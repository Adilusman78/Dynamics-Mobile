query 70142 DYM_DAO_WH_SalesLine
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whSalesLine';
    EntitySetName = 'whSalesLines';

    elements
    {
        dataitem(SalesLine;
        "Sales Line")
        {
            column(documentType;
            "Document Type")
            {
            }
            column(documentNo;
            "Document No.")
            {
            }
            column("type";
            "Type")
            {
            }
            column(no;
            "No.")
            {
            }
            column(variantCode;
            "Variant Code")
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
            column(unitofMeasureCode;
            "Unit of Measure Code")
            {
            }
            column(unitofMeasure;
            "Unit of Measure")
            {
            }
            column(qtyperUnitofMeasure;
            "Qty. per Unit of Measure")
            {
            }
            column(quantity;
            Quantity)
            {
            }
            column(quantityBase;
            "Quantity (Base)")
            {
            }
            column(qtytoShip;
            "Qty. to Ship")
            {
            }
            column(qtytoShipBase;
            "Qty. to Ship (Base)")
            {
            }
            column(quantityShipped;
            "Quantity Shipped")
            {
            }
            column(qtyShippedBase;
            "Qty. Shipped (Base)")
            {
            }
            column(lineNo;
            "Line No.")
            {
            }
            column(description;
            Description)
            {
            }
            column(outstandingQuantity;
            "Outstanding Quantity")
            {
            }
        }
    }
}
