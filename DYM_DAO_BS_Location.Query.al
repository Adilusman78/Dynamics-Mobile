query 84107 DYM_DAO_BS_Location
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsLocation';
    EntitySetName = 'bsLocations';

    elements
    {
    dataitem(Location;
    Location)
    {
    column("code";
    "Code")
    {
    }
    column(name;
    Name)
    {
    }
    column(useAsInTransit;
    "Use As In-Transit")
    {
    }
    column(binMandatory;
    "Bin Mandatory")
    {
    }
    column(requirePick;
    "Require Pick")
    {
    }
    column(requirePutaway;
    "Require Put-away")
    {
    }
    column(requireReceive;
    "Require Receive")
    {
    }
    column(requireShipment;
    "Require Shipment")
    {
    }
    }
    }
}
