enum 70108 DYM_DocumentTraceStatus
{
    Caption = 'Document Trace Status';

    //Value order controls importance!
    //The higher the value, the higher the importance for user.
    //Have in mind if extending
    value(0; None)
    {
        Caption = 'None';
    }
    value(1; Success)
    {
        Caption = 'Success';
    }
    value(2; Pending)
    {
        Caption = 'Pending';
    }
    value(3; Failed)
    {
        Caption = 'Failed';
    }
}
