query 70131 DYM_DAO_SL_MixAndMatchGroup
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slMixAndMatchGroup';
    EntitySetName = 'slMixAndMatchGroups';

    elements
    {
        dataitem(DYM_MixAndMatchGroup;
        DYM_MixAndMatchGroup)
        {
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
