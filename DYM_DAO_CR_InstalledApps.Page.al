page 84022 DYM_DAO_CR_InstalledApps
{
    PageType = API;
    Caption = 'DAOSyncLogEntries';
    Editable = false;
    SourceTable = "NAV App Installed App";
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crInstalledApp';
    EntitySetName = 'crInstalledApps';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field(appId; Rec."App ID")
                {
                }
                field(name; Rec.Name)
                {
                }
                field(publishedAs; Rec."Published As")
                {
                }
                field(publisher; Rec.Publisher)
                {
                }
                field(version; format(AppVersion))
                {
                }
                field(integral;not IsNullGuid(IntegrityModuleInfo."App Id"))
                {
                }
            }
        }
    }
    var IntegrityModuleInfo: Record DYM_IntegrityModuleInfo;
    AppVersion: Version;
    trigger OnAfterGetRecord()
    begin
        AppVersion:=Version.Create(Rec."Version Major", Rec."Version Minor", Rec."Version Build", Rec."Version Revision");
        if not IntegrityModuleInfo.Get(Rec."App ID")then clear(IntegrityModuleInfo);
    end;
}
