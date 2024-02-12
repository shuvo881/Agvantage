public without sharing class BulkBidController {

    

    @AuraEnabled(cacheable=true)
    public static String getAllBidsByBuyerId(String buyerId,String rand, Boolean filterToday, Boolean isExclude) {

        //List<Bid__c> bidList = [Select Id, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Buyer_Name__c =: buyerId order by CreatedDate ASC];
        List<Bid__c> bidList = new List<Bid__c>();

        List<Commodity_Excluded_From_Bulk_Bid__c> filterListObj = Commodity_Excluded_From_Bulk_Bid__c.getall().values();
        List<string> filterList= new List<string> ();

        for(Commodity_Excluded_From_Bulk_Bid__c a: filterListObj){
            filterList.add(String.valueOf(a.Name));
        }
        System.debug(JSON.serializePretty(filterList));
        bidList = [Select Id, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c,Default_Date__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c, Delivery_End_Date__c,Delivery_End__c,Delivery_Start__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Site__r.Site_Active__c=True AND Buyer_Name__c =: buyerId AND Default_Date_Time__c<TODAY AND Commodity__c NOT IN :filterList And Is_Excluded__c=false  ORDER BY Site__r.Name, Commodity__c, Grade__c, Crop_Year__c, Sale_Origin_Destination__c DESC, Default_Date__c ASC, Price__c ASC];

        if(filterToday==true) {           
            bidList = [Select Id, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c,Default_Date__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c,Delivery_End__c,Delivery_Start__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Site__r.Site_Active__c=True AND Buyer_Name__c =: buyerId  AND Commodity__c NOT IN :filterList And Is_Excluded__c=false ORDER BY Site__r.Name, Commodity__c, Grade__c, Crop_Year__c, Sale_Origin_Destination__c DESC, Default_Date__c ASC, Price__c ASC];
        }
        if(isExclude==true){
            bidList = [Select Id, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c,Default_Date__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c,Delivery_End__c,Delivery_Start__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Site__r.Site_Active__c=True AND Buyer_Name__c =: buyerId AND Default_Date_Time__c<TODAY AND Commodity__c IN :filterList ORDER BY Site__r.Name, Commodity__c, Grade__c, Crop_Year__c, Sale_Origin_Destination__c DESC, Default_Date__c ASC, Price__c ASC];
        }

        Map<String, Bid__c> bidMap = new Map<String, Bid__c>();
        //Set<String> stringKeyList= new Set<String>();
        Integer index=0;
        for(Bid__c b : bidList){
            if(String.valueOf(b.Delivery_Start__c) !=null && String.valueOf(b.Delivery_End__c) !=null)
            {
                //System.debug(String.valueOf(b.Delivery_Start__c));
            
            
           String[] ds = String.valueOf(b.Delivery_Start__c).split('\\-');
            String[] de = String.valueOf(b.Delivery_End__c).split('\\-');

            String key = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+ds[0]+ds[1]+ds[2]+'-'+de[0]+de[1]+de[2]+'-';
            if(b.Delivery_Start__c<System.today())
            {
                key=b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+'lower-delivery'+'-'+de[0]+de[1]+de[2]+'-';
            }
            if(bidMap.containsKey(key))
            {
               //Bid__c oldB= bidMap.get(keyList);
               Bid__c oldB= bidMap.Remove(key);
               if(oldB.Default_Date__c<b.Default_Date__c)
               {
               
                //System.debug(index+' Key: '+keyList);
                bidMap.put(key, b);
                //stringKeyList.add(stringKey);
               }
               else{
               
                //System.debug(index+' Key B: '+keyList);
                bidMap.put(key, oldB);
               }
            }
            else{
              
              //System.debug(index+' Key 1: '+keyList);
              bidMap.put(key, b);  
              //stringKeyList.add(stringKey);
            }
            }
            
            

            // String key = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-';
            // String stringKey = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-'+String.valueOf(b.Delivery_Start__c)+String.valueOf(b.Delivery_End__c);
            
            
        }
       //System.debug('Keyset '+bidMap.keySet());
 //System.debug('size '+bidMap.size());
        return JSON.serialize(bidMap.values());

    }

    @AuraEnabled
    public static void saveData(String records, String rand, Datetime saveDate) {

        System.debug('records-->'+records);
        System.debug('DateTime-->'+saveDate);
        List<bid__c> bids = (List<bid__c>) JSON.deserialize(records, List<bid__c>.class);
        

        for(Bid__c b : bids){
            b.Default_Date_Time__c = saveDate;
        }

        System.debug('bids-->'+bids);

        insert bids;

    }

    @AuraEnabled
    public static void updateExludedData(String recordId, String rand) {

        System.debug('recordId-->'+recordId);

        Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c, Buyer_Name__c  From Bid__c Where Id=:recordId Limit 1];

        List<Bid__c> bidList = [Select Id, Is_Excluded__c From Bid__c Where Buyer_Name__c=:bidDetail.Buyer_Name__c AND Site__c=:bidDetail.Site__c And Commodity__c=:bidDetail.Commodity__c And Grade__c=:bidDetail.Grade__c and Crop_Year__c=:bidDetail.Crop_Year__c];

        for(Bid__c bid : bidList){
            bid.Is_Excluded__c = true;
        }

        update bidList;


    }

    @AuraEnabled
    public static string getAllSelectedBids(String recordId, String rand){

      
        Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c,Delivery_Start__c,Delivery_End__c,Sale_Origin_Destination__c From Bid__c Where Id=:recordId Limit 1];

        List<Bid__c> bidList = [Select Id, Farming_Region_Name__c, Buyer_Name_Text__c, Price_Change__c, Site__c, Default_Date__c, Site__r.Name, Site_Name__c,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start__c, Delivery_End__c,Delivery_Start_Date__c,Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c  From Bid__c Where Site__c=:bidDetail.Site__c And Commodity__c=:bidDetail.Commodity__c And Grade__c=:bidDetail.Grade__c and Crop_Year__c=:bidDetail.Crop_Year__c AND Delivery_Start__c=:bidDetail.Delivery_Start__c AND Delivery_End__c=:bidDetail.Delivery_End__c AND Sale_Origin_Destination__c=:bidDetail.Sale_Origin_Destination__c ORDER BY Default_Date__c DESC, Price__c DESC];

        return JSON.serialize(bidList);
        

    }

    

}