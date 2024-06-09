page 70128 DYM_DAO_WH_WhseShipmentLine
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whWhseShipmentLine';
    EntitySetName = 'whWhseShipmentLines';
    SourceTable = "Warehouse Shipment Line";
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
                field(lineNo; Rec."Line No.")
                {
                }
                field(itemNo; Rec."Item No.")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                }
                field(qtyperUnitofMeasure; Rec."Qty. per Unit of Measure")
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
                field(shelfNo; Rec."Shelf No.")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(qtyBase; Rec."Qty. (Base)")
                {
                }
                field(qtyOutstanding; Rec."Qty. Outstanding")
                {
                }
                field(qtyOutstandingBase; Rec."Qty. Outstanding (Base)")
                {
                }
                field(qtytoShip; Rec."Qty. to Ship")
                {
                }
                field(qtytoShipBase; Rec."Qty. to Ship (Base)")
                {
                }
                field(qtyShipped; Rec."Qty. Shipped")
                {
                }
                field(qtyShippedBase; Rec."Qty. Shipped (Base)")
                {
                }
                field(sourceType; Rec."Source Type")
                {
                }
                field(sourceSubtype; Rec."Source Subtype")
                {
                }
                field(sourceNo; Rec."Source No.")
                {
                }
                field(sourceLineNo; Rec."Source Line No.")
                {
                }
                field(sourceDocument; Rec."Source Document")
                {
                }
                field(status; Rec.Status)
                {
                }
                field(sortingSequenceNo; Rec."Sorting Sequence No.")
                {
                }
                field(destinationType; Rec."Destination Type")
                {
                }
                field(destinationNo; Rec."Destination No.")
                {
                }
                field(cubage; Rec.Cubage)
                {
                }
                field(weight; Rec.Weight)
                {
                }
            }
        }
    }
}
