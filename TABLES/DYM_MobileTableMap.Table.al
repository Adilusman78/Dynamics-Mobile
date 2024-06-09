table 70115 DYM_MobileTableMap
{
    Caption = 'Mobile Table Map';
    DrillDownPageID = DYM_MobileTableMappingLink;
    LookupPageID = DYM_MobileTableMappingList;

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                GeneralDP.LookUpTable("Table No.");
                FillTableName;
            end;

            trigger OnValidate()
            begin
                FillTableName;
            end;
        }
        field(2; "Mobile Table"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(3; Direction; enum DYM_MobileTableMapDirection)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if (Direction = Direction::Push) then Clear("Pull Type");
            end;
        }
        field(4; Disabled; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Sync. Priority"; Integer)
        {
            DataClassification = SystemMetadata;
            InitValue = 100;
        }
        field(10; "Has Sync Mandatory Fields"; Boolean)
        {
            CalcFormula = Exist(DYM_MobileFieldMap WHERE("Device Role Code" = FIELD("Device Role Code"), "Table No." = FIELD("Table No."), "Table Index" = FIELD(Index), "Sync Mandatory" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Pull Type"; enum DYM_PullType)
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if not (Direction in [Direction::Pull, Direction::Both]) then FieldError(Direction);
            end;
        }
        field(12; "Fields Defined by Table Index"; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_MobileTableMap.Index WHERE("Table No." = FIELD("Table No."), "Device Role Code" = FIELD("Device Role Code"));

            trigger OnValidate()
            begin
                if ("Fields Defined by Table Index" <> 0) then if CheckFieldMapExists then Error(Text001, FieldCaption("Fields Defined by Table Index"));
            end;
        }
        field(1001; "NAV Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type" = CONST(Table), "Object ID" = FIELD("Table No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1002; "Linked Tables"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count(DYM_MobileTableMap WHERE("Device Role Code" = FIELD("Device Role Code"), "Parent Table No." = FIELD("Table No."), "Parent Table Index" = FIELD(Index)));
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
        field(20002; Index; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;
        }
        field(20003; "Parent Table No."; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;
        }
        field(20004; "Parent Table Index"; Integer)
        {
            DataClassification = SystemMetadata;
            BlankZero = true;
        }
        field(20005; "Relation Type"; enum DYM_MobileTableMapRelationType)
        {
            DataClassification = SystemMetadata;
        }
        field(20006; "Use specific push handler"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(20007; "Use specific pull handler"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(20008; "Key"; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;

            trigger OnLookup()
            begin
                LookUpTableKeys(Key);
            end;
        }
    }
    keys
    {
        key(Key1; "Device Role Code", "Table No.", Index)
        {
            Clustered = true;
        }
        key(Key2; "Device Role Code", "Sync. Priority", "Mobile Table", Direction)
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    begin
        DeleteFieldMapping;
        SyncMgt.SetDBSChanged;
    end;

    trigger OnInsert()
    begin
        InitMobileTable;
        CheckMobileTable;
        SyncMgt.SetDBSChanged;
        Index := GetNextTableIndex;
    end;

    trigger OnModify()
    begin
        CheckMobileTable;
        SyncMgt.SetDBSChanged;
    end;

    trigger OnRename()
    begin
        Error(ConstMgt.ERR_0001, TableCaption);
    end;

    var
        ConstMgt: Codeunit DYM_ConstManagement;
        SyncMgt: Codeunit DYM_SyncManagement;
        GeneralDP: Codeunit DYM_GeneralDataProcess;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        Text001: Label 'You cannot use %1 when field mapping is defined.';
        Text002: Label 'There are linked tables defined for this table. If you continue all linked tables will be deleted. Do you want to continue?';
        KeyListPattern: Label '[%1]';

    procedure InitMobileTable()
    var
        TableMap: Record DYM_MobileTableMap;
    begin
        if ("Parent Table No." <> 0) then begin
            if TableMap.Get("Device Role Code", "Parent Table No.", "Parent Table Index") then begin
                Validate(Direction, TableMap.Direction);
                if (Direction = Direction::Pull) then Validate("Pull Type", TableMap."Pull Type");
            end;
        end;
        if ((Direction = Direction::Pull) and ("Pull Type" = "Pull Type"::None)) then Validate("Pull Type", "Pull Type"::Device);
    end;

    procedure CheckMobileTable()
    var
        TableMap: Record DYM_MobileTableMap;
    begin
        if ("Parent Table No." <> 0) then begin
            if TableMap.Get("Device Role Code", "Parent Table No.", "Parent Table Index") then begin
                TestField("Pull Type", TableMap."Pull Type");
                if (TableMap."Parent Table No." <> 0) then TableMap.TestField("Relation Type", TableMap."Relation Type"::Regular);
            end;
        end;
    end;

    procedure DeleteFieldMapping()
    var
        TableMap: Record DYM_MobileTableMap;
        FieldMap: Record DYM_MobileFieldMap;
        TableMapFilters: Record DYM_MobileTableMapFilters;
    begin
        TableMap.Reset;
        TableMap.SetRange("Device Role Code", "Device Role Code");
        TableMap.SetRange("Parent Table No.", "Table No.");
        TableMap.SetRange("Parent Table Index", Index);
        if not TableMap.IsEmpty then if not Confirm(Text001, false) then exit;
        TableMap.DeleteAll(true);
        FieldMap.Reset;
        FieldMap.SetRange("Device Role Code", "Device Role Code");
        FieldMap.SetRange("Table No.", "Table No.");
        FieldMap.SetRange("Table Index", Index);
        FieldMap.DeleteAll;
        TableMapFilters.Reset;
        TableMapFilters.SetRange("Device Role Code", "Device Role Code");
        TableMapFilters.SetRange("Table No.", "Table No.");
        TableMapFilters.SetRange("Table Index", Index);
        TableMapFilters.DeleteAll;
    end;

    procedure CheckFieldMapExists() Result: Boolean
    var
        FieldMap: Record DYM_MobileFieldMap;
    begin
        FieldMap.Reset;
        FieldMap.SetRange("Device Role Code", "Device Role Code");
        FieldMap.SetRange("Table No.", "Table No.");
        FieldMap.SetRange("Table Index", Index);
        exit(not FieldMap.IsEmpty);
    end;

    procedure GetNextTableIndex() Result: Integer
    var
        TableMap: Record DYM_MobileTableMap;
    begin
        Clear(Result);
        TableMap.Reset;
        TableMap.SetRange("Device Role Code", "Device Role Code");
        TableMap.SetRange("Table No.", "Table No.");
        if TableMap.FindLast then Result := TableMap.Index;
        Result += 10000;
    end;

    procedure FillTableName()
    begin
        if ("Mobile Table" = '') then "Mobile Table" := LowLevelDP.ValidateText(LowLevelDP.GetTableName("Table No."));
    end;

    procedure LookUpTableKeys(var KeyValue: Integer) Result: Integer
    var
        GenListMgt: Codeunit DYM_GenericListManagement;
        RecRef: RecordRef;
        KeyRef: KeyRef;
        FldRef: FieldRef;
        KeyNo: Integer;
        FieldNo: Integer;
        SelectedKey: Integer;
        KeyFieldsList: Text;
    begin
        Clear(Result);
        TestField("Table No.");
        GenListMgt.InitList;
        RecRef.Open("Table No.", true);
        for KeyNo := 1 to RecRef.KeyCount do begin
            Clear(KeyFieldsList);
            KeyRef := RecRef.KeyIndex(KeyNo);
            for FieldNo := 1 to KeyRef.FieldCount do begin
                FldRef := KeyRef.FieldIndex(FieldNo);
                KeyFieldsList := KeyFieldsList + StrSubstNo(KeyListPattern, FldRef.Name);
            end;
            GenListMgt.AddListEntry(KeyNo, KeyFieldsList);
        end;
        GenListMgt.LookUpListByKey(KeyValue);
    end;
}
