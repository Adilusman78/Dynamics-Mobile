query 84112 DYM_DAO_BS_ItemLedgerEntry
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemLedgerEntry';
    EntitySetName = 'bsItemLedgerEntries';

    elements
    {
    dataitem(ItemLedgerEntry;
    "Item Ledger Entry")
    {
    column(entryNo;
    "Entry No.")
    {
    }
    column(entryType;
    "Entry Type")
    {
    }
    column(documentType;
    "Document Type")
    {
    }
    column(documentNo;
    "Document No.")
    {
    }
    column(postingDate;
    "Posting Date")
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
    column(quantity;
    Quantity)
    {
    }
    column(remainingQuantity;
    "Remaining Quantity")
    {
    }
    column(open;
    Open)
    {
    }
    column(positive;
    Positive)
    {
    }
    }
    }
}
