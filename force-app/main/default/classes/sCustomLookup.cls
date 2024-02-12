public without sharing class sCustomLookup {
 
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value, String recId, String ntptype, String selectedntp) {
        // try {            System.debug('recId-->'+recId);
            list<opportunity> opp=[select id,Sale_Origin_Destination__c from opportunity where id =: recId limit 1];
            List<RecordsData> recordsDataList = new List<RecordsData>();
            List<Site__c> siteList = new List<Site__c>();
            Set<String> setNtps=new Set<String>();

            System.debug('ntptype-->'+ntptype);
            System.debug('searchString-->'+searchString);
            String srchQuery = '%'+searchString+'%';
        
            if(ntptype=='ntpname'){

                siteList = [SELECT Name, NTP__c from Site__c Where Site_Active__c = True and NTP__c!=null And NTP__c Like :srchQuery];
                for(Site__c currentNtp : siteList)
                {
                    setNtps.add(currentNtp.NTP__c);
                }

                for(String s : setNtps) {
                    recordsDataList.add( new RecordsData(s, s ));
                }

            }else{
              
                System.debug('selectedntp-->'+selectedntp);
                string query ='';
                if(selectedntp!=null){

                    query = 'SELECT Name from Site__c WHERE Site_Active__c = True and  Sale_Origin_Destination2__c INCLUDES (\'' + opp[0].Sale_Origin_Destination__c +'\') And NTP__c=:selectedntp And Name Like :srchQuery ORDER BY Name ASC NULLS LAST';
                    for(SObject s : Database.query(query)) {
                        recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
                    }
                }else{

                    query = 'SELECT Name from Site__c WHERE  Site_Active__c = True and Sale_Origin_Destination2__c INCLUDES (\'' + opp[0].Sale_Origin_Destination__c +'\') And Name Like :srchQuery ORDER BY Name ASC NULLS LAST';                    
                    for(SObject s : Database.query(query)) {
                        recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
                    }

                }


            }


            System.debug(JSON.serializePretty(recordsDataList));

            return recordsDataList;
    //  } catch (Exception err) {
    //   if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
    //             throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
    //         } else {
    //             throw new AuraHandledException(err.getMessage());
    //         }
    //  }
    }
 
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}