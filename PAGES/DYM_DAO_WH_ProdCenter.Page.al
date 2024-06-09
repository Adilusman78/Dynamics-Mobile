page 70119 DYM_DAO_WH_ProdCenter
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whProdCenter';
    EntitySetName = 'whProdCenters';
    Caption = 'DYM_DAO_WH_ProdCenter';
    SourceTable = "Prod. Order Routing Line";
    SourceTableTemporary = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(SystemId; Rec.SystemId)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(no; Rec."No.")
                {
                }
                field(name; Rec.Description)
                {
                }
                field(workCenterNo; Rec."Work Center No.")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        FiltersBackup: Record "Prod. Order Routing Line" temporary;
        NextEntryNo: Integer;
    begin
        FiltersBackup.Reset();
        FiltersBackup.CopyFilters(Rec);
        Rec.Reset();
        if Rec.IsTemporary then Rec.DeleteAll();
        clear(NextEntryNo);
        WorkCenter.Reset();
        if WorkCenter.FindSet() then
            repeat
                NextEntryNo += 1;
                Rec.Init();
                Rec.SystemId := WorkCenter.SystemId;
                Rec."Routing Reference No." := NextEntryNo;
                Rec.Type := Rec.Type::"Work Center";
                Rec."No." := WorkCenter."No.";
                Rec.Description := WorkCenter.Name;
                clear(Rec."Work Center No.");
                Rec.Insert();
            until WorkCenter.Next() = 0;
        MachineCenter.Reset();
        if MachineCenter.FindSet() then
            repeat
                NextEntryNo += 1;
                Rec.Init();
                Rec.SystemId := MachineCenter.SystemId;
                Rec."Routing Reference No." := NextEntryNo;
                Rec.Type := Rec.Type::"Machine Center";
                Rec."No." := MachineCenter."No.";
                Rec.Description := MachineCenter.Name;
                Rec."Work Center No." := MachineCenter."Work Center No.";
                Rec.Insert();
            until MachineCenter.Next() = 0;
        Rec.Reset();
    end;
}
