query 84315 DYM_DAO_WH_PhysInventoryLines
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whPhysicalInventoryLine';
    EntitySetName = 'whPhysicalInventoryLines';
    OrderBy = ascending(journalTemplateName, journalBatchName, lineNo, locationCode, binCode, itemNo, unitOfMeasureCode, variantCode, mobileDevice, description);

    elements
    {
    dataitem(ItemJournalLine;
    "Item Journal Line")
    {
    column(journalTemplateName;
    "Journal Template Name")
    {
    }
    column(journalBatchName;
    "Journal Batch Name")
    {
    }
    column(itemNo;
    "Item No.")
    {
    }
    column(description;
    Description)
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
    column(unitOfMeasureCode;
    "Unit of Measure Code")
    {
    }
    column(mobileDevice;
    DYM_MobileDevice)
    {
    }
    column(binCode;
    "Bin Code")
    {
    }
    column(lineNo;
    "Line No.")
    {
    }
    }
    }
}
