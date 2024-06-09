table 84005 DYM_DeviceGroup
{
    Caption = 'Device Group';
    DrillDownPageID = DYM_DeviceGroupsLookUp;
    LookupPageID = DYM_DeviceGroupsLookUp;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(2; Description; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(102; Disabled; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(201; "Last Full Sync Date"; Date)
        {
            DataClassification = SystemMetadata;
        }
        field(202; "Last Full Sync Time"; Time)
        {
            DataClassification = SystemMetadata;
        }
        field(20001; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;

            trigger OnValidate()
            begin
                if((xRec."Device Role Code" <> '') and (xRec."Device Role Code" <> "Device Role Code"))then Error(Text001, FieldCaption("Device Role Code"));
            end;
        }
    }
    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    begin
        if not CheckEmpty then Error(Text002);
        SyncMgt.SetDESChanged;
    end;
    trigger OnInsert()
    begin
        SyncMgt.SetDESChanged;
    end;
    trigger OnModify()
    begin
        SyncMgt.SetDESChanged;
    end;
    trigger OnRename()
    begin
        Error(ConstMgt.ERR_0001, TableCaption);
    end;
    var Location: Record Location;
    GlobalDP: Codeunit DYM_GlobalDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    SyncMgt: Codeunit DYM_SyncManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
    Text001: Label 'You cannot change the %1 field.';
    Text002: Label 'You cannot delete Device Group, while it contains devices.';
    Text003: Label 'The device group %1 is disabled and can not export data for it';
    procedure ForceSync(SkipDialogs: Boolean)
    var
        DeviceRole: Record DYM_DeviceRole;
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        //ForceSync
        Clear(GlobalDP);
        if not SkipDialogs then if not Confirm(ConstMgt.MSG_0002, false)then exit;
        DeviceSetup.Reset;
        DeviceSetup.SetRange("Device Group Code", Code);
        DeviceSetup.SetRange(Disabled, false);
        if not DeviceSetup.FindFirst then exit;
        if not DeviceRole.Get("Device Role Code")then Clear(DeviceRole);
        GlobalDP.ProcessPull(GlobalDP.GeneratePullFileName(enum::DYM_PullType::None, DeviceRole, Rec, DeviceSetup), enum::DYM_PullType::None);
    end;
    procedure ForceSyncInt(SkipDialogs: Boolean)
    var
        DeviceRole: Record DYM_DeviceRole;
        DeviceSetup: Record DYM_DeviceSetup;
        StreamMgt: Codeunit DYM_StreamManagement;
        DummyInStream: InStream;
    begin
        //ForceSyncInt
        Clear(GlobalDP);
        clear(StreamMgt);
        StreamMgt.initDummyInStream(DummyInStream);
        if(Disabled = true)then Error(StrSubstNo(Text003, Code));
        if not SkipDialogs then if not Confirm(ConstMgt.MSG_0002, false)then exit;
        DeviceSetup.Reset;
        DeviceSetup.SetRange("Device Group Code", Code);
        DeviceSetup.SetRange(Disabled, false);
        if not DeviceSetup.FindFirst then exit;
        Clear(DeviceSetup);
        if not DeviceRole.Get("Device Role Code")then Clear(DeviceRole);
        CacheMgt.SetContextByCodes(DeviceRole.Code, Code, '');
        GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::Group, true, false, DummyInStream);
    end;
    procedure CheckEmpty()Result: Boolean var
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        Clear(Result);
        DeviceSetup.Reset;
        DeviceSetup.SetRange("Device Role Code", "Device Role Code");
        DeviceSetup.SetRange("Device Group Code", Code);
        exit(DeviceSetup.IsEmpty);
    end;
}
