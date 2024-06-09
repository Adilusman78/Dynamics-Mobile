query 70118 DYM_DAO_BS_WhseActivityLineSum
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsWhseActivityLineSum';
    EntitySetName = 'bsWhseActivityLinesSum';

    elements
    {
        dataitem(WhseActLine;
        "Warehouse Activity Line")
        {
            DataItemTableFilter = "Assemble to Order" = const(false), "Action Type" = filter(1); //Take

            column(locationCode;
            "Location Code")
            {
            }
            column(zoneCode;
            "Zone Code")
            {
            }
            column(binCode;
            "Bin Code")
            {
            }
            column(itemNo;
            "Item No.")
            {
            }
            column(variantCode;
            "Variant Code")
            {
            }
            column(unitofMeasureCode;
            "Unit of Measure Code")
            {
            }
            column(actionType;
            "Action Type")
            {
            }
            column(qtytoPick;
            "Qty. Outstanding")
            {
                Method = Sum;
            }
            column(qtytoPickBase;
            "Qty. Outstanding (Base)")
            {
                Method = Sum;
            }
        }
    }
}
