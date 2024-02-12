@isTest(seeAllData=true)
public with sharing class ListViewRecordsControllerTest {
    
    @IsTest
    static void test1(){
        Test.setMock(HttpCalloutMock.class, new ListViewRecordsControllerMockTest());
        ListViewRecordsController.getContactsByListViewId();
        Test.setMock(HttpCalloutMock.class, new ListViewRecordsControllerMockTest());
        ListViewQueryQueueable.runCode(); 
    }
}