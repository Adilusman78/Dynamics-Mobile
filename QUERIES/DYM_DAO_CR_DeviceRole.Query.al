query 70121 DYM_DAO_CR_DeviceRole
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crDeviceRole';
    EntitySetName = 'crDevicesRoles';

    elements
    {
        dataitem(DeviceRole;
        DYM_DeviceRole)
        {
            column("code";
            "Code")
            {
            }
            column(description;
            Description)
            {
            }
        }
    }
}
