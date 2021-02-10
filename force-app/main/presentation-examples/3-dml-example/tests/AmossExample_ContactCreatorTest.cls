@isTest
public with sharing class AmossExample_ContactCreatorTest {

    @isTest
    public static void successfullyUpsertingWithoutIssuingAnyDml() {

        List<String> namesToPassIn = new List<String>{
            'Name1', 'Name2', 'Name3', 'Name4'
        };

        Amoss_Instance dmlController = new Amoss_Instance( SimpleDml.class );

        dmlController
            .expects( 'upsertRecords' )
            .withParameterNamed( 'objectsToUpsert' )
                .withElementAt( 0 ).withFieldsSetTo( new Map<String,Object>{ 'LastName' => namesToPassIn[0] } )
                .withElementAt( 1 ).withFieldsSetTo( new Map<String,Object>{ 'LastName' => namesToPassIn[1] } )
                .withElementAt( 2 ).withFieldsSetTo( new Map<String,Object>{ 'LastName' => namesToPassIn[2] } )
                .withElementAt( 3 ).withFieldsSetTo( new Map<String,Object>{ 'LastName' => namesToPassIn[3] } );

        Test.startTest();

            ContactCreator creator = new ContactCreator()
                                        .setDatabaseWriter( (SimpleDml)dmlController.generateDouble() );

            List<Contact> createdContacts = creator.createContacts( namesToPassIn );

        Test.stopTest();

        dmlController.verify();  // this checks that we send the contacts to be created

        // Then we can assert things about the contacts we get returned.
        // But we don't have to do any SOQL, and the test is very fast.
        //
        // However, since we never insert anything, we aren't checking that the Contacts can
        // actually be created - it's dangerous to *always* do this.
    }

    @isTest
    public static void testingDmlExceptions() {

        List<String> unimportantNames = new List<String>{ 'Name1' };

        Amoss_Instance dmlController = new Amoss_Instance( SimpleDml.class );

        dmlController
            .expects( 'upsertRecords' )
            .throwing( new DmlException( 'This might be almost impossible to have happen otherwise' ) );

        Test.startTest();

            ContactCreator creator = new ContactCreator()
                                        .setDatabaseWriter( (SimpleDml)dmlController.generateDouble() );

            String  exceptionMessage;
            try {
                List<Contact> createdContacts = creator.createContacts( unimportantNames );
            } catch( ContactCreator.CouldNotUpsertContactsException e ) {
                exceptionMessage = e.getMessage();
            }

        Test.stopTest();

        dmlController.verify();  // this checks that upsertRecords was called

        Amoss_Asserts.assertContains( 'There was an issue creating the contacts', exceptionMessage, 'When the DML throws an exception, it is rethrown with a useful message' );

    }
}
