codeunit 70106 DYM_CacheManagement
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;
    var DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    CacheBuffer: Record DYM_CacheBuffer temporary;
    FieldMap: Record DYM_MobileFieldMap;
    ConstMgt: Codeunit DYM_ConstManagement;
    XMLCacheDoc: XmlDocument;
    StateDescription: Text[250];
    SLE: Integer; //Sync Log Entry context
    PPE: Integer; // Post Processing Entry context
    BSE: Integer; // BlobStore Entry context
    RecNo: Integer;
    CheckPoint: Boolean;
    ErrorCode, OperationData, OperationHint: Text[250];
    //Performance Counters
    PerformanceCounter: Integer;
    PerformanceData: Dictionary of[Integer, DateTime];
    //Table metadata
    TableMetadata: Dictionary of[Text, Dictionary of[Integer, Integer]];
    #region Setup
    procedure GetSetup(var _MobileSetup: Record DYM_DynamicsMobileSetup; var _DeviceRole: Record DYM_DeviceRole; var _DeviceGroup: Record DYM_DeviceGroup; var _DeviceSetup: Record DYM_DeviceSetup; var _SLE: Integer; var _SetupRead: Boolean)
    begin
        if((_SetupRead) and (not GetCheckPoint))then exit;
        _MobileSetup.Get;
        GetContext(_DeviceRole, _DeviceGroup, _DeviceSetup, _SLE);
        _SetupRead:=true;
    end;
    procedure GetSetup_NoContext(var _MobileSetup: Record DYM_DynamicsMobileSetup; var _SetupRead: Boolean)
    begin
        if((_SetupRead) and (not GetCheckPoint))then exit;
        _MobileSetup.Get;
        _SetupRead:=true;
    end;
    #endregion 
    #region Context
    procedure SetContext(var l_DeviceRole: Record DYM_DeviceRole; var l_DeviceGroup: Record DYM_DeviceGroup; var l_DeviceSetup: Record DYM_DeviceSetup; l_SLE: Integer)
    begin
        DeviceRole:=l_DeviceRole;
        DeviceGroup:=l_DeviceGroup;
        DeviceSetup:=l_DeviceSetup;
        SLE:=l_SLE;
    end;
    procedure SetContextByCodes(l_DeviceRoleCode: Code[20]; l_DeviceGroupCode: Code[20]; l_DeviceSetupCode: Code[100])
    begin
        if not DeviceRole.Get(l_DeviceRoleCode)then Clear(DeviceRole);
        if not DeviceGroup.Get(l_DeviceGroupCode)then Clear(DeviceGroup);
        if not DeviceSetup.Get(l_DeviceSetupCode)then Clear(DeviceSetup);
    end;
    procedure GetContext(var l_DeviceRole: Record DYM_DeviceRole; var l_DeviceGroup: Record DYM_DeviceGroup; var l_DeviceSetup: Record DYM_DeviceSetup; var l_SLE: Integer)
    begin
        l_DeviceRole:=DeviceRole;
        l_DeviceGroup:=DeviceGroup;
        l_DeviceSetup:=DeviceSetup;
        l_SLE:=SLE;
    end;
    procedure ClearContext()
    begin
        Clear(DeviceRole);
        Clear(DeviceGroup);
        Clear(DeviceSetup);
        Clear(SLE);
    end;
    #endregion 
    #region Sync Log Entry context
    procedure SetContextSLE(_SLE: Integer)
    begin
        SLE:=_SLE;
    end;
    procedure GetContextSLE()Result: Integer begin
        exit(SLE);
    end;
    procedure ClearContextSLE()
    begin
        Clear(SLE);
    end;
    #endregion 
    #region Post Processing Context
    procedure SetContextPPE(_PPE: Integer)
    begin
        PPE:=_PPE;
    end;
    procedure GetContextPPE()Result: Integer begin
        exit(PPE);
    end;
    procedure ClearContextPPE()
    begin
        Clear(PPE);
    end;
    #endregion 
    #region BlobStore Entry context
    procedure SetContextBSE(_BSE: Integer)
    begin
        BSE:=_BSE;
    end;
    procedure GetContextBSE()Result: Integer begin
        exit(BSE);
    end;
    procedure ClearContextBSE()
    begin
        Clear(BSE);
    end;
    #endregion 
    #region Processing Context
    procedure SetFieldMapContext(var l_FieldMap: Record DYM_MobileFieldMap)
    begin
        FieldMap:=l_FieldMap;
    end;
    procedure GetFieldMapContext(var l_FieldMap: Record DYM_MobileFieldMap)
    begin
        l_FieldMap:=FieldMap;
    end;
    procedure ClearFieldMapContext()
    begin
        Clear(FieldMap);
    end;
    procedure SetRecNoContext(l_RecNo: Integer)
    begin
        RecNo:=l_RecNo;
    end;
    procedure GetRecNoContext()Result: Integer begin
        exit(RecNo);
    end;
    procedure ClearRecNoContext()
    begin
        Clear(RecNo);
    end;
    #endregion 
    #region XML Cache
    procedure GetXMLCache(var XMLDoc: XmlDocument)
    var
        b: text;
    begin
        //XMLDom := XMLCacheDom.CloneNode(true);
        //XMLDoc := XmlDocument.Create(XMLCacheDoc);
        XMLCacheDoc.WriteTo(b);
        XmlDocument.ReadFrom(b, XMLDoc);
    end;
    procedure SetXMLCache(var XMLDoc: XmlDocument)
    var
        InS: InStream;
        OutS: OutStream;
        b: text;
    begin
        //if IsNull(XMLCacheDom) then
        //    XMLCacheDom := XMLCacheDom.XmlDocument();
        //XMLCacheDom := XMLDom.CloneNode(true);
        //XMLCacheDoc := XmlDocument.Create(XMLDoc);
        XMLDoc.WriteTo(b);
        XmlDocument.ReadFrom(b, XMLCacheDoc);
    end;
    procedure CheckXMLCache()Result: Boolean var
        NodeList: XmlNodeList;
    begin
        //Clear(Result);
        //exit(not IsNull(XMLCacheDom));
        //Result := not XMLCacheDoc.AsXmlNode().AsXmlElement().IsEmpty();
        XMLCacheDoc.SelectNodes('*', NodeList);
        Result:=NodeList.Count() > 0;
    end;
    procedure ClearXMLCache()
    begin
        //Clear(XMLCacheDom);
        XMLCacheDoc:=XmlDocument.Create('');
    end;
    #endregion 
    #region Cache Buffer
    procedure GetCacheBufferEntry(TableNo: Integer; TableIndex: Integer; TableName: Text[30]; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[250]; Direction: enum DYM_PacketDirection)Result: Text[250]begin
        Clear(Result);
        if CacheBuffer.Get(TableNo, TableIndex, TableName, FieldNo, FieldIndex, MobileField, RecID, Direction)then exit(CacheBuffer.Data);
    end;
    procedure SetCacheBufferEntry(TableNo: Integer; TableIndex: Integer; TableName: Text[30]; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[150]; Direction: enum DYM_PacketDirection; Data: Text[250])
    begin
        CacheBuffer.Init;
        CacheBuffer."Table No.":=TableNo;
        CacheBuffer."Table Index":=TableIndex;
        CacheBuffer."Table Name":=TableName;
        CacheBuffer."Field No.":=FieldNo;
        CacheBuffer."Field Index":=FieldIndex;
        CacheBuffer."Mobile Field":=MobileField;
        CacheBuffer."Record ID":=RecID;
        CacheBuffer.Direction:=Direction;
        CacheBuffer.Data:=Data;
        if not CacheBuffer.Insert then CacheBuffer.Modify;
    end;
    procedure CheckCacheBufferEntry(TableNo: Integer; TableIndex: Integer; TableName: Text[30]; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[150])Result: Boolean begin
        exit(CacheBuffer.Get(TableNo, TableIndex, TableName, FieldNo, FieldIndex, MobileField, RecID));
    end;
    procedure ClearCacheBuffer()
    begin
        CacheBuffer.Reset;
        CacheBuffer.DeleteAll;
    end;
    procedure UpdateCacheBuffer(TableNo: Integer; TableIndex: Integer; RecID: Text[200]; Direction: enum DYM_PacketDirection; Data: Text[250])
    var
        CacheBufferTemp: Record DYM_CacheBuffer temporary;
    begin
        CacheBufferTemp.Reset;
        CacheBufferTemp.DeleteAll;
        CacheBuffer.Reset;
        CacheBuffer.SetRange("Table No.", TableNo);
        CacheBuffer.SetRange("Table Index", TableIndex);
        CacheBuffer.SetRange("Record ID", '');
        CacheBuffer.SetRange(Direction, Direction);
        CacheBuffer.SetRange(Data, Data);
        if CacheBuffer.FindSet(false, false)then repeat CacheBufferTemp.Init;
                CacheBufferTemp.TransferFields(CacheBuffer, true);
                CacheBufferTemp.Insert;
            until CacheBuffer.Next = 0;
        CacheBuffer.DeleteAll;
        CacheBufferTemp.Reset;
        if CacheBufferTemp.FindSet(false, false)then repeat CacheBuffer.Init;
                CacheBuffer.TransferFields(CacheBufferTemp, true);
                CacheBuffer."Record ID":=RecID;
                CacheBuffer.Data:=Data;
                CacheBuffer.Insert;
            until CacheBufferTemp.Next = 0;
        CacheBufferTemp.DeleteAll;
    end;
    procedure CacheBufferRecID()Result: Text[150]begin
        Clear(Result);
        exit(CacheBuffer."Record ID");
    end;
    procedure CacheBufferData()Result: Text[250]begin
        Clear(Result);
        exit(CacheBuffer.Data);
    end;
    #endregion 
    #region Fields Cache
    procedure GetFlowField(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, '', RecID, enum::DYM_PacketDirection::Pull));
    end;
    procedure SetFlowField(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, '', RecID, enum::DYM_PacketDirection::Pull, Data);
    end;
    procedure GetLookupField(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Pull));
    end;
    procedure SetLookupField(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Pull, Data);
    end;
    procedure GetInternalField(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Pull));
    end;
    procedure SetInternalField(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Pull, Data);
    end;
    procedure CacheBufferFieldName()Result: Text[250]begin
        CLEAR(Result);
        EXIT(CacheBuffer."Mobile Field");
    end;
    #endregion 
    #region Flags Cache
    procedure GetGlobalFlag(RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(0, 0, '', 0, 0, '', RecID, enum::DYM_PacketDirection::Push));
    end;
    procedure SetGlobalFlag(RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(0, 0, '', 0, 0, '', RecID, enum::DYM_PacketDirection::Push, Data);
    end;
    procedure CheckGlobalFlag(RecID: Text[250]; Data: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(0, 0, '', 0, 0, '', RecID, enum::DYM_PacketDirection::Push) = Data);
    end;
    procedure GetTableNameFlag(TableName: Text[30]; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(0, 0, TableName, 0, 0, '', RecID, enum::DYM_PacketDirection::Push));
    end;
    procedure SetTableNameFlag(TableName: Text[30]; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(0, 0, TableName, 0, 0, '', RecID, enum::DYM_PacketDirection::Push, Data);
    end;
    procedure CheckTableNameFlag(TableName: Text[30]; RecID: Text[250]; Data: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(0, 0, TableName, 0, 0, '', RecID, enum::DYM_PacketDirection::Push) = Data);
    end;
    procedure GetTableMapFlag(TableNo: Integer; TableIndex: Integer; TableName: Text[30]; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, TableName, 0, 0, '', RecID, enum::DYM_PacketDirection::Push));
    end;
    procedure SetTableMapFlag(TableNo: Integer; TableIndex: Integer; TableName: Text[30]; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(TableNo, TableIndex, TableName, 0, 0, '', RecID, enum::DYM_PacketDirection::Push, Data);
    end;
    procedure CheckTableMapFlag(TableNo: Integer; TableIndex: Integer; TableName: Text[30]; RecID: Text[250]; Data: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, TableName, 0, 0, '', RecID, enum::DYM_PacketDirection::Push) = Data);
    end;
    procedure GetRecordFlag(TableNo: Integer; TableIndex: Integer; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', 0, 0, '', RecID, enum::DYM_PacketDirection::Push));
    end;
    procedure SetRecordFlag(TableNo: Integer; TableIndex: Integer; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(TableNo, TableIndex, '', 0, 0, '', RecID, enum::DYM_PacketDirection::Push, Data);
    end;
    procedure CheckRecordFlag(TableNo: Integer; TableIndex: Integer; RecID: Text[250]; Data: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', 0, 0, '', RecID, enum::DYM_PacketDirection::Push) = Data);
    end;
    procedure GetFieldFlag(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Push));
    end;
    procedure SetFieldFlag(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[150]; Data: Text[250])
    begin
        SetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Push, Data);
    end;
    procedure CheckFieldFlag(TableNo: Integer; TableIndex: Integer; FieldNo: Integer; FieldIndex: Integer; MobileField: Text[30]; RecID: Text[250]; Data: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(TableNo, TableIndex, '', FieldNo, FieldIndex, MobileField, RecID, enum::DYM_PacketDirection::Push) = Data);
    end;
    #endregion 
    #region RPC Cache
    procedure GetRPCCache(Direction: enum DYM_PacketDirection; FieldName: Text[250]; RecID: Text[250]): Text[250]begin
        exit(GetCacheBufferEntry(0, 0, ConstMgt.RPC_VirtualTableName, 0, 0, FieldName, RecID, Direction));
    end;
    procedure SetRPCCache(Direction: enum DYM_PacketDirection; FieldName: Text[250]; RecID: Text[250]; Data: Text[250])
    begin
        SetCacheBufferEntry(0, 0, ConstMgt.RPC_VirtualTableName, 0, 0, FieldName, RecID, Direction, Data);
    end;
    procedure CheckRPCCache(Direction: enum DYM_PacketDirection; FieldName: Text[250]; RecID: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(0, 0, ConstMgt.RPC_VirtualTableName, 0, 0, FieldName, RecID, Direction) <> '');
    end;
    procedure CheckRPCCacheValue(Direction: enum DYM_PacketDirection; RecID: Text[250]; Data: Text[250]): Boolean begin
        exit(GetCacheBufferEntry(0, 0, ConstMgt.RPC_VirtualTableName, 0, 0, '', RecID, Direction) = Data);
    end;
    procedure FindRPCCache(Direction: enum DYM_PacketDirection)Result: Boolean begin
        Clear(Result);
        CacheBuffer.Reset;
        CacheBuffer.SetRange("Table No.", 0);
        CacheBuffer.SetRange("Table Index", 0);
        CacheBuffer.SetRange("Table Name", ConstMgt.RPC_VirtualTableName);
        CacheBuffer.SetRange("Field No.", 0);
        CacheBuffer.SetRange("Field Index", 0);
        //CacheBuffer.SetRange("Mobile Field", '');
        CacheBuffer.SetRange(Direction, Direction);
        exit(CacheBuffer.FindSet(false, false));
    end;
    procedure NextRPCCache()Result: Integer begin
        Clear(Result);
        exit(CacheBuffer.Next);
    end;
    procedure GetPullRPCCache(FieldName: Text[250]; RecID: Text[250]): Text[250]begin
        EXIT(GetRPCCache(enum::DYM_PacketDirection::Pull, FieldName, RecID));
    end;
    procedure GetPushRPCCache(FieldName: Text[250]; RecID: Text[250]): Text[250]begin
        EXIT(GetRPCCache(enum::DYM_PacketDirection::Push, FieldName, RecID));
    end;
    procedure SetPullRPCCache(FieldName: Text[250]; RecID: Text[250]; Data: Text[250])
    begin
        SetRPCCache(enum::DYM_PacketDirection::Pull, FieldName, RecID, Data);
    end;
    procedure SetSystemPullRPCCache(FieldName: Text[250]; Data: Text[250])
    begin
        SetRPCCache(enum::DYM_PacketDirection::Pull, FieldName, ConstMgt.RPC_SystemRecID, Data);
    end;
    procedure SetPushRPCCache(FieldName: Text[250]; RecID: Text[250]; Data: Text[250])
    begin
        SetRPCCache(enum::DYM_PacketDirection::Push, FieldName, RecID, Data);
    end;
    procedure CheckPullRPCCache(FieldName: Text[250]; RecID: Text[250]): Boolean begin
        EXIT(CheckRPCCache(enum::DYM_PacketDirection::Pull, FieldName, RecID));
    end;
    procedure CheckPushRPCCache(FieldName: Text[250]; RecID: Text[250]): Boolean begin
        EXIT(CheckRPCCache(enum::DYM_PacketDirection::Push, FieldName, RecID));
    end;
    procedure FindPushRPCCache()Result: Boolean begin
        EXIT(FindRPCCache(enum::DYM_PacketDirection::Push));
    end;
    procedure NextPushRPCCache()Result: Integer begin
        EXIT(NextRPCCache);
    end;
    procedure GetRPCCacheRecCount(Direction: enum DYM_PacketDirection)Result: Integer var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    begin
        CLEAR(Result);
        CacheBuffer.RESET;
        CacheBuffer.SETCURRENTKEY("Table No.", "Table Index", "Table Name", "Record ID");
        CacheBuffer.SETRANGE("Table No.", 0);
        CacheBuffer.SETRANGE("Table Index", 0);
        CacheBuffer.SETRANGE("Table Name", ConstMgt.RPC_VirtualTableName);
        CacheBuffer.SETRANGE("Field No.", 0);
        CacheBuffer.SETRANGE("Field Index", 0);
        CacheBuffer.SETRANGE(Direction, Direction);
        IF CacheBuffer.FINDSET(FALSE, FALSE)THEN REPEAT IF(LowLevelDP.Text2Integer(CacheBuffer."Record ID") > Result)THEN Result:=LowLevelDP.Text2Integer(CacheBuffer."Record ID");
            UNTIL CacheBuffer.NEXT = 0;
    end;
    procedure GetPushRPCCacheRecCount()Result: Integer begin
        EXIT(GetRPCCacheRecCount(enum::DYM_PacketDirection::Push));
    end;
    #endregion 
    #region Record Mapping Cache
    procedure ClearRecordMapCache()
    begin
        CacheBuffer.Reset;
        CacheBuffer.SetRange("Table No.", ConstMgt.RCM_Id);
        CacheBuffer.DeleteAll;
    end;
    procedure GetRecordMapCache(TableNo: Integer; KeyRecordID: Text[200]): Text[250]begin
        exit(GetCacheBufferEntry(TableNo, ConstMgt.RCM_Id, '', 0, 0, '', KeyRecordID, enum::DYM_PacketDirection::Push));
    end;
    procedure SetRecordMapCache(TableNo: Integer; KeyRecordID: Text[200]; ValueRecordID: Text[250])
    begin
        SetCacheBufferEntry(TableNo, ConstMgt.RCM_Id, '', 0, 0, '', KeyRecordID, enum::DYM_PacketDirection::Push, ValueRecordID);
    end;
    #endregion 
    #region Operation Hint and Data
    procedure GetOperationHint()Result: Text begin
        EXIT(OperationHint);
    end;
    procedure SetOperationHint(_OperationHint: Text)
    begin
        OperationHint:=_OperationHint;
    end;
    procedure ClearOperationHint()
    begin
        CLEAR(OperationHint);
    end;
    procedure GetOperationData()Result: Text begin
        EXIT(OperationData);
    end;
    procedure SetOperationData(_OperationData: Text)
    begin
        OperationData:=_OperationData;
    end;
    procedure ClearOperationData()
    begin
        CLEAR(OperationData);
    end;
    #endregion 
    #region Error Code
    procedure GetErrorCode()Result: Text[250]begin
        EXIT(ErrorCode);
    end;
    procedure SetErrorCode(_ErrorCode: Text[250])
    begin
        ErrorCode:=_ErrorCode;
    end;
    procedure ClearErrorCode()
    begin
        CLEAR(ErrorCode);
    end;
    #endregion 
    #region State Description
    procedure GetStateDescription()Result: Text[250]begin
        exit(StateDescription);
    end;
    procedure SetStateDescription(_StateDescription: Text[250])
    begin
        StateDescription:=_StateDescription;
    end;
    procedure ClearStateDescription()
    begin
        Clear(StateDescription);
    end;
    procedure GetStateDescriptionMaxStrLen(): Integer begin
        exit(MaxStrLen(StateDescription));
    end;
    #endregion 
    #region Checkpoint
    procedure GetCheckPoint(): Boolean begin
        exit(CheckPoint);
    end;
    procedure SetCheckPoint(_CheckPoint: Boolean)
    begin
        CheckPoint:=_CheckPoint;
    end;
    #endregion 
    #region Performance Counters
    procedure StartPerfCounter()PerfCounterId: Integer begin
        PerformanceCounter+=1;
        PerformanceData.Add(PerformanceCounter, CreateDateTime(today, time));
        Exit(PerformanceCounter);
    end;
    procedure StopPerfCounter(PerfCounterId: Integer)Result: Duration begin
        Clear(Result);
        if(PerformanceData.ContainsKey(PerfCounterId))then exit(CreateDateTime(today, time) - PerformanceData.Get(PerfCounterId));
    end;
    #endregion 
    #region Table metadata
    procedure SetTableMetadata(TableId: Text; PullDuration: Duration; RecordsCount: Integer)
    var
        CurrentTableMetadata: Dictionary of[Integer, Integer];
        CurrentTableMetadataDuration: Duration;
        CurrentTableMetadataRecordsCount: Integer;
    begin
        Clear(CurrentTableMetadataDuration);
        Clear(CurrentTableMetadataRecordsCount);
        if TableMetadata.ContainsKey(TableId)then begin
            TableMetadata.Get(TableId, CurrentTableMetadata);
            if CurrentTableMetadata.ContainsKey(Enum::DYM_TableMetadataType::PullDuration.AsInteger())then CurrentTableMetadataDuration:=CurrentTableMetadata.Get(Enum::DYM_TableMetadataType::PullDuration.AsInteger());
            if CurrentTableMetadata.ContainsKey(Enum::DYM_TableMetadataType::RecordsCount.AsInteger())then CurrentTableMetadataRecordsCount:=CurrentTableMetadata.Get(Enum::DYM_TableMetadataType::RecordsCount.AsInteger());
        end;
        Clear(CurrentTableMetadata);
        CurrentTableMetadata.Add(Enum::DYM_TableMetadataType::PullDuration.AsInteger(), CurrentTableMetadataDuration + PullDuration);
        CurrentTableMetadata.Add(Enum::DYM_TableMetadataType::RecordsCount.AsInteger(), CurrentTableMetadataRecordsCount + RecordsCount);
        TableMetadata.Remove(TableId);
        TableMetadata.Add(TableId, CurrentTableMetadata);
    end;
    procedure ClearTableMetadata()
    begin
        Clear(TableMetadata);
    end;
    procedure GetTableMetadataDict(var DurationDict: Dictionary of[Text, Dictionary of[Integer, Integer]])
    begin
        DurationDict:=TableMetadata;
    end;
#endregion 
}
