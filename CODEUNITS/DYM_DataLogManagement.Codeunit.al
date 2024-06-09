codeunit 70112 DYM_DataLogManagement
{
    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        ConstMgt: Codeunit DYM_ConstManagement;
        CacheMgt: Codeunit DYM_CacheManagement;
        DebugMgt: Codeunit DYM_DebugManagement;
        SetupRead: Boolean;
        SLE: Integer;

    procedure LogActiveRecOp(TableName: Text[30]; Position: Text[250])
    begin
        CacheMgt.SetStateDescription(StrSubstNo(ConstMgt.MSG_0009, TableName, Position));
    end;

    procedure LogDataOp_Incoming(var RecRef: RecordRef)
    begin
        LogDataOperation(DYM_DataLogEntryType::Incoming, RecRef);
    end;

    procedure LogDataOp_Create(var RecRef: RecordRef)
    begin
        LogDataOperation(DYM_DataLogEntryType::Create, RecRef);
    end;

    procedure LogDataOp_Modify(var RecRef: RecordRef)
    begin
        LogDataOperation(DYM_DataLogEntryType::Modify, RecRef);
    end;

    local procedure LogDataOperation(EntryType: enum DYM_DataLogEntryType; var RecRef: RecordRef)
    begin
        case EntryType of
            enum::DYM_DataLogEntryType::Incoming:
                CacheMgt.SetStateDescription(StrSubstNo(ConstMgt.MSG_0009, RecRef.Name, LowLevelDP.RecordRefPK2TextDescriptive(RecRef)));
            enum::DYM_DataLogEntryType::Create:
                CacheMgt.SetStateDescription(StrSubstNo(ConstMgt.MSG_0010, RecRef.Name, LowLevelDP.RecordRefPK2TextDescriptive(RecRef)));
            enum::DYM_DataLogEntryType::Modify:
                CacheMgt.SetStateDescription(StrSubstNo(ConstMgt.MSG_0011, RecRef.Name, LowLevelDP.RecordRefPK2TextDescriptive(RecRef)));
        end;
        if (EntryType in [enum::DYM_DataLogEntryType::Create, enum::DYM_DataLogEntryType::Modify]) then InsertDataLogEntry(EntryType, CacheMgt.GetContextSLE, RecRef.Number, LowLevelDP.RecordRefPK2Text(RecRef));
    end;

    local procedure InsertDataLogEntry(EntryType: enum DYM_DataLogEntryType; SyncLogEntryNo: BigInteger; TableNo: Integer; Position: Text[250])
    var
        DataLog: Record DYM_DataLog;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        DataLog.Init;
        Clear(DataLog."Entry No.");
        DataLog."Entry TimeStamp" := CreateDateTime(Today, Time);
        DataLog."Entry Type" := EntryType;
        DataLog."Sync Log Entry No." := SyncLogEntryNo;
        DataLog."Table No." := TableNo;
        DataLog.Position := Position;
        DataLog.Insert;
    end;

    procedure GetPositionWithNames(DataLog: Record DYM_DataLog): Text[250]
    begin
        exit(LowLevelDP.GetPositionWithNames(DataLog."Table No.", DataLog.Position));
    end;
}
