codeunit 70138 DYM_PostProcessManagement
{
    TableNo = DYM_PostProcessLog;

    trigger OnRun()
    begin
        process(Rec);
    end;

    var
        CacheMgt: Codeunit DYM_CacheManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        StatsMgt: Codeunit DYM_StatisticsManagement;
        EventLogMgt: Codeunit DYM_EventLogManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        PostProcessHandler: Codeunit DYM_PostProcessHandler;
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        SLE: Integer;
        SetupRead: Boolean;
        Text003: Label 'Start processing [%1;%2;%3].';
        Text004: Label 'End processing.';
        Text005: Label 'There is no specified handler for the table [%1]';

    [CommitBehavior(CommitBehavior::Ignore)]
    procedure process(var Rec: record DYM_PostProcessLog)
    begin
        Clear(DeviceRole);
        Clear(DeviceGroup);
        Clear(DeviceSetup);
        DeviceRole.Get(Rec."Device Role Code");
        DeviceGroup.Get(Rec."Device Group Code");
        DeviceSetup.Get(Rec."Device Setup Code");
        CacheMgt.setContext(DeviceRole, DeviceGroup, DeviceSetup, Rec."Sync Log Entry No.");
        ProcessPostProcessEntry(Rec);
    end;

    procedure LogPostProcessOperation(var RecRef: RecordRef; OpType: enum DYM_PostProcessOperationType; Parameters: Text[250]; Dependancy: BigInteger; Subsequent: Boolean; Data: Text[250]): BigInteger
    begin
        if SettingsMgt.CheckSetting(ConstMgt.PPR_PostProcessActive) then exit(InsertPostProcessEntry(RecRef.Number, LowLevelDP.RecordRefPK2Text(RecRef), OpType, Parameters, Dependancy, Subsequent, Data));
    end;

    procedure InsertPostProcessEntry(TableNo: Integer; Position: Text[250]; OpType: enum DYM_PostProcessOperationType; Parameters: Text[250]; Dependancy: BigInteger; Subsequent: Boolean; Data: Text[250]): BigInteger
    var
        PostProcessLog: Record DYM_PostProcessLog;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessLog.Init;
        Clear(PostProcessLog."Entry No.");
        PostProcessLog."Sync Log Entry No." := SLE;
        PostProcessLog.Status := PostProcessLog.Status::Pending;
        PostProcessLog."Table No." := TableNo;
        PostProcessLog.Position := Position;
        PostProcessLog."Operation Type" := OpType;
        Clear(PostProcessLog.Message);
        Clear(PostProcessLog."Start TimeStamp");
        Clear(PostProcessLog."End TimeStamp");
        PostProcessLog."Entry TimeStamp" := CreateDateTime(Today, Time);
        PostProcessLog.Company := CompanyName;
        PostProcessLog."Device Role Code" := DeviceRole.Code;
        PostProcessLog."Device Group Code" := DeviceGroup.Code;
        PostProcessLog."Device Setup Code" := DeviceSetup.Code;
        PostProcessLog.Parameters := Parameters;
        PostProcessLog.Dependancy := Dependancy;
        PostProcessLog.Subsequent := Subsequent;
        PostProcessLog.Data := Data;
        PostProcessLog.Insert;
        exit(PostProcessLog."Entry No.");
    end;

    procedure ProcessPostProcessEntry(PostProcessEntry: Record DYM_PostProcessLog)
    var
        RecRef: RecordRef;
        IsHandled: Boolean;
    begin
        Clear(StatsMgt);
        EventLogMgt.LogInfo(PostProcessEntry."Entry No.", enum::DYM_EventLogSourceType::"Post-Processing", StrSubstNo(Text003, PostProcessEntry."Table No.", PostProcessEntry."Operation Type", PostProcessEntry.Position), '');
        CheckDependancy(PostProcessEntry);
        clear(IsHandled);
        OnBeforeProcessPostProcessEntry(PostProcessEntry, IsHandled);
        clear(PostProcessHandler);
        PostProcessHandler.SetPostProcessEntry(PostProcessEntry);
        if not IsHandled then begin
            case PostProcessEntry."Table No." of
                DATABASE::"Warehouse Activity Header":
                    PostProcessHandler.PostProcessWhseActivityHeader();
                DATABASE::"Transfer Header":
                    PostProcessHandler.PostProcessTransferHeader();
                DATABASE::"Warehouse Shipment Header":
                    PostProcessHandler.PostProcessWhseShptHeader();
                DATABASE::"Warehouse Receipt Header":
                    PostProcessHandler.PostProcessWhseRcptHeader();
                DATABASE::"Posted Whse. Shipment Header":
                    PostProcessHandler.PostProcessPostedWhseShptHdr();
                DATABASE::"Posted Whse. Receipt Header":
                    PostProcessHandler.PostProcessPostedWhseRcptHdr();
                DATABASE::"Sales Shipment Header":
                    PostProcessHandler.PostProcessSalesShptHeader();
                DATABASE::"Purch. Rcpt. Header":
                    PostProcessHandler.PostProcessPurchRcptHeader();
                DATABASE::"Transfer Shipment Header":
                    PostProcessHandler.PostProcessTransShptHeader();
                DATABASE::"Transfer Receipt Header":
                    PostProcessHandler.PostProcessTransRcptHeader();
                Database::"Sales Header":
                    PostProcessHandler.PostProcessSalesHeader();
                Database::"Purchase Header":
                    PostProcessHandler.PostProcessPurchaseHeader();
                Database::"Item Journal Line":
                    PostProcessHandler.PostProcessItemJnl();
                else begin
                    RecRef.Open(PostProcessEntry."Table No.");
                    Error(StrSubstNo(Text005, RecRef.Name));
                    RecRef.Close();
                end;
            end;
        end;
        EventLogMgt.LogInfo(PostProcessEntry."Entry No.", enum::DYM_EventLogSourceType::"Post-Processing", StrSubstNo(Text004), '');
    end;

    procedure CheckDependancy(PostProcessEntry: Record DYM_PostProcessLog)
    var
        DepPostProcEntry: Record DYM_PostProcessLog;
    begin
        if (PostProcessEntry.Dependancy <> 0) then begin
            DepPostProcEntry.Get(PostProcessEntry.Dependancy);
            DepPostProcEntry.TestField(Status, enum::DYM_PostProcessPacketStatus::Success);
        end;
    end;

    procedure GetParentPostProcessEntry(PostProcessEntry: Record DYM_PostProcessLog): BigInteger
    var
        ParentPostProcessEntry: Record DYM_PostProcessLog;
    begin
        if ParentPostProcessEntry.Get(PostProcessEntry.Dependancy) then begin
            if (ParentPostProcessEntry.Dependancy = 0) then
                exit(ParentPostProcessEntry."Entry No.")
            else
                exit(GetParentPostProcessEntry(ParentPostProcessEntry));
        end;
    end;

    procedure GetPositionWithNames(PostProcessLog: Record DYM_PostProcessLog): Text[250]
    begin
        exit(LowLevelDP.GetPositionWithNames(PostProcessLog."Table No.", PostProcessLog.Position));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcessPostProcessEntry(PostProcessEntry: Record DYM_PostProcessLog; var IsHandled: Boolean)
    begin
    end;
}
