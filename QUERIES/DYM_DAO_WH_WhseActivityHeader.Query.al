query 70149 DYM_DAO_WH_WhseActivityHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_whWhseActivityHeader';
    EntitySetName = 'backup_whWhseActivityHeaders';

    elements
    {
        dataitem(WarehouseActivityHeader;
        "Warehouse Activity Header")
        {
            column("type";
            Type)
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
            column(locationCode;
            "Location Code")
            {
            }
            column(postingDate;
            "Posting Date")
            {
            }
            column(sourceType;
            "Source Type")
            {
            }
            column(sourceSubtype;
            "Source Subtype")
            {
            }
            column(sourceNo;
            "Source No.")
            {
            }
            column(sourceDocument;
            "Source Document")
            {
            }
            column(destinationType;
            "Destination Type")
            {
            }
            column(destinationNo;
            "Destination No.")
            {
            }
        }
    }
}
