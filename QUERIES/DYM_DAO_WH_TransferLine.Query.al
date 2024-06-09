query 70144 DYM_DAO_WH_TransferLine
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whTransferLine';
    EntitySetName = 'whTransferLines';

    elements
    {
        dataitem(TransferLine;
        "Transfer Line")
        {
            column(documentNo;
            "Document No.")
            {
            }
            column(lineNo;
            "Line No.")
            {
            }
            column(derivedFromLineNo;
            "Derived From Line No.")
            {
            }
            column(itemNo;
            "Item No.")
            {
            }
            column(variantCode;
            "Variant Code")
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
            column(outstandingQuantity;
            "Outstanding Quantity")
            {
            }
            column(outstandingQtyBase;
            "Outstanding Qty. (Base)")
            {
            }
            column(qtyinTransit;
            "Qty. in Transit")
            {
            }
            column(qtyinTransitBase;
            "Qty. in Transit (Base)")
            {
            }
            column(transferFromBinCode;
            "Transfer-from Bin Code")
            {
            }
            column(transferToBinCode;
            "Transfer-To Bin Code")
            {
            }
        }
    }
}
