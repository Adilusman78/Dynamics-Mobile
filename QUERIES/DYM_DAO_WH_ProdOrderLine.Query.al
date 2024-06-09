query 70137 DYM_DAO_WH_ProdOrderLine
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whProdOrderLine';
    EntitySetName = 'whProdOrderLines';

    elements
    {
        dataitem(ProdOrderLine;
        "Prod. Order Line")
        {
            column(status;
            Status)
            {
            }
            column(prodOrderNo;
            "Prod. Order No.")
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
            column(quantity;
            "Quantity")
            {
            }
            column(quantityBase;
            "Quantity (Base)")
            {
            }
            column(unitofMeasureCode;
            "Unit of Measure Code")
            {
            }
            column(finishedQuantity;
            "Finished Quantity")
            {
            }
            column(finishedQtyBase_;
            "Finished Qty. (Base)")
            {
            }
            column(remainingQuantity;
            "Remaining Quantity")
            {
            }
            column(remainingQtyBase_;
            "Remaining Qty. (Base)")
            {
            }
        }
    }
}
