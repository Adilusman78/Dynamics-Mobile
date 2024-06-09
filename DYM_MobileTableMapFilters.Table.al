table 84003 DYM_MobileTableMapFilters
{
    Caption = 'Mobile Table Map Filters';

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Filter Field No."; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = Field."No." WHERE(TableNo=FIELD("Table No."));

            trigger OnLookup()
            begin
                GeneralDP.LookUpField("Table No.", "Filter Field No.");
            end;
        }
        field(3; "Filter Type";enum DYM_MobileTableMapFilterType)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if("Filter Type" = "Filter Type"::Field)then CheckTableLinking;
                if("Filter Type" <> xRec."Filter Type")then Clear("Filter Value");
            end;
        }
        field(4; "Filter Value"; Text[250])
        {
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                LookUpFilterValue("Filter Value");
            end;
        }
        field(5; "FlowFilter to Field No."; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;

            trigger OnLookup()
            begin
                LookUpFlowField;
            end;
        }
        field(6; "FlowFilter to Field Index"; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;
            Editable = false;
        }
        field(20001; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(20002; "Table Index"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(20005; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceGroup.Code WHERE("Device Role Code"=FIELD("Device Role Code"));
        }
        field(20006; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code WHERE("Device Role Code"=FIELD("Device Role Code"));
        }
    }
    keys
    {
        key(Key1; "Device Role Code", "Table No.", "Table Index", "Filter Field No.", "FlowFilter to Field No.", "FlowFilter to Field Index", "Device Group Code", "Device Setup Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    begin
        SyncMgt.SetDBSChanged;
    end;
    trigger OnInsert()
    begin
        SyncMgt.SetDBSChanged;
    end;
    trigger OnModify()
    begin
        SyncMgt.SetDBSChanged;
    end;
    trigger OnRename()
    begin
        Error(ConstMgt.ERR_0001, TableCaption);
    end;
    var LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    SyncMgt: Codeunit DYM_SyncManagement;
    SessionMgt: Codeunit DYM_SessionManagement;
    GeneralDP: Codeunit DYM_GeneralDataProcess;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    Text001: Label 'You can define %1 only for field with class FlowFilter.';
    CacheMgt: Codeunit DYM_CacheManagement;
    procedure LookUpFilterValue(var FilterValue: Text[250])
    var
        ParentTableNo: Integer;
        ParentTableFieldNo: Integer;
        SessionValueCode: Code[10];
    begin
        case "Filter Type" of "Filter Type"::Filter: SessionMgt.ShowSessionValuesHint;
        "Filter Type"::"Session Value": begin
            SessionValueCode:=FilterValue;
            SessionMgt.LookUpSessionValues(SessionValueCode);
            FilterValue:=SessionValueCode;
        end;
        "Filter Type"::Field: begin
            GeneralDP.LookUpField(GetParentTableNo, ParentTableFieldNo);
            if(ParentTableFieldNo <> 0)then FilterValue:=LowLevelDP.Integer2Text(ParentTableFieldNo)
            else if(FilterValue <> '')then if Confirm(ConstMgt.MSG_0004, false, FieldCaption("Filter Value"))then Clear(FilterValue);
        end;
        "Filter Type"::"Setting Value": begin
            CacheMgt.SetContextByCodes("Device Role Code", '', '');
            SettingsMgt.LookUpSettingCode(enum::DYM_SettingsType::"BackOffice Setting", FilterValue);
        end;
        end;
    end;
    procedure LookUpFlowField()
    var
        FieldMap: Record DYM_MobileFieldMap;
    begin
        if not LowLevelDP.IsFlowFilter("Table No.", "Filter Field No.")then Error(Text001, FieldCaption("FlowFilter to Field No."));
        FieldMap.Reset;
        FieldMap.SetRange("Device Role Code", "Device Role Code");
        FieldMap.SetRange("Table No.", "Table No.");
        FieldMap.SetRange("Table Index", "Table Index");
        FieldMap.SetRange("NAV Field Class", FieldMap."NAV Field Class"::FlowField);
        if PAGE.RunModal(PAGE::DYM_MobileFieldMapLookUp, FieldMap) = ACTION::LookupOK then begin
            Validate("FlowFilter to Field No.", FieldMap."Field No.");
            Validate("FlowFilter to Field Index", FieldMap."Field Index");
        end
        else if("FlowFilter to Field No." <> 0)then if Confirm(ConstMgt.MSG_0005, false, FieldCaption("FlowFilter to Field No."))then begin
                    Clear("FlowFilter to Field No.");
                    Clear("FlowFilter to Field Index");
                end;
    end;
    procedure GetParentTableNo()Result: Integer var
        TableMap: Record DYM_MobileTableMap;
    begin
        Clear(Result);
        if not TableMap.Get("Device Role Code", "Table No.", "Table Index")then Clear(TableMap);
        exit(TableMap."Parent Table No.");
    end;
    procedure GetParentTableIndex()Result: Integer var
        TableMap: Record DYM_MobileTableMap;
    begin
        Clear(Result);
        if not TableMap.Get("Device Role Code", "Table No.", "Table Index")then Clear(TableMap);
        exit(TableMap."Parent Table Index");
    end;
    procedure CheckTableLinking()
    var
        TableMap: Record DYM_MobileTableMap;
    begin
        if("Filter Type" <> "Filter Type"::Field)then exit;
        if not TableMap.Get("Device Role Code", "Table No.", "Table Index")then exit;
        TableMap.TestField("Parent Table No.");
        TableMap.TestField("Parent Table Index");
    end;
}
