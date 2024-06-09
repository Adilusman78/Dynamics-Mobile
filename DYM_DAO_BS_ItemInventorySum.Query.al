query 84120 DYM_DAO_BS_ItemInventorySum
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemInventorySumEntity';
    EntitySetName = 'bsItemInventorySum';

    elements
    {
    dataitem(ItemLedgerEntry;
    "Item Ledger Entry")
    {
    column(itemNo;
    "Item No.")
    {
    }
    column(variantCode;
    "Variant Code")
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    column(remainingQuantity;
    "Remaining Quantity")
    {
    Method = Sum;
    }
    dataitem(Item;
    "Item")
    {
    SqlJoinType = LeftOuterJoin;
    DataItemLink = "No."=ItemLedgerEntry."Item No.";

    column(description;
    Description)
    {
    }
    column(baseUnitofMeasure;
    "Base Unit of Measure")
    {
    }
    column(salesUnitofMeasure;
    "Sales Unit of Measure")
    {
    }
    }
    }
    }
}
