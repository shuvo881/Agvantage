@isTest
public class MoveToClosedPaidHandlerTest {
    
    @isTest
    static void testHandleOpportunityUpdate() {
        Tolerance__c TC = new Tolerance__c(Name='text');
        insert TC;
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity 1', Closed_Paid__c = null, StageName = 'Open', Commission_Rate_Unit_Buyer__c=3,CloseDate=System.today(),Tolerance__c = TC.Id);
        
        // Insert test records
        insert opportunity;
        
        // Modify the opportunity to simulate an update
        opportunity.StageName = 'Closed Paid';
        

        update opportunity;

        // Create test data
        Opportunity opportunity1 = new Opportunity(Name = 'Test Opportunity 1', Closed_Paid__c = null, StageName = 'Open');
        Opportunity opportunity2 = new Opportunity(Name = 'Test Opportunity 2', Closed_Paid__c = Date.today(), StageName = 'Open');
        Opportunity opportunity3 = new Opportunity(Name = 'Test Opportunity 3', Closed_Paid__c = Date.today(), StageName = 'Closed/Not Paid');
        List<Opportunity> opportunities = new List<Opportunity>{opportunity1, opportunity2, opportunity3};

        MoveToClosedPaidHandler.handleOpportunityUpdate(opportunities);

    }
}