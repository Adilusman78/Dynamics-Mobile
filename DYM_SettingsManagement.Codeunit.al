codeunit 84020 DYM_SettingsManagement
{
    trigger OnRun()
    begin
        CheckOrphanMapping;
    end;
    var CacheMgt: Codeunit DYM_CacheManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    SLE: Integer;
    Text001: Label 'You must specify setting %1.';
    Text002: Label 'You have published more than %1 settings. Some settings will not be visible in the list.';
    SetupRead: Boolean;
    Text003: Label 'Do you want to delete the Setting Code?';
    procedure ImportDefaultData()
    var
        NAVmobileSetup: Record DYM_DynamicsMobileSetup;
        Ins: InStream;
        RecRef: RecordRef;
        RecText: Text[1024];
        TableCounter: Integer;
    begin
        NAVmobileSetup.Get;
        NAVmobileSetup.CalcFields("Default settings");
        if(not NAVmobileSetup."Default settings".HasValue)then exit;
        NAVmobileSetup."Default settings".CreateInStream(Ins, TextEncoding::UTF8);
        Clear(TableCounter);
        TableCounter+=1;
        while not Ins.EOS do begin
            Ins.ReadText(RecText);
            if(StrLen(RecText) = 0)then begin
                TableCounter+=1;
                RecRef.Close;
                case TableCounter of 2: RecRef.Open(DATABASE::DYM_DynamicsMobileSetup);
                3: RecRef.Open(DATABASE::DYM_MobileTableMap);
                4: RecRef.Open(DATABASE::DYM_MobileFieldMap);
                5: RecRef.Open(DATABASE::DYM_MobileTableMapFilters);
                6: RecRef.Open(DATABASE::DYM_DeviceRole);
                7: RecRef.Open(DATABASE::DYM_DeviceGroup);
                8: RecRef.Open(DATABASE::DYM_DeviceSetup);
                end;
            end
            else if(TableCounter > 1)then begin
                    LowLevelDP.Text2RecordRef(RecText, RecRef);
                end;
        end;
        NAVmobileSetup.Get;
        NAVmobileSetup."Dynamics Mobile initialized":=true;
        NAVmobileSetup.Modify;
        Commit;
    end;
    procedure CheckOrphanMapping()
    var
        TableMap: Record DYM_MobileTableMap;
        FieldMap: Record DYM_MobileFieldMap;
        FieldMapBuffer: Record DYM_MobileFieldMap temporary;
    begin
        FieldMapBuffer.Reset;
        FieldMapBuffer.DeleteAll;
        FieldMap.Reset;
        if FieldMap.FindSet(false, false)then repeat FieldMapBuffer.Init;
                FieldMapBuffer.Copy(FieldMap);
                FieldMapBuffer.Insert;
            until FieldMap.Next = 0;
        TableMap.Reset;
        if TableMap.FindSet(false, false)then repeat FieldMap.Reset;
                FieldMap.SetRange("Device Role Code", TableMap."Device Role Code");
                FieldMap.SetRange("Table No.", TableMap."Table No.");
                FieldMap.SetRange("Table Index", TableMap.Index);
                if FieldMap.FindSet(false, false)then repeat if FieldMapBuffer.Get(FieldMap."Device Role Code", FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index")then FieldMapBuffer.Delete;
                    until FieldMap.Next = 0;
            until TableMap.Next = 0;
        FieldMapBuffer.Reset;
        PAGE.RunModal(0, FieldMapBuffer);
    end;
    procedure OpenSettings(DeviceRoleCode: Code[20]; DeviceGroupCode: Code[20]; DeviceSetupCode: Code[100])
    var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        CacheMgt.SetContextByCodes(DeviceRoleCode, DeviceGroupCode, DeviceSetupCode);
        SettingsAssignment.Reset;
        SettingsAssignment.SetRange("Device Role Code", DeviceRoleCode);
        SettingsAssignment.SetRange("Device Group Code", DeviceGroupCode);
        SettingsAssignment.SetRange("Device Setup Code", DeviceSetupCode);
        PAGE.RunModal(0, SettingsAssignment);
    end;
    procedure CheckSetting(SettingCode: Text[50])Result: Boolean var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        Clear(Result);
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        SettingsAssignment.Reset;
        SettingsAssignment.SetRange("Device Role Code", DeviceRole.Code);
        SettingsAssignment.SetRange("Device Group Code", DeviceGroup.Code);
        SettingsAssignment.SetRange("Device Setup Code", DeviceSetup.Code);
        SettingsAssignment.SetRange(Type, enum::DYM_SettingsType::"BackOffice Setting");
        SettingsAssignment.SetRange(Code, SettingCode);
        if not SettingsAssignment.IsEmpty then exit(true);
        SettingsAssignment.SetRange("Device Setup Code", '');
        if not SettingsAssignment.IsEmpty then exit(true);
        SettingsAssignment.SetRange("Device Group Code", '');
        if not SettingsAssignment.IsEmpty then exit(true);
        SettingsAssignment.SetRange("Device Role Code", '');
        if not SettingsAssignment.IsEmpty then exit(true);
    end;
    procedure TestSetting(SettingCode: Text[50])
    var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        if not CheckSetting(SettingCode)then begin
            if(DeviceSetup.Code <> '')then Error(ConstMgt.MSG_0021, enum::DYM_SettingsType::"BackOffice Setting", SettingCode, DeviceRole.Code, DeviceGroup.Code, DeviceSetup.Code);
            if(DeviceGroup.Code <> '')then Error(ConstMgt.MSG_0022, enum::DYM_SettingsType::"BackOffice Setting", SettingCode, DeviceRole.Code, DeviceGroup.Code);
            Error(ConstMgt.MSG_0023, enum::DYM_SettingsType::"BackOffice Setting", SettingCode, DeviceRole.Code);
        end;
    end;
    procedure GetSetting(SettingCode: Text[50])Result: Text[100]var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        Clear(Result);
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        SettingsAssignment.Reset;
        SettingsAssignment.SetRange("Device Role Code", DeviceRole.Code);
        SettingsAssignment.SetRange("Device Group Code", DeviceGroup.Code);
        SettingsAssignment.SetRange("Device Setup Code", DeviceSetup.Code);
        SettingsAssignment.SetRange(Type, enum::DYM_SettingsType::"BackOffice Setting");
        SettingsAssignment.SetRange(Code, SettingCode);
        if SettingsAssignment.FindFirst then exit(SettingsAssignment.Value);
        SettingsAssignment.SetRange("Device Setup Code", '');
        if SettingsAssignment.FindFirst then exit(SettingsAssignment.Value);
        SettingsAssignment.SetRange("Device Group Code", '');
        if SettingsAssignment.FindFirst then exit(SettingsAssignment.Value);
        SettingsAssignment.SetRange("Device Role Code", '');
        if SettingsAssignment.FindFirst then exit(SettingsAssignment.Value);
    end;
    procedure CheckGlobalSetting(SettingCode: Text[50])Result: Boolean var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        CLEAR(Result);
        SettingsAssignment.RESET;
        SettingsAssignment.SETRANGE("Device Role Code", '');
        SettingsAssignment.SETRANGE("Device Group Code", '');
        SettingsAssignment.SETRANGE("Device Setup Code", '');
        SettingsAssignment.SETRANGE(Type, enum::DYM_SettingsType::"BackOffice Setting");
        SettingsAssignment.SETRANGE(Code, SettingCode);
        EXIT(NOT SettingsAssignment.ISEMPTY);
    end;
    procedure TestGlobalSetting(SettingCode: Text[50])
    begin
        IF NOT CheckGlobalSetting(SettingCode)THEN ERROR(ConstMgt.MSG_0023, enum::DYM_SettingsType::"BackOffice Setting", SettingCode, DeviceRole.Code);
    end;
    procedure GetGlobalSetting(SettingCode: Text[50])Result: Text[100]var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        CLEAR(Result);
        SettingsAssignment.RESET;
        SettingsAssignment.SETRANGE("Device Role Code", '');
        SettingsAssignment.SETRANGE("Device Group Code", '');
        SettingsAssignment.SETRANGE("Device Setup Code", '');
        SettingsAssignment.SETRANGE(Type, enum::DYM_SettingsType::"BackOffice Setting");
        SettingsAssignment.SETRANGE(Code, SettingCode);
        IF SettingsAssignment.FINDFIRST THEN EXIT(SettingsAssignment.Value);
    end;
    procedure GetGlobalSetting(SettingCode: Text[50]; UseDefaults: Boolean)Result: Text[100]var
        ConstMgt: Codeunit DYM_ConstManagement;
    begin
        Clear(Result);
        Result:=GetGlobalSetting(SettingCode);
        if(Result = '')then begin
            case SettingCode of ConstMgt.CLD_APIURL(): Result:=ConstMgt.DSV_cloud_APIURL();
            ConstMgt.CLD_URL_fetchPacketsLink(): Result:=ConstMgt.DSV_cloud_URL_fetchPacketsLink();
            end;
        end;
    end;
    procedure SetGlobalSetting(SettingCode: Text[50]; SettingValue: Text[100])
    var
        SettingsAssignment: Record DYM_SettingsAssignment;
    begin
        SettingsAssignment.RESET;
        SettingsAssignment.SETRANGE("Device Role Code", '');
        SettingsAssignment.SETRANGE("Device Group Code", '');
        SettingsAssignment.SETRANGE("Device Setup Code", '');
        SettingsAssignment.SETRANGE(Type, enum::DYM_SettingsType::"BackOffice Setting");
        SettingsAssignment.SETRANGE(Code, SettingCode);
        IF not SettingsAssignment.FINDFIRST THEN begin
            SettingsAssignment.Init();
            SettingsAssignment.Validate("Device Role Code", '');
            SettingsAssignment.Validate("Device Group Code", '');
            SettingsAssignment.Validate("Device Setup Code", '');
            SettingsAssignment.Validate(Type, enum::DYM_SettingsType::"BackOffice Setting");
            SettingsAssignment.Validate(Code, SettingCode);
            SettingsAssignment.Insert();
        end;
        SettingsAssignment.Validate(Value, SettingValue);
        SettingsAssignment.Modify();
    end;
    #region Published Settings
    procedure GetPublishedSettingsCodes(PublishedTo: enum DYM_SettingsPublishType; var PublishedSettingsCodes: array[16]of Text[50])
    var
        Settings: Record DYM_Settings;
        PublishedPos: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(PublishedSettingsCodes);
        Clear(PublishedPos);
        Settings.Reset;
        Settings.SetRange("Publish to", PublishedTo);
        if((PublishedTo <> enum::DYM_SettingsPublishType::DYM_DeviceRole) and (DeviceRole.Code <> ''))then Settings.SetRange("Applies-to Device Role", DeviceRole.Code);
        if Settings.FindSet(false, false)then repeat PublishedPos+=1;
                if(PublishedPos <= ArrayLen(PublishedSettingsCodes))then PublishedSettingsCodes[PublishedPos]:=Settings.Code;
            until Settings.Next = 0;
    end;
    procedure GetPublishedSettingsCode(PublishedTo: enum DYM_SettingsPublishType; PublishedPos: Integer): Text[50]var
        Settings: Record DYM_Settings;
        PublishedSettingsCodes: array[16]of Text[50];
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(PublishedSettingsCodes);
        GetPublishedSettingsCodes(PublishedTo, PublishedSettingsCodes);
        if(PublishedPos in[1 .. ArrayLen(PublishedSettingsCodes)])then exit(PublishedSettingsCodes[PublishedPos]);
    end;
    procedure GetPublishedSettingsValues(PublishedTo: enum DYM_SettingsPublishType; var PublishedSettingsValues: array[16]of Text[100])
    var
        Settings: Record DYM_Settings;
        PublishedPos: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(PublishedSettingsValues);
        Clear(PublishedPos);
        Settings.Reset;
        Settings.SetRange("Publish to", PublishedTo);
        if((PublishedTo <> enum::DYM_SettingsPublishType::DYM_DeviceRole) and (DeviceRole.Code <> ''))then Settings.SetRange("Applies-to Device Role", DeviceRole.Code);
        if Settings.FindSet(false, false)then repeat PublishedPos+=1;
                if(PublishedPos <= ArrayLen(PublishedSettingsValues))then begin
                    if CheckSetting(Settings.Code)then begin
                        PublishedSettingsValues[PublishedPos]:=GetSetting(Settings.Code);
                        if(PublishedSettingsValues[PublishedPos] = '')then PublishedSettingsValues[PublishedPos]:=ConstMgt.SPV_NoValue;
                    end;
                end;
            until Settings.Next = 0;
    end;
    procedure GetSettingsCaptions(CaptionExpr: Text[80])Result: Text[1024]var
        SettingsMgt: Codeunit DYM_SettingsManagement;
        PublishedToText: Text[80];
        PublishedPosText: Text[80];
        CommaPosition: Integer;
        PublishedTo: enum DYM_SettingsPublishType;
        PublishedPos: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(Result);
        CommaPosition:=StrPos(CaptionExpr, ',');
        if(CommaPosition > 0)then begin
            PublishedToText:=CopyStr(CaptionExpr, 1, CommaPosition - 1);
            PublishedPosText:=CopyStr(CaptionExpr, CommaPosition + 1);
            if not Evaluate(PublishedTo, PublishedToText)then Clear(PublishedTo);
            if not Evaluate(PublishedPos, PublishedPosText)then Clear(PublishedPos);
            if((PublishedTo <> PublishedTo::None) and (PublishedPos <> 0))then exit(SettingsMgt.GetPublishedSettingsCode(PublishedTo, PublishedPos));
        end;
        exit('');
    end;
    procedure CheckPublishedSettingsCount(PublishedTo: enum DYM_SettingsPublishType; var PublishedSettingsValues: array[16]of Text[100])
    var
        Settings: Record DYM_Settings;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Settings.Reset;
        Settings.SetRange("Publish to", PublishedTo);
        if((PublishedTo <> enum::DYM_SettingsPublishType::DYM_DeviceRole) and (DeviceRole.Code <> ''))then Settings.SetRange("Applies-to Device Role", DeviceRole.Code);
        if(Settings.Count > ArrayLen(PublishedSettingsValues))then Message(Text002, ArrayLen(PublishedSettingsValues));
    end;
    #endregion 
    #region LookUp Settings
    procedure LookUpSettingCode(SettingType: enum DYM_SettingsType; var SettingCode: Text[50])
    var
        Settings: Record DYM_Settings;
        SelectedSettingCode: Text[50];
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(SelectedSettingCode);
        Settings.Reset;
        Settings.SetRange(Type, SettingType);
        if(DeviceRole.Code <> '')then Settings.SetRange("Applies-to Device Role", DeviceRole.Code);
        if(SettingCode <> '')then begin
            Settings.SetRange(Code, SettingCode);
            if Settings.FindFirst then;
            Settings.SetRange(Code);
        end;
        if PAGE.RunModal(0, Settings) = ACTION::LookupOK then SelectedSettingCode:=Settings.Code;
        if(SelectedSettingCode <> '')then SettingCode:=SelectedSettingCode
        else if(SettingCode <> '')then if Confirm(Text003, false)then Clear(SettingCode);
    end;
#endregion 
}
