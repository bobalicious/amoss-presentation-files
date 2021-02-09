@isTest
public with sharing class CraftMockExample_CalloutAccountTest {

    @isTest
    public static void testWithCraftMock() {

        // An example using Nikita Chursin's SalesforceCraft Mock Http Server library, for comparison
        // https://github.com/nchursin/sfcraft-mock-server

        // First we create a 'resource' - the thing that we will 'call', settings its response
        sfcraft_MockAPIResource resource = new sfcraft_MockAPIResource();
        resource.setResponse(
            'GET',
            200,
            '[{"Name":"sForceTest1"}]'
        );

        // Then we create a 'server' that ties an endpoint to that resource
        // We could do this many times with different resources, if we wanted to.
        sfcraft_MockServer server = new sfcraft_MockServer();
        server.addEndpoint( 'http://api.example.com/accounts', resource );
        server.setAsMock();

        Test.startTest();
            List<Account> returnedAccounts = CalloutAccounts.getAccounts();
        Test.stopTest();

        System.assertEquals( 'sForceTest1', returnedAccounts[0].Name, 'getAccounts will call the HTTP Service and deserialise the resulting JSON into a List of Accounts' );
    }
}