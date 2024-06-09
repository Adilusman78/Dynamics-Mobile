query 84312 DYM_DAO_WH_ItemJournalBatch
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whItemJournalBatch';
    EntitySetName = 'whItemJournalBatches';

    elements
    {
    dataitem(ItemJournalBatch;
    "Item Journal Batch")
    {
    column(journalTemplateName;
    "Journal Template Name")
    {
    }
    column(name;
    Name)
    {
    }
    }
    }
}
