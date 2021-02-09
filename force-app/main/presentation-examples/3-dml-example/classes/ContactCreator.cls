public with sharing class ContactCreator {

    SimpleDml databaseWriter = new SimpleDml();

    public class CouldNotUpsertContactsException extends Exception {}

    //
    // A really trivial exampe of the kind of thing we might do
    // We perform some processing, and then create some data
    //
    public List<Contact> createContacts( List<String> lastNames ) {

        List<Contact> contacts = new List<Contact>();
        for( String thisLastName : lastNames ) {
            contacts.add( new Contact( LastName = thisLastName ) );
        }

        try {
            databaseWriter.upsertRecords( contacts );
        } catch ( DmlException e ) {
            // In reality things may not be as simple as this, but it serves as an example
            throw new CouldNotUpsertContactsException( 'There was an issue creating the contacts. ' + e.getMessage() );
        }
        return contacts;
    }

    // If you want to use mocking, but don't want to go fully fledged 'dependency injection'
    // and 'object registers', then you'll probably find this kind of method quite common.
    //
    // You allow tests to overwrite member variables, without exposing the internal structure
    // to the tests, or allowing non-test methods to change the configuration of the object.
    @testVisible
    private ContactCreator setDatabaseWriter( SimpleDml databaseWriter ) {
        this.databaseWriter = databaseWriter;
        return this;
    }
}