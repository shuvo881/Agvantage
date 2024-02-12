@IsTest(seeAllData=true)
private class TfObjectLookupControllerTest {
    @IsTest
    static void testTfObjectLookupController() {

        
        Account acc= [select Id from Account limit 1];
        
        String searchKey = 'Test';
        String objectName = 'Account';
        String searchField = 'Name';
        //String buyerId = '0012x00000EMV1sAAH';

        TfObjectLookupController.TfObjectLookupController(searchKey, objectName, searchField, 'Test Random String');
       // String searchKey, String objectName, String searchField, String rand, String buyerId
          TfObjectLookupController.TfContactWithBuyerName(searchKey, objectName, searchField,'001254',acc.Id);  
        
        }
    }