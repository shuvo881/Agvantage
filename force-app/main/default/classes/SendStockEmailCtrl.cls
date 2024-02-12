public class SendStockEmailCtrl {
    public List<Contact> getIDs;
    public List<Wrapper> allStocks {get;set;}
    public String conIds{get;set;}  
    public List<String> selectedStocks {get;set;}
    public Boolean isEmailSent {get;set;}

    public List<Available_Stock__c> selectedStockList {get;set;}

    public SendStockEmailCtrl(ApexPages.StandardSetController controller){

        isEmailSent = false;

        List<Wrapper> stocks = new List<Wrapper>();


        // String columns = String.join(getColumnsFromLayout('Available_Stock__c'), ',');

        List<Available_Stock__c> stockObjList = new List<Available_Stock__c>();

        String commodity = Apexpages.currentPage().getParameters().get('commodity');
        String urlConIds = Apexpages.currentPage().getParameters().get('conIds');

        List<Available_Stock__c> stockList = new List<Available_Stock__c>();
        if(commodity=='all' || commodity==null){
            stockList = [Select Id, Name, Account__r.Name, Seller_Representative__r.Name, Grade2__c, Commodity__c From Available_Stock__c];
        }else{
            stockList = [Select Id, Name, Account__r.Name, Seller_Representative__r.Name, Grade2__c, Commodity__c From Available_Stock__c Where Commodity__c=:commodity];
        }

        for(Available_Stock__c stock : stockList){
            stocks.add(new Wrapper(stock));
            stockObjList.add(stock);
        }

        allStocks = stocks;

        selectedStockList = stockObjList;
        
        System.debug('stocks-->'+stocks);

        System.debug('Get Selected');
        getIDs = controller.getSelected();
        conIds = '';  
        for(Contact cont : getIDs){
            conIds += cont.Id + ','; 
            System.debug('Contact ID : '+conIds);
        }
        conIds = conIds.removeEnd(','); 

        if(urlConIds!=null){
            conIds = urlConIds;
        }



    } 

    public string getConIds(){
        return conIds;
    }

    public string getCommoditySelectedValue(){
        return Apexpages.currentPage().getParameters().get('commodity');
    }

    public Set<String> getCommodityList(){
        
        Set<String> commodities = new Set<String>();

        for(Available_Stock__c stock : [Select Id, Commodity__c From Available_Stock__c]){
            commodities.add(stock.Commodity__c);
        }
        
        return commodities;


    }

     // METHODS
     public void processEmail(){
        try {
              // allStocks.clear();

        //clear data
        delete [Select Id From Email_Template_Temp_Values__c];

        List<String> sStocks = new List<String>();

        List<Email_Template_Temp_Values__c> stockCustomSettingList = new List<Email_Template_Temp_Values__c>();

        for(Wrapper w : allStocks){
             if(w.checked){
                sStocks.add(w.Id);
                stockCustomSettingList.add(new Email_Template_Temp_Values__c(Name=w.Id, Stock_Id__c=w.Id));
             }
        }

        insert stockCustomSettingList;

        selectedStocks = sStocks;

        List<Stock_List_Email__c> sleList = new List<Stock_List_Email__c>();

        EmailTemplate et = [Select Id, Name, NamespacePrefix, DeveloperName, Subject, Body From EmailTemplate Where DeveloperName='Warehouse_Stock_List' Limit 1];

        // List<string> toAddress = new List<string>();
        // toAddress.add('saiful@mintconsulting.org');

        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();

        Set<Id> contactIds = new Set<Id>();

        System.debug('getIDs-->'+getIDs);

        String[] conIdsSp = conIds.split(',');

        for(String con : conIdsSp){
            
            // contactIds.add(con.Contact_Id__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            sleList.add(new Stock_List_Email__c(Email_Body__c=et.Body));
            // mail.setToAddresses(toAddress);
            // mail.setSubject(et.subject);
            // mail.setHTMLBody(et.Body);
            // mail.setTargetObjectId(primaryContact);
            mail.setTargetObjectId(con);
            // mail.setWhatId(primaryAccount);
            // mail.setWhatId('a02AD0000000A93YAE');
            mail.setSaveAsActivity(true);
            mail.setUseSignature(false);
            allmsg.add(mail);

            
        }

        // for(Contact c : [Select Id, Email From Contact Where Id IN : contactIds]){
        //     toAddress.add(c.Email);
        // }

        // try {
            //working
            Messaging.sendEmail(allmsg);
           // delete [Select Id From Email_Template_Temp_Values__c];
            
            if(!sleList.isEmpty()){
                insert sleList;
            }
            
            isEmailSent = true;
            return;
        // } catch (Exception e) {
        //     System.debug(e.getMessage());
        // }
            
        } catch (Exception ex) {
            System.debug('error-->'+ex);
            
        } finally {
            //delete [Select Id From Email_Template_Temp_Values__c];
        }
      


   }

    public static List<String> getColumnsFromLayout(String objName){

        List<String> allColumnNames = new List<String>();

        HttpRequest req = new HttpRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String endPoinURL = baseUrl+'/services/data/v50.0/search/layout?q='+objName;

        req.setEndpoint(endPoinURL);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        Http http = new Http();
        if(!Test.isRunningTest())
        {
            HttpResponse response = http.send(req);
            if( response.getStatusCode() == 200 ) {
                List<Object> preResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> tokenResponse = (Map<String, Object>) preResponse[0];
                List<Object> columns = (List<Object>) tokenResponse.get('searchColumns');

                for(Object o : columns){
                    Map<String, Object> oa = (Map<String, Object>) o;

                    String columnAPIName = String.valueOf(oa.get('field')).replaceAll(objName+'.','');

                    System.debug('oa->'+columnAPIName);
                    allColumnNames.add(columnAPIName);
                }

            }
        }


        return allColumnNames;

    }

    public static void getListViews(){

        HttpRequest req = new HttpRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        //String endPoinURL = baseUrl+'/services/data/v50.0/sobjects/Contact/listviews/00B2x000007WJOnEAO/describe';
        String endPoinURL = baseUrl+'/services/data/v50.0/search/layout?q=Available_Stock__c';
        
        req.setEndpoint(endPoinURL);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        Http http = new Http();
       
        if(!Test.isRunningTest())
        {
             HttpResponse response = http.send(req);
            if( response.getStatusCode() == 200 ) {
                Map<String, Object> tokenResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String query = (String) tokenResponse.get('searchColumns');
                System.debug(response.getBody());
            }
        }

    }

    public class Wrapper {

        public Boolean checked {get;set;}
        public String Id {get;set;}
        public String Name {get;set;}
        public String Grade {get;set;}
        public String SellerTradingName {get;set;}
        public String SellerRepresentative {get;set;}


        public Wrapper(Available_Stock__c stock){
            this.checked = false;
            this.Id = stock.Id;
            this.Name = stock.Name;
            this.Grade = stock.Grade2__c;
            this.SellerTradingName = stock.Account__r.Name;
            this.SellerRepresentative = stock.Seller_Representative__r.Name;
        }

    }

}