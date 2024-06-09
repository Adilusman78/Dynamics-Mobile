query 70110 DYM_DAO_BS_ItemVariant
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemVariant';
    EntitySetName = 'bsItemVariants';

    elements
    {
        dataitem(ItemVariant;
        "Item Variant")
        {
            column(itemNo;
            "Item No.")
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
