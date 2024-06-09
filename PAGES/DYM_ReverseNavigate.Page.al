page 70162 DYM_ReverseNavigate
{
    Caption = 'Reverse Navigate';
    PageType = NavigatePage;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(SearchGroup)
            {
                ShowCaption = false;

                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';

                    trigger OnValidate()
                    begin
                        ReverseNavigate;
                    end;
                }
            }
            part(DeviceSetupSubPage; DYM_RevNavDeviceSetupSubPage)
            {
                ApplicationArea = All;
            }
            part(SyncLogSubPage; DYM_RevNavSyncLogSubPage)
            {
                ApplicationArea = All;
            }
            part(DataLogSubPage; DYM_RevNavDataLogSubpage)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(RevNav)
            {
                ApplicationArea = All;
                Caption = 'Reverse Navigate';
                Image = Navigate;

                trigger OnAction()
                begin
                    ReverseNavigate;
                end;
            }
        }
    }
    var
        SettingsMgt: Codeunit DYM_SettingsManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        DeviceSetupBuffer: Record DYM_DeviceSetup temporary;
        SyncLogBuffer: Record DYM_SyncLog temporary;
        DataLogBuffer: Record DYM_DataLog temporary;
        MissingData: Boolean;
        DateFilter: Text;
        DateFilterSyncLogEntryNo: Integer;
        DocumentNo: Code[20];
        Text001: Label 'Missing data is found during reverse navigation process.';
        Text002: Label 'Reverse Navigation results:\ \Document No. : %1\Devices : %2\Sync Log Entries : %3\Data Log Entries : %4';
        Text003: Label 'Please use more accurate search criteria.';
        Text004: Label 'No entries found with date filter [%1].\Use [%2] setting to override.';
        DefaultDateFilter: Label '-1M', Locked = true;

    procedure ReverseNavigate()
    var
        DeviceSetup: Record DYM_DeviceSetup;
        SyncLog: Record DYM_SyncLog;
        DataLog: Record DYM_DataLog;
        RawDataLog: Record DYM_RawDataLog;
    begin
        if (StrLen(DocumentNo) < 5) then error(Text003);
        if (DocumentNo <> '') then begin
            ClearBuffers();
            DateFilter := SettingsMgt.GetGlobalSetting(ConstMgt.BOS_ReverseNavigateDateFilter());
            if (DateFilter = '') then DateFilter := DefaultDateFilter;
            Clear(DateFilterSyncLogEntryNo);
            SyncLog.Reset();
            SyncLog.SetFilter("Entry TimeStamp", '>%1', CreateDateTime(CalcDate(DateFilter), 0T));
            if SyncLog.FindFirst() then DateFilterSyncLogEntryNo := SyncLog."Entry No.";
            RawDataLog.Reset();
            RawDataLog.SetCurrentKey("Sync Log Entry No.", "Entry Type", "Table Name", "Record No.", "Field Name", "Attribute Name", "Field Value");
            if (DateFilterSyncLogEntryNo <> 0) then RawDataLog.SetFilter("Sync Log Entry No.", '>%1', DateFilterSyncLogEntryNo);
            RawDataLog.SetRange("Entry Type", RawDataLog."Entry Type"::Field);
            RawDataLog.SetRange("Field Value", DocumentNo);
            if RawDataLog.FindSet() then
                repeat
                    UpdateBuffers(RawDataLog."Sync Log Entry No.");
                    RawDataLog.SetRange("Sync Log Entry No.", RawDataLog."Sync Log Entry No.");
                    RawDataLog.FindLast();
                    RawDataLog.SetRange("Sync Log Entry No.");
                until RawDataLog.Next() = 0;
            DataLog.Reset;
            DataLog.SetCurrentKey(Position);
            DataLog.SetFilter(Position, StrSubstNo('*%1*', DocumentNo));
            if (DateFilterSyncLogEntryNo <> 0) then DataLog.SetFilter("Sync Log Entry No.", '>%1', DateFilterSyncLogEntryNo);
            if DataLog.FindSet(false, false) then
                repeat
                    DataLogBuffer.Init;
                    DataLogBuffer.TransferFields(DataLog, true);
                    DataLogBuffer.Insert;
                    UpdateBuffers(DataLog."Sync Log Entry No.");
                until DataLog.Next = 0;
            UpdateSubPages();
        end;
    end;

    local procedure ClearBuffers()
    begin
        DeviceSetupBuffer.Reset;
        if DeviceSetupBuffer.IsTemporary then DeviceSetupBuffer.DeleteAll;
        SyncLogBuffer.Reset;
        if SyncLogBuffer.IsTemporary then SyncLogBuffer.DeleteAll;
        DataLogBuffer.Reset;
        if DataLogBuffer.IsTemporary then DataLogBuffer.DeleteAll;
    end;

    local procedure UpdateBuffers(SyncLogEntryNo: Integer)
    var
        SyncLog: Record DYM_SyncLog;
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        if not SyncLogBuffer.Get(SyncLogEntryNo) then begin
            if not SyncLog.Get(SyncLogEntryNo) then MissingData := true;
            SyncLogBuffer.Init;
            SyncLogBuffer.TransferFields(SyncLog, true);
            SyncLogBuffer.Insert;
            if not DeviceSetupBuffer.Get(SyncLog."Device Setup Code") then begin
                if not DeviceSetup.Get(SyncLog."Device Setup Code") then MissingData := true;
                DeviceSetupBuffer.Init;
                DeviceSetupBuffer.TransferFields(DeviceSetup, true);
                DeviceSetupBuffer.Insert;
            end;
        end;
    end;

    local procedure UpdateSubPages()
    var
        DeviceSetupRecCount: Integer;
        SyncLogRecCount: Integer;
        DataLogRecCount: Integer;
    begin
        Clear(DeviceSetupRecCount);
        Clear(SyncLogRecCount);
        Clear(DataLogRecCount);
        DeviceSetupBuffer.Reset;
        SyncLogBuffer.Reset;
        DataLogBuffer.Reset;
        DeviceSetupRecCount := DeviceSetupBuffer.Count;
        SyncLogRecCount := SyncLogBuffer.Count;
        DataLogRecCount := DataLogBuffer.Count;
        CurrPage.DeviceSetupSubPage.PAGE.TransferSyncLogBuffer(DeviceSetupBuffer);
        CurrPage.DeviceSetupSubPage.PAGE.Refresh;
        CurrPage.SyncLogSubPage.PAGE.TransferSyncLogBuffer(SyncLogBuffer);
        CurrPage.SyncLogSubPage.PAGE.Refresh;
        CurrPage.DataLogSubPage.PAGE.TransferDataLogBuffer(DataLogBuffer);
        CurrPage.DataLogSubPage.PAGE.Refresh;
        if MissingData then Message(Text001);
        if ((DeviceSetupRecCount <> 0) or (SyncLogRecCount <> 0) or (DataLogRecCount <> 0)) then
            Message(Text002, DocumentNo, DeviceSetupRecCount, SyncLogRecCount, DataLogRecCount)
        else
            Message(Text004, DateFilter, ConstMgt.BOS_ReverseNavigateDateFilter());
    end;
}
