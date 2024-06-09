codeunit 70114 DYM_DebugRaiseError
{
    trigger OnRun()
    begin
        Error('Call Stack Push');
    end;
}
