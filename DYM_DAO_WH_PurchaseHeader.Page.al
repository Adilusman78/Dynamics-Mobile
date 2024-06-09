page 84302 DYM_DAO_WH_PurchaseHeader
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whPurchaseHeader';
    EntitySetName = 'whPurchaseHeaders';
    Caption = 'DYM_DAO_WH_PurchaseHeader';
    SourceTable = "Purchase Header";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(documentType; Rec."Document Type")
                {
                }
                field(no; Rec."No.")
                {
                }
                field(mobileStatus; Rec.DYM_MobileStatus)
                {
                }
                field(mobileDevice; Rec.DYM_MobileDevice)
                {
                }
                field(documentDate; Rec."Document Date")
                {
                }
                field(buyfromVendorNo; Rec."Buy-from Vendor No.")
                {
                }
                field(buyfromVendorName; Rec."Buy-from Vendor Name")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(buyFromAddress; Rec."Buy-from Address")
                {
                }
                field(paytoVendorNo; Rec."Pay-to Vendor No.")
                {
                }
            }
        }
    }
}
