page 70177 DYM_SyncLogEntryNavigate
{
    Caption = 'Sync Log Entry Navigate';
    Editable = false;
    PageType = NavigatePage;
    SourceTable = "Dimension Selection Buffer";
    SourceTableView = SORTING(Code);

    layout
    {
        area(content)
        {
            group(Info)
            {
                Caption = 'Info';

                field("STRSUBSTNO ( Text001 , DeviceRole.Code , DeviceRole.Description )"; StrSubstNo(Text001, DeviceRole.Code, DeviceRole.Description))
                {
                    ApplicationArea = All;
                    Caption = 'Device Role Code';
                    Editable = false;
                }
                field("STRSUBSTNO ( Text001 , DeviceGroup.Code , DeviceGroup.Description )"; StrSubstNo(Text001, DeviceGroup.Code, DeviceGroup.Description))
                {
                    ApplicationArea = All;
                    Caption = 'Device Group Code';
                    Editable = false;
                }
                field("STRSUBSTNO ( Text001 , DeviceSetup.Code , DeviceSetup.Description )"; StrSubstNo(Text001, DeviceSetup.Code, DeviceSetup.Description))
                {
                    ApplicationArea = All;
                    Caption = 'Device Setup Code';
                    Editable = false;
                }
            }
            repeater(Control1103100000)
            {
                ShowCaption = false;

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                }
                field("Filter Lookup Table No."; Rec."Filter Lookup Table No.")
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';

                    trigger OnAssistEdit()
                    begin
                        Clear(StatsMgt);
                        StatsMgt.DrillDownRecStat(SyncLogEntry, Rec, AddDataLog);
                    end;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnFindRecord(Which: Text): Boolean
    begin
        RecStats := Rec;
        if RecStats.Find(Which) then begin
            Rec := RecStats;
            exit(true);
        end;
        exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        MSteps: Integer;
    begin
        RecStats := Rec;
        MSteps := RecStats.Next(Steps);
        if (MSteps <> 0) then Rec := RecStats;
        exit(MSteps);
    end;

    trigger OnOpenPage()
    begin
        Clear(StatsMgt);
        if SyncLogEntry.Get(SyncLogEntryNo) then SyncLogEntry.GetNavigation(RecStats, AddDataLog);
        if not DeviceRole.Get(SyncLogEntry."Device Role Code") then Clear(DeviceRole);
        if not DeviceGroup.Get(SyncLogEntry."Device Group Code") then Clear(DeviceGroup);
        if not DeviceSetup.Get(SyncLogEntry."Device Setup Code") then Clear(DeviceSetup);
        DeviceSetup.CalcFields("Salesperson Name");
        RecStats.Reset;
    end;

    var
        RecStats: Record "Dimension Selection Buffer" temporary;
        AddDataLog: Record DYM_DataLog temporary;
        SyncLogEntry: Record DYM_SyncLog;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        StatsMgt: Codeunit DYM_StatisticsManagement;
        SyncLogEntryNo: Integer;
        Text001: Label '%1 - %2', Locked = true;

    procedure SetSyncLogEntry(SE: Integer)
    begin
        SyncLogEntryNo := SE;
    end;
}
