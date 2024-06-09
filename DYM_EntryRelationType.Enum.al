enum 84003 DYM_EntryRelationType
{
    Extensible = true;
    Caption = 'Entry Relation Type';

    value(0; None)
    {
    Caption = 'None';
    }
    value(1; SyncLogEntry)
    {
    Caption = 'Sync Log Entry';
    }
    value(2; PostProcessLogEntry)
    {
    Caption = 'Post Process Log Entry';
    }
    value(3; BlobStoreEntry)
    {
    Caption = 'BlobStore Entry';
    }
}
