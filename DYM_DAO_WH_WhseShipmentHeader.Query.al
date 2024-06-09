query 84306 DYM_DAO_WH_WhseShipmentHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_whWhseShipmentHeader';
    EntitySetName = 'backup_whWhseShipmentHeaders';

    elements
    {
    dataitem(WarehouseShipmentHeader;
    "Warehouse Shipment Header")
    {
    column(no;
    "No.")
    {
    }
    column(mobileStatus;
    DYM_MobileStatus)
    {
    }
    column(mobileDevice;
    DYM_MobileDevice)
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    column(zoneCode;
    "Zone Code")
    {
    }
    column(binCode;
    "Bin Code")
    {
    }
    column(documentStatus;
    "Document Status")
    {
    }
    column(status;
    Status)
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
    column(sortingMethod;
    "Sorting Method")
    {
    }
    }
    }
}
