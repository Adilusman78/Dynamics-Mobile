table 70112 DYM_IntegrityModuleInfo
{
    Caption = 'Integrity Module Info';

    fields
    {
        field(1; "App Id"; Guid)
        {
            DataClassification = SystemMetadata;
            Caption = 'App Id';
        }
        field(2; Name; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Name';
        }
        field(3; Publisher; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Publisher';
        }
    }
    keys
    {
        key(Key1; "App Id")
        {
        }
    }
}
