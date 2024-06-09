query 70114 DYM_DAO_BS_ShipAgentService
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsShippingAgentService';
    EntitySetName = 'bsShippingAgentServices';

    elements
    {
        dataitem(ShippingAgentServices;
        "Shipping Agent Services")
        {
            column(shippingAgentCode;
            "Shipping Agent Code")
            {
            }
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
