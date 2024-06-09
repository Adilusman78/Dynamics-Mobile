codeunit 84000 DYM_DynamicsMobileStartup
{
    SingleInstance = true;

    trigger OnRun()
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        CheckSetup;
        Message(Text000);
        StartProcessScheduler;
    end;
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    SyncMgt: Codeunit DYM_SyncManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    PacketMgt: Codeunit DYM_PacketManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    SetupCheckPointCounter: Integer;
    SettingsCheckPointCounter: Integer;
    SetupRead: Boolean;
    Text000: Label 'Dynamics Mobile dispatcher started.';
    procedure StartProcessScheduler()
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        MobileSetup.TestField("Process Timer Interval");
        Clear(SetupCheckPointCounter);
        Clear(SettingsCheckPointCounter);
        if MobileSetup."Settings Auto Sync" then MobileSetup.TestField("Auto Sync Intervals");
        repeat OnTimerEvent;
            Sleep(MobileSetup."Process Timer Interval");
        until false;
    end;
    procedure SettingsCheckPoint()
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if MobileSetup."DES Changed" then begin
            SyncMgt.ForceExportDES;
            SyncMgt.ClearDESChanged;
        end;
        if MobileSetup."DBS Changed" then begin
            SyncMgt.ForceExportDBS;
            SyncMgt.ClearDBSChanged;
        end;
        Clear(SetupRead);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
    end;
    procedure SetupCheckPoint()
    begin
        CacheMgt.SetCheckPoint(true);
    end;
    procedure CheckSetup()
    var
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        Cue: Record DYM_DynamicsMobileCue;
    begin
        Clear(SettingsMgt);
        if not MobileSetup."Dynamics Mobile initialized" then begin
            SettingsMgt.ImportDefaultData;
            Clear(SetupRead);
            CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        end;
        if not Cue.Get then begin
            Cue.Init;
            Cue.Insert;
        end;
        Commit;
    end;
    procedure OnTimerEvent()
    begin
        SelectLatestVersion;
        PacketMgt.ProcessWaiting(false);
        if MobileSetup."Packet Process Retry Enabled" then PacketMgt.ProcessWaiting(true);
        if MobileSetup."Settings Auto Sync" then begin
            SettingsCheckPointCounter+=1;
            if(SettingsCheckPointCounter >= MobileSetup."Auto Sync Intervals")then begin
                SettingsCheckPoint;
                Clear(SettingsCheckPointCounter);
            end;
        end;
        SetupCheckPointCounter+=1;
        if(SetupCheckPointCounter > ConstMgt.CHP_SetupCheckPointTimerIntervals)then begin
            SetupCheckPoint;
            Clear(SetupCheckPointCounter);
        end;
    end;
}
