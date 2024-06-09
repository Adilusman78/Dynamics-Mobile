enum 70102 DYM_BLOBStoreEntryStatus
{
    Extensible = true;
    Caption = 'BlobStore Entry Status';

    value(0; "Pending")
    {
        Caption = 'Pending';
    }
    value(1; "Loading")
    {
        Caption = 'Loading';
    }
    value(2; "Loaded")
    {
        Caption = 'Loaded';
    }
    value(3; "LoadError")
    {
        Caption = 'LoadError';
    }
    value(4; "Processed")
    {
        Caption = 'Processed';
    }
}
