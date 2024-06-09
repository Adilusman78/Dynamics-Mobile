codeunit 70101 DYM_AssistedSetup
{
    var
        Title: Label 'Set up connection to Dynamics Mobile Portal';
        ShortTitle: Label 'Connect to Dynamics Mobile Portal';
        Description: Label 'Connect to Dynamics Mobile Portal to enable mobile access to your data';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure OnRegisterAssistedSetup();
    var
        AssistedSetup: Codeunit "Guided Experience";
        ConstMgt: Codeunit DYM_ConstManagement;
    begin
        if AssistedSetup.Exists(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::DYM_AssistedSetupWizard) then AssistedSetup.Remove(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::DYM_AssistedSetupWizard);
        AssistedSetup.InsertAssistedSetup(Title, ShortTitle, Description, 1, ObjectType::Page, Page::DYM_AssistedSetupWizard, enum::"Assisted Setup Group"::Connect, ConstMgt.ASH_AssistedSetupEmbeddedVideoURL(), enum::"Video Category"::Connect, ConstMgt.ASH_AssistedSetupDocURL());
    end;
}
