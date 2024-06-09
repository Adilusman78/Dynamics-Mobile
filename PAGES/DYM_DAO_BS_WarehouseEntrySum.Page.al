page 70105 DYM_DAO_BS_WarehouseEntrySum
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsWarehouseEntrySum';
    EntitySetName = 'bsWarehouseEntriesSum';
    SourceTable = "Warehouse Entry";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;
    SourceTableTemporary = true;

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
                field(lotNo; Rec."Lot No.")
                {
                }
                field(serialNo; Rec."Serial No.")
                {
                }
                field(expirationDate; LowLevelDP.ODDate2Text(Rec."Expiration Date"))
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(qtyBase; Rec."Qty. (Base)")
                {
                }
                field(qtyAvail; Rec.Cubage)
                {
                }
                field(itemDescription; Item.Description)
                {
                }
                field(itemDescription2; Item."Description 2")
                {
                }
                field(variantDescription; ItemVariant.Description)
                {
                }
                field(variantDescription2; ItemVariant."Description 2")
                {
                }
            }
        }
    }
    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        BinContent: Record "Bin Content";
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;

    trigger OnOpenPage()
    begin
        LoadTableData();
    end;

    trigger OnAfterGetRecord()
    begin
        CalcItemDescriptions();
    end;

    local procedure CalcQtyAvail(_WhseEntry: Record "Warehouse Entry") Result: Decimal
    begin
        clear(Result);
        BinContent.Reset();
        if BinContent.Get(Rec."Location Code", Rec."Bin Code", Rec."Item No.", Rec."Variant Code", Rec."Unit of Measure Code") then begin
            BinContent.SetRange("Lot No. Filter", Rec."Lot No.");
            BinContent.SetRange("Serial No. Filter", Rec."Serial No.");
            Result := BinContent.CalcQtyAvailToTakeUOM();
        end;
    end;

    local procedure CalcItemDescriptions()
    begin
        if (Rec."Item No." <> Item."No.") then if not Item.Get(Rec."Item No.") then clear(Item);
        if ((Rec."Item No." <> ItemVariant."Item No.") or (Rec."Variant Code" <> ItemVariant.Code)) then if not ItemVariant.Get(Rec."Item No.", Rec."Variant Code") then clear(ItemVariant);
    end;

    procedure LoadTableData()
    var
        WarehouseEntry: Record "Warehouse Entry";
        FiltersBackup: Record "Warehouse Entry" temporary;
        BackupFilterGroup: Integer;
    begin
        FiltersBackup.Reset();
        FiltersBackup.CopyFilters(Rec);
        if Rec.IsTemporary then begin
            Rec.Reset();
            Rec.DeleteAll();
        end;
        WarehouseEntry.Reset;
        WarehouseEntry.CopyFilters(Rec);
        if WarehouseEntry.FindSet(false, false) then
            repeat
                Rec.Reset;
                Rec.SetRange("Location Code", WarehouseEntry."Location Code");
                Rec.SetRange("Zone Code", WarehouseEntry."Zone Code");
                Rec.SetRange("Bin Code", WarehouseEntry."Bin Code");
                Rec.SetRange("Item No.", WarehouseEntry."Item No.");
                Rec.SetRange("Variant Code", WarehouseEntry."Variant Code");
                rec.SetRange("Unit of Measure Code", WarehouseEntry."Unit of Measure Code");
                Rec.SetRange("Lot No.", WarehouseEntry."Lot No.");
                Rec.SetRange("Serial No.", WarehouseEntry."Serial No.");
                //Set filter by Expiration Date also in order to catch possible multiple Exp.Date per Lot
                Rec.SetRange("Expiration Date", WarehouseEntry."Expiration Date");
                if not rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Entry No." := WarehouseEntry."Entry No.";
                    Rec."Location Code" := WarehouseEntry."Location Code";
                    Rec."Zone Code" := WarehouseEntry."Zone Code";
                    Rec."Bin Code" := WarehouseEntry."Bin Code";
                    Rec."Item No." := WarehouseEntry."Item No.";
                    Rec."Variant Code" := WarehouseEntry."Variant Code";
                    Rec."Unit of Measure Code" := WarehouseEntry."Unit of Measure Code";
                    Rec."Lot No." := WarehouseEntry."Lot No.";
                    Rec."Serial No." := WarehouseEntry."Serial No.";
                    Rec."Expiration Date" := WarehouseEntry."Expiration Date";
                    Clear(Rec.Quantity);
                    Clear(Rec."Qty. (Base)");
                    //Cubage is used for QtyAvail in order to allow filtering on it
                    Rec.Cubage := CalcQtyAvail(Rec);
                    Rec.Insert();
                end;
                Rec.Quantity += WarehouseEntry.Quantity;
                Rec."Qty. (Base)" += WarehouseEntry."Qty. (Base)";
                Rec.Modify();
            until WarehouseEntry.next = 0;
        Rec.Reset();
        Rec.CopyFilters(FiltersBackup);
    end;
}
