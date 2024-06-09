enum 70111 DYM_EventLogEventType
{
    Extensible = true;
    Caption = 'EventLog Event Type';

    value(0; "Trace")
    {
        Caption = 'Trace';
    }
    value(1; "Debug")
    {
        Caption = 'Debug';
    }
    value(2; "Info")
    {
        Caption = 'Info';
    }
    value(3; "Warning")
    {
        Caption = 'Warning';
    }
    value(4; "Error")
    {
        Caption = 'Error';
    }
}
