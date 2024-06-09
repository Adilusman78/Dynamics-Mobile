query 84116 DYM_DAO_BS_ShipAgent
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsShippingAgent';
    EntitySetName = 'bsShippingAgents';

    elements
    {
    dataitem(ShippingAgent;
    "Shipping Agent")
    {
    column("code";
    "Code")
    {
    }
    column(name;
    Name)
    {
    }
    }
    }
}
