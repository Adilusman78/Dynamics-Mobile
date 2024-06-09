codeunit 84011 DYM_StatisticsManagement
{
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    GlobalDP: Codeunit DYM_GlobalDataProcess;
    XMLMgt: Codeunit DYM_XMLManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
    SetupRead: Boolean;
    SLE: Integer;
    Text001: Label 'No packet found for Sync Log Entry No. [%1].';
    Text002: Label 'You should be in company [%1] in order to navigate this packet.';
    Text003: Label 'Attempt to use non-temporary table buffer [%1]. Please contact your system administrator.';
    #region Statistics
    procedure GetStatistics(SyncLog: Record DYM_SyncLog; var DeviceRoleCode: Code[20]; var DeviceGroupCode: Code[20]; var DeviceSetupCode: Code[100]; var RecStats: Record "Dimension Selection Buffer")Result: Boolean var
        PullType: enum DYM_PullType;
        Challenge: Boolean;
        InS: InStream;
        i: Integer;
        ActiveTableRec: Codeunit DYM_ActiveRecManagement;
    begin
        Clear(Result);
        SyncLog.TestField(Direction, SyncLog.Direction::Push);
        SyncLog.TestField(Internal, false);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        RecStats.Reset;
        RecStats.DeleteAll;
        CacheMgt.SetContextSLE(SyncLog."Entry No.");
        Clear(GlobalDP);
        GlobalDP.GetSyncParams(PullType, Challenge);
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        DeviceRoleCode:=DeviceRole.Code;
        DeviceGroupCode:=DeviceGroup.Code;
        DeviceSetupCode:=DeviceSetup.Code;
        if ActiveTableRec.FindTable then repeat RecStats.Init;
                RecStats.Code:=ActiveTableRec.GetTableName;
                RecStats.Level:=ActiveTableRec.TableRecordsCount;
                RecStats.Insert;
            until not ActiveTableRec.NextTable;
        exit;
    end;
    procedure ReadPacketData(SyncLog: Record DYM_SyncLog; TableName: Text[30]; var Data: Record DYM_CacheBuffer)Result: Boolean var
        TableMap: Record DYM_MobileTableMap;
        FieldMap: Record DYM_MobileFieldMap;
        RawPreviewPage: Page DYM_RawPacketDataPreview;
        PullType: enum DYM_PullType;
        Challenge: Boolean;
        InS: InStream;
        TableNo: Integer;
        RowNo: Integer;
        FieldNo: Integer;
        Str: Text;
        PacketTables: Codeunit DYM_ActiveRecManagement;
        PacketRecords: Codeunit DYM_ActiveRecManagement;
        PacketFields: Codeunit DYM_ActiveRecManagement;
    begin
        Clear(Result);
        SyncLog.TestField(Direction, SyncLog.Direction::Push);
        SyncLog.TestField(Internal, false);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Data.Reset;
        Data.DeleteAll;
        CacheMgt.SetContextSLE(SyncLog."Entry No.");
        Clear(GlobalDP);
        GlobalDP.GetSyncParams(PullType, Challenge);
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        PacketRecords.ReadTable(TableName);
        if PacketRecords.FindRecord then repeat Clear(FieldNo);
                RowNo+=1;
                if PacketFields.FindField(TableName)then repeat FieldNo+=1;
                        Data.Init;
                        Data."Mobile Field":=PacketFields.GetFieldName;
                        Data."Record ID":=Format(RowNo);
                        Str:=PacketRecords.TextField(PacketFields.GetFieldName);
                        if(StrLen(Str) <= MaxStrLen(Data.Data))then Data.Data:=Str
                        else
                            Data.Data:=ConstMgt.STA_HaveLongValue;
                        Data.Editable:=CheckFieldEditable(TableName, Data."Mobile Field");
                        Data.Insert;
                    until not PacketFields.NextField;
            until not PacketRecords.NextRecord;
        Clear(RawPreviewPage);
        RawPreviewPage.SetData(DeviceRole.Code, TableName, RowNo, Data);
        RawPreviewPage.RunModal;
    end;
    #endregion 
    #region Navigation
    procedure PreNavigate(SyncLog: Record DYM_SyncLog)
    begin
        if(SyncLog.Company <> CompanyName)then Error(Text002, SyncLog.Company);
        SyncLog.TestField(Direction, SyncLog.Direction::Push);
        SyncLog.TestField(Internal, false);
        SyncLog.TestField(Status, SyncLog.Status::Success);
    end;
    procedure SmartNavigate(SyncLog: Record DYM_SyncLog)
    var
        RecStats: Record "Dimension Selection Buffer" temporary;
        AddDataLog: Record DYM_DataLog temporary;
        DataLog: Record DYM_DataLog;
        PageManagement: Codeunit "Page Management";
        RecRef: RecordRef;
        PageRecVariant: Variant;
        DataLogTableDict: Dictionary of[Integer, Boolean];
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PreNavigate(SyncLog);
        DataLog.Reset();
        DataLog.SetCurrentKey("Sync Log Entry No.", "Table No.");
        DataLog.SetRange("Sync Log Entry No.", SyncLog."Entry No.");
        if DataLog.FindSet()then repeat if not DataLogTableDict.ContainsKey(DataLog."Table No.")then DataLogTableDict.Add(DataLog."Table No.", false);
                GetPostedDocuments(RecStats, AddDataLog, DataLog."Table No.", DataLog.Position);
            until DataLog.Next() = 0;
        AddDataLog.Reset();
        if AddDataLog.FindSet()then repeat if not DataLogTableDict.ContainsKey(AddDataLog."Table No.")then DataLogTableDict.Add(AddDataLog."Table No.", true);
            until AddDataLog.Next() = 0;
        DataLog.Reset();
        DataLog.SetCurrentKey("Sync Log Entry No.", "Table No.");
        DataLog.SetRange("Sync Log Entry No.", SyncLog."Entry No.");
        DataLog.SetRange("Table No.", DataLogNavigateTableListSelector(DataLogTableDict, false));
        if DataLog.FindLast()then begin
            Clear(RecRef);
            RecRef.Open(DataLog."Table No.");
            RecRef.SetPosition(DataLog.Position);
            if RecRef.Find()then ShowSingleRecRefDefaultPage(RecRef);
        end;
        AddDataLog.Reset();
        AddDataLog.SetRange("Table No.", DataLogNavigateTableListSelector(DataLogTableDict, true));
        if AddDataLog.FindLast()then begin
            clear(RecRef);
            RecRef.Open(AddDataLog."Table No.");
            RecRef.SetPosition(AddDataLog.Position);
            if RecRef.Find()then ShowSingleRecRefDefaultPage(RecRef);
        end;
    end;
    procedure DataLogNavigateTableListSelector(_DataLogTablesList: Dictionary of[Integer, Boolean]; _SourceType: Boolean)Result: Integer begin
        clear(Result);
        //The last found table is returned e.g. place unposted tables before posted ones
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Sales Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Sales Invoice Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Gen. Journal Line", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Transfer Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Transfer Shipment Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Transfer Receipt Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Warehouse Activity Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Warehouse Receipt Header", Result);
        DataLogNavigateTableListCheck(_DataLogTablesList, _SourceType, Database::"Warehouse Shipment Header", Result);
    end;
    procedure DataLogNavigateTableListCheck(_DataLogTablesList: Dictionary of[Integer, Boolean]; _SourceType: Boolean; _TableId: Integer; var Result: Integer)
    begin
        if(_DataLogTablesList.ContainsKey(_TableId))then if(_DataLogTablesList.Get(_TableId) = _SourceType)then Result:=_TableId;
    end;
    procedure GetNavigation(SyncLog: Record DYM_SyncLog; var RecStats: Record "Dimension Selection Buffer"; var AddDataLog: Record DYM_DataLog; FillBuffer: Boolean)Result: Boolean var
        DataLog: Record DYM_DataLog;
    begin
        Clear(Result);
        PreNavigate(SyncLog);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        DataLog.Reset;
        DataLog.SetCurrentKey("Sync Log Entry No.", "Table No.");
        DataLog.SetRange("Sync Log Entry No.", SyncLog."Entry No.");
        if DataLog.FindSet(false, false)then repeat DataLog.SetRange("Table No.", DataLog."Table No.");
                InsertRecStat(DataLog."Table No.", DataLog.Count, RecStats);
                GetPostedDocuments(RecStats, AddDataLog, DataLog."Table No.", DataLog.Position);
                if DataLog.FindLast then DataLog.SetRange("Table No.");
            until DataLog.Next = 0;
        Commit;
    end;
    procedure GetPostedDocuments(var _RecStats: Record "Dimension Selection Buffer"; var _AddDataLog: Record DYM_DataLog; _TableNo: Integer; _Position: Text)
    var
        RecRef: RecordRef;
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        TransferHeader: Record "Transfer Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        WhseActivityHeader: Record "Warehouse Activity Header";
        RegWhseActivityHeader: Record "Registered Whse. Activity Hdr.";
    begin
        case _TableNo of Database::"Sales Header": begin
            SalesHeader.SetPosition(_Position);
            case SalesHeader."Document Type" of SalesHeader."Document Type"::Order: begin
                SalesInvHeader.Reset();
                SalesInvHeader.SetCurrentKey("Order No.");
                SalesInvHeader.SetRange("Order No.", SalesHeader."No.");
                RecRef.GetTable(SalesInvHeader);
                UpdateAddDataLog(_RecStats, _AddDataLog, RecRef);
            end;
            SalesHeader."Document Type"::Invoice: begin
                SalesInvHeader.Reset();
                SalesInvHeader.SetCurrentKey("Pre-Assigned No.");
                SalesInvHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
                RecRef.GetTable(SalesInvHeader);
                UpdateAddDataLog(_RecStats, _AddDataLog, RecRef);
            end;
            end;
        end;
        Database::"Transfer Header": begin
            TransferHeader.SetPosition(_Position);
            TransferShipmentHeader.Reset();
            TransferShipmentHeader.SetRange("Transfer Order No.", TransferHeader."No.");
            RecRef.GetTable(TransferShipmentHeader);
            UpdateAddDataLog(_RecStats, _AddDataLog, RecRef);
            TransferReceiptHeader.Reset();
            TransferReceiptHeader.SetRange("Transfer Order No.", TransferHeader."No.");
            RecRef.GetTable(TransferReceiptHeader);
            UpdateAddDataLog(_RecStats, _AddDataLog, RecRef);
        end;
        Database::"Warehouse Activity Header": begin
            WhseActivityHeader.SetPosition(_Position);
            RegWhseActivityHeader.Reset();
            RegWhseActivityHeader.SetCurrentKey("Whse. Activity No.");
            RegWhseActivityHeader.SetRange("Whse. Activity No.", WhseActivityHeader."No.");
            RecRef.GetTable(RegWhseActivityHeader);
            UpdateAddDataLog(_RecStats, _AddDataLog, RecRef);
        end;
        end;
    end;
    procedure UpdateAddDataLog(var _RecStats: Record "Dimension Selection Buffer"; var _AddDataLog: Record DYM_DataLog; var _RecRef: RecordRef)
    begin
        if _RecRef.FindSet()then begin
            InsertRecStat(_RecRef.Number, _RecRef.Count, _RecStats);
            repeat InsertAddDataLog(_AddDataLog, _RecRef.Number, _RecRef.GetPosition());
            until _RecRef.Next() = 0;
        end;
    end;
    procedure DrillDownRecStat(SyncLog: Record DYM_SyncLog; var RecStats: Record "Dimension Selection Buffer"; var AddDataLog: Record DYM_DataLog)
    var
        DataLog: Record DYM_DataLog;
        RecRef: RecordRef;
        RecRefVar: Variant;
        IsHandled: Boolean;
        RecordsFound: Boolean;
    begin
        PreNavigate(SyncLog);
        Clear(IsHandled);
        OnDrillDownRecStat(SyncLog, RecStats, IsHandled);
        if IsHandled then exit;
        Clear(RecordsFound);
        //Search directly logged records in DataLog
        Clear(RecRef);
        RecRef.Open(RecStats.Level);
        DataLog.Reset;
        DataLog.SetCurrentKey("Sync Log Entry No.", "Table No.");
        DataLog.SetRange("Sync Log Entry No.", SyncLog."Entry No.");
        DataLog.SetRange("Table No.", RecStats.Level);
        if DataLog.FindSet(false, false)then repeat RecRef.SetPosition(DataLog.Position);
                RecRef.Mark(true);
                RecordsFound:=true;
            until DataLog.Next = 0;
        if(RecordsFound)then begin
            ShowMarkedRecRefDefaultPage(RecRef);
        end
        else
        begin
            //Search additional DataLog from posted documents
            Clear(RecRef);
            RecRef.Open(AddDataLog."Table No.");
            AddDataLog.Reset;
            AddDataLog.SetCurrentKey("Sync Log Entry No.", "Table No.");
            AddDataLog.SetRange("Table No.", RecStats.Level);
            if AddDataLog.FindSet(false, false)then repeat RecRef.SetPosition(AddDataLog.Position);
                    RecRef.Mark(true);
                    RecordsFound:=true;
                until AddDataLog.Next() = 0;
            if(RecordsFound)then ShowMarkedRecRefDefaultPage(RecRef);
        end;
    end;
    procedure ShowSingleRecRefDefaultPage(var RecRef: RecordRef)
    var
        PageManagement: Codeunit "Page Management";
    begin
        RecRef.SetRecFilter();
        PageManagement.PageRun(RecRef);
    end;
    procedure ShowMarkedRecRefDefaultPage(var RecRef: RecordRef)
    var
        RecRefVar: Variant;
    begin
        RecRef.MarkedOnly(true);
        RecRefVar:=RecRef;
        Page.RunModal(0, RecRefVar);
    end;
    procedure InsertRecStat(TableNo: Integer; RecCount: Integer; var RecStats: Record "Dimension Selection Buffer")
    begin
        RecStats.Init;
        RecStats.Code:=CopyStr(LowLevelDP.GetTableName(TableNo), 1, MaxStrLen(RecStats.Code));
        RecStats.Level:=TableNo;
        RecStats."Filter Lookup Table No.":=RecCount;
        RecStats.Insert;
    end;
    procedure InsertAddDataLog(var _AddDataLog: Record DYM_DataLog; TableNo: Integer; Position: Text)
    var
        NextEntryNo: Integer;
    begin
        if not _AddDataLog.IsTemporary then error(Text003);
        _AddDataLog.Reset();
        if _AddDataLog.FindLast()then NextEntryNo:=_AddDataLog."Entry No.";
        NextEntryNo+=1;
        Clear(_AddDataLog);
        _AddDataLog.Init();
        _AddDataLog."Entry No.":=NextEntryNo;
        _AddDataLog."Table No.":=TableNo;
        _AddDataLog.Position:=Position;
        _AddDataLog.Insert();
    end;
    #endregion 
    #region Checks
    procedure calcStreamChecksum(_inStream: InStream): Text var
        CryptMgt: Codeunit "Cryptography Management";
    begin
        exit(CryptMgt.GenerateHash(_inStream, 0)); //MD5,SHA1,SHA256,SHA384,SHA512
    end;
    procedure CheckFieldEditable(TableName: Text; FieldName: Text)Result: Boolean var
        MobileFieldMap: Record DYM_MobileFieldMap;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        MobileFieldMap.Reset;
        MobileFieldMap.SetFilter(Direction, '%1|%2', MobileFieldMap.Direction::Push, MobileFieldMap.Direction::Both);
        MobileFieldMap.SetRange("Device Role Code", DeviceRole.Code);
        MobileFieldMap.SetRange("Mobile Table", TableName);
        MobileFieldMap.SetRange("Mobile Field", FieldName);
        if MobileFieldMap.FindFirst then exit(MobileFieldMap."Raw Data Editable");
    end;
    #endregion 
    [IntegrationEvent(false, false)]
    procedure OnDrillDownRecStat(SyncLog: Record DYM_SyncLog; var RecStats: Record "Dimension Selection Buffer"; var IsHandled: Boolean)
    begin
    end;
}
