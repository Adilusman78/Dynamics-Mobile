query 84106 DYM_DAO_BS_ItemLedgerEntrySum
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsitemLedgerEntrySum';
    EntitySetName = 'bsitemLedgerEntriesSum';

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
    column(lotNo;
    "Lot No.")
    {
    }
    column(serialNo;
    "Serial No.")
    {
    }
    column(packageNo;
    "Package No.")
    {
    }
    column(expirationDate;
    "Expiration Date")
    {
    }
    column(remainingQuantity;
    "Remaining Quantity")
    {
    Method = Sum;
    }
    column(sumQuantity;
    Quantity)
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
