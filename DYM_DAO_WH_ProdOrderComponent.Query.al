query 84321 DYM_DAO_WH_ProdOrderComponent
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whProdOrderComponent';
    EntitySetName = 'whProdOrderComponents';

    elements
    {
    dataitem(ProdOrderComponent;
    "Prod. Order Component")
    {
    column(status;
    Status)
    {
    }
    column(prodOrderNo;
    "Prod. Order No.")
    {
    }
    column(prodOrderLineNo;
    "Prod. Order Line No.")
    {
    }
    column(lineNo;
    "Line No.")
    {
    }
    column(itemNo;
    "Item No.")
    {
    }
    column(description;
    Description)
    {
    }
    column(unitofMeasureCode;
    "Unit of Measure Code")
    {
    }
    column(quantityper;
    "Quantity per")
    {
    }
    column(expectedQuantity;
    "Expected Quantity")
    {
    }
    column(expectedQtyBase;
    "Expected Qty. (Base)")
    {
    }
    column(remainingQuantity;
    "Remaining Quantity")
    {
    }
    column(remainingQtyBase;
    "Remaining Qty. (Base)")
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    column(binCode;
    "Bin Code")
    {
    }
    column(flushingMethod;
    "Flushing Method")
    {
    }
    }
    }
}
