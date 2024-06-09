codeunit 70109 DYM_CopySettingsManagement
{
    var
        UpdateCount, InsertCount : Integer;
        Text0001: Label 'Are you sure you want to copy settings from [%1] [%2] to [%3] [%4]? /There will be [%5] updates and [%6] creations', Locked = true;
        Text0002: Label 'There is no chosen source type', Locked = true;
        Text0003: Label 'There is no chosen target type', Locked = true;

    procedure CopySettings(SourceHierrarchyType: Enum DYM_HierarchyType; SourceHierrarchyMember: Text; TargetHierrarchyType: Enum DYM_HierarchyType; TargetHierrarchyMember: Text; CreateWithouthValue: Boolean; CreateOnlyMissingSetting: Boolean)
    var
        Process: Boolean;
        SourceSettingAssignment: Record DYM_SettingsAssignment;
        TargetSettingAssignment: Record DYM_SettingsAssignment;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        CalculateSettingsForCopy(sourceHierrarchyType, SourceHierrarchyMember, TargetHierrarchyType, TargetHierrarchyMember);
        Process := AskQuestionForCopy(sourceHierrarchyType, SourceHierrarchyMember, TargetHierrarchyType, TargetHierrarchyMember);
        if (Process) then begin
            SetHierarchyFilters(sourceHierrarchyType, sourceHierrarchyMember, SourceSettingAssignment);
            GetHierarchy(TargetHierrarchyType, TargetHierrarchyMember, DeviceRole, DeviceGroup, DeviceSetup);
            if (SourceSettingAssignment.FindSet()) then
                repeat
                    TargetSettingAssignment.Reset();
                    TargetSettingAssignment.SetRange("Device Role Code", DeviceRole.Code);
                    TargetSettingAssignment.SetRange("Device Group Code", DeviceGroup.Code);
                    TargetSettingAssignment.SetRange("Device Setup Code", DeviceSetup.Code);
                    TargetSettingAssignment.SetRange(Code, SourceSettingAssignment.Code);
                    if (TargetSettingAssignment.FindSet()) then begin
                        if not (CreateOnlyMissingSetting) then begin
                            TargetSettingAssignment.Validate(Value, SourceSettingAssignment.Value);
                            TargetSettingAssignment.Modify(true);
                        end;
                    end
                    else begin
                        TargetSettingAssignment.Reset();
                        if (DeviceRole.Code <> '') then TargetSettingAssignment.Validate("Device Role Code", DeviceRole.Code);
                        if (DeviceGroup.Code <> '') then TargetSettingAssignment.Validate("Device Group Code", DeviceGroup.Code);
                        if (DeviceSetup.Code <> '') then TargetSettingAssignment.Validate("Device Setup Code", DeviceSetup.Code);
                        TargetSettingAssignment.Validate(Type, SourceSettingAssignment.Type);
                        TargetSettingAssignment.Validate(Code, SourceSettingAssignment.Code);
                        if (CreateWithouthValue) then begin
                            TargetSettingAssignment.Validate(Value, '');
                        end
                        else begin
                            TargetSettingAssignment.Validate(Value, SourceSettingAssignment.Value);
                        end;
                        TargetSettingAssignment.Insert(true);
                    end;
                until SourceSettingAssignment.Next() = 0;
        end;
    end;

    local procedure AskQuestionForCopy(SourceHierrarchyType: Enum DYM_HierarchyType; SourceHierrarchyMember: Text; TargetHierrarchyType: Enum DYM_HierarchyType; TargetHierrarchyMember: Text): Boolean
    begin
        exit(Confirm(StrSubstNo(Text0001, SourceHierrarchyType, SourceHierrarchyMember, TargetHierrarchyType, TargetHierrarchyMember, UpdateCount, InsertCount), false));
    end;

    local procedure CalculateSettingsForCopy(sourceHierrarchyType: Enum DYM_HierarchyType; sourceHierrarchyMember: Text; targetHierrarchyType: Enum DYM_HierarchyType; targetHierrarchyMember: Text)
    var
        SourceSettingAssignment, TargetSettingAssignment : Record DYM_SettingsAssignment;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        SourceSettingAssignment.Reset();
        TargetSettingAssignment.Reset();
        Clear(UpdateCount);
        Clear(InsertCount);
        SetHierarchyFilters(sourceHierrarchyType, sourceHierrarchyMember, SourceSettingAssignment);
        GetHierarchy(targetHierrarchyType, targetHierrarchyMember, DeviceRole, DeviceGroup, DeviceSetup);
        if (SourceSettingAssignment.FindSet()) then
            repeat
                TargetSettingAssignment.Reset();
                TargetSettingAssignment.SetRange("Device Role Code", DeviceRole.Code);
                TargetSettingAssignment.SetRange("Device Group Code", DeviceGroup.Code);
                TargetSettingAssignment.SetRange("Device Setup Code", DeviceSetup.Code);
                TargetSettingAssignment.SetRange(Code, SourceSettingAssignment.Code);
                if not (TargetSettingAssignment.IsEmpty()) then begin
                    UpdateCount += 1;
                end
                else begin
                    InsertCount += 1;
                end;
            until SourceSettingAssignment.Next() = 0;
    end;

    local procedure GetHierarchy(HierrarchyType: Enum DYM_HierarchyType; HierarchyMember: Text; var DeviceRole: Record DYM_DeviceRole; var DeviceGroup: Record DYM_DeviceGroup; var DeviceSetup: Record DYM_DeviceSetup)
    begin
        case HierrarchyType of
            Enum::DYM_HierarchyType::" ":
                Error(Text0003);
            Enum::DYM_HierarchyType::Role:
                DeviceRole.Get(HierarchyMember);
            Enum::DYM_HierarchyType::Group:
                begin
                    DeviceGroup.Get(HierarchyMember);
                    DeviceRole.Get(DeviceGroup."Device Role Code");
                end;
            Enum::DYM_HierarchyType::Device:
                begin
                    DeviceSetup.Get(HierarchyMember);
                    DeviceGroup.Get(DeviceSetup."Device Group Code");
                    DeviceRole.Get(DeviceSetup."Device Role Code");
                end;
        end;
    end;

    local procedure SetHierarchyFilters(HierrarchyType: Enum DYM_HierarchyType; HierarchyMember: Text; var SettingAssignment: Record DYM_SettingsAssignment)
    begin
        case HierrarchyType of
            Enum::DYM_HierarchyType::" ":
                Error(Text0002);
            Enum::DYM_HierarchyType::Role:
                begin
                    SettingAssignment.SetRange("Device Role Code", HierarchyMember);
                    SettingAssignment.SetRange("Device Group Code", '');
                    SettingAssignment.SetRange("Device Setup Code", '');
                end;
            Enum::DYM_HierarchyType::Group:
                begin
                    SettingAssignment.SetRange("Device Group Code", HierarchyMember);
                    SettingAssignment.SetRange("Device Setup Code", '');
                end;
            Enum::DYM_HierarchyType::Device:
                begin
                    SettingAssignment.SetRange("Device Setup Code", HierarchyMember);
                end;
        end;
    end;
}
