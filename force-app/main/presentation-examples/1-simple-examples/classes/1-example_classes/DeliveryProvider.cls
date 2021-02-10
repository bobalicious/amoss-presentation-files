public virtual class DeliveryProvider {
    public class DeliveryProviderException extends Exception {}
    public virtual Boolean canDeliver( String postcode, Date deliveryDate ) {
        return false;
    }
    public virtual Boolean scheduleDelivery( String postcode, Date deliveryDate ) {
        return false;
    }
}