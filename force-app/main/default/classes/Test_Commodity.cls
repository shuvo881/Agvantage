@isTest
public class Test_Commodity {


    @isTest
    public static void method1(){

        Test.startTest();

        Account sAccount = new Account();
        sAccount.Name = 'Test';
        insert sAccount;
        
        Contact c= new Contact();
        c.LastName = 'Test';
        c.AccountId = sAccount.Id;
        c.ID_Status__c = 'Banking & Finance';
        c.Farming_Regions__c = 'N/A';
        c.Cotton_Valley_Regions__c = 'N/A';
        c.Phone_Work__c = '123456789';
        c.Contact_Manager__c = 'AgVantage';
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
        st.Sale_Origin_Destination2__c='Nearest Terminal Port (NTP)';
        st.Sale_Origin_Destination__c='Nearest Terminal Port (NTP)';
        st.NTP__c='test';            
        insert st;
        
        Opportunity sOppty = new Opportunity();
        sOppty.Name = 'Test';
        sOppty.AccountId = sAccount.Id;
        sOppty.Seller_Representative__c = c.Id;
        sOppty.Buyer_s_Contact__c = c.Id;
        sOppty.CloseDate = system.today().addDays(10);
        sOppty.StageName = 'Open/Sent';
        sOppty.Contract_Type__c = 'Fixed Grade';
        sOppty.Commodity__c = 'Adzuki Beans';
        sOppty.Grade__c = 'As per contract conditions';
        sOppty.Contract_Quantity__c = 3.00;
        sOppty.Commission_Rate_Unit__c=3487;
        sOppty.Commission_invoiced_to__c='N/A';
        sOppty.Commission_invoiced_to_Buyer__c='N/A';
        sOppty.Variety__c = 'Test';
        sOppty.Sale_Origin_Destination__c='Nearest Terminal Port (NTP)';
        sOppty.Type = 'Forward Sale';
        sOppty.Confirmed_BNC__c = true;
        sOppty.By_Pass_Validation_Rules__c = true;
        sOppty.Crop_Year__c = '2018/2019';
        sOppty.Delivery_Period_End__c = system.today().addDays(10);
        sOppty.Delivery_Period_Start__c = system.today().addDays(20);
        sOppty.Delivery_Terms__c = 'Delivered';
        sOppty.Discount__c = d.Id;
        sOppty.Grade_Standards__c = 'Grade is as per GTA Receival standards';
        sOppty.GST_Type__c = 'Price exclusive of GST less applicable state and federal, or other levies';
        sOppty.Payment_Terms__c = '30 Days end of week of delivery/transfer';
        sOppty.Premium__c = p.Id;
        sOppty.Rules_Arbitration__c = 'Rules and Arbitration - Grain Trade Australia - GTA';
        sOppty.Tolerance__c = t.Id;
        sOppty.Transfer_To_Be_Done_By__c = 'Delivered';
        sOppty.Weight_Terms__c = 'Weights & Quality - Final at destination over certified weighbridge';
        sOppty.Price__c = 20;
        insert sOppty;
        

        
        list<Contract_Site__c> csList=new list<Contract_Site__c>();
        
        
        
        Contract_Site__c cc1=new Contract_Site__c(); 
        cc1.Site__c=st.id;
        cc1.Quantity__c=32;
        cc1.Site_Price__c=323;
        cc1.Sale_Origin_Destination__c='Delivered';
        cc1.Opportunity__c=sOppty.id;
        cc1.Grade__c = 'As per contract conditions';
        cc1.Spreads__c = 'base';
        csList.add(cc1);
        
        Contract_Site__c cc2=new Contract_Site__c(); 
        cc2.Site__c=st.id;
        cc2.Quantity__c=32;
        cc2.Site_Price__c=323;
        cc2.Sale_Origin_Destination__c='Public Warehouse';
        cc2.Opportunity__c=sOppty.id;
        cc2.Grade__c = 'As per contract conditions';
        cc2.Spreads__c = '';
        csList.add(cc2);
        
        Contract_Site__c cc3=new Contract_Site__c(); 
        cc3.Site__c=st.id;
        cc3.Quantity__c=32;
        cc3.Site_Price__c=323;
        cc3.Sale_Origin_Destination__c='Delivered';
        cc3.Opportunity__c=sOppty.id;
        cc3.Grade__c = 'As per contract conditions';
        cc3.Spreads__c = '10';
        csList.add(cc3);
        
        insert csList;
        

        Test.stopTest();
    }
  
    
    @isTest
    public static void method2(){

        Test.startTest();
        
        Account sAccount = new Account();
        sAccount.Name = 'Test';
        insert sAccount;
        
        Contact c= new Contact();
        c.LastName = 'Test';
        c.AccountId = sAccount.Id;
        c.ID_Status__c = 'Banking & Finance';
        c.Farming_Regions__c = 'N/A';
        c.Cotton_Valley_Regions__c = 'N/A';
        c.Phone_Work__c = '123456789';
        c.Contact_Manager__c = 'AgVantage';
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
        st.Sale_Origin_Destination2__c='Public Warehouse';
        st.Sale_Origin_Destination__c='Public Warehouse';
        st.NTP__c='test';            
        insert st;
        
        Opportunity sOppty = new Opportunity();
        sOppty.Name = 'Test';
        sOppty.AccountId = sAccount.Id;
        sOppty.Seller_Representative__c = c.Id;
        sOppty.Buyer_s_Contact__c = c.Id;
        sOppty.CloseDate = system.today().addDays(10);
        sOppty.StageName = 'Open/Sent';
        sOppty.Contract_Type__c = 'Fixed Grade';
        sOppty.Commodity__c = 'Adzuki Beans';
        sOppty.Grade__c = 'As per contract conditions';
        sOppty.Contract_Quantity__c = 3.00;
        sOppty.Commission_Rate_Unit__c=3487;
        sOppty.Commission_invoiced_to__c='N/A';
        sOppty.Commission_invoiced_to_Buyer__c='N/A';
        sOppty.Variety__c = 'Test';
        sOppty.Sale_Origin_Destination__c='Public Warehouse';
        sOppty.Type = 'Forward Sale';
        sOppty.Confirmed_BNC__c = true;
        sOppty.By_Pass_Validation_Rules__c = true;
        sOppty.Crop_Year__c = '2018/2019';
        sOppty.Delivery_Period_End__c = system.today().addDays(10);
        sOppty.Delivery_Period_Start__c = system.today().addDays(20);
        sOppty.Delivery_Terms__c = 'Delivered';
        sOppty.Discount__c = d.Id;
        sOppty.Grade_Standards__c = 'Grade is as per GTA Receival standards';
        sOppty.GST_Type__c = 'Price exclusive of GST less applicable state and federal, or other levies';
        sOppty.Payment_Terms__c = '30 Days end of week of delivery/transfer';
        sOppty.Premium__c = p.Id;
        sOppty.Rules_Arbitration__c = 'Rules and Arbitration - Grain Trade Australia - GTA';
        sOppty.Tolerance__c = t.Id;
        sOppty.Transfer_To_Be_Done_By__c = 'Delivered';
        sOppty.Weight_Terms__c = 'Weights & Quality - Final at destination over certified weighbridge';
        sOppty.Price__c = 20;
        insert sOppty;
        

        
        list<Contract_Site__c> csList=new list<Contract_Site__c>();
        
        
        
        Contract_Site__c cc1=new Contract_Site__c(); 
        cc1.Site__c=st.id;
        cc1.Quantity__c=32;
        cc1.Site_Price__c=323;
        cc1.Sale_Origin_Destination__c='Delivered';
        cc1.Opportunity__c=sOppty.id;
        cc1.Grade__c = 'As per contract conditions';
        cc1.Spreads__c = 'base';
        csList.add(cc1);
        
        Contract_Site__c cc2=new Contract_Site__c(); 
        cc2.Site__c=st.id;
        cc2.Quantity__c=32;
        cc2.Site_Price__c=323;
        cc2.Sale_Origin_Destination__c='Public Warehouse';
        cc2.Opportunity__c=sOppty.id;
        cc2.Grade__c = 'As per contract conditions';
        cc2.Spreads__c = '';
        csList.add(cc2);
        
        Contract_Site__c cc3=new Contract_Site__c(); 
        cc3.Site__c=st.id;
        cc3.Quantity__c=32;
        cc3.Site_Price__c=323;
        cc3.Sale_Origin_Destination__c='Delivered';
        cc3.Opportunity__c=sOppty.id;
        cc3.Grade__c = 'As per contract conditions';
        cc3.Spreads__c = '10';
        csList.add(cc3);
        
        insert csList;
        

        Test.stopTest();
    }
    
    @isTest
    public static void method3(){

        Test.startTest();
        
        Account sAccount = new Account();
        sAccount.Name = 'Test';
        insert sAccount;
        
        Contact c= new Contact();
        c.LastName = 'Test';
        c.AccountId = sAccount.Id;
        c.ID_Status__c = 'Banking & Finance';
        c.Farming_Regions__c = 'N/A';
        c.Cotton_Valley_Regions__c = 'N/A';
        c.Phone_Work__c = '123456789';
        c.Contact_Manager__c = 'AgVantage';
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
        st.Sale_Origin_Destination2__c='Free on Truck (FOT)';
        st.Sale_Origin_Destination__c='Free on Truck (FOT)';
        st.NTP__c='test';            
        insert st;
        
        Opportunity sOppty = new Opportunity();
        sOppty.Name = 'Test';
        sOppty.AccountId = sAccount.Id;
        sOppty.Seller_Representative__c = c.Id;
        sOppty.Buyer_s_Contact__c = c.Id;
        sOppty.CloseDate = system.today().addDays(10);
        sOppty.StageName = 'Open/Sent';
        sOppty.Contract_Type__c = 'Fixed Grade';
        sOppty.Commodity__c = 'Adzuki Beans';
        sOppty.Grade__c = 'As per contract conditions';
        sOppty.Contract_Quantity__c = 3.00;
        sOppty.Commission_Rate_Unit__c=3487;
        sOppty.Commission_invoiced_to__c='N/A';
        sOppty.Commission_invoiced_to_Buyer__c='N/A';
        sOppty.Variety__c = 'Test';
        sOppty.Sale_Origin_Destination__c='Free on Truck (FOT)';
        sOppty.Type = 'Forward Sale';
        sOppty.Confirmed_BNC__c = true;
        sOppty.By_Pass_Validation_Rules__c = true;
        sOppty.Crop_Year__c = '2018/2019';
        sOppty.Delivery_Period_End__c = system.today().addDays(10);
        sOppty.Delivery_Period_Start__c = system.today().addDays(20);
        sOppty.Delivery_Terms__c = 'Delivered';
        sOppty.Discount__c = d.Id;
        sOppty.Grade_Standards__c = 'Grade is as per GTA Receival standards';
        sOppty.GST_Type__c = 'Price exclusive of GST less applicable state and federal, or other levies';
        sOppty.Payment_Terms__c = '30 Days end of week of delivery/transfer';
        sOppty.Premium__c = p.Id;
        sOppty.Rules_Arbitration__c = 'Rules and Arbitration - Grain Trade Australia - GTA';
        sOppty.Tolerance__c = t.Id;
        sOppty.Transfer_To_Be_Done_By__c = 'Delivered';
        sOppty.Weight_Terms__c = 'Weights & Quality - Final at destination over certified weighbridge';
        sOppty.Price__c = 20;
        insert sOppty;
        

        
        list<Contract_Site__c> csList=new list<Contract_Site__c>();
        
        
        
        Contract_Site__c cc1=new Contract_Site__c(); 
        cc1.Site__c=st.id;
        cc1.Quantity__c=32;
        cc1.Site_Price__c=323;
        cc1.Sale_Origin_Destination__c='Delivered';
        cc1.Opportunity__c=sOppty.id;
        cc1.Grade__c = 'As per contract conditions';
        cc1.Spreads__c = 'base';
        csList.add(cc1);
        
        Contract_Site__c cc2=new Contract_Site__c(); 
        cc2.Site__c=st.id;
        cc2.Quantity__c=32;
        cc2.Site_Price__c=323;
        cc2.Sale_Origin_Destination__c='Public Warehouse';
        cc2.Opportunity__c=sOppty.id;
        cc2.Grade__c = 'As per contract conditions';
        cc2.Spreads__c = '';
        csList.add(cc2);
        
        Contract_Site__c cc3=new Contract_Site__c(); 
        cc3.Site__c=st.id;
        cc3.Quantity__c=32;
        cc3.Site_Price__c=323;
        cc3.Sale_Origin_Destination__c='Delivered';
        cc3.Opportunity__c=sOppty.id;
        cc3.Grade__c = 'As per contract conditions';
        cc3.Spreads__c = '10';
        csList.add(cc3);
        
        insert csList;

        delete csList[0];
        

        Test.stopTest();
    }
  
}