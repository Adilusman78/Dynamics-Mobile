page 84024 DYM_CopySettings
{
    Caption = 'Copy Settings';
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Source)
            {
                field(sourceHierrarchyType; sourceHierrarchyType)
                {
                    Caption = 'Source Type';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        TargetHierrarchyType:=SourceHierrarchyType;
                    end;
                }
                field(sourceHierrarchyMember; sourceHierrarchyMember)
                {
                    Caption = 'Source Member';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean var
                        DeviceSetup: Record DYM_DeviceSetup;
                        DeviceGroup: Record DYM_DeviceGroup;
                        DeviceRole: Record DYM_DeviceRole;
                    begin
                        if(SourceHierrarchyType = Enum::DYM_HierarchyType::Role)then begin
                            if Page.RunModal(Page::DYM_DeviceRolesLookUp, DeviceRole) = Action::LookupOK then begin
                                SourceHierrarchyMember:=DeviceRole.Code;
                            end;
                        end;
                        if(SourceHierrarchyType = Enum::DYM_HierarchyType::Group)then begin
                            if Page.RunModal(Page::DYM_DeviceGroupsLookUp, DeviceGroup) = Action::LookupOK then begin
                                SourceHierrarchyMember:=DeviceGroup.Code;
                            end;
                        end;
                        if(SourceHierrarchyType = Enum::DYM_HierarchyType::Device)then begin
                            if Page.RunModal(Page::DYM_DeviceSetupsLookUp, DeviceSetup) = Action::LookupOK then begin
                                SourceHierrarchyMember:=DeviceSetup.Code;
                            end;
                        end;
                    end;
                }
            }
            group(Target)
            {
                field(targetHierrarchyType; targetHierrarchyType)
                {
                    Caption = 'Target Type';
                    ApplicationArea = All;
                }
                field(targetHierrarchyMember; targetHierrarchyMember)
                {
                    Caption = 'Target Member';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean var
                        DeviceSetup: Record DYM_DeviceSetup;
                        DeviceGroup: Record DYM_DeviceGroup;
                        DeviceRole: Record DYM_DeviceRole;
                    begin
                        case targetHierrarchyType of Enum::DYM_HierarchyType::Role: begin
                            if Page.RunModal(Page::DYM_DeviceRolesLookUp, DeviceRole) = Action::LookupOK then begin
                                targetHierrarchyMember:=DeviceRole.Code;
                            end;
                        end;
                        Enum::DYM_HierarchyType::Group: begin
                            if Page.RunModal(Page::DYM_DeviceGroupsLookUp, DeviceGroup) = Action::LookupOK then begin
                                targetHierrarchyMember:=DeviceGroup.Code;
                            end;
                        end;
                        Enum::DYM_HierarchyType::Device: begin
                            if Page.RunModal(Page::DYM_DeviceSetupsLookUp, DeviceSetup) = Action::LookupOK then begin
                                targetHierrarchyMember:=DeviceSetup.Code;
                            end;
                        end;
                        end;
                    end;
                }
            }
            group(Options)
            {
                field(CreateOnlyMissingSettings; CreateOnlyMissingSettings)
                {
                    Caption = 'Create missing only';
                    ApplicationArea = All;
                }
                field(CreateSettingWithouthValue; CreateSettingWithouthValue)
                {
                    Caption = 'Create without value';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("View copy settings")
            {
                Caption = 'View Settings';

                action("View Settings")
                {
                    ApplicationArea = All;
                    Caption = 'View settings';
                    Image = MachineCenter;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+G';

                    trigger OnAction()
                    begin
                        ViewSettingsForCopy();
                    end;
                }
            }
            group("Copy settings")
            {
                Caption = 'View Settings';

                action("Copy Setting")
                {
                    ApplicationArea = All;
                    Caption = 'Copy settings';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+G';

                    trigger OnAction()
                    begin
                        CopySettingsMgt.CopySettings(SourceHierrarchyType, SourceHierrarchyMember, TargetHierrarchyType, TargetHierrarchyMember, CreateSettingWithouthValue, CreateOnlyMissingSettings);
                    end;
                }
            }
        }
    }
    var CopySettingsMgt: Codeunit DYM_CopySettingsManagement;
    SourceHierrarchyMember, TargetHierrarchyMember: Text;
    SourceHierrarchyType, TargetHierrarchyType: Enum DYM_HierarchyType;
    CreateOnlyMissingSettings, CreateSettingWithouthValue: Boolean;
    Text001: Label 'There is no chosen type', Locked = true;
    Text002: Label 'There is no chosen member', Locked = true;
    local procedure ViewSettingsForCopy()
    var
        sourceSettingAssignment: Record DYM_SettingsAssignment;
    begin
        sourceSettingAssignment.Reset();
        if(sourceHierrarchyType = Enum::DYM_HierarchyType::" ")then Error(Text001);
        if(SourceHierrarchyMember = '')then Error(Text002);
        case sourceHierrarchyType of Enum::DYM_HierarchyType::Role: begin
            sourceSettingAssignment.SetRange("Device Role Code", sourceHierrarchyMember);
            sourceSettingAssignment.SetRange("Device Group Code", '');
            sourceSettingAssignment.SetRange("Device Setup Code", '');
        end;
        Enum::DYM_HierarchyType::Group: begin
            sourceSettingAssignment.SetRange("Device Group Code", sourceHierrarchyMember);
            sourceSettingAssignment.SetRange("Device Setup Code", '');
        end;
        Enum::DYM_HierarchyType::Device: sourceSettingAssignment.SetRange("Device Setup Code", sourceHierrarchyMember);
        end;
        page.RunModal(0, sourceSettingAssignment);
    end;
}
