page 70135 DYM_DeviceRolesList
{
    Caption = 'Device Roles List';
    PageType = List;
    SourceTable = DYM_DeviceRole;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1103100000)
            {
                ShowCaption = false;

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("NAV Processing Codeunit"; Rec."NAV Processing Codeunit")
                {
                    ApplicationArea = All;
                }
                field("NAV Proc. Codeunit Name"; Rec."NAV Proc. Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(txtbox_PublishedSettings01; PublishedSettingsValues[1])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,1');
                    Editable = false;
                    Visible = PublishedSetting01Visible;
                }
                field(txtbox_PublishedSettings02; PublishedSettingsValues[2])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,2');
                    Editable = false;
                    Visible = PublishedSetting02Visible;
                }
                field(txtbox_PublishedSettings03; PublishedSettingsValues[3])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,3');
                    Editable = false;
                    Visible = PublishedSetting03Visible;
                }
                field(txtbox_PublishedSettings04; PublishedSettingsValues[4])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,4');
                    Editable = false;
                    Visible = PublishedSetting04Visible;
                }
                field(txtbox_PublishedSettings05; PublishedSettingsValues[5])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,5');
                    Editable = false;
                    Visible = PublishedSetting05Visible;
                }
                field(txtbox_PublishedSettings06; PublishedSettingsValues[6])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,6');
                    Editable = false;
                    Visible = PublishedSetting06Visible;
                }
                field(txtbox_PublishedSettings07; PublishedSettingsValues[7])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,7');
                    Editable = false;
                    Visible = PublishedSetting07Visible;
                }
                field(txtbox_PublishedSettings08; PublishedSettingsValues[8])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,8');
                    Editable = false;
                    Visible = PublishedSetting08Visible;
                }
                field(txtbox_PublishedSettings09; PublishedSettingsValues[9])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,9');
                    Editable = false;
                    Visible = PublishedSetting09Visible;
                }
                field(txtbox_PublishedSettings10; PublishedSettingsValues[10])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,10');
                    Editable = false;
                    Visible = PublishedSetting10Visible;
                }
                field(txtbox_PublishedSettings11; PublishedSettingsValues[11])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,11');
                    Editable = false;
                    Visible = PublishedSetting11Visible;
                }
                field(txtbox_PublishedSettings12; PublishedSettingsValues[12])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,12');
                    Editable = false;
                    Visible = PublishedSetting12Visible;
                }
                field(txtbox_PublishedSettings13; PublishedSettingsValues[13])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,13');
                    Editable = false;
                    Visible = PublishedSetting13Visible;
                }
                field(txtbox_PublishedSettings14; PublishedSettingsValues[14])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,14');
                    Editable = false;
                    Visible = PublishedSetting14Visible;
                }
                field(txtbox_PublishedSettings15; PublishedSettingsValues[15])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,15');
                    Editable = false;
                    Visible = PublishedSetting15Visible;
                }
                field(txtbox_PublishedSettings16; PublishedSettingsValues[16])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('1,16');
                    Editable = false;
                    Visible = PublishedSetting16Visible;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';

                action("Device &Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Device &Groups';
                    Image = ExplodeBOM;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page DYM_DeviceGroupsList;
                    RunPageLink = "Device Role Code" = FIELD(Code);
                    ShortCutKey = 'Ctrl+G';
                }
                action("&Table Map")
                {
                    ApplicationArea = All;
                    Caption = '&Table Map';
                    Image = BOMVersions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page DYM_MobileTableMappingList;
                    RunPageLink = "Device Role Code" = FIELD(Code), "Parent Table No." = CONST(0);
                    ShortCutKey = 'Ctrl+T';
                }
                action("&Settings")
                {
                    ApplicationArea = All;
                    Caption = '&Settings';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+S';

                    trigger OnAction()
                    begin
                        Clear(SettingsMgt);
                        SettingsMgt.OpenSettings(Rec.Code, '', '');
                        PreloadPublishedSettings(Rec.Code);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //CacheMgt.SetContextByCodes ( Code , '' , '' ) ;
        //SettingsMgt.GetPublishedSettingsValues ( enum::DYM_SettingsPublishType::DYM_DeviceRole , PublishedSettingsValues ) ;
        PreloadedSettings2Array;
    end;

    trigger OnOpenPage()
    begin
        CacheMgt.SetContextByCodes('', '', '');
        PreloadPublishedSettings('');
        SettingsMgt.CheckPublishedSettingsCount(enum::DYM_SettingsPublishType::DYM_DeviceRole, PublishedSettingsValues);
        SetVisibility;
    end;

    var
        SettingsMgt: Codeunit DYM_SettingsManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        CacheMgt: Codeunit DYM_CacheManagement;
        PublishedSettingsBuffer: Record DYM_CacheBuffer temporary;
        PublishedSettingsValues: array[16] of Text[100];
        [InDataSet]
        PublishedSetting01Visible: Boolean;
        [InDataSet]
        PublishedSetting02Visible: Boolean;
        [InDataSet]
        PublishedSetting03Visible: Boolean;
        [InDataSet]
        PublishedSetting04Visible: Boolean;
        [InDataSet]
        PublishedSetting05Visible: Boolean;
        [InDataSet]
        PublishedSetting06Visible: Boolean;
        [InDataSet]
        PublishedSetting07Visible: Boolean;
        [InDataSet]
        PublishedSetting08Visible: Boolean;
        [InDataSet]
        PublishedSetting09Visible: Boolean;
        [InDataSet]
        PublishedSetting10Visible: Boolean;
        [InDataSet]
        PublishedSetting11Visible: Boolean;
        [InDataSet]
        PublishedSetting12Visible: Boolean;
        [InDataSet]
        PublishedSetting13Visible: Boolean;
        [InDataSet]
        PublishedSetting14Visible: Boolean;
        [InDataSet]
        PublishedSetting15Visible: Boolean;
        [InDataSet]
        PublishedSetting16Visible: Boolean;
        Text001: Label 'Preloading settings @1@@@@@@@@@@@@', Locked = true;

    procedure SetVisibility(): Boolean
    begin
        PublishedSetting01Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 1) <> '');
        PublishedSetting02Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 2) <> '');
        PublishedSetting03Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 3) <> '');
        PublishedSetting04Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 4) <> '');
        PublishedSetting05Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 5) <> '');
        PublishedSetting06Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 6) <> '');
        PublishedSetting07Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 7) <> '');
        PublishedSetting08Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 8) <> '');
        PublishedSetting09Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 9) <> '');
        PublishedSetting10Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 10) <> '');
        PublishedSetting11Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 11) <> '');
        PublishedSetting12Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 12) <> '');
        PublishedSetting13Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 13) <> '');
        PublishedSetting14Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 14) <> '');
        PublishedSetting15Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 15) <> '');
        PublishedSetting16Visible := (SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceRole, 16) <> '');
    end;

    procedure PreloadPublishedSettings(DeviceRoleCodeFilter: Code[20])
    var
        DeviceRole: Record DYM_DeviceRole;
        dlg: Dialog;
        i: Integer;
        OldFilterGroup: Integer;
        RecCount: Integer;
        OldPos: Integer;
        Pos: Decimal;
        Step: Decimal;
    begin
        PublishedSettingsBuffer.Reset;
        if (DeviceRoleCodeFilter <> '') then PublishedSettingsBuffer.SetRange("Record ID", DeviceRoleCodeFilter);
        PublishedSettingsBuffer.DeleteAll;
        Clear(RecCount);
        Clear(OldPos);
        Clear(Pos);
        Clear(Step);
        dlg.Open(Text001);
        DeviceRole.Reset;
        DeviceRole.CopyFilters(Rec);
        if (DeviceRoleCodeFilter <> '') then begin
            OldFilterGroup := DeviceRole.FilterGroup;
            DeviceRole.FilterGroup(10);
            DeviceRole.SetRange(Code, DeviceRoleCodeFilter);
            DeviceRole.FilterGroup(OldFilterGroup);
        end;
        RecCount := DeviceRole.Count;
        if (RecCount <> 0) then Step := 10000 / RecCount;
        if DeviceRole.FindSet(false, false) then
            repeat
                Pos += Step;
                if (Round(Pos, 1) <> OldPos) then begin
                    OldPos := Round(Pos, 1);
                    dlg.Update(1, OldPos);
                end;
                CacheMgt.SetContextByCodes(DeviceRole.Code, '', '');
                SettingsMgt.GetPublishedSettingsValues(enum::DYM_SettingsPublishType::DYM_DeviceRole, PublishedSettingsValues);
                for i := 1 to ArrayLen(PublishedSettingsValues) do begin
                    Clear(PublishedSettingsBuffer);
                    PublishedSettingsBuffer.Init;
                    PublishedSettingsBuffer."Record ID" := DeviceRole.Code;
                    PublishedSettingsBuffer.Data := PublishedSettingsValues[i];
                    PublishedSettingsBuffer."Field No." := i;
                    PublishedSettingsBuffer.Insert;
                end;
            until DeviceRole.Next = 0;
        dlg.Close;
    end;

    procedure PreloadedSettings2Array()
    var
        i: Integer;
    begin
        Clear(PublishedSettingsValues);
        for i := 1 to ArrayLen(PublishedSettingsValues) do if PublishedSettingsBuffer.Get(0, 0, '', i, 0, '', Rec.Code) then PublishedSettingsValues[i] := PublishedSettingsBuffer.Data;
    end;
}
