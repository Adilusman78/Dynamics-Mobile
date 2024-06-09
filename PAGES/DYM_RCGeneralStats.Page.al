page 70158 DYM_RCGeneralStats
{
    Caption = 'RC General Stats';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = DYM_DynamicsMobileCue;

    layout
    {
        area(content)
        {
            grid(GlobalSettingsGrid)
            {
                Caption = 'Global Settings';

                group("Global Settings")
                {
                    Caption = 'Global Settings';

                    field("CloudAppArea"; GlobalSettings.Get(ConstMgt.CLD_AppArea()))
                    {
                        Caption = 'Cloud Application Area';
                        ApplicationArea = All;
                        Visible = CloudVisible;
                    }
                    field("IntegrityVersionHash"; GlobalSettings.Get(ConstMgt.STV_IntegrityVersionHash()))
                    {
                        Caption = 'Integrity Version Hash';
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup("Packet Statistics")
            {
                Caption = 'Packet Statistics';

                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                    DrillDownPageID = DYM_SyncLogEntries;
                }
                field(Pending; Rec.Pending)
                {
                    ApplicationArea = All;
                    DrillDownPageID = DYM_SyncLogEntries;
                }
                field(Success; Rec.Success)
                {
                    ApplicationArea = All;
                    DrillDownPageID = DYM_SyncLogEntries;
                    StyleExpr = TRUE;
                }
                field(Failed; Rec.Failed)
                {
                    ApplicationArea = All;
                    DrillDownPageID = DYM_SyncLogEntries;
                    StyleExpr = TRUE;
                }
                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                    DrillDownPageID = DYM_SyncLogEntries;
                    StyleExpr = TRUE;
                }
            }
            cuegroup("Hierarchy Statistics")
            {
                Caption = 'Hierarchy Statistics';

                field("Active Roles"; Rec."Active Roles")
                {
                    ApplicationArea = All;
                    ColumnSpan = 2;
                    RowSpan = 1;
                }
                field("Active Groups"; Rec."Active Groups")
                {
                    ApplicationArea = All;
                    ColumnSpan = 2;
                    RowSpan = 2;
                }
                field("Active Devices"; Rec."Active Devices")
                {
                    ApplicationArea = All;
                    ColumnSpan = 3;
                }
            }
        }
    }
    var
        ConstMgt: Codeunit DYM_ConstManagement;
        GlobalSettings: Dictionary of [Text, Text];
        [InDataSet]
        CloudVisible: boolean;
        MobileSetup: Record DYM_DynamicsMobileSetup;

    trigger OnOpenPage()
    begin
        ReadGlobalSettings();
        if not MobileSetup.Get then Clear(MobileSetup);
        if (MobileSetup."Dashboard Calculation Days" <> 0) then Rec.SetFilter("Date Filter", '>%1', CreateDateTime(Today - MobileSetup."Dashboard Calculation Days", 0T));
        if not Rec.Get() then begin
            rec.Init();
            rec.Insert();
        end;
    end;

    procedure ReadGlobalSettings()
    var
        SettingsMgt: Codeunit DYM_SettingsManagement;
        StateMgt: Codeunit DYM_StateManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
    begin
        clear(GlobalSettings);
        GlobalSettings.Add(ConstMgt.BOS_PacketStorageType(), SettingsMgt.GetGlobalSetting(ConstMgt.BOS_PacketStorageType()));
        GlobalSettings.Add(ConstMgt.CLD_AppArea(), SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea()));
        GlobalSettings.Add(ConstMgt.STV_IntegrityVersionHash(), StateMgt.GetStateVar('', ConstMgt.STV_IntegrityVersionHash()));
        clear(CloudVisible);
        CloudVisible := GlobalSettings.Get(ConstMgt.BOS_PacketStorageType()) = ConstMgt.BOS_PacketStorageType_DMCloud();
    end;
}
