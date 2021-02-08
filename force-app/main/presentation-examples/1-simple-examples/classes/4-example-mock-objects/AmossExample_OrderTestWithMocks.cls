@isTest
public with sharing class AmossExample_OrderTestWithMocks {

    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );

    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_singleMock() {

        // Mocks are characterised by the use of 'expects', and 'then'
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .expects( 'canDeliver' ).returning( true )
            .then()
            .expects( 'scheduleDelivery' ).returning( true );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        // We check that the expected call stack is empty
        deliveryProviderController.verify();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }

    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_multiplMocks() {

        Amoss_Instance cannotDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        cannotDeliverController
            .expects( 'canDeliver' ).returning( false );

        AmossExample_DeliveryProvider cannotDeliver = (AmossExample_DeliveryProvider)cannotDeliverController.generateDouble();

        Amoss_Instance canDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        canDeliverController
            .expects( 'canDeliver' ).returning( true )
            .then()
            .expects( 'scheduleDelivery' ).returning( true );

        AmossExample_DeliveryProvider canDeliver = (AmossExample_DeliveryProvider)canDeliverController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ cannotDeliver, canDeliver } );

        Test.stopTest();

        // We check that the expected call stack is empty
        cannotDeliverController.verify();
        canDeliverController.verify();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

    }

    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_mixingMockAndStubBehaviour() {

        Amoss_Instance cannotDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        cannotDeliverController
            .when( 'canDeliver' ).returns( false );

        AmossExample_DeliveryProvider cannotDeliver = (AmossExample_DeliveryProvider)cannotDeliverController.generateDouble();

        // We can call canDeliver as many times as we want, or not at all
        // but scheduleDelivery must be called exactly once
        //
        // Be careful when mising the behaviour for a single method - it may not do what you think it does (yet)
        //
        Amoss_Instance canDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        canDeliverController
            .when( 'canDeliver' ).returns( true )
            .also()
            .expects( 'scheduleDelivery' ).returning( true );

        AmossExample_DeliveryProvider canDeliver = (AmossExample_DeliveryProvider)canDeliverController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );
            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ cannotDeliver, canDeliver } );

        Test.stopTest();

        // We check that the expected call stack is empty
        cannotDeliverController.verify();
        canDeliverController.verify();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

    }
}