@IsTest(seeAllData=true)
private class SMSDashboardControllerTest {
    @IsTest
    static void smsTest1() {
        // Create test data
        Site__c testSite = new Site__c();
        testSite.Sale_Origin_Destination2__c = 'Delivered;Free on Truck (FOT) - Gin Yard;Public Warehouse;Free on Truck (FOT);Free on Board (FOB);Free In Store (FIS)';
        testSite.Regions_Farming_MZ__c = 'Dubbo - NSW';
        testSite.Market_Region__c = 'Central West - NSW';
        testSite.Name = 'Test Site';

        List<Bid__c> bidList = SMSDashboardController.getAllData(String.valueOf(testSite.Id));
        List<Schema.PicklistEntry> picklistOptions = SMSDashboardController.getPickListOptionsCott('Bid__c', 'Commodity__c');
        //SMSDashboardController.insertBidIdsToCustomSettingsApex('a1ABn0000008ebNMAQ:a1ABn0000008ebOMAQ:a1ABn0000008ebPMAQ');
        String jsonResponse = SMSDashboardController.getContactListViewsApex('2'); 
        List<Schema.PicklistEntry> picklist = SMSDashboardController.getPickListOptions('Bid__c', 'Commodity__c'); 
        String singlePicklist = SMSDashboardController.getSinglePicklistOptions('Bid__c', 'Commodity__c'); 
        List<Contact> getContacts = SMSDashboardController.getContactListViewDataApex('00B2x000007WJOnEAO', '2');
        List<Contact> getContacts2 = SMSDashboardController.getContactListViewDataApex('00B2x000007brBHEAY', '2');
        List<bid__c> getSmsDataTest = SMSDashboardController.getSmsData('2');
        Map<String, List<String>> getFieldDependenciesTest = SMSDashboardController.getFieldDependencies('bid__c', 'Commodity__c', 'Grade__c');
        List<String> samplePicklist = new List<String>();
        samplePicklist.add('Commodity__c');
        samplePicklist.add('Grade__c');
        samplePicklist.add('Crop_Year__c');
        String getAllPickListOptionsTest = SMSDashboardController.getAllPickListOptions(JSON.serialize(samplePicklist));
        String getAllSearchBidOptionsTest = SMSDashboardController.getAllSearchBidOptions(JSON.serialize(samplePicklist));

        samplePicklist = new List<String>();
        samplePicklist.add('a1ABn0000008ecJMAQ');
        samplePicklist.add('a1ABn0000008ebnMAA');
        samplePicklist.add('a1ABn0000008ecHMAQ');
        SMSDashboardController.insertBidIdsToCustomSettingsApex(JSON.serialize(samplePicklist));
        SMSDashboardController.getOrderMarketRegion('10');
        List<Bid__c> bidList1 = SMSDashboardController.getAllDataByDate(String.valueOf(System.today()),'932855898787980');
        List<Bid__c> bidList2 = SMSDashboardController.getAllBidDataBySearch('MacKay Port GrainCorp - QLD','Chickpeas - Desi Type','CHKP - CSP - 4.1.1 MIN. RECEIVAL STANDARD FARMER DRESSED','2023/2024','Delivered','932855898787980');

    }

}