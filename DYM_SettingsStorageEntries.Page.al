page 84998 DYM_SettingsStorageEntries
{
    PageType = List;
    SourceTable = DYM_SettingsStorage;
    PromotedActionCategories = 'New,Process,Report,Backup,Restore,File,Logs';
    Caption = 'Settings Storage Entries';

    layout
    {
        area(Content)
        {
            repeater(SettingsStorageGrid)
            {
                field("Entry No"; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No';
                    Editable = false;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = true;
                }
                field("Type"; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Editable = false;
                }
                field(Format; Rec.Format)
                {
                    ApplicationArea = All;
                    Caption = 'Format';
                    Editable = false;
                }
                field("Entry Timestamp"; Rec."Entry TimeStamp")
                {
                    ApplicationArea = All;
                    Caption = 'Exported';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(BackupCSVGroup)
            {
                Caption = 'Backup CSV';

                action(BackupCSVFull)
                {
                    ApplicationArea = All;
                    Caption = 'Full';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportFull(false);
                    end;
                }
                action(BackupCSVSettings)
                {
                    ApplicationArea = All;
                    Caption = 'Settings';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportSettings(false);
                    end;
                }
                action(BackupCSVHierarchy)
                {
                    ApplicationArea = All;
                    Caption = 'Hierarchy';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportDeviceHierarchy(false);
                    end;
                }
                action(BackupCSVMapping)
                {
                    ApplicationArea = All;
                    Caption = 'Mapping';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportMapping(false);
                    end;
                }
                action(BackupCSVLogTables)
                {
                    ApplicationArea = All;
                    Caption = 'Log tables';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::CSV);
                        SetupIOHandler.ExportLogTables(false);
                    end;
                }
            }
            group(GenerateJSONGroup)
            {
                Caption = 'Generate JSON';

                action(GenerateJSONFull)
                {
                    ApplicationArea = All;
                    Caption = 'Full';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::JSON);
                        SetupIOHandler.ExportFull(false);
                    end;
                }
                action(GenerateJSONSettings)
                {
                    ApplicationArea = All;
                    Caption = 'Settings';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::JSON);
                        SetupIOHandler.ExportSettings(false);
                    end;
                }
                action(GenerateJSONHierarchy)
                {
                    ApplicationArea = All;
                    Caption = 'Hierarchy';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::JSON);
                        SetupIOHandler.ExportDeviceHierarchy(false);
                    end;
                }
                action(GenerateJSONMapping)
                {
                    ApplicationArea = All;
                    Caption = 'Mapping';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        Clear(SetupIOHandler);
                        SetupIOHandler.SetExportFormat(Enum::DYM_BackupRestoreFormat::JSON);
                        SetupIOHandler.ExportMapping(false);
                    end;
                }
            }
            group(RestoreGroup)
            {
                Caption = 'Restore';

                action(Restore)
                {
                    ApplicationArea = All;
                    Caption = 'Restore';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.RestoreStorageEntry();
                    end;
                }
            }
            group(FileGroup)
            {
                Caption = 'File';

                action(Upload)
                {
                    ApplicationArea = All;
                    Caption = 'Upload';
                    Image = MoveUp;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.Upload();
                    end;
                }
                action(Download)
                {
                    ApplicationArea = All;
                    Caption = 'Download';
                    Image = MoveDown;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.Download();
                    end;
                }
            }
        }
        area(Navigation)
        {
            action("E&vent Log Entries")
            {
                ApplicationArea = All;
                Caption = 'E&vent Log Entries';
                Image = WarrantyLedger;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page DYM_EventLogEntries;
                RunPageLink = "Source Type"=CONST("Settings Storage"), "Source Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Source Entry No.");
            }
        }
    }
    var SetupIOHandler: Codeunit DYM_SetupIOHandler;
}
