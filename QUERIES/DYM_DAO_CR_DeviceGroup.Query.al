query 70120 DYM_DAO_CR_DeviceGroup
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crDeviceGroup';
    EntitySetName = 'crDevicesGroups';

    elements
    {
        dataitem(DeviceGroup;
        DYM_DeviceGroup)
        {
            column("code";
            "Code")
            {
            }
            column(description;
            Description)
            {
            }
            column(disabled;
            Disabled)
            {
            }
            column(deviceRoleCode;
            "Device Role Code")
            {
            }
        }
    }
}
