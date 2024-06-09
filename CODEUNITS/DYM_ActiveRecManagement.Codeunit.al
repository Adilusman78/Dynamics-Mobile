codeunit 70103 DYM_ActiveRecManagement
{
    trigger OnRun()
    begin
    end;

    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        CacheMgt: Codeunit DYM_CacheManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        ConstMgt: Codeunit DYM_ConstManagement;
        SLE: Integer;
        SetupRead: Boolean;
        ContextTableName: Text;
        ActiveTableRDL: Record DYM_RawDataLog;
        ActiveFieldRDL: Record DYM_RawDataLog;
        FilterRDL: Record DYM_RawDataLog temporary;
        ActiveRecRDL: Record DYM_RawDataLog temporary;
        Text001: Label 'Table with name %1 does not exist in the context of Sync Log Entry No. %2.';
        Text002: Label 'Table not initialized.';
        ContextPattern: Label '%1,%2', Locked = true;
        KeyPattern: Label '([%1] = [%2])', Locked = true;
    #region ActiveTable
    procedure FindTable() Result: Boolean
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        ActiveTableRDL.Reset;
        ActiveTableRDL.SetRange("Sync Log Entry No.", SLE);
        ActiveTableRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Table);
        exit(ActiveTableRDL.FindSet(false, false));
    end;

    procedure NextTable() Result: Boolean
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        exit(ActiveTableRDL.Next = 1);
    end;

    procedure GetTableName(): Text
    begin
        exit(ActiveTableRDL."Table Name");
    end;

    procedure TableRecordsCount() Result: Integer
    var
        RawDataLog: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        RawDataLog.Reset;
        RawDataLog.SetRange("Sync Log Entry No.", SLE);
        RawDataLog.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Record);
        RawDataLog.SetRange("Table Name", GetTableName);
        exit(RawDataLog.Count);
    end;
    #endregion 
    #region ActiveRec
    procedure ReadTable(TableName: Text) Result: Boolean
    var
        TableRDL: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TableRDL.Reset;
        TableRDL.SetRange("Sync Log Entry No.", SLE);
        TableRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Table);
        TableRDL.SetRange("Table Name", TableName);
        if not TableRDL.IsEmpty then begin
            ContextTableName := TableName;
            ClearFilters;
            exit(true);
        end;
    end;

    procedure FindRecord() Result: Boolean
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not CheckTable() then exit(false);
        InitActiveRecRDL;
        ActiveRecRDL.Reset;
        exit(ActiveRecRDL.FindSet(false, false));
    end;

    procedure FindTable(TableName: Text): Boolean
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        ActiveFieldRDL.Reset;
        ActiveFieldRDL.SetRange("Sync Log Entry No.", SLE);
        ActiveFieldRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Table);
        ActiveFieldRDL.SetRange("Table Name", TableName);
        exit(ActiveFieldRDL.FindSet(false, false));
    end;

    procedure NextRecord() Result: Boolean
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        exit(ActiveRecRDL.Next = 1);
    end;

    procedure GetRecordNo(): Integer
    begin
        exit(ActiveRecRDL."Record No.");
    end;

    procedure SetRecordNo(RecordNo: Integer)
    begin
        ActiveRecRDL.Reset;
        ActiveRecRDL.SetRange("Record No.", RecordNo);
        if not ActiveRecRDL.FindSet(false, false) then Clear(ActiveRecRDL);
        ActiveRecRDL.Reset;
    end;

    procedure GetActiveRecContext() Result: Text
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        exit(StrSubstNo(ContextPattern, ContextTableName, LowLevelDP.Integer2Text(GetRecordNo)));
    end;

    procedure SetActiveRecContext(Context: Text)
    var
        TableName: Text;
        RecordNo: Integer;
    begin
        Clear(TableName);
        Clear(RecordNo);
        TableName := SelectStr(1, Context);
        RecordNo := LowLevelDP.Text2Integer(SelectStr(2, Context));
        if ((TableName <> '') and (RecordNo <> 0)) then begin
            ReadTable(TableName);
            if FindRecord then SetRecordNo(RecordNo);
        end;
    end;
    #endregion 
    #region ActiveField
    procedure FindField(TableName: Text): Boolean
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        ActiveFieldRDL.Reset;
        ActiveFieldRDL.SetRange("Sync Log Entry No.", SLE);
        ActiveFieldRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::TableField);
        ActiveFieldRDL.SetRange("Table Name", TableName);
        exit(ActiveFieldRDL.FindSet(false, false));
    end;

    procedure NextField(): Boolean
    begin
        exit(ActiveFieldRDL.Next = 1);
    end;

    procedure GetFieldName(): Text
    begin
        exit(ActiveFieldRDL."Field Name");
    end;
    #endregion 
    #region Field Access
    procedure TextField(FieldName: Text) Result: Text
    var
        FieldRDL: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        exit(GetRawDataLogEntry(enum::DYM_RawDataLogEntryType::Field, ContextTableName, ActiveRecRDL."Record No.", FieldName, ''));
    end;

    procedure BooleanField(FieldName: Text): Boolean
    begin
        exit(LowLevelDP.Text2Boolean(TextField(FieldName)));
    end;

    procedure IntegerField(FieldName: Text): Integer
    begin
        exit(LowLevelDP.Text2Integer(TextField(FieldName)));
    end;

    procedure BigIntegerField(FieldName: Text): BigInteger
    begin
        exit(LowLevelDP.Text2BigInteger(TextField(FieldName)));
    end;

    procedure DecimalField(FieldName: Text): Decimal
    begin
        exit(LowLevelDP.Text2Decimal(TextField(FieldName)));
    end;

    procedure DateField(FieldName: Text): Date
    begin
        exit(DT2Date(LowLevelDP.Text2DateTime(TextField(FieldName))));
    end;

    procedure ODDateField(FieldName: Text): Date
    begin
        exit(LowLevelDP.ODText2Date(TextField(FieldName)));
    end;

    procedure TimeField(FieldName: Text): Time
    begin
        exit(DT2Time(LowLevelDP.Text2DateTime(TextField(FieldName))));
    end;

    procedure DateTimeField(FieldName: Text): DateTime
    begin
        exit(LowLevelDP.Text2DateTime(TextField(FieldName)));
    end;

    procedure BLOB2BLOBFieldRef(FieldName: Text; var BLOBFieldRef: FieldRef)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        GetRawDataLogEntryBLOB2BLOB(enum::DYM_RawDataLogEntryType::Field, ContextTableName, ActiveRecRDL."Record No.", FieldName, BLOBFieldRef);
    end;

    procedure BLOB2MediaFieldRef(FieldName: Text; var MediaFieldRef: FieldRef)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        GetRawDataLogEntryBLOB2Media(enum::DYM_RawDataLogEntryType::Field, ContextTableName, ActiveRecRDL."Record No.", FieldName, MediaFieldRef);
    end;

    procedure OptionField(FieldName: Text; FieldPos: Text): Integer
    begin
        EXIT(LowLevelDP.Text2OptionValue(FieldPos, TextField(FieldName)));
    end;
    #endregion 
    #region Attributes
    procedure GetGlobalAttribute(AttributeName: Text) Result: Text
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        exit(GetRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Global Attribute", '', 0, '', AttributeName));
    end;

    procedure CheckGlobalAttribute(AttributeName: Text; AttributeValue: Text): Boolean
    begin
        exit(GetGlobalAttribute(AttributeName) = AttributeValue);
    end;

    procedure GetTableAttribute(AttributeName: Text) Result: Text
    var
        TableAttributeRDL: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        exit(GetRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Table Attribute", ContextTableName, 0, '', AttributeName));
    end;

    procedure CheckTableAttribute(AttributeName: Text; AttributeValue: Text): Boolean
    var
        TableAttributeRDL: Record DYM_RawDataLog;
    begin
        exit(GetTableAttribute(AttributeName) = AttributeValue);
    end;

    procedure GetRecordAttribute(AttributeName: Text) Result: Text
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        exit(GetRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Record Attribute", ContextTableName, ActiveRecRDL."Record No.", '', AttributeName));
    end;

    procedure CheckRecordAttribute(AttributeName: Text; AttributeValue: Text): Boolean
    begin
        exit(GetRecordAttribute(AttributeName) = AttributeValue);
    end;

    procedure GetFieldAttribute(FieldName: Text; AttributeName: Text) Result: Text
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        exit(GetRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Record Attribute", ContextTableName, ActiveRecRDL."Record No.", FieldName, AttributeName));
    end;

    procedure CheckFieldAttribute(FieldName: Text; AttributeName: Text; AttributeValue: Text): Boolean
    begin
        exit(GetFieldAttribute(FieldName, AttributeName) = AttributeValue);
    end;
    #endregion 
    #region Fields
    procedure CheckField(FieldName: Text) Result: Boolean
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if (not CheckTable()) then exit(false);
        exit(CheckRawDataLogEntry(enum::DYM_RawDataLogEntryType::TableField, ContextTableName, 0, FieldName, ''));
    end;
    #endregion 
    #region Filters
    procedure ClearFilter(FilterEntryNo: BigInteger)
    begin
        TestTable;
        if FilterRDL.Get(FilterEntryNo) then FilterRDL.Delete;
    end;

    procedure ClearFilters()
    begin
        TestTable;
        FilterRDL.Reset;
        FilterRDL.DeleteAll;
    end;

    procedure SetFieldFilter(FieldName: Text; FilterValue: Text) Result: BigInteger
    var
        NextEntry: Integer;
    begin
        Clear(Result);
        if (not CheckTable()) then exit;
        if (not CheckField(FieldName)) then exit;
        exit(InsertFilterRawDataLogEntry(enum::DYM_RawDataLogEntryType::Field, 0, FieldName, '', FilterValue, false));
    end;

    procedure SetRecordAttributeFilter(AttributeName: Text; FilterValue: Text) Result: BigInteger
    begin
        Clear(Result);
        TestTable;
        exit(InsertFilterRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Record Attribute", 0, '', AttributeName, FilterValue, false));
    end;

    procedure SetRecordMissingAttributeFilter(AttributeName: Text) Result: BigInteger
    begin
        Clear(Result);
        TestTable;
        exit(InsertFilterRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Record Attribute", 0, '', AttributeName, '', true));
    end;

    procedure SetFieldAttributeFilter(FieldName: Text; AttributeName: Text; FilterValue: Text) Result: BigInteger
    begin
        Clear(Result);
        TestTable;
        exit(InsertFilterRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Field Attribute", 0, FieldName, AttributeName, FilterValue, false));
    end;
    #endregion 
    #region Checks
    local procedure CheckTable(): Boolean
    begin
        exit(ContextTableName <> '');
    end;

    local procedure TestTable()
    begin
        if (ContextTableName = '') then Error(Text002);
    end;
    #endregion 
    #region Raw Data Log
    local procedure GetRawDataLogEntry(EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; AttributeName: Text) Result: Text
    var
        RawDataLog: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        FilterRawDataLogEntry(RawDataLog, EntryType, TableName, RecordNo, FieldName, AttributeName);
        if RawDataLog.FindFirst then exit(RawDataLog."Field Value");
    end;

    local procedure CheckRawDataLogEntry(EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; AttributeName: Text) Result: Boolean
    var
        RawDataLog: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        FilterRawDataLogEntry(RawDataLog, EntryType, TableName, RecordNo, FieldName, AttributeName);
        exit(not RawDataLog.IsEmpty());
    end;

    procedure GetRawDataLogEntryBLOB2BLOB(EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; var BLOBFieldRef: FieldRef)
    var
        RawDataLog: Record DYM_RawDataLog;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        FilterRawDataLogEntry(RawDataLog, EntryType, TableName, RecordNo, FieldName, '');
        if RawDataLog.FindFirst then begin
            RawDataLog.CalcFields("Blob Value");
            if (RawDataLog."Blob Value".HasValue) then if LowLevelDP.IsBLOB(BLOBFieldRef.Record.Number, BLOBFieldRef.Number) then BLOBFieldRef.Value := RawDataLog."Blob Value";
        end;
    end;

    procedure GetRawDataLogEntryBLOB2Media(EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; var MediaFieldRef: FieldRef)
    var
        RawDataLog: Record DYM_RawDataLog;
        TenantMedia: Record "Tenant Media";
        MediaRepoBuffer: Record "Media Repository" temporary;
        InS: InStream;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        FilterRawDataLogEntry(RawDataLog, EntryType, TableName, RecordNo, FieldName, '');
        IF RawDataLog.FINDFIRST THEN BEGIN
            RawDataLog.CALCFIELDS("Blob Value");
            IF (RawDataLog."Blob Value".HASVALUE) THEN
                IF LowLevelDP.IsMedia(MediaFieldRef.RECORD.NUMBER, MediaFieldRef.NUMBER) THEN BEGIN
                    RawDataLog."Blob Value".CREATEINSTREAM(InS, TextEncoding::UTF8);
                    MediaRepoBuffer.INIT;
                    MediaRepoBuffer."File Name" := FORMAT(CREATEGUID);
                    MediaRepoBuffer.Image.IMPORTSTREAM(InS, MediaRepoBuffer."File Name");
                    MediaRepoBuffer.INSERT(TRUE);
                    MediaFieldRef.VALUE := MediaRepoBuffer.Image;
                END;
        END;
    end;

    procedure FilterRawDataLogEntry(var RawDataLog: Record DYM_RawDataLog; EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; AttributeName: Text)
    begin
        RawDataLog.Reset;
        RawDataLog.SetRange("Sync Log Entry No.", SLE);
        RawDataLog.SetRange("Entry Type", EntryType);
        RawDataLog.SetRange("Table Name", TableName);
        RawDataLog.SetRange("Record No.", RecordNo);
        RawDataLog.SetRange("Field Name", FieldName);
        RawDataLog.SetRange("Attribute Name", AttributeName);
    end;

    local procedure InsertFilterRawDataLogEntry(EntryType: enum DYM_RawDataLogEntryType; RecordNo: Integer; FieldName: Text; AttributeName: Text; "Filter": Text; MissingAttribute: Boolean) Result: BigInteger
    var
        NextEntry: Integer;
    begin
        Clear(Result);
        TestTable;
        Clear(NextEntry);
        FilterRDL.Reset;
        if FilterRDL.FindLast then NextEntry := FilterRDL."Entry No.";
        NextEntry += 1;
        FilterRDL.Init;
        FilterRDL."Entry No." := NextEntry;
        FilterRDL."Entry Type" := EntryType;
        FilterRDL."Table Name" := ContextTableName;
        FilterRDL."Field Name" := FieldName;
        FilterRDL."Attribute Name" := AttributeName;
        FilterRDL."Field Value" := Filter;
        FilterRDL."Filter Missing" := MissingAttribute;
        FilterRDL.Insert;
        exit(FilterRDL."Entry No.");
    end;

    local procedure InitActiveRecRDL()
    var
        RecordRDL: Record DYM_RawDataLog;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TestTable;
        ActiveRecRDL.Reset;
        ActiveRecRDL.DeleteAll;
        RecordRDL.Reset;
        RecordRDL.SetRange("Sync Log Entry No.", SLE);
        RecordRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Record);
        RecordRDL.SetRange("Table Name", ContextTableName);
        if RecordRDL.FindSet(false, false) then
            repeat
                Clear(ActiveRecRDL);
                ActiveRecRDL.Init;
                ActiveRecRDL.TransferFields(RecordRDL, true);
                Clear(ActiveRecRDL."Filter Flag");
                ActiveRecRDL.Insert;
            until RecordRDL.Next = 0;
        ApplyFilters;
    end;

    local procedure ApplyFilters()
    var
        FilteredRecRDL: Record DYM_RawDataLog;
        FilterPass: Integer;
        EntryType: Integer;
    begin
        for FilterPass := 1 to 4 do begin
            case FilterPass of
                1:
                    EntryType := enum::DYM_RawDataLogEntryType::Field.AsInteger();
                2:
                    EntryType := enum::DYM_RawDataLogEntryType::"Record Attribute".AsInteger();
                3:
                    EntryType := enum::DYM_RawDataLogEntryType::"Field Attribute".AsInteger();
                4:
                    EntryType := enum::DYM_RawDataLogEntryType::"Record Attribute".AsInteger();
            end;
            if (FilterPass = 4) then begin // Records not having specific attribute
                ActiveRecRDL.Reset;
                ActiveRecRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Record);
                ActiveRecRDL.SetRange("Table Name", ContextTableName);
                ActiveRecRDL.ModifyAll("Filter Flag", true);
            end;
            FilteredRecRDL.Reset;
            FilteredRecRDL.SetRange("Sync Log Entry No.", SLE);
            FilteredRecRDL.SetRange("Entry Type", EntryType);
            FilteredRecRDL.SetRange("Table Name", ContextTableName);
            FilterRDL.Reset;
            FilterRDL.SetRange("Entry Type", EntryType);
            FilterRDL.SetRange("Table Name", ContextTableName);
            FilterRDL.SetRange("Filter Missing", false);
            if (FilterPass = 4) then FilterRDL.SetRange("Filter Missing", true);
            if FilterRDL.FindSet(false, false) then
                repeat
                    FilteredRecRDL.SetRange("Field Name", FilterRDL."Field Name");
                    FilteredRecRDL.SetRange("Attribute Name", FilterRDL."Attribute Name");
                    FilteredRecRDL.SetFilter("Field Value", FilterRDL."Field Value");
                    if FilteredRecRDL.FindSet(false, false) then
                        repeat
                            ActiveRecRDL.Reset;
                            ActiveRecRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Record);
                            ActiveRecRDL.SetRange("Table Name", ContextTableName);
                            ActiveRecRDL.SetRange("Record No.", FilteredRecRDL."Record No.");
                            case (FilterPass = 4) of
                                true:
                                    ActiveRecRDL.SetRange("Filter Flag", true);
                                false:
                                    ActiveRecRDL.SetRange("Filter Flag", false);
                            end;
                            if ActiveRecRDL.FindFirst then begin
                                ActiveRecRDL."Filter Flag" := (FilterPass <> 4);
                                ActiveRecRDL.Modify;
                            end;
                        until FilteredRecRDL.Next = 0;
                    ActiveRecRDL.Reset;
                    ActiveRecRDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Record);
                    ActiveRecRDL.SetRange("Table Name", ContextTableName);
                    ActiveRecRDL.SetRange("Filter Flag", false);
                    ActiveRecRDL.DeleteAll;
                    ActiveRecRDL.SetRange("Filter Flag");
                    ActiveRecRDL.ModifyAll("Filter Flag", false);
                until FilterRDL.Next = 0;
        end;
    end;
    #endregion 
    #region Position
    procedure ActiveRecPK2Text() Result: Text
    var
        FieldMap: Record DYM_MobileFieldMap;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if FindField(GetTableName) then
            repeat
                FieldMap.Reset;
                FieldMap.SetRange("Device Role Code", DeviceRole.Code);
                FieldMap.SetRange("Mobile Table", GetTableName);
                FieldMap.SetRange("Mobile Field", GetFieldName);
                FieldMap.SetRange("Key Field", true);
                if not FieldMap.IsEmpty then Result := Result + StrSubstNo(KeyPattern, GetFieldName, TextField(GetFieldName));
            until NextField;
    end;
    #endregion
}
