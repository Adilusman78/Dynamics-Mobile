enum 70112 DYM_EventLogSourceType
{
    Extensible = true;
    Caption = 'EventLog Event Source Type';

    value(0; "Processing")
    {
        Caption = 'Processing';
    }
    value(1; "Post-Processing")
    {
        Caption = 'Post-Processing';
    }
    value(2; "Parsing")
    {
        Caption = 'Parsing';
    }
    value(3; "Loading")
    {
        Caption = 'Loading';
    }
    value(4; "RPC")
    {
        Caption = 'RPC';
    }
    value(5; "BLOB Loading")
    {
        Caption = 'BLOB Loading';
    }
    value(6; "Fetch")
    {
        Caption = 'Fetch';
    }
    value(7; "Settings Storage")
    {
        Caption = 'Settings Storage';
    }
}
