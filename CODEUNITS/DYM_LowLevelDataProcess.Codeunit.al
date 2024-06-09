codeunit 70132 DYM_LowLevelDataProcess
{
    var Text001: Label '%1 is invalid number for filter value. Supported numbers are 1..999.';
    Text002: Label 'Evaluation error on casting. Table [%1] Record No. [%2] Field [%3] Value [%4].';
    FS_Integer: Label '<Sign><Integer>', Locked = true;
    FS_Decimal: Label '<Sign><Integer><Decimals><Comma,.>', Locked = true;
    FS_IC_Date: Label '<Month,2>/<Day,2>/<Year4>', Locked = true;
    FS_IC_Time: Label '<Hours24,2>:<Minutes,2>:<Seconds,2>', Locked = true;
    FS_IC_DateTime: Label '<Month,2>/<Day,2>/<Year4> <Hours24,2>:<Minutes,2>:<Seconds,2>', Locked = true;
    FS_OD_Date: Label '<Year4>-<Month,2>-<Day,2>', Locked = true;
    FS_OD_Time: Label '<Hours24,2>:<Minutes,2>:<Seconds,2>Z', Locked = true;
    FS_OD_DateTime: Label '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z', Locked = true;
    CacheMgt: Codeunit DYM_CacheManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    #region Filters Handling
    procedure ReplaceSingleStr(InputString: Text; SearchString: Text; ReplaceString: Text)Result: Text var
        SearchStringPos: Integer;
    begin
        Clear(Result);
        if((StrLen(InputString) = 0) or (StrLen(SearchString) = 0) or (StrLen(ReplaceString) = 0))then exit(InputString);
        Clear(SearchStringPos);
        SearchStringPos:=StrPos(InputString, SearchString);
        if(SearchStringPos = 0)then exit(InputString);
        Result:=Result + CopyStr(InputString, 1, SearchStringPos - 1);
        Result:=Result + ReplaceString;
        Result:=Result + CopyStr(InputString, SearchStringPos + StrLen(SearchString));
        Result:=ReplaceSingleStr(Result, SearchString, ReplaceString);
    end;
    procedure GetSubStrCount(InputString: Text)Result: Integer var
        i: Integer;
    begin
        Clear(Result);
        for i:=1 to StrLen(InputString)do if(Format(InputString[i]) = ',')then Result+=1;
        Result+=1;
    end;
    procedure GetFilterValueMask(FilterValue: Integer)Result: Code[10]begin
        Clear(Result);
        if not(FilterValue in[1 .. 999])then Error(Text001, FilterValue);
        Result:='$' + PadStr('', 3 - StrLen(Format(FilterValue)), '0') + Format(FilterValue);
    end;
    #endregion 
    #region Data Type Conversion
    procedure Text2Boolean(Value: Text)Result: Boolean var
        TrueValue: Label 'TRUE', Locked = true;
        FalseValue: Label 'FALSE', Locked = true;
        TrueValueInt: Label '1', Locked = true;
        FalseValueInt: Label '0', Locked = true;
        IsHandled: Boolean;
    begin
        Clear(Result);
        OnBeforeText2Boolean(Value, Result, IsHandled);
        If IsHandled then exit;
        case UpperCase(Value)of TrueValue: Result:=true;
        FalseValue: Result:=false;
        end;
        case UpperCase(Value)of TrueValueInt: Result:=true;
        FalseValueInt: Result:=false;
        end;
    end;
    procedure Boolean2Text(Value: Boolean)Result: Text var
        TrueValue: Label 'true';
        FalseValue: Label 'false';
        IsHandled: Boolean;
    begin
        OnBeforeBoolean2Text(Value, Result, IsHandled);
        if IsHandled Then exit;
        case Value of true: Result:=TrueValue;
        false: Result:=FalseValue;
        end;
    end;
    procedure Text2Integer(Value: Text)Result: Integer var
        IsHandled: Boolean;
    begin
        OnBeforeText2Integer(Value, Result, IsHandled);
        if IsHandled then exit;
        if not Evaluate(Result, Value)then Clear(Result);
    end;
    procedure Integer2Text(Value: Integer)Result: Text var
        IsHandled: Boolean;
    begin
        Clear(Result);
        OnBeforeInteger2Text(Value, Result, IsHandled);
        if IsHandled then exit;
        Result:=Format(Value, 0, FS_Integer);
    end;
    procedure Text2BigInteger(Value: Text)Result: BigInteger var
        IsHandled: Boolean;
    begin
        OnBeforeText2BigInteger(Value, Result, IsHandled);
        if IsHandled then exit;
        if not Evaluate(Result, Value)then Clear(Result);
    end;
    procedure BigInteger2Text(Value: BigInteger)Result: Text var
        IsHandled: Boolean;
    begin
        Clear(Result);
        OnBeforeBigInteger2Text(Value, Result, IsHandled);
        if IsHandled then exit;
        Result:=Format(Value, 0, FS_Integer);
    end;
    procedure Text2Decimal(Value: Text)Result: Decimal var
        DecSepPos: Integer;
        TempText: Text;
        TempInt: Integer;
        Sign: Integer;
        IsHandled: Boolean;
    begin
        Clear(Result);
        OnBeforeText2Decimal(Value, Result, IsHandled);
        if IsHandled then exit;
        Clear(DecSepPos);
        Clear(Sign);
        if(Value = '')then exit;
        Sign:=1;
        if(CopyStr(Value, 1, 1) = '-')then Sign:=-1;
        DecSepPos:=StrPos(Value, '.');
        if(DecSepPos <> 0)then begin
            TempText:=CopyStr(Value, 1, DecSepPos - 1);
            if not Evaluate(TempInt, TempText)then CastingError(Value);
            Result:=Result + TempInt;
            TempText:=CopyStr(Value, DecSepPos + 1);
            if not Evaluate(TempInt, TempText)then CastingError(Value);
            if(TempInt <> 0)then Result:=Result + Sign * TempInt / Power_Int(10, StrLen(TempText));
        end
        else if not Evaluate(Result, Value)then CastingError(Value);
    end;
    procedure Decimal2Text(Value: Decimal)Result: Text var
        IsHandled: Boolean;
    begin
        Clear(Result);
        OnBeforeDecimal2Text(Value, Result, IsHandled);
        if IsHandled then exit;
        Result:=Format(Value, 0, FS_Decimal);
    end;
    procedure Text2Date(Value: Text)Result: Date var
        IsHandled: Boolean;
    begin
        OnBeforeText2Date(Value, Result, IsHandled);
        if IsHandled then exit;
        exit(ODText2Date(Value));
    end;
    procedure Date2Text(Value: Date)Result: Text var
        IsHandled: Boolean;
    begin
        OnBeforeDate2Text(Value, Result, IsHandled);
        if IsHandled then exit;
        exit(ODDate2Text(Value));
    end;
    procedure Text2Time(Value: Text)Result: Time var
        IsHandled: Boolean;
    begin
        OnBeforeText2Time(Value, Result, IsHandled);
        if IsHandled then exit;
        exit(ODText2Time(Value));
    end;
    procedure Time2Text(Value: Time)Result: Text var
        IsHandled: Boolean;
    begin
        OnBeforeTime2Text(Value, Result, IsHandled);
        if IsHandled then exit;
        exit(ODTime2Text(value));
    end;
    procedure Text2DateTime(Value: Text)Result: DateTime var
        IsHandled: Boolean;
    begin
        OnBeforeText2DateTime(Value, Result, IsHandled);
        if IsHandled then exit;
        exit(ODText2DateTime(Value));
    end;
    procedure DateTime2Text(Value: DateTime)Result: Text var
        IsHandled: Boolean;
    begin
        OnBeforeDateTime2Text(Value, Result, IsHandled);
        if IsHandled then exit;
        exit(ODDateTime2Text(Value));
    end;
    procedure Text2Option(VAR FieldRef: FieldRef; Value: Text)Result: Integer var
        OptionString: Text;
        OptionValue: Text;
        OptionCount: Integer;
        OptionPos: Integer;
        IsHandled: Boolean;
    begin
        Result:=-1;
        OnBeforeText2Option(FieldRef, Value, Result, IsHandled);
        if IsHandled then exit;
        OptionString:=FieldRef.OptionMembers;
        OptionCount:=GetSubStrCount(OptionString);
        FOR OptionPos:=1 TO OptionCount DO BEGIN
            OptionValue:=SELECTSTR(OptionPos, OptionString);
            IF(SELECTSTR(OptionPos, OptionString) = Value)THEN Result:=OptionPos - 1;
        END;
        IF(Result = -1)THEN ERROR(Text002, FieldRef.RECORD.NAME, CacheMgt.GetRecNoContext, FieldRef.NAME, Value);
    end;
    procedure Option2Text(VAR FieldRef: FieldRef)Result: Text var
        OptionString: Text;
        OptionPos: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeOption2Text(FieldRef, Result, IsHandled);
        if IsHandled then exit;
        OptionString:=FieldRef.OptionMembers;
        OptionPos:=FieldRef.VALUE;
        EXIT(SELECTSTR(OptionPos + 1, OptionString));
    end;
    procedure OptionValue2Text(FieldPos: Text; Value: Integer)Result: Text var
        RecRef: RecordRef;
        FldRef: FieldRef;
        TableId: Integer;
        FieldId: Integer;
        IsHandled: Boolean;
    begin
        CLEAR(Result);
        OnBeforeOptionValue2Text(FieldPos, Value, Result, IsHandled);
        if IsHandled then exit;
        IF NOT EVALUATE(TableId, SELECTSTR(1, FieldPos))THEN CLEAR(TableId);
        IF NOT EVALUATE(FieldId, SELECTSTR(2, FieldPos))THEN CLEAR(FieldId);
        RecRef.OPEN(TableId);
        FldRef:=RecRef.FIELD(FieldId);
        FldRef.VALUE:=Value;
        EXIT(Option2Text(FldRef));
    end;
    procedure Text2OptionValue(FieldPos: Text; Value: Text)Result: Integer var
        RecRef: RecordRef;
        FldRef: FieldRef;
        TableId: Integer;
        FieldId: Integer;
        IsHandled: Boolean;
    begin
        CLEAR(Result);
        OnBeforeText2OptionValue(FieldPos, Value, Result, IsHandled);
        if IsHandled then exit;
        IF NOT EVALUATE(TableId, SELECTSTR(1, FieldPos))THEN CLEAR(TableId);
        IF NOT EVALUATE(FieldId, SELECTSTR(2, FieldPos))THEN CLEAR(FieldId);
        RecRef.OPEN(TableId);
        FldRef:=RecRef.FIELD(FieldId);
        EXIT(Text2Option(FldRef, Value));
    end;
    #endregion 
    #region BLOBs
    procedure BigText2Blob(var FldRef: FieldRef; var Data: BigText)
    var
        TempBlob: Codeunit "Temp Blob";
        OutS: OutStream;
        tb: Codeunit "Temp Blob";
    begin
        if(GetFieldType(FldRef.Record.Number, FldRef.Number) <> ConstMgt.FDT_BLOB)then exit;
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        data.Write(OutS);
        TempBlob.ToFieldRef(FldRef);
    end;
    procedure Blob2BigText(var FldRef: FieldRef; var Data: BigText)
    var
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
    begin
        if(GetFieldType(FldRef.Record.Number, FldRef.Number) <> ConstMgt.FDT_BLOB)then exit;
        TempBlob.FromFieldRef(FldRef);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        data.Read(InS);
    end;
    #endregion 
    #region base64
    procedure b64Text2Blob(var FldRef: FieldRef; TextValue: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutS: OutStream;
    begin
        if(TextValue = '')then exit;
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        Base64Convert.FromBase64(TextValue, OutS);
        TempBlob.ToFieldRef(FldRef);
    end;
    procedure Blob2b64Text(var FldRef: FieldRef)Result: Text var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
    begin
        TempBlob.FromFieldRef(FldRef);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        exit(Base64Convert.ToBase64(InS));
    end;
    procedure b64Text2Media(var FldRef: FieldRef; TextValue: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutS: OutStream;
        TenantMedia: Record "Tenant Media";
    begin
        IF(TextValue = '')THEN EXIT;
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        TempBlob.ToFieldRef(FldRef);
        TenantMedia.INIT;
        TenantMedia.ID:=CREATEGUID;
        TenantMedia.Content.CreateOutStream(OutS, TextEncoding::UTF8);
        Base64Convert.FromBase64(TextValue, OutS);
        TenantMedia.INSERT;
        FldRef.VALUE:=TenantMedia.ID;
    end;
    procedure Media2b64Text(var FldRef: FieldRef)Result: Text var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        TenantMedia: Record "Tenant Media";
    begin
        CLEAR(Result);
        FldRef.CALCFIELD;
        TempBlob.FromFieldRef(FldRef);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        Result:=Base64Convert.ToBase64(InS);
    end;
    #endregion 
    #region Invariant Culture Format
    procedure ICText2Date(Value: Text)Result: Date var
        TempText: Text;
        Year: Integer;
        Month: Integer;
        Day: Integer;
    begin
        Clear(Result);
        Clear(Year);
        Clear(Month);
        Clear(Day);
        if(StrLen(Value) = 0)then exit(0D);
        if(StrLen(Value) <> 10)then CastingError(Value);
        TempText:=CopyStr(Value, 7, 4);
        if not Evaluate(Year, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 1, 2);
        if not Evaluate(Month, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 4, 2);
        if not Evaluate(Day, TempText)then CastingError(Value);
        Result:=DMY2Date(Day, Month, Year);
    end;
    procedure ICDate2Text(Value: Date)Result: Text begin
        Clear(Result);
        if(Value = 0D)then exit;
        Result:=Format(Value, 0, FS_IC_Date);
    end;
    procedure ICText2Time(Value: Text)Result: Time var
        TempText: Text;
        Hour: Integer;
        "Min": Integer;
        Sec: Integer;
    begin
        Clear(Result);
        Clear(Hour);
        Clear(Min);
        Clear(Sec);
        if(StrLen(Value) = 0)then exit(0T);
        if(StrLen(Value) <> 8)then CastingError(Value);
        TempText:=CopyStr(Value, 1, 2);
        if not Evaluate(Hour, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 4, 2);
        if not Evaluate(Min, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 7, 2);
        if not Evaluate(Sec, TempText)then CastingError(Value);
        if(not(Hour in[0 .. 23]) or not(Min in[0 .. 59]) or not(Sec in[0 .. 59]))then CastingError(Value);
        Result:=000000T + Hour * 3600000 + Min * 60000 + Sec * 1000;
    end;
    procedure ICTime2Text(Value: Time)Result: Text begin
        Clear(Result);
        if(Value = 0T)then exit;
        Result:=Format(Value, 0, FS_IC_Time);
    end;
    procedure ICText2DateTime(Value: Text)Result: DateTime var
        DateText: Text;
        TimeText: Text;
    begin
        Clear(Result);
        Clear(DateText);
        Clear(TimeText);
        if(StrLen(Value) = 0)then exit;
        if(StrLen(Value) <> 19)then CastingError(Value);
        DateText:=CopyStr(Value, 1, 10);
        TimeText:=CopyStr(Value, 12, 8);
        Result:=CreateDateTime(Text2Date(DateText), Text2Time(TimeText));
    end;
    procedure ICDateTime2Text(Value: DateTime)Result: Text begin
        Clear(Result);
        if(Value = CreateDateTime(0D, 0T))then exit;
        Result:=Format(Value, 0, FS_IC_DateTime);
    end;
    #endregion 
    #region OData Format
    procedure ODText2Date(Value: Text)Result: Date var
        TempText: Text;
        Year: Integer;
        Month: Integer;
        Day: Integer;
    begin
        Clear(Result);
        Clear(Year);
        Clear(Month);
        Clear(Day);
        if(StrLen(Value) = 0)then exit(0D);
        if(StrLen(Value) <> 10)then CastingError(Value);
        TempText:=CopyStr(Value, 1, 4);
        if not Evaluate(Year, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 6, 2);
        if not Evaluate(Month, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 9, 2);
        if not Evaluate(Day, TempText)then CastingError(Value);
        Result:=DMY2Date(Day, Month, Year);
    end;
    procedure ODDate2Text(Value: Date)Result: Text begin
        Clear(Result);
        if(Value = 0D)then exit;
        Result:=Format(Value, 0, FS_OD_Date);
    end;
    procedure ODText2Time(Value: Text)Result: Time var
        TempText: Text;
        Hour: Integer;
        "Min": Integer;
        Sec: Integer;
    begin
        Clear(Result);
        Clear(Hour);
        Clear(Min);
        Clear(Sec);
        if(StrLen(Value) = 0)then exit(0T);
        if not(StrLen(Value)IN[8, 12])then CastingError(Value);
        TempText:=CopyStr(Value, 1, 2);
        if not Evaluate(Hour, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 4, 2);
        if not Evaluate(Min, TempText)then CastingError(Value);
        TempText:=CopyStr(Value, 7, 2);
        if not Evaluate(Sec, TempText)then CastingError(Value);
        if(not(Hour in[0 .. 23]) or not(Min in[0 .. 59]) or not(Sec in[0 .. 59]))then CastingError(Value);
        Result:=000000T + Hour * 3600000 + Min * 60000 + Sec * 1000;
    end;
    procedure ODTime2Text(Value: Time)Result: Text begin
        Clear(Result);
        if(Value = 0T)then exit;
        Result:=Format(Value, 0, FS_OD_Time);
    end;
    procedure ODText2DateTime(Value: Text)Result: DateTime var
        DateText: Text;
        TimeText: Text;
    begin
        Clear(Result);
        Clear(DateText);
        Clear(TimeText);
        if(StrLen(Value) = 0)then exit;
        if not(StrLen(Value)IN[20, 24])then CastingError(Value);
        DateText:=CopyStr(Value, 1, 10);
        TimeText:=CopyStr(Value, 12, 8);
        Result:=CreateDateTime(Text2Date(DateText), Text2Time(TimeText));
    end;
    procedure ODDateTime2Text(Value: DateTime)Result: Text begin
        Clear(Result);
        if(Value = CreateDateTime(0D, 0T))then exit;
        Result:=Format(Value, 0, FS_OD_DateTime);
    end;
    #endregion 
    #region Math
    procedure Power_Int(Base: Integer; Power: Integer)Result: Integer var
        i: Integer;
    begin
        Result:=1;
        for i:=1 to Power do Result:=Result * Base;
    end;
    #endregion 
    #region Casting Error Handling
    procedure CastingError(TextValue: Text)
    var
        MobileTableMap: Record DYM_MobileTableMap;
        MobileFieldMap: Record DYM_MobileFieldMap;
    begin
        CacheMgt.GetFieldMapContext(MobileFieldMap);
        if not MobileTableMap.Get(MobileFieldMap."Device Role Code", MobileFieldMap."Table No.", MobileFieldMap."Table Index")then Clear(MobileTableMap);
        Error(Text002, MobileTableMap."Mobile Table", CacheMgt.GetRecNoContext, MobileFieldMap."Mobile Field", TextValue);
    end;
    #endregion 
    #region Object properties
    procedure GetFieldType(TableNo: Integer; FieldNo: Integer): Integer var
        Fld: Record "Field";
    begin
        if Fld.Get(TableNo, FieldNo)then exit(Fld.Type);
    end;
    procedure GetFieldClass(TableNo: Integer; FieldNo: Integer): Integer var
        Fld: Record "Field";
    begin
        if Fld.Get(TableNo, FieldNo)then exit(Fld.Class);
    end;
    procedure GetFieldName(TableNo: Integer; FieldNo: Integer)Result: Text var
        Fld: Record "Field";
    begin
        if Fld.Get(TableNo, FieldNo)then exit(Fld.FieldName);
    end;
    procedure GetFieldByName(_TableNo: Integer; _FieldName: Text)Result: Integer var
        Fld: Record "Field";
    begin
        Fld.Reset();
        fld.SetRange(TableNo, _TableNo);
        Fld.SetRange(FieldName, _FieldName);
        if Fld.FindFirst()then exit(Fld."No.");
    end;
    procedure GetTableName(TableNo: Integer)Result: Text var
        AllObj: Record AllObj;
    begin
        Clear(Result);
        if AllObj.Get(AllObj."Object Type"::Table, TableNo)then exit(AllObj."Object Name");
    end;
    #endregion 
    #region Field Ref
    procedure GetFieldRefFieldType(FldRef: FieldRef)Result: Integer begin
        Clear(Result);
        exit(GetFieldType(FldRef.Record.Number, FldRef.Number));
    end;
    procedure FldRefValue2Text(FldMap: Record DYM_MobileFieldMap; FldType: Integer; var FldRef: FieldRef; var TextValue: Text)
    var
        TempInteger: Integer;
        TempBigInteger: BigInteger;
        TempDecimal: Decimal;
        TempBoolean: Boolean;
        TempDate: Date;
        TempTime: Time;
        TempDateTime: DateTime;
        TempCode: Code[250];
        TempText: Text;
        IsHandled: Boolean;
    begin
        if(FldType = 0)then FldType:=GetFieldRefFieldType(FldRef);
        OnBeforeFldRefValue2Text(FldType, FldRef, TextValue, IsHandled);
        if IsHandled then exit;
        case FldType of ConstMgt.FDT_Option: begin
            //Option/Enum handling as text is neeeded by Warehouse Demo app
            //TextValue := FldRef.GetEnumValueNameFromOrdinalValue(FldRef.Value);
            TempInteger:=FldRef.Value;
            TextValue:=Integer2Text(TempInteger);
        end;
        ConstMgt.FDT_Integer: begin
            TempInteger:=FldRef.Value;
            TextValue:=Integer2Text(TempInteger);
        end;
        ConstMgt.FDT_BigInteger: begin
            TempBigInteger:=FldRef.Value;
            TextValue:=BigInteger2Text(TempBigInteger);
        end;
        ConstMgt.FDT_Decimal: begin
            TempDecimal:=FldRef.Value;
            TextValue:=Decimal2Text(TempDecimal);
        end;
        ConstMgt.FDT_Boolean: begin
            TempBoolean:=FldRef.Value;
            TextValue:=Boolean2Text(TempBoolean);
        end;
        ConstMgt.FDT_Date: begin
            TempDate:=FldRef.Value;
            //Value := Date2Text ( TempDate ) ;
            //TempDateTime := CreateDateTime(TempDate, 0T);
            if((TempDate <> 0D) and (FldMap."Const Value Type" = Enum::DYM_MobileFieldMapConstType::"Ending Date"))then TempDateTime:=CreateDateTime(TempDate, 235959T)
            else
                TempDateTime:=CreateDateTime(TempDate, 0T);
            TextValue:=DateTime2Text(TempDateTime);
        end;
        ConstMgt.FDT_Time: begin
            TempTime:=FldRef.Value;
            //Value := Time2Text ( TempTime ) ;
            TempDateTime:=CreateDateTime(Today, TempTime);
            TextValue:=DateTime2Text(TempDateTime);
        end;
        ConstMgt.FDT_DateTime: begin
            TempDateTime:=FldRef.Value;
            TextValue:=DateTime2Text(TempDateTime);
        end;
        ConstMgt.FDT_Code: begin
            TempCode:=FldRef.Value;
            TextValue:=Format(TempCode, 0, 1);
        end;
        ConstMgt.FDT_Text: begin
            TempText:=FldRef.Value;
            TextValue:=Format(TempText, 0, 1);
        end;
        ConstMgt.FDT_BLOB: begin
            //CLEAR ( Value ) ;
            TextValue:=Blob2b64Text(FldRef);
        end;
        ConstMgt.FDT_Media: begin
            TextValue:=Media2b64Text(FldRef);
        end;
        else
            Error(Text002, FldType);
        end;
    end;
    procedure GetFldRefValue2Text(FldMap: Record DYM_MobileFieldMap; var FldRef: FieldRef)Result: Text begin
        Clear(Result);
        FldRefValue2Text(FldMap, 0, FldRef, Result);
    end;
    procedure Value2FldRef(var FldRef: FieldRef; TextValue: Text)
    var
        RecRef: RecordRef;
        FldType: Integer;
        TempInteger: Integer;
        TempBigInteger: BigInteger;
        TempDecimal: Decimal;
        TempBoolean: Boolean;
        TempDate: Date;
        TempTime: Time;
        TempDateTime: DateTime;
        TempCode: Code[250];
        TempText: Text;
    begin
        RecRef:=FldRef.Record;
        FldType:=GetFieldType(RecRef.Number, FldRef.Number);
        case FldType of ConstMgt.FDT_Option(): begin
            CASE IsNumStr(TextValue)OF TRUE: TempInteger:=Text2Integer(TextValue);
            FALSE: TempInteger:=Text2Option(FldRef, TextValue);
            END;
            FldRef.VALUE:=TempInteger;
        end;
        ConstMgt.FDT_Integer: begin
            TempInteger:=Text2Integer(TextValue);
            FldRef.Value:=TempInteger;
        end;
        ConstMgt.FDT_BigInteger: begin
            TempBigInteger:=Text2BigInteger(TextValue);
            FldRef.Value:=TempBigInteger;
        end;
        ConstMgt.FDT_Decimal: begin
            TempDecimal:=Text2Decimal(TextValue);
            FldRef.Value:=TempDecimal;
        end;
        ConstMgt.FDT_Boolean: begin
            TempBoolean:=Text2Boolean(TextValue);
            FldRef.Value:=TempBoolean;
        end;
        ConstMgt.FDT_Date: begin
            //TempDate := Text2Date ( Value ) ;
            TempDate:=DT2Date(Text2DateTime(TextValue));
            FldRef.Value:=TempDate;
        end;
        ConstMgt.FDT_Time: begin
            //TempTime := Text2Time ( Value ) ;
            TempTime:=DT2Time(Text2DateTime(TextValue));
            FldRef.Value:=TempTime;
        end;
        ConstMgt.FDT_DateTime: begin
            TempDateTime:=Text2DateTime(TextValue);
            FldRef.Value:=TempDateTime;
        end;
        ConstMgt.FDT_Code: begin
            if Evaluate(TempCode, TextValue)then FldRef.Value:=TempCode;
        end;
        ConstMgt.FDT_Text: begin
            if Evaluate(TempText, TextValue)then FldRef.Value:=TempText;
        end;
        ConstMgt.FDT_BLOB: begin
            b64Text2Blob(FldRef, TextValue);
        end;
        ConstMgt.FDT_Media(): begin
            b64Text2Media(FldRef, TextValue);
        end;
        else
            CastingError(TextValue);
        end;
    end;
    procedure Value2FldRefFilter(var FldRef: FieldRef; TextValue: Text)
    var
        RecRef: RecordRef;
        FldType: Integer;
        TempInteger: Integer;
        TempBigInteger: BigInteger;
        TempDecimal: Decimal;
        TempBoolean: Boolean;
        TempDate: Date;
        TempTime: Time;
        TempDateTime: DateTime;
        TempCode: Code[250];
        TempText: Text;
    begin
        RecRef:=FldRef.Record;
        FldType:=GetFieldType(RecRef.Number, FldRef.Number);
        case FldType of ConstMgt.FDT_Option(): begin
            CASE IsNumStr(TextValue)OF TRUE: TempInteger:=Text2Integer(TextValue);
            FALSE: TempInteger:=Text2Option(FldRef, TextValue);
            END;
            FldRef.SetRange(TempInteger);
        end;
        ConstMgt.FDT_Integer: begin
            TempInteger:=Text2Integer(TextValue);
            FldRef.SetRange(TempInteger);
        end;
        ConstMgt.FDT_BigInteger: begin
            TempBigInteger:=Text2BigInteger(TextValue);
            FldRef.SetRange(TempBigInteger);
        end;
        ConstMgt.FDT_Decimal: begin
            TempDecimal:=Text2Decimal(TextValue);
            FldRef.SetRange(TempDecimal);
        end;
        ConstMgt.FDT_Boolean: begin
            TempBoolean:=Text2Boolean(TextValue);
            FldRef.SetRange(TempBoolean);
        end;
        ConstMgt.FDT_Date: begin
            //TempDate := Text2Date ( Value ) ;
            TempDate:=DT2Date(Text2DateTime(TextValue));
            FldRef.SetRange(TempDate);
        end;
        ConstMgt.FDT_Time: begin
            //TempTime := Text2Time ( Value ) ;
            TempTime:=DT2Time(Text2DateTime(TextValue));
            FldRef.SetRange(TempTime);
        end;
        ConstMgt.FDT_DateTime: begin
            TempDateTime:=Text2DateTime(TextValue);
            FldRef.SetRange(TempDateTime);
        end;
        ConstMgt.FDT_Code: begin
            if Evaluate(TempCode, TextValue)then FldRef.SetRange(TempCode);
        end;
        ConstMgt.FDT_Text: begin
            if Evaluate(TempText, TextValue)then FldRef.SetRange(TempText);
        end;
        else
            CastingError(TextValue);
        end;
    end;
    #endregion 
    #region Field Type Checks
    procedure IsInteger(TableNo: Integer; FieldNo: Integer)Result: Boolean begin
        exit(GetFieldType(TableNo, FieldNo) = ConstMgt.FDT_Integer);
    end;
    procedure IsDecimal(TableNo: Integer; FieldNo: Integer)Result: Boolean begin
        exit(GetFieldType(TableNo, FieldNo) = ConstMgt.FDT_Decimal());
    end;
    procedure IsBLOB(TableNo: Integer; FieldNo: Integer): Boolean begin
        exit(GetFieldType(TableNo, FieldNo) = ConstMgt.FDT_BLOB);
    end;
    procedure IsMedia(TableNo: Integer; FieldNo: Integer): Boolean begin
        exit(GetFieldType(TableNo, FieldNo) = ConstMgt.FDT_Media);
    end;
    procedure IsSupported(TableNo: Integer; FieldNo: Integer)Result: Boolean begin
        exit(GetFieldType(TableNo, FieldNo)in[ConstMgt.FDT_Integer, ConstMgt.FDT_Option, ConstMgt.FDT_BigInteger, ConstMgt.FDT_Decimal, ConstMgt.FDT_Boolean, ConstMgt.FDT_Date, ConstMgt.FDT_Time, ConstMgt.FDT_DateTime, ConstMgt.FDT_Code, ConstMgt.FDT_Text, ConstMgt.FDT_BLOB]);
    end;
    #endregion 
    #region Field Class Checks
    procedure IsFlowField(TableNo: Integer; FieldNo: Integer)Result: Boolean begin
        exit(GetFieldClass(TableNo, FieldNo) = ConstMgt.FDC_FlowField);
    end;
    procedure IsFlowFilter(TableNo: Integer; FieldNo: Integer)Result: Boolean begin
        exit(GetFieldClass(TableNo, FieldNo) = ConstMgt.FDC_FlowFilter);
    end;
    #endregion 
    #region Json
    procedure AddRecordRef2Json(RecRef: RecordRef)Result: JsonObject var
        JObj: JsonObject;
        FldRef: FieldRef;
        FieldCount: Integer;
        i: Integer;
        TAB: Char;
        DummyFldMap: Record DYM_MobileFieldMap;
    begin
        Clear(JObj);
        Clear(DummyFldMap);
        TAB:=ConstMgt.BYT_TAB;
        FieldCount:=RecRef.FieldCount;
        for i:=1 to FieldCount do begin
            FldRef:=RecRef.FieldIndex(i);
            if(IsSupported(RecRef.Number, FldRef.Number))then begin
                //Result := Result + GetFldRefValue2Text(DummyFldMap, FldRef);
                JObj.Add(FldRef.Name, GetFldRefValue2Text(DummyFldMap, FldRef));
            //if (i <> FieldCount) then
            //    Result := Result + Format(TAB);
            end;
        end;
        Result.Add(ConstMgt.SYN_Record(), JObj);
    end;
    #endregion 
    #region Text Data IO
    procedure RecordRef2Text(RecRef: RecordRef)Result: Text var
        FldRef: FieldRef;
        FieldCount: Integer;
        i: Integer;
        TAB: Char;
        DummyFldMap: Record DYM_MobileFieldMap;
    begin
        Clear(Result);
        Clear(DummyFldMap);
        TAB:=ConstMgt.BYT_TAB;
        FieldCount:=RecRef.FieldCount;
        for i:=1 to FieldCount do begin
            FldRef:=RecRef.FieldIndex(i);
            if(IsSupported(RecRef.Number, FldRef.Number))then begin
                Result:=Result + GetFldRefValue2Text(DummyFldMap, FldRef);
                if(i <> FieldCount)then Result:=Result + Format(TAB);
            end;
        end;
    end;
    procedure Text2RecordRef(Value: Text; var RecRef: RecordRef)
    var
        FldRef: FieldRef;
        FieldCount: Integer;
        DelimiterPos: Integer;
        i: Integer;
        FieldVal: Text;
        TAB: Char;
    begin
        RecRef.Init;
        TAB:=ConstMgt.BYT_TAB;
        FieldCount:=RecRef.FieldCount;
        for i:=1 to FieldCount do begin
            FldRef:=RecRef.FieldIndex(i);
            if((IsSupported(RecRef.Number, FldRef.Number)) and (not IsFlowField(RecRef.Number, FldRef.Number)) and (not IsFlowFilter(RecRef.Number, FldRef.Number)))then begin
                if(i = FieldCount)then DelimiterPos:=StrLen(Value) + 1
                else
                    DelimiterPos:=StrPos(Value, Format(TAB));
                if(DelimiterPos <> 0)then FieldVal:=CopyStr(Value, 1, DelimiterPos - 1)
                else
                    Clear(FieldVal);
                Value:=CopyStr(Value, DelimiterPos + 1);
                Value2FldRef(FldRef, FieldVal);
            end;
        end;
        if not RecRef.Insert then RecRef.Modify;
    end;
    procedure RecordRefPK2Text(RecRef: RecordRef)Result: Text begin
        Clear(Result);
        exit(RecRef.GetPosition(false));
    end;
    procedure RecordRefPK2TextDescriptive(RecRef: RecordRef)Result: Text var
        SubStrPos: Integer;
    begin
        Clear(Result);
        Result:=RecRef.GetPosition(true);
        Clear(SubStrPos);
        repeat SubStrPos:=StrPos(Result, ConstMgt.CNS_Const);
            if(SubStrPos <> 0)then Result:=DelStr(Result, SubStrPos, StrLen(ConstMgt.CNS_Const));
        until SubStrPos = 0;
    end;
    procedure GetPositionWithNames(TableNo: Integer; Position: Text)Result: Text[250]var
        RecRef: RecordRef;
    begin
        clear(Result);
        if(Position = '')then exit;
        RecRef.Open(TableNo, true);
        RecRef.SetPosition(Position);
        exit(RecRef.GetPosition(true));
    end;
    procedure ValidateText(Val: Text)Result: Text begin
        Result:=Val;
        Result:=DelChr(Result, '=', ConstMgt.VTX_InvalidChars);
        Result:=ConvertStr(Result, ConstMgt.VTX_SearchChars, ConstMgt.VTX_ReplaceChars);
    end;
    procedure SQLValidateText(Val: Text)Result: Text begin
        Result:=Val;
        Result:=ConvertStr(Result, ConstMgt.VTX_SearchChars, ConstMgt.VTX_ReplaceChars);
    end;
    procedure IsInPrimaryKey(TableNo: Integer; FieldNo: Integer)Result: Boolean var
        RecRef: RecordRef;
        FldRef: FieldRef;
        KeyRef: KeyRef;
        i: Integer;
    begin
        Clear(Result);
        RecRef.Open(TableNo, true);
        KeyRef:=RecRef.KeyIndex(1);
        for i:=1 to KeyRef.FieldCount do begin
            FldRef:=KeyRef.FieldIndex(i);
            if(FldRef.Number = FieldNo)then Result:=true;
        end;
    end;
    procedure Duration2SecondsText(_Duration: Duration): Text begin
        exit(BigInteger2Text(_Duration));
    end;
    #endregion 
    #region Text functions
    procedure ReplaceStr(InputString: Text; SearchString: Text; ReplaceString: Text)Result: Text var
        SearchStringPos: Integer;
        WorkString: Text;
    begin
        Clear(Result);
        if((StrLen(InputString) = 0) or (StrLen(SearchString) = 0) or (StrLen(ReplaceString) = 0))then exit(InputString);
        WorkString:=InputString;
        repeat Clear(SearchStringPos);
            SearchStringPos:=StrPos(WorkString, SearchString);
            if(SearchStringPos <> 0)then begin
                Result:=Result + CopyStr(WorkString, 1, SearchStringPos - 1);
                Result:=Result + ReplaceString;
                WorkString:=CopyStr(WorkString, SearchStringPos + StrLen(SearchString));
            end
            else
                Result:=Result + WorkString;
        until SearchStringPos = 0;
    end;
    procedure CRLF()Result: Text;
    var
        TempChar: Char;
    begin
        Clear(Result);
        TempChar:=13; //CR
        Result:=Result + Format(TempChar);
        TempChar:=10; //LF
        Result:=Result + Format(TempChar);
    end;
    procedure IsNumStr(Value: Text)Result: Boolean var
        CharPos: Integer;
        CharLoop: Integer;
    begin
        CLEAR(Result);
        IF(Value = '')THEN EXIT;
        Result:=TRUE;
        FOR CharLoop:=1 TO STRLEN(Value)DO BEGIN
            IF NOT IsNumChar(Value[CharLoop])THEN CLEAR(Result);
        END;
    end;
    procedure IsNumChar(Chr: Char)Result: Boolean begin
        EXIT(Chr IN['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']);
    end;
    procedure IsCurlyBracketEncapsulated(_Value: Text): Boolean begin
        exit((CopyStr(_Value, 1, 1) = '{') and (CopyStr(_Value, StrLen(_Value), 1) = '}'));
    end;
    procedure AddText2CommaSepList(_ListText: Text; _Value: Text): Text begin
        case(_ListText = '')of true: exit(_Value);
        false: exit(StrSubstNo('%1,%2', _ListText, _Value));
        end;
    end;
    procedure List2Text(_List: List of[Text])Result: Text var
        ListPos: Integer;
    begin
        Clear(Result);
        for ListPos:=1 to _List.Count do if(ListPos = 1)then Result:=_list.Get(ListPos)
            else
                Result:=Result + ',' + _list.Get(ListPos);
    end;
    #endregion 
    #region GUID functions
    procedure GetNullGuid()Result: Guid begin
        clear(Result)end;
    #endregion 
    #region Event Publishers
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2Boolean(_value: Text; var _result: Boolean; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeBoolean2Text(_value: Boolean; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2Integer(_value: Text; var _result: Integer; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeInteger2Text(_value: Integer; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2BigInteger(_value: Text; var _result: BigInteger; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeBigInteger2Text(_value: BigInteger; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2Decimal(_value: Text; var _result: Decimal; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeDecimal2Text(_value: Decimal; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2Date(_value: Text; var _result: Date; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeDate2Text(_value: Date; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2Time(_value: Text; var _result: Time; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeTime2Text(_value: Time; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2DateTime(_value: Text; var _result: DateTime; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeDateTime2Text(_value: DateTime; var _result: Text; var _isHandled: Boolean);
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2Option(var _fldRef: FieldRef; _value: Text; var _result: Integer; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeOption2Text(var _fldRef: FieldRef; _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeOptionValue2Text(_fieldPos: Text; _value: Integer; var _result: Text; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeText2OptionValue(_fieldPos: Text; _value: Text; var _result: Integer; var _isHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeFldRefValue2Text(FldType: Integer; var FldRef: FieldRef; var TextValue: Text; var _isHandled: Boolean)
    begin
    end;
#endregion 
}
