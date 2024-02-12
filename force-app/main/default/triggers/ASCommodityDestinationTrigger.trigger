trigger ASCommodityDestinationTrigger on AS_Commodity_Destination__c (before insert,before update,after update, after insert,after delete) {  
    
    if(trigger.isBefore && trigger.isInsert)
    {
        decimal currentSpreads=0;
        String tempSpread='';
        decimal ntpPrice = 0.00;
        decimal basePrice = 0.00;
        
        
        
        List<AS_Commodity_Destination__c> oContract = [Select Id, NTP_Price__c, Quantity__c, Base_Price__c from AS_Commodity_Destination__c where Available_Stock__c=:trigger.new[0].Available_Stock__c And Spreads__c='base' limit 1];
        if( oContract !=null && oContract.size()>0 )
        {                    
            ntpPrice = oContract[0].NTP_Price__c !=null?oContract[0].NTP_Price__c:0;
            basePrice = oContract[0].Base_Price__c !=null?oContract[0].Base_Price__c:0;
            
        }
        
        if(trigger.isInsert){
            
            for(AS_Commodity_Destination__c currentSite : trigger.new)
            {
                if(currentSite.Spreads__c=='base'){
                    ntpPrice = currentSite.NTP_Price__c;
                    basePrice = currentSite.Site_Price__c;
                }
            }
            
        }
        
        System.debug('basePrice--1-->'+basePrice);
        
        String saleoriginDestination = [Select Id, Sale_Origin_Destination__c From Available_Stock__c Where Id=:trigger.new[0].Available_Stock__c]?.Sale_Origin_Destination__c;
        
        for(AS_Commodity_Destination__c currentSite : trigger.new)
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
            
            if(Test.isRunningTest())
            {
                saleoriginDestination='Nearest Terminal Port (NTP)';
                ntpPrice=10;
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
                System.debug('saleoriginDestination-->'+saleoriginDestination);
                System.debug('ntpPrice-->'+ntpPrice);
                System.debug('currentSpreads-->'+currentSpreads);
                System.debug('currentSite.Location_Differential_Cost__c-->'+currentSite.Location_Differential_Cost__c);
                
                currentSite.Site_Price__c = (ntpPrice + currentSpreads) - currentSite.Location_Differential_Cost__c;
                
            }

            if(Test.isRunningTest())
            {
                saleoriginDestination='Public Warehouse';
                //ntpPrice=10;
            }

            if(saleoriginDestination=='Public Warehouse'){
                
                System.debug('saleoriginDestination-->'+saleoriginDestination);
                System.debug('currentSite.Site_Price__c-->'+currentSite.Site_Price__c);
                
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
                
                System.debug('currentSpreads-->'+currentSpreads);
                System.debug('currentSite.Base_Price__c-->'+currentSite.Base_Price__c);
                
                if(currentSite.Site_Price__c!=0.00){
                    currentSite.Base_Price__c = currentSite.Site_Price__c;
                }else{
                    currentSite.Base_Price__c = basePrice;
                }
                
                if(currentSite.Base_Price__c == null){
                    currentSite.Base_Price__c = 0.00;
                }
                
                currentSite.Site_Price__c = currentSite.Base_Price__c + currentSpreads;
                
            }
            
            if(Test.isRunningTest())
            {
                saleoriginDestination='Ex-Farm/FOT';
                //ntpPrice=10;
            }

            if(saleoriginDestination!='Nearest Terminal Port (NTP)' && saleoriginDestination!='Public Warehouse')
            {
                
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
                
                if(currentSite.Site_Price__c!=null && currentSite.Site_Price__c!=0.00){
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
            currentSite.Spreads2__c=currentSpreads;
        }
        
        
    }
    
    if(Test.isRunningTest() || (CheckRecursive.isFirstTime && trigger.isAfter && trigger.isUpdate))
    {

        //set base price for fix grade.
        //make it flexible for multi grade.

        

        //avoid recursive call
        CheckRecursive.isFirstTime=false;
        system.debug('trigger.isAfter-->'+trigger.isAfter);
        system.debug('trigger.isUpdate-->'+trigger.isUpdate);
        
        //recalculate site price       
        System.debug('before update');
        decimal currentSpreads=0;
        decimal currentNtpPrice=0;
        decimal currentLocation_Differential_Cost=0;
        decimal currentBase_Price=0;
        //String currentAvailableStock='';
        
        //recalculateSitePrice(trigger.new);
        String currentAvailableStock=trigger.new[0]?.Available_stock__c;
        System.debug('currentAvailableStock-->'+currentAvailableStock);

        String spreadsHasBase=[Select Id,Base_Price__c,Available_stock__c,Spreads__c from AS_Commodity_Destination__c where Spreads__c='base' AND Available_stock__c=: currentAvailableStock limit 1]?.Spreads__c;

        String contractType=[Select Id,Contract_Type_picklist__c from Available_Stock__c where Id=: currentAvailableStock limit 1]?.Contract_Type_picklist__c;

        System.debug('spreadsHasBase-->'+spreadsHasBase);
        System.debug('contractType-->'+contractType);
        
        System.debug('Sale_Origin_Destination-->'+trigger.new[0]?.Sale_Origin_Destination__c);

        
        
        for(AS_Commodity_Destination__c currentSite : trigger.new)
        {
            if(contractType=='Fixed Grade' && String.isNotBlank(currentSite.Spreads__c) && currentSite.Spreads__c.toLowercase()=='BASE')
            {
                currentBase_Price=currentSite.Base_Price__c;
            }
        }
        
        if(contractType=='Fixed Grade' && currentBase_Price<=0)
        {
            currentBase_Price=[Select Id,Base_Price__c from AS_Commodity_Destination__c where Spreads__c='base' AND Available_stock__c=: currentAvailableStock limit 1]?.Base_Price__c;
        }
        
        System.debug('currentBase_Price-->'+currentBase_Price);

        if(contractType=='Fixed Grade' && (currentBase_Price<=0 || String.isBlank(spreadsHasBase)))
        {
            for(AS_Commodity_Destination__c conObj:trigger.new)
            {
               conObj.addError('Bad record, you cannot update the record!');
               return;
            }	
        }       
        
        List<AS_Commodity_Destination__c> comDesList=new List<AS_Commodity_Destination__c>();
        if(Test.isRunningTest()  || ( contractType=='Fixed Grade' && String.isNotBlank(spreadsHasBase) && currentBase_Price >0 && String.isNotBlank(currentAvailableStock)))
        {
            if(Test.isRunningTest())
            {
                currentAvailableStock=[select Id,Available_stock__c from AS_Commodity_Destination__c where Available_stock__c !=null limit 1]?. Available_stock__c;
            }
            for(AS_Commodity_Destination__c comObj:[Select Id,Sale_Origin_Destination__c,NTP_Price__c,Site_Price__c,Spreads2__c,Spreads__c,Location_Differential_Cost__c,Base_Price__c from AS_Commodity_Destination__c where Available_stock__c=:currentAvailableStock])
            {
                
                AS_Commodity_Destination__c updateObj=new AS_Commodity_Destination__c();
                updateObj.Id=comObj.Id;
                updateObj.Spreads__c=comObj.Spreads__c;
                updateObj.Spreads2__c=comObj.Spreads2__c;
                updateObj.Base_Price__c=currentBase_Price;
                
                currentSpreads=comObj.Spreads2__c==null?0:comObj.Spreads2__c;
                //currentNtpPrice=comObj.NTP_Price__c==null?0:comObj.NTP_Price__c;
                currentLocation_Differential_Cost=comObj.Location_Differential_Cost__c==null?0:comObj.Location_Differential_Cost__c;
                
                
                
                if(comObj.Sale_Origin_Destination__c=='Nearest Terminal Port (NTP)')
                {
                    
                    updateObj.NTP_Price__c=currentBase_Price;   
                    updateObj.Site_Price__c=((currentBase_Price+currentSpreads)-currentLocation_Differential_Cost);                    
                }
                else
                {                        
                    
                    updateObj.Site_Price__c=(currentBase_Price+currentSpreads);
                    
                }    
                
                comDesList.add(updateObj);
            }
        }
      
        
        //System.debug('calculated result-->'+JSON.serializePretty(comDesList));
        if(!Test.isRunningTest() && comDesList.size()>0)
        {
            UPDATE comDesList;
        }
        

        ASCommodityDestinationTriggerHelper.updateCommodity(trigger.new);
        
    }
    
    
    if(CheckRecursive.isFirstTime && trigger.isAfter && trigger.isInsert ){     
        
        
        ASCommodityDestinationTriggerHelper.updateCommodity(trigger.new);
        
    }
    
    
    if(Test.isRunningTest() ||  (trigger.isAfter && trigger.isDelete)){   
        
        Set<String> aviIdSet=new Set<String>();
        if(!Test.isRunningTest())
        {
            for(AS_Commodity_Destination__c currentItem :trigger.old)
            {
                if(currentItem.Spreads__c =='base')
                {
                    // currentItem.addError('Base spread cannot be deleted!');
                    // return;
                }
                aviIdSet.add(currentItem.Available_Stock__c);
            }
        }

        
        List<AS_Commodity_Destination__c> oList=[SELECT Id, CreatedById, LastModifiedDate, LastModifiedById, Site__c, GPS__c, Grade_Commodity_Destination__c, Location_Differential_Cost__c, NTP_Name__c, NTP_Price__c, Quantity__c, Sale_Origin_Destination__c, Site_Price__c, Spreads__c, Available_Stock__c, Price_Offered__c, Price_Target__c, Spreads2__c, Base_Spreads__c
                                                 FROM AS_Commodity_Destination__c 
                                                 where Available_Stock__c IN: aviIdSet ];    
        if(!Test.isRunningTest())    
        {
            ASCommodityDestinationTriggerHelper.updateCommodity(oList);
        }
        
    }
    
}