enum 84100 DYM_BS_MobileStatus
{
    Extensible = true;
    Caption = 'Mobile Status';

    value(0; " ")
    {
    Caption = ' ';
    }
    value(1; Pending)
    {
    Caption = 'Pending';
    }
    value(2; "In Progress")
    {
    Caption = 'InProgress';
    }
    value(3; "Partially Processed")
    {
    Caption = 'Partially Processed';
    }
    value(4; Processed)
    {
    Caption = 'Processed';
    }
}
