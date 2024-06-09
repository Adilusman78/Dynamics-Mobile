codeunit 84007 DYM_PacketManagement
{
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    EventLogMgt: Codeunit DYM_EventLogManagement;
    SyncMgt: Codeunit DYM_SyncManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    GeneralDP: Codeunit DYM_GeneralDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    SDSHandler: Codeunit DYM_SessionDataStoreHandler;
    SetupCheckPointCounter: Integer;
    SettingsCheckPointCounter: Integer;
    SetupRead: Boolean;
    ParamsText: Text;
    DeviceFilterText: Text;
    Params: List of[Text];
    Param_Fetch: Label 'FETCH', Locked = true;
    Param_Load: Label 'LOAD', Locked = true;
    Param_LoadBLOB: Label 'LOADBLOB', Locked = true;
    Param_Parse: Label 'PARSE', Locked = true;
    Param_Process: Label 'PROCESS', Locked = true;
    Param_Process_Regular: Label 'PROCESS_REGULAR', Locked = true;
    Param_Process_Internal: Label 'PROCESS_INTERNAL', Locked = true;
    Param_PostProcess: Label 'POSTPROCESS', Locked = true;
    Param_Upload: Label 'UPLOAD', Locked = true;
    Param_All: Label 'ALL', Locked = true;
    Text000: Label 'Dynamics Mobile dispatcher started.';
    Text001: Label 'Dynamics Mobile packet scheduler is already running!';
    MsgOpState: Label '[%1][%2][%3]', Locked = true;
    OpStatus_Start: Label 'START', Locked = true;
    OpStatus_Failed: Label 'FAILED', Locked = true;
    OpStatus_Success: Label 'SUCCESS', Locked = true;
    trigger OnRun()
    var
        MaxJobProcessCalls: Integer;
        JobProcessCallDelay: Integer;
        JobStartTime, CurrentTime: DateTime;
        JobRunDuration: Duration;
        JobProcessCalls: Integer;
        JobProcessingDone: Boolean;
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if(ParamsText = '')then setParams('');
        Clear(MaxJobProcessCalls);
        Case SettingsMgt.CheckGlobalSetting(ConstMgt.BOS_MaxJobProcessCalls())of false: MaxJobProcessCalls:=1;
        true: MaxJobProcessCalls:=LowLevelDP.Text2Integer(SettingsMgt.GetGlobalSetting(ConstMgt.BOS_MaxJobProcessCalls()));
        end;
        Clear(JobProcessCallDelay);
        if SettingsMgt.CheckGlobalSetting(ConstMgt.BOS_JobProcessCallDelay())then JobProcessCallDelay:=LowLevelDP.Text2Integer(SettingsMgt.GetGlobalSetting(ConstMgt.BOS_JobProcessCallDelay()));
        clear(JobStartTime);
        JobStartTime:=CreateDateTime(today, time);
        clear(JobProcessingDone);
        clear(JobProcessCalls);
        Repeat JobProcessCalls+=1;
            //Call processing method
            RunProcessingJob();
            //Max runs reached
            if(JobProcessCalls >= MaxJobProcessCalls)then JobProcessingDone:=true;
            //Max duration reached
            JobRunDuration:=CreateDateTime(today, time) - JobStartTime;
            if(JobRunDuration > GetMaxJobRunDuration())then JobProcessingDone:=true;
            if(JobProcessCallDelay > 0)then Sleep(JobProcessCallDelay);
        until JobProcessingDone;
    end;
    procedure GetMaxJobRunDuration(): Duration begin
        exit(1000 * 60); // One minute = 1000 miliseconds (in a second) * 60 seconds (in a minute)
    end;
    procedure RunProcessingJob()
    begin
        ProcessWaiting(false);
        if(MobileSetup."Packet Process Retry Enabled")then ProcessWaiting(true);
    end;
    procedure ProcessWaiting(Retry: Boolean)
    var
        SyncLog: Record DYM_SyncLog;
        ProcSyncLog: Record DYM_SyncLog;
        PostProcessLog: Record DYM_PostProcessLog;
        ProcPostProcessLog: Record DYM_PostProcessLog;
        BLOBStoreEntry: Record DYM_BLOBStore;
        ProcBLOBStoreEntry: Record DYM_BLOBStore;
        IntegrityMgt: Codeunit DYM_IntegrityManagement;
        SyncLogEntryFound: Boolean;
        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        Clear(IntegrityMgt);
        IntegrityMgt.TestModulesIntegrity(false);
        SettingsMgt.TestSetting(ConstMgt.BOS_PacketStorageType());
        /////////////////////////////
        //    Fetching             //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_Fetch))then begin
            HeartBeatMgt.CreateHeartBeat_Fetch();
            FetchSyncLogEntries();
        end;
        /////////////////////////////
        //    Loading              //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_Load))then begin
            SyncLog.Reset;
            SyncLog.SetCurrentKey(Company, Direction, Status, Priority);
            SyncLog.SetRange(Company, CompanyName);
            SyncLog.SetRange(Direction, SyncLog.Direction::Push);
            //SyncLog.SetRange(Status, SyncLog.Status::Pending);
            case Retry of false: SyncLog.SetRange(Status, SyncLog.Status::Pending);
            true: begin
                SyncLog.SetRange(Status, SyncLog.Status::LoadError);
                SyncLog.SetFilter("Next Process TimeStamp", '<=%1', CreateDateTime(Today, Time));
                if(MobileSetup."Skip Processing Older (Days)" <> 0)then SyncLog.SetFilter("Entry TimeStamp", '>=%1', CreateDateTime(Today - MobileSetup."Skip Processing Older (Days)", Time));
            end;
            end;
            if(DeviceFilterText <> '')then SyncLog.SetFilter("Device Setup Code", DeviceFilterText);
            if SyncLog.FindSet(false, false)then repeat CacheMgt.SetContextSLE(SyncLog."Entry No.");
                    HeartBeatMgt.CreateHeartBeat_SyncLog(SyncLog.Path, enum::DYM_JobQueueOperation::Load);
                    ProcSyncLog.Get(SyncLog."Entry No.");
                    LoadSyncLogEntry(ProcSyncLog);
                    CacheMgt.ClearContextSLE();
                until SyncLog.Next = 0;
        end;
        /////////////////////////////
        //    Parsing              //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_Parse))then begin
            SyncLog.Reset;
            SyncLog.SetCurrentKey(Company, Direction, Status, Priority);
            SyncLog.SetRange(Company, CompanyName);
            SyncLog.SetRange(Direction, SyncLog.Direction::Push);
            SyncLog.SetRange(Status, SyncLog.Status::Loaded);
            if(DeviceFilterText <> '')then SyncLog.SetFilter("Device Setup Code", DeviceFilterText);
            if SyncLog.FindSet(false, false)then repeat CacheMgt.SetContextSLE(SyncLog."Entry No.");
                    HeartBeatMgt.CreateHeartBeat_SyncLog(SyncLog.Path, enum::DYM_JobQueueOperation::Parse);
                    ProcSyncLog.Get(SyncLog."Entry No.");
                    ParseSyncLogEntry(ProcSyncLog);
                    CacheMgt.ClearContextSLE();
                until SyncLog.Next = 0;
        end;
        /////////////////////////////
        //    Processing           //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_Process) OR (params.Contains(Param_Process_Internal)) OR (params.Contains(Param_Process_Regular)))then begin
            SyncLog.Reset;
            SyncLog.SetCurrentKey(Company, Direction, Status, Priority);
            SyncLog.SetRange(Company, CompanyName);
            SyncLog.SetRange(Direction, SyncLog.Direction::Push);
            if((not params.Contains(Param_All)) AND (not params.Contains(Param_Process)))then begin
                if(params.Contains(Param_Process_Internal))then SyncLog.SetRange(Internal, true);
                if(params.Contains(Param_Process_Regular))then begin
                    SyncLog.SetRange(Internal, false);
                end end;
            if(DeviceFilterText <> '')then SyncLog.SetFilter("Device Setup Code", DeviceFilterText);
            case Retry of false: SyncLog.SetRange(Status, SyncLog.Status::Parsed);
            true: begin
                SyncLog.SetFilter(Status, '%1|%2', SyncLog.Status::Failed, SyncLog.Status::InProgress);
                SyncLog.SetFilter("Next Process TimeStamp", '<=%1', CreateDateTime(Today, Time));
                if(MobileSetup."Skip Processing Older (Days)" <> 0)then begin
                    SyncLog.SetFilter("Entry TimeStamp", '>=%1', CreateDateTime(Today - MobileSetup."Skip Processing Older (Days)", Time));
                end;
            end;
            end;
            Clear(SyncLogEntryFound);
            if SyncLog.FindSet(false, false)then begin
                SyncLogEntryFound:=true;
                repeat CacheMgt.SetContextSLE(SyncLog."Entry No.");
                    HeartBeatMgt.CreateHeartBeat_SyncLog(ProcSyncLog.Path, enum::DYM_JobQueueOperation::Process);
                    ProcSyncLog.Get(SyncLog."Entry No.");
                    ProcessSyncLogEntry(ProcSyncLog);
                    CacheMgt.ClearContextSLE();
                    PostProcessLog.Reset;
                    PostProcessLog.SetRange(Company, CompanyName);
                    PostProcessLog.SetRange(Status, PostProcessLog.Status::Pending);
                    PostProcessLog.SetRange("Sync Log Entry No.", SyncLog."Entry No.");
                    if PostProcessLog.FindSet(false, false)then repeat CacheMgt.SetContextPPE(PostProcessLog."Entry No.");
                            HeartBeatMgt.CreateHeartBeat_PostProcess(ProcPostProcessLog.Data);
                            ProcPostProcessLog.Get(PostProcessLog."Entry No.");
                            ProcessPostProcessEntry(ProcPostProcessLog);
                            CacheMgt.ClearContextPPE();
                        until PostProcessLog.Next = 0;
                until SyncLog.Next = 0;
            end;
        end;
        /////////////////////////////
        //    Post-Processing      //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_PostProcess))then begin
            if not SyncLogEntryFound then begin
                PostProcessLog.Reset;
                PostProcessLog.SetRange(Company, CompanyName);
                if(DeviceFilterText <> '')then PostProcessLog.SetFilter("Device Setup Code", DeviceFilterText);
                case Retry of false: PostProcessLog.SetRange(Status, PostProcessLog.Status::Pending);
                true: begin
                    PostProcessLog.SetRange(Status, PostProcessLog.Status::Failed);
                    PostProcessLog.SetFilter("Next Process TimeStamp", '<=%1', CreateDateTime(Today, Time));
                    if(MobileSetup."Skip Processing Older (Days)" <> 0)then begin
                        SyncLog.SetFilter("Entry TimeStamp", '>=%1', CreateDateTime(Today - MobileSetup."Skip Processing Older (Days)", Time));
                    end;
                end;
                end;
                if PostProcessLog.FindSet(false, false)then repeat CacheMgt.SetContextPPE(PostProcessLog."Entry No.");
                        HeartBeatMgt.CreateHeartBeat_PostProcess(ProcPostProcessLog.Data);
                        ProcPostProcessLog.Get(PostProcessLog."Entry No.");
                        ProcessPostProcessEntry(ProcPostProcessLog);
                        CacheMgt.ClearContextPPE();
                    until PostProcessLog.Next = 0;
            end;
        end;
        /////////////////////////////
        //    Loading BLOB Store   //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_LoadBLOB))then begin
            BLOBStoreEntry.Reset();
            BLOBStoreEntry.SetRange(Status, BLOBStoreEntry.Status::Pending);
            if BLOBStoreEntry.FindSet(false, false)then repeat CacheMgt.SetContextBSE(BLOBStoreEntry."Entry No.");
                    HeartBeatMgt.CreateHeartBeat_LoadBlobStore(ProcBLOBStoreEntry.Identifier);
                    ProcBLOBStoreEntry.Get(BLOBStoreEntry."Entry No.");
                    LoadBLOBStoreEntry(ProcBLOBStoreEntry);
                    CacheMgt.ClearContextBSE();
                until BLOBStoreEntry.next = 0;
        end;
        /////////////////////////////
        //    Uploading            //
        /////////////////////////////
        if(params.Contains(Param_All)) OR (params.Contains(Param_Upload))then begin
            SyncLog.Reset;
            SyncLog.SetCurrentKey(Company, Direction, Status, Priority);
            SyncLog.SetRange(Company, CompanyName);
            SyncLog.SetRange(Direction, SyncLog.Direction::Pull);
            SyncLog.SetRange(Status, SyncLog.Status::Pending);
            if(DeviceFilterText <> '')then SyncLog.SetFilter("Device Setup Code", DeviceFilterText);
            //FileSystem storage type needs to leave Pull entries in Pending status, so we use Internal flag field instead
            if(SettingsMgt.GetSetting(ConstMgt.BOS_PacketStorageType()) = ConstMgt.BOS_PacketStorageType_FileSystem())then SyncLog.SetRange(Internal, false);
            if SyncLog.FindSet(false, false)then repeat CacheMgt.SetContextSLE(SyncLog."Entry No.");
                    HeartBeatMgt.CreateHeartBeat_Upload(ProcSyncLog.Path);
                    ProcSyncLog.Get(SyncLog."Entry No.");
                    LoadSyncLogEntry(ProcSyncLog);
                    CacheMgt.ClearContextSLE();
                until SyncLog.Next = 0;
        end;
    end;
    procedure FetchSyncLogEntries()
    var
        DummySyncLog: Record DYM_SyncLog;
        PacketStorageMgt: Codeunit DYM_PacketStorageManagement;
        EnvIdMgt: Codeunit DYM_EnvIdManagement;
    begin
        clear(EnvIdMgt);
        EnvIdMgt.verifyEnvId();
        CacheMgt.SetContextSLE(0);
        clear(PacketStorageMgt);
        clear(DummySyncLog);
        PacketStorageMgt.Run(DummySyncLog);
    end;
    procedure LoadSyncLogEntry(var SyncLog: Record DYM_SyncLog)
    var
        SyncLog2: Record DYM_SyncLog;
        PacketStorageMgt: Codeunit DYM_PacketStorageManagement;
        Result: Boolean;
    begin
        SyncLog2.Get(SyncLog."Entry No.");
        SyncLog2.Status:=SyncLog2.Status::Loading;
        SyncLog2.Modify;
        EventLogMgt.LogInfo(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Loading, StrSubstNo(MsgOpState, Param_Load, OpStatus_Start, SyncLog."Entry No."), '');
        Commit;
        CacheMgt.ClearStateDescription;
        Clear(PacketStorageMgt);
        SyncLog.Get(synclog."Entry No.");
        Result:=PacketStorageMgt.Run(SyncLog);
        SyncLog2.Reset;
        SyncLog2.Get(SyncLog."Entry No.");
        case Result of false: begin
            Clear(StatsMgt);
            SyncLog2.Status:=SyncLog2.Status::LoadError;
            SyncLog2."Error Description":=CopyStr(GetLastErrorText, 1, MaxStrLen(SyncLog2."Error Description"));
            SyncLog2."Last State":=CacheMgt.GetStateDescription;
            if MobileSetup."Packet Process Retry Enabled" then begin
                SyncLog2."Retries count"+=1;
                SyncLog2.Priority+=1;
                SyncLog2."Next Process TimeStamp":=CreateDateTime(Today, Time) + MobileSetup."Process Wait Time (sec)" * 1000;
            end;
            EventLogMgt.LogError(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Loading, StrSubstNo(MsgOpState, Param_Load, OpStatus_Failed, SyncLog."Entry No."), '');
            SyncLog2.Modify;
        end;
        true: begin
            case SyncLog2.Direction of synclog2.Direction::Push: SyncLog2.Status:=SyncLog2.Status::Loaded;
            SyncLog2.Direction::Pull: case synclog2.Internal of false: SyncLog2.Status:=SyncLog2.Status::Success;
                true: SyncLog2.Status:=SyncLog2.Status::Pending;
                end;
            end;
            Clear(SyncLog2."Error Description");
            Clear(SyncLog2."Last State");
            clear(SyncLog2."Next Process TimeStamp");
            clear(synclog2."Retries count");
            SyncLog2."End TimeStamp":=CreateDateTime(Today, Time);
            SyncLog2.Modify;
            EventLogMgt.LogInfo(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Loading, StrSubstNo(MsgOpState, Param_Load, OpStatus_Success, SyncLog."Entry No."), '');
        end;
        end;
        Commit;
    end;
    procedure ParseSyncLogEntry(var SyncLog: Record DYM_SyncLog)
    var
        SyncLog2: Record DYM_SyncLog;
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        RawDP: Codeunit DYM_RawDataProcessing;
        Result: Boolean;
    begin
        SyncLog2.Get(SyncLog."Entry No.");
        SyncLog2."Start TimeStamp":=CreateDateTime(Today, Time);
        SyncLog2.Status:=SyncLog2.Status::Parsing;
        SyncLog2.Modify;
        Clear(StatsMgt);
        EventLogMgt.LogInfo(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Parsing, StrSubstNo(MsgOpState, Param_Parse, OpStatus_Start, SyncLog."Entry No."), '');
        Commit;
        CacheMgt.ClearStateDescription;
        Clear(RawDP);
        Result:=RawDP.Run(SyncLog);
        SyncLog2.Reset;
        SyncLog2.Get(SyncLog."Entry No.");
        case Result of false: begin
            Clear(StatsMgt);
            SyncLog2.Status:=SyncLog2.Status::ParseError;
            SyncLog2."Error Description":=CopyStr(GetLastErrorText, 1, MaxStrLen(SyncLog2."Error Description"));
            SyncLog2."Last State":=CacheMgt.GetStateDescription;
            EventLogMgt.LogError(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Parsing, StrSubstNo(MsgOpState, Param_Parse, OpStatus_Failed, SyncLog."Entry No."), '');
            SyncLog2.Modify;
        end;
        true: begin
            SyncLog2.Status:=SyncLog2.Status::Parsed;
            Clear(SyncLog2."Error Description");
            Clear(SyncLog2."Last State");
            SyncLog2."End TimeStamp":=CreateDateTime(Today, Time);
            SyncLog2.Modify;
            EventLogMgt.LogInfo(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Parsing, StrSubstNo(MsgOpState, Param_Parse, OpStatus_Success, SyncLog."Entry No."), '');
        end;
        end;
        Commit;
    end;
    procedure ProcessSyncLogEntry(var SyncLog: Record DYM_SyncLog)
    var
        SyncLog2: Record DYM_SyncLog;
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        Result: Boolean;
    begin
        SyncLog2.Get(SyncLog."Entry No.");
        SyncLog2."Start TimeStamp":=CreateDateTime(Today, Time);
        SyncLog2.Status:=SyncLog2.Status::InProgress;
        SyncLog2.Modify;
        Clear(StatsMgt);
        EventLogMgt.LogInfo(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Processing, StrSubstNo(MsgOpState, Param_Process, OpStatus_Start, SyncLog."Entry No."), '');
        Commit;
        CacheMgt.ClearStateDescription;
        CacheMgt.ClearOperationHint();
        CacheMgt.ClearOperationData();
        Clear(GlobalDP);
        Result:=GlobalDP.Run(SyncLog);
        //GlobalDP.RUN ( SyncLog ) ;
        //Result := TRUE ;
        SyncLog2.Reset;
        SyncLog2.Get(SyncLog."Entry No.");
        case Result of false: begin
            Clear(StatsMgt);
            SyncLog2.Status:=SyncLog2.Status::Failed;
            SyncLog2."Operation Hint":=CacheMgt.GetOperationHint();
            SyncLog2."Error Description":=CopyStr(GetLastErrorText, 1, MaxStrLen(SyncLog2."Error Description"));
            SyncLog2."Last State":=CacheMgt.GetStateDescription;
            if MobileSetup."Packet Process Retry Enabled" then begin
                SyncLog2."Retries count"+=1;
                SyncLog2.Priority+=1;
                SyncLog2."Next Process TimeStamp":=CreateDateTime(Today, Time) + MobileSetup."Process Wait Time (sec)" * 1000;
                if(SyncLog2."Retries count" > MobileSetup."Max Tries Count")then begin
                    SyncLog2.Status:=SyncLog2.Status::Error;
                    EventLogMgt.LogError(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Processing, StrSubstNo(MsgOpState, Param_Process, OpStatus_Failed, SyncLog."Entry No."), '');
                end
                else
                    EventLogMgt.LogWarning(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Processing, StrSubstNo(MsgOpState, Param_Process, OpStatus_Failed, SyncLog."Entry No."), '');
            end;
            SyncLog2.Modify;
            OnAfterSetSyncLogStatus(SyncLog2);
        end;
        true: begin
            SyncLog2.Status:=SyncLog2.Status::Success;
            SyncLog2."Operation Hint":=CacheMgt.GetOperationHint();
            Clear(SyncLog2."Error Description");
            Clear(SyncLog2."Last State");
            SyncLog2."End TimeStamp":=CreateDateTime(Today, Time);
            SyncLog2.Modify;
            EventLogMgt.LogInfo(SyncLog."Entry No.", enum::DYM_EventLogSourceType::Processing, StrSubstNo(MsgOpState, Param_Process, OpStatus_Success, SyncLog."Entry No."), '');
            OnAfterSetSyncLogStatus(SyncLog2);
        end;
        end;
        Commit;
    end;
    procedure ProcessPostProcessEntry(var PostProcessLog: Record DYM_PostProcessLog)
    var
        PostProcessLog2: Record DYM_PostProcessLog;
        PostProcessMgt: Codeunit DYM_PostProcessManagement;
        Result: Boolean;
    begin
        PostProcessLog2.Get(PostProcessLog."Entry No.");
        PostProcessLog2.Status:=PostProcessLog2.Status::InProgress;
        PostProcessLog2."Start TimeStamp":=CreateDateTime(Today, Time);
        PostProcessLog2.Modify;
        Commit;
        Clear(PostProcessMgt);
        Result:=PostProcessMgt.Run(PostProcessLog);
        PostProcessLog2.Reset;
        PostProcessLog2.Get(PostProcessLog."Entry No.");
        PostProcessLog2."End TimeStamp":=CreateDateTime(Today, Time);
        case Result of false: begin
            case SDSHandler.PP_Flag_Skipped_Pop(PostProcessLog2)of true: begin
                PostProcessLog2.Status:=PostProcessLog2.Status::Skipped;
                clear(PostProcessLog2.Message);
            end;
            false: begin
                Clear(StatsMgt);
                PostProcessLog2.Status:=PostProcessLog2.Status::Failed;
                PostProcessLog2.Message:=CopyStr(GetLastErrorText, 1, MaxStrLen(PostProcessLog2.Message));
                if MobileSetup."Packet Process Retry Enabled" then begin
                    PostProcessLog2."Retries count"+=1;
                    PostProcessLog2.Priority+=1;
                    PostProcessLog2."Next Process TimeStamp":=CreateDateTime(Today, Time) + MobileSetup."Process Wait Time (sec)" * 1000;
                    if(PostProcessLog2."Retries count" > MobileSetup."Max Tries Count")then begin
                        PostProcessLog2.Status:=PostProcessLog2.Status::Error;
                    //EventLogMgt.InsertEventLogEntry ( SyncLog."Entry No." , 3 , 2 , STRSUBSTNO ( Text003 , SyncLog."Entry No." ) ) ;
                    end; //ELSE
                //EventLogMgt.InsertEventLogEntry ( SyncLog."Entry No." , 2 , 2 , STRSUBSTNO ( Text003 , SyncLog."Entry No." ) ) ;
                end;
            end;
            end;
            PostProcessLog2.Modify;
        end;
        true: begin
            PostProcessLog2.Status:=PostProcessLog2.Status::Success;
            Clear(PostProcessLog2.Message);
            PostProcessLog2.Modify;
        end;
        end;
        Commit;
    end;
    procedure LoadBLOBStoreEntry(var BLOBStoreEntry: Record DYM_BLOBStore)
    var
        BLOBStoreEntry2: Record DYM_BLOBStore;
        SyncLog: record DYM_SyncLog;
        PacketStorageMgt: Codeunit DYM_PacketStorageManagement;
        Result: Boolean;
    begin
        BLOBStoreEntry2.Get(BLOBStoreEntry."Entry No.");
        BLOBStoreEntry2.Status:=BLOBStoreEntry2.Status::Loading;
        BLOBStoreEntry2.Modify;
        EventLogMgt.LogInfo(BLOBStoreEntry."Entry No.", enum::DYM_EventLogSourceType::Loading, StrSubstNo(MsgOpState, Param_LoadBLOB, OpStatus_Start, SyncLog."Entry No."), '');
        Commit;
        CacheMgt.ClearStateDescription;
        Clear(PacketStorageMgt);
        BLOBStoreEntry.Get(BLOBStoreEntry."Entry No.");
        Clear(synclog);
        SyncLog."Entry No.":=-BLOBStoreEntry."Entry No.";
        Result:=PacketStorageMgt.Run(SyncLog);
        BLOBStoreEntry2.Reset;
        BLOBStoreEntry2.Get(BLOBStoreEntry."Entry No.");
        case Result of false: begin
            Clear(StatsMgt);
            BLOBStoreEntry2.Status:=BLOBStoreEntry2.Status::LoadError;
            EventLogMgt.LogError(BLOBStoreEntry."Entry No.", enum::DYM_EventLogSourceType::Loading, StrSubstNo(MsgOpState, Param_LoadBLOB, OpStatus_Failed, SyncLog."Entry No."), '');
            BLOBStoreEntry2.Modify;
        end;
        true: begin
            BLOBStoreEntry2.Status:=BLOBStoreEntry2.Status::Loaded;
            BLOBStoreEntry2.Modify;
            EventLogMgt.LogInfo(BLOBStoreEntry."Entry No.", enum::DYM_EventLogSourceType::Loading, StrSubstNo(MsgOpState, Param_LoadBLOB, OpStatus_Success, SyncLog."Entry No."), '');
        end;
        end;
        Commit;
    end;
    procedure SettingsCheckPoint()
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if MobileSetup."DES Changed" then begin
            SyncMgt.ForceExportDES;
            SyncMgt.ClearDESChanged;
        end;
        if MobileSetup."DBS Changed" then begin
            SyncMgt.ForceExportDBS;
            SyncMgt.ClearDBSChanged;
        end;
        Clear(SetupRead);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
    end;
    procedure SetupCheckPoint()
    begin
        CacheMgt.SetCheckPoint(true);
    end;
    procedure CheckSetup()
    var
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        Cue: Record DYM_DynamicsMobileCue;
    begin
        Clear(SettingsMgt);
        if not MobileSetup."Dynamics Mobile initialized" then begin
            SettingsMgt.ImportDefaultData;
            Clear(SetupRead);
            CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        end;
        if not Cue.Get then begin
            Cue.Init;
            Cue.Insert;
        end;
        Commit;
    end;
    procedure setParams(_Params: Text)
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        ParamText: Text;
        i: Integer;
    begin
        ParamsText:=_Params;
        for i:=1 to LowLevelDP.GetSubStrCount(ParamsText)do begin
            ParamText:=UpperCase(SelectStr(i, ParamsText));
            case LowLevelDP.IsCurlyBracketEncapsulated(ParamText)of false: Params.Add(ParamText);
            true: DeviceFilterText:=CopyStr(ParamText, 2, StrLen(ParamText) - 2);
            end;
        end;
        if(ParamsText = '')then Params.Add(Param_All);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterSetSyncLogStatus(var SyncLog: Record DYM_SyncLog)
    begin
    end;
}
