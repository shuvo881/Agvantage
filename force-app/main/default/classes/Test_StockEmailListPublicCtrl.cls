@isTest
public with sharing class Test_StockEmailListPublicCtrl {   
    @isTest
    public static void StockEmailListPublicCtrl_Constructor_Test(){
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

        Farm__c farmObj = new Farm__c();
        farmObj.Name = 'test';
        farmObj.Account__c = sAccount.Id;
        farmObj.Distance_km__c = 10;
        farmObj.Direction__c = 'North';
        farmObj.Location_State__c = 'ACT';
        farmObj.Region__c = 'Albany Zone - WA';
        farmObj.Nearest_Town__c = 'Albany Zone - WA';
        farmObj.Road_Name__c = 'Albany Zone - WA';
        insert farmObj;

        Available_Stock__c avaObj=new Available_Stock__c();
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
        avaObj.Free_on_Board_FOB__c = '2';
        avaObj.Price_Offered__c = 5;
        avaObj.Price_Target__c = 1;
        avaObj.Quantity__c = 2;
        insert avaObj;

       


        //

        Available_Stock__c exFarmObj=new Available_Stock__c();
        exFarmObj.Account__c = sAccount.Id;        
        exFarmObj.Seller_Representative__c = c.id;
        exFarmObj.Broker_Consultant_Rep__c = 'Steve Dalton';
        exFarmObj.AgVantage_Acting_as__c = 'Broker';
        exFarmObj.Business_Credited_to__c = 'Steve Dalton';
        exFarmObj.Sale_Origin_Destination__c = 'Ex-Farm/FOT';
        exFarmObj.Sales_Type__c = 'Forward Sale';
        exFarmObj.Commodity__c = 'Wheat';
        exFarmObj.Crop_Year__c = '2018/2019';
        exFarmObj.Tolerance__c = t.id;
        exFarmObj.Last_Bid__c = 10;
        exFarmObj.Premium__c = p.Id;
        exFarmObj.Discount__c = d.Id;
        exFarmObj.Increments__c = 'Nil - Flat Priced';
        exFarmObj.Payment_Terms__c = '30 Days end of week of delivery/transfer';
        exFarmObj.GST_Type__c = 'Price exclusive of GST less applicable state and federal, or other levies';
        exFarmObj.Recipient_Created_Tax_Invoice__c = 'Buyer will supply Recipient Created Invoice';
        exFarmObj.Delivery_Period_Start__c = system.today().addDays(20);
        exFarmObj.Delivery_Period_End__c = system.today().addDays(10);
        exFarmObj.Preferred_Selling_Date__c = system.today();
        exFarmObj.Vendor_Declarations__c = 'Yes';
        exFarmObj.Delivery_Terms__c = 'As per Contract Conditions';
        exFarmObj.Contract_Type_picklist__c='Multi Grade';
        exFarmObj.Weight_Terms__c='As per Contract Conditions';
        exFarmObj.GTA_Contract_Number__c='3';
        exFarmObj.Transfer_to_be_done_by__c='Ex-Farm/FOT';
        exFarmObj.Rules_and_Arbitration__c='Rules and Arbitration - Grain Trade Australia - GTA';
        exFarmObj.Grade_Standards__c='Grade is as per GTA Receival standards';
        exFarmObj.Expiry_Date_and_Time__c = system.now();
        exFarmObj.Free_on_Board_FOB__c = '2';
        exFarmObj.Price_Offered__c = 5;
        exFarmObj.Price_Target__c = 1;
        exFarmObj.Quantity__c = 2;
        exFarmObj.Farm_Location__c = farmObj.Id;
        insert exFarmObj;

        //insert custom setting

        Email_Template_Temp_Values__c emailObj=new Email_Template_Temp_Values__c();
        emailObj.Name=avaObj.Id;
        emailObj.Stock_Id__c=avaObj.Id;
        Insert emailObj;

        Email_Template_Temp_Values__c emailObj2=new Email_Template_Temp_Values__c();
        emailObj2.Name=exFarmObj.Id;
        emailObj2.Stock_Id__c=exFarmObj.Id;
        Insert emailObj2;

        Stock_Email_Settings__c stockEmailObj=new Stock_Email_Settings__c();
        stockEmailObj.Site_Url__c='test';
        stockEmailObj.Name='test';
        Insert stockEmailObj;

        // Contact conObj=new Contact();
        // conObj.LastName='test';
        // conObj.AccountId=sAccount.Id;
        // conObj.Contact_Manager__c='N/A';
        // conObj.ID_Status__c='Agronomist';
        // conObj.Farming_Regions__c='N/A';
        // conObj.Cotton_Valley_Regions__c='N/A';
        // conObj.Phone_Work__c='0123456';
        

        // Insert conObj;


        // List<sObject> conList = [Select Id From Contact];



       // new StockListEmailTemplateCtrl().selectedStockList;        
        ApexPages.currentPage().getParameters().put('ids', avaObj.Id);
        //stockIds.add(avaObj.Id);

        new StockEmailListPublicCtrl();        
        //new StockEmailListPublicCtrl().stockIds=stockIds;        
        new StockEmailListPublicCtrl().getStockList();        

        Test.stopTest();
    }
}