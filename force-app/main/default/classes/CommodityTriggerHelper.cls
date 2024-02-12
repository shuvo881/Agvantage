public without sharing class CommodityTriggerHelper {
    
    public static void updateCommodity( List<Contract_Site__c>  conList) {
        
        Set<Id> oppIds = new Set<Id>();
        Set<Id> quantity = new Set<Id>();
        Map<Id, Decimal> totalQuantityMap = new Map<Id, Decimal>();
        Map<Id, Decimal> oppContractUnitPrice = new Map<Id, Decimal>();
        List<Opportunity> oppToBeUpdated = new List<Opportunity>();
        Set<String> grade = new Set<String>();
        
        Map<String, String> contractSiteSpreadMap = new Map<String, String>();
        Map<String, List<String>> contractOppotunityMap = new Map<String, List<String>>();
        
        for(Contract_Site__c con : conList){
            
            oppIds.add(con.Opportunity__c);
            
        }      
        
        // for(Opportunity opp:[Select Id,Price__c from Opportunity where Id IN:oppIds ])
        // {
        //     oppContractUnitPrice.put(opp.Id, opp.Price__c);
        // }

        //get commodity destination base site_price field value.
        Decimal contractPriceperUnit=0; // is null
		for(Contract_Site__c record: [SELECT Id,Site_Price__c FROM Contract_Site__c WHERE Opportunity__c IN:oppIds AND Spreads__c = 'base' LIMIT 1]) {
		  contractPriceperUnit = record.Site_Price__c;
		}

        
        String gradeSpreadStr = '';
        String gradeStr = '';
        Integer newLineCounter=0;
        //Decimal contractPriceperUnit=0;
        
        Set<String> gradeSpreadSet=new Set<String>();
        Set<String> gradeSet=new Set<String>();
        
        for(Contract_Site__c contr : [Select Id,Opportunity__c,Opportunity__r.Contract_Type__c, Quantity__c, Grade__c, Spreads__c From Contract_Site__c Where Opportunity__c IN :oppIds])
        {
            
            //System.debug('contr-->'+contr);
            
            if(contr.Quantity__c==null){
                contr.Quantity__c = 0.00;
            }
            
            if(!totalQuantityMap.containsKey(contr.Opportunity__c)){
                totalQuantityMap.put(contr.Opportunity__c, 0.00);
            }
            
            totalQuantityMap.put(contr.Opportunity__c, totalQuantityMap.get(contr.Opportunity__c)+contr.Quantity__c);
            
            if(contr.Opportunity__r.Contract_Type__c=='Fixed Grade'){
                
                if(contr.Grade__c != null)
                {
                    gradeSet.add(contr.Grade__c);    
                }
                
                //gradeStr += contr.Grade__c+';';
                //gradeSpreadStr = 'N/A';
                gradeSpreadSet.add('N/A');
            }else{
                if(contr.Spreads__c=='base'){
                    if(contr.Grade__c != null)
                    {
                        gradeStr = contr.Grade__c;
                    }
                    
                }else{
                    //gradeSpreadStr += contr.Grade__c+' '+(contr.Spreads__c==null?'':contr.Spreads__c)+'\n';
                    gradeSpreadSet.add((contr.Grade__c ==null?'':contr.Grade__c)+' '+(contr.Spreads__c==null?'':contr.Spreads__c));
                }
            }
            
            
            
        }
        
        //Duplicate issue on Grade and spread entries
        for(String st:gradeSet)
        {
            gradeStr+=st+';';
        }
        for(String st:gradeSpreadSet)
        {
            gradeSpreadStr+=st+'\n';
        }
        
        Decimal ntpPrice=0;
        String ntpBaseSpread='';
        Integer index=0;
        Integer counter=0;
        for(Contract_Site__c currentSite:conList)
        {
            if(currentSite.NTP_Price__c !=null && currentSite.NTP_Price__c>0)
            {
                ntpPrice=currentSite.NTP_Price__c;
                index=counter;
                break;
            }
            counter++;
        }
        
        for(String oppId : oppIds){
            
            if(conList[index].NTP_Price__c != null && conList[index].NTP_Price__c>0)
            {
                oppToBeUpdated.add(new Opportunity(Id=oppId, Contract_Quantity__c=totalQuantityMap.get(oppId), Grade__c=gradeStr, Grade_Spreads__c=gradeSpreadStr,Price__c=conList[index].Site_Price__c,Spreads__c=conList[index].Base_Spreads__c));
            }
            else
            {
                oppToBeUpdated.add(new Opportunity(Id=oppId, Contract_Quantity__c=totalQuantityMap.get(oppId), Grade__c=gradeStr, Grade_Spreads__c=gradeSpreadStr,Price__c=contractPriceperUnit));
            }
            
        }
        
        
        
        if(!oppToBeUpdated.isEmpty())
        {
            System.debug('oppToBeUpdated-->'+JSON.serializePretty(oppToBeUpdated));
            update oppToBeUpdated;
        }
        
        
    }
    
}