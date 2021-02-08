public with sharing class OpportunityProductCanceller {

    private DateTime dateOfCancellation = System.now();
    private OpportunityProductDataSource opportunityProductsDataSource;
    private List<OpportunityLineItem> opportunityProductsToUpdate;

    public OpportunityProductCanceller process() {

        opportunityProductsToUpdate = opportunityProductsDataSource.getProducts();

        for ( OpportunityLineItem thisProduct : opportunityProductsToUpdate ) {
            thisProduct.Fulfilment_Status__c = 'Cancelled';
            thisProduct.Cancelled_On__c      = dateOfCancellation;
        }
        return this;
    }

    public List<OpportunityLineItem> getProductsToUpdate() {
        return opportunityProductsToUpdate;
    }

    public OpportunityProductCanceller setProductsDataSource( OpportunityProductDataSource opportunityProductsDataSource ) {
        this.opportunityProductsDataSource = opportunityProductsDataSource;
        return this;
    }

    public OpportunityProductCanceller setDateOfCancellation( DateTime dateOfCancellation ) {
        this.dateOfCancellation = dateOfCancellation;
        return this;
    }




    public OpportunityProductCanceller processWithProtection() {

        opportunityProductsToUpdate = new List<OpportunityLineItem>();

        for ( OpportunityLineItem thisProduct : opportunityProductsDataSource.getProducts() ) {
            if ( thisProduct.Can_Be_Cancelled__c ) {
                thisProduct.Fulfilment_Status__c = 'Cancelled';
                thisProduct.Cancelled_On__c      = dateOfCancellation;
                opportunityProductsToUpdate.add( thisProduct );
            }
        }
        return this;
    }
}