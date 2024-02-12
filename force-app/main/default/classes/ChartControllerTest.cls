@IsTest(seeAllData=true)
private class ChartControllerTest {
    @IsTest
    static void testChartController() {
     // Instantiate a new controller with all parameters in the page
    
     List<Bid__c> bidDetails = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c,Delivery_Start__c,Delivery_End__c,Sale_Origin_Destination__c, CreatedDate, Price__c From Bid__c  WHERE Commodity__c='Canola - Non GMO' ORDER BY Price__c ASC Limit 1];
     Date theStartDate = Date.newInstance((Date.Today().Year()-2),1,1);
     Date theEndDate = Date.newInstance(Date.Today().Year(),12,31);

     for(Bid__c bidDetail:bidDetails)
     {
    ChartController.getGrades(bidDetail.Id);
     ChartController.getGradesList(bidDetail.Id);
     ChartController.getBidByGrade(bidDetail.Id,theStartDate,theEndDate);
     ChartController.getAllSelectedBids(bidDetail.Id,theStartDate,theEndDate); 
     }
     ChartController ccr=new ChartController();
     ccr.recordRelatedGradeBids='';
     ccr.recordRelatedGrades='';
     ccr.recordBids='';
    
     ccr.redirectToTarget();
                          
 }    
}