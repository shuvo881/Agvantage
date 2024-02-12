public with sharing class OffertoStockClone {
    @AuraEnabled
    public static string offerToStock(String recordId) {
        List<Available_Stock__c> originalStock = [SELECT RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Account__c, Last_Bid_Date__c, Protein__c, Quantity__c, Price_Target__c, Last_Bid__c, Farm_Location__c, Comments__c, Screenings__c, Farm_Distance_km__c, Test_Weight__c, Moisture__c, Farm_Direction__c, Farm_Nearest_Town__c, Crop_Year__c, Commodity__c, Grade1__c, Oil__c, Admix__c, Falling_Number__c, Defectives__c, Foreign_Seeds__c, Foreign_Material__c, Other_Contaminants__c, Purity__c, Retention__c, Mould__c, Poor_Colour__c, Unmillable_Material__c, Size__c, Farm_Road_Name__c, Farm_Location_State__c, Farm_Region__c, Sale_Origin_Destination__c, Seller_Representative__c, State_From_Account__c, Variety__c, Delivery_Period_Start__c, Delivery_Period_End__c, Farm_Cotton_Valley_Region__c, Site_Available_Stocks__c, Preferred_Selling_Date__c, Payment_Terms__c, Grade_Spreads__c, Status__c, Broker_Consultant_Rep__c, Delivery_Terms__c, Tolerance__c, Price_Offered__c, Business_Credited_to__c, Sales_Type__c, Premium__c, Discount__c, Increments__c, GST_Type__c, Recipient_Created_Tax_Invoice__c, Vendor_Declarations__c, Grade2__c, Weight_Terms__c, Transfer_to_be_done_by__c, Rules_and_Arbitration__c, Grade_Standards__c, Expiry_Date_and_Time__c, Free_on_Board_FOB__c, AgVantage_Acting_as__c, Contract_Type_picklist__c, GTA_Contract_Number__c, Contract_Type__c, Contract_Price_per_Unit__c, Spreads__c, Commodity_Origin__c, Free_in_Store_FIS__c, Farm_Latitude__c, Farm_Longitude__c, Unit_of_Measure__c, Original_AS_Record__c, Carry_Amount__c, Unit_of_Time__c, Carry_Date_Start__c, Carry_Date_End__c, Area_Hectares__c, Yield_units_per_ha_max__c, Yield_units_per_ha_min__c, Qty_Units_Max__c, Qty_Units_Min__c, Freight__c, A_Mortgage__c, Regist_or_Unregist_Security_Interest__c, Encumbrance_or_Lien__c, Plant_Breeders_Rights__c, End_Point_Royalties_Liabilities__c, Disclosures_Details__c, Condition__c, Conditions__c, Is_Stock__c, Id, OwnerId, IsDeleted, Name FROM Available_Stock__c WHERE Id =: recordId LIMIT 1];


        List<AS_Commodity_Destination__c> originalDestination = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Available_Stock__c, Base_Price__c, Base_Spreads__c, Site__c, GPS__c, Grade_Commodity_Destination__c, Location_Differential_Cost__c, NTP_Name__c, NTP_Price__c, Price_Offered__c, Price_Target__c, Quantity__c, Sale_Origin_Destination__c, Site_Price__c, Spreads__c, Spreads2__c FROM AS_Commodity_Destination__c WHERE Available_Stock__c =: recordId LIMIT 1];
        // Create a new Stocks record and assign values from the original Available_Stock__c record
        if(!originalStock.isEmpty()){

        Stock__c clonedStock = new Stock__c();

        // clonedStock.CreatedById = originalStock.CreatedById;
        // clonedStock.LastModifiedDate = originalStock.LastModifiedDate;
        // clonedStock.LastModifiedById = originalStock.LastModifiedById;
        clonedStock.Account__c = originalStock[0].Account__c;
        clonedStock.Last_Bid_Date__c = originalStock[0].Last_Bid_Date__c;
        clonedStock.Protein__c = originalStock[0].Protein__c;
        clonedStock.Quantity__c = originalStock[0].Quantity__c;
        clonedStock.Price_Target__c = originalStock[0].Price_Target__c;
        clonedStock.Last_Bid__c = originalStock[0].Last_Bid__c;
        clonedStock.Farm_Location__c = originalStock[0].Farm_Location__c;
        clonedStock.Comments__c = originalStock[0].Comments__c;
        clonedStock.Screenings__c = originalStock[0].Screenings__c;
        clonedStock.Test_Weight__c = originalStock[0].Test_Weight__c;
        clonedStock.Moisture__c = originalStock[0].Moisture__c;
        clonedStock.Crop_Year__c = originalStock[0].Crop_Year__c;
        clonedStock.Commodity__c = originalStock[0].Commodity__c;
        clonedStock.Grade1__c = originalStock[0].Grade1__c;
        clonedStock.Oil__c = originalStock[0].Oil__c;
        clonedStock.Admix__c = originalStock[0].Admix__c;
        clonedStock.Falling_Number__c = originalStock[0].Falling_Number__c;
        clonedStock.Defectives__c = originalStock[0].Defectives__c;
        clonedStock.Foreign_Seeds__c = originalStock[0].Foreign_Seeds__c;
        clonedStock.Foreign_Material__c = originalStock[0].Foreign_Material__c;
        clonedStock.Other_Contaminants__c = originalStock[0].Other_Contaminants__c;
        clonedStock.Purity__c = originalStock[0].Purity__c;
        clonedStock.Retention__c = originalStock[0].Retention__c;
        clonedStock.Mould__c = originalStock[0].Mould__c;
        clonedStock.Poor_Colour__c = originalStock[0].Poor_Colour__c;
        clonedStock.Unmillable_Material__c = originalStock[0].Unmillable_Material__c;
        clonedStock.Size__c = originalStock[0].Size__c;
        clonedStock.Sale_Origin_Destination__c = originalStock[0].Sale_Origin_Destination__c;
        clonedStock.Seller_Representative__c = originalStock[0].Seller_Representative__c;
        clonedStock.Variety__c = originalStock[0].Variety__c;
        clonedStock.Delivery_Period_Start__c = originalStock[0].Delivery_Period_Start__c;
        clonedStock.Delivery_Period_End__c = originalStock[0].Delivery_Period_End__c;
        clonedStock.Site_Available_Stocks__c = originalStock[0].Site_Available_Stocks__c;
        clonedStock.Preferred_Selling_Date__c = originalStock[0].Preferred_Selling_Date__c;
        clonedStock.Payment_Terms__c = originalStock[0].Payment_Terms__c;
        clonedStock.Grade_Spreads__c = originalStock[0].Grade_Spreads__c;
        clonedStock.Status__c = originalStock[0].Status__c;
        clonedStock.Broker_Consultant_Rep__c = originalStock[0].Broker_Consultant_Rep__c;
        clonedStock.Delivery_Terms__c = originalStock[0].Delivery_Terms__c;
        clonedStock.Tolerance__c = originalStock[0].Tolerance__c;
        clonedStock.Price_Offered__c = originalStock[0].Price_Offered__c;
        clonedStock.Business_Credited_to__c = originalStock[0].Business_Credited_to__c;
        clonedStock.Sales_Type__c = originalStock[0].Sales_Type__c;
        clonedStock.Premium__c = originalStock[0].Premium__c;
        clonedStock.Discount__c = originalStock[0].Discount__c;
        clonedStock.Increments__c = originalStock[0].Increments__c;
        clonedStock.GST_Type__c = originalStock[0].GST_Type__c;
        clonedStock.Recipient_Created_Tax_Invoice__c = originalStock[0].Recipient_Created_Tax_Invoice__c;
        clonedStock.Vendor_Declarations__c = originalStock[0].Vendor_Declarations__c;
        clonedStock.Grade2__c = originalStock[0].Grade2__c;
        clonedStock.Weight_Terms__c = originalStock[0].Weight_Terms__c;
        clonedStock.Transfer_to_be_done_by__c = originalStock[0].Transfer_to_be_done_by__c;
        clonedStock.Rules_and_Arbitration__c = originalStock[0].Rules_and_Arbitration__c;
        clonedStock.Grade_Standards__c = originalStock[0].Grade_Standards__c;
        clonedStock.Expiry_Date_and_Time__c = originalStock[0].Expiry_Date_and_Time__c;
        clonedStock.Free_on_Board_FOB__c = originalStock[0].Free_on_Board_FOB__c;
        clonedStock.AgVantage_Acting_as__c = originalStock[0].AgVantage_Acting_as__c;
        clonedStock.Contract_Type_picklist__c = originalStock[0].Contract_Type_picklist__c;
        clonedStock.GTA_Contract_Number__c = originalStock[0].GTA_Contract_Number__c;
        clonedStock.Contract_Type__c = originalStock[0].Contract_Type__c;
        clonedStock.Contract_Price_per_Unit__c = originalStock[0].Contract_Price_per_Unit__c;
        clonedStock.Spreads__c = originalStock[0].Spreads__c;
        clonedStock.Commodity_Origin__c = originalStock[0].Commodity_Origin__c;
        clonedStock.Free_in_Store_FIS__c = originalStock[0].Free_in_Store_FIS__c;
        clonedStock.Original_AS_Record__c = originalStock[0].Original_AS_Record__c;
        clonedStock.Carry_Amount__c = originalStock[0].Carry_Amount__c;
        clonedStock.Unit_of_Time__c = originalStock[0].Unit_of_Time__c;
        clonedStock.Carry_Date_Start__c = originalStock[0].Carry_Date_Start__c;
        clonedStock.Carry_Date_End__c = originalStock[0].Carry_Date_End__c;
        clonedStock.Area_Hectares__c = originalStock[0].Area_Hectares__c;
        clonedStock.Yield_units_per_ha_max__c = originalStock[0].Yield_units_per_ha_max__c;
        clonedStock.Yield_units_per_ha_min__c = originalStock[0].Yield_units_per_ha_min__c;
        clonedStock.Freight__c = originalStock[0].Freight__c;
        clonedStock.A_Mortgage__c = originalStock[0].A_Mortgage__c;
        clonedStock.Regist_or_Unregist_Security_Interest__c = originalStock[0].Regist_or_Unregist_Security_Interest__c;
        clonedStock.Encumbrance_or_Lien__c = originalStock[0].Encumbrance_or_Lien__c;
        clonedStock.Plant_Breeders_Rights__c = originalStock[0].Plant_Breeders_Rights__c;
        clonedStock.End_Point_Royalties_Liabilities__c = originalStock[0].End_Point_Royalties_Liabilities__c;
        clonedStock.Disclosures_Details__c = originalStock[0].Disclosures_Details__c;
        clonedStock.Condition__c = originalStock[0].Condition__c;
        clonedStock.Conditions__c = originalStock[0].Conditions__c;



        // Insert the cloned Stocks record
        try{
            insert clonedStock;

      
        // Verify if the cloning was successful
        System.debug('Cloned Stocks record ID: ' + clonedStock.Id);

 if(clonedStock.Id!= NULL && !originalDestination.isEmpty()){

    List<AS_Commodity_Dest_for_Stock__c> newCdList = new List<AS_Commodity_Dest_for_Stock__c>();
    for(AS_Commodity_Destination__c originalDestinationValue: originalDestination){
        AS_Commodity_Dest_for_Stock__c cd = new AS_Commodity_Dest_for_Stock__c(
            // CreatedDate = originalDestination.CreatedDate,
            // CreatedById = originalDestination.CreatedById,
            // LastModifiedDate = originalDestination.LastModifiedDate,
            // LastModifiedById = originalDestination.LastModifiedById,
            Stock__c = clonedStock.Id,
            Base_Price__c   = originalDestinationValue.Base_Price__c,    
            Base_Spreads__c = originalDestinationValue.Base_Spreads__c,
            Site__c = originalDestinationValue.Site__c,  
            Grade_Commodity_Destination__c  = originalDestinationValue.Grade_Commodity_Destination__c,    
            NTP_Name__c = originalDestinationValue.NTP_Name__c,
            NTP_Price__c    = originalDestinationValue.NTP_Price__c,
            Price_Offered__c    = originalDestinationValue.Price_Offered__c,
            Price_Target__c = originalDestinationValue.Price_Target__c,
            Quantity__c = originalDestinationValue.Quantity__c,
            Sale_Origin_Destination__c  = originalDestinationValue.Sale_Origin_Destination__c,
            Site_Price__c   = originalDestinationValue.Site_Price__c,
            Spreads__c  = originalDestinationValue.Spreads__c,
            Spreads2__c = originalDestinationValue.Spreads2__c
        );
        newCdList.add(cd);
    }
    try {
        insert newCdList;
    } catch (Exception e) {
      return e.getMessage();    
    }
            System.debug('Cloned Destination record ID: ' + clonedStock.Id);
            return clonedStock.Id;

        }  
    }
    catch (Exception e) {
        return e.getMessage();

    }
    }
    return null;


    }

    @AuraEnabled
    public static string stockToOffer(Id recordId){
        List<Stock__c> currentStock = [SELECT A_Mortgage__c, Account__c, Admix__c, AgVantage_Acting_as__c, Area_Hectares__c, Broker_Consultant_Rep__c, Business_Credited_to__c, Carry_Amount__c, Carry_Date_End__c, Carry_Date_Start__c, Comments__c, Commodity_Origin__c, Commodity__c, Condition__c, Conditions__c, Contract_Price_per_Unit__c, Contract_Type__c, Contract_Type_picklist__c, CreatedById, CreatedDate, CreatedDate__c, Crop_Year__c, Defectives__c, Delivery_Period_End__c, Delivery_Period_Start__c, Delivery_Terms__c, Disclosures_Details__c, Discount__c, Encumbrance_or_Lien__c, End_Point_Royalties_Liabilities__c, Expiry_Date_and_Time__c, Falling_Number__c, Farm_Cotton_Valley_Region__c, Farm_Direction__c, Farm_Distance_km__c, Farm_Latitude__c, Farm_Location_State__c, Farm_Location__c, Farm_Longitude__c, Farm_Nearest_Town__c, Farm_Region__c, Farm_Road_Name__c, Foreign_Material__c, Foreign_Seeds__c, Free_in_Store_FIS__c, Free_on_Board_FOB__c, Freight__c, GST_Type__c, GTA_Contract_Number__c, Grade1__c, Grade2__c, Grade_Spreads__c, Grade_Standards__c, Id, Increments__c, IsDeleted, IsDeleted__c, LastActivityDate, LastActivityDate__c, LastModifiedById, LastModifiedBy__c, LastModifiedDate, LastModifiedDate__c, LastReferencedDate, LastReferencedDate__c, LastViewedDate, LastViewedDate__c, Last_Bid_Date__c, Last_Bid__c, Moisture__c, Mould__c, Name, Name__c, Oil__c, Original_AS_Record__c, Other_Contaminants__c, OwnerId, Payment_Terms__c, Plant_Breeders_Rights__c, Poor_Colour__c, Preferred_Selling_Date__c, Premium__c, Price_Offered__c, Price_Target__c, Protein__c, Purity__c, Qty_Units_Max__c, Qty_Units_Min__c, Quantity__c, Recipient_Created_Tax_Invoice__c, RecordTypeId, Regist_or_Unregist_Security_Interest__c, Retention__c, Rules_and_Arbitration__c, Sale_Origin_Destination__c, Sales_Type__c, Screenings__c, Seller_Representative__c, Site_Available_Stocks__c, Size__c, Spreads__c, State_From_Account__c, Status__c, SystemModstamp, SystemModstamp__c, Test_Weight__c, Tolerance__c, Transfer_to_be_done_by__c, Unit_of_Measure__c, Unit_of_Time__c, Unmillable_Material__c, Variety__c, Vendor_Declarations__c, Weight_Terms__c, Yield_units_per_ha_max__c, Yield_units_per_ha_min__c FROM Stock__c WHERE Id =: recordId LIMIT 1];


        List<AS_Commodity_Dest_for_Stock__c> originalDestination = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Stock__c, Base_Price__c, Base_Spreads__c, Site__c, GPS__c, Grade_Commodity_Destination__c, Location_Differential_Cost__c, NTP_Name__c, NTP_Price__c, Price_Offered__c, Price_Target__c, Quantity__c, Sale_Origin_Destination__c, Site_Price__c, Spreads__c, Spreads2__c FROM AS_Commodity_Dest_for_Stock__c WHERE Stock__c =: recordId LIMIT 1];

        if(!currentStock.isEmpty()){
            Available_Stock__c newOffer = new Available_Stock__c();
        
            newOffer.CreatedById = currentStock[0].CreatedById;
            newOffer.LastModifiedById = currentStock[0].LastModifiedById;
            newOffer.Account__c = currentStock[0].Account__c;
            newOffer.Last_Bid_Date__c = currentStock[0].Last_Bid_Date__c;
            newOffer.Protein__c = currentStock[0].Protein__c;
            newOffer.Quantity__c = currentStock[0].Quantity__c;
            newOffer.Price_Target__c = currentStock[0].Price_Target__c;
            newOffer.Last_Bid__c = currentStock[0].Last_Bid__c;
            newOffer.Farm_Location__c = currentStock[0].Farm_Location__c;
            newOffer.Comments__c = currentStock[0].Comments__c;
            newOffer.Screenings__c = currentStock[0].Screenings__c;
            newOffer.Test_Weight__c = currentStock[0].Test_Weight__c;
            newOffer.Moisture__c = currentStock[0].Moisture__c;
            newOffer.Crop_Year__c = currentStock[0].Crop_Year__c;
            newOffer.Commodity__c = currentStock[0].Commodity__c;
            newOffer.Grade1__c = currentStock[0].Grade1__c;
            newOffer.Oil__c = currentStock[0].Oil__c;
            newOffer.Admix__c = currentStock[0].Admix__c;
            newOffer.Falling_Number__c = currentStock[0].Falling_Number__c;
            newOffer.Defectives__c = currentStock[0].Defectives__c;
            newOffer.Foreign_Seeds__c = currentStock[0].Foreign_Seeds__c;
            newOffer.Foreign_Material__c = currentStock[0].Foreign_Material__c;
            newOffer.Other_Contaminants__c = currentStock[0].Other_Contaminants__c;
            newOffer.Purity__c = currentStock[0].Purity__c;
            newOffer.Retention__c = currentStock[0].Retention__c;
            newOffer.Mould__c = currentStock[0].Mould__c;
            newOffer.Poor_Colour__c = currentStock[0].Poor_Colour__c;
            newOffer.Unmillable_Material__c = currentStock[0].Unmillable_Material__c;
            newOffer.Size__c = currentStock[0].Size__c;
            newOffer.Sale_Origin_Destination__c = currentStock[0].Sale_Origin_Destination__c;
            newOffer.Seller_Representative__c = currentStock[0].Seller_Representative__c;
            newOffer.Variety__c = currentStock[0].Variety__c;
            newOffer.Delivery_Period_Start__c = currentStock[0].Delivery_Period_Start__c;
            newOffer.Delivery_Period_End__c = currentStock[0].Delivery_Period_End__c;
            newOffer.Site_Available_Stocks__c = currentStock[0].Site_Available_Stocks__c;
            newOffer.Preferred_Selling_Date__c = currentStock[0].Preferred_Selling_Date__c;
            newOffer.Payment_Terms__c = currentStock[0].Payment_Terms__c;
            newOffer.Grade_Spreads__c = currentStock[0].Grade_Spreads__c;
            newOffer.Status__c = currentStock[0].Status__c;
            // newOffer.Broker_Consultant_Rep__c = currentStock[0].Broker_Consultant_Rep__c;
            newOffer.Delivery_Terms__c = currentStock[0].Delivery_Terms__c;
            newOffer.Tolerance__c = currentStock[0].Tolerance__c;
            newOffer.Price_Offered__c = currentStock[0].Price_Offered__c;
            // newOffer.Business_Credited_to__c = currentStock[0].Business_Credited_to__c;
            newOffer.Sales_Type__c = currentStock[0].Sales_Type__c;
            newOffer.Premium__c = currentStock[0].Premium__c;
            newOffer.Discount__c = currentStock[0].Discount__c;
            newOffer.Increments__c = currentStock[0].Increments__c;
            newOffer.GST_Type__c = currentStock[0].GST_Type__c;
            newOffer.Recipient_Created_Tax_Invoice__c = currentStock[0].Recipient_Created_Tax_Invoice__c;
            newOffer.Vendor_Declarations__c = currentStock[0].Vendor_Declarations__c;
            newOffer.Grade2__c = currentStock[0].Grade2__c;
            newOffer.Weight_Terms__c = currentStock[0].Weight_Terms__c;
            newOffer.Transfer_to_be_done_by__c = currentStock[0].Transfer_to_be_done_by__c;
            newOffer.Rules_and_Arbitration__c = currentStock[0].Rules_and_Arbitration__c;
            newOffer.Grade_Standards__c = currentStock[0].Grade_Standards__c;
            newOffer.Expiry_Date_and_Time__c = currentStock[0].Expiry_Date_and_Time__c;
            newOffer.Free_on_Board_FOB__c = currentStock[0].Free_on_Board_FOB__c;
            newOffer.AgVantage_Acting_as__c = currentStock[0].AgVantage_Acting_as__c;
            newOffer.Contract_Type_picklist__c = currentStock[0].Contract_Type_picklist__c;
            newOffer.GTA_Contract_Number__c = currentStock[0].GTA_Contract_Number__c;
            newOffer.Contract_Type__c = currentStock[0].Contract_Type__c;
            newOffer.Contract_Price_per_Unit__c = currentStock[0].Contract_Price_per_Unit__c;
            newOffer.Spreads__c = currentStock[0].Spreads__c;
            newOffer.Commodity_Origin__c = currentStock[0].Commodity_Origin__c;
            newOffer.Free_in_Store_FIS__c = currentStock[0].Free_in_Store_FIS__c;
            newOffer.Original_AS_Record__c = currentStock[0].Original_AS_Record__c;
            newOffer.Carry_Amount__c = currentStock[0].Carry_Amount__c;
            newOffer.Unit_of_Time__c = currentStock[0].Unit_of_Time__c;
            newOffer.Carry_Date_Start__c = currentStock[0].Carry_Date_Start__c;
            newOffer.Carry_Date_End__c = currentStock[0].Carry_Date_End__c;
            newOffer.Area_Hectares__c = currentStock[0].Area_Hectares__c;
            newOffer.Yield_units_per_ha_max__c = currentStock[0].Yield_units_per_ha_max__c;
            newOffer.Yield_units_per_ha_min__c = currentStock[0].Yield_units_per_ha_min__c;
            newOffer.Freight__c = currentStock[0].Freight__c;
            newOffer.A_Mortgage__c = currentStock[0].A_Mortgage__c;
            newOffer.Regist_or_Unregist_Security_Interest__c = currentStock[0].Regist_or_Unregist_Security_Interest__c;
            newOffer.Encumbrance_or_Lien__c = currentStock[0].Encumbrance_or_Lien__c;
            newOffer.Plant_Breeders_Rights__c = currentStock[0].Plant_Breeders_Rights__c;
            newOffer.End_Point_Royalties_Liabilities__c = currentStock[0].End_Point_Royalties_Liabilities__c;
            newOffer.Disclosures_Details__c = currentStock[0].Disclosures_Details__c;
            newOffer.Condition__c = currentStock[0].Condition__c;
            newOffer.Conditions__c = currentStock[0].Conditions__c;
            newOffer.OwnerId = currentStock[0].OwnerId;
            try {
                insert newOffer;
                if(newOffer.Id!= NULL && originalDestination != null){
                    List<AS_Commodity_Destination__c> newCdList = new List<AS_Commodity_Destination__c>();
                    for(AS_Commodity_Dest_for_Stock__c originalDestinationValue: originalDestination){
                        AS_Commodity_Destination__c cd = new AS_Commodity_Destination__c(
                            // CreatedDate = originalDestination.CreatedDate,
                            // CreatedById = originalDestination.CreatedById,
                            // LastModifiedDate = originalDestination.LastModifiedDate,
                            // LastModifiedById = originalDestination.LastModifiedById,
                            Available_Stock__c = newOffer.Id,
                            Base_Price__c   = originalDestinationValue.Base_Price__c,    
                            Base_Spreads__c = originalDestinationValue.Base_Spreads__c,
                            Site__c = originalDestinationValue.Site__c,  
                            Grade_Commodity_Destination__c  = originalDestinationValue.Grade_Commodity_Destination__c,    
                            NTP_Name__c = originalDestinationValue.NTP_Name__c,
                            NTP_Price__c    = originalDestinationValue.NTP_Price__c,
                            Price_Offered__c    = originalDestinationValue.Price_Offered__c,
                            Price_Target__c = originalDestinationValue.Price_Target__c,
                            Quantity__c = originalDestinationValue.Quantity__c,
                            Sale_Origin_Destination__c  = originalDestinationValue.Sale_Origin_Destination__c,
                            Site_Price__c   = originalDestinationValue.Site_Price__c,
                            Spreads__c  = originalDestinationValue.Spreads__c,
                            Spreads2__c = originalDestinationValue.Spreads2__c
                        );
                        newCdList.add(cd);
                    }
                    try {
                        insert newCdList;
                    } catch (Exception e) {
                      return e.getMessage();    
                    }
                    return newOffer.Id;
                }
    
            } catch (Exception e) {
                return e.getMessage();

            }
            
        }   
        return null;
    }
}

    






// public without sharing class OffertoStockClone {
    
//     private static final String CLASS_NAME = 'OffertoStockClone';
//     private static final String OPERATION_UPDATE = 'INSERT';

//     @InvocableMethod
//     public static List<Response> StockClone(List<Request> requests){
//         List<Response> responses = new List<Response>();
//         List<Database.SaveResult> results = new List<Database.SaveResult>();
//         Database.DMLOptions dmlOptions = new Database.DMLOptions();
    
//         try{    
//             System.debug(requests[0].recordId);
//         }
//         catch(Exception exc){
//             System.debug('error : '+exc.getmessage()+ ' line : '+exc.getlineNumber());
        
//         }
        
//         // Return list of responses
//         return responses;
//     }
    
//     // Request Data Structure
//     public class Request {
//         @InvocableVariable(label='Offer Record' required=true)
//         public String recordId;
//     }
    
//     // Response Data Structure
//     public class Response {
//         @InvocableVariable(label='Stock Id' required=true)
//         public String stockId;
//     }
// }