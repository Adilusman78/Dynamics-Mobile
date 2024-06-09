codeunit 84019 DYM_SessionManagement
{
    trigger OnRun()
    begin
    end;
    var Text001: Label 'Do you want to delete the Session Value?';
    Text002: Label 'You can use the following Session Values in the filter string:\';
    Text003: Label '$%1 = %2\', Locked = true;
    SessionValuesCodes: Label '$DRC,$DGC,$DSC,$SPC,$SPN,$DML,$TDY,$WDT,$TIM,$BLC', Locked = true;
    SessionValuesText: Label '$001 - Device Role Code,$002 - Device Group Code,$003 - Device Setup Code,$004 - Salesperson Code,$005 - Salesperon Name,$006 - Device Mobile Location,$007 - Today,$008 - Work Date,$009 - Time,$010 - Base Location Code', Locked = true;
    MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    GenListMgt: Codeunit DYM_GenericListManagement;
    SetupRead: Boolean;
    SLE: Integer;
    #region Session Values
    local procedure GetDateTimeOffset()Result: Text var
        DateTimeFilter: Text;
        DateTimeOffset: Date;
        Offset: Integer;
    begin
        if(SettingsMgt.GetSetting(ConstMgt.BOS_DateTimeOffset()) = '')then Offset:=1;
        Offset:=LowLevelDP.Text2Integer(SettingsMgt.GetSetting(ConstMgt.BOS_DateTimeOffset()));
        DateTimeOffset:=Today - Offset;
        DateTimeFilter:=LowLevelDP.Date2Text(DateTimeOffset) + '..' + LowLevelDP.Date2Text(Today);
        exit(DateTimeFilter);
    end;
    local procedure GetDeliveryPersonCode()Result: Text begin
        exit(StrSubstNo('%1 | '''' ', DeviceSetup.Code));
    end;
    local procedure GetSalesOderHistoryDays()Result: Text;
    var
        DaysOffset: Integer;
    begin
        if(SettingsMgt.CheckSetting(ConstMgt.BOS_SalesOrderHistoryDays()))then begin
            DaysOffset:=LowLevelDP.Text2Integer(SettingsMgt.GetSetting(ConstMgt.BOS_SalesOrderHistoryDays()));
            exit(StrSubstNo('-%1D..Today', DaysOffset));
        end;
        exit('-1M..Today');
    end;
    procedure LookUpSessionValues(var SessionValueCode: Code[10])Result: Code[10]var
        SessionValues: Record DYM_SessionValues;
    begin
        Clear(Result);
        SessionValues.Reset;
        if not SessionValues.Get(SessionValueCode)then;
        if PAGE.RunModal(0, SessionValues) = ACTION::LookupOK then Result:=SessionValues.Code;
        if(Result <> '')then SessionValueCode:=Result
        else if(SessionValueCode <> '')then if Confirm(Text001, false)then Clear(SessionValueCode);
    end;
    procedure GetSessionValue(SessionValueCode: Code[10])Result: Text[250]var
        Salesperson: Record "Salesperson/Purchaser";
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        case SessionValueCode of ConstMgt.SES_DRC: exit(DeviceRole.Code);
        ConstMgt.SES_DGC: exit(DeviceGroup.Code);
        ConstMgt.SES_DSC: exit(DeviceSetup.Code);
        ConstMgt.SES_SPC: exit(DeviceSetup."Salesperson Code");
        ConstMgt.SES_SPN: if Salesperson.Get(DeviceSetup."Salesperson Code")then exit(Salesperson.Name);
        ConstMgt.SES_DML: exit(DeviceSetup."Mobile Location");
        ConstMgt.SES_TDY: exit(Format(Today));
        ConstMgt.SES_WDT: exit(Format(WorkDate));
        ConstMgt.SES_TIM: exit(Format(Time));
        ConstMgt.SES_BLC: exit(SettingsMgt.GetSetting(ConstMgt.BOS_BaseLocationFilter));
        ConstMgt.SES_DTO(): exit(GetDateTimeOffset());
        ConstMgt.SES_DPC(): exit(GetDeliveryPersonCode());
        ConstMgt.SES_SOH(): exit(GetSalesOderHistoryDays());
        end;
    end;
    procedure GetSessionValueDescription(SessionValueCode: Code[10])Result: Text[30]var
        SessionValues: Record DYM_SessionValues;
    begin
        Clear(Result);
        if SessionValues.Get(SessionValueCode)then exit(SessionValues.Description);
    end;
    procedure ApplySessionValuesCodes(InputString: Text[250])Result: Text[250]var
        i: Integer;
    begin
        Clear(Result);
        Result:=InputString;
        for i:=1 to LowLevelDP.GetSubStrCount(Result)do Result:=LowLevelDP.ReplaceSingleStr(Result, LowLevelDP.GetFilterValueMask(i), SelectStr(i, SessionValuesCodes));
    end;
    procedure ApplySessionValuesToFilter(var FilterString: Text[250])Result: Text[250]var
        SessionValues: Record DYM_SessionValues;
    begin
        Clear(Result);
        Result:=FilterString;
        SessionValues.Reset;
        if SessionValues.FindSet(false, false)then repeat Result:=LowLevelDP.ReplaceSingleStr(Result, ConstMgt.SES_Prefix + SessionValues.Code, GetSessionValue(SessionValues.Code));
            until SessionValues.Next = 0;
    end;
    procedure ShowSessionValuesHint()
    var
        SessionValues: Record DYM_SessionValues;
        SessionValuesHint: Text;
    begin
        Clear(SessionValuesHint);
        SessionValuesHint:=Text002;
        SessionValues.Reset;
        if SessionValues.FindSet(false, false)then repeat SessionValuesHint:=SessionValuesHint + StrSubstNo(Text003, SessionValues.Code, SessionValues.Description);
            until SessionValues.Next = 0;
        Message(SessionValuesHint);
    end;
    #endregion 
    #region Context
    procedure GetContextValue(TableName: Text[30]; "Key": Text[250])Result: Text[250]var
        SeparatorPos: Integer;
    begin
        Clear(Result);
        Clear(SeparatorPos);
        SeparatorPos:=StrPos(Key, '.');
        if(SeparatorPos <> 0)then begin
            TableName:=CopyStr(Key, 1, SeparatorPos - 1);
            Key:=CopyStr(Key, SeparatorPos + 1);
        end;
        exit(CacheMgt.GetTableNameFlag(TableName, Key));
    end;
    procedure ApplyContextValuesToFilter(var FilterString: Text[250])Result: Text[250]var
        ContextFilterFound: Boolean;
        ContextVariablePos: Integer;
        SeparatorPos: Integer;
        DelimiterPos: Integer;
        PreContext: Text[250];
        PostContext: Text[250];
        WorkText: Text[250];
        TableName: Text[30];
        FieldName: Text[30];
        CacheValue: Text[30];
    begin
        Clear(Result);
        Result:=FilterString;
        Clear(ContextFilterFound);
        repeat Clear(ContextVariablePos);
            Clear(SeparatorPos);
            Clear(DelimiterPos);
            Clear(PreContext);
            Clear(PostContext);
            Clear(WorkText);
            Clear(TableName);
            Clear(FieldName);
            Clear(CacheValue);
            ContextVariablePos:=StrPos(Result, ConstMgt.CTX_ContextVariable);
            ContextFilterFound:=ContextVariablePos <> 0;
            if ContextFilterFound then begin
                PreContext:=CopyStr(Result, 1, ContextVariablePos - 1);
                DelimiterPos:=StrPos(Result, ')');
                PostContext:=CopyStr(Result, DelimiterPos + 1);
                WorkText:=CopyStr(Result, ContextVariablePos + StrLen(ConstMgt.CTX_ContextVariable), DelimiterPos - StrLen(ConstMgt.CTX_ContextVariable) - 1);
                SeparatorPos:=StrPos(WorkText, '.');
                if(SeparatorPos > 2)then begin
                    TableName:=CopyStr(WorkText, 2, SeparatorPos - 2);
                    FieldName:=CopyStr(WorkText, SeparatorPos + 1, DelimiterPos - StrLen(PreContext) - StrLen(ConstMgt.CTX_ContextVariable) - SeparatorPos - 1);
                end;
                Result:=PreContext;
                if((TableName <> '') and (FieldName <> ''))then CacheValue:=CacheMgt.GetTableNameFlag(TableName, FieldName);
                if(CacheValue <> '')then Result+=CacheValue
                else
                    Result+='''''';
                Result+=PostContext;
            end;
        until not ContextFilterFound;
    end;
    #endregion 
    #region Settings
    procedure ApplySettingValuesToFilter(var FilterString: Text[250])Result: Text[250]var
        ContextFilterFound: Boolean;
        ContextVariablePos: Integer;
        DelimiterPos: Integer;
        PreContext: Text[250];
        PostContext: Text[250];
        WorkText: Text[250];
        SettingCode: Text[30];
        SettingValue: Text[30];
    begin
        Clear(Result);
        Result:=FilterString;
        Clear(ContextFilterFound);
        repeat Clear(ContextVariablePos);
            Clear(DelimiterPos);
            Clear(PreContext);
            Clear(PostContext);
            Clear(WorkText);
            Clear(SettingCode);
            Clear(SettingValue);
            ContextVariablePos:=StrPos(Result, ConstMgt.CTX_Setting);
            ContextFilterFound:=ContextVariablePos <> 0;
            if ContextFilterFound then begin
                PreContext:=CopyStr(Result, 1, ContextVariablePos - 1);
                DelimiterPos:=StrPos(Result, ')');
                PostContext:=CopyStr(Result, DelimiterPos + 1);
                SettingCode:=CopyStr(Result, ContextVariablePos + StrLen(ConstMgt.CTX_Setting) + 1, DelimiterPos - ContextVariablePos - StrLen(ConstMgt.CTX_Setting) - 1);
                Result:=PreContext;
                if(SettingCode <> '')then SettingValue:=SettingsMgt.GetSetting(SettingCode);
                if(SettingValue <> '')then Result+=SettingValue
                else
                    Result+='''''';
                Result+=PostContext;
            end;
        until not ContextFilterFound;
    end;
#endregion 
}
