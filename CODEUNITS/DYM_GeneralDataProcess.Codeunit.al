codeunit 70122 DYM_GeneralDataProcess
{
    Permissions = TableData Customer = rimd,
        TableData "Sales Header" = rimd,
        TableData "Sales Line" = rimd,
        TableData "Purchase Header" = rimd,
        TableData "Purchase Line" = rimd,
        TableData "Gen. Journal Line" = rimd,
        TableData "Item Journal Line" = rimd,
        TableData "Line Number Buffer" = rimd,
        TableData "Reservation Entry" = rimd;

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
        SessionMgt: Codeunit DYM_SessionManagement;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        SLE: Integer;
        SetupRead: Boolean;
        Text_LastStatePullPattern: Label 'Table No. [%1] Table Index [%2]';
    #region Push
    procedure PushProcessGeneral(var TableBuffer: RecordRef; var TableMap: Record DYM_MobileTableMap; CRUDType: Integer; CallTriggers: Boolean; var ResponseTableBuffer: RecordRef)
    var
        TableMapFilters: Record DYM_MobileTableMapFilters;
        DummyFieldMap: Record DYM_MobileFieldMap;
        RecRef: RecordRef;
        FromField: FieldRef;
        ToField: FieldRef;
        HasFieldFilters: Boolean;
        FieldValue: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        RecRef.Open(TableMap."Table No.");
        RecRef.Reset;
        Clear(HasFieldFilters);
        HasFieldFilters := PullProcessApplyStaticFilters(RecRef, TableMap, false, DummyFieldMap);
        TableBuffer.Reset;
        if TableBuffer.FindSet(false, false) then
            repeat
                if (CRUDType in [ConstMgt.CRD_None, ConstMgt.CRD_Update, ConstMgt.CRD_Delete]) then begin
                    RecRef.SetPosition(TableBuffer.GetPosition);
                    if not RecRef.Find then RecRef.Init;
                end;
                if (CRUDType = ConstMgt.CRD_Create) then RecRef.Init;
                PushProcessTransferFields(TableBuffer, TableMap, RecRef, CRUDType, CallTriggers);
                if CacheMgt.CheckRecordFlag(TableMap."Table No.", TableMap.Index, Format(TableBuffer.RecordId), ConstMgt.CBF_DirectResponse) then PullProcessTransferFields(ResponseTableBuffer, TableMap, RecRef);
            until TableBuffer.Next = 0;
        FlushTableWriteCache(RecRef);
    end;

    procedure PushProcessTransferFields(var TableBuffer: RecordRef; var TableMap: Record DYM_MobileTableMap; var RecRef: RecordRef; CRUDType: Integer; CallTriggers: Boolean)
    var
        FieldMap: Record DYM_MobileFieldMap;
        AIRec: RecordRef;
        KeyRef: KeyRef;
        FromField: FieldRef;
        ToField: FieldRef;
        FilterField: FieldRef;
        KeyFieldIndex: Integer;
        AIEntry: Integer;
        TempText: Text[250];
        SkipFieldValueTransfer: Boolean;
    begin
        FieldMap.Reset;
        FieldMap.SetCurrentKey("Device Role Code", "Table No.", "Table Index", "Sync. Priority");
        FieldMap.SetRange("Device Role Code", TableMap."Device Role Code");
        FieldMap.SetRange("Table No.", TableMap."Table No.");
        if (TableMap."Fields Defined by Table Index" = 0) then
            FieldMap.SetRange("Table Index", TableMap.Index)
        else
            FieldMap.SetRange("Table Index", TableMap."Fields Defined by Table Index");
        FieldMap.SetFilter(Direction, '%1|%2|%3', FieldMap.Direction::Push, FieldMap.Direction::Both, FieldMap.Direction::Internal);
        FieldMap.SetRange(Disabled, false);
        FieldMap.SetRange(Relational, false);
        if FieldMap.FindSet(false, false) then
            repeat
                FromField := TableBuffer.Field(FieldMap."Field No.");
                ToField := RecRef.Field(FieldMap."Field No.");
                ToField.Value := FromField.Value;
                Clear(TempText);
                Clear(SkipFieldValueTransfer);
                TempText := LowLevelDP.GetFldRefValue2Text(FieldMap, FromField);
                if FieldMap.Direction = FieldMap.Direction::Internal then begin
                    if ((FieldMap.Direction = FieldMap.Direction::Internal) and (FieldMap."Session Value" <> '')) then TempText := SessionMgt.GetSessionValue(FieldMap."Session Value");
                end;
                if (FieldMap."Const Value Type" = FieldMap."Const Value Type"::Always) then begin
                    TempText := FieldMap."Const Value";
                end
                else begin
                    if (FieldMap.Direction <> FieldMap.Direction::Internal) then begin
                        if (LowLevelDP.GetFieldRefFieldType(ToField) = ConstMgt.FDT_BLOB) then begin
                            SkipFieldValueTransfer := true;
                            FromField.CalcField;
                            ToField.Value := FromField.Value;
                        end;
                    end;
                    if (FieldMap."Const Value Type" IN [FieldMap."Const Value Type"::Null, FieldMap."Const Value Type"::"Ending Date"]) then begin
                        if (TempText = '') then TempText := FieldMap."Const Value";
                    end;
                end;
                if not SkipFieldValueTransfer then LowLevelDP.Value2FldRef(ToField, TempText);
                if (CacheMgt.CheckFieldFlag(TableMap."Table No.", TableMap.Index, FieldMap."Field No.", FieldMap."Field Index", FieldMap."Mobile Field", Format(TableBuffer.RecordId), ConstMgt.CBF_Validate) or (FieldMap.Validate)) then ToField.Validate;
            until FieldMap.Next = 0;
        FieldMap.SetRange("AutoIncrement Push Value", true);
        if FieldMap.FindSet(false, false) then begin
            AIRec.Open(RecRef.Number);
            KeyRef := AIRec.KeyIndex(1);
            for KeyFieldIndex := 1 to KeyRef.FieldCount do begin
                FilterField := KeyRef.FieldIndex(KeyFieldIndex);
                if (FilterField.Number <> FieldMap."Field No.") then begin
                    FromField := RecRef.FieldIndex(KeyFieldIndex);
                    FilterField.SetRange(FromField.Value);
                end;
            end;
            Clear(AIEntry);
            if AIRec.FindLast then begin
                FromField := AIRec.Field(FieldMap."Field No.");
                AIEntry := LowLevelDP.Text2Integer(LowLevelDP.GetFldRefValue2Text(FieldMap, FromField));
            end;
            AIEntry += 1;
            ToField := RecRef.Field(FieldMap."Field No.");
            LowLevelDP.Value2FldRef(ToField, LowLevelDP.Integer2Text(AIEntry));
        end;
        case CRUDType of
            ConstMgt.CRD_None:
                if not RecRef.Insert(CallTriggers) then
                    RecRef.Modify(CallTriggers);
            ConstMgt.CRD_Create:
                RecRef.Insert(CallTriggers);
            ConstMgt.CRD_Update:
                RecRef.Modify(CallTriggers);
            ConstMgt.CRD_Delete:
                RecRef.Delete(CallTriggers);
        end;
    end;
    #endregion 
    #region Pull
    procedure PullProcessGeneral(var ParentTableData: RecordRef; var TableBuffer: RecordRef; var TableMap: Record DYM_MobileTableMap; Child: Boolean)
    var
        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
        TableMapFilters: Record DYM_MobileTableMapFilters;
        DummyFieldMap: Record DYM_MobileFieldMap;
        RecRef: RecordRef;
        FromField: FieldRef;
        ToField: FieldRef;
        HasFieldFilters: Boolean;
        FieldValue, HeartBeatRecordCount, Counter : Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(Counter);
        HeartBeatRecordCount := ConstMgt.HRT_DefaultHeartBeatRecordNumber();
        if (SettingsMgt.CheckSetting(ConstMgt.BOS_HeartBeatRecordCount())) then HeartBeatRecordCount := LowLevelDP.Text2Integer(ConstMgt.BOS_HeartBeatRecordCount());
        CacheMgt.SetStateDescription(StrSubstNo(Text_LastStatePullPattern, TableMap."Table No.", TableMap.Index));
        RecRef.Open(TableMap."Table No.");
        RecRef.Reset;
        if (TableMap.Key = 0) then
            PullProcessAutoSelectKey(RecRef, TableMap)
        else
            RecRef.CurrentKeyIndex(TableMap.Key);
        Clear(HasFieldFilters);
        HasFieldFilters := PullProcessApplyStaticFilters(RecRef, TableMap, false, DummyFieldMap);
        case HasFieldFilters of
            false:
                begin
                    if RecRef.FindSet(false, false) then
                        repeat
                            Counter += 1;
                            if (Counter mod HeartBeatRecordCount = 0) then HeartBeatMgt.CreateHeartBeat_Pull_Records(TableMap, Counter);
                            if PullProcessExistRelation(RecRef, TableMap) then PullProcessTransferFields(TableBuffer, TableMap, RecRef);
                        until RecRef.Next = 0;
                end;
            true:
                begin
                    ParentTableData.Reset;
                    if ParentTableData.FindSet(false, false) then
                        repeat
                            TableMapFilters.Reset;
                            TableMapFilters.SetRange("Device Role Code", TableMap."Device Role Code");
                            TableMapFilters.SetRange("Table No.", TableMap."Table No.");
                            TableMapFilters.SetRange("Table Index", TableMap.Index);
                            TableMapFilters.SetRange("Filter Type", TableMapFilters."Filter Type"::Field);
                            TableMapFilters.SetFilter("Device Group Code", '%1|%2', '', DeviceGroup.Code);
                            TableMapFilters.SetFilter("Device Setup Code", '%1|%2', '', DeviceSetup.Code);
                            if TableMapFilters.FindSet(false, false) then
                                repeat
                                    Evaluate(FieldValue, TableMapFilters."Filter Value");
                                    FromField := ParentTableData.Field(FieldValue);
                                    ToField := RecRef.Field(TableMapFilters."Filter Field No.");
                                    ToField.SetRange(FromField.Value);
                                until TableMapFilters.Next = 0;
                            if RecRef.FindSet(false, false) then
                                repeat
                                    Counter += 1;
                                    if (Counter mod HeartBeatRecordCount = 0) then HeartBeatMgt.CreateHeartBeat_Pull_Records(TableMap, Counter);
                                    if PullProcessExistRelation(RecRef, TableMap) then PullProcessTransferFields(TableBuffer, TableMap, RecRef);
                                until RecRef.Next = 0;
                        until ParentTableData.Next = 0;
                end;
        end;
    end;

    procedure PullProcessTransferFields(var TableBuffer: RecordRef; var TableMap: Record DYM_MobileTableMap; var RecRef: RecordRef)
    var
        FieldMap: Record DYM_MobileFieldMap;
        KeyRef: KeyRef;
        FromField: FieldRef;
        ToField: FieldRef;
        KeyFieldIndex: Integer;
        LookUpValue: Text[30];
        SkipFieldTransfer: Boolean;
        TempDec: Decimal;
    begin
        KeyRef := RecRef.KeyIndex(1);
        for KeyFieldIndex := 1 to KeyRef.FieldCount do begin
            FromField := KeyRef.FieldIndex(KeyFieldIndex);
            ToField := TableBuffer.Field(FromField.Number);
            ToField.Value := FromField.Value;
        end;
        FieldMap.Reset;
        FieldMap.SetRange("Device Role Code", TableMap."Device Role Code");
        FieldMap.SetRange("Table No.", TableMap."Table No.");
        if (TableMap."Fields Defined by Table Index" = 0) then
            FieldMap.SetRange("Table Index", TableMap.Index)
        else
            FieldMap.SetRange("Table Index", TableMap."Fields Defined by Table Index");
        FieldMap.SetFilter(Direction, '%1|%2|%3|%4', FieldMap.Direction::Pull, FieldMap.Direction::Both, FieldMap.Direction::Internal, FieldMap.Direction::"LookUp Result");
        FieldMap.SetRange(Disabled, false);
        FieldMap.SetRange(Relational, false);
        FieldMap.SetFilter("Const Value Type", '%1|%2|%3', FieldMap."Const Value Type"::" ", FieldMap."Const Value Type"::Null, FieldMap."Const Value Type"::"Ending Date");
        if FieldMap.FindSet(false, false) then
            repeat
                PullProcessApplyStaticFilters(RecRef, TableMap, true, FieldMap);
                if (FieldMap.Direction = FieldMap.Direction::"LookUp Result") then begin
                    Clear(LookUpValue);
                    LookUpValue := PullProcessLookUpRelation(TableBuffer, TableMap, FieldMap);
                    CacheMgt.SetLookupField(FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index", FieldMap."Mobile Field", Format(RecRef.RecordId), LookUpValue);
                end
                else begin
                    Clear(SkipFieldTransfer);
                    FromField := RecRef.Field(FieldMap."Field No.");
                    if (LowLevelDP.IsFlowField(FieldMap."Table No.", FieldMap."Field No.")) then begin
                        FromField.CalcField;
                        if ((FieldMap."Const Value Type" = FieldMap."Const Value Type"::" ") AND (FieldMap."Const Value" = ConstMgt.MFL_Reverse()) AND (LowLevelDP.IsDecimal(FieldMap."Table No.", FieldMap."Field No."))) then begin
                            TempDec := FromField.Value;
                            TempDec *= -1;
                            FromField.Value := TempDec;
                        end;
                        CacheMgt.SetFlowField(FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index", Format(RecRef.RecordId), LowLevelDP.GetFldRefValue2Text(FieldMap, FromField));
                        SkipFieldTransfer := true;
                    end;
                    if ((FieldMap.Direction = FieldMap.Direction::Internal) and (FieldMap."Field No." = 0)) then begin
                        CacheMgt.SetInternalField(FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index", FieldMap."Mobile Field", Format(RecRef.RecordId), SessionMgt.GetSessionValue(FieldMap."Session Value"));
                        SkipFieldTransfer := true;
                    end;
                    if not SkipFieldTransfer then begin
                        ToField := TableBuffer.Field(FieldMap."Field No.");
                        if (LowLevelDP.GetFieldRefFieldType(FromField) = ConstMgt.FDT_BLOB) then FromField.CalcField;
                        ToField.Value := FromField.Value;
                        if ((FieldMap."Const Value Type" = FieldMap."Const Value Type"::" ") AND (FieldMap."Const Value" = ConstMgt.MFL_Reverse()) AND (LowLevelDP.IsDecimal(FieldMap."Table No.", FieldMap."Field No."))) then begin
                            TempDec := ToField.Value;
                            TempDec *= -1;
                            ToField.Value := TempDec;
                        end;
                    end;
                end;
            until FieldMap.Next = 0;
        //Handle SystemId
        FromField := RecRef.Field(RecRef.SystemIdNo);
        ToField := TableBuffer.Field(TableBuffer.SystemIdNo);
        ToField.Value := FromField.Value;
        //IF NOT CacheMgt.CheckCacheBufferEntry ( TableMap."Table No." , 0 , '' , 0 , 0 , '' , FORMAT ( RecRef.RECORDID ) , 0 ) THEN BEGIN
        if not TableBuffer.Insert then TableBuffer.Modify;
        //  CacheMgt.SetCacheBufferEntry  ( FieldMap."Table No." , FieldMap."Table Index" , '' ,
        //                                  0 , 0 , '' , FORMAT ( RecRef.RECORDID ) , '' , 0 ) ;
        //END ;
    end;

    procedure PullProcessApplyStaticFilters(var SourceTable: RecordRef; var TableMap: Record DYM_MobileTableMap; FlowFiltersOnly: Boolean; var FieldMap: Record DYM_MobileFieldMap) Result: Boolean
    var
        TableMapFilters: Record DYM_MobileTableMapFilters;
        FromField: FieldRef;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        TableMapFilters.Reset;
        TableMapFilters.SetRange("Device Role Code", TableMap."Device Role Code");
        TableMapFilters.SetRange("Table No.", TableMap."Table No.");
        TableMapFilters.SetRange("Table Index", TableMap.Index);
        TableMapFilters.SetFilter("Device Group Code", '%1|%2', '', DeviceGroup.Code);
        TableMapFilters.SetFilter("Device Setup Code", '%1|%2', '', DeviceSetup.Code);
        if (FlowFiltersOnly) then begin
            TableMapFilters.SetRange("FlowFilter to Field No.", FieldMap."Field No.");
            TableMapFilters.SetRange("FlowFilter to Field Index", FieldMap."Field Index");
        end;
        if TableMapFilters.FindSet(false, false) then
            repeat
                FromField := SourceTable.Field(TableMapFilters."Filter Field No.");
                case TableMapFilters."Filter Type" of
                    TableMapFilters."Filter Type"::Const:
                        LowLevelDP.Value2FldRefFilter(FromField, TableMapFilters."Filter Value");
                    TableMapFilters."Filter Type"::Filter:
                        FromField.SetFilter(SessionMgt.ApplySessionValuesToFilter(TableMapFilters."Filter Value"));
                    TableMapFilters."Filter Type"::"Session Value":
                        FromField.SetFilter(SessionMgt.GetSessionValue(TableMapFilters."Filter Value"));
                    TableMapFilters."Filter Type"::Field:
                        begin
                            if ((TableMap."Parent Table No." = 0) or (TableMap."Parent Table Index" = 0)) then TableMapFilters.FieldError("Filter Type");
                            Result := true;
                        end;
                    TableMapFilters."Filter Type"::"Setting Value":
                        begin
                            FromField.SetFilter(SettingsMgt.GetSetting(TableMapFilters."Filter Value"));
                        end;
                end;
            until TableMapFilters.Next = 0;
    end;

    procedure PullProcessExistRelation(var ParentTableData: RecordRef; var TableMap: Record DYM_MobileTableMap) Result: Boolean
    var
        ChildTableMap: Record DYM_MobileTableMap;
        TableMapFilters: Record DYM_MobileTableMapFilters;
        DummyFieldMap: Record DYM_MobileFieldMap;
        RecRef: RecordRef;
        FromField: FieldRef;
        ToField: FieldRef;
        HasFieldFilters: Boolean;
        FieldValue: Integer;
    begin
        Clear(Result);
        ChildTableMap.Reset;
        ChildTableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        ChildTableMap.SetRange("Device Role Code", DeviceRole.Code);
        ChildTableMap.SetFilter(Direction, '%1|%2', ChildTableMap.Direction::Both, ChildTableMap.Direction::Pull);
        ChildTableMap.SetRange("Parent Table No.", TableMap."Table No.");
        ChildTableMap.SetRange("Parent Table Index", TableMap.Index);
        ChildTableMap.SetFilter("Relation Type", '%1|%2', ChildTableMap."Relation Type"::Exists, ChildTableMap."Relation Type"::"Not Exists");
        ChildTableMap.SetRange("Pull Type", TableMap."Pull Type");
        ChildTableMap.SetRange(Disabled, false);
        if ChildTableMap.FindSet(false, false) then begin
            repeat
                Clear(Result);
                RecRef.Close;
                RecRef.Open(ChildTableMap."Table No.");
                RecRef.Reset;
                Clear(HasFieldFilters);
                HasFieldFilters := PullProcessApplyStaticFilters(RecRef, ChildTableMap, false, DummyFieldMap);
                if (HasFieldFilters) then begin
                    TableMapFilters.Reset;
                    TableMapFilters.SetRange("Device Role Code", ChildTableMap."Device Role Code");
                    TableMapFilters.SetRange("Table No.", ChildTableMap."Table No.");
                    TableMapFilters.SetRange("Table Index", ChildTableMap.Index);
                    TableMapFilters.SetRange("Filter Type", TableMapFilters."Filter Type"::Field);
                    TableMapFilters.SetFilter("Device Group Code", '%1|%2', '', DeviceGroup.Code);
                    TableMapFilters.SetFilter("Device Setup Code", '%1|%2', '', DeviceSetup.Code);
                    if TableMapFilters.FindSet(false, false) then
                        repeat
                            Evaluate(FieldValue, TableMapFilters."Filter Value");
                            FromField := ParentTableData.Field(FieldValue);
                            ToField := RecRef.Field(TableMapFilters."Filter Field No.");
                            ToField.SetRange(FromField.Value);
                        until TableMapFilters.Next = 0;
                end;
                case ChildTableMap."Relation Type" of
                    ChildTableMap."Relation Type"::Exists:
                        exit(not RecRef.IsEmpty);
                    ChildTableMap."Relation Type"::"Not Exists":
                        exit(RecRef.IsEmpty);
                end;
            until ChildTableMap.Next = 0;
        end
        else
            exit(true);
    end;

    procedure PullProcessLookUpRelation(var ParentTableData: RecordRef; var TableMap: Record DYM_MobileTableMap; var FieldMap: Record DYM_MobileFieldMap) Result: Text[250]
    var
        ChildTableMap: Record DYM_MobileTableMap;
        TableMapFilters: Record DYM_MobileTableMapFilters;
        DummyFieldMap: Record DYM_MobileFieldMap;
        LookUpFieldMap: Record DYM_MobileFieldMap;
        RecRef: RecordRef;
        FromField: FieldRef;
        ToField: FieldRef;
        LookUpField: FieldRef;
        HasFieldFilters: Boolean;
        FieldValue: Integer;
    begin
        Clear(Result);
        ChildTableMap.Reset;
        ChildTableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        ChildTableMap.SetRange("Device Role Code", DeviceRole.Code);
        ChildTableMap.SetFilter(Direction, '%1|%2', ChildTableMap.Direction::Both, ChildTableMap.Direction::Pull);
        ChildTableMap.SetRange("Parent Table No.", TableMap."Table No.");
        ChildTableMap.SetRange("Parent Table Index", TableMap.Index);
        ChildTableMap.SetRange("Relation Type", ChildTableMap."Relation Type"::LookUp);
        ChildTableMap.SetRange("Pull Type", TableMap."Pull Type");
        ChildTableMap.SetRange(Disabled, false);
        ChildTableMap.SetRange("Mobile Table", FieldMap."Mobile Field");
        if ChildTableMap.FindSet(false, false) then begin
            repeat
                Clear(Result);
                RecRef.Close;
                RecRef.Open(ChildTableMap."Table No.");
                RecRef.Reset;
                Clear(HasFieldFilters);
                HasFieldFilters := PullProcessApplyStaticFilters(RecRef, ChildTableMap, false, DummyFieldMap);
                if (HasFieldFilters) then begin
                    TableMapFilters.Reset;
                    TableMapFilters.SetRange("Device Role Code", ChildTableMap."Device Role Code");
                    TableMapFilters.SetRange("Table No.", ChildTableMap."Table No.");
                    TableMapFilters.SetRange("Table Index", ChildTableMap.Index);
                    TableMapFilters.SetRange("Filter Type", TableMapFilters."Filter Type"::Field);
                    TableMapFilters.SetFilter("Device Group Code", '%1|%2', '', DeviceGroup.Code);
                    TableMapFilters.SetFilter("Device Setup Code", '%1|%2', '', DeviceSetup.Code);
                    if TableMapFilters.FindSet(false, false) then
                        repeat
                            Evaluate(FieldValue, TableMapFilters."Filter Value");
                            FromField := ParentTableData.Field(FieldValue);
                            ToField := RecRef.Field(TableMapFilters."Filter Field No.");
                            ToField.SetRange(FromField.Value);
                        until TableMapFilters.Next = 0;
                end;
                if RecRef.FindFirst then begin
                    LookUpFieldMap.Reset;
                    LookUpFieldMap.SetRange("Device Role Code", ChildTableMap."Device Role Code");
                    LookUpFieldMap.SetRange("Table No.", ChildTableMap."Table No.");
                    LookUpFieldMap.SetRange("Table Index", ChildTableMap.Index);
                    LookUpFieldMap.SetRange("Mobile Field", FieldMap."Mobile Field");
                    LookUpFieldMap.SetRange(Disabled, false);
                    LookUpFieldMap.SetRange(Direction, LookUpFieldMap.Direction::"LookUp Result");
                    if LookUpFieldMap.FindFirst then begin
                        LookUpField := RecRef.Field(LookUpFieldMap."Field No.");
                        exit(LookUpField.Value);
                    end;
                end;
            until ChildTableMap.Next = 0;
        end;
    end;

    procedure PullProcessAutoSelectKey(var SourceTable: RecordRef; var TableMap: Record DYM_MobileTableMap) Result: Boolean
    var
        TableMapFilters: Record DYM_MobileTableMapFilters;
        KeyBuffer: Record "Dimension Buffer" temporary;
        FromField: FieldRef;
        KeyRef: KeyRef;
        SessionValueType: Integer;
        i: Integer;
    begin
        Clear(Result);
        KeyBuffer.Reset;
        KeyBuffer.DeleteAll;
        for i := 1 to SourceTable.KeyCount do begin
            KeyRef := SourceTable.KeyIndex(i);
            if KeyRef.Active then begin
                Clear(KeyBuffer);
                KeyBuffer.Init;
                KeyBuffer."Entry No." := i;
                KeyBuffer.Insert;
            end;
        end;
        TableMapFilters.Reset;
        TableMapFilters.SetRange("Device Role Code", TableMap."Device Role Code");
        TableMapFilters.SetRange("Table No.", TableMap."Table No.");
        TableMapFilters.SetRange("Table Index", TableMap.Index);
        TableMapFilters.SetFilter("Device Group Code", '%1|%2', '', DeviceGroup.Code);
        TableMapFilters.SetFilter("Device Setup Code", '%1|%2', '', DeviceSetup.Code);
        TableMapFilters.SetRange("FlowFilter to Field No.", 0);
        TableMapFilters.SetRange("FlowFilter to Field Index", 0);
        if TableMapFilters.FindSet(false, false) then
            repeat
                FromField := SourceTable.Field(TableMapFilters."Filter Field No.");
                KeyBuffer.Reset;
                if KeyBuffer.FindSet(false, false) then
                    repeat
                        KeyRef := SourceTable.KeyIndex(KeyBuffer."Entry No.");
                        for i := 1 to KeyRef.FieldCount do if (KeyRef.FieldIndex(i).Number = FromField.Number) then begin
                                KeyBuffer."No. Of Dimensions" += 1;
                                KeyBuffer.Modify;
                            end;
                    until KeyBuffer.Next = 0;
            until TableMapFilters.Next = 0;
        KeyBuffer.Reset;
        KeyBuffer.SetCurrentKey("No. Of Dimensions");
        if KeyBuffer.FindLast then if (KeyBuffer."No. Of Dimensions" <> 0) then SourceTable.CurrentKeyIndex(KeyBuffer."Entry No.");
    end;
    #endregion 
    #region LookUp
    procedure LookUpTable(var TableNo: Integer) Result: Boolean
    var
        Objects: Record AllObj;
    begin
        Clear(Result);
        Objects.Reset;
        Objects.SetRange("Object Type", Objects."Object Type"::Table);
        if PAGE.RunModal(PAGE::"All Objects", Objects) = ACTION::LookupOK then begin
            TableNo := Objects."Object ID";
            exit(true);
        end;
    end;

    procedure LookUpField(TableNo: Integer; var FieldNo: Integer) Result: Boolean
    var
        Fld: Record "Field";
        FldList: Page "Fields Lookup";
    begin
        Clear(Result);
        Clear(FldList);
        Fld.Reset;
        Fld.SetRange(TableNo, TableNo);
        if PAGE.RunModal(PAGE::"Fields Lookup", Fld) = ACTION::LookupOK then begin
            FieldNo := Fld."No.";
            exit(true);
        end;
    end;
    #endregion 
    #region Write Caching
    procedure FlushTableWriteCache(var RecRef: RecordRef)
    begin
        if RecRef.CountApprox = 0 then;
    end;
    #endregion
}
