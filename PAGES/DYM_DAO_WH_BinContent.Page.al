page 70117 DYM_DAO_WH_BinContent
{
    PageType = API;
    DelayedInsert = true;
    SourceTable = "Bin Content";
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whBinContent';
    EntitySetName = 'whBinContents';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(locationCode; Rec."Location Code")
                {
                }
                field(zoneCode; Rec."Zone Code")
                {
                }
                field(binCode; Rec."Bin Code")
                {
                }
                field(itemNo; Rec."Item No.")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                }
                field(qtyperUnitofMeasure; Rec."Qty. per Unit of Measure")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(quantityBase; Rec."Quantity (Base)")
                {
                }
                field(name; Name)
                {
                }
                field(fixed; Rec.Fixed)
                {
                }
                field(default; Rec.Default)
                {
                }
                field(dedicated; Rec.Dedicated)
                {
                }
                field(binTypeCode; Rec."Bin Type Code")
                {
                }
                field(warehouseClassCode; Rec."Warehouse Class Code")
                {
                }
                field(blockMovement; Rec."Block Movement")
                {
                }
                field(binRanking; Rec."Bin Ranking")
                {
                }
                field(qty; Qty)
                {
                }
                field(qtyAvail; QtyAvail)
                {
                }
            }
        }
    }
    var
        Name: Text;
        Qty: Decimal;
        QtyAvail: Decimal;

    trigger OnAfterGetRecord()
    begin
        Rec.GetItemDescr(Rec."Item No.", Rec."Variant Code", Name);
        Qty := Rec.CalcQtyUOM();
        QtyAvail := Rec.CalcQtyAvailToTakeUOM();
    end;
}
