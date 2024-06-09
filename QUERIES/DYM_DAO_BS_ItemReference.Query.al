query 70108 DYM_DAO_BS_ItemReference
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemReference';
    EntitySetName = 'bsItemReferences';

    elements
    {
        dataitem(ItemReference;
        "Item Reference")
        {
            column(description;
            Description)
            {
            }
            column(description2;
            "Description 2")
            {
            }
            column(itemNo;
            "Item No.")
            {
            }
            column(referenceNo;
            "Reference No.")
            {
            }
            column(referenceType;
            "Reference Type")
            {
            }
            column(referenceTypeNo;
            "Reference Type No.")
            {
            }
            column(unitOfMeasure;
            "Unit of Measure")
            {
            }
            column(variantCode;
            "Variant Code")
            {
            }
        }
    }
}
