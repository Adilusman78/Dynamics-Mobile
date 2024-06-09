query 70124 DYM_DAO_CR_MobileTableMap
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crMobileTableMap';
    EntitySetName = 'crMobileTableMaps';

    elements
    {
        dataitem(MobileTableMap;
        DYM_MobileTableMap)
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
            column(fieldsDefinedByTableIndex;
            "Fields Defined by Table Index")
            {
            }
            column(index;
            Index)
            {
            }
            column(mobileTable;
            "Mobile Table")
            {
            }
            column("key";
            "Key")
            {
            }
            //column(navTableName; "NAV Table Name") { }
            column(pullType;
            "Pull Type")
            {
            }
            column(relationType;
            "Relation Type")
            {
            }
            column(tableNo;
            "Table No.")
            {
            }
            column(systemId;
            SystemId)
            {
            }
        }
    }
}
