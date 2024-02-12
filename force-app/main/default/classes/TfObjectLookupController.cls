public with sharing class TfObjectLookupController {
    @AuraEnabled(cacheable=true)
        public static List<sObject> TfObjectLookupController(String searchKey, String objectName, String searchField, String rand) {
    

            System.debug('searchKey-->'+searchKey);
            System.debug('objectName-->'+objectName);
            System.debug('searchfield-->'+searchfield);
            String sql = 'SELECT Id, '+searchField+' FROM '+objectName+' WHERE Name LIKE \''+searchKey+'%\' LIMIT 10';
            if (objectName=='Site__c') {
                sql =  'SELECT Id, '+searchField+' FROM '+objectName+' WHERE Site_Active__c= true AND Name LIKE \''+searchKey+'%\' LIMIT 25';
            }

            List<sObject> bids = Database.query(sql);
    
            return bids;
        }
 
        @AuraEnabled(cacheable=true)
        public static List<sObject> TfContactWithBuyerName(String searchKey, String objectName, String searchField, String rand, String buyerId) {
    

            System.debug('searchKey-->'+searchKey);
            System.debug('objectName-->'+objectName);
            System.debug('searchfield-->'+searchfield);
            System.debug('buyerId-->'+buyerId);

            String sql = 'SELECT Id, Name FROM Contact WHERE Name LIKE \''+searchKey+'%\' LIMIT 10';

            if(buyerId != '' || buyerId != null){
                sql = 'SELECT Id, '+searchField+' FROM '+objectName+' WHERE Name LIKE \''+searchKey+'%\' AND Account.Id = \''+buyerId+'\' LIMIT 10';
            }
           
            System.debug('sql-->'+sql);

            List<sObject> bids = Database.query(sql);
    
            return bids;
        }

}