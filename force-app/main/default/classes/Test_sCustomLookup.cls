@isTest
public class Test_sCustomLookup {
   

     @isTest
     public static void fetchRecords_test()
     {        
        Account sAccount = new Account();
        sAccount.Name = 'Test';
        sAccount.Referred_By__c = 'ECOM';
        sAccount.Priority__c = 'Follow Up';
        insert sAccount;
        
        Contact c= new Contact();
        c.LastName = 'Test';
        c.AccountId = sAccount.Id;
        c.ID_Status__c = 'Banking & Finance';
        c.Contact_Manager__c = 'AgVantage';
        c.Farming_Regions__c = 'N/A';
        c.Cotton_Valley_Regions__c = 'N/A';
        c.Phone_Work__c = '123456789';
        c.Referred_By__c = 'ECOM';
        c.Priority__c = 'Follow Up';
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
        st.Sale_Origin_Destination2__c='Delivered';
        st.Sale_Origin_Destination__c='Delivered';
        st.NTP__c = 'test';
        st.Site_Active__c = true;
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
        sOppty.Sale_Origin_Destination__c='Delivered';
        sOppty.Type = 'Forward Sale';
        sOppty.Confirmed_BNC__c = true;
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

         
         sCustomLookup.fetchRecords('Account','Name','new','test',sOppty.Id,'ok','no');
         sCustomLookup.fetchRecords('Account','Name','test','test',sOppty.Id,'ntpname','no');
         sCustomLookup.fetchRecords('Account','Name','test','test',sOppty.Id,'ok',null);
         
         sCustomLookup.RecordsData tempObj=new sCustomLookup.RecordsData('test','test');
         
         
     }
     

}