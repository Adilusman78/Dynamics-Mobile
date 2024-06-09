table 84007 DYM_SyncLog
{
    Caption = 'Sync Log';
    DataPerCompany = false;
    DrillDownPageID = DYM_SyncLogEntries;
    LookupPageID = DYM_SyncLogEntries;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(4; Direction;enum DYM_PacketDirection)
        {
            DataClassification = SystemMetadata;
        }
        field(5; Status;enum DYM_PacketStatus)
        {
            DataClassification = SystemMetadata;
        }
        field(6; Path; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Error Description"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Start TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(10; "End TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(12; "NAS ID"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(13; Company; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(14; Priority; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(15; "Packet Type";enum DYM_PacketType)
        {
            DataClassification = SystemMetadata;
        }
        field(16; "Packet Size"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(17; "Last State"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(18; "Web Service Entry"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(19; "Request Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
        }
        field(101; Internal; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(102; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(103; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceGroup.Code;
        }
        field(104; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(105; "Pull Type";enum DYM_PullType)
        {
            DataClassification = SystemMetadata;
        }
        field(201; "Retries count"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(202; "Next Process TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(1001; Packet; BLOB)
        {
            DataClassification = SystemMetadata;
        }
        field(1002; Checksum; Text[32])
        {
            DataClassification = SystemMetadata;
        }
        field(1003; "Operation Hint"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Company, Direction, Status, Priority)
        {
        }
        key(Key3; Direction, Company, "NAS ID", "Device Role Code", "Device Group Code", "Device Setup Code", Checksum)
        {
        }
        key(Key4; Company, Direction, Status, "Device Role Code", "Device Group Code", "Device Setup Code")
        {
        }
    }
    fieldgroups
    {
    }
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    GlobalDP: Codeunit DYM_GlobalDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
    SetupRead: Boolean;
    Text001: Label 'Unable to enqueue file %1.';
    Text002: Label 'The status of Sync Log Entry No. %1 is %2. If you re-parse the entry the system will try to parse and process it again. The raw data will be read again from packet.Do you want to continue?';
    Text003: Label 'The status of Sync Log Entry No. %1 is %2. If you re-process the entry the system will try to execute business logic with current raw data. Do you want to continue?';
    Text004: Label 'The status of Sync Log Entry No. %1 is %2. If you re-parse the entry the system will try to load, parse and process it again. The packet will be loaded from storage location.Do you want to continue?';
    Text005: Label 'Sync Log Entry does not contain packet data.';
    Text006: Label 'The status of Sync Log Entry No. %1 is %2. The packet will be loaded from file content.Do you want to continue?';
    Text007: Label 'The status of Sync Log Entry No. %1 is %2. If you set the status to Debug the Sync Log Entry can not be handled.Do you want to continue?';
    procedure Enqueue()
    var
        SyncLog: Record DYM_SyncLog;
        TempFile: File;
        Filename: Text[250];
        InS: InStream;
        OutS: OutStream;
        NextEntry: Integer;
    begin
        Clear(Filename);
        Clear(Filename);
        if not UploadIntoStream('', '', ConstMgt.MSG_0003(), Filename, InS)then exit;
        Clear(NextEntry);
        SyncLog.LockTable;
        SyncLog.Reset;
        if SyncLog.FindLast then NextEntry:=SyncLog."Entry No.";
        NextEntry+=1;
        SyncLog.Init;
        SyncLog."Entry No.":=NextEntry;
        SyncLog."Entry TimeStamp":=CreateDateTime(Today, Time);
        SyncLog.Direction:=SyncLog.Direction::Push;
        SyncLog.Status:=SyncLog.Status::Loaded;
        SyncLog.Path:=Filename;
        SyncLog.Company:=CompanyName;
        SyncLog.Packet.CreateOutStream(OutS, TextEncoding::UTF8);
        CopyStream(OutS, InS);
        SyncLog.Insert;
    end;
    procedure Download()
    var
        inS: InStream;
        tempFilename: Text;
    begin
        CalcFields(Packet);
        if(not packet.HasValue)then error(Text005);
        packet.CreateInStream(inS, TextEncoding::UTF8);
        tempFilename:=CreateGuid() + '.xml';
        DownloadFromStream(inS, 'Export', '', 'All Files (*.*)|*.*', tempfilename);
    end;
    procedure ManualProcess()
    var
        ProcSyncLogEntry: Record DYM_SyncLog;
        PacketMgt: Codeunit DYM_PacketManagement;
    begin
        Clear(PacketMgt);
        ProcSyncLogEntry.Get("Entry No.");
        If(ProcSyncLogEntry.Status = ProcSyncLogEntry.Status::Pending)then PacketMgt.LoadSyncLogEntry(ProcSyncLogEntry);
        ProcSyncLogEntry.Find();
        if(ProcSyncLogEntry.Status = ProcSyncLogEntry.Status::Loaded)then PacketMgt.ParseSyncLogEntry(ProcSyncLogEntry);
        ProcSyncLogEntry.Find();
        if(ProcSyncLogEntry.Status = ProcSyncLogEntry.Status::Parsed)then PacketMgt.ProcessSyncLogEntry(ProcSyncLogEntry);
    end;
    procedure Debug(Force: Boolean)
    begin
        TestField(Direction, Direction::Push);
        if not Force then if not Confirm(Text007, false, "Entry No.", Status)then exit;
        LockTable;
        Status:=Status::Debug;
        Modify;
        Commit;
    end;
    procedure ReLoad(Force: Boolean)
    begin
        if(Status in[Status::Loaded, Status::Parsing, Status::Parsed, Status::InProgress, Status::Success])then if not Force then if not Confirm(Text004, false, "Entry No.", Status)then exit;
        LockTable;
        Clear(Status);
        Modify;
        Commit;
    end;
    procedure ReParse(Force: Boolean)
    begin
        if(Status in[Status::Parsing, Status::Parsed, Status::InProgress, Status::Success])then if not Force then if not Confirm(Text002, false, "Entry No.", Status)then exit;
        LockTable;
        Status:=Status::Loaded;
        Modify;
        Commit;
    end;
    procedure ReProcess(Force: Boolean)
    begin
        TestField(Direction, Direction::Push);
        if(Status in[Status::Parsing, Status::Parsed, Status::InProgress, Status::Success])then if not Force then if not Confirm(Text003, false, "Entry No.", Status)then exit;
        LockTable;
        Status:=Status::Parsed;
        Modify;
        Commit;
    end;
    procedure GetStatistics(var DeviceRoleCode: Code[20]; var DeviceGroupCode: Code[20]; var DeviceSetupCode: Code[100]; var RecStats: Record "Dimension Selection Buffer")
    begin
        Clear(StatsMgt);
        StatsMgt.GetStatistics(Rec, DeviceRoleCode, DeviceGroupCode, DeviceSetupCode, RecStats);
    end;
    procedure ShowStatistics()
    var
        SyncLogEntryStatsPage: Page DYM_SyncLogEntryStatistics;
    begin
        Clear(SyncLogEntryStatsPage);
        SyncLogEntryStatsPage.SetSyncLogEntry("Entry No.");
        SyncLogEntryStatsPage.RunModal;
    end;
    procedure GetNavigation(var RecStats: Record "Dimension Selection Buffer"; var AddDataLog: Record DYM_DataLog)
    begin
        Clear(StatsMgt);
        StatsMgt.GetNavigation(Rec, RecStats, AddDataLog, true);
    end;
    procedure ShowNavigation()
    var
        SyncLogEntryNavPage: Page DYM_SyncLogEntryNavigate;
    begin
        Clear(SyncLogEntryNavPage);
        SyncLogEntryNavPage.SetSyncLogEntry("Entry No.");
        SyncLogEntryNavPage.RunModal;
    end;
    procedure SmartNavigate()
    begin
        StatsMgt.SmartNavigate(Rec);
    end;
    procedure OpenPacket()
    begin
        if(Path <> '')then HyperLink(Path);
    end;
    procedure ImportPacket(Force: Boolean)
    var
        InS: InStream;
        OutS: OutStream;
        TempFilename: Text;
    begin
        TestField(Direction, Direction::Push);
        TestField(Internal, false);
        if(Status in[Status::Parsing, Status::Parsed, Status::InProgress, Status::Success])then if not Force then if not Confirm(Text006, false, "Entry No.", Status)then exit;
        LockTable();
        UploadIntoStream('Import', '', 'All Files (*.*)|*.*', TempFilename, InS);
        Packet.CreateOutStream(OutS, TextEncoding::UTF8);
        CopyStream(OutS, InS);
        Modify();
        Commit();
    end;
}
