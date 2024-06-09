enum 70126 DYM_PostProcessPacketStatus
{
    Caption = 'PostProcess Packet Status';

    value(0; "Pending")
    {
        Caption = 'Pending';
    }
    value(1; InProgress)
    {
        Caption = 'InProgress';
    }
    value(2; "Success")
    {
        Caption = 'Success';
    }
    value(3; "Failed")
    {
        Caption = 'Failed';
    }
    value(4; Error)
    {
        Caption = 'Error';
    }
    value(5; Debug)
    {
        Caption = 'Debug';
    }
    value(6; Skipped)
    {
        Caption = 'Skipped';
    }
}
