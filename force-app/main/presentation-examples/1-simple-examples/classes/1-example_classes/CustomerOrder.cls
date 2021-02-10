/*
MIT License

Copyright (c) 2020 Robert Baillie

https://github.com/bobalicious/amoss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

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