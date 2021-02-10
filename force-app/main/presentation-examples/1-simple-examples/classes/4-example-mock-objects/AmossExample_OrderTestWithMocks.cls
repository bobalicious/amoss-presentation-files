@isTest
public with sharing class AmossExample_OrderTestWithMocks {

    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );


// Add a little text to the slide to say why - order of things...

    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_singleMock() {

        // Mocks are characterised by the use of 'expects', and 'then'
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
        deliveryProviderController
            .expects( 'canDeliver' ).returning( true )
            .then()
            .expects( 'scheduleDelivery' ).returning( true );

        DeliveryProvider deliveryProvider = (DeliveryProvider)deliveryProviderController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        // We check that the expected call stack is empty
        deliveryProviderController.verify();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }









    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_multipleMocks() {

        Amoss_Instance cannotDeliverController = new Amoss_Instance( DeliveryProvider.class );
        cannotDeliverController
            .expects( 'canDeliver' ).returning( false );

        DeliveryProvider cannotDeliver = (DeliveryProvider)cannotDeliverController.generateDouble();

        Amoss_Instance canDeliverController = new Amoss_Instance( DeliveryProvider.class );
        canDeliverController
            .expects( 'canDeliver' ).returning( true )
            .then()
            .expects( 'scheduleDelivery' ).returning( true );

        DeliveryProvider canDeliver = (DeliveryProvider)canDeliverController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<DeliveryProvider>{ cannotDeliver, canDeliver } );

        Test.stopTest();

        // We check that the expected call stack is empty
        cannotDeliverController.verify();
        canDeliverController.verify();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

    }

    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_mixingMockAndStubBehaviour() {

        Amoss_Instance cannotDeliverController = new Amoss_Instance( DeliveryProvider.class );
        cannotDeliverController
            .when( 'canDeliver' ).returns( false );

        DeliveryProvider cannotDeliver = (DeliveryProvider)cannotDeliverController.generateDouble();

        // We can call canDeliver as many times as we want, or not at all
        // but scheduleDelivery must be called exactly once
        //
        // Be careful when mising the behaviour for a single method - it may not do what you think it does (yet)
        //
        Amoss_Instance canDeliverController = new Amoss_Instance( DeliveryProvider.class );
        canDeliverController
            .when( 'canDeliver' ).returns( true )
            .also()
            .expects( 'scheduleDelivery' ).returning( true );

        DeliveryProvider canDeliver = (DeliveryProvider)canDeliverController.generateDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );
            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<DeliveryProvider>{ cannotDeliver, canDeliver } );

        Test.stopTest();

        // We check that the expected call stack is empty
        cannotDeliverController.verify();
        canDeliverController.verify();

        System.assertEquals( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

    }
}