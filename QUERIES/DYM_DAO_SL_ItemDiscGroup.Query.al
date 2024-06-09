query 70130 DYM_DAO_SL_ItemDiscGroup
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slItemDiscountGroup';
    EntitySetName = 'slItemDiscountGroups';

    elements
    {
        dataitem(itemDiscountGroup;
        "Item Discount Group")
        {
            column(itemDiscountGroupCode;
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
