trigger MoveToClosedPaidTrigger on Opportunity (before update) {
    MoveToClosedPaidHandler.handleOpportunityUpdate(Trigger.new);
}