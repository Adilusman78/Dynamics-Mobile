query 84001 DYM_DAO_CR_SettingsAssignment
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crSettingsAssignment';
    EntitySetName = 'crSettingsAssignments';

    elements
    {
    dataitem(SettingsAssignment;
    DYM_SettingsAssignment)
    {
    column(deviceRoleCode;
    "Device Role Code")
    {
    }
    column(deviceGroupCode;
    "Device Group Code")
    {
    }
    column(deviceSetupCode;
    "Device Setup Code")
    {
    }
    column("type";
    "Type")
    {
    }
    column("Code";
    "Code")
    {
    }
    column("value";
    "Value")
    {
    }
    }
    }
}
