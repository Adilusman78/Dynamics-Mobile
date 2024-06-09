codeunit 84028 DYM_RawDataProcessing
{
    TableNo = DYM_SyncLog;

    trigger OnRun()
    begin
        process(Rec);
    end;
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    GlobalDP: Codeunit DYM_GlobalDataProcess;
    CacheMgt: Codeunit DYM_CacheManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    SessionMgt: Codeunit DYM_SessionManagement;
    XMLMgt: Codeunit DYM_XMLManagement;
    StreamMgt: Codeunit DYM_StreamManagement;
    SLE: Integer;
    SetupRead: Boolean;
    DummyBlob: Codeunit "Temp Blob";
    Text007: Label 'Cannot open %1.';
    Text009: Label 'Packet cheskcum match with Sync Log Entry No. %1.';
    Text013: Label 'Could not find packet for Sync Log Entry No. %1.';
    [CommitBehavior(CommitBehavior::Ignore)]
    procedure process(var Rec: Record DYM_SyncLog)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        CacheMgt.ClearCacheBuffer;
        CacheMgt.ClearStateDescription;
        if((Rec.Direction <> Rec.Direction::Push) or (Rec.Internal))then exit;
        Rec.CalcFields(Packet);
        if not Rec.Packet.HasValue then Error(Text013, Rec."Entry No.");
        if(UpperCase(Rec.Company) <> UpperCase(CompanyName))then Rec.FieldError(Company);
        SLE:=rec."Entry No.";
        Parse();
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, Rec."Entry No.");
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        if Rec.Get(Rec."Entry No.")then begin
            CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
            Rec."Device Role Code":=DeviceRole.Code;
            Rec."Device Group Code":=DeviceGroup.Code;
            Rec."Device Setup Code":=DeviceSetup.Code;
            Rec.Modify;
        end;
    end;
    #region Parsing
    procedure Parse()
    var
        XMLDoc: XmlDocument;
        XMLNodeList: XmlNodeList;
        XMLNode: XmlNode;
        SyncLog: Record DYM_SyncLog;
        InS: InStream;
        i: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        CacheMgt.ClearCacheBuffer;
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        if not SyncLog.Get(SLE)then Clear(SyncLog);
        GlobalDP.testChecksum(syncLog);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if(SLE = 0) and (MobileSetup."Packet Process Retry Enabled")then exit;
        SyncLog.CalcFields(Packet);
        SyncLog.Packet.CreateInStream(InS, TextEncoding::UTF8);
        XmlDocument.ReadFrom(InS, XMLDoc);
        CleanupRawDataLog;
        XMLDoc.SelectSingleNode(ConstMgt.SYN_PrimaryTag, XMLNode);
        ParseAttributes(XMLNode, enum::DYM_RawDataLogEntryType::"Global Attribute", '', 0, '');
        XMLDoc.SelectNodes(ConstMgt.SYN_PrimaryTag + '/' + ConstMgt.SYN_Table, XMLNodeList);
        for i:=1 to XMLNodeList.Count()do begin
            XMLNodeList.Get(i, XMLNode);
            ParseTable(XMLNode);
        end;
        if(not SyncLog."Web Service Entry")then CacheMgt.ClearCacheBuffer;
        CacheMgt.ClearXMLCache;
    end;
    procedure ParseTable(NodeIn: XmlNode)
    var
        RecordNodeList: XmlNodeList;
        RecordNode: XmlNode;
        MobileTableName, TableName: Text[30];
        RecordNo: Integer;
        i: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        MobileTableName:=XMLMgt.GetNodeValue(NodeIn, ConstMgt.SYN_TableName, false);
        TableName:=Mobile2BackendTableName(MobileTableName);
        InsertTableRawDataLogEntry(TableName);
        ParseAttributes(NodeIn, enum::DYM_RawDataLogEntryType::"Table Attribute", TableName, 0, '');
        NodeIn.SelectNodes(ConstMgt.SYN_Record, RecordNodeList);
        for i:=1 to RecordNodeList.Count()do begin
            RecordNo:=i + 1;
            RecordNodeList.Get(i, RecordNode);
            InsertRecordRawDataLogEntry(TableName, RecordNo);
            ParseAttributes(RecordNode, enum::DYM_RawDataLogEntryType::"Record Attribute", TableName, RecordNo, '');
            ParseRecord(RecordNode, MobileTableName, TableName, RecordNo);
        end;
    end;
    procedure ParseRecord(NodeIn: XmlNode; MobileTableName: Text; TableName: Text; RecordNo: Integer)
    var
        FieldNodeList: XmlNodeList;
        FieldNode: XmlNode;
        MobileFieldName, FieldName: Text;
        MobileTableMap: Record DYM_MobileTableMap;
        MobileFieldMap: Record DYM_MobileFieldMap;
        BlobData: Codeunit "Temp Blob";
        //BlobDataInStream: InStream;
        ResultDictionary: Dictionary of[Integer, Text];
        BlobFileName: Text;
        BlobFieldRef: FieldRef;
        i, DictPos: Integer;
    begin
        NodeIn.SelectNodes('*', FieldNodeList);
        for i:=1 to FieldNodeList.Count()do begin
            FieldNodeList.Get(i, FieldNode);
            MobileFieldName:=FieldNode.AsXmlElement().Name;
            clear(ResultDictionary);
            Mobile2BackendFieldName(MobileTableName, MobileFieldName, ResultDictionary);
            for DictPos:=1 to ResultDictionary.Count do begin
                FieldName:=ResultDictionary.Get(DictPos);
                if not CheckTableFieldRawDataLogEntry(TableName, FieldName)then InsertTableFieldRawDataLogEntry(TableName, FieldName);
                if(StrLen(FieldNode.AsXmlElement().InnerText) > RawDataEntryValueMaxLength)then begin
                    clear(BlobData);
                    XMLMgt.GetBinary(NodeIn, MobileFieldName, BlobData);
                    InsertFieldRawDataLogEntry(TableName, RecordNo, FieldName, '', BlobData);
                end
                else
                begin
                    //StreamMgt.initDummyInStream(DummyInStream);
                    InsertFieldRawDataLogEntry(TableName, RecordNo, FieldName, FieldNode.AsXmlElement().InnerText, DummyBlob);
                end;
                ParseAttributes(FieldNode, Enum::DYM_RawDataLogEntryType::"Field Attribute", TableName, RecordNo, FieldName);
            end;
        end;
    end;
    procedure ParseAttributes(NodeIn: XmlNode; EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text)
    var
        AttributeNodeList: XmlNodeList;
        AttributeNode: XmlNode;
        AttributeName: Text;
        AttributeValue: Text;
        i: Integer;
    begin
        NodeIn.SelectNodes('@*', AttributeNodeList);
        for i:=1 to(AttributeNodeList.Count())do begin
            AttributeNodeList.Get(i, AttributeNode);
            AttributeName:=AttributeNode.AsXmlAttribute().Name;
            AttributeValue:=AttributeNode.AsXmlAttribute().Value;
            case EntryType of enum::DYM_RawDataLogEntryType::"Global Attribute": begin
                if(AttributeName = ConstMgt.SYN_DeviceSetup())then BuildContextHierarchy(AttributeValue);
                InsertGlobalAttributeRawDataLogEntry(AttributeName, AttributeValue);
            end;
            enum::DYM_RawDataLogEntryType::"Table Attribute": InsertTableAttributeRawDataLogEntry(TableName, AttributeName, AttributeValue);
            enum::DYM_RawDataLogEntryType::"Record Attribute": InsertRecordAttributeRawDataLogEntry(TableName, RecordNo, AttributeName, AttributeValue);
            enum::DYM_RawDataLogEntryType::"Field Attribute": InsertFieldAttributeRawDataLogEntry(TableName, RecordNo, FieldName, AttributeName, AttributeValue);
            end;
        end;
    end;
    #endregion 
    #region Raw Data Log
    procedure InsertRawDataLogEntry(EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; AttributeName: Text; Value: Text; var BlobData: Codeunit "Temp Blob")
    var
        RawDataLog: Record DYM_RawDataLog;
        BlobDataInStream: InStream;
        OutS: OutStream;
        RecRef: RecordRef;
        FldRef: FieldRef;
        BlobSize: Integer;
    begin
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        RawDataLog.Init;
        Clear(RawDataLog."Entry No.");
        RawDataLog."Sync Log Entry No.":=SLE;
        RawDataLog."Entry Type":=EntryType;
        RawDataLog."Table Name":=TableName;
        RawDataLog."Record No.":=RecordNo;
        RawDataLog."Field Name":=FieldName;
        RawDataLog."Attribute Name":=AttributeName;
        if(StrLen(Value) <= RawDataEntryValueMaxLength)then RawDataLog."Field Value":=Value;
        if(BlobData.HasValue())then begin
            BlobData.CreateInStream(BlobDataInStream, TextEncoding::UTF8);
            RawDataLog."Blob Value".CreateOutStream(OutS, TextEncoding::UTF8);
            CopyStream(OutS, BlobDataInStream);
        end;
        //RawDataLog.Value := Value;
        RawDataLog.Insert;
        RawDataLog.CalcFields("Blob Value");
        BlobSize:=RawDataLog."Blob Value".Length;
    end;
    procedure CheckRawDataLogEntry(EntryType: enum DYM_RawDataLogEntryType; TableName: Text; RecordNo: Integer; FieldName: Text; AttributeName: Text)Result: Boolean var
        RawDataLog: Record DYM_RawDataLog;
    begin
        Clear(Result);
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        RawDataLog.Reset;
        RawDataLog.SetRange("Sync Log Entry No.", SLE);
        RawDataLog.SetRange("Entry Type", EntryType);
        RawDataLog.SetRange("Table Name", TableName);
        RawDataLog.SetRange("Record No.", RecordNo);
        RawDataLog.SetRange("Field Name", FieldName);
        RawDataLog.SetRange("Attribute Name", AttributeName);
        exit(not RawDataLog.IsEmpty);
    end;
    procedure InsertTableRawDataLogEntry(TableName: Text)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::Table, TableName, 0, '', '', '', DummyBlob);
    end;
    procedure InsertTableFieldRawDataLogEntry(TableName: Text; FieldName: Text)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::TableField, TableName, 0, FieldName, '', '', DummyBlob);
    end;
    procedure InsertRecordRawDataLogEntry(TableName: Text; RecordNo: Integer)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::Record, TableName, RecordNo, '', '', '', DummyBlob);
    end;
    procedure InsertFieldRawDataLogEntry(TableName: Text; RecordNo: Integer; FieldName: Text; Value: Text; var BlobData: Codeunit "Temp Blob")
    begin
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::Field, TableName, RecordNo, FieldName, '', Value, BlobData);
    end;
    procedure InsertGlobalAttributeRawDataLogEntry(AttributeName: Text; Value: Text)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Global Attribute", '', 0, '', AttributeName, Value, DummyBlob);
    end;
    procedure InsertTableAttributeRawDataLogEntry(TableName: Text; AttributeName: Text; Value: Text)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Table Attribute", TableName, 0, '', AttributeName, Value, DummyBlob);
    end;
    procedure InsertRecordAttributeRawDataLogEntry(TableName: Text; RecordNo: Integer; AttributeName: Text; Value: Text)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Record Attribute", TableName, RecordNo, '', AttributeName, Value, DummyBlob);
    end;
    procedure InsertFieldAttributeRawDataLogEntry(TableName: Text; RecordNo: Integer; FieldName: Text; AttributeName: Text; Value: Text)
    begin
        //StreamMgt.initDummyInStream(DummyInStream);
        InsertRawDataLogEntry(enum::DYM_RawDataLogEntryType::"Field Attribute", TableName, RecordNo, FieldName, AttributeName, Value, DummyBlob);
    end;
    procedure CheckTableFieldRawDataLogEntry(TableName: Text; FieldName: Text): Boolean begin
        exit(CheckRawDataLogEntry(enum::DYM_RawDataLogEntryType::TableField, TableName, 0, FieldName, ''));
    end;
    procedure RawDataEntryValueMaxLength(): Integer var
        RawDataLog: Record DYM_RawDataLog;
    begin
        exit(MaxStrLen(RawDataLog."Field Value"));
    end;
    #endregion 
    #region Initialize
    procedure CleanupRawDataLog()
    var
        RawDataLog: Record DYM_RawDataLog;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if(SLE = 0)then exit;
        RawDataLog.Reset;
        RawDataLog.SetRange("Sync Log Entry No.", SLE);
        RawDataLog.DeleteAll;
    end;
    procedure BuildContextHierarchy(_DeviceSetupCode: code[100])
    begin
        DeviceSetup.Get(_DeviceSetupCode);
        DeviceGroup.Get(DeviceSetup."Device Group Code");
        DeviceRole.Get(DeviceSetup."Device Role Code");
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
    end;
    #endregion 
    #region Table and Field names conversion
    procedure Mobile2BackendTableName(_TableName: Text)Result: Text var
        MobileTableMap: record DYM_MobileTableMap;
    begin
        Result:=_TableName;
        MobileTableMap.Reset();
        MobileTableMap.SetRange("Device Role Code", DeviceRole.Code);
        MobileTableMap.SetRange("Mobile Table", _TableName);
        MobileTableMap.SetRange(Disabled, false);
        MobileTableMap.SetFilter(Direction, '%1|%2', MobileTableMap.Direction::Push, MobileTableMap.Direction::Both);
        if MobileTableMap.FindFirst()then Result:=LowLevelDP.ValidateText(LowLevelDP.GetTableName(MobileTableMap."Table No."));
    end;
    procedure Mobile2BackendFieldName(_TableName: Text; _FieldName: Text; var ResultDictionary: Dictionary of[Integer, Text])
    var
        MobileTableMap: record DYM_MobileTableMap;
        MobileFieldMap: record DYM_MobileFieldMap;
        Result: Text;
        i: Integer;
    begin
        clear(ResultDictionary);
        Result:=_FieldName;
        Clear(i);
        MobileTableMap.Reset();
        MobileTableMap.SetRange("Device Role Code", DeviceRole.Code);
        MobileTableMap.SetRange("Mobile Table", _TableName);
        MobileTableMap.SetRange(Disabled, false);
        MobileTableMap.SetFilter(Direction, '%1|%2', MobileTableMap.Direction::Push, MobileTableMap.Direction::Both);
        if MobileTableMap.FindFirst()then begin
            MobileFieldMap.Reset();
            MobileFieldMap.SetRange("Device Role Code", MobileTableMap."Device Role Code");
            MobileFieldMap.SetRange("Table No.", MobileTableMap."Table No.");
            MobileFieldMap.SetRange("Table Index", MobileTableMap.Index);
            MobileFieldMap.SetRange("Mobile Field", _FieldName);
            MobileFieldMap.SetRange(Disabled, false);
            MobileFieldMap.SetFilter(Direction, '%1|%2', MobileFieldMap.Direction::Push, MobileFieldMap.Direction::Both);
            if MobileFieldMap.FindSet()then repeat Result:=LowLevelDP.ValidateText(LowLevelDP.GetFieldName(MobileFieldMap."Table No.", MobileFieldMap."Field No."));
                    if((MobileFieldMap."Const Value Type" = MobileFieldMap."Const Value Type"::" ") AND (MobileFieldMap."Const Value" <> ''))then Result:=MobileFieldMap."Const Value";
                    i+=1;
                    ResultDictionary.Add(i, Result);
                until MobileFieldMap.Next() = 0;
        end;
        //if (ResultDictionary.Count = 0) then begin
        i+=1;
        ResultDictionary.Add(i, Result);
    //end;
    end;
#endregion 
}
