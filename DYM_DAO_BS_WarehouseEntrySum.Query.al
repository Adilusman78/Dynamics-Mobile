query 84115 DYM_DAO_BS_WarehouseEntrySum
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsWarehouseEntrySum_backup';
    EntitySetName = 'bsWarehouseEntriesSum_backup';

    elements
    {
    dataitem(WarehouseEntry;
    "Warehouse Entry")
    {
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
    column(expirationDate;
    "Expiration Date")
    {
    }
    column(quantity;
    Quantity)
    {
    Method = Sum;
    }
    column(qtyBase;
    "Qty. (Base)")
    {
    Method = Sum;
    }
    }
    }
}
