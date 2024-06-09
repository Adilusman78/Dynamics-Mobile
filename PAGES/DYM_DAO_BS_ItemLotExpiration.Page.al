page 70103 DYM_DAO_BS_ItemLotExpiration
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemLotExpiration';
    EntitySetName = 'bsItemLotExpirations';
    SourceTable = "Item Ledger Entry";
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
                field(itemNo; Rec."Item No.")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(lotNo; Rec."Lot No.")
                {
                }
                field(expirationDate; LowLevelDP.ODDate2Text(Rec."Expiration Date"))
                {
                }
                field(blocked; LotNoInfo.Blocked)
                {
                }
            }
        }
    }
    var
        LotNoInfo: Record "Lot No. Information";
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;

    trigger OnOpenPage()
    begin
        LoadTableData();
    end;

    trigger OnAfterGetRecord()
    begin
        if ((Rec."Item No." <> LotNoInfo."Item No.") OR (Rec."Variant Code" <> LotNoInfo."Variant Code") OR (Rec."Lot No." <> LotNoInfo."Lot No.")) then if not LotNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then clear(LotNoInfo);
    end;

    procedure LoadTableData()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        FiltersBackup: Record "Item Ledger Entry" temporary;
        BackupFilterGroup: Integer;
    begin
        FiltersBackup.Reset();
        FiltersBackup.CopyFilters(Rec);
        if Rec.IsTemporary then begin
            Rec.Reset();
            Rec.DeleteAll();
        end;
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange(Positive, true);
        if (Rec.GetFilters <> '') then begin
            ItemLedgerEntry.SetFilter("Item No.", FiltersBackup.GetFilter("Item No."));
            ItemLedgerEntry.SetFilter("Variant Code", FiltersBackup.GetFilter("Variant Code"));
            ItemLedgerEntry.SetFilter("Lot No.", FiltersBackup.GetFilter("Lot No."));
        end;
        BackupFilterGroup := ItemLedgerEntry.FilterGroup;
        ItemLedgerEntry.FilterGroup(10);
        ItemLedgerEntry.SetFilter("Lot No.", '<>''''');
        ItemLedgerEntry.FilterGroup(BackupFilterGroup);
        if ItemLedgerEntry.FindSet(false, false) then
            repeat
                Rec.Reset;
                Rec.SetRange("Item No.", ItemLedgerEntry."Item No.");
                Rec.SetRange("Variant Code", ItemLedgerEntry."Variant Code");
                Rec.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                //Set filter by Expiration Date also in order to catch possible multiple Exp.Date per Lot
                Rec.SetRange("Expiration Date", ItemLedgerEntry."Expiration Date");
                if rec.IsEmpty then begin
                    Rec.Init();
                    Rec."Entry No." := ItemLedgerEntry."Entry No.";
                    Rec."Item No." := ItemLedgerEntry."Item No.";
                    Rec."Variant Code" := ItemLedgerEntry."Variant Code";
                    Rec."Lot No." := ItemLedgerEntry."Lot No.";
                    Rec."Expiration Date" := ItemLedgerEntry."Expiration Date";
                    Rec.Insert();
                end until ItemLedgerEntry.next = 0;
        Rec.Reset();
        Rec.CopyFilters(FiltersBackup);
    end;
}
