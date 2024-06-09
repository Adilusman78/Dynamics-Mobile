table 84018 DYM_SettingsAssignment
{
    Caption = 'Settings Assignment';
    DrillDownPageID = DYM_SettingsAssignment;
    LookupPageID = DYM_SettingsAssignment;

    fields
    {
        field(1; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(2; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceGroup.Code;
        }
        field(3; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(4; Type;enum DYM_SettingsType)
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Code"; Text[50])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_Settings.Code WHERE(Type=FIELD(Type));

            trigger OnLookup()
            begin
                SettingsMgt.LookUpSettingCode(Type, Code);
            end;
        }
        field(6; Value; Text[100])
        {
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                LookupSettingsValue(Value);
            end;
        }
    }
    keys
    {
        key(Key1; "Device Role Code", "Device Group Code", "Device Setup Code", Type, "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        if(Type in[Type::"Mobile Feature", Type::"Mobile Setting"])then begin
            TestField("Device Setup Code", '');
            TestField("Device Group Code");
        end;
    end;
    var SettingsMgt: Codeunit DYM_SettingsManagement;
    procedure LookupSettingsValue(var Value: Text[100])
    var
        Settings: Record DYM_Settings;
    begin
        if not Settings.Get(Type, Code)then exit;
        if((Settings."Table No." = 0) or (Settings."Field No." = 0))then exit;
    /*
        CLEAR ( GeneralLookUpForm ) ;
        GeneralLookUpForm.LOOKUPMODE ( TRUE ) ;
        GeneralLookUpForm.SetTable ( Settings."Table No." ) ;
        GeneralLookUpForm.SetField ( Settings."Field No." ) ;
        IF GeneralLookUpForm.RUNMODAL = ACTION::LookupOK THEN
          Value := GeneralLookUpForm.GetSelectedValue ;
        */
    end;
}
