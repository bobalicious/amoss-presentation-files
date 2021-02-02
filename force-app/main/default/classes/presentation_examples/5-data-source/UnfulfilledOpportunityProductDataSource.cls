public with sharing class UnfulfilledOpportunityProductDataSource implements OpportunityProductDataSource {

    private Set<Id> opportunityIds;

    public UnfulfilledOpportunityProductDataSource setOpportunityIds( Set<Id> opportunityIds ) {
        this.opportunityIds = opportunityIds;
        return this;
    }

    public List<OpportunityLineItem> getProducts() {
        List<OpportunityLineItem> products = new List<OpportunityLineItem>();
        for ( OpportunityLineItem thisOpportunityProduct : [SELECT Id
                                                            FROM   OpportunityLineItem
                                                            WHERE  OpportunityId     IN :opportunityIds
                                                            AND    Fulfilment_Status__c != 'Fulfilled' ] ) {
            products.add( thisOpportunityProduct );
        }
        return products;
    }
}
