table 84002 DYM_MobileFieldMap
{
    Caption = 'Mobile Field Map';
    DrillDownPageID = DYM_MobileFieldMappingList;
    LookupPageID = DYM_MobileFieldMappingList;

    fields
    {
        field(2; "Mobile Field"; Text[30])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(3; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_MobileTableMap."Table No.";
        }
        field(4; "Field No."; Integer)
        {
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                GeneralDP.LookUpField("Table No.", "Field No.");
                FillFieldName;
            end;
            trigger OnValidate()
            begin
                FillFieldName;
            end;
        }
        field(8; "EQ Relation Field No."; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;

            trigger OnLookup()
            begin
                GeneralDP.LookUpField("Table No.", "EQ Relation Field No.");
            end;
            trigger OnValidate()
            begin
                if("EQ Relation Field No." <> 0)then TestField(Relational);
            end;
        }
        field(9; "EQ Condition Field No."; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;
            TableRelation = Field."No." WHERE(TableNo=FIELD("Table No."));

            trigger OnLookup()
            begin
                GeneralDP.LookUpField("Table No.", "EQ Condition Field No.");
            end;
            trigger OnValidate()
            begin
                if("EQ Condition Field No." <> 0)then TestField(Relational);
            end;
        }
        field(10; "EQ Condition Value"; Text[250])
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if("EQ Condition Value" <> '')then TestField(Relational);
            end;
        }
        field(11; Relational; Boolean)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                TestField("Field No.", 0);
                if not Relational then begin
                    Clear("EQ Relation Field No.");
                    Clear("EQ Condition Field No.");
                    Clear("EQ Condition Value");
                end;
            end;
        }
        field(13; Disabled; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(14; "Const Value"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(15; "Const Value Type";enum DYM_MobileFieldMapConstType)
        {
            DataClassification = SystemMetadata;
        }
        field(16; Direction;enum DYM_MobileFieldMapDirection)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if(Direction <> Direction::Internal)then if("Session Value" <> '')then if Confirm(ConstMgt.MSG_0001, false, FieldCaption(Direction), FieldCaption("Session Value"))then Clear("Session Value")
                        else
                            Error('');
                CalcFields("Table Direction");
                if("Table Direction" = "Table Direction"::Push)then if(Direction in[Direction::Pull, Direction::Both])then FieldError(Direction);
                if("Table Direction" = "Table Direction"::Pull)then if(Direction in[Direction::Push, Direction::Both])then FieldError(Direction);
            end;
        }
        field(17; "AutoIncrement Push Value"; Boolean)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if "AutoIncrement Push Value" then if not LowLevelDP.IsInteger("Table No.", "Field No.")then Error(Text001, FieldCaption("AutoIncrement Push Value"));
            end;
        }
        field(18; "AutoIncrement Pull Value"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(19; "Session Value"; Code[10])
        {
            DataClassification = SystemMetadata;

            //Editable = false;
            trigger OnLookup()
            begin
                TestField(Direction, Direction::Internal);
                SessionMgt.LookUpSessionValues("Session Value");
            end;
        }
        field(20; "Sync. Priority"; Integer)
        {
            DataClassification = SystemMetadata;
            InitValue = 100;
        }
        field(22; "Sync Mandatory"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(23; Validate; Boolean)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if(Direction = Direction::Pull)then FieldError(Direction);
            end;
        }
        field(24; "Table Direction";enum DYM_MobileTableMapDirection)
        {
            CalcFormula = Lookup(DYM_MobileTableMap.Direction WHERE("Device Role Code"=FIELD("Device Role Code"), "Table No."=FIELD("Table No."), Index=FIELD("Table Index")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Raw Data Editable"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(26; "Key Field"; Boolean)
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
        field(1003; "NAV Field Type"; Text[30])
        {
            CalcFormula = Lookup(Field."Type Name" WHERE(TableNo=FIELD("Table No."), "No."=FIELD("Field No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1004; "NAV Field Class"; Option)
        {
            CalcFormula = Lookup(Field.Class WHERE(TableNo=FIELD("Table No."), "No."=FIELD("Field No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = Normal, FlowField, FlowFilter;
        }
        field(1005; "NAV Field Size"; Integer)
        {
            CalcFormula = Lookup(Field.Len WHERE(TableNo=FIELD("Table No."), "No."=FIELD("Field No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1006; "Mobile Table"; Text[30])
        {
            CalcFormula = Lookup(DYM_MobileTableMap."Mobile Table" WHERE("Table No."=FIELD("Table No."), Index=FIELD("Table Index")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20001; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(20002; "Field Index"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(20003; "Table Index"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Device Role Code", "Table No.", "Table Index", "Field No.", "Field Index")
        {
            Clustered = true;
        }
        key(Key2; "Table No.", "Field No.")
        {
        }
        key(Key3; "Device Role Code", "Table No.", "Table Index", "Sync. Priority")
        {
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
        CheckTable;
        SyncMgt.SetDBSChanged;
        "Field Index":=GetNextFieldIndex;
    end;
    trigger OnModify()
    begin
        SyncMgt.SetDBSChanged;
    end;
    trigger OnRename()
    begin
    //ERROR ( ConstMgt.ERR_0001 , TABLECAPTION ) ;
    end;
    var GeneralDP: Codeunit DYM_GeneralDataProcess;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    SyncMgt: Codeunit DYM_SyncManagement;
    SessionMgt: Codeunit DYM_SessionManagement;
    Text001: Label 'You can set %1 only to field of type Integer.';
    procedure IsAutoIncrementPush()Result: Boolean begin
        CLEAR(Result);
        EXIT((Direction = Direction::Push) AND ("AutoIncrement Push Value") AND (LowLevelDP.IsInteger("Table No.", "Field No.")));
    end;
    procedure IsAutoIncrementPull()Result: Boolean begin
        CLEAR(Result);
        EXIT((Direction = Direction::Pull) AND ("AutoIncrement Pull Value"));
    end;
    procedure CheckTable()
    var
        TableMap: Record DYM_MobileTableMap;
    begin
        if not TableMap.Get("Device Role Code", "Table No.", "Table Index")then Clear(TableMap);
        TableMap.TestField("Fields Defined by Table Index", 0);
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
    procedure GetNextFieldIndex()Result: Integer var
        FieldMap: Record DYM_MobileFieldMap;
    begin
        Clear(Result);
        FieldMap.Reset;
        FieldMap.SetRange("Device Role Code", "Device Role Code");
        FieldMap.SetRange("Table No.", "Table No.");
        FieldMap.SetRange("Table Index", "Table Index");
        FieldMap.SetRange("Field No.", "Field No.");
        if FieldMap.FindLast then Result:=FieldMap."Field Index";
        Result+=10000;
    end;
    procedure FillFieldName()
    begin
        if("Mobile Field" = '')then "Mobile Field":=LowLevelDP.ValidateText(LowLevelDP.GetFieldName("Table No.", "Field No."));
    end;
    procedure GetMobileTableName()Result: Text[30]var
        TableMap: Record DYM_MobileTableMap;
    begin
        Clear(Result);
        if not TableMap.Get("Device Role Code", "Table No.", "Table Index")then Clear(TableMap);
        exit(TableMap."Mobile Table");
    end;
}
