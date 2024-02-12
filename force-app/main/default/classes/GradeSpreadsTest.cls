@isTest
public class GradeSpreadsTest 
{
	@testSetup
    static void setupData() 
    {
    	Account sAccount = new Account();
        sAccount.Name = 'Test';
        insert sAccount;
        
        Opportunity sOppty = new Opportunity();
        sOppty.Name = 'Test';
        sOppty.CloseDate = system.today().addDays(10);
        sOppty.StageName = 'Open';
        sOppty.Commodity__c = 'Barley - Feed';
        sOppty.Grade__c = 'F1 - GTA Barley1 - CSG-10';
        sOppty.Variety__c = 'Test';
        insert sOppty;
    }
    
    private static testMethod void testGradeSpreads() 
    {
        Opportunity sOppty = [select id from Opportunity limit 1];
        GradeSpreads oController = new GradeSpreads(new ApexPages.StandardController(sOppty));
        oController.init();
        oController.lstGrades[0].dValue = '+10';
        oController.lstGrades[0].iOrder = 1;
        oController.actionSave();
        oController.actionBack();

		Opportunity sOppty1 = [select id,Grade_Spreads__c from Opportunity limit 1];
        system.debug('sOppty1:'+sOppty1);
        GradeSpreads oController1 = new GradeSpreads(new ApexPages.StandardController(sOppty));
        oController1.init();
    }
}