codeunit 84044 DYM_DocumentTraceManagement
{
    var LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    TraceStatusTemplate_SyncLog: Label 'S:[%1]', Locked = true;
    TraceStatusTemplate_PostProcessLog: Label 'P:[%1]', Locked = true;
    procedure GetTraceStatus(RecRef: RecordRef; var TraceStatus: enum DYM_DocumentTraceStatus; var TraceSatusText: Text)
    var
        SyncLogTraceStatus: enum DYM_DocumentTraceStatus;
        PostProcessLogTraceStatus: enum DYM_DocumentTraceStatus;
        DummyEntryNo: Integer;
    begin
        clear(TraceStatus);
        clear(TraceSatusText);
        GetSyncLogTraceStatus(RecRef, SyncLogTraceStatus, DummyEntryNo);
        GetPostProcessLogTraceStatus(RecRef, PostProcessLogTraceStatus, DummyEntryNo);
        if((SyncLogTraceStatus <> SyncLogTraceStatus::None) OR (PostProcessLogTraceStatus <> PostProcessLogTraceStatus::None))then begin
            TraceStatus:=SyncLogTraceStatus;
            if(TraceStatus.AsInteger() < PostProcessLogTraceStatus.AsInteger())then TraceStatus:=PostProcessLogTraceStatus;
            if(SyncLogTraceStatus <> SyncLogTraceStatus::None)then TraceSatusText:=LowLevelDP.AddText2CommaSepList(TraceSatusText, StrSubstNo(TraceStatusTemplate_SyncLog, SyncLogTraceStatus));
            if(PostProcessLogTraceStatus <> PostProcessLogTraceStatus::None)then TraceSatusText:=LowLevelDP.AddText2CommaSepList(TraceSatusText, StrSubstNo(TraceStatusTemplate_PostProcessLog, PostProcessLogTraceStatus));
        end;
    end;
    procedure DrillDownTraceStatus(RecRef: RecordRef)
    var
        SyncLog: Record DYM_SyncLog;
        PostProcessLog: Record DYM_PostProcessLog;
        SyncLogTraceStatus: enum DYM_DocumentTraceStatus;
        PostProcessLogTraceStatus: enum DYM_DocumentTraceStatus;
        SyncLogEntryNo, PostProcessEntryNo: Integer;
    begin
        GetSyncLogTraceStatus(RecRef, SyncLogTraceStatus, SyncLogEntryNo);
        GetPostProcessLogTraceStatus(RecRef, PostProcessLogTraceStatus, PostProcessEntryNo);
        if(SyncLogTraceStatus <> SyncLogTraceStatus::None)then begin
            if SyncLog.Get(SyncLogEntryNo)then begin
                SyncLog.SetRecFilter();
                Page.RunModal(0, SyncLog);
            end;
        end
        else if(PostProcessLogTraceStatus <> PostProcessLogTraceStatus::None)then begin
                if PostProcessLog.Get(PostProcessEntryNo)then begin
                    PostProcessLog.SetRecFilter();
                    page.RunModal(0, PostProcessLog);
                end;
            end;
    end;
    local procedure GetSyncLogTraceStatus(RecRef: RecordRef; var SyncLogTraceStatus: enum DYM_DocumentTraceStatus; var SyncLogTraceEntryNo: Integer)
    var
        SyncLog: Record DYM_SyncLog;
        DataLog: Record DYM_DataLog;
        RawDataLog: Record DYM_RawDataLog;
        DeviceRole: Record DYM_DeviceRole;
        TableMap: Record DYM_MobileTableMap;
    begin
        clear(SyncLogTraceStatus);
        clear(SyncLogTraceEntryNo);
        DataLog.Reset();
        DataLog.SetCurrentKey("Sync Log Entry No.", "Table No.", Position);
        DataLog.SetFilter("Entry Type", '%1|%2', DataLog."Entry Type"::Create, DataLog."Entry Type"::Modify);
        DataLog.SetRange("Table No.", RecRef.Number);
        DataLog.SetRange(Position, LowLevelDP.RecordRefPK2Text(RecRef));
        if DataLog.FindSet()then repeat if(SyncLog."Entry No." <> DataLog."Sync Log Entry No.")then if SyncLog.Get(DataLog."Sync Log Entry No.")then if SyncLogStatus2TraceStatus(SyncLog.Status).AsInteger() > SyncLogTraceStatus.AsInteger()then begin
                            SyncLogTraceStatus:=SyncLogStatus2TraceStatus(SyncLog.Status);
                            SyncLogTraceEntryNo:=SyncLog."Entry No.";
                        end;
            until DataLog.Next() = 0;
        //Search through Raw Data Log 
        if(SyncLogTraceStatus = SyncLogTraceStatus::None)then begin
            DeviceRole.Reset();
            DeviceRole.SetRange(Type, DeviceRole.Type::Warehouse);
            if DeviceRole.FindFirst()then begin
                TableMap.Reset();
                TableMap.SetRange("Device Role Code", DeviceRole.Code);
                TableMap.SetRange("Table No.", RecRef.Number);
                TableMap.SetFilter(Direction, '%1|%2', TableMap.Direction::Push, TableMap.Direction::Both);
                TableMap.SetRange(Disabled, false);
                if TableMap.FindFirst()then begin
                    RawDataLog.Reset();
                    RawDataLog.SetCurrentKey("Sync Log Entry No.", "Entry Type", "Table Name", "Record No.", "Field Name", "Attribute Name", "Field Value");
                    RawDataLog.SetRange("Entry Type", RawDataLog."Entry Type"::Field);
                    RawDataLog.SetRange("Table Name", TableMap."Mobile Table");
                    RawDataLog.SetRange("Field Value", getRecRefDocumentNo(RecRef));
                    if RawDataLog.FindFirst()then begin
                        if SyncLog.Get(RawDataLog."Sync Log Entry No.")then begin
                            SyncLogTraceStatus:=SyncLogStatus2TraceStatus(SyncLog.Status);
                            SyncLogTraceEntryNo:=SyncLog."Entry No.";
                        end;
                    end;
                end;
            end;
        end;
    end;
    local procedure GetPostProcessLogTraceStatus(RecRef: RecordRef; var PostProcessLogTraceStatus: enum DYM_DocumentTraceStatus; var PostProcessLogTraceEntryNo: Integer)
    var
        PostProcessLog: Record DYM_PostProcessLog;
    begin
        clear(PostProcessLogTraceStatus);
        clear(PostProcessLogTraceEntryNo);
        PostProcessLog.Reset();
        PostProcessLog.SetCurrentKey("Table No.", Position);
        PostProcessLog.SetRange("Table No.", RecRef.Number);
        PostProcessLog.SetRange(Position, LowLevelDP.RecordRefPK2Text(RecRef));
        if PostProcessLog.FindSet()then repeat if PostProcessLogStatus2TraceStatus(PostProcessLog.Status).AsInteger() > PostProcessLogTraceStatus.AsInteger()then begin
                    PostProcessLogTraceStatus:=PostProcessLogStatus2TraceStatus(PostProcessLog.Status);
                    PostProcessLogTraceEntryNo:=PostProcessLog."Entry No.";
                end;
            until PostProcessLog.Next() = 0;
    end;
    local procedure SyncLogStatus2TraceStatus(SyncLogStatus: enum DYM_PacketStatus)Result: enum DYM_DocumentTraceStatus begin
        clear(Result);
        Case SyncLogStatus of SyncLogStatus::Failed, SyncLogStatus::Error: Result:=Result::Failed;
        SyncLogStatus::InProgress: Result:=Result::Pending;
        SyncLogStatus::Success: Result:=Result::Success;
        End;
    end;
    local procedure PostProcessLogStatus2TraceStatus(PostProcessLogStatus: enum DYM_PostProcessPacketStatus)Result: enum DYM_DocumentTraceStatus begin
        clear(Result);
        Case PostProcessLogStatus of PostProcessLogStatus::Failed, PostProcessLogStatus::Error: Result:=Result::Failed;
        PostProcessLogStatus::Pending, PostProcessLogStatus::InProgress: Result:=Result::Pending;
        PostProcessLogStatus::Success: Result:=Result::Success;
        End;
    end;
    local procedure getRecRefDocumentNo(RecRef: RecordRef)Result: Code[20]var
        PrimaryKeyRef: KeyRef;
        FldRef: FieldRef;
        i: Integer;
    begin
        clear(Result);
        PrimaryKeyRef:=RecRef.KeyIndex(1);
        for i:=1 to PrimaryKeyRef.FieldCount do begin
            FldRef:=PrimaryKeyRef.FieldIndex(i);
            if(FldRef.Type = FieldType::Code)then exit(FldRef.Value);
        end;
    end;
}
