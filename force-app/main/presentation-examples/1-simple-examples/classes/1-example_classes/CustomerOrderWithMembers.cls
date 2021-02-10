@isTest
public with sharing class CustomerOrderWithMembers {

    String postcode;
    Date   deliveryDate;
    List<DeliveryProvider> deliveryProviders = new List<DeliveryProvider>();

    public Boolean scheduleDelivery() {

        try {
            for ( DeliveryProvider thisDeliveryProvider : deliveryProviders ) {
                if ( thisDeliveryProvider.canDeliver( postcode, deliveryDate ) ) {
                    return thisDeliveryProvider.scheduleDelivery( postcode, deliveryDate );
                }
            }
        } catch( DeliveryProvider.DeliveryProviderException e ) {
            // maybe we would log something here, or similar
        }

        return false;
    }

    public CustomerOrderWithMembers addDeliveryProvider( DeliveryProvider deliveryProvider ) {
        deliveryProviders.add( deliveryProvider );
        return this;
    }

    public CustomerOrderWithMembers setPostcode( String postcode ) {
        this.postcode = postcode;
        return this;
    }

    public CustomerOrderWithMembers setDeliveryDate( Date deliveryDate ) {
        this.deliveryDate = deliveryDate;
        return this;
    }
}