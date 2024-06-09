query 70123 DYM_DAO_CR_MobileFieldMap
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crMobileFieldMap';
    EntitySetName = 'crMobileFieldMaps';

    elements
    {
        dataitem(DataItemName;
        DYM_MobileFieldMap)
        {
            column(deviceRoleCode;
            "Device Role Code")
            {
            }
            column(direction;
            Direction)
            {
            }
            column(disabled;
            Disabled)
            {
            }
            column(fieldIndex;
            "Field Index")
            {
            }
            column(fieldNo;
            "Field No.")
            {
            }
            column(keyField;
            "Key Field")
            {
            }
            column(mobileField;
            "Mobile Field")
            {
            }
            column(mobileTable;
            "Mobile Table")
            {
            }
            //column(navTableName; "NAV Table Name") { }
            column(relational;
            Relational)
            {
            }
            column(tableIndex;
            "Table Index")
            {
            }
            column(tableNo;
            "Table No.")
            {
            }
            column(tableDirection;
            "Table Direction")
            {
            }
            column(systemId;
            SystemId)
            {
            }
            //column(navFieldName; "NAV Field Name") { }
        }
    }
}
