page 84000 DYM_DynamicsMobileSetup
{
    Caption = 'Dynamics Mobile Setup';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Settings,Import,Export,Services Link,';
    SourceTable = DYM_DynamicsMobileSetup;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Packet Storage Path"; Rec."Packet Storage Path")
                {
                    ApplicationArea = All;
                }
                field("Process Timer Interval"; Rec."Process Timer Interval")
                {
                    ApplicationArea = All;
                }
                field("Dashboard Calculation Days"; Rec."Dashboard Calculation Days")
                {
                    ApplicationArea = All;
                }
                field("Skip Checksum check"; Rec."Skip Checksum check")
                {
                    ApplicationArea = All;
                }
                field("Dynamics Mobile Service URL"; Rec."Dynamics Mobile Service URL")
                {
                    ApplicationArea = All;
                }
            }
            group(Internal)
            {
                Caption = 'Internal';

                field("Pull Disabled"; Rec."Pull Disabled")
                {
                    ApplicationArea = All;
                }
                field("Deleting XML Disabled"; Rec."Deleting XML Disabled")
                {
                    ApplicationArea = All;
                }
                field("Debug Level"; Rec."Debug Level")
                {
                    ApplicationArea = All;
                }
                field("Settings Auto Sync"; Rec."Settings Auto Sync")
                {
                    ApplicationArea = All;
                }
                field("Auto Sync Intervals"; Rec."Auto Sync Intervals")
                {
                    ApplicationArea = All;
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';

                field("Packet Process Retry Enabled"; Rec."Packet Process Retry Enabled")
                {
                    ApplicationArea = All;
                }
                field("Skip Processing Older (Days)"; Rec."Skip Processing Older (Days)")
                {
                    ApplicationArea = All;
                }
                field("Max Tries Count"; Rec."Max Tries Count")
                {
                    ApplicationArea = All;
                }
                field("Process Wait Time (sec)"; Rec."Process Wait Time (sec)")
                {
                    ApplicationArea = All;
                }
            }
            group(About)
            {
                Caption = 'About';

                field("ConstMgt.DMV_Version"; ConstMgt.DMV_Version)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("Dynamics Mobile services link")
            {
                Caption = 'Dynamics Mobile services link';

                action("Export D&ES")
                {
                    ApplicationArea = All;
                    Caption = 'Export D&ES';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SyncMgt.ForceExportDES;
                    end;
                }
                action("Export D&BS")
                {
                    ApplicationArea = All;
                    Caption = 'Export D&BS';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SyncMgt.ForceExportDBS;
                    end;
                }
                separator(Action1103109013)
                {
                }
            }
            group(Import)
            {
                Caption = 'Import';
                Image = Import;

                action(Full)
                {
                    ApplicationArea = All;
                    Caption = 'Full';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.ImportFull(true);
                    end;
                }
                action(Settings)
                {
                    ApplicationArea = All;
                    Caption = 'Settings';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.ImportSettings(true);
                    end;
                }
                action("Device Hierarchy")
                {
                    ApplicationArea = All;
                    Caption = 'Device Hierarchy';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.ImportDeviceHierarchy(true);
                    end;
                }
                action(Mapping)
                {
                    ApplicationArea = All;
                    Caption = 'Mapping';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.ImportMapping(true);
                    end;
                }
                action(LogTables)
                {
                    ApplicationArea = All;
                    Caption = 'Log tables';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.ImportLogTables(true);
                    end;
                }
            }
            group(Export)
            {
                Caption = 'Export';
                Image = Export;

                action(Action10)
                {
                    ApplicationArea = All;
                    Caption = 'Full';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportFull(true);
                    end;
                }
                action(Action9)
                {
                    ApplicationArea = All;
                    Caption = 'Settings';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportSettings(true);
                    end;
                }
                action(Action8)
                {
                    ApplicationArea = All;
                    Caption = 'Device Hierarchy';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportDeviceHierarchy(true);
                    end;
                }
                action(Action7)
                {
                    ApplicationArea = All;
                    Caption = 'Mapping';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportMapping(true);
                    end;
                }
                action(Action16)
                {
                    ApplicationArea = All;
                    Caption = 'Log tables';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportLogTables(true);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';

                action("&Settings")
                {
                    ApplicationArea = All;
                    Caption = '&Settings';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+S';

                    trigger OnAction()
                    begin
                        Clear(SettingsMgt);
                        SettingsMgt.OpenSettings('', '', '');
                    end;
                }
            }
        }
    }
    var SyncMgt: Codeunit DYM_SyncManagement;
    SetupIOMgt: Codeunit DYM_SetupIOManagement;
    SetupIOHandler: Codeunit DYM_SetupIOHandler;
    ConstMgt: Codeunit DYM_ConstManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
}
