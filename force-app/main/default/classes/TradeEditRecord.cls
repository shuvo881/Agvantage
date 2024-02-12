public without sharing class TradeEditRecord {
    
     
    @AuraEnabled
    public static Opportunity getData(String recordId, String rand) {
        Opportunity oppobj = [SELECT Id, IsDeleted, AccountId, RecordTypeId, Name, Description, StageName, Amount, Probability, TotalOpportunityQuantity, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, PushCount, LastStageChangeDate, FiscalQuarter, FiscalYear, Fiscal, ContactId, LastViewedDate, LastReferencedDate, SyncedQuoteId, ContractId, HasOpenActivity, HasOverdueTask, LastAmountChangedHistoryId, LastCloseDateChangedHistoryId, Budget_Confirmed__c, Discovery_Completed__c, ROI_Analysis_Completed__c, Priority__c, Loss_Reason__c, Contract_Number__c, Contract_Type__c, Crop_Year__c, Contract_Quantity__c, Carry_Date_Start__c, Carry_Date_End__c, Increments__c, Payment_Terms__c, Area_hectares__c, Yield_units_per_ha_min__c, Yield_units_per_ha_max__c, Allowed_Tolerance_Diff_in_P_No_Negetive__c, GrainCorp_Grower_Buyer_Code__c, Delivery_Terms__c, Commodity_Origin__c, Delivery_Order_CMO_No__c, Delivery_Period_Start__c, Delivery_Period_End__c, Grade_Standards__c, Recipient_Created_Tax_Invoice_RCTI__c,  Sale_Origin_Destination__c, Broker_Consultant_Rep__c, Business_Credited_to__c, Broker_Office__c, Commission_invoiced_to__c, Commission_Rate_Unit__c, AgVantage_Acting_as__c, Carry_Amount__c, Unit_of_Time__c, GTA_Contract_Number__c, Farm__c, Farm_Distance_km__c, Farm_Direction__c, Farm_Nearest_Town__c, Farm_Location_State__c, Farm_Region__c, Farm_Road_Name__c, Buyer_s_Contact__c, Buyer_s_Account__c, NGR__c, Variety__c, Transfer_To_Be_Done_By__c, A_Mortgage__c, Encumbrance_or_Lien__c, Plant_Breeders_Rights__c, Registered_or_Unregistered_Security_Inte__c, End_Point_Royalties_liabilities__c, pandadoc__TrackingNumber__c, ACT_OpportunityID__c, Seller_Farming_Regions__c, Legacy_Commodity__c, Legacy_Grade__c, Legacy_Tolerance__c, Seller_Cotton_Valley_Region__c, Seller_ABN__c, Seller_Account_Address_Street__c, Seller_Account_Address_City__c, Seller_Account_Address_State__c, Seller_Account_Address_Postal_Code__c, Seller_Account_Phone__c, Signed_BNC_Received_from_Seller__c, Commission_invoiced_to_Buyer__c, Commodity_Type__c, Commission_Rate_Unit_Buyer__c, Invoice_Date__c, Seller_Mobile__c, Contract_Date__c, Transaction_Type__c, Units_Delivered_to_Buyer__c, Grade__c, Commodity__c, Price__c, Seller_Account_Fax__c, Unit_of_Measure__c, Freight__c, Rules_Arbitration__c, Grade_Spreads__c, Weight_Terms__c, Tolerance__c, Contract_Conditions__c, Seller_Account_Email__c, GST_Type__c, Farm_Contact_Name__c, Buyer_s_Account_Address_Street__c, Track_Terms__c, Free_on_Board_FOB__c, Free_in_Store_FIS__c, Seller_Representative__c, Count_of_Contract_Site__c, Qty_Units_Max__c, Qty_Units_Min__c, Transfer_To_Be_Done_By_Formula__c, Invoice_Number__c, Buyer_s_Account_Address_City__c, Signed_Contract_Recd_From_Seller__c, Contract_Sent_To_Seller__c, Contract_Received_from_Buyer__c, Legacy_Discount__c, RCTI_Bank_Details_Confirmed__c, RCTI_Bank_sent_to_Seller__c, Legacy_Commodity_Destinations__c, BNC_sent_to_Buyer__c, BNC_Sent_to_Seller__c, Vendor_Declarations__c, Tolerance_Exceeds_Reason__c, Transfer_form_Sent_to_Seller__c, Transfer_Form_Received_from_Seller__c, Test_Auto_Number__c, Allowed_Tolerance_Diff_in_No_Pos__c, Legacy_Farm_Region__c, Tolerance_Notification_Sent__c, Buyer_s_Account_Address_State__c, Premium__c, Discount__c, Buyer_s_Account_Address_Postal_Code__c, Buyer_s_Account_Phone__c, Buyer_s_Account_website__c, Buyer_s_Account_Fax__c, Buyer_s_Account_Email__c, Buyer_s_Account_ABN__c, Farm_Work_Phone__c, Farm_Work_Mobile__c, Farm_Work_Email__c, Email_Subject_Buyer__c, Email_Subject_for_Seller__c, Delivery_Period_End_CLM__c, Stage_CLM__c, Vendor_Declarations_Required__c, Vendor_Dec_Sent_to_Seller__c, Vendor_Dec_Received_from_Seller__c, Transfer_Form_Confirmed__c, Reference_Number_CLM__c, Closed_Paid__c, Confirmed_BNC__c, Allowed_Tolerance_Diff_P_No_Positive__c, Seller_Bank_Name__c, Seller_BSB__c, Seller_Bank_Account_No__c, Seller_Account_Name__c, Spreads__c, Buyer_s_Payment_Method__c, Total_Invoiced_Excl_GST__c, Total_Invoiced_Incl_GST__c, Allowed_Tolerance_Diff_in_No_Neg__c, Minimum_Tolerance_No__c, Maximum_Tolerance_No__c, Notes__c, Legacy_BNC_Sent_to_Seller__c, Legacy_BNC_Sent_to_Buyer__c, Legacy_Contract_Received_from_Buyer__c, Legacy_Contract_Sent_To_Seller__c, Legacy_RCTI_Bank_sent_to_Seller__c, Legacy_RCTI_Bank_Details_Confirmed__c, Legacy_Signed_BNC_Received_from_Seller__c, Legacy_Signed_Contract_Received_From_Sel__c, Legacy_Transfer_form_Sent_to_Seller__c, Legacy_Transfer_Form_ReceivedfromSeller__c, Legacy_Transfer_Form_Confirmed__c, Legacy_Closed_Paid__c, Legacy_Crop_Year__c, Seller_Representative_Email_Work__c, IsFOT__c, Buyer_s_Account_Email_Admin__c, Non_FOT_Contract_Price_per_Unit__c, Non_FOT_Contract_Quantity__c, Generate_BNC_Doc__c, Seller_BNC_Doc_Link__c, Buyer_BNC_Doc_Link__c, Send_Seller_BNC_Doc_Email__c, Send_Buyer_BNC_Doc_Email__c, Seller_BNC_Docs_Created__c, Buyer_BNC_Docs_Created__c, Latest_Seller_BNC_Doc_Email_Sent__c, Latest_Buyer_BNC_Doc_Email_Sent__c, GenerateSendBNCDoc__c, Buyer_Confirmation_Email__c, Seller_Confirmation_Email__c, Seller_Representative_Name__c,Carrier_Contact__c, Freight_Account__c, Generate_Send_BNC_to_Buyer_Seller__c FROM Opportunity WHERE Id=:recordId LIMIT 1];

        return oppObj;

    }

    @AuraEnabled
    public static string saveData(String opp, String recordId) {

        Opportunity oppObj = (Opportunity) JSON.deserialize(opp, Opportunity.class);
        // oppObj.Name=null;
        // oppObj.AccountId=null;
        // oppObj.Seller_Representative__c=null;
        // oppObj.Contract_Quantity__c=null;
        // oppObj.GenerateSendBNCDoc__c=null;

        insert oppObj;

        List<Contract_Site__c> contractSiteList = [Select Id, Opportunity__c, Site_Price__c, Site__c, Location_Differential_Cost__c, GPS__c, Sale_Origin_Destination__c, Base_Price__c, Grade__c, Base_Spreads__c, Quantity__c, NTP_Name__c, NTP_Price__c, Spreads2__c, Site_Price2__c, Spreads__c, UseinDocTable__c, Name From Contract_Site__c Where Opportunity__c=:recordId];

        List<Contract_Site__c> conSiteList = new List<Contract_Site__c>();

        for(Contract_Site__c s :contractSiteList ){
            // s.Id = null;

            Contract_Site__c conSite = s.clone();
            conSite.Opportunity__c = oppObj.Id;
            conSite.Id = null;
            conSite.Quantity__c=0;
            conSiteList.add(conSite);
        }

        System.debug('conSite-->'+JSON.serializePretty(conSiteList));
        
        if(!conSiteList.isEmpty()){
            insert conSiteList;
        }


        return oppObj.Id;
    }

}