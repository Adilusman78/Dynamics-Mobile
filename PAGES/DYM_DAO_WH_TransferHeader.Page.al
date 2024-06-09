page 70123 DYM_DAO_WH_TransferHeader
{
    Permissions = tabledata "Transfer Header" = rimd;
    SourceTable = "Transfer Header";
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whTransferHeader';
    EntitySetName = 'whTransferHeaders';
    Caption = 'DYM_DAO_WH_TransferHeader';
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;
    ODataKeyFields = "No.";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; Rec."No.")
                {
                }
                field(mobileShipStatus; Rec.DYM_MobileShipStatus)
                {
                }
                field(mobileReceiveStatus; Rec.DYM_MobileReceiveStatus)
                {
                }
                field(mobileDevice; Rec.DYM_MobileDevice)
                {
                }
                field(transferFromName; Rec."Transfer-from Name")
                {
                }
                field(transferToName; Rec."Transfer-to Name")
                {
                }
                field(transferfromCode; Rec."Transfer-from Code")
                {
                }
                field(transfertoCode; Rec."Transfer-to Code")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(inTransitCode; Rec."In-Transit Code")
                {
                }
                field(directTransfer; Rec."Direct Transfer")
                {
                }
                field(status; Rec.Status)
                {
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                }
                field(receiptDate; Rec."Receipt Date")
                {
                }
            }
        }
    }
}
