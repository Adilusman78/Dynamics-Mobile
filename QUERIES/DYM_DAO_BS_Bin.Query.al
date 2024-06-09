query 70100 DYM_DAO_BS_Bin
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsBin';
    EntitySetName = 'bsBins';

    elements
    {
        dataitem(Bin;
        Bin)
        {
            column("code";
            "Code")
            {
            }
            column(zoneCode;
            "Zone Code")
            {
            }
            column(locationCode;
            "Location Code")
            {
            }
            column(description;
            Description)
            {
            }
            column(blockMovement;
            "Block Movement")
            {
            }
        }
    }
}
