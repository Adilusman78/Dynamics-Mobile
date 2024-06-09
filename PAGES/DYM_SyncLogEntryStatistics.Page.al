page 70178 DYM_SyncLogEntryStatistics
{
    Caption = 'Sync Log Entry Statistics';
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
                    Caption = 'Device Role';
                    Editable = false;
                }
                field("STRSUBSTNO ( Text001 , DeviceGroup.Code , DeviceGroup.Description )"; StrSubstNo(Text001, DeviceGroup.Code, DeviceGroup.Description))
                {
                    ApplicationArea = All;
                    Caption = 'Device Group';
                    Editable = false;
                }
                field("STRSUBSTNO ( Text001 , DeviceSetup.Code , DeviceSetup.Description ) "; StrSubstNo(Text001, DeviceSetup.Code, DeviceSetup.Description))
                {
                    ApplicationArea = All;
                    Caption = 'Device Setup';
                    Editable = false;
                }
            }
            repeater(Control1103100000)
            {
                ShowCaption = false;

                field("RecStats.Code"; RecStats.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                }
                field(RecCount; RecCount)
                {
                    ApplicationArea = All;
                    Caption = 'Records Count';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        StatsMgt.ReadPacketData(SyncLogEntry, RecStats.Code, Data);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        RecCount := RecStats.Level;
    end;

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
        if SyncLogEntry.Get(SyncLogEntryNo) then SyncLogEntry.GetStatistics(DeviceRoleCode, DeviceGroupCode, DeviceSetupCode, RecStats);
        if not DeviceRole.Get(DeviceRoleCode) then Clear(DeviceRole);
        if not DeviceGroup.Get(DeviceGroupCode) then Clear(DeviceGroup);
        if not DeviceSetup.Get(DeviceSetupCode) then Clear(DeviceSetup);
        DeviceSetup.CalcFields("Salesperson Name");
        RecStats.Reset;
    end;

    var
        RecStats: Record "Dimension Selection Buffer" temporary;
        RecCount: Integer;
        SyncLogEntry: Record DYM_SyncLog;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        Data: Record DYM_CacheBuffer temporary;
        StatsMgt: Codeunit DYM_StatisticsManagement;
        SyncLogEntryNo: Integer;
        DeviceRoleCode: Code[20];
        DeviceGroupCode: Code[20];
        DeviceSetupCode: Code[100];
        Text001: Label '%1 - %2', Locked = true;

    procedure SetSyncLogEntry(SE: Integer)
    begin
        SyncLogEntryNo := SE;
    end;
}
