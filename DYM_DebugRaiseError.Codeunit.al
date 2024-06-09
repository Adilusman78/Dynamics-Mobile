codeunit 84014 DYM_DebugRaiseError
{
    trigger OnRun()
    begin
        Error('Call Stack Push');
    end;
}
