@isTest
public class CommodityViewsTest 
{
    @testSetup
    static void setupData() 
    {
    	Commodity_View__c sCV = new Commodity_View__c();
        sCV.Commodity__c = 'Test';
        insert sCV;  
    }

    private static testMethod void testCommodityViews() 
    {
        CommodityViews oController = new CommodityViews();
        oController.init();
    }
}