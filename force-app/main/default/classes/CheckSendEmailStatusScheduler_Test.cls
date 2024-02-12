@isTest
public class CheckSendEmailStatusScheduler_Test {

    @IsTest
    static void method1(){
        
        insert new Contact(LastName='test', Email='test@test.com', ID_Status__c='IT Service Provider', Referred_By__c='Act Data Base', Priority__c='Employee', Contact_Manager__c ='AgVantage');
        // insert new Contact(LastName='test2', Email='test@test.com', ID_Status__c='IT Service Provider');

        Check_Email_Status_Scheduler__c setting = new Check_Email_Status_Scheduler__c();
        setting.Scheduler_Name__c = 'Test Setting';
        setting.Interval__c = 2;
        setting.Stop__c = false;
        insert setting;

        Test.startTest();
            SchedulableContext sc = null;
            CheckSendEmailStatusScheduler tsc = new CheckSendEmailStatusScheduler();
            tsc.execute(sc);
        Test.stopTest();
        
    }

}