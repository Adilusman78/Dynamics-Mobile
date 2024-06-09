codeunit 70121 DYM_ExtensionInstallManagement
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        ConstMgt: Codeunit DYM_ConstManagement;
        DynamicsMobileSetup: Record DYM_DynamicsMobileSetup;
        JobQueueEntry: Record "Job Queue Entry";
        EventLog: Record DYM_EventLog;
        RestartTime: DateTime;
        Info: ModuleInfo;
    begin
        if not DynamicsMobileSetup.Get() then begin
            DynamicsMobileSetup.Init();
            DynamicsMobileSetup.Insert();
        end;
        NavApp.GetCurrentModuleInfo(Info);
        JobQueueEntry.Reset();
        JobQueueEntry.SetFilter("Object Type to Run", StrSubstNo('%1 | %2', JobQueueEntry."Object Type to Run"::Codeunit, JobQueueEntry."Object Type to Run"::Report));
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
        if (Info.Id = ConstMgt.APP_OnPrem_ID()) then JobQueueEntry.SetRange("Object ID to Run", ConstMgt.RNG_Range_OnPrem_FromId(), ConstMgt.RNG_Range_OnPrem_ToId());
        if (Info.Id = ConstMgt.APP_SaaS_ID()) then JobQueueEntry.SetRange("Object ID to Run", ConstMgt.RNG_Range_SaaS_FromId(), ConstMgt.RNG_Range_SaaS_ToId());
        if (JobQueueEntry.FindSet()) then
            repeat
                RestartTime := CreateDateTime(Today, Time) + 120 * 1000;
                JobQueueEntry.Validate("Earliest Start Date/Time", RestartTime);
                JobQueueEntry.Restart();
            until JobQueueEntry.Next() = 0;
    end;
}
