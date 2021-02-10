@isTest
public with sharing class AmossExample_Capabilities {

    @isTest
    private static void comparingToObjectsCanCheckValueEqualityOrInstanceEquality() {

        Amoss_Instance controller = new Amoss_Instance( CustomerOrder.class );

        Contact contactToMatch = new Contact( FirstName = 'example' );

        controller
            .when( 'exampleMethod' )
                //
                // Useful for checking that the right instance is passed in
                // so it can be mutated.
                // Available for all object types.
                //
                .withParameterNamed( 'matchesIfTheSameValue' ).setTo( contactToMatch )
                //
                // Useful for checking the construction of things that are passed in.
                // Available for all object types.
                //
                .andParameterNamed( 'matchesIfTheSameInstance').setToTheSameValueAs( contactToMatch )
                //
                // Useful for checking that SObject fields get set in particular ways.
                // Available for SObjects
                //
                .andParameterNamed( 'matchesIfAllFieldsSetToSameValue' ).withFieldsSetLike( new Contact( FirstName = 'example' ) )
                //
                // Useful for checking that SObject fields get set in particular ways when SObjects are clunky to build.
                // Available for SObjects
                //
                .andParameterNamed( 'matchesIfAllFieldsSetToSameValueAsMap' ).withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'example' } );
    }

    @isTest
    private static void comparingToListsCanCheckPropertiesOfTheListElements() {

        Amoss_Instance controller = new Amoss_Instance( CustomerOrder.class );

        controller
            //
            // Can check that a list is constructed with particular values in
            // particular elements.
            //
            .when( 'exampleMethod' )
                .withParameterNamed( 'listParameter' )
                    .withElementAt( 0 ).setTo( 'aParticularValue' )
                    .withElementAt( 1 ).setTo( 'anotherParticularValue' )
            //
            // Can check that a list is constructed with particular values in
            // ANY of the elements.
            //
            .also().when( 'exampleMethod' )
                .withParameterNamed( 'listParameter' )
                    .withAnyElement().setTo( 'aValueToLookFor' )

            //
            // Can check that a list is constructed with particular values in
            // ALL of the elements.
            //
            .also().when( 'exampleMethod' )
                .withParameterNamed( 'listParameter' )
                    .withAllElements().setTo( 'theSameValue' )

            //
            // All elements is more useful when you use other comparisons - any can be used.
            // For example, checking that all the passed Contacts are PersonAccounts
            //
            .also().when( 'exampleMethod' )
                .withParameterNamed( 'listParameter' )
                    .withAllElements().withFieldsSetTo( new Map<String,Object>{ 'IsPersonAccount' => true } )

            //
            // And all the comparisons can be combined
            //
            .also().when( 'exampleMethod' )
            .withParameterNamed( 'listParameter' )
                .withAllElements().withFieldsSetTo( new Map<String,Object>{ 'IsPersonAccount' => true } )
                .withElementAt( 0 ).withFieldsSetTo( new Map<String,Object>{ 'Some_Property__c' => 15 } )
                .withElementAt( 1 ).withFieldsSetTo( new Map<String,Object>{ 'Some_Property__c' => 11 } )
                .withElementAt( 2 ).withFieldsSetTo( new Map<String,Object>{ 'Some_Property__c' => 10 } );
    }

    @isTest
    private static void exceptionsCanBeThrown() {

        Amoss_Instance controller = new Amoss_Instance( CustomerOrder.class );

        controller
        //
        // Can be configured to throw exceptions.
        //
        .when( 'exampleMethod' )
            .willThrow( new DmlException( 'Exception that might otherwise be hard to generate' ) )

        //
        // Using, parameter matching, can be configured do that only in certain circumstances
        //
        .also().when( 'exampleMethod' )
            .withParameterNamed( 'parameterName' ).setTo( 'onlyInParticularCircumstances' )
            .willThrow( new DmlException( 'Exception that might otherwise be hard to generate' ) );
    }

    @isTest
    private static void canCreateAStubThatWillFailWhateverIsCalledAgainstIt() {

        Amoss_Instance controller = new Amoss_Instance( CustomerOrder.class );
        controller.expectsNoCalls();
    }
}
