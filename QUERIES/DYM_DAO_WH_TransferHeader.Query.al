query 70143 DYM_DAO_WH_TransferHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_whTransferHeader';
    EntitySetName = 'backup_whTransferHeaders';

    elements
    {
        dataitem(TransferHeader;
        "Transfer Header")
        {
            column(no;
            "No.")
            {
            }
            column(mobileShipStatus;
            DYM_MobileShipStatus)
            {
            }
            column(mobileReceiveStatus;
            DYM_MobileReceiveStatus)
            {
            }
            column(mobileDevice;
            DYM_MobileDevice)
            {
            }
            column(transferfromCode;
            "Transfer-from Code")
            {
            }
            column(transfertoCode;
            "Transfer-to Code")
            {
            }
            column(postingDate;
            "Posting Date")
            {
            }
            column(inTransitCode;
            "In-Transit Code")
            {
            }
            column(directTransfer;
            "Direct Transfer")
            {
            }
            column(status;
            Status)
            {
            }
        }
    }
}
