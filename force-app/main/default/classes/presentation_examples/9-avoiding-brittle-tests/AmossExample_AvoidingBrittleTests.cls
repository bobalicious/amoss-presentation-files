@isTest
public with sharing class AmossExample_AvoidingBrittleTests {

    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );


    @isTest
    public static void inherentlyBrittleTest() {

        //
        // If we check everything, then the test becomes brittle.
        // Any change to class named, method names, parameter names, processing order, will cause this test to pass.
        // We have swapped out complexity of setup with complexity of maintenance.
        //
        // That's OK, if it's a good trade-off.
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
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
        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }



    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_singleTestStubWithParameterChecking() {

        // Configure a Test Stub for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .when( 'canDeliver' )
                .withParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
                .andParameterNamed( 'postcode' ).setTo( deliveryPostcode )
                .willReturn( true )
            .also()
            .when( 'canDeliver' ).willReturn( false )
            .also()
            .when( 'scheduleDelivery' ).willReturn( true );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }






    @isTest
    public static void ifDeliveryCannotBeMadeItIsNotBooked_singleTestStub() {

        // Configure a Test Stub for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .when( 'canDeliver' ).willReturn( false );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        System.assertEquals( false, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery cannot be scheduled, will return false' );
    }





    @isTest
    public static void ifProviderThrowsAnException_singleTestStub() {

        // Configure a Test Stub for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .when( 'canDeliver' ).willThrow( new AmossExample_DeliveryProvider.DeliveryProviderException( 'something went wrong working out if we can deliver' ) );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean exceptionThrown = false;
            Boolean scheduleDeliveryResponse;

            try {
                scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );
            } catch ( Exception e ) {
                exceptionThrown = true;
            }

        Test.stopTest();

        System.assertEquals( false, exceptionThrown         , 'scheduleDelivery, when a delivery provider throws an exception, stops it from propogating' );
        System.assertEquals( false, scheduleDeliveryResponse, 'scheduleDelivery, when a delivery provider throws an exception, will return false' );
    }






    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_multipleTestStubs() {

        // A Stub Delivery Provider that cannot deliver
        //
        Amoss_Instance cannotDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        cannotDeliverController
            .when( 'canDeliver' ).willReturn( false );
        AmossExample_DeliveryProvider cannotDeliver = (AmossExample_DeliveryProvider)cannotDeliverController.generateDouble();

        // A Stub Delivery Provider that can deliver
        //
        Amoss_Instance canDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        canDeliverController
            .when( 'canDeliver' ).willReturn( true )
            .also()
            .when( 'scheduleDelivery' ).willReturn( true );
        AmossExample_DeliveryProvider canDeliver = (AmossExample_DeliveryProvider)canDeliverController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery(
                                                    new List<AmossExample_DeliveryProvider>{
                                                        cannotDeliver, canDeliver
                                                    }
                                                );

        Test.stopTest();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }
}