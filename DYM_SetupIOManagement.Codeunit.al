codeunit 84021 DYM_SetupIOManagement
{
    var FileMgt: Codeunit "File Management";
    TempBlob: Codeunit "Temp Blob";
    EventLogMgt: Codeunit DYM_EventLogManagement;
    DebugMgt: Codeunit DYM_DebugManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    SettingsStorage: Record DYM_SettingsStorage;
    ExportFormat: Enum DYM_BackupRestoreFormat;
    Filename: Text;
    //StreamReader: InStream;
    StreamWriter: OutStream;
    RecRef: RecordRef;
    dlg: Dialog;
    Filesize: Integer;
    ImportPos: Integer;
    ImportOldPos: Integer;
    i: Integer;
    DummyLine: Text;
    TableName: Text;
    Progress: Integer;
    Version_Full: Label 'F_DynaMo40_NAV71W1', Locked = true;
    Version_Settings: Label 'S_DynaMo40_NAV71W1', Locked = true;
    Version_DeviceHierarchy: Label 'D_DynaMo40_NAV71W1', Locked = true;
    Version_Mapping: Label 'M_DynaMo40_NAV71W1', Locked = true;
    Version_DMLog: Label 'L_DynaMo40_NAV71W1', Locked = true;
    SettingsFileExtension: Label 'txt', Locked = true;
    EventLogMsgPattern: Label '[%1][%2]', Locked = true;
    JsonTableNamePatter: Label '%1_%2', Locked = true;
    FS_Date: Label '<Year4><Month,2><Day,2>', Locked = true;
    FS_Time: Label '<Hours24,2><Minutes,2><Seconds,2>', Locked = true;
    Text001: Label 'Packet version doen not match Dynamics Mobile version.\Dynamics Mobile version : %1.\File version : %2.';
    Text002: Label 'Table   #1####################\Progress @2@@@@@@@@@@@@@@@@@@@@', Locked = true;
    Text003: Label 'You must select a file.';
    Text004: Label 'Json format is supported for export operations only.\It cannot be used for Restore operation.\Do you want to continue?';
    procedure ImportTable(var SR: InStream; TableNo: Integer)
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        RecRef: RecordRef;
        Line: Text;
    begin
        dlg.Update(1, LowLevelDP.GetTableName(TableNo));
        RecRef.Open(TableNo);
        repeat SR.ReadText(Line);
            if(Filesize <> 0)then begin
                ImportPos+=StrLen(Line) + 2;
                if(Round(ImportPos / Filesize * 10000, 1) <> ImportOldPos)then begin
                    ImportOldPos:=Round(ImportPos / Filesize * 10000, 1);
                    dlg.Update(2, ImportOldPos);
                end;
            end;
            if(Line <> '')then LowLevelDP.Text2RecordRef(Line, RecRef);
        until(Line = '');
    end;
    procedure ExportTable(var SW: OutStream; var JO: JsonObject; TableNo: Integer)
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        RecRef: RecordRef;
        RecCount: Integer;
        OldPos: Integer;
        Pos: Decimal;
        Step: Decimal;
        JArr: JsonArray;
    begin
        Clear(RecCount);
        Clear(OldPos);
        Clear(Pos);
        Clear(Step);
        dlg.Update(1, LowLevelDP.GetTableName(TableNo));
        if ExportFormat = ExportFormat::CSV then SW.WriteText();
        RecRef.Open(TableNo);
        RecRef.Reset;
        RecCount:=RecRef.Count;
        if(RecCount <> 0)then Step:=10000 / RecCount;
        if RecRef.FindSet(false, false)then repeat Pos+=Step;
                if(Round(Pos, 100) <> OldPos)then begin
                    OldPos:=Round(Pos, 100);
                    dlg.Update(2, OldPos);
                end;
                case ExportFormat of ExportFormat::CSV: begin
                    SW.WriteText(LowLevelDP.RecordRef2Text(RecRef));
                    SW.WriteText();
                end;
                ExportFormat::JSON: begin
                    JArr.Add(LowLevelDP.AddRecordRef2Json(RecRef));
                end;
                end;
            until RecRef.Next = 0;
        if ExportFormat = ExportFormat::JSON then JO.Add(StrSubstNo(JsonTableNamePatter, ConstMgt.SYN_Table(), LowLevelDP.GetTableName(TableNo)), JArr);
    end;
    procedure TruncateTable(TableNo: Integer)
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableNo);
        RecRef.Reset();
        RecRef.DeleteAll();
    end;
    procedure SelectInputFile()Result: Text begin
        clear(FileMgt);
        Result:=FileMgt.BLOBImport(TempBlob, '');
        if(Result = '')then Error(Text003);
    end;
    procedure WriteOutputFile()
    var
        ServerFilename: Text;
        ClientFilename: Text;
        BlobInStream: InStream;
    begin
        TempBlob.CreateInStream(BlobInStream, TextEncoding::UTF8);
        ClientFilename:=CreateGuid() + '.txt';
        FileMgt.BLOBExport(TempBlob, ClientFilename, true);
    //DownloadFromStream(BlobInStream, 'Export', '', 'All Files (*.*)|*.*', ClientFilename);
    end;
    procedure SetSettingsStorageEntry(_SettingsStorage: Record DYM_SettingsStorage)
    begin
        _SettingsStorage.CalcFields(Data);
        TempBlob.FromRecord(_SettingsStorage, _SettingsStorage.FieldNo(Data));
        SettingsStorage:=_SettingsStorage;
    end;
    procedure SetExportFormat(_ExportFormat: Enum DYM_BackupRestoreFormat): Boolean begin
        if(_ExportFormat = _ExportFormat::JSON)then if not Confirm(Text004, false)then exit(false);
        ExportFormat:=_ExportFormat;
        exit(true);
    end;
    procedure OpenStreamWriter(var SW: OutStream; var JO: JsonObject)
    begin
        Clear(TempBlob);
        TempBlob.CreateOutStream(SW, TextEncoding::UTF8);
        if(ExportFormat = ExportFormat::JSON)then Clear(JO);
        dlg.Open(Text002);
    end;
    procedure CloseStreamWriter()
    begin
        dlg.Close;
    end;
    procedure ImportVersion(var SR: InStream; VersionText: Text)
    var
        PacketVersionText: Text;
    begin
        SR.ReadText(PacketVersionText);
        if(VersionText <> PacketVersionText)then Error(Text001, VersionText, PacketVersionText);
        SR.ReadText(DummyLine);
    end;
    procedure ExportVersion(var SW: OutStream; var JO: JsonObject; VersionText: Text)
    begin
        case ExportFormat of ExportFormat::CSV: begin
            SW.WriteText(VersionText);
            sw.WriteText();
        end;
        ExportFormat::JSON: begin
            JO.Add('version', VersionText);
        end;
        end;
    end;
    procedure OpenStreamReader(var StreamReader: InStream)
    begin
        Clear(ImportPos);
        Clear(ImportOldPos);
        Filesize:=GetFileSize;
        TempBlob.CreateInStream(StreamReader, TextEncoding::UTF8);
        dlg.Open(Text002);
    end;
    procedure CloseStreamReader()
    begin
        dlg.Close;
    end;
    procedure GetFileSize()Result: Integer begin
        exit(TempBlob.Length())end;
    procedure WriteLine2Stream(ToStream: OutStream; TextLine: Text)
    begin
        if(TextLine <> '')then ToStream.WriteText(TextLine);
        ToStream.WriteText(LowLevelDP.CRLF());
    end;
    procedure ExportBlob(var SW: OutStream; var JO: JsonObject; BackupRestoreType: Enum DYM_BackupRestoreType)
    var
        SettingsStorage: Record DYM_SettingsStorage;
        FldRef: FieldRef;
        RecRef: RecordRef;
        InS: InStream;
        OutS: OutStream;
    begin
        if(ExportFormat = ExportFormat::JSON)then JO.WriteTo(SW);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        SettingsStorage.Init();
        SettingsStorage.Type:=BackupRestoreType;
        SettingsStorage.Format:=ExportFormat;
        SettingsStorage."Entry TimeStamp":=CreateDateTime(today, time);
        SettingsStorage.Description:=GenSettingsStorageDescription(BackupRestoreType);
        SettingsStorage.Data.CreateOutStream(OutS, TextEncoding::UTF8);
        CopyStream(OutS, InS);
        SettingsStorage.Insert();
        EventLogMgt.LogInfo(SettingsStorage."Entry No.", enum::DYM_EventLogSourceType::"Settings Storage", StrSubstNo(EventLogMsgPattern, 'Export ' + Format(SettingsStorage.Type), UserId), '');
    end;
    procedure GenSettingsStorageDescription(BackupRestoreType: Enum DYM_BackupRestoreType)Result: Text begin
        exit(StrSubstNo('%1_%2_%3', Format(BackupRestoreType), UserId, Format(today, 0, FS_Date) + Format(time, 0, FS_Time)));
    end;
}
