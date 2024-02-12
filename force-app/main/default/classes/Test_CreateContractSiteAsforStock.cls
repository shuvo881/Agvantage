@isTest(SeeAllData=true)
 public class Test_CreateContractSiteAsforStock {

 
    public static testmethod void method1(){
        Test.startTest();

        Account sAccount = new Account();
        sAccount.Name = 'Test';
        sAccount.Referred_By__c = 'SMS';
        sAccount.Priority__c = 'Admin'; 
        insert sAccount;
        
        Contact c= new Contact();
        c.LastName = 'Test';
        c.AccountId = sAccount.Id;
        c.ID_Status__c = 'Banking & Finance';
        c.Farming_Regions__c = 'N/A';
        c.Cotton_Valley_Regions__c = 'N/A';
        c.Phone_Work__c = '123456789';
        c.Contact_Manager__c = 'N/A';
        c.Email = 'test@gmail.com';
        c.Referred_By__c = 'SMS';
        c.Priority__c = 'Admin'; 
        
        insert c;
        
        Discount__c d = new Discount__c();
        d.Name = '10';
        insert d;
        
        Premium__c p = new Premium__c();
        p.Name = '40';
        insert p ;
        
        Tolerance__c t = new Tolerance__c();
        t.Name = '41';
        insert t;
        
        Site__c st = new Site__c();
        st.name='testSite';
        st.Sale_Origin_Destination2__c='Ex-Farm/FOT';
        insert st;

        Farm__c fr=new Farm__c();
        fr.Name='fr1';
        fr.Account__c=sAccount.id;
        fr.Direction__c='North';
        fr.Distance_km__c=1;
        fr.Location_State__c='ACT';
        fr.Region__c='Albany Zone - WA';
        fr.Nearest_Town__c='Albany Zone - WA';
        fr.Road_Name__c='Albany Zone - WA';

        INSERT fr;

       

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
        avaObj.Free_on_Board_FOB__c = '2';
        avaObj.Price_Offered__c = 5;
       
        insert avaObj;
   

       
        list<AS_Commodity_Dest_for_Stock__c> csList=new list<AS_Commodity_Dest_for_Stock__c>();

        
        AS_Commodity_Dest_for_Stock__c cc1=new AS_Commodity_Dest_for_Stock__c(); 
        cc1.Site__c=st.id;
        cc1.Quantity__c=32;
        cc1.Site_Price__c=323;
        cc1.Price_Offered__c=10;
        cc1.Sale_Origin_Destination__c='Ex-Farm/FOT';
        cc1.Stock__c=avaObj.id;
        cc1.Grade_Commodity_Destination__c = 'As per contract conditions';
        cc1.Spreads__c = '5';
        csList.add(cc1);
    
        // AS_Commodity_Dest_for_Stock__c cc2=new AS_Commodity_Dest_for_Stock__c(); 
        // cc2.Site__c=st.id;
        // cc2.Quantity__c=32;
        // cc2.Site_Price__c=323;
        // cc1.Price_Target__c=10;
        // cc2.Sale_Origin_Destination__c='Ex-Farm/FOT';
        // cc2.Stock__c=avaObj.id;
        // cc2.Grade_Commodity_Destination__c = 'As per contract conditions';
        // cc2.Spreads__c = '';
        // csList.add(cc2);
        
        // AS_Commodity_Dest_for_Stock__c cc3=new AS_Commodity_Dest_for_Stock__c(); 
        // cc3.Site__c=st.id;
        // cc3.Quantity__c=32;
        // cc3.Site_Price__c=323;
        // cc1.Price_Target__c=5;
        // cc3.Sale_Origin_Destination__c='Ex-Farm/FOT';
        // cc3.Stock__c=avaObj.id;
        // cc3.Grade_Commodity_Destination__c = 'As per contract conditions';
        // cc3.Spreads__c = '10';
        
        // csList.add(cc3);

        INSERT csList;


        CreateContractSiteAsforStock.fetchData1(avaObj.id);
        CreateContractSiteAsforStock.fetchSaleODType(avaObj.id);
        CreateContractSiteAsforStock.acdHasExistingAvailableStock(avaObj.id);
        CreateContractSiteAsforStock.insCntrct(csList);
        CreateContractSiteAsforStock.picklistValues('Stock__c','Contract_Type_picklist__c');
        // CreateContractSiteAsforStock.picklistValues('Commodity__c','Contract_Type__c');
        //CreateContractSiteAsforStock.getDependedPickListValues('Contact','Email','LeadSource');
        CreateContractSiteAsforStock.getPickListValues('Contact','LeadSource');

        Test.stopTest();
    }





}