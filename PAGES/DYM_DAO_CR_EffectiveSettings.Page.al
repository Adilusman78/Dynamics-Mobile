page 70107 DYM_DAO_CR_EffectiveSettings
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crEffectiveSetting';
    EntitySetName = 'crEffectiveSettings';
    SourceTable = DYM_SettingsAssignment;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(deviceRoleCode; Rec."Device Role Code")
                {
                }
                field(deviceGroupCode; Rec."Device Group Code")
                {
                }
                field(deviceSetupCode; Rec."Device Setup Code")
                {
                }
                field("type"; Rec."Type")
                {
                }
                field("code"; Rec.Code)
                {
                }
                field("value"; Rec."Value")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        SettingsAss: Record DYM_SettingsAssignment;
        DeviceSetup: Record DYM_DeviceSetup;
        FiltersBackup: Record DYM_SettingsAssignment temporary;
    begin
        FiltersBackup.Reset;
        FiltersBackup.CopyFilters(Rec);
        If Rec.IsTemporary then begin
            Rec.Reset;
            Rec.DeleteAll();
        end;
        DeviceSetup.Reset;
        If DeviceSetup.FindSet(False, False) then
            repeat //Global settings are not used in device hierarchy context
                //Transfer Device Settings
                SettingsAss.Reset;
                SettingsAss.SetRange("Type", SettingsAss."Type"::"BackOffice Setting");
                SettingsAss.SetRange("Device Role Code", DeviceSetup."Device Role Code");
                SettingsAss.SetRange("Device Group Code", DeviceSetup."Device Group Code");
                SettingsAss.SetRange("Device Setup Code", DeviceSetup."Code");
                AddMissingSA2RecSet(DeviceSetup, SettingsAss, Rec);
                //Transfer Group Settings
                SettingsAss.SetRange("Device Setup Code", '');
                AddMissingSA2RecSet(DeviceSetup, SettingsAss, Rec);
                //Transfer Role Settings
                SettingsAss.SetRange("Device Group Code", '');
                AddMissingSA2RecSet(DeviceSetup, SettingsAss, Rec);
            until DeviceSetup.Next = 0;
        Rec.Reset;
        Rec.CopyFilters(FiltersBackup);
    end;

    procedure AddMissingSA2RecSet(var _DeviceSetup: Record DYM_DeviceSetup; var _FromSettingsAss: Record DYM_SettingsAssignment; var _ToSettingsAss: Record DYM_SettingsAssignment)
    begin
        if _FromSettingsAss.FindSet(False, False) then
            repeat
                _ToSettingsAss.Reset;
                _ToSettingsAss.SetRange("Device Role Code", _DeviceSetup."Device Role Code");
                _ToSettingsAss.SetRange("Device Group Code", _DeviceSetup."Device Group Code");
                _ToSettingsAss.SetRange("Device Setup Code", _DeviceSetup."Code");
                _ToSettingsAss.SetRange("Type", _FromSettingsAss."Type");
                _ToSettingsAss.SetRange("Code", _FromSettingsAss."Code");
                If _ToSettingsAss.IsEmpty then begin
                    Clear(_ToSettingsAss);
                    _ToSettingsAss.Init;
                    _ToSettingsAss."Device Role Code" := _DeviceSetup."Device Role Code";
                    _ToSettingsAss."Device Group Code" := _DeviceSetup."Device Group Code";
                    _ToSettingsAss."Device Setup Code" := _DeviceSetup."Code";
                    _ToSettingsAss."Type" := _FromSettingsAss."Type";
                    _ToSettingsAss."Code" := _FromSettingsAss."Code";
                    _ToSettingsAss."Value" := _FromSettingsAss."Value";
                    _ToSettingsAss.Insert();
                end;
            until _FromSettingsAss.Next = 0;
    end;
}
