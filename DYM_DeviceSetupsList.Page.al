page 84006 DYM_DeviceSetupsList
{
    Caption = 'Device Setups List';
    DelayedInsert = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Process,Device';
    SourceTable = DYM_DeviceSetup;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;

                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                }
                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Mobile Location"; Rec."Mobile Location")
                {
                    ApplicationArea = All;
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = All;
                }
                field("Device Role Type"; Rec."Device Role Type")
                {
                    ApplicationArea = all;
                }
                field(txtbox_PublishedSettings01; PublishedSettingsValues[1])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,1');
                    Editable = false;
                    Visible = PublishedSetting01Visible;
                }
                field(txtbox_PublishedSettings02; PublishedSettingsValues[2])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,2');
                    Editable = false;
                    Visible = PublishedSetting02Visible;
                }
                field(txtbox_PublishedSettings03; PublishedSettingsValues[3])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,3');
                    Editable = false;
                    Visible = PublishedSetting03Visible;
                }
                field(txtbox_PublishedSettings04; PublishedSettingsValues[4])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,4');
                    Editable = false;
                    Visible = PublishedSetting04Visible;
                }
                field(txtbox_PublishedSettings05; PublishedSettingsValues[5])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,5');
                    Editable = false;
                    Visible = PublishedSetting05Visible;
                }
                field(txtbox_PublishedSettings06; PublishedSettingsValues[6])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,6');
                    Editable = false;
                    Visible = PublishedSetting06Visible;
                }
                field(txtbox_PublishedSettings07; PublishedSettingsValues[7])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,7');
                    Editable = false;
                    Visible = PublishedSetting07Visible;
                }
                field(txtbox_PublishedSettings08; PublishedSettingsValues[8])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,8');
                    Editable = false;
                    Visible = PublishedSetting08Visible;
                }
                field(txtbox_PublishedSettings09; PublishedSettingsValues[9])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,9');
                    Editable = false;
                    Visible = PublishedSetting09Visible;
                }
                field(txtbox_PublishedSettings10; PublishedSettingsValues[10])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,10');
                    Editable = false;
                    Visible = PublishedSetting10Visible;
                }
                field(txtbox_PublishedSettings11; PublishedSettingsValues[11])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,11');
                    Editable = false;
                    Visible = PublishedSetting11Visible;
                }
                field(txtbox_PublishedSettings12; PublishedSettingsValues[12])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,12');
                    Editable = false;
                    Visible = PublishedSetting12Visible;
                }
                field(txtbox_PublishedSettings13; PublishedSettingsValues[13])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,13');
                    Editable = false;
                    Visible = PublishedSetting13Visible;
                }
                field(txtbox_PublishedSettings14; PublishedSettingsValues[14])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,14');
                    Editable = false;
                    Visible = PublishedSetting14Visible;
                }
                field(txtbox_PublishedSettings15; PublishedSettingsValues[15])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,15');
                    Editable = false;
                    Visible = PublishedSetting15Visible;
                }
                field(txtbox_PublishedSettings16; PublishedSettingsValues[16])
                {
                    ApplicationArea = All;
                    CaptionClass = SettingsMgt.GetSettingsCaptions('3,16');
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
            action("Expor&t Data")
            {
                ApplicationArea = All;
                Caption = 'Expor&t Data';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+T';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                    Rec.ForceSync(false);
                    CurrPage.Update(false);
                end;
            }
        }
        area(navigation)
        {
            action("<Action1103100005>")
            {
                ApplicationArea = All;
                Caption = '&Group';
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page DYM_DeviceGroupsList;
                RunPageLink = Code=FIELD("Device Group Code");
            }
            action("&Settings")
            {
                ApplicationArea = All;
                Caption = '&Settings';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+S';

                trigger OnAction()
                begin
                    Clear(SettingsMgt);
                    SettingsMgt.OpenSettings(Rec."Device Role Code", Rec."Device Group Code", Rec.Code);
                    PreloadPublishedSettings(Rec.Code);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if ShowPublishedSettings then begin
            //CacheMgt.SetContextByCodes ( "Device Role Code" , "Device Group Code" , Code ) ;
            //SettingsMgt.GetPublishedSettingsValues ( enum::DYM_SettingsPublishType::DYM_DeviceSetup , PublishedSettingsValues ) ;
            PreloadedSettings2Array;
        end;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if(Rec.GetFilter("Device Role Code") <> '')then Rec."Device Role Code":=Rec.GetRangeMin("Device Role Code");
        if(Rec.GetFilter("Device Group Code") <> '')then Rec."Device Group Code":=Rec.GetRangeMin("Device Group Code");
    end;
    trigger OnOpenPage()
    begin
        ShowPublishedSettings:=SetContextByFilters;
        if ShowPublishedSettings then begin
            PreloadPublishedSettings('');
            SettingsMgt.CheckPublishedSettingsCount(enum::DYM_SettingsPublishType::DYM_DeviceSetup, PublishedSettingsValues);
            SetVisibility;
        end;
    end;
    var SettingsMgt: Codeunit DYM_SettingsManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
    PublishedSettingsBuffer: Record DYM_CacheBuffer temporary;
    ShowPublishedSettings: Boolean;
    PublishedSettingsValues: array[16]of Text[100];
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
    procedure SetVisibility(): Boolean begin
        PublishedSetting01Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 1) <> '');
        PublishedSetting02Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 2) <> '');
        PublishedSetting03Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 3) <> '');
        PublishedSetting04Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 4) <> '');
        PublishedSetting05Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 5) <> '');
        PublishedSetting06Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 6) <> '');
        PublishedSetting07Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 7) <> '');
        PublishedSetting08Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 8) <> '');
        PublishedSetting09Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 9) <> '');
        PublishedSetting10Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 10) <> '');
        PublishedSetting11Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 11) <> '');
        PublishedSetting12Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 12) <> '');
        PublishedSetting13Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 13) <> '');
        PublishedSetting14Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 14) <> '');
        PublishedSetting15Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 15) <> '');
        PublishedSetting16Visible:=(SettingsMgt.GetPublishedSettingsCode(enum::DYM_SettingsPublishType::DYM_DeviceSetup, 16) <> '');
    end;
    procedure SetContextByFilters()Result: Boolean var
        DeviceRoleCode: Code[20];
    begin
        Clear(Result);
        Clear(DeviceRoleCode);
        if(Rec.GetFilter("Device Role Code") <> '')then begin
            DeviceRoleCode:=Rec.GetRangeMin("Device Role Code");
            Result:=true;
        end;
        CacheMgt.SetContextByCodes(DeviceRoleCode, '', '');
    end;
    procedure PreloadPublishedSettings(DeviceSetupCodeFilter: Code[100])
    var
        DeviceSetup: Record DYM_DeviceSetup;
        dlg: Dialog;
        i: Integer;
        OldFilterGroup: Integer;
        RecCount: Integer;
        OldPos: Integer;
        Pos: Decimal;
        Step: Decimal;
    begin
        PublishedSettingsBuffer.Reset;
        if(DeviceSetupCodeFilter <> '')then PublishedSettingsBuffer.SetRange("Record ID", DeviceSetupCodeFilter);
        PublishedSettingsBuffer.DeleteAll;
        Clear(RecCount);
        Clear(OldPos);
        Clear(Pos);
        Clear(Step);
        dlg.Open(Text001);
        DeviceSetup.Reset;
        DeviceSetup.CopyFilters(Rec);
        if(DeviceSetupCodeFilter <> '')then begin
            OldFilterGroup:=DeviceSetup.FilterGroup;
            DeviceSetup.FilterGroup(10);
            DeviceSetup.SetRange(Code, DeviceSetupCodeFilter);
            DeviceSetup.FilterGroup(OldFilterGroup);
        end;
        RecCount:=DeviceSetup.Count;
        if(RecCount <> 0)then Step:=10000 / RecCount;
        if DeviceSetup.FindSet(false, false)then repeat Pos+=Step;
                if(Round(Pos, 1) <> OldPos)then begin
                    OldPos:=Round(Pos, 1);
                    dlg.Update(1, OldPos);
                end;
                CacheMgt.SetContextByCodes(DeviceSetup."Device Role Code", DeviceSetup."Device Group Code", DeviceSetup.Code);
                SettingsMgt.GetPublishedSettingsValues(enum::DYM_SettingsPublishType::DYM_DeviceSetup, PublishedSettingsValues);
                for i:=1 to ArrayLen(PublishedSettingsValues)do begin
                    Clear(PublishedSettingsBuffer);
                    PublishedSettingsBuffer.Init;
                    PublishedSettingsBuffer."Record ID":=DeviceSetup.Code;
                    PublishedSettingsBuffer.Data:=PublishedSettingsValues[i];
                    PublishedSettingsBuffer."Field No.":=i;
                    PublishedSettingsBuffer.Insert;
                end;
            until DeviceSetup.Next = 0;
        dlg.Close;
    end;
    procedure PreloadedSettings2Array()
    var
        i: Integer;
    begin
        Clear(PublishedSettingsValues);
        for i:=1 to ArrayLen(PublishedSettingsValues)do if PublishedSettingsBuffer.Get(0, 0, '', i, 0, '', Rec.Code)then PublishedSettingsValues[i]:=PublishedSettingsBuffer.Data;
    end;
}
