page 84023 DYM_DAO_CR_JobQueueEntries
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crJobQueueEntry';
    EntitySetName = 'crJobQueueEntries';
    SourceTable = "Job Queue Entry";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field(id; Rec.ID)
                {
                }
                field(description; Rec.Description)
                {
                }
                field(jobQueueCategory; Rec."Job Queue Category Code")
                {
                }
                field(status; Rec.Status)
                {
                }
                field(objectTypeToRun; Rec."Object Type to Run")
                {
                }
                field(objectIdToRun; Rec."Object ID to Run")
                {
                }
                field(objectCaptiontoRun; Rec."Object Caption to Run")
                {
                }
                field(scheduled; Rec.Scheduled)
                {
                }
                field(recurring; Rec."Recurring Job")
                {
                }
                field(numberOfMinutesBetweenRuns; Rec."No. of Minutes between Runs")
                {
                }
                field(userId; Rec."User ID")
                {
                }
                field(dynamicsMobileJob; Rec."Run in User Session")
                {
                }
            }
        }
    }
    var ConstMgt: Codeunit DYM_ConstManagement;
    DMModuleInfo: ModuleInfo;
    DMRangeFrom, DMRangeTo: Integer;
    trigger OnOpenPage()
    begin
        clear(DMRangeFrom);
        clear(DMRangeTo);
        NavApp.GetCurrentModuleInfo(DMModuleInfo);
        if(DMModuleInfo.Id = ConstMgt.APP_OnPrem_ID())then begin
            DMRangeFrom:=ConstMgt.RNG_Range_OnPrem_FromId();
            DMRangeTo:=ConstMgt.RNG_Range_OnPrem_ToId();
        end;
        if(DMModuleInfo.Id = ConstMgt.APP_SaaS_ID())then begin
            DMRangeFrom:=ConstMgt.RNG_Range_SaaS_FromId();
            DMRangeTo:=ConstMgt.RNG_Range_SaaS_ToId();
        end;
        PopulatePageData();
    end;
    procedure PopulatePageData()
    var
        JobQueueEntry: Record "Job Queue Entry";
        FiltersBackupRec: Record "Job Queue Entry";
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        SkipRecord: Boolean;
    begin
        FiltersBackupRec.Reset();
        FiltersBackupRec.CopyFilters(Rec);
        Rec.Reset();
        if(Rec.IsTemporary)then rec.DeleteAll();
        JobQueueEntry.Reset();
        if(FiltersBackupRec.GetFilters() <> '')then JobQueueEntry.CopyFilters(FiltersBackupRec);
        //Remove actual table filtering as we use the field for different purpose
        JobQueueEntry.SetRange("Run in User Session");
        if JobQueueEntry.FindSet()then repeat Rec.Init();
                Rec.TransferFields(JobQueueEntry, true);
                //Use as buffer field for dynamicsMobileJob in order to allow filtering on it
                Rec."Run in User Session":=((Rec."Object ID to Run" >= DMRangeFrom) AND (Rec."Object ID to Run" <= DMRangeTo));
                Rec.Insert();
            until JobQueueEntry.Next() = 0;
        Rec.CopyFilters(FiltersBackupRec);
    end;
}
