@isTest
public with sharing class AmossExample_OrderTestWithSpy {
    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );

    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_singleTestSpy() {

        // Configure a Test Spy for a single Delivery Provider
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

        // These assertions are the characteristic of a spy...
        System.assertEquals( deliveryPostcode, deliveryProviderController.get().call( 0 ).of( 'canDeliver' ).parameter( 'postcode' )    , 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the postcode' );
        System.assertEquals( deliveryDate    , deliveryProviderController.get().call( 0 ).of( 'canDeliver' ).parameter( 'deliveryDate' ), 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the delivery date' );

        System.assertEquals( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'postcode' )    , 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the postcode' );

        System.assertEquals( deliveryDate    , deliveryProviderController.get().call( -1 ).of( 'scheduleDelivery' ).parameter( 'deliveryDate' ), 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the delivery date' );

    }
}