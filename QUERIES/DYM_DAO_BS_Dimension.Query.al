query 70102 DYM_DAO_BS_Dimension
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsDimension';
    EntitySetName = 'bsDimensions';

    elements
    {
        dataitem(Dimension;
        Dimension)
        {
            column(blocked;
            Blocked)
            {
            }
            column("code";
            "Code")
            {
            }
            column(codeCaption;
            "Code Caption")
            {
            }
            column(description;
            Description)
            {
            }
            column(name;
            Name)
            {
            }
        }
    }
}
