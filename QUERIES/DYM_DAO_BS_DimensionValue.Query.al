query 70103 DYM_DAO_BS_DimensionValue
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsDimensionValue';
    EntitySetName = 'bsDimensionValues';

    elements
    {
        dataitem(DimensionValue;
        "Dimension Value")
        {
            column(blocked;
            Blocked)
            {
            }
            column(dimensionCode;
            "Dimension Code")
            {
            }
            column("code";
            "Code")
            {
            }
            column(dimensionId;
            "Dimension Id")
            {
            }
            column(dimensionValueID;
            "Dimension Value ID")
            {
            }
            column(dimensionValueType;
            "Dimension Value Type")
            {
            }
            column(name;
            Name)
            {
            }
            column(indentation;
            Indentation)
            {
            }
        }
    }
}
