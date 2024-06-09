query 84113 DYM_DAO_BS_WarehouseEntry
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsWarehouseEntry';
    EntitySetName = 'bsWarehouseEntries';

    elements
    {
    dataitem(WarehouseEntry;
    "Warehouse Entry")
    {
    column(entryNo;
    "Entry No.")
    {
    }
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
    column(qtyperUnitofMeasure;
    "Qty. per Unit of Measure")
    {
    }
    column(lotNo;
    "Lot No.")
    {
    }
    column(serialNo;
    "Serial No.")
    {
    }
    column(quantity;
    Quantity)
    {
    }
    column(qtyBase;
    "Qty. (Base)")
    {
    }
    }
    }
}
