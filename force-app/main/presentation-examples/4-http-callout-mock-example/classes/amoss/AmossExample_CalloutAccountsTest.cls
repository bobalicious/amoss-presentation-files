@isTest
public with sharing class AmossExample_CalloutAccountsTest {

    @isTest
    public static void testWithAmoss() {

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 200 );
        response.setStatus( 'Complete' );
        response.setBody( '[{"Name":"sForceTest1"}]' );

        Amoss_Instance httpCalloutMockController = new Amoss_Instance( AmossExample_MockableHttpCalloutMock.class );
        httpCalloutMockController
            .expects( 'respond' )
            .returning( response );
        Test.setMock( HttpCalloutMock.class, httpCalloutMockController.generateDouble() );

        Test.startTest();
            List<Account> returnedAccounts = CalloutAccounts.getAccounts();
        Test.stopTest();

        httpCalloutMockController.verify();

        HttpRequest passedRequest = (HttpRequest)httpCalloutMockController.get().latestCallOf('respond').parameter('request');
        System.assertEquals( 'GET'                            , passedRequest.getMethod()  , 'getAccounts will call the HTTP Service with a GET Request' );
        System.assertEquals( 'http://api.example.com/accounts', passedRequest.getEndpoint(), 'getAccounts will call the HTTP Service setting the endpoint' );

        System.assertEquals( 'sForceTest1', returnedAccounts[0].Name, 'getAccounts will call the HTTP Service and deserialise the resulting JSON into a List of Accounts' );
    }
}
