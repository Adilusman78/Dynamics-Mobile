query 84211 DYM_DAO_SL_CustDiscountGroup
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slCustDiscountGroup';
    EntitySetName = 'slCustDiscountGroups';

    elements
    {
    dataitem(CustomerDiscountGroup;
    "Customer Discount Group")
    {
    column(custDiscountGroupCode;
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
