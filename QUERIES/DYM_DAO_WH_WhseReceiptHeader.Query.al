query 70151 DYM_DAO_WH_WhseReceiptHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_whWhseReceiptHeader';
    EntitySetName = 'backup_whWhseReceiptHeaders';

    elements
    {
        dataitem(WarehouseReceiptHeader;
        "Warehouse Receipt Header")
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
            column(documentStatus;
            "Document Status")
            {
            }
            column(postingDate;
            "Posting Date")
            {
            }
            column(sortingMethod;
            "Sorting Method")
            {
            }
        }
    }
}
