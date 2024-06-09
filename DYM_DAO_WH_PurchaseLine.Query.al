query 84303 DYM_DAO_WH_PurchaseLine
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whPurchaseLine';
    EntitySetName = 'whPurchaseLines';

    elements
    {
    dataitem(PurchaseLine;
    "Purchase Line")
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
    column(qtytoReceive;
    "Qty. to Receive")
    {
    }
    column(qtytoReceiveBase;
    "Qty. to Receive (Base)")
    {
    }
    column(quantityReceived;
    "Quantity Received")
    {
    }
    column(qtyReceivedBase;
    "Qty. Received (Base)")
    {
    }
    column(lineNo;
    "Line No.")
    {
    }
    column(outstandingQuantity;
    "Outstanding Quantity")
    {
    }
    column(description;
    Description)
    {
    }
    column(overReceiptQuantity;
    "Over-Receipt Quantity")
    {
    }
    column(overReceiptCode;
    "Over-Receipt Code")
    {
    }
    column(overReceiptApprovalStatus;
    "Over-Receipt Approval Status")
    {
    }
    }
    }
}
