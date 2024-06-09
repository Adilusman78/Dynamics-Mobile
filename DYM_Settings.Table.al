table 84017 DYM_Settings
{
    Caption = 'Settings';
    DrillDownPageID = DYM_SettingsList;
    LookupPageID = DYM_SettingsList;

    fields
    {
        field(1; Type;enum DYM_SettingsType)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Code"; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                GeneralDP.LookUpTable("Table No.");
            end;
            trigger OnValidate()
            begin
                if("Table No." <> xRec."Table No.")then Clear("Field No.");
            end;
        }
        field(4; "Field No."; Integer)
        {
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                GeneralDP.LookUpField("Table No.", "Field No.");
            end;
        }
        field(5; "Publish to";enum DYM_SettingsPublishType)
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Applies-to Device Role"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(7; "Mandatory for";enum DYM_SettingsMandatoryType)
        {
            DataClassification = SystemMetadata;
        }
        field(1001; "NAV Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type"=CONST(Table), "Object ID"=FIELD("Table No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1002; "NAV Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo=FIELD("Table No."), "No."=FIELD("Field No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    begin
        SettingsAssignment.Reset;
        SettingsAssignment.SetRange(Type, Type);
        SettingsAssignment.SetRange(Code, Code);
        if not SettingsAssignment.IsEmpty then if Confirm(Text001, false)then SettingsAssignment.DeleteAll;
    end;
    var GeneralDP: Codeunit DYM_GeneralDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    SettingsAssignment: Record DYM_SettingsAssignment;
    Text001: Label 'There are Settings Assingments in use. If you continue all settings assignments for this setting will be deleted. Do you want to continue?';
}
