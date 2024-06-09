query 70145 DYM_DAO_WH_TransReceiptHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whTransReceiptHeader';
    EntitySetName = 'whTransReceiptHeaders';

    elements
    {
        dataitem(TransferReceiptHeader;
        "Transfer Receipt Header")
        {
            column(externalDocumentNo;
            "External Document No.")
            {
            }
            column(no;
            "No.")
            {
            }
            column(receiptDate;
            "Receipt Date")
            {
            }
            column(shipmentDate;
            "Shipment Date")
            {
            }
            column(inTransitCode;
            "In-Transit Code")
            {
            }
            column(shipmentMethodCode;
            "Shipment Method Code")
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
            column(transferFromName;
            "Transfer-from Name")
            {
            }
            column(transferToCode;
            "Transfer-to Code")
            {
            }
            column(transferToName;
            "Transfer-to Name")
            {
            }
        }
    }
}
