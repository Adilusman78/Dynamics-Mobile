page 84030 DYM_AssistedSetupWizard
{
    Caption = 'Dynamics Mobile Assisted Setup Wizard';
    PageType = NavigatePage;
    SourceTable = DYM_DynamicsMobileSetup;
    SourceTableTemporary = true;

    //Wizard steps
    // 0 - Welcome
    // 1 - Environment checklist
    // 2 - Configuration
    // 3 - Confirmation
    layout
    {
        area(Content)
        {
            group(NotCompletedTopBanner)
            {
                Editable = false;
                ShowCaption = false;
                Visible = BannersAvailable and (not TestSuccessful);

                field(NotDoneIcon; MediaResourceNotCompleted."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(CompletedTopBanner)
            {
                Editable = false;
                ShowCaption = false;
                Visible = BannersAvailable and (WizardStep = 3) and (TestSuccessful);

                field(CompletedIcon; MediaResourceCompleted."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Welcome)
            {
                Visible = WizardStep = 0;
                Caption = '';
                InstructionalText = 'Welcome to Dynamics Mobile Assisted Setup Wizard.';

                label(WelcomePurpose)
                {
                    ApplicationArea = All;
                    CaptionClass = 'Here you can configure your connection to the Dynamics Mobile Portal. You will need your App Area Id and xAPI Key, which you can get from your area in Dynamics Mobile Portal.';
                }
                label(WelcomeHelp)
                {
                    ApplicationArea = All;
                    CaptionClass = 'If needed, please refer to the provided documentation and video. If you do not have them, please contact your Dynamics Mobile representative.';
                }
                field(VideoURL; VideoURLLabel)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(ConstMgt.ASH_AssistedSetupVideoURL());
                    end;
                }
                field(DocumentationURL; DocURLLabel)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        HyperLink(ConstMgt.ASH_AssistedSetupDocURL());
                    end;
                }
            }
            group(EnvironmentInfo)
            {
                Visible = WizardStep = 1;
                InstructionalText = 'Here you can see your environment information.';

                field(EnvType; EI_EnvType)
                {
                    ApplicationArea = All;
                    Caption = 'Environment Type';
                    Editable = false;
                    ToolTip = 'Your environment type';
                }
                field(EnvName; EI_EnvName)
                {
                    ApplicationArea = All;
                    Caption = 'Environment Name';
                    Editable = false;
                    Visible = EI_IsSaas;
                    ToolTip = 'Your environment name';
                }
                field(IsProduction; EI_IsProduction)
                {
                    ApplicationArea = All;
                    Caption = 'Is Production';
                    Editable = false;
                    Visible = EI_IsSaas;
                    ToolTip = 'Is your environment a production one.';
                }
                field(AzureADSetupl; EI_AzureADSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Azure AD Setup';
                    Editable = false;
                    ToolTip = 'Is your Azure AD setup';
                }
                field(AzureTenantId; EI_AzureTenantId)
                {
                    ApplicationArea = All;
                    Caption = 'Azure Tenant Id';
                    Editable = false;
                    Visible = EI_AzureADSetup;
                    ToolTip = 'Your Azure tenant id';
                }
                field(ODataPort; EI_ODataPort)
                {
                    ApplicationArea = All;
                    Caption = 'OData interface URL';
                    Editable = false;
                    ToolTip = 'Your OData interface URL';
                }
                field(CurrentCompanyName; EI_CurrentCompanyName)
                {
                    ApplicationArea = All;
                    Caption = 'Current Company Name';
                    Editable = false;
                    ToolTip = 'Your current company name';
                }
            }
            group(Configuration)
            {
                Visible = WizardStep = 2;
                InstructionalText = 'Please fill in the connection data to your Dynamics Mobile Portal account.';

                field(pfAppArea; F_AppArea)
                {
                    ApplicationArea = All;
                    Caption = 'App Area';
                    ToolTip = 'Enter your App Area Id';
                }
                field(pfxAPIKey; F_xAPIKey)
                {
                    ApplicationArea = All;
                    Caption = 'xAPI Key';
                    ToolTip = 'Enter your xAPI Key';
                }
            }
            group(Confirmation)
            {
                InstructionalText = 'You are almost done. Before you finish, you need to test your connection to Dynamics Mobile Portal.';
                Visible = WizardStep = 3;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = WizardStep > 0;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = WizardStep < 3;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(ActionTest)
            {
                ApplicationArea = All;
                Caption = 'Test';
                Visible = TestActionEnabled and (WizardStep = 3);
                Image = TestFile;
                InFooterBar = true;

                trigger OnAction();
                begin
                    TestAction();
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = TestSuccessful and (WizardStep = 3);
                Image = Approve;
                InFooterBar = true;

                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }
    var SettingsMgt: Codeunit DYM_SettingsManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    AssistedSetup: Codeunit "Guided Experience";
    MediaResourceNotCompleted, MediaResourceCompleted: Record "Media Resources";
    WizardStep: Integer;
    TestActionEnabled, FinishActionEnabled: Boolean;
    BannersAvailable, TestSuccessful, vsCompletedBanner: Boolean;
    EI_EnvType, EI_EnvName, EI_AzureTenantId, EI_ODataPort, EI_CurrentCompanyName: Text;
    EI_IsSaas, EI_IsProduction, EI_AzureADSetup: Boolean;
    F_AppArea: Text;
    F_xAPIKey: Text;
    ConfirmationHeaderMsg: Label 'You are about to save the following settings:\';
    ChangeSettingSubMsg: Label '\Change [%1]\------------------------------\[%2]\--->\[%3]\';
    ConfirmationFooterMsg: Label '\Do you want to continue?';
    NoChangeConfirmationMsg: Label 'You have made no changes to the settings. Do you want to continue?';
    ConnectionSuccessMsg: Label 'Connection successfull.';
    ConnectionFailedMsg: Label 'Connection failed:\%1';
    VideoURLLabel: Label 'Watch how to configure your Dynamics Mobile Portal account';
    DocURLLabel: Label 'Learn more about Dynamics Mobile configuration';
    EnvType_SaaS: Label 'SaaS';
    EnvType_OnPrem: Label 'On-Prem';
    trigger OnOpenPage()
    var
        EnvInfo: Codeunit "Environment Information";
        TenantInfo: Codeunit "Tenant Information";
        AzureInfo: Codeunit "Azure AD Tenant";
        AzureADMgt: Codeunit "Azure AD Mgt.";
        ServerSetting: Codeunit "Server Setting";
    begin
        LoadTopBanner();
        F_AppArea:=SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea());
        F_xAPIKey:=SettingsMgt.GetGlobalSetting(ConstMgt.CLD_xAPIKey());
        EI_IsSaas:=EnvInfo.IsSaaSInfrastructure();
        Clear(EI_EnvType);
        If EI_IsSaas then EI_EnvType:=EnvType_SaaS
        else
            EI_EnvType:=EnvType_OnPrem;
        if(EI_IsSaas)then begin
            Clear(EI_IsProduction);
            EI_IsProduction:=EnvInfo.IsProduction();
            Clear(EI_EnvName);
            EI_EnvName:=EnvInfo.GetEnvironmentName();
        end;
        clear(EI_AzureADSetup);
        EI_AzureADSetup:=AzureADMgt.IsAzureADAppSetupDone();
        Clear(EI_AzureTenantId);
        if(EI_AzureADSetup)then EI_AzureTenantId:=AzureInfo.GetAadTenantId();
        Clear(EI_ODataPort);
        EI_ODataPort:=GetUrl(ClientType::Api);
        Clear(EI_CurrentCompanyName);
        EI_CurrentCompanyName:=CompanyName();
    end;
    local procedure NextStep(Back: Boolean)
    begin
        case Back of true: begin
            WizardStep:=WizardStep - 1;
            clear(TestSuccessful);
        end;
        false: WizardStep:=WizardStep + 1;
        end;
        TestActionEnabled:=((WizardStep = 3) and (F_AppArea <> '') and (F_xAPIKey <> ''));
    //FinishActionEnabled := ((WizardStep = 2) and (TestSuccessful));
    end;
    local procedure TestAction(): Boolean var
        CloudMgt: Codeunit DYM_CloudManagement;
        ResultMsg: Text;
    begin
        Clear(ResultMsg);
        case CloudMgt.testConnection(F_AppArea, F_xAPIKey, ResultMsg)of true: begin
            Message(ConnectionSuccessMsg);
            TestSuccessful:=true;
            exit(true);
        end;
        false: begin
            Message(ConnectionFailedMsg, ResultMsg);
            TestSuccessful:=false;
            exit(false);
        end;
        end;
    end;
    local procedure FinishAction()
    var
        ConfirmationMessage: Text;
        UpdateAppArea: Boolean;
        UpdatexAPIKey: Boolean;
    begin
        Clear(ConfirmationMessage);
        UpdateAppArea:=((F_AppArea <> SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea())) and ((F_AppArea <> '')));
        UpdatexAPIKey:=((F_xAPIKey <> SettingsMgt.GetGlobalSetting(ConstMgt.CLD_xAPIKey())) and ((F_xAPIKey <> '')));
        if(UpdateAppArea or UpdatexAPIKey)then begin
            ConfirmationMessage:=ConfirmationMessage + ConfirmationHeaderMsg;
            if(UpdateAppArea)then ConfirmationMessage:=ConfirmationMessage + StrSubstNo(ChangeSettingSubMsg, 'App Area', SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea()), F_AppArea);
            if(UpdatexAPIKey)then ConfirmationMessage:=ConfirmationMessage + StrSubstNo(ChangeSettingSubMsg, 'xAPI Key', SettingsMgt.GetGlobalSetting(ConstMgt.CLD_xAPIKey()), F_xAPIKey);
            ConfirmationMessage:=ConfirmationMessage + ConfirmationFooterMsg;
        end
        else
            ConfirmationMessage:=NoChangeConfirmationMsg;
        if not Confirm(ConfirmationMessage, false)then exit;
        if UpdateAppArea then SettingsMgt.SetGlobalSetting(ConstMgt.CLD_AppArea(), F_AppArea);
        if UpdatexAPIKey then SettingsMgt.SetGlobalSetting(ConstMgt.CLD_xAPIKey(), F_xAPIKey);
        AssistedSetup.CompleteAssistedSetup(ObjectType::Page, Page::DYM_AssistedSetupWizard);
        CurrPage.Close();
    end;
    local procedure LoadTopBanner()
    begin
        if MediaResourceNotCompleted.Get('ASSISTEDSETUP-NOTEXT-400PX.PNG') and (CurrentClientType() = ClientType::Web)then BannersAvailable:=MediaResourceNotCompleted."Media Reference".HasValue();
        if MediaResourceCompleted.Get('ASSISTEDSETUPDONE-NOTEXT-400px.PNG') and (CurrentClientType() = ClientType::Web)then BannersAvailable:=MediaResourceCompleted."Media Reference".HasValue();
    end;
}
