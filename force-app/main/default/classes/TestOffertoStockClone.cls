@isTest(seeAllData=true)
public class TestOffertoStockClone {
    
    @isTest
    static void testStockToOffer_Success() {
        Account acc = [Select Id from Account LIMIT 1];
        Tolerance__c tol = [Select Id from Tolerance__c LIMIT 1];
        AS_Commodity_Dest_for_Stock__c com = [Select Id, Stock__c from AS_Commodity_Dest_for_Stock__c Where Stock__c != null LIMIT 1];
        Stock__c testStock = [Select Id, Quantity__c, Price_Offered__c, Account__c, Delivery_Terms__c, Tolerance__c, Sale_Origin_Destination__c from Stock__c where Id =: com.Stock__c LIMIT 1];
        testStock.Id= null ;
        testStock.Account__c = acc.Id;
        testStock.Tolerance__c = tol.Id;
        testStock.Delivery_Terms__c = 'Delivered' ;
        testStock.Sale_Origin_Destination__c = 'Delivered' ;
        insert testStock;

        OffertoStockClone.stockToOffer(testStock.Id);
    }

        @isTest
        static void testStockClone() {
            Account acc = [Select Id from Account LIMIT 1];
            Tolerance__c tol = [Select Id from Tolerance__c LIMIT 1];
            Available_Stock__c testStock1 = [Select Id, Quantity__c, Price_Offered__c, Account__c, Delivery_Terms__c, Tolerance__c, Sale_Origin_Destination__c from Available_Stock__c LIMIT 1];
            testStock1.Id= null ;
            testStock1.Account__c = acc.Id;
            testStock1.Tolerance__c = tol.Id;
            testStock1.Delivery_Terms__c = 'Delivered' ;
            testStock1.Sale_Origin_Destination__c = 'Delivered' ;
            insert testStock1;
    
            OffertoStockClone.offerToStock(testStock1.Id);
           try {
            OffertoStockClone.offerToStock('testStock1.Id');
           } catch (Exception e) {
            
           }

        }
    }