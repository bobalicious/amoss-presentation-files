@isTest
public with sharing class CustomerOrder {

    String postcode;
    Date   deliveryDate;

    //
    // This is the method we want to test
    //
    public Boolean scheduleDelivery( List<DeliveryProvider> deliveryProviders ) {

        //
        // It attempts to schedule delivery of this order, using the passed in delivery providers.
        //
        try {
            //
            // It does so by looping over the delivery providers it has been given
            //
            for ( DeliveryProvider thisDeliveryProvider : deliveryProviders ) {
                //
                // It asks each one in turn if it can deliver, based on the postcode and delivery date
                // of the current order
                //
                if ( thisDeliveryProvider.canDeliver( postcode, deliveryDate ) ) {
                    //
                    // If the provider says it can, then it is asked to schedule the delivery.
                    // The result is then returned.
                    //
                    return thisDeliveryProvider.scheduleDelivery( postcode, deliveryDate );
                }
            }
        } catch( DeliveryProvider.DeliveryProviderException e ) {
            //
            // If any of the providers throw an exception at any point
            // then maybe something is logged somewhere... we don't worry about that for this example
            // but it's exactly the kind of thing we'd want to test
            //
        }

        return false;
    }

    public CustomerOrder setPostcode( String postcode ) {
        this.postcode = postcode;
        return this;
    }

    public CustomerOrder setDeliveryDate( Date deliveryDate ) {
        this.deliveryDate = deliveryDate;
        return this;
    }
}