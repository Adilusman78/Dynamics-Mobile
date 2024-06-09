query 84313 DYM_DAO_WH_TransShipHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whTransShipheader';
    EntitySetName = 'whTransShipHeaders';

    elements
    {
    dataitem(TransShipHeader;
    "Transfer Shipment Header")
    {
    column(externalDocumentNo;
    "External Document No.")
    {
    }
    column(inTransitCode;
    "In-Transit Code")
    {
    }
    column(no;
    "No.")
    {
    }
    column(postingDate;
    "Posting Date")
    {
    }
    column(shipmentDate;
    "Shipment Date")
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
    column(transferOrderDate;
    "Transfer Order Date")
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
