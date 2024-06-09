codeunit 70129 DYM_JobQueueDispatcher
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        startUp(Rec);
    end;

    var
        Text001: Label 'You must assign a parameter to the job queue. Valid values for parameter are: ALL, FETCH, LOAD, PARSE, PROCESS, POSTPROCESS, UPLOAD';

    procedure startUp(JobQueueEntry: record "Job Queue Entry")
    var
        DMSetup: Record DYM_DynamicsMobileSetup;
        packetMgt: Codeunit DYM_PacketManagement;
        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
    begin
        DMSetup.Get();
        clear(packetMgt);
        if JobQueueEntry."Parameter String" = '' then Error(Text001);
        HeartBeatMgt.SetJobQueueEntry(JobQueueEntry);
        HeartBeatMgt.DeleteAllHeartBeats();
        packetMgt.setParams(JobQueueEntry."Parameter String");
        //packetMgt.ProcessWaiting(false);
        //if (DMSetup."Packet Process Retry Enabled") then
        //    packetMgt.ProcessWaiting(true);
        packetMgt.Run();
        HeartBeatMgt.DeleteAllHeartBeats();
    end;
}
