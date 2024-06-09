enum 84004 DYM_JobQueueOperation
{
    Caption = 'Job Queue Operation';

    value(0; None)
    {
    Caption = 'None';
    }
    value(1; Fetch)
    {
    Caption = 'Fetch';
    }
    value(2; Load)
    {
    Caption = 'Load';
    }
    value(3; Parse)
    {
    Caption = 'Parse';
    }
    value(4; Process)
    {
    Caption = 'Process';
    }
    value(5; PostProcess)
    {
    Caption = 'PostProcess';
    }
    value(6; Upload)
    {
    Caption = 'Upload';
    }
    value(7; LoadBlob)
    {
    Caption = 'LoadBlob';
    }
}
