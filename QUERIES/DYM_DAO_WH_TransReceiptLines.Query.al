query 70146 DYM_DAO_WH_TransReceiptLines
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whTransReceiptLine';
    EntitySetName = 'whTransReceiptLines';

    elements
    {
        dataitem(TransferReceiptLine;
        "Transfer Receipt Line")
        {
            column(qtyPerUnitOfMeasure;
            "Qty. per Unit of Measure")
            {
            }
            column(quantity;
            Quantity)
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
            column(unitOfMeasureCode;
            "Unit of Measure Code")
            {
            }
            column(itemRcptEntryNo;
            "Item Rcpt. Entry No.")
            {
            }
            column(itemNo;
            "Item No.")
            {
            }
            column(documentNo;
            "Document No.")
            {
            }
            column(receiptDate;
            "Receipt Date")
            {
            }
            column(inTransitCode;
            "In-Transit Code")
            {
            }
            column(shippingAgentCode;
            "Shipping Agent Code")
            {
            }
            column(shippingAgentServiceCode;
            "Shipping Agent Service Code")
            {
            }
            column(shortcutDimension1Code;
            "Shortcut Dimension 1 Code")
            {
            }
            column(shortcutDimension2Code;
            "Shortcut Dimension 2 Code")
            {
            }
            column(transferOrderNo;
            "Transfer Order No.")
            {
            }
            column(transferFromCode;
            "Transfer-from Code")
            {
            }
            column(transferToCode;
            "Transfer-to Code")
            {
            }
        }
    }
}
