@isTest
public with sharing class AmossExample_OppProductCancellerTest {

    private static DateTime dateOfCancellation = DateTime.newInstance( 2021, 01, 02, 15, 00, 0 );

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

            List<OpportunityLineItem> updatedProducts = new OpportunityProductCanceller()
                                                            .setDateOfCancellation( dateOfCancellation )
                                                            .setProductsDataSource( productsDataSource )
                                                            .process()
                                                            .getProductsToUpdate();

        Test.stopTest();

        ProductsDataSourceController.verify();

        System.assertEquals( originalProducts.size(), updatedProducts.size(), 'process, when configured with Products, will update all those products' );

        for ( OpportunityLineItem thisUpdatedProduct : updatedProducts ) {
            System.assertEquals( 'Cancelled'       , thisUpdatedProduct.Fulfilment_Status__c, 'process, when configured with Products, will set those Products to Cancelled' );
            System.assertEquals( dateOfCancellation, thisUpdatedProduct.Cancelled_On__c     , 'process, when configured with Products, will the cancellation date on the products' );
        }
    }


    /**
    * @method  process
    * @case    when configured with products
    * @result  will set those products to complete
    */
    @isTest
    private static void process_whenConfiguredWithAProducts_willSetThoseProductsToComplete_usingAFabricator() {

        /**
         * The processor references the Formula field 'Can_Be_Cancelled__c'
         *
         * ! ISPICKVAL( Fulfilment_Status__c, 'Fulfilled' )
         *
         */
        List<OpportunityLineItem> originalProducts = new List<OpportunityLineItem>{

            (OpportunityLineItem)new sfab_FabricatedSObject( OpportunityLineItem.class )
                .set( 'Can_Be_Cancelled__c', true )
                .toSobject(),

            (OpportunityLineItem)new sfab_FabricatedSObject( OpportunityLineItem.class )
                .set( 'Can_Be_Cancelled__c', false )
                .toSobject(),

            (OpportunityLineItem)new sfab_FabricatedSObject( OpportunityLineItem.class )
                .set( 'Can_Be_Cancelled__c', true )
                .toSobject()
        };

        Amoss_Instance productsDataSourceController = new Amoss_Instance( OpportunityProductDataSource.class );
        productsDataSourceController
            .expects( 'getProducts' )
            .returns( originalProducts );
        OpportunityProductDataSource productsDataSource = (OpportunityProductDataSource)productsDataSourceController.generateDouble();

        Test.startTest();

            OpportunityProductCanceller canceller = new OpportunityProductCanceller()
                                                            .setDateOfCancellation( dateOfCancellation )
                                                            .setProductsDataSource( productsDataSource )
                                                            .processWithProtection();

            List<OpportunityLineItem> updatedProducts = canceller.getProductsToUpdate();

        Test.stopTest();

        ProductsDataSourceController.verify();

        System.assertEquals( 2, updatedProducts.size(), 'process, when configured with Products, will update all those products that can be cancelled' );

        for ( OpportunityLineItem thisUpdatedProduct : updatedProducts ) {
            System.assertEquals( true              , thisUpdatedProduct.Can_Be_Cancelled__c , 'process, when configured with Products, will only update those Products that can be cancelled' );
            System.assertEquals( 'Cancelled'       , thisUpdatedProduct.Fulfilment_Status__c, 'process, when configured with Products, will set those Products that can be cancelled to Cancelled' );
            System.assertEquals( dateOfCancellation, thisUpdatedProduct.Cancelled_On__c     , 'process, when configured with Products, will set the cancellation date on the products that can be cancelled' );
        }
    }

}