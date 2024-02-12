@isTest
public class Test_sCustomLookupAsforStock {
   

     @isTest
     public static void fetchRecords_test()
     {
         
        Test.startTest();

        Account sAccount = new Account();
        sAccount.Name = 'Test';
        insert sAccount;


        Site__c st = new Site__c();
        st.name='testSite';
        st.Sale_Origin_Destination2__c='Delivered';
        st.Sale_Origin_Destination__c='Delivered';
        st.NTP__c = 'test';
          

        insert st;

        Contact c= new Contact();
        c.LastName = 'Test';
        c.AccountId = sAccount.Id;
        
        c.ID_Status__c = 'Banking & Finance';
        c.ID_Status__c = 'Banking & Finance';
        c.Contact_Manager__c = 'AgVantage';
        c.Farming_Regions__c = 'N/A';
        c.Cotton_Valley_Regions__c = 'N/A';
        c.Phone_Work__c = '123456789';
        c.Email = 'test@gmail.com';
         c.Referred_By__c = 'Act Data Base';
        c.Priority__c = 'Follow Up';
        insert c;

        Tolerance__c t = new Tolerance__c();
        t.Name = '41';
        insert t;

        Premium__c p = new Premium__c();
        p.Name = '40';
        insert p;

        Discount__c d = new Discount__c();
        d.Name = '10';
        insert d;

        Stock__c avaObj=new Stock__c();

        avaObj.Account__c = sAccount.Id;        
        avaObj.Seller_Representative__c = c.id;
        avaObj.Broker_Consultant_Rep__c = 'Steve Dalton';
        avaObj.AgVantage_Acting_as__c = 'Broker';
        avaObj.Business_Credited_to__c = 'Steve Dalton';
        avaObj.Sale_Origin_Destination__c = 'Free on Board (FOB)';
        avaObj.Sales_Type__c = 'Forward Sale';
        avaObj.Commodity__c = 'Wheat';
        avaObj.Crop_Year__c = '2018/2019';
        avaObj.Tolerance__c = t.id;
        avaObj.Last_Bid__c = 10;
        avaObj.Premium__c = p.Id;
        avaObj.Discount__c = d.Id;
        avaObj.Increments__c = 'Nil - Flat Priced';
        avaObj.Payment_Terms__c = '30 Days end of week of delivery/transfer';
        avaObj.GST_Type__c = 'Price exclusive of GST less applicable state and federal, or other levies';
        avaObj.Recipient_Created_Tax_Invoice__c = 'Buyer will supply Recipient Created Invoice';
        avaObj.Delivery_Period_Start__c = system.today().addDays(20);
        avaObj.Delivery_Period_End__c = system.today().addDays(10);
        avaObj.Preferred_Selling_Date__c = system.today();
        avaObj.Vendor_Declarations__c = 'Yes';
        avaObj.Delivery_Terms__c = 'FOB';
        avaObj.Contract_Type_picklist__c='Multi Grade';
        avaObj.Weight_Terms__c='As per Contract Conditions';
        avaObj.GTA_Contract_Number__c='3';
        avaObj.Transfer_to_be_done_by__c='Free on Board (FOB)';
        avaObj.Rules_and_Arbitration__c='Rules and Arbitration - Grain Trade Australia - GTA';
        avaObj.Grade_Standards__c='Grade is as per GTA Receival standards';
        avaObj.Expiry_Date_and_Time__c = system.now();

        //

        avaObj.Free_on_Board_FOB__c = '2';
        avaObj.Price_Offered__c = 5;
       
        insert avaObj;

        //System.debug('Available stock-->'+avaObj);

    
        sCustomLookupAsforStock.fetchRecords('test', 'test', 'test', 'test', avaObj.id, 'ntp', 'test');
        sCustomLookupAsforStock.fetchRecords('test', 'test', 'test', 'test', avaObj.id, 'ntpname', 'test');
        sCustomLookupAsforStock.fetchRecords('test', 'test', 'test', 'test', avaObj.id, 'ntp', null);

       // sCustomLookup.RecordsData tempObj=new sCustomLookup.RecordsData('test','test');
         
  
         
         Test.stopTest();
     }


}