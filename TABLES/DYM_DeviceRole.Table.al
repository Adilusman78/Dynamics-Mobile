table 70106 DYM_DeviceRole
{
    Caption = 'Device Role';
    DrillDownPageID = DYM_DeviceRolesLookUp;
    LookupPageID = DYM_DeviceRolesLookUp;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "NAV Processing Codeunit"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(4; Type;enum DYM_DeviceRoleType)
        {
            DataClassification = SystemMetadata;
        }
        field(101; "NAV Proc. Codeunit Name"; Text[30])
        {
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type"=CONST(Codeunit), "Object ID"=FIELD("NAV Processing Codeunit")));
            Editable = false;
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
        if not CheckEmpty then Error(Text001);
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
    var ConstMgt: Codeunit DYM_ConstManagement;
    SyncMgt: Codeunit DYM_SyncManagement;
    Text001: Label 'You cannot delete Device Role, while it contains Device Groups or Table Mappings.';
    procedure CheckEmpty()Result: Boolean var
        DeviceGroup: Record DYM_DeviceGroup;
        TableMap: Record DYM_MobileTableMap;
    begin
        Clear(Result);
        DeviceGroup.Reset;
        DeviceGroup.SetRange("Device Role Code", Code);
        TableMap.Reset;
        TableMap.SetRange("Device Role Code", Code);
        exit((DeviceGroup.IsEmpty) and (TableMap.IsEmpty));
    end;
}
