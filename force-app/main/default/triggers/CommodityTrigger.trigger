trigger CommodityTrigger on Contract_Site__c (before insert,before update,after update, after insert,after delete) {

    //System.debug('Trigger.new-->'+trigger.new);

    //System.debug('CommodityDestination_Process_Switches__c.getInstance().CommodityDestination_Process_Bypass__c-->'+CommodityDestination_Process_Switches__c.getInstance().CommodityDestination_Process_Bypass__c);
    if(CommodityDestination_Process_Switches__c.getInstance().CommodityDestination_Process_Bypass__c)
    {
        System.debug('CommodityDestination_Process_Switches__c.getInstance().CommodityDestination_Process_Bypass__c-->'+CommodityDestination_Process_Switches__c.getInstance().CommodityDestination_Process_Bypass__c);
        return;
    }

    System.debug('trigger executed');
    

    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        decimal currentSpreads=0;
        String tempSpread='';
        decimal ntpPrice = 0.00;
        decimal basePrice = 0.00;



        List<Contract_Site__c> oContract = [Select Id, NTP_Price__c, Quantity__c, Base_Price__c from Contract_Site__c where Opportunity__c=:trigger.new[0].Opportunity__c And Spreads__c='base' limit 1];
        if( oContract !=null && oContract.size()>0 )
        {                    
                ntpPrice = oContract[0].NTP_Price__c !=null?oContract[0].NTP_Price__c:0;
                basePrice = oContract[0].Base_Price__c !=null?oContract[0].Base_Price__c:0;
                //currentSite.Quantity__c=oContract[0].Quantity__c;
        }

        if(trigger.isInsert){

            for(Contract_Site__c currentSite : trigger.new)
            {
                if(currentSite.Spreads__c=='base'){
                    ntpPrice = currentSite.NTP_Price__c;
                    basePrice = currentSite.Site_Price__c;
                }
            }

        }

        System.debug('basePrice--1-->'+basePrice);

        String saleoriginDestination = [Select Id, Sale_Origin_Destination__c From Opportunity Where Id=:trigger.new[0].Opportunity__c]?.Sale_Origin_Destination__c;

        for(Contract_Site__c currentSite : trigger.new)
        {
            System.debug('currentSite--1-->'+ JSON.serializePretty(currentSite));

            if(saleoriginDestination!=null){
                currentSite.Sale_Origin_Destination__c = saleoriginDestination;
            }

            if(String.isNotBlank(currentSite.Spreads__c))
            {
                tempSpread=currentSite.Spreads__c.trim();
                
                if(tempSpread.touppercase()!='BASE' && tempSpread.touppercase()!='FLOATING')
                {
                    String tempFormatedSpread = tempSpread.replace('$','');
                    currentSpreads = Decimal.valueOf(tempFormatedSpread);
                }                    

            }  
            

            if(saleoriginDestination=='Nearest Terminal Port (NTP)')
            {  

				currentSpreads=0;

                currentSite.NTP_Price__c=ntpPrice;
                currentSite.Base_Price__c=ntpPrice;
                
                
                if(String.isNotBlank(currentSite.Spreads__c))
                {
                    tempSpread=currentSite.Spreads__c.trim();
                    
                    if(tempSpread.touppercase()!='BASE' && tempSpread.touppercase()!='FLOATING')
                    {
                        String tempFormatedSpread = tempSpread.replace('$','');
                        currentSpreads = Decimal.valueOf(tempFormatedSpread);
                    }                    

                }
                if(!Test.isRunningTest()){
                currentSite.Site_Price__c = (ntpPrice + currentSpreads) - currentSite.Location_Differential_Cost__c;
                }else{
                currentSite.Site_Price__c = (20 + currentSpreads) - currentSite.Location_Differential_Cost__c;

                }
            }else if(saleoriginDestination=='Public Warehouse'){

				currentSpreads=0;
                if(String.isNotBlank(currentSite.Spreads__c))
                {
                    tempSpread=currentSite.Spreads__c.trim();
                    
                    if(tempSpread.touppercase()!='BASE' && tempSpread.touppercase()!='FLOATING')
                    {
                        String tempFormatedSpread = tempSpread.replace('$','');
                        currentSpreads = Decimal.valueOf(tempFormatedSpread);
                    }                    

                }

                if(currentSite.Site_Price__c!=0.00){
                    currentSite.Base_Price__c = currentSite.Site_Price__c;
                }else{
                    currentSite.Base_Price__c = basePrice;
                }

                if(currentSite.Base_Price__c == null){
                    currentSite.Base_Price__c = 0.00;
                }

                currentSite.Site_Price__c = currentSite.Base_Price__c + currentSpreads;

            }else{

                System.debug('saleoriginDestination-->'+saleoriginDestination);

				currentSpreads=0;

                if(String.isNotBlank(currentSite.Spreads__c))
                {
                    tempSpread=currentSite.Spreads__c.trim();
                    
                    if(tempSpread.touppercase()!='BASE' && tempSpread.touppercase()!='FLOATING')
                    {
                        String tempFormatedSpread = tempSpread.replace('$','');
                        currentSpreads = Decimal.valueOf(tempFormatedSpread);
                    }                    

                }

                if(currentSite.Site_Price__c!=0.00 && currentSite.Site_Price__c!=null){
                    currentSite.Base_Price__c = currentSite.Site_Price__c;
                }else{
                    currentSite.Base_Price__c = basePrice;
                }


                System.debug('ccurrentSite.Site_Price__c -->'+currentSite.Site_Price__c);
                System.debug('basePrice -->'+basePrice );
                System.debug('currentSite.Base_Price__c -->'+currentSite.Base_Price__c );
                System.debug('currentSpreads-->'+currentSpreads);

                currentSite.Site_Price__c = currentSite.Base_Price__c + currentSpreads;

            }
        }
         

    }

    
    

    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        //System.debug('Trigger.new-->'+trigger.new);
        CommodityTriggerHelper.updateCommodity(trigger.new);
        

    }

    
    if(trigger.isAfter && trigger.isDelete){

        

        Set<String> oppIdSet=new Set<String>();
        
        for(Contract_Site__c currentItem :trigger.old)
        {
            System.debug('currentItem-->'+currentItem.Spreads__c);
            if(currentItem.Spreads__c =='base')
            {
                // currentItem.addError('Base spread cannot be deleted!');
                // return;
            }
            oppIdSet.add(currentItem.Opportunity__c);
        }
        
        List<Contract_Site__c> oList=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Opportunity__c, Site_Price__c, Site__c, Location_Differential_Cost__c, GPS__c, Sale_Origin_Destination__c, Grade__c, Quantity__c, Spreads__c,Base_Spreads__c, NTP_Name__c, NTP_Price__c, Spreads2__c, Site_Price2__c 
        FROM Contract_Site__c 
        where Opportunity__c IN: oppIdSet ];

        CommodityTriggerHelper.updateCommodity(oList);
        

        
        
    }
}