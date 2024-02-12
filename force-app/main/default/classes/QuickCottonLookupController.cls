public with sharing class QuickCottonLookupController {
    @AuraEnabled(cacheable=true)
        public static List<sObject> QuickCottonLookupController(String searchKey, String objectName, String searchField, String rand) {
    

            System.debug('searchKey-->'+searchKey);
            System.debug('objectName-->'+objectName);
            System.debug('searchfield-->'+searchfield);

            String sql = 'SELECT Id, '+searchField+' FROM '+objectName+' WHERE Name LIKE \''+searchKey+'%\' LIMIT 10';

            System.debug('sql-->'+sql);

            List<sObject> bids = Database.query(sql);
    
            return bids;
        }

        @AuraEnabled(cacheable=true)
        public static List<sObject> TfSiteFilter(String searchKey, String objectName, String searchField) {
    

            System.debug('searchKey-->'+searchKey);
            System.debug('objectName-->'+objectName);
            System.debug('searchfield-->'+searchfield);
            //List<String> operators = new List<String> {'Balonnne Plains', 'Barwon Darling', 'Central Highlands', 'Darling Downs', 'Dawson Callide',' Georgetown', 'Gwydir', 'Katherine', 'Kunnanarra', 'Lachlan', 'Lower Namoi', 'MacIntyre', 'Macquarie', 'Mungindi', 'Murray Valley', 'Murrumbidgee', 'Ord', 'Upper Namoi', 'Walgett' };
            String sql = 'SELECT Id, '+searchField+' FROM '+objectName+' WHERE Name LIKE \''+searchKey+'%\' LIMIT 10';
            if (objectName=='Site__c') {
                 //sql = 'SELECT Id, Name, Is_Valley__c,Cotton_Valley_Regions__c FROM '+objectName+' WHERE Site_Active__c= true AND Name LIKE \''+searchKey+'%\' AND (Cotton_Valley_Regions__c IN :operators OR Is_Valley__c = true) LIMIT 10';
                sql = 'SELECT Id, Name, Is_Valley__c,Cotton_Valley_Regions__c FROM '+objectName+' WHERE Site_Active__c= true AND Name LIKE \''+searchKey+'%\' AND ((Name LIKE \'%Valley%\' OR Name LIKE \'% Gin %\') OR Is_Valley__c = true) LIMIT 25';

                 //OR Cotton_Valley_Regions__c IN :operators AND Sale_Origin_Destination__c=\'Free on Truck (FOT) - Gin Yard\'
                }
            

           
            System.debug('sql-->'+sql);
            List<sObject> bids = Database.query(sql);
/*
            
    if (objectName=='Site__c') {
        
        List<sObject> filterBids=new List<sObject>();
        for(sObject bid:bids)
        {
            
            if(operators.contains((String)bid.get('Cotton_Valley_Regions__c')))
            {
                System.debug(bid);
                filterBids.add(bid);
            }
        }
        return filterBids;
    }
    else{
        List<sObject> bids = Database.query(sql);
        
    }*/
         return bids;   
        }
 
}