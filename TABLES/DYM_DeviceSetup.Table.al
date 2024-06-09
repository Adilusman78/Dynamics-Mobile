table 70107 DYM_DeviceSetup
{
    Caption = 'Device Setup';
    DrillDownPageID = DYM_DeviceSetupsLookUp;
    LookupPageID = DYM_DeviceSetupsLookUp;
    Permissions = TableData DYM_SyncLog = rimd;

    fields
    {
        field(1; "Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Salesperson Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            begin
                if (Code = '') then Code := "Salesperson Code";
            end;
        }
        field(3; "Mobile Location"; Code[10])
        {
            DataClassification = SystemMetadata;
            TableRelation = Location.Code;
        }
        field(4; Description; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(11; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceGroup.Code WHERE("Device Role Code" = FIELD("Device Role Code"));
        }
        field(102; Disabled; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(103; "Device Group Disabled"; Boolean)
        {
            CalcFormula = Lookup(DYM_DeviceGroup.Disabled WHERE("Device Role Code" = FIELD("Device Role Code"), Code = FIELD("Device Group Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5001; "Salesperson Name"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Salesperson Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5002; "Location Name"; Text[100])
        {
            CalcFormula = Lookup(Location.Name WHERE(Code = FIELD("Mobile Location")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20001; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;

            trigger OnValidate()
            begin
                if ((xRec."Device Role Code" <> '') and (xRec."Device Role Code" <> "Device Role Code")) then Error(Text001, FieldCaption("Device Role Code"));
            end;
        }
        field(20002; "Device Role Type"; enum DYM_DeviceRoleType)
        {
            Editable = false;
            CalcFormula = Lookup(DYM_DeviceRole."Type" WHERE("Code" = FIELD("Device Role Code")));
            FieldClass = FlowField;
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

    var
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        ConstMgt: Codeunit DYM_ConstManagement;
        SyncMgt: Codeunit DYM_SyncManagement;
        CacheMgt: Codeunit DYM_CacheManagement;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        Text001: Label 'You cannot change the %1 field.';
        Text002: Label 'The device %1 is disabled and can not export data for it';
        Text003: Label 'The device group %1 is disabled and can not export data for it';

    procedure ForceSync(SkipDialogs: Boolean)
    var
        StreamMgt: Codeunit DYM_StreamManagement;
        DummyInStream: InStream;
    begin
        Clear(GlobalDP);
        clear(StreamMgt);
        StreamMgt.initDummyInStream(DummyInStream);
        if (Disabled = true) then Error(StrSubstNo(Text002, Code));
        if not SkipDialogs then if not Confirm(ConstMgt.MSG_0002, false) then exit;
        TestField("Device Group Code");
        if not DeviceGroup.Get("Device Group Code") then Clear(DeviceGroup);
        if (DeviceGroup.Disabled = true) then Error(StrSubstNo(Text003, DeviceGroup.Code));
        TestField("Device Role Code");
        if not DeviceRole.Get("Device Role Code") then Clear(DeviceRole);
        CacheMgt.SetContextByCodes(DeviceRole.Code, DeviceGroup.Code, Code);
        GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::Device, true, false, DummyInStream);
    end;

    procedure GetDeviceGroup()
    begin
        if (DeviceGroup.Code <> "Device Group Code") then DeviceGroup.Get("Device Group Code");
    end;
}
