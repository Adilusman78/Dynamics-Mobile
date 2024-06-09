page 84304 DYM_DAO_WH_WhseShipmentHeader
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whWhseShipmentHeader';
    EntitySetName = 'whWhseShipmentHeaders';
    Caption = 'DYM_DAO_WH_WhseShipmentHeader';
    SourceTable = "Warehouse Shipment Header";
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
                field(binCode; Rec."Bin Code")
                {
                }
                field(documentStatus; Rec."Document Status")
                {
                }
                field(status; Rec.Status)
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                }
                field(sorting_Method; Rec."Sorting Method")
                {
                }
            }
        }
    }
}
