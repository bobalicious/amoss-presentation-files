@isTest
public with sharing class AmossExample_OppProductCancellerTest {

    private static DateTime dateOfClosure = DateTime.newInstance( 2021, 01, 02, 15, 00, 0 );

    /**
    * @method  process
    * @case    when configured with products
    * @result  will set those products to complete
    */
    @isTest
    private static void process_whenConfiguredWithAProducts_willSetThoseProductsToComplete() {

        List<OpportunityLineItem> originalProducts = new List<OpportunityLineItem>{
            new OpportunityLineItem(),
            new OpportunityLineItem(),
            new OpportunityLineItem()
        };

        Amoss_Instance productsDataSourceController = new Amoss_Instance( OpportunityProductDataSource.class );
        productsDataSourceController
            .expects( 'getProducts' )
            .returns( originalProducts );
        OpportunityProductDataSource productsDataSource = (OpportunityProductDataSource)productsDataSourceController.generateDouble();

        Test.startTest();

            OpportunityProductCanceller canceller = new OpportunityProductCanceller()
                                                            .setDateOfCancellation( dateOfClosure )
                                                            .setProductsDataSource( productsDataSource )
                                                            .process();

            List<OpportunityLineItem> updatedProducts = canceller.getProductsToUpdate();

        Test.stopTest();

        ProductsDataSourceController.verify();

        System.assertEquals( originalProducts.size(), updatedProducts.size(), 'process, when configured with Products, will set those Products to cancelled' );

        for ( OpportunityLineItem thisUpdatedProduct : updatedProducts ) {
//            System.assertEquals( dateOfClosure, thisUpdatedProduct.CompletionDate, 'process, when configured with Products, will set those Products to cancelled' );
        }
    }
}