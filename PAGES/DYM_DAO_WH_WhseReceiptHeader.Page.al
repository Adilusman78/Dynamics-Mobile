page 70126 DYM_DAO_WH_WhseReceiptHeader
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whWhseReceiptHeader';
    EntitySetName = 'whWhseReceiptHeaders';
    Caption = 'DYM_DAO_WH_WhseReceiptHeader';
    SourceTable = "Warehouse Receipt Header";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; Rec."No.")
                {
                }
                field(mobileStatus; Rec.DYM_MobileStatus)
                {
                }
                field(mobileDevice; Rec.DYM_MobileDevice)
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(zoneCode; Rec."Zone Code")
                {
                }
                field(documentStatus; Rec."Document Status")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(sortingMethod; Rec."Sorting Method")
                {
                }
                field(binCode; Rec."Bin Code")
                {
                }
                field(vendorShipmentNo; Rec."Vendor Shipment No.")
                {
                }
            }
        }
    }
}
