codeunit 70126 DYM_HeartBeatManagement
{
    SingleInstance = true;

    var
        CacheMgt: Codeunit DYM_CacheManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        JobQueueEntry: Record "Job Queue Entry";
        StartTime, EndTime : DateTime;
        Text001: Label 'No Job Queue Entry Id context found.';

    procedure SetJobQueueEntry(var _JobQueueEntry: Record "Job Queue Entry")
    begin
        JobQueueEntry := _JobQueueEntry;
    end;

    procedure DeleteAllHeartBeats()
    var
        HeartBeat: Record DYM_HeartBeat;
    begin
        if (IsNullGuid(JobQueueEntry.ID)) then Error(Text001);
        HeartBeat.Reset();
        HeartBeat.SetRange("Job Queue Entry Id", JobQueueEntry.ID);
        if not HeartBeat.IsEmpty then HeartBeat.DeleteAll();
    end;

    local procedure CreateHeartBeat(Data: Text[250]; Operation: Enum DYM_JobQueueOperation; EntryRelationType: Enum DYM_EntryRelationType)
    var
        HeartBeat: Record DYM_HeartBeat;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
    begin
        if not SettingsMgt.CheckSetting(ConstMgt.BOS_HeartBeatActive) then exit;
        EndTime := CreateDateTime(today, time);
        Clear(HeartBeat);
        HeartBeat.Init();
        HeartBeat."Job Queue Entry Id" := JobQueueEntry.ID;
        HeartBeat."Session Id" := Database.SessionId();
        HeartBeat.Data := Data;
        HeartBeat."Date Time" := CreateDateTime(today, time);
        HeartBeat."Job Queue Entry Description" := JobQueueEntry.Description;
        HeartBeat.Operation := Operation;
        HeartBeat."Entry Relation Type" := EntryRelationType;
        HeartBeat."Entry Relation ID" := CacheMgt.GetContextSLE();
        HeartBeat.Company := CompanyName;
        if (StartTime <> 0DT) then HeartBeat.Duration := EndTime - StartTime;
        HeartBeat.Insert();
        StartTime := CreateDateTime(today, time);
    end;

    procedure GetHeartBeat(var ResultHeartBeatBuffer: Record DYM_HeartBeat)
    var
        ConstMgt: Codeunit DYM_ConstManagement;
        HeartBeatReport: Report DYM_HeartBeatReport;
        HeartBeatBuffer: Record DYM_HeartBeat temporary;
        JobQueueEntry: Record "Job Queue Entry";
        RecRef: RecordRef;
        Info: ModuleInfo;
    begin
        Clear(HeartBeatBuffer);
        Clear(HeartBeatReport);
        HeartBeatReport.UseRequestPage(false);
        HeartBeatReport.RunModal();
        HeartBeatReport.GetHeartBeat(HeartBeatBuffer);
        HeartBeatBuffer.Reset();
        if HeartBeatBuffer.FindSet then
            repeat
                HeartBeatBuffer.SetRange("Job Queue Entry Id", HeartBeatBuffer."Job Queue Entry Id");
                HeartBeatBuffer.FindLast();
                Clear(ResultHeartBeatBuffer);
                ResultHeartBeatBuffer.Init();
                ResultHeartBeatBuffer.Copy(HeartBeatBuffer);
                ResultHeartBeatBuffer.Duration := CreateDateTime(today, time) - ResultHeartBeatBuffer."Date Time";
                ResultHeartBeatBuffer.Insert();
                HeartBeatBuffer.SetRange("Job Queue Entry Id");
            until HeartBeatBuffer.Next() = 0;
    end;

    procedure GetHeartBeatHistory(JobQueueEntryId: Guid; var ResultHeartBeatBuffer: Record DYM_HeartBeat)
    var
        HeartBeatReport: Report DYM_HeartBeatReport;
        HeartBeat: Record DYM_HeartBeat temporary;
    begin
        Clear(HeartBeat);
        HeartBeatReport.UseRequestPage(false);
        HeartBeatReport.RunModal();
        HeartBeatReport.GetHeartBeat(HeartBeat);
        HeartBeat.Reset();
        if (not IsNullGuid(JobQueueEntryId)) then HeartBeat.SetRange("Job Queue Entry Id", JobQueueEntryId);
        if (HeartBeat.FindSet()) then
            repeat
                Clear(ResultHeartBeatBuffer);
                ResultHeartBeatBuffer.Init();
                ResultHeartBeatBuffer.Copy(HeartBeat);
                ResultHeartBeatBuffer.Insert();
            until HeartBeat.Next() = 0;
    end;
    #region Proxy methods
    procedure CreateHeartBeat_SyncLog(Data: Text[250]; Operation: Enum DYM_JobQueueOperation)
    begin
        CreateHeartBeat(Data, Operation, Enum::DYM_EntryRelationType::SyncLogEntry);
    end;

    procedure CreateHeartBeat_NoneEntryType(Data: Text[250]; Operation: Enum DYM_JobQueueOperation)
    begin
        CreateHeartBeat(Data, Operation, Enum::DYM_EntryRelationType::None);
    end;

    procedure CreateHeartBeat_LoadBlobStore(Data: Text[250])
    begin
        CreateHeartBeat(Data, Enum::DYM_JobQueueOperation::LoadBlob, Enum::DYM_EntryRelationType::BlobStoreEntry);
    end;

    procedure CreateHeartBeat_PostProcess(Data: Text[250])
    begin
        CreateHeartBeat(Data, Enum::DYM_JobQueueOperation::PostProcess, Enum::DYM_EntryRelationType::PostProcessLogEntry);
    end;

    procedure CreateHeartBeat_Upload(Data: Text[250])
    begin
        CreateHeartBeat(Data, Enum::DYM_JobQueueOperation::Upload, Enum::DYM_EntryRelationType::SyncLogEntry);
    end;

    procedure CreateHeartBeat_Fetch()
    begin
        CreateHeartBeat('', enum::DYM_JobQueueOperation::Fetch, enum::DYM_EntryRelationType::None);
    end;

    procedure CreateHeartBeat_Pull(TableMap: Record DYM_MobileTableMap)
    begin
        CreateHeartBeat(StrSubstNo(ConstMgt.HRT_MessagePattern_Pull(), TableMap."Table No.", TableMap."Mobile Table", TableMap.Index), enum::DYM_JobQueueOperation::Process, enum::DYM_EntryRelationType::SyncLogEntry);
    end;

    procedure CreateHeartBeat_Pull_Records(TableMap: Record DYM_MobileTableMap; Counter: Integer)
    begin
        CreateHeartBeat(StrSubstNo(ConstMgt.HRT_RecordMessagePattern_Records(), TableMap."Table No.", TableMap."Mobile Table", TableMap.Index, Counter), enum::DYM_JobQueueOperation::Process, enum::DYM_EntryRelationType::SyncLogEntry);
    end;
    #endregion
}
