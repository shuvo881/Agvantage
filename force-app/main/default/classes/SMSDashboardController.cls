public with sharing class SMSDashboardController {   


        @AuraEnabled(cacheable=true)
        public static List<bid__c> getAllData(String rand) {
    

            List<Bid__c> groupedBids = new List<Bid__c>();

            List<bid__c> bids = [SELECT Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c, Delivery_Start_Date__c, Delivery_Start__c,Delivery_End__c,  Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null AND Default_Date__c=TODAY ORDER BY Site__r.Name, Commodity__c, Crop_Year__c, Price__c DESC];


            Map<String, bid__c> bidMap = new Map<String, bid__c>();
    
            for(bid__c b : bids){
    
                String siteCombo = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c;
                if(bidMap.get(siteCombo)==null){
                    bidMap.put(siteCombo, new bid__c(Price__c=0));
                }
    
    
                if(b.Price__c > bidMap.get(siteCombo).Price__c){
                    bidMap.put(siteCombo, b);
                }
    
            }
    
            // get previous bids

            List<bid__c> bidsPriorList = [SELECT Id, Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c, Delivery_Start_Date__c,Delivery_Start__c,Delivery_End__c, Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null AND Default_Date__c<TODAY AND Default_Date__c=LAST_N_DAYS:10 ORDER BY Default_Date__c ASC, Price__c ASC Limit 50000];

            Map<String, bid__c> oldBidMap = new Map<String, bid__c>();
    
            for(bid__c b : bidsPriorList){
                oldBidMap.put(b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c, b);
            }

        
            for(Bid__c b : bidMap.values()){

                b.Price_Change__c = '$0.00';

                String siteCombo2 = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c;
                
                
                if(oldBidMap.get(siteCombo2)!=null){

                    if((b.Price__c - oldBidMap.get(siteCombo2).Price__c)<0)
                    {
                        b.Price_Change__c = '-$'+ (oldBidMap.get(siteCombo2).Price__c - b.Price__c )+'';
                    } else {
                        b.Price_Change__c = '+$'+(b.Price__c - oldBidMap.get(siteCombo2).Price__c)+'';
                    } 
                
                }

                groupedBids.add(b);

            }


            // return updatedBidList;
            return groupedBids;
        }
    
        @AuraEnabled
    public static void updateExludedData(String recordId, String rand) {

        System.debug('recordId-->'+recordId);

        Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Buyer_Name__c  From Bid__c Where Id=:recordId Limit 1];

        List<Bid__c> bidList = [Select Id, Is_Excluded__c From Bid__c Where Buyer_Name__c=:bidDetail.Buyer_Name__c AND  Site__c=:bidDetail.Site__c And Commodity__c=:bidDetail.Commodity__c And Grade__c=:bidDetail.Grade__c];

        for(Bid__c bid : bidList){
            bid.Is_Excluded__c = true;
        }

        update bidList;


    }

        @AuraEnabled
        public static void insertBidIdsToCustomSettingsApex(String bidIds) {
            System.debug('bidIds: ' + bidIds);
        
            List<String> bidIdList = (List<String>) JSON.deserialize(bidIds, List<String>.class);
    
            delete [Select Id From Bid_Ids_For_SMS__c];
            
            List<Bid_Ids_For_SMS__c> bidIdListToInsert = new List<Bid_Ids_For_SMS__c>();
    
            for(String bidId : bidIdList){
                bidIdListToInsert.add(new Bid_Ids_For_SMS__c(Name=bidId));
            }
    
            if (!bidIdListToInsert.isEmpty()) {
                insert bidIdListToInsert;
            }
        }
    
        @AuraEnabled(cacheable=true)
        public static String getContactListViewsApex(String rand) {
            List<wrapperClass> pickListLines = new List<wrapperClass>();
            for(ListView_Query__c lq : [Select Id, ListView_Id__c, Name From ListView_Query__c ORDER BY Name ASC]){
                wrapperClass wc = new wrapperClass();
                wc.label = lq.Name;
                wc.value = lq.ListView_Id__c;
                wc.selected = false;
                pickListLines.add(wc);
            }
            return JSON.serialize(pickListLines);
        }
    
        
        // @AuraEnabled
        // public static void insertDataToCAllBid(String bidId) {
        //    System.debug('bidId'+ bidId);
        //     //delete [Select Id From Get_All_Bid_Id__c];
        //     Get_All_Bid_Id__c CBid = new Get_All_Bid_Id__c(); 
        //     CBid.Bid_Id__c =String.valueof(bidId) ;        
        //     CBid.Name = bidId;        
        //     // Insert the custom setting record
        //     update CBid;
        // }
    
    
        public static List<Schema.PicklistEntry> getPickListOptions(String objName, String fieldName) {
    
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
    
            Schema.DescribeSObjectResult describeResult = objType.getDescribe();
            Schema.DescribeFieldResult picklistField = describeResult.fields.getMap().get(fieldName).getDescribe();
            
            List<Schema.PicklistEntry> picklistEntries = picklistField.getPicklistValues();
    
            return picklistEntries;
        }

        public static List<Schema.PicklistEntry> getPickListOptionsCott(String objName, String fieldName) {
    
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
    
            Schema.DescribeSObjectResult describeResult = objType.getDescribe();
            Schema.DescribeFieldResult picklistField = describeResult.fields.getMap().get(fieldName).getDescribe();
            
            List<Schema.PicklistEntry> picklistEntries = picklistField.getPicklistValues();
            List<Schema.PicklistEntry> picklistEntries1 = new List<Schema.PicklistEntry>();
            if (fieldName == 'Sale_Origin_Destination__c') {
                return picklistEntries;                
            }
            for (Schema.PicklistEntry CottPic : picklistEntries) {

                    if(CottPic.getValue().contains('Cotton - Lint') ){
                        picklistEntries1.add(CottPic);
                    }
                    else if(CottPic.getValue().contains('Cotton Lint') ){
                        picklistEntries1.add(CottPic);
                    }               
                
            }
    
            return picklistEntries1;
        }
    
    
    
        @AuraEnabled(cacheable=true)
        public static String getSinglePicklistOptions(String objName, String fieldName) {
    
    
                List<wrapperClass> pickListLines = new List<wrapperClass>();
    
                for(PicklistEntry pe : getPickListOptions(objName, fieldName)){
    
                    wrapperClass wc = new wrapperClass();
                    wc.label = pe.getLabel();
                    wc.value = pe.getValue();
                    wc.selected = false;
    
                    pickListLines.add(wc);
    
                }
    
            return JSON.serialize(pickListLines);
            
        }
     @AuraEnabled(cacheable=true)
        public static String getConverseTemplates(String rand) {
    
    
                List<wrapperClass> templates = new List<wrapperClass>();
                List<smagicinteract__SMS_Template__c> templateList = [SELECT Id, Name, smagicinteract__Name__c, smagicinteract__Text__c, For_SMS_Dashboard__c FROM smagicinteract__SMS_Template__c WHERE For_SMS_Dashboard__c = true];

                for(smagicinteract__SMS_Template__c tmp : templateList){
    
                    wrapperClass wc = new wrapperClass();
                    wc.label = tmp.smagicinteract__Name__c;
                    wc.value = tmp.smagicinteract__Text__c;
                    wc.selected = false;
    
                    templates.add(wc);
    
                }
    
            return JSON.serialize(templates);
            
        }
        @AuraEnabled(cacheable = true)
        public static List<Contact> getContactListViewDataApex( String contactListViewId, String rand ) {
    
            List<ListView_Query__c> dataList = [SELECT Id, ListView_Query_Scrip__c, Name FROM ListView_Query__c WHERE ListView_Id__c  = :contactListViewId];
            
            List<Contact> contactList = new List<Contact>();
            
            if(!dataList.isEmpty()){
    
                String listViewScript = dataList[0].ListView_Query_Scrip__c;
    
                String[] substrings = listViewScript.split('WHERE');
    
                System.debug('substrings = '+substrings);
    
    
                
                if(dataList[0].Name=='Recently Viewed Contacts' || dataList[0].Name=='My Contacts' || dataList[0].Name=='All Contacts'){
                    contactList = Database.query(dataList[0].ListView_Query_Scrip__c);
                }else{
    
                    String Querystr = 'SELECT Id, LastName, Name, Mobile_Work__c, ID_Status__c,Cotton_Valley_Regions__c, Priority__c, Phone,Email,Farming_Regions__c  FROM Contact WHERE '+ substrings[1];
                    contactList = Database.query(Querystr);
                }
                
            }
    
            return contactList;
            
        }
    
        @AuraEnabled(cacheable = true)
        public static List<bid__c> getSmsData(String randomNumber) {
    
            Set<String> bidIds = new Set<String>();
    
            for(Bid_Ids_For_SMS__c b : [SELECT Id, Name FROM Bid_Ids_For_SMS__c]){
                bidIds.add(b.Name);
            }
    
            List<bid__c> bids = [SELECT Name, Commodity_Short_Name__c, Grade_Short_Name__c, Site__r.Site_Short_Name__c, Price_Tag_Name__c, Site__r.Sale_Origin_Destination2__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Commodity__c, Default_Date_Time__c, Grade__c, Crop_Year__c, Price__c FROM bid__c   where Id IN:bidIds ORDER BY Site__r.Name, Commodity__c, Crop_Year__c, Price__c DESC];
    
    
            return bids;
            // return bids;
        }

     @AuraEnabled(cacheable = true)
        public static List<String> getOrderMarketRegion(String randomNumber) {
                List<Market_Region_Order__c> marketRegions = [SELECT Name FROM Market_Region_Order__c ORDER BY Order_No__c];
                List<String> marketnames=new List<String>();
                for(Market_Region_Order__c m:marketRegions)
                {
                    marketnames.add(m.Name);
                }
           
            return marketnames;
            // return bids;
        }
    
        @AuraEnabled(cacheable=true)
        public static String getAllPickListOptions(String pickListNames) {
            System.debug('pickListNames: ' + pickListNames);
    
            List<String> plNames = (List<String>) JSON.deserialize(pickListNames, List<String>.class);
    
            Map<String, List<wrapperClass>> pickListData = new Map<String, List<wrapperClass>>();
    
            for(String p : plNames){
    
                List<wrapperClass> pickListLines = new List<wrapperClass>();
    
                for(PicklistEntry pe : getPickListOptions('Bid__c', p)){
    
                    wrapperClass wc = new wrapperClass();
                    wc.label = pe.getLabel();
                    wc.value = pe.getValue();
                    wc.selected = false;
    
    
                    pickListLines.add(wc);
    
                }
    
                pickListData.put(p, pickListLines);
    
            }
    
    
    
            Map<String, List<String>> dependantPicklistMap = getFieldDependencies('bid__c', 'Commodity__c', 'Grade__c');
    
    
            for(String p : dependantPicklistMap.keySet()){
    
                if(dependantPicklistMap.get(p).size()>0){
    
                    List<wrapperClass> dependantPickListLines = new List<wrapperClass>();
    
    
                    for(String option : dependantPicklistMap.get(p)){
                        wrapperClass wc2 = new wrapperClass();
                        wc2.label = option;
                        wc2.value = option;
                        wc2.selected = false;
        
        
                        dependantPickListLines.add(wc2);
                    }
        
                    pickListData.put(p, dependantPickListLines);
                }
    
    
    
            }
    
    
            return JSON.serialize(pickListData);
            
        }


        // For Cotton Retrieve

        @AuraEnabled(cacheable=true)
        public static String getAllPickListOptions1(String pickListNames) {
            System.debug('pickListNames: ' + pickListNames);
    
            List<String> plNames = (List<String>) JSON.deserialize(pickListNames, List<String>.class);
    
            Map<String, List<wrapperClass>> pickListData = new Map<String, List<wrapperClass>>();
    
            for(String p : plNames){
    
                List<wrapperClass> pickListLines = new List<wrapperClass>();
    
                for(PicklistEntry pe : getPickListOptionsCott('Bid__c', p)){
    
                    wrapperClass wc = new wrapperClass();
                    wc.label = pe.getLabel();
                    wc.value = pe.getValue();
                    wc.selected = false;
    
    
                    pickListLines.add(wc);
    
                }
    
                pickListData.put(p, pickListLines);
    
            }
    
    
    
            Map<String, List<String>> dependantPicklistMap = getFieldDependencies('bid__c', 'Commodity__c', 'Grade__c');
    
    
            for(String p : dependantPicklistMap.keySet()){
    
                if(dependantPicklistMap.get(p).size()>0){
    
                    List<wrapperClass> dependantPickListLines = new List<wrapperClass>();
    
    
                    for(String option : dependantPicklistMap.get(p)){
                        wrapperClass wc2 = new wrapperClass();
                        wc2.label = option;
                        wc2.value = option;
                        wc2.selected = false;
        
        
                        dependantPickListLines.add(wc2);
                    }
        
                    pickListData.put(p, dependantPickListLines);
                }
    
    
    
            }
    
    
            return JSON.serialize(pickListData);
            
        }
    
        public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField){
    
            Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
    
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
    
            Schema.DescribeSObjectResult describeResult = objType.getDescribe();
            Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
            Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();
    
            List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
            List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
    
            for(Schema.PicklistEntry currControllingValue : controllingValues)
            {
                controllingInfo.put(currControllingValue.getLabel(), new List<String>());
            }
     
            for(Schema.PicklistEntry currDependentValue : dependentValues)
            {
                String jsonString = JSON.serialize(currDependentValue);
        
                MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
        
                String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
        
        
                Integer baseCount = 0;
        
                for(Integer curr : hexString.getChars())
                {
                    Integer val = 0;
        
                    if(curr >= 65)
                    {
                        val = curr - 65 + 10;
                    }
                    else
                    {
                        val = curr - 48;
                    }
        
                    if((val & 8) == 8)
                    {
                        controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                    }
                    if((val & 4) == 4)
                    {
                        controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                    }
                    if((val & 2) == 2)
                    {
                        controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                    }
                    if((val & 1) == 1)
                    {
                        controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                    }
        
                    baseCount += 4;
                }            
            } 
     
     
            return controllingInfo;
        }
    
        public class wrapperClass {
                
            public String label {get; set;}
            public String value {get; set;}
            public Boolean selected {get; set;}
    
        }
    
        public class MyPickListInfo{
            public String validFor;
        }
        
        
       
        @AuraEnabled(cacheable=true)
        public static List<bid__c> getAllDataByDate(String bidDate,String rand) {
    
            Date Defaultdate = date.valueOf(bidDate);

            List<Bid__c> groupedBids = new List<Bid__c>();

            List<bid__c> bids = [SELECT Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c, Delivery_Start_Date__c, Delivery_Start__c,Delivery_End__c,  Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null AND Default_Date__c=:Defaultdate ORDER BY Site__r.Name, Commodity__c, Crop_Year__c, Price__c DESC];


            Map<String, bid__c> bidMap = new Map<String, bid__c>();
    
            for(bid__c b : bids){
    
                String siteCombo = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c;
                if(bidMap.get(siteCombo)==null){
                    bidMap.put(siteCombo, new bid__c(Price__c=0));
                }
    
    
                if(b.Price__c > bidMap.get(siteCombo).Price__c){
                    bidMap.put(siteCombo, b);
                }
    
            }
    
            // get previous bids

            List<bid__c> bidsPriorList1 = [SELECT Id, Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c, Delivery_Start_Date__c,Delivery_Start__c,Delivery_End__c, Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null AND Default_Date__c<:Defaultdate AND Default_Date__c=LAST_N_DAYS:10 ORDER BY Default_Date__c ASC, Price__c ASC Limit 50000];

            Map<String, bid__c> oldBidMap = new Map<String, bid__c>();
    
            for(bid__c b : bidsPriorList1){
                oldBidMap.put(b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c, b);
            }

        
            for(Bid__c b : bidMap.values()){

                b.Price_Change__c = '$0.00';

                String siteCombo2 = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c;
                
                
                if(oldBidMap.get(siteCombo2)!=null){

                    if((b.Price__c - oldBidMap.get(siteCombo2).Price__c)<0)
                    {
                        b.Price_Change__c = '-$'+ (oldBidMap.get(siteCombo2).Price__c - b.Price__c )+'';
                    } else {
                        b.Price_Change__c = '+$'+(b.Price__c - oldBidMap.get(siteCombo2).Price__c)+'';
                    } 
                
                }

                groupedBids.add(b);

            }


            // return updatedBidList;
            return groupedBids;
        }

        
        @AuraEnabled(cacheable=true)
        public static String getAllSearchBidOptions(String pickListNames) {
            System.debug('pickListNames: ' + pickListNames);
    
            List<String> plNames = (List<String>) JSON.deserialize(pickListNames, List<String>.class);
    
            Map<String, List<wrapperClass>> pickListData = new Map<String, List<wrapperClass>>();
    
            for(String p : plNames){
    
                List<wrapperClass> pickListLines = new List<wrapperClass>();
    
                for(PicklistEntry pe : getPickListOptions('Bid__c', p)){
    
                    wrapperClass wc = new wrapperClass();
                    wc.label = pe.getLabel();
                    wc.value = pe.getValue();
                    wc.selected = false;
    
    
                    pickListLines.add(wc);
    
                }
    
                pickListData.put(p, pickListLines);
    
            }
    
    
    
            Map<String, List<String>> dependantPicklistMap = getFieldDependencies('bid__c', 'Commodity__c', 'Grade__c');
    
    
            for(String p : dependantPicklistMap.keySet()){
    
                if(dependantPicklistMap.get(p).size()>0){
    
                    List<wrapperClass> dependantPickListLines = new List<wrapperClass>();
    
    
                    for(String option : dependantPicklistMap.get(p)){
                        wrapperClass wc2 = new wrapperClass();
                        wc2.label = option;
                        wc2.value = option;
                        wc2.selected = false;
        
        
                        dependantPickListLines.add(wc2);
                    }
        
                    pickListData.put(p, dependantPickListLines);
                }
    
    
    
            }
    
    
            return JSON.serialize(pickListData);
            
        }

        
        @AuraEnabled(cacheable=true)
        public static List<bid__c> getAllBidDataBySearch(String siteBid,String commodityBid,String gradeBid,String cropyearBid,String saleoriginBid,String rand) {
   
if(siteBid=='' || siteBid==null || siteBid.length()<=1){
    siteBid=' ';
}
   
if(commodityBid=='' ||commodityBid==null || commodityBid.length()<=1 ){
    commodityBid=' ';
}
   
if(gradeBid=='' || gradeBid==null || gradeBid.length()<=1){
    gradeBid=' ';
}

    if(cropyearBid=='' || cropyearBid==null || cropyearBid.length()<=1)
    {
        cropyearBid='/';
    }
    if(saleoriginBid=='' || saleoriginBid==null || saleoriginBid.length()<=1)
    {
        saleoriginBid=' ';
    }



    String site='%'+siteBid+'%';
    String commodity='%'+commodityBid+'%';
    String grade='%'+gradeBid+'%';
    String cropyear='%'+cropyearBid+'%';
    String saleorigin='%'+saleoriginBid+'%';

            List<Bid__c> groupedBids = new List<Bid__c>();
            List<bid__c> bids = new List<bid__c>();
            if(saleoriginBid!=' ')
            {
            bids = [SELECT Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c, Delivery_Start_Date__c, Delivery_Start__c,Delivery_End__c,IsDeleted,  Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null  AND Site__r.Name LIKE:site AND Commodity__c LIKE:commodity AND Crop_Year__c LIKE:cropyear AND Grade__c LIKE:grade AND  Sale_Origin_Destination__c LIKE:saleorigin ORDER BY Site__r.Name, Commodity__c, Crop_Year__c, Price__c DESC];
            }
            else{
             bids = [SELECT Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c,IsDeleted, Delivery_Start_Date__c, Delivery_Start__c,Delivery_End__c,  Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null  AND Site__r.Name LIKE:site AND Commodity__c LIKE:commodity AND Crop_Year__c LIKE:cropyear AND Grade__c LIKE:grade ORDER BY Site__r.Name, Commodity__c, Crop_Year__c, Price__c DESC];

            }


            Map<String, bid__c> bidMap = new Map<String, bid__c>();
    
            for(bid__c b : bids){
    
                String siteCombo = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c;
                if(bidMap.get(siteCombo)==null){
                    bidMap.put(siteCombo, new bid__c(Price__c=0));
                }
    
    
                if(b.Price__c > bidMap.get(siteCombo).Price__c){
                    bidMap.put(siteCombo, b);
                }
    
            }

            List<bid__c> bidsPriorList1 = new List<bid__c>();
            // get previous bids
            if(saleoriginBid!='')
            {
            bidsPriorList1 = [SELECT Id, Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c,IsDeleted, Delivery_Start_Date__c,Delivery_Start__c,Delivery_End__c, Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null AND Site__r.Name LIKE:site AND Commodity__c LIKE:commodity AND Crop_Year__c LIKE:cropyear AND Grade__c LIKE:grade AND  Sale_Origin_Destination__c LIKE:saleorigin  AND Default_Date__c=LAST_N_DAYS:10 ORDER BY Default_Date__c ASC, Price__c ASC Limit 50000];
            }
            else {
            bidsPriorList1 = [SELECT Id, Name, Site__r.Sale_Origin_Destination2__c, Site__c, Sale_Origin_Destination__c, Buyer_Name__r.Name, Buyer_Name_Text__c, Site__r.Regions_Farming_MZ__c, Site__r.Market_Region__c, Site__r.Name, Farming_Region_Name__c, Default_Date_Time__c,Default_Date__c, Commodity__c, Grade__c, Crop_Year__c, Price__c,IsDeleted, Delivery_Start_Date__c,Delivery_Start__c,Delivery_End__c, Price_Change__c, Delivery_End_Date__c FROM bid__c Where Site__r.Market_Region__c!=null AND Site__r.Name LIKE:site AND Commodity__c LIKE:commodity AND Crop_Year__c LIKE:cropyear AND Grade__c LIKE:grade AND  Default_Date__c=LAST_N_DAYS:10 ORDER BY Default_Date__c ASC, Price__c ASC Limit 50000];
            }

            Map<String, bid__c> oldBidMap = new Map<String, bid__c>();
    
            for(bid__c b : bidsPriorList1){
                oldBidMap.put(b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c, b);
            }

        
            for(Bid__c b : bidMap.values()){

                b.Price_Change__c = '$0.00';

                String siteCombo2 = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+b.Sale_Origin_Destination__c+'-'+b.Delivery_Start__c+'-'+b.Delivery_End__c;
                
                
                if(oldBidMap.get(siteCombo2)!=null){

                    if((b.Price__c - oldBidMap.get(siteCombo2).Price__c)<0)
                    {
                        b.Price_Change__c = '-$'+ (oldBidMap.get(siteCombo2).Price__c - b.Price__c )+'';
                    } else {
                        b.Price_Change__c = '+$'+(b.Price__c - oldBidMap.get(siteCombo2).Price__c)+'';
                    } 
                
                }

                groupedBids.add(b);

            }


            // return updatedBidList;
            return groupedBids;
        }

    }