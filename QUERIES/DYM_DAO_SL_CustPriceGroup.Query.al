query 70129 DYM_DAO_SL_CustPriceGroup
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slCustPriceGroup';
    EntitySetName = 'slCustPriceGroups';

    elements
    {
        dataitem(CustomerPriceGroup;
        "Customer Price Group")
        {
            column(custPriceGroupCode;
            Code)
            {
            }
            column(description;
            Description)
            {
            }
        }
    }
}
