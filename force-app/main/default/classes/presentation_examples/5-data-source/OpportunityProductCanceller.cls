public with sharing class OpportunityProductCanceller {

    private DateTime dateOfCancellation = System.now();
    private OpportunityProductDataSource opportunityProductsDataSource;

    public OpportunityProductCanceller process() {

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

    private List<OpportunityLineItem> opportunityProductsToUpdate {
        get {
            if ( opportunityProductsToUpdate == null ) {
                opportunityProductsToUpdate = opportunityProductsDataSource.getProducts();
            }
            return opportunityProductsToUpdate;
        }
        set;
    }
}