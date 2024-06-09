query 84000 DYM_DAO_CR_DeviceSetup
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crDeviceSetup';
    EntitySetName = 'crDevicesSetup';

    elements
    {
    dataitem(DeviceSetup;
    DYM_DeviceSetup)
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
    column(deviceGroupCode;
    "Device Group Code")
    {
    }
    column(salespersonCode;
    "Salesperson Code")
    {
    }
    }
    }
}
