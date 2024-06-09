query 84302 DYM_DAO_WH_PurchaseHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_whPurchaseHeader';
    EntitySetName = 'backup_whPurchaseHeaders';

    elements
    {
    dataitem(PurchaseHeader;
    "Purchase Header")
    {
    column(documentType;
    "Document Type")
    {
    }
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
    column(documentDate;
    "Document Date")
    {
    }
    column(buyfromVendorNo;
    "Buy-from Vendor No.")
    {
    }
    column(buyfromVendorName;
    "Buy-from Vendor Name")
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    }
    }
}
