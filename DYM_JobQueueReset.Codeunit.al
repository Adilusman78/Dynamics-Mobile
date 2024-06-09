codeunit 84006 DYM_JobQueueReset
{
    var MSG_JobQueueEntriesReset: Label '[%1] job queue entries reset.';
    trigger OnRun()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueEntry2: Record "Job Queue Entry";
        Counter: Integer;
    begin
        clear(Counter);
        JobQueueEntry.RESET;
        JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SETRANGE("Object ID to Run", CODEUNIT::DYM_JobQueueDispatcher);
        JobQueueEntry.SETFILTER(Status, '%1|%2', JobQueueEntry.Status::Error, JobQueueEntry.Status::Finished);
        IF JobQueueEntry.FINDSET(FALSE, FALSE)THEN REPEAT Counter+=1;
                JobQueueEntry2.GET(JobQueueEntry.ID);
                JobQueueEntry2.Restart;
            UNTIL JobQueueEntry.NEXT = 0;
        if(Counter > 0)then Message(MSG_JobQueueEntriesReset, Counter);
    end;
}
