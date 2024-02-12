public without sharing class ASCommodityDestinationTriggerHelper {
    public static void updateCommodity(List<AS_Commodity_Destination__c> conList) {
        
        Set<Id> aStockIds = new Set<Id>();
        Set<Id> quantity = new Set<Id>();
        Map<Id, Decimal> totalQuantityMap = new Map<Id, Decimal>();
        Map<Id, Decimal> stockContractUnitPrice = new Map<Id, Decimal>();
        List<Available_Stock__c> aStockToBeUpdated = new List<Available_Stock__c>();
        Set<String> grade = new Set<String>();
        
        Map<String, String> contractSiteSpreadMap = new Map<String, String>();
        Map<String, List<String>> contractAstockMap = new Map<String, List<String>>();
        
        for(AS_Commodity_Destination__c con : conList){
            
            aStockIds.add(con.Available_Stock__c);
            
        }
        
        //Used to set ContractUnitPrice value. When GradeSpread has many items then ContractUnitPrice = 0
        for(Available_Stock__c asObj:[Select Id,Price_Offered__c,Price_Target__c,Contract_Price_per_Unit__c from Available_Stock__c where Id IN:aStockIds])
        {
            stockContractUnitPrice.put(asObj.Id,asObj.Contract_Price_per_Unit__c);
            
        }
        
        String gradeSpreadStr = '';
        String gradeStr = '';
        //String gradeSpreads='';
        Integer newLineCounter=0;
        Decimal contractPriceperUnit=0;
        Decimal currentNTPPrice=0;
        
        Set<String> gradeSpreadSet=new Set<String>();
        Set<String> gradeSet=new Set<String>();
        
        for(AS_Commodity_Destination__c contr : [Select Id, Available_Stock__c,Available_Stock__r.Contract_Type_picklist__c, Quantity__c, Grade_Commodity_Destination__c, Spreads__c,Price_Offered__c,Price_Target__c From AS_Commodity_Destination__c Where Available_Stock__c IN :aStockIds])
        {
            
            if(contr.Quantity__c==null){
                contr.Quantity__c = 0.00;
            }
            
            if(!totalQuantityMap.containsKey(contr.Available_Stock__c)){
                totalQuantityMap.put(contr.Available_Stock__c, 0.00);
            }
            
            totalQuantityMap.put(contr.Available_Stock__c, totalQuantityMap.get(contr.Available_Stock__c)+contr.Quantity__c);
            
            System.debug('contr.Available_Stock__c-->'+contr.Available_Stock__c);
            System.debug('contr.Available_Stock__r.Contract_Type_picklist__c-->'+contr.Available_Stock__r.Contract_Type_picklist__c);
            
            if(contr.Available_Stock__r.Contract_Type_picklist__c=='Fixed Grade')
            {
                // 
                if(contr.Grade_Commodity_Destination__c !=null)
                {
                    gradeSet.add(contr.Grade_Commodity_Destination__c);
                }

                
                gradeSpreadSet.add('N/A');
                
            }
            else{
                if(contr.Spreads__c=='base'){
                    if(contr.Grade_Commodity_Destination__c !=null)
                    {
                        gradeStr = contr.Grade_Commodity_Destination__c;
                    }
                    
                }else{
                    //gradeSpreadStr += contr.Grade__c+' '+(contr.Spreads__c==null?'':contr.Spreads__c)+'\n';
                    gradeSpreadSet.add((contr.Grade_Commodity_Destination__c ==null?'':contr.Grade_Commodity_Destination__c)+' '+(contr.Spreads__c==null?'':contr.Spreads__c));
                }
            }
        }
        
        for(String st:gradeSet)
        {
            gradeStr+=st+';';
        }
        for(String st:gradeSpreadSet)
        {           
            gradeSpreadStr+=st+'\n';
        }
        
        // contractSiteSpreadMap.put(contr.Id,gradeSpreads);                    
        //}
        Decimal ntpPriceOffered=0;
        Decimal ntpPriceTarget=0;
        String ntpBaseSpread='';
        Integer index=0;
        Integer counter=0;
        
        for(AS_Commodity_Destination__c currentSite:conList)
        {
            if((currentSite.Price_Offered__c !=null || currentSite.Price_Target__c !=null) && (currentSite.Price_Offered__c >0 || currentSite.Price_Target__c >0 ))
            {
                ntpPriceOffered=currentSite.Price_Offered__c;
                ntpPriceTarget=currentSite.Price_Target__c;
                index=counter;
                break;
            }
            counter++;
        }
        
        System.debug('gradeStr-->'+gradeStr);
        System.debug('gradeSpreadStr-->'+gradeSpreadStr);
        
        for(String oppId : aStockIds){
            
            System.debug('aStockIds-->'+aStockIds);
            System.debug('aStockToBeUpdated-->'+aStockToBeUpdated);
            
            //if(conList[index].NTP_Price__c != null && conList[index].NTP_Price__c>0)
            System.debug('conList[index]-->'+conList[index].Base_Spreads__c );
            System.debug('conList[index]-->'+conList[index].Price_Offered__c );
            System.debug('conList[index]-->'+conList[index].Price_Target__c );

            System.debug('ntpPriceOffered-->'+ntpPriceOffered );
            System.debug('ntpPriceTarget-->'+ntpPriceTarget );
            if(ntpPriceOffered>0 || ntpPriceTarget>0)
            {
                System.debug('ntpPriceOffered-->'+ntpPriceOffered);
                System.debug('ntpPriceTarget-->'+ntpPriceTarget);
                aStockToBeUpdated.add(new Available_Stock__c (Id=oppId, Quantity__c=totalQuantityMap.get(oppId), Grade2__c=gradeStr, Grade_Spreads__c=gradeSpreadStr,Price_Offered__c=conList[index].Price_Offered__c,Price_Target__c=conList[index].Price_Target__c,Spreads__c=conList[index].Base_Spreads__c));
            }
            else
            {
                aStockToBeUpdated.add(new Available_Stock__c (Id=oppId, Quantity__c=totalQuantityMap.get(oppId), Grade2__c=gradeStr, Grade_Spreads__c=gradeSpreadStr,Contract_Price_per_Unit__c=contractPriceperUnit));
            }
            
        }
        if(!aStockToBeUpdated.isEmpty())
        {
            System.debug('aStockToBeUpdated-->'+aStockToBeUpdated);
            update aStockToBeUpdated;
        }
        
    }
    
    
}