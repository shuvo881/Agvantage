public with sharing class getContactforStock {
    @AuraEnabled
    public static Contact getData(String recordId, String rand) {
        Contact conObj = [SELECT Id, IsDeleted, MasterRecordId, AccountId, LastName, FirstName, Salutation, MiddleName, Suffix, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude, MailingGeocodeAccuracy, MailingAddress, Phone, Fax, MobilePhone, ReportsToId, Email, Title, Department, OwnerId, HasOptedOutOfEmail, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastCURequestDate, LastCUUpdateDate, LastViewedDate, LastReferencedDate, EmailBouncedReason, EmailBouncedDate, IsEmailBounced, PhotoUrl, Jigsaw, JigsawContactId, IndividualId, Office_Manager__c, Referred_By__c, Account_ID_18_Digit__c, Priority__c, Spouse_Name__c, Fax_Work__c, Messenger_ID__c, Daily_Prices_Email__c, Daily_Prices_SMS__c, Weekly_Report_Email__c, Weekly_SMS__c, Monthly_Report_Email__c, Monthly_SMS__c, ID_Status__c, pi__Needs_Score_Synced__c, pi__Pardot_Last_Scored_At__c, pi__campaign__c, pi__comments__c, pi__conversion_date__c, pi__conversion_object_name__c, pi__conversion_object_type__c, pi__created_date__c, pi__first_activity__c, pi__first_search_term__c, pi__first_search_type__c, pi__first_touch_url__c, pi__grade__c, pi__last_activity__c, pi__notes__c, pi__pardot_hard_bounced__c, pi__score__c, pi__url__c, pi__utm_campaign__c, pi__utm_content__c, pi__utm_medium__c, pi__utm_source__c, pi__utm_term__c, Phone_Work__c, Mobile_Work__c, Email_Offpage__c, Farming_Regions__c, Cotton_Valley_Regions__c, Spouse_Email__c, Spouse_Mobile__c, ACT_ContactID__c, Notes__c, Communicate_via_email__c, Communicate_via_SMS__c, Nearest_Public_Warehouse_Contact__c, Commodities__c, et4ae5__HasOptedOutOfMobile__c, et4ae5__Mobile_Country_Code__c, smagicinteract__SMSOptOut__c, Trade_Regions__c, Priority_SMS_Opt_Out__c, Contact_Manager__c, Opt_Back_in_SMS_Date__c, rcsfl__SMS_Number__c, rcsfl__SendSMS__c, Days_Since_Last_Activity__c, Contact_ABN__c, Unsubscribe_Temp_Emails__c, Opt_Back_in_Emails__c, Contact_NGR__c, Multiple_Contact_Records__c, Producer_Grower_Commodities__c, Buyer_Commodities__c, Hidden_Account_Changed__c, Opt_Out_SMS__c, Opt_Out_Temporarily_SMS__c, Cotton_Gin__c FROM Contact WHERE Id=:recordId LIMIT 1];



        return conObj;

    }

    
    @AuraEnabled
    public static string saveData(String stock, String rand) {

        Stock__c stockObj = (Stock__c) JSON.deserialize(stock, Stock__c.class);
//System.debug('stock->>'+stockObj);
        insert stockObj;

        return stockObj.Id;
    }
}