@IsTest(seeAllData=true)
public class TradeEditRecordTest {
    @IsTest
    static void testTradeEditRecord() {
       Opportunity obj = [SELECT Id, Name, AccountId,Seller_Representative__c,StageName,Buyer_s_Contact__c,CloseDate,Broker_Consultant_Rep__c,Sale_Origin_Destination__c,AgVantage_Acting_as__c,Business_Credited_to__c,Contract_Number__c,Commodity__c,Commission_Rate_Unit__c,Commission_Rate_Unit_Buyer__c,Crop_Year__c,Tolerance__c,Premium__c,Discount__c,Increments__c,Payment_Terms__c,GST_Type__c,Vendor_Declarations__c,Contract_Date__c,Transaction_Type__c FROM Opportunity WHERE Commodity__c != NULL ORDER BY Id DESC limit 1];   

     String recordId=obj.Id;
     obj.Id=null;
                            
     TradeEditRecord.saveData(JSON.serialize(obj),recordId);     
      TradeEditRecord.getData(recordId,'990850');                        
 }    
    }