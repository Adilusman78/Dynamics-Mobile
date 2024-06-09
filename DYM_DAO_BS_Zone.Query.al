query 84110 DYM_DAO_BS_Zone
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsZone';
    EntitySetName = 'bsZones';

    elements
    {
    dataitem(Zone;
    Zone)
    {
    column("code";
    "Code")
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    }
    }
}
