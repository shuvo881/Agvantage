@IsTest(seeAllData=true)
private class BidQuickCottonControllerTest {
    @IsTest
    static void testGetAllBidsByBuyerId() {
        Bid__c testBid = [SELECT Id, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Site__c, Bidders_Contact__c, Buyer_Name__c, Commodity__c, Crop_Year__c, Default_Country__c, Default_Date_Time__c, Delivery_End_Date__c, Delivery_Start_Date__c, Grade__c, LastModifiedById__c, Price__c, Sale_Origin_Destination__c, Farming_Region_Name__c, buyer_field_formula_field__c,  Price_Tag_Name__c, Name__c, Grade_Short_Name__c, Commodity_Short_Name__c, Todays_date__c, Buyer_Name_Text__c FROM Bid__c where Commodity_Short_Name__c='Cotton' AND Buyer_Name_Text__c='Namoi Cotton Alliance' limit 1]; 

        String buyerId = testBid.Buyer_Name__c;
        String rand = '526562356';
        BidQuickCottonController.getAllBidsByBuyerId(buyerId, rand, true);
        
        List<Bid__c> bidList = new List<Bid__c>();
        List<Bid__c> baseBids = new List<Bid__c>();
        Datetime lastDate = Datetime.now().addDays(-1); 

        List<Bid__c> testBids = new List<Bid__c>();
        // testBids.add(new Bid__c(
        //     Commodity__c = 'Cotton',
        //     Crop_Year__c = '2023',
        //     Default_Date_Time__c = Datetime.newInstance(2023, 7, 26)
        // ));
        System.debug('testBid.Buyer_Name__c '+testBid.Buyer_Name__c);
        testBids.add(new Bid__c(
            Commodity__c = 'Cotton',
            Crop_Year__c = '2023',Is_Excluded__c=false,Commodity_Short_Name__c='Cotton',
            Site__c = testBid.Site__c,
            Buyer_Name__c = testBid.Buyer_Name__c,
            Adjustment__c='Base',
            Default_Date_Time__c = Datetime.newInstance(2023, 7, 26)
        ));
       
        insert testBids;
        

    
        insert baseBids;


        BidQuickCottonController.saveData(JSON.serialize(bidList),rand,  datetime.now());

        // List<String> samplePicklist = new List<String>();
        // samplePicklist.add('Commodity__c');
        // samplePicklist.add('Grade__c');
        // samplePicklist.add('Crop_Year__c');
        // String getAllPickListOptionsTest = SMSDashboardController.getAllPickListOptions(JSON.serialize(samplePicklist));

        // samplePicklist = new List<String>();
        // samplePicklist.add('a1ABn0000008ecJMAQ');
        // samplePicklist.add('a1ABn0000008ebnMAA');
        // samplePicklist.add('a1ABn0000008ecHMAQ');
        // SMSDashboardController.insertBidIdsToCustomSettingsApex(JSON.serialize(samplePicklist));
    }
}