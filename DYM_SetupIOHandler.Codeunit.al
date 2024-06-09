codeunit 84051 DYM_SetupIOHandler
{
    var SetupIOMgt: Codeunit DYM_SetupIOManagement;
    Filename: Text;
    StreamReader: InStream;
    StreamWriter: OutStream;
    JObj: JsonObject;
    ExportFormat: Enum DYM_BackupRestoreFormat;
    Version_Full: Label 'F_DynaMo40_NAV71W1', Locked = true;
    Version_Settings: Label 'S_DynaMo40_NAV71W1', Locked = true;
    Version_DeviceHierarchy: Label 'D_DynaMo40_NAV71W1', Locked = true;
    Version_Mapping: Label 'M_DynaMo40_NAV71W1', Locked = true;
    Version_DMLog: Label 'L_DynaMo40_NAV71W1', Locked = true;
    procedure SetExportFormat(_ExportFormat: Enum DYM_BackupRestoreFormat)
    begin
        ExportFormat:=_ExportFormat;
    end;
    procedure SetSettingsStorageEntry(_SettingsStorage: Record DYM_SettingsStorage)
    begin
        SetupIOMgt.SetSettingsStorageEntry(_SettingsStorage);
    end;
    #region FullIO
    procedure ImportFull(FromFile: Boolean)
    begin
        if FromFile then Filename:=SetupIOMgt.SelectInputFile;
        SetupIOMgt.OpenStreamReader(StreamReader);
        SetupIOMgt.ImportVersion(StreamReader, Version_Full);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DynamicsMobileSetup);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileTableMap);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DeviceRole);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DeviceGroup);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DeviceSetup);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_Settings);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_SettingsAssignment);
        SetupIO_OnFullImport(StreamReader);
        SetupIOMgt.CloseStreamReader;
    end;
    procedure ExportFull(ToFile: Boolean)
    begin
        if not SetupIOMgt.SetExportFormat(ExportFormat)then exit;
        SetupIOMgt.OpenStreamWriter(StreamWriter, JObj);
        SetupIOMgt.ExportVersion(StreamWriter, JObj, Version_Full);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DynamicsMobileSetup);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileTableMap);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DeviceRole);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DeviceGroup);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DeviceSetup);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_Settings);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_SettingsAssignment);
        SetupIO_OnFullExport(StreamWriter, JObj);
        case ToFile of true: SetupIOMgt.WriteOutputFile;
        false: SetupIOMgt.ExportBlob(StreamWriter, JObj, Enum::DYM_BackupRestoreType::Full);
        end;
        SetupIOMgt.CloseStreamWriter;
    end;
    procedure TruncateFull()
    begin
        SetupIOMgt.TruncateTable(DATABASE::DYM_DynamicsMobileSetup);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileTableMap);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.TruncateTable(DATABASE::DYM_DeviceRole);
        SetupIOMgt.TruncateTable(DATABASE::DYM_DeviceGroup);
        SetupIOMgt.TruncateTable(DATABASE::DYM_DeviceSetup);
        SetupIOMgt.TruncateTable(DATABASE::DYM_Settings);
        SetupIOMgt.TruncateTable(DATABASE::DYM_SettingsAssignment);
    end;
    #endregion 
    #region SettingsIO
    procedure ImportSettings(FromFile: Boolean)
    begin
        if FromFile then Filename:=SetupIOMgt.SelectInputFile;
        SetupIOMgt.OpenStreamReader(StreamReader);
        SetupIOMgt.ImportVersion(StreamReader, Version_Settings);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DynamicsMobileSetup);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileTableMap);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_Settings);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_SettingsAssignment);
        SetupIOMgt.CloseStreamReader;
    end;
    procedure ExportSettings(ToFile: Boolean)
    begin
        if not SetupIOMgt.SetExportFormat(ExportFormat)then exit;
        SetupIOMgt.OpenStreamWriter(StreamWriter, JObj);
        SetupIOMgt.ExportVersion(StreamWriter, JObj, Version_Settings);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DynamicsMobileSetup);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileTableMap);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_Settings);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_SettingsAssignment);
        case ToFile of true: SetupIOMgt.WriteOutputFile;
        false: SetupIOMgt.ExportBlob(StreamWriter, JObj, Enum::DYM_BackupRestoreType::Settings);
        end;
        SetupIOMgt.CloseStreamWriter;
    end;
    procedure TruncateSettings()
    begin
        SetupIOMgt.TruncateTable(DATABASE::DYM_DynamicsMobileSetup);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileTableMap);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.TruncateTable(DATABASE::DYM_Settings);
        SetupIOMgt.TruncateTable(DATABASE::DYM_SettingsAssignment);
    end;
    #endregion 
    #region DeviceHierarchyIO
    procedure ImportDeviceHierarchy(FromFile: Boolean)
    begin
        if FromFile then Filename:=SetupIOMgt.SelectInputFile;
        SetupIOMgt.OpenStreamReader(StreamReader);
        SetupIOMgt.ImportVersion(StreamReader, Version_DeviceHierarchy);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DeviceRole);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DeviceGroup);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DeviceSetup);
        SetupIOMgt.CloseStreamReader;
    end;
    procedure ExportDeviceHierarchy(ToFile: Boolean)
    begin
        if not SetupIOMgt.SetExportFormat(ExportFormat)then exit;
        SetupIOMgt.OpenStreamWriter(StreamWriter, JObj);
        SetupIOMgt.ExportVersion(StreamWriter, JObj, Version_DeviceHierarchy);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DeviceRole);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DeviceGroup);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DeviceSetup);
        case ToFile of true: SetupIOMgt.WriteOutputFile;
        false: SetupIOMgt.ExportBlob(StreamWriter, JObj, Enum::DYM_BackupRestoreType::"Device Hierarchy");
        end;
        SetupIOMgt.CloseStreamWriter;
    end;
    procedure TruncateDeviceHierarchy()
    begin
        SetupIOMgt.TruncateTable(DATABASE::DYM_DeviceRole);
        SetupIOMgt.TruncateTable(DATABASE::DYM_DeviceGroup);
        SetupIOMgt.TruncateTable(DATABASE::DYM_DeviceSetup);
    end;
    #endregion 
    #region MappingIO
    procedure ImportMapping(FromFile: Boolean)
    begin
        if FromFile then Filename:=SetupIOMgt.SelectInputFile;
        SetupIOMgt.OpenStreamReader(StreamReader);
        SetupIOMgt.ImportVersion(StreamReader, Version_Mapping);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileTableMap);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_MobileTableMapFilters);
        SetupIOMgt.CloseStreamReader;
    end;
    procedure ExportMapping(ToFile: Boolean)
    begin
        if not SetupIOMgt.SetExportFormat(ExportFormat)then exit;
        SetupIOMgt.OpenStreamWriter(StreamWriter, JObj);
        SetupIOMgt.ExportVersion(StreamWriter, JObj, Version_Mapping);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileTableMap);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_MobileTableMapFilters);
        case ToFile of true: SetupIOMgt.WriteOutputFile;
        false: SetupIOMgt.ExportBlob(StreamWriter, JObj, Enum::DYM_BackupRestoreType::Mapping);
        end;
        SetupIOMgt.CloseStreamWriter;
    end;
    procedure TruncateMapping()
    begin
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileTableMap);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileFieldMap);
        SetupIOMgt.TruncateTable(DATABASE::DYM_MobileTableMapFilters);
    end;
    #endregion 
    #region LogTablesIO
    procedure ImportLogTables(FromFile: Boolean)
    begin
        if FromFile then Filename:=SetupIOMgt.SelectInputFile;
        SetupIOMgt.OpenStreamReader(StreamReader);
        SetupIOMgt.ImportVersion(StreamReader, Version_DMLog);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_SyncLog);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_DataLog);
        SetupIOMgt.ImportTable(StreamReader, DATABASE::DYM_PostProcessLog);
        SetupIOMgt.CloseStreamReader;
    end;
    procedure ExportLogTables(ToFile: Boolean)
    begin
        SetupIOMgt.SetExportFormat(ExportFormat);
        SetupIOMgt.OpenStreamWriter(StreamWriter, JObj);
        SetupIOMgt.ExportVersion(StreamWriter, JObj, Version_DMLog);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_SyncLog);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_DataLog);
        SetupIOMgt.ExportTable(StreamWriter, JObj, DATABASE::DYM_PostProcessLog);
        case ToFile of true: SetupIOMgt.WriteOutputFile;
        false: SetupIOMgt.ExportBlob(StreamWriter, JObj, Enum::DYM_BackupRestoreType::"Log tables");
        end;
        SetupIOMgt.CloseStreamWriter;
    end;
    procedure TruncateLogTables()
    begin
        SetupIOMgt.TruncateTable(DATABASE::DYM_SyncLog);
        SetupIOMgt.TruncateTable(DATABASE::DYM_DataLog);
        SetupIOMgt.TruncateTable(DATABASE::DYM_PostProcessLog);
    end;
    #endregion 
    [IntegrationEvent(true, false)]
    local procedure SetupIO_OnFullImport(var InS: InStream)
    begin
    end;
    [IntegrationEvent(true, false)]
    local procedure SetupIO_OnFullExport(var OutS: OutStream; JObj: JsonObject)
    begin
    end;
}
