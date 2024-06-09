codeunit 84037 DYM_EventLogManagement
{
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    DebugMgt: Codeunit DYM_DebugManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    SetupRead: Boolean;
    SLE: Integer;
    local procedure InsertEventLogEntry(SourceEntryNo: BigInteger; EventType: enum DYM_EventLogEventType; SourceType: enum DYM_EventLogSourceType; Msg: Text[250]; _Data: Text)
    var
        EventLog: Record DYM_EventLog;
        OutS: OutStream;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not((DebugMgt.isLevelActive_Debug()) or (DebugMgt.isLevelActive_Trace()))then begin
            EventLog.Reset;
            EventLog.SetRange("Event Type", EventType);
            EventLog.SetRange("Source Type", SourceType);
            EventLog.SetRange("Source Entry No.", SourceEntryNo);
            EventLog.SetRange(Company, CompanyName);
            EventLog.SetRange(Message, Msg);
            if not EventLog.IsEmpty then exit;
        end;
        EventLog.Init;
        Clear(EventLog."Entry No.");
        EventLog."Entry TimeStamp":=CreateDateTime(Today, Time);
        EventLog."Event Type":=EventType;
        EventLog."Source Type":=SourceType;
        EventLog."Source Entry No.":=SourceEntryNo;
        EventLog.Company:=CompanyName;
        EventLog.Message:=Msg;
        EventLog.Insert;
        if(EventType = EventLog."Event Type"::Warning)then if DebugMgt.isLevelActive_Debug()then Message(Msg);
        IF(_Data = '')THEN EXIT;
        EventLog.Data.CREATEOUTSTREAM(OutS, TextEncoding::UTF8);
        OutS.WRITE(_Data);
        EventLog.MODIFY;
    end;
    #region Generic Log Methods
    procedure LogTrace(_SourceEntryNo: BigInteger; _SourceType: enum DYM_EventLogSourceType; _Msg: Text[250]; _Data: Text)
    begin
        if(DebugMgt.isLevelActive_Trace())then InsertEventLogEntry(_SourceEntryNo, DYM_EventLogEventType::Trace, _SourceType, _Msg, _Data);
    end;
    procedure LogDebug(_SourceEntryNo: BigInteger; _SourceType: enum DYM_EventLogSourceType; _Msg: Text[250]; _Data: Text)
    begin
        if(DebugMgt.isLevelActive_Debug())then InsertEventLogEntry(_SourceEntryNo, DYM_EventLogEventType::Debug, _SourceType, _Msg, _Data);
    end;
    procedure LogInfo(_SourceEntryNo: BigInteger; _SourceType: enum DYM_EventLogSourceType; _Msg: Text[250]; _Data: Text)
    begin
        InsertEventLogEntry(_SourceEntryNo, DYM_EventLogEventType::Info, _SourceType, _Msg, _Data);
    end;
    procedure LogWarning(_SourceEntryNo: BigInteger; _SourceType: enum DYM_EventLogSourceType; _Msg: Text[250]; _Data: Text)
    begin
        InsertEventLogEntry(_SourceEntryNo, DYM_EventLogEventType::Warning, _SourceType, _Msg, _Data);
    end;
    procedure LogError(_SourceEntryNo: BigInteger; _SourceType: enum DYM_EventLogSourceType; _Msg: Text[250]; _Data: Text)
    begin
        if(_Data = '')then _Data:=DebugMgt.GetLastErrorData();
        InsertEventLogEntry(_SourceEntryNo, DYM_EventLogEventType::Error, _SourceType, _Msg, _Data);
    end;
    #endregion 
    #region Fetch Log Methods
    procedure LogFetchTrace(_Msg: Text[250]; _Data: Text)
    begin
        if(DebugMgt.isLevelActive_Trace())then InsertEventLogEntry(0, DYM_EventLogEventType::Trace, DYM_EventLogSourceType::Fetch, _Msg, _Data);
    end;
    procedure LogFetchDebug(_Msg: Text[250]; _Data: Text)
    begin
        if(DebugMgt.isLevelActive_Debug())then InsertEventLogEntry(0, DYM_EventLogEventType::Debug, DYM_EventLogSourceType::Fetch, _Msg, _Data);
    end;
    procedure LogFetchInfo(_Msg: Text[250]; _Data: Text)
    begin
        InsertEventLogEntry(0, DYM_EventLogEventType::Info, DYM_EventLogSourceType::Fetch, _Msg, _Data);
    end;
    procedure LogFetchWarning(_Msg: Text[250]; _Data: Text)
    begin
        InsertEventLogEntry(0, DYM_EventLogEventType::Warning, DYM_EventLogSourceType::Fetch, _Msg, _Data);
    end;
    #endregion 
    #region Process Log Methods
    procedure LogProcessTrace(_Msg: Text[250]; _Data: Text)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if(DebugMgt.isLevelActive_Trace())then InsertEventLogEntry(SLE, DYM_EventLogEventType::Trace, DYM_EventLogSourceType::Processing, _Msg, _Data);
    end;
    procedure LogProcessDebug(_Msg: Text[250]; _Data: Text)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if(DebugMgt.isLevelActive_Debug())then InsertEventLogEntry(SLE, DYM_EventLogEventType::Debug, DYM_EventLogSourceType::Processing, _Msg, _Data);
    end;
    procedure LogProcessDebug_MethodStart()
    begin
        DebugMgt.PushCallStack();
        LogProcessDebug(StrSubstNo(ConstMgt.DBG_T_MethodStart(), DebugMgt.GetCallStackObject(), DebugMgt.GetCallStackMethod()), '');
    end;
    procedure LogProcessDebug_MethodEnd()
    begin
        DebugMgt.PushCallStack();
        LogProcessDebug(StrSubstNo(ConstMgt.DBG_T_MethodEnd(), DebugMgt.GetCallStackObject(), DebugMgt.GetCallStackMethod()), '');
    end;
    procedure LogProcessDebug_PullDuration(_TableId: Text; _PerfCounterId: Integer; RecRef: RecordRef)
    var
        PullDuration: Duration;
    begin
        PullDuration:=CacheMgt.StopPerfCounter(_PerfCounterId);
        LogProcessDebug(StrSubstNo(ConstMgt.DBG_T_PullDuration(), _TableId, PullDuration), '');
        CacheMgt.SetTableMetadata(_TableId, PullDuration, RecRef.Count);
    end;
    procedure LogProcessDebug_APICallDuration(_PerfCounterId: Integer)
    begin
        DebugMgt.PushCallStack();
        LogProcessDebug(StrSubstNo(ConstMgt.DBG_T_APICallDuration(), DebugMgt.GetCallStackMethod(), CacheMgt.StopPerfCounter(_PerfCounterId)), '');
    end;
    procedure LogProcessInfo(_Msg: Text[250]; _Data: Text)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        InsertEventLogEntry(SLE, DYM_EventLogEventType::Info, DYM_EventLogSourceType::Processing, _Msg, _Data);
    end;
    procedure LogProcessWarning(_Msg: Text[250]; _Data: Text)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        InsertEventLogEntry(SLE, DYM_EventLogEventType::Warning, DYM_EventLogSourceType::Processing, _Msg, _Data);
    end;
#endregion 
}
