@isTest
public with sharing class AmossExample_AvoidingBrittleTests {

    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );

    @isTest
    public static void inherentlyBrittleTest() {

        //
        // If we check everything, then the test becomes brittle.
        // Any change to class named, method names, parameter names, processing order, will cause this test to fail.
        // We have swapped out complexity of setup / dependency with complexity of maintenance.
        //
        // That's OK, if it's a good trade-off - but we only want to do it if we get a payback for it.
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
        deliveryProviderController
            .expects( 'canDeliver' )
                .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
                .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
                .returning( true )
            .then()
            .expects( 'scheduleDelivery' )
                .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
                .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
                .returns( true );
        DeliveryProvider deliveryProvider = (DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            CustomerOrder order = new CustomerOrder()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }
}