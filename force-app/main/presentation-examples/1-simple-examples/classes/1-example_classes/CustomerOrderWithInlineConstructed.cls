@isTest
public with sharing class CustomerOrderWithInlineConstructed {

    String postcode;
    Date   deliveryDate;

    public Boolean scheduleDelivery() {

        //
        // This inline construction makes it impossible to use the mock framework
        //
        // Even if the construction is based on configuration.
        // The fact it is constructed inline, in a method variable, means we can't access it
        // and override it.
        //
        List<DeliveryProvider> deliveryProviders = new List<DeliveryProvider>{
            new DhlDeliveryProvider(),
            new UpsDeliveryProvider(),
            new YodelDeliveryProvider()
        };

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

    public CustomerOrderWithInlineConstructed setPostcode( String postcode ) {
        this.postcode = postcode;
        return this;
    }

    public CustomerOrderWithInlineConstructed setDeliveryDate( Date deliveryDate ) {
        this.deliveryDate = deliveryDate;
        return this;
    }

    public class DhlDeliveryProvider extends DeliveryProvider {
        public override Boolean canDeliver( String postcode, Date deliveryDate ) {
            return true;
        }
        public override Boolean scheduleDelivery( String postcode, Date deliveryDate ) {
            return true;
        }
    }

    public class UpsDeliveryProvider extends DeliveryProvider {
        public override Boolean canDeliver( String postcode, Date deliveryDate ) {
            return true;
        }
        public override Boolean scheduleDelivery( String postcode, Date deliveryDate ) {
            return true;
        }
    }

    public class YodelDeliveryProvider extends DeliveryProvider {
        public override Boolean canDeliver( String postcode, Date deliveryDate ) {
            return true;
        }
        public override Boolean scheduleDelivery( String postcode, Date deliveryDate ) {
            return true;
        }
    }
}