@IsTest
public with sharing class SMSMagicControllerTest {
    @IsTest
    static void SendSms()
    {
        Contact newContact = new Contact();
        newContact.LastName = 'Smith';
        newContact.Referred_By__c = 'John Doe'; // Replace with the appropriate value
        newContact.Priority__c = 'High'; // Replace with the appropriate value
        newContact.ID_Status__c = 'Trader'; // Replace with the appropriate value
        newContact.Contact_Manager__c = 'AgVantage'; // Replace with the appropriate value
        newContact.Mobile_Work__c = '525522';
        insert newContact;
        

        List<Object> recipientNumbers = new List<Object>();
        recipientNumbers.add(newContact.Id);
        String messageContent = 'Test SMS';

        Test.startTest();
        SMSMagicController.sendSMS(recipientNumbers, messageContent);
        Test.stopTest();
    }
}