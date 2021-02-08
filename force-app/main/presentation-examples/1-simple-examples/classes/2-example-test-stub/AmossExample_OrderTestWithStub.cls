@isTest
public with sharing class AmossExample_OrderTestWithStub {

    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );

    @isTest
    public static void theSimplestStub() {

        // How we configure the simplest possible stub
        // Every method will return null
        //
        // First we create a controller - the thing we use to describe our Test Double
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );

        // And then use it to generate our Test Double
        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.generateDouble();

        // Though, obviously that on its own is not really that useful, we'll normally want to specify some behaviour too...
    }





    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_singleTestStub() {

        // Configure a Test Stub for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .when( 'canDeliver' ).willReturn( true )
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
    public static void ifDeliveryCanBeMadeItIsBooked_singleTestStubWithParameterChecking() {

        // Configure a Test Stub for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .when( 'canDeliver' )
                .withParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
                .andParameterNamed( 'deliveryPostcode' ).setTo( deliveryPostcode )
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

        System.assertEquals( false, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery cannot be scheduled, will return false' );
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