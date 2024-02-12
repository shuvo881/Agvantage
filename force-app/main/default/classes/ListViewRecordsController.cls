public with sharing class ListViewRecordsController {
   // @AuraEnabled(cacheable=true)
   @InvocableMethod(label='ContactListView' description='Get Contact ListViewId Using Api...')
    public static void getContactsByListViewId(){      

        // List<ListView_Query__c> listName = [SELECT Id, Name, ListView_Id__c, ListView_Query_Scrip__c, Q_Script_Status__c,  Farming_Region__c FROM ListView_Query__c];
        // delete listQueries;
        
        List<Contact> allContacts = new List<Contact>();        
        String sobjectApiName 	= 'Contact';
        //String ListviewId = '00B96000000TWIeEAO';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(URl.getOrgDomainUrl().toExternalForm()+'/services/data/v56.0/sobjects/'+sobjectApiName+'/listviews');       
        request.setHeader('content-type', 'application/json' );
        request.setHeader('Authorization' ,'Bearer '+userInfo.getSessionId() );
        
        List<Object> listRecord = new List<Object>();
        Http h = new Http();
        HttpResponse response = h.send(request);
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            List<Object> listviews = (List<Object>) jsonResponse.get('listviews');
            System.debug('jsonResponse'+listviews);

            delete [Select Id From ListView_Query__c];

            List<ListView_Query__c> lqList = new List<ListView_Query__c>();

            for (Object obj : listviews) {
                Map<String, Object> listView = (Map<String, Object>) obj;

                System.debug('obj-->'+listView);
                System.debug('id-->'+listView.get('id'));

                ListView_Query__c lq = new ListView_Query__c();
                lq.Name = String.valueOf(listView.get('label'));
                lq.ListView_Id__c = String.valueOf(listView.get('id'));
                lq.Object_Name__c = String.valueOf(listView.get('Contact'));

                lqList.add(lq);

            }

            insert lqList;

            ListViewQueryQueueable LVQQueueable = new ListViewQueryQueueable(); 
            System.enqueueJob(LVQQueueable); 


        } else {
            System.debug('Error: ' + response.getBody());
        }

    }


}