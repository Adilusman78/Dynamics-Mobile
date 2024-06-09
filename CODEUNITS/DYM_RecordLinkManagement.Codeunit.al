codeunit 70140 DYM_RecordLinkManagement
{
    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        CacheMgt: Codeunit DYM_CacheManagement;
        XMLMgt: Codeunit DYM_XMLManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        ConstMgt: Codeunit DYM_ConstManagement;
        StatsMgt: Codeunit DYM_StatisticsManagement;
        SessionMgt: Codeunit DYM_SessionManagement;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        AIEntryNo: Integer;
        SLE: Integer;
        SetupRead: Boolean;

    procedure SetRecordLink(_MapTableName: Text[50]; _DMS_RowId: Text[50]; _RecordLinkTableNo: Integer; _RecordLinkRecId: Guid)
    var
        RecordLink: Record DYM_RecordLink;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        RecordLink.Reset();
        RecordLink.SetRange("Device Setup Code", DeviceSetup.Code);
        RecordLink.SetRange(MapTableName, _MapTableName);
        RecordLink.SetRange(DMS_RowId, _DMS_RowId);
        if not RecordLink.FindFirst() then begin
            RecordLink.Init();
            RecordLink.Validate("Device Setup Code", DeviceSetup.Code);
            RecordLink.Validate(MapTableName, _MapTableName);
            RecordLink.Validate(DMS_RowId, _DMS_RowId);
            RecordLink.Insert();
        end;
        RecordLink.Validate(RecordLinkTableNo, _RecordLinkTableNo);
        RecordLink.Validate(RecordLinkRecId, _RecordLinkRecId);
        RecordLink.Modify();
    end;

    procedure GetRecordLinkByDMSRowId(_MapTableName: Text[50]; _DMS_RowId: Text[50]; var _RecordLink: Record DYM_RecordLink)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not _RecordLink.Get(DeviceSetup.Code, _MapTableName, _DMS_RowId) then clear(_RecordLink);
    end;

    procedure GetRecordLinkRecId(_MapTablename: Text[50]; _DMS_RowId: Text[50]) Result: Guid
    var
        RecordLink: Record DYM_RecordLink;
    begin
        Clear(RecordLink);
        GetRecordLinkByDMSRowId(_MapTablename, _DMS_RowId, RecordLink);
        exit(RecordLink.RecordLinkRecId);
    end;
}
