public without sharing class BidQuickCottonController {


    @AuraEnabled(cacheable=true)
    public static String getAllBidsByBuyerId(String buyerId,String rand, Boolean filterToday) {

        //List<Bid__c> bidList = [Select Id, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Commodity_Short_Name__c='Cotton' AND Buyer_Name__c =: buyerId order by CreatedDate ASC];
        List<Bid__c> bidList = new List<Bid__c>();

        bidList = [Select Id, Adjustment__c, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Is_Excluded__c=false AND Commodity_Short_Name__c='Cotton' AND Site__r.Site_Active__c=True AND Buyer_Name__c =: buyerId AND Default_Date_Time__c<TODAY AND Adjustment__c!='Base' ORDER BY Site__r.Name, Commodity__c, Grade__c, Crop_Year__c, Sale_Origin_Destination__c DESC, Default_Date__c ASC, Price__c ASC];

        if(filterToday==true) {           
            bidList = [Select Id, Adjustment__c, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where  Is_Excluded__c=false AND Commodity_Short_Name__c='Cotton' AND Site__r.Site_Active__c=True AND Buyer_Name__c =: buyerId  AND Adjustment__c!='Base' ORDER BY Site__r.Name, Commodity__c, Grade__c, Crop_Year__c, Sale_Origin_Destination__c DESC, Default_Date__c ASC, Price__c ASC];
        }

        // get base 

        List<Bid__c> baseBids = [Select Id, Adjustment__c, Price_Change__c, Site__c, Site__r.Name,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start_Date__c, Delivery_End_Date__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where  Is_Excluded__c=false AND Commodity_Short_Name__c='Cotton' AND Site__r.Site_Active__c=True AND Buyer_Name__c =: buyerId  AND Adjustment__c='Base' ORDER BY CreatedDate ASC, Price__c ASC];

        Map<String, Bid__c> bidMap = new Map<String, Bid__c>();
List<String> bkeysList=new List<String>();
       

        if(!baseBids.isEmpty()){
            Datetime lastDate = baseBids[baseBids.size()-1].Default_Date_Time__c;
           
            for(Bid__c b : baseBids){
                if(b.Default_Date_Time__c==lastDate){
                   System.debug('b-->'+b);  
                    String bkey = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-';
                    bidMap.put(bkey, b);
            bkeysList.add(bkey);
 System.debug('bidMap-->'+bidMap.values());
                }

            }
            
        }

         for(Bid__c b : bidList){
            String nkey = b.Site__c+'-'+b.Commodity__c+'-'+b.Grade__c+'-'+b.Crop_Year__c+'-';
           if(!bkeysList.contains(nkey))
           {
            bidMap.put(nkey, b);
           }
            
           
        }

 System.debug('bidMap-->'+bidMap.values());
        
        return JSON.serialize(bidMap.values());

    }

    @AuraEnabled
    public static void saveData(String records, String rand, Datetime saveDate) {

        //Opportunity oppObj = (Opportunity) JSON.deserialize(opp, Opportunity.class);
        // System.debug('SaveDate-->'+saveDate);
        // System.debug('SaveDate-->'+Date.valueOf(saveDate));
        
       // Datetime saveDateTime = (Datetime) JSON.deserialize(saveDate, DateTime.class);
        System.debug('DateTime-->'+saveDate);


        System.debug('records-->'+records);

        List<bid__c> bids = (List<bid__c>) JSON.deserialize(records, List<bid__c>.class);
        

        for(Bid__c b : bids){
            b.Default_Date_Time__c = saveDate;

            System.debug('b-->'+b);

        }

        System.debug('bids-->'+JSON.serializePretty(bids));

        insert bids;

    }

}