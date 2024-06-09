query 70109 DYM_DAO_BS_ItemUnitofMeasure
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemUnitofMeasure';
    EntitySetName = 'bsItemUnitsofMeasure';

    elements
    {
        dataitem(ItemUnitofmeasure;
        "Item Unit of Measure")
        {
            column(itemNo;
            "Item No.")
            {
            }
            column("code";
            "Code")
            {
            }
            column(qtyperUnitofMeasure;
            "Qty. per Unit of Measure")
            {
            }
            column(length;
            Length)
            {
            }
            column(width;
            Width)
            {
            }
            column(height;
            Height)
            {
            }
            column(cubage;
            Cubage)
            {
            }
            column(weight;
            Weight)
            {
            }
        }
    }
}
