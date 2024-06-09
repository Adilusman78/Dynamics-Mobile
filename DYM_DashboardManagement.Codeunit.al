codeunit 84015 DYM_DashboardManagement
{
    trigger OnRun()
    begin
    end;
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    SetupRead: Boolean;
    procedure GetPacketsCount(_DeviceSetupCode: Code[100]; Direction: enum DYM_PacketDirection; Status: enum DYM_PacketStatus)Result: Integer var
        SyncLog: Record DYM_SyncLog;
    begin
        Clear(Result);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        SyncLog.Reset;
        SyncLog.SetCurrentKey(Company, Direction, Status, "Device Role Code", "Device Group Code", "Device Setup Code");
        SyncLog.SetRange(Company, CompanyName);
        SyncLog.SetRange(Direction, Direction);
        SyncLog.SetRange(Status, Status);
        SyncLog.SetFilter("Entry TimeStamp", '>=%1', CreateDateTime(Today - MobileSetup."Dashboard Calculation Days", Time));
        if(_DeviceSetupCode <> '')then SyncLog.SetRange("Device Setup Code", _DeviceSetupCode);
        exit(SyncLog.Count);
    end;
    procedure DrillDownPackets(_DeviceSetupCode: Code[100]; Direction: Enum DYM_PacketDirection; Status: enum DYM_PacketStatus)
    var
        SyncLog: Record DYM_SyncLog;
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        SyncLog.Reset;
        SyncLog.SetCurrentKey(Company, Direction, Status, "Device Role Code", "Device Group Code", "Device Setup Code");
        SyncLog.SetRange(Company, CompanyName);
        SyncLog.SetRange(Direction, Direction);
        SyncLog.SetRange(Status, Status);
        SyncLog.SetFilter("Entry TimeStamp", '>=%1', CreateDateTime(Today - MobileSetup."Dashboard Calculation Days", Time));
        if(_DeviceSetupCode <> '')then SyncLog.SetRange("Device Setup Code", _DeviceSetupCode);
        PAGE.RunModal(0, SyncLog);
    end;
    procedure GetSettingsSynced()Result: Boolean begin
        Clear(Result);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        exit(not(MobileSetup."DES Changed" or MobileSetup."DBS Changed"));
    end;
    procedure GetActiveGroups()Result: Integer var
        DeviceGroup: Record DYM_DeviceGroup;
    begin
        Clear(Result);
        DeviceGroup.Reset;
        DeviceGroup.SetRange(Disabled, false);
        exit(DeviceGroup.Count);
    end;
    procedure GetActiveDevices()Result: Integer var
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        Clear(Result);
        DeviceGroup.Reset;
        DeviceGroup.SetRange(Disabled, false);
        if DeviceGroup.FindSet(false, false)then repeat DeviceSetup.Reset;
                DeviceSetup.SetRange("Device Group Code", DeviceGroup.Code);
                DeviceSetup.SetRange(Disabled, false);
                Result+=DeviceSetup.Count;
            until DeviceGroup.Next = 0;
    end;
}
