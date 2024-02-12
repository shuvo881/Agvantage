@isTest
global with sharing class ListViewRecordsControllerMockTest implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String mockResponse = '{'+
                                '"listviews": ['+
                                    '{'+
                                        '"label": "All Contacts",'+
                                        '"id": "00B96000000TWIeEAO",'+
                                        '"Contact": "Contact"'+
                                    '},'+
                                    '{'+
                                        '"label": "Recent Contacts",'+
                                        '"id": "00B96000000TWIeEAP",'+
                                        '"Contact": "Contact"'+
                                    '}'+
                                ']'+
                              '}';
        response.setBody(mockResponse);
        response.setStatusCode(200);
        return response; 
    }

    
}