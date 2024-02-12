@IsTest
private class QuickCottonLookupControllerTest {
    @IsTest
    static void testQuickCottonLookupController() {

        String searchKey = 'Test';
        String objectName = 'Account';
        String searchField = 'Name';

        QuickCottonLookupController.QuickCottonLookupController(searchKey, objectName, searchField, 'Test Random String');
        QuickCottonLookupController.TfSiteFilter(searchKey, objectName, searchField);  
        }
    }