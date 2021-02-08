public with sharing class ExampleUsageOfProductCanceller {

    public ExampleUsageOfProductCanceller() {

        List<OpportunityLineItem> lineItemsToCancel = new OpportunityProductCanceller()
                                                            .setDateOfCancellation( System.now() )
                                                            .setProductsDataSource(
                                                                new UnfulfilledOpportunityProductDataSource()
                                                                    .setOpportunityIds( new Set<Id>() ) // obviously, this would have Ids passed in
                                                            )
                                                            .process()
                                                            .getProductsToUpdate();

        update lineItemsToCancel;
    }
}
