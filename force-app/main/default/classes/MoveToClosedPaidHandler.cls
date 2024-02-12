public class MoveToClosedPaidHandler {
    public static void handleOpportunityUpdate(List<Opportunity> opportunities) {
        for (Opportunity opportunity : opportunities) {
            // Check if Closed Paid date is entered
            if (opportunity.Closed_Paid__c != null) {
                // Update the stage to CLOSED/PAID
                opportunity.StageName = 'CLOSED/PAID';
            }
        }
    }
}