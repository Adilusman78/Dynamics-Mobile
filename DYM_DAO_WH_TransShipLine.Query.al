query 84314 DYM_DAO_WH_TransShipLine
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whTransShipLine';
    EntitySetName = 'whTransShipLines';

    elements
    {
    dataitem(TransShipLine;
    "Transfer Shipment Line")
    {
    column(documentNo;
    "Document No.")
    {
    }
    column(itemNo;
    "Item No.")
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
    column(itemShptEntryNo;
    "Item Shpt. Entry No.")
    {
    }
    column(quantity;
    Quantity)
    {
    }
    column(qtyPerUnitOfMeasure;
    "Qty. per Unit of Measure")
    {
    }
    column(inTransitCode;
    "In-Transit Code")
    {
    }
    column(shipmentDate;
    "Shipment Date")
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
