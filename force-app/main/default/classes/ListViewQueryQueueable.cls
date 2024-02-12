public class ListViewQueryQueueable implements Queueable {
    public void execute(QueueableContext context) {
        runCode();
    }

    @future(callout=true)
    public static void runCode(){


        List<Listview_Query__c> lqList = [Select Id, ListView_Id__c,ListView_Query_Scrip__c From Listview_Query__c Where Q_Script_Status__c = null ];

        if(!lqList.isEmpty()) {

            String sobjectApiName 	= 'Contact';
            String ListviewId = lqList[0].ListView_Id__c;
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(URl.getOrgDomainUrl().toExternalForm()+'/services/data/v56.0/sobjects/'+sobjectApiName+'/listviews/'+listViewId+'/describe');
            request.setHeader('content-type', 'application/json' );
            request.setHeader('Authorization' ,'Bearer '+userInfo.getSessionId() );
            
            List<Object> listRecord = new List<Object>();
            Http h = new Http();
            HttpResponse response = h.send(request);
            if (response.getStatusCode() == 200) {
                ListView_Query__c lqToBeUpdated = new ListView_Query__c();

                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                lqToBeUpdated.Id = lqList[0].Id;
                lqToBeUpdated.ListView_Query_Scrip__c = String.valueOf(jsonResponse.get('query'));
                lqToBeUpdated.Q_Script_Status__c ='1';

                update lqToBeUpdated;
            }
        }



        if(lqList.size()>1) {

             System.enqueueJob(new ListViewQueryQueueable());

        }

    }

}