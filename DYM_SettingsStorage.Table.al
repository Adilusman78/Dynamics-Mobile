table 84995 DYM_SettingsStorage
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No';
            DataClassification = SystemMetadata;
        }
        field(2; "Data"; Blob)
        {
            Caption = 'Data';
            DataClassification = SystemMetadata;
        }
        field(3; "Type";Enum DYM_BackupRestoreType)
        {
            Caption = 'Type';
            DataClassification = SystemMetadata;
        }
        field(4; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(5; "Entry TimeStamp"; DateTime)
        {
            Caption = 'Entry TimeStamp';
            DataClassification = SystemMetadata;
        }
        field(6; "Format";Enum DYM_BackupRestoreFormat)
        {
            Caption = 'Format';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    var DebugMgt: Codeunit DYM_DebugManagement;
    EventLogMgt: Codeunit DYM_EventLogManagement;
    EventLogMsgPattern: Label '[%1][%2]', Locked = true;
    CSVFormatFileExtension: Label '.txt', Locked = true;
    JSONFormatFileExtension: Label '.json', Locked = true;
    OpDialogLogText: Label 'Download', Locked = true;
    Text001: Label 'Record does not contain data.';
    Text002: Label 'Push files (*.txt)|*.txt|All Files (*.*)|*.*';
    Text003: Label 'Do you want to truncate the tables before the import?';
    Text_ExportDialogTitle: Label 'Export';
    procedure Download()
    var
        inS: InStream;
        tempFilename: Text;
    begin
        CalcFields(Data);
        if(not Data.HasValue)then error(Text001);
        Data.CreateInStream(inS, TextEncoding::UTF8);
        case Rec.Format of Rec.Format::CSV: tempFilename:=CreateGuid() + CSVFormatFileExtension;
        Rec.Format::JSON: tempFilename:=CreateGuid() + JSONFormatFileExtension;
        end;
        DownloadFromStream(inS, Text_ExportDialogTitle, '', Text002, tempfilename);
        EventLogMgt.LogInfo(Rec."Entry No.", enum::DYM_EventLogSourceType::"Settings Storage", StrSubstNo(EventLogMsgPattern, OpDialogLogText, UserId), '');
    end;
    procedure Upload()
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        SetupIOMgt: Codeunit DYM_SetupIOManagement;
        TempFile: File;
        Filename: Text[250];
        InS: InStream;
        OutS: OutStream;
        NextEntry: Integer;
        BackupRestoreType: enum DYM_BackupRestoreType;
    begin
        Clear(Filename);
        BackupRestoreType:=enum::DYM_BackupRestoreType.FromInteger(StrMenu(LowLevelDP.List2Text(enum::DYM_BackupRestoreType.Names())) - 1);
        Clear(Filename);
        if not UploadIntoStream('', '', Text002, Filename, InS)then exit;
        clear(Rec);
        Rec.Init();
        Rec."Entry TimeStamp":=CreateDateTime(Today, Time);
        Rec.Type:=BackupRestoreType;
        Rec.Format:=Rec.Format::CSV;
        Rec.Data.CreateOutStream(OutS, TextEncoding::UTF8);
        Rec.Description:=SetupIOMgt.GenSettingsStorageDescription(BackupRestoreType);
        CopyStream(OutS, InS);
        Rec.Insert();
        EventLogMgt.LogInfo(Rec."Entry No.", enum::DYM_EventLogSourceType::"Settings Storage", StrSubstNo(EventLogMsgPattern, 'Upload', UserId), '');
    end;
    procedure RestoreStorageEntry()
    var
        Truncate: Boolean;
    begin
        Rec.TestField(Format, Format::CSV);
        Truncate:=Confirm(Text003, false);
        if(Truncate)then TruncateTables(Rec.Type);
        ImportSettingsStorageData(Rec.Type);
    end;
    local procedure TruncateTables(BackupRestoreType: Enum DYM_BackupRestoreType)
    var
        SetupIOHandler: Codeunit DYM_SetupIOHandler;
    begin
        case Rec.Type of BackupRestoreType::Full: SetupIOHandler.TruncateFull();
        BackupRestoreType::Mapping: SetupIOHandler.TruncateMapping();
        BackupRestoreType::"Device Hierarchy": SetupIOHandler.TruncateDeviceHierarchy();
        BackupRestoreType::Settings: SetupIOHandler.TruncateSettings();
        BackupRestoreType::"Log tables": SetupIOHandler.TruncateLogTables();
        end;
        EventLogMgt.LogInfo(Rec."Entry No.", enum::DYM_EventLogSourceType::"Settings Storage", StrSubstNo(EventLogMsgPattern, 'TruncateTables', UserId), '');
    end;
    local procedure ImportSettingsStorageData(BackupRestoreType: Enum DYM_BackupRestoreType)
    var
        SetupIOMgt: Codeunit DYM_SetupIOManagement;
        SetupIOHandler: Codeunit DYM_SetupIOHandler;
    begin
        clear(SetupIOMgt);
        SetupIOHandler.SetSettingsStorageEntry(Rec);
        case Rec.Type of BackupRestoreType::Full: SetupIOHandler.ImportFull(false);
        BackupRestoreType::Mapping: SetupIOHandler.ImportMapping(false);
        BackupRestoreType::"Device Hierarchy": SetupIOHandler.ImportDeviceHierarchy(false);
        BackupRestoreType::Settings: SetupIOHandler.ImportSettings(false);
        BackupRestoreType::"Log tables": SetupIOHandler.ImportLogTables(false);
        end;
        EventLogMgt.LogInfo(Rec."Entry No.", enum::DYM_EventLogSourceType::"Settings Storage", StrSubstNo(EventLogMsgPattern, 'Import ' + Format(Rec.Type), UserId), '');
    end;
}
