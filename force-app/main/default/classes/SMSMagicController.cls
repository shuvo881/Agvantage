public with sharing class SMSMagicController {
    @AuraEnabled
    public static void sendSMS(list<object> recipientNumber, String messageContent) {
        String senderId = '61488824329'; // Please replace the 'smsMagic' with your relevant sender ID.
        List<Id> recipientIds = new List<Id>();
        for (Object recipient : recipientNumber) {
            recipientIds.add((Id) recipient);
        }
        List<Contact> recipientPhoneNo = [SELECT Id, Mobile_Work__c, Name, FirstName,LastName FROM Contact WHERE Id IN :recipientIds];
        

        System.debug('recipientNumber'+recipientPhoneNo);
        List<smagicinteract__smsMagic__c> smsObjectList = new List<smagicinteract__smsMagic__c>(); 
        SMS_Process__c SMSProcess = new SMS_Process__c();
        SMSProcess.Name = 'Bid SMS';
        SMSProcess.SMS_Body__c = messageContent;
        insert SMSProcess;
       
        String messageContentReal= messageContent;
        for (Contact recipientNo : recipientPhoneNo) {
            messageContent=messageContentReal;
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();   
            if(recipientNo.Mobile_Work__c == null ){
            }
            else if (recipientNo.Mobile_Work__c != '' || recipientNo.Mobile_Work__c != ',' || recipientNo.Mobile_Work__c != 'null' || recipientNo.Mobile_Work__c != 'undefined' ) {
                if(messageContent.contains('{!Contact.Name}'))
                {
                    messageContent = messageContent.replace('{!Contact.Name}',recipientNo.Name );

                }
                if(messageContent.contains('{!Contact.FirstName}'))
                {
                messageContent = messageContent.replace('{!Contact.FirstName}',recipientNo.FirstName );
                
                }
                if(messageContent.contains('{!Contact.LastName}'))
                {
                    messageContent = messageContent.replace('{!Contact.LastName}',recipientNo.LastName );
                }
                    smsObject.smagicinteract__SenderId__c = senderId;
                smsObject.smagicinteract__PhoneNumber__c = String.valueOf(recipientNo.Mobile_Work__c);
                smsObject.smagicinteract__Name__c = recipientNo.Name; 
                smsObject.smagicinteract__ObjectType__c = 'Contact'; 
                smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field can either be 0 or 1. If you specify the value as 1, the SMS will not be sent, but an entry will be created under the SMS History object.
                smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                smsObject.smagicinteract__SMSText__c = messageContent;
                smsObject.smagicinteract__Contact__c = recipientNo.Id;
        
                smsObjectList.add(smsObject);
            }
            
        }    
        insert smsObjectList;

        List<SMS_Process_Contact__c> SMSProcessContactList = new List<SMS_Process_Contact__c>();   
        for (smagicinteract__smsMagic__c smsObject : smsObjectList) {            
            SMS_Process_Contact__c SMSPCList = new SMS_Process_Contact__c();           
            SMSPCList.Contact_No__c = smsObject.smagicinteract__PhoneNumber__c;
            SMSPCList.Name = 'SMS Process Contact';
            SMSPCList.SMS_History__c = smsObject.Id;
            SMSPCList.SMS_Process_Id__c = SMSProcess.Id;
            SMSPCList.Contact__c = smsObject.smagicinteract__Contact__c;
            SMSProcessContactList.add(SMSPCList);
        }
        insert SMSProcessContactList;
    }


}