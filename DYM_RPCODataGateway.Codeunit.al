codeunit 84410 DYM_RPCODataGateway
{
    //RPC
    trigger OnRun()
    begin
    end;
    procedure ODataWrite(dataIn: Text)Result: Text var
        RPCLogEntryNo: BigInteger;
        DeviceSetupCode: Code[20];
        DeviceSetup: Record DYM_DeviceSetup;
        DataResult, DataIns, DataOut: Text;
    begin
        CLEAR(Result);
        Clear(RPCLog);
        XmlDocument.ReadFrom(DataIn, XMLDomRequest);
        XMLDomRequest.SelectSingleNode(ConstMgt.WSC_PrimaryTag, XMLNodeRequest);
        CLEAR(CallPolicy);
        CLEAR(DeviceSetupCode);
        CallPolicy:=XMLMgt.GetNodeValue(XMLNodeRequest, ConstMgt.WSC_CallPolicy, FALSE);
        DeviceSetupCode:=XMLMgt.GetNodeValue(XMLNodeRequest, ConstMgt.SYN_DeviceSetup, FALSE);
        DeviceSetup.GET(DeviceSetupCode);
        CacheMgt.SetContextByCodes(DeviceSetup."Device Role Code", DeviceSetup."Device Group Code", DeviceSetup.Code);
        RPCLogEntryNo:=InsertRPCLogEntry(DataIn);
        RPCLog.GET(RPCLogEntryNo);
        ProcessRPCLog(RPCLog);
        RPCLog.GET(RPCLogEntryNo);
        DataInNode.WriteTo(DataIns);
        DataoutNode.WriteTo(DataOut);
        DataResult:=DataIns + DataOut;
        InitResponse(XMLDomResponse, XMLNodeResponse);
        CASE CallPolicy OF ConstMgt.WSC_CallPolicy_Direct, ConstMgt.WSC_CallPolicy_DirectResponse, '': BEGIN
            IF(RPCLog.Status = RPCLog.Status::Success)THEN BEGIN
                ProcessDirectResponseRPC(XMLNodeResponse, DataResult);
            END
            ELSE
            BEGIN
                XMLMgt.AddAttribute(XMLNodeResponse, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_Error);
                XMLMgt.AddAttribute(XMLNodeResponse, ConstMgt.WSC_ErrorCode, RPCLog."Error Code");
                XMLMgt.AddAttribute(XMLNodeResponse, ConstMgt.WSC_ErrorDescription, RPCLog."Error Description");
            END;
        END;
        ConstMgt.WSC_CallPolicy_Queue: BEGIN
            XMLMgt.AddAttribute(XMLNodeResponse, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_Queued);
        END;
        END;
        XMLDomResponse.WriteTo(DataOut);
        UpdateRPCLogEntry(RPCLogEntryNo, DataOut);
        EXIT(DataOut);
    end;
    LOCAL procedure InitResponse(VAR DOMOut: XmlDocument; VAR NodeOut: XmlNode)
    var
    begin
        XMLMgt.CreateRootXML(XMLRootResponse, DOMOut, enum::DYM_PullType::None);
        XMLMgt.AddElement(XMLRootResponse, ConstMgt.WSC_Result, '', NodeOut);
    end;
    local procedure ProcessDirectResponseRPC(VAR NodeOut: XmlNode; var DataResult: Text)
    begin
        XMLMgt.AddAttribute(XMLNodeResponse, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_OK);
        XMLMgt.AddElement(XMLNodeResponse, constmgt.SYN_PrimaryTag(), DataResult, XMLNodeResponseResult);
        XMLMgt.AddAttribute(XMLNodeResponseResult, ConstMgt.SYN_DeviceSetup, DeviceSetup.Code);
        XMLMgt.AddAttribute(XMLNodeResponseResult, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_OK);
    end;
    procedure InsertRPCLogEntry(RequestText: Text)Result: BigInteger begin
        CLEAR(Result);
        Clear(RPCLog);
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        RPCLog.INIT;
        RPCLog."Entry TimeStamp":=CREATEDATETIME(TODAY, TIME);
        RPCLog.Status:=RPCLog.Status::Pending;
        RPCLog."Device Role Code":=DeviceRole.Code;
        RPCLog."Device Group Code":=DeviceGroup.Code;
        RPCLog."Device Setup Code":=DeviceSetup.Code;
        CLEAR(RPCLog."Operation Hint");
        CLEAR(RPCLog."Operation Data");
        CLEAR(RPCLog."Error Description");
        CLEAR(RPCLog.Request);
        CLEAR(RPCLog.Response);
        RPCLog.Request.CREATEOUTSTREAM(OutS, TEXTENCODING::UTF8);
        OutS.WRITETEXT(RequestText);
        RPCLog.INSERT;
        EXIT(RPCLog."Entry No");
    end;
    LOCAL procedure UpdateRPCLogEntry(RPCLogEntryNo: BigInteger; ResponseText: Text)
    begin
        Clear(RPCLog);
        RPCLog.GET(RPCLogEntryNo);
        RPCLog.Response.CREATEOUTSTREAM(OutS, TEXTENCODING::UTF8);
        OutS.WRITETEXT(ResponseText);
        RPCLog.MODIFY;
    end;
    LOCAL procedure ProcessPushRPC(NodeIn: XmlNode)
    begin
        NodeIn.SelectNodes(ConstMgt.RPC_Call, XMLNodeList);
        FOR i:=1 TO(XMLNodeList.Count)DO BEGIN
            XMLNodeList.Get(i, XMLNode);
            KeyValueNodeList:=XMLNode.AsXmlElement().GetChildNodes();
            FOR j:=1 TO(KeyValueNodeList.Count)DO BEGIN
                KeyValueNodeList.Get(j, KeyValueNode);
                IF(KeyValueNode.AsXmlElement().Name = ConstMgt.RPC_DataIn)THEN BEGIN
                    CLEAR(RecId);
                    DataInNodeList:=KeyValueNode.AsXmlElement().GetChildNodes();
                    FOR k:=1 TO(DataInNodeList.Count)DO BEGIN
                        DataInNodeList.Get(k, DataInNode);
                        IF(DataInNode.AsXmlElement().Name = ConstMgt.RPC_Records)THEN BEGIN
                            DataInRecordsNodeList:=DataInNode.AsXmlElement().GetChildNodes();
                            FOR l:=1 TO(DataInRecordsNodeList.Count)DO BEGIN //records
                                RecId+=1;
                                DataInRecordsNodeList.get(l, DataInRecordsNode);
                                DataInRecNodeList:=DataInRecordsNode.AsXmlElement().GetChildNodes();
                                FOR m:=1 TO(DataInRecNodeList.Count)DO BEGIN
                                    DataInRecNodeList.Get(m, DataInRecNode);
                                    CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Push, DataInRecNode.AsXmlElement().Name, LowLevelDP.Integer2Text(RecId), DataInRecNode.AsXmlElement().InnerXml);
                                END;
                            END;
                        END
                        ELSE
                            CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Push, DataInNode.AsXmlElement().Name, ConstMgt.RPC_SystemRecID(), DataInNode.AsXmlElement().InnerXml);
                    END;
                END
                ELSE
                    CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Push, KeyValueNode.AsXmlElement().Name, ConstMgt.RPC_SystemRecID(), KeyValueNode.AsXmlElement().InnerXml);
            END;
        end;
    END;
    LOCAL procedure ProcessPushRPCResponse(VAR NodeOut: XmlNode)
    begin
        XMLMgt.AddElement(NodeOut, ConstMgt.RPC_DataIn, '', DatainNode);
        IF CacheMgt.FindRPCCache(enum::DYM_PacketDirection::Push)THEN REPEAT XMLMgt.AddElement(DatainNode, CacheMgt.CacheBufferFieldName, CacheMgt.CacheBufferData, DummyNode);
            UNTIL CacheMgt.NextRPCCache = 0;
        CLEAR(LastRecID);
        XMLMgt.AddElement(NodeOut, ConstMgt.RPC_DataOut, '', DataoutNode);
        IF CacheMgt.FindRPCCache(enum::DYM_PacketDirection::Pull)THEN REPEAT IF((LastRecID <> CacheMgt.CacheBufferRecID) OR (DataoutNode.AsXmlElement().IsEmpty))THEN BEGIN
                    IF(CacheMgt.CacheBufferRecID = ConstMgt.RPC_SystemRecID)THEN BEGIN
                        XMLMgt.AddElement(DataoutNode, ConstMgt.SYN_Record, '', DataoutRecNode);
                    END
                    ELSE
                        XMLMgt.AddElement(DataoutNode, ConstMgt.SYN_Record, '', DataoutRecNode)END;
                XMLMgt.AddElement(DataoutRecNode, CacheMgt.CacheBufferFieldName, CacheMgt.CacheBufferData, DummyNode);
                LastRecID:=CacheMgt.CacheBufferRecID;
            UNTIL CacheMgt.NextRPCCache = 0;
    end;
    procedure ProcessRPCLog(RPCLog: Record DYM_RPCLog)
    var
        EventLog: Record DYM_EventLog;
        ErrorMessage, FileContent, Content: Text;
    begin
        RPCLog.Status:=RPCLog.Status::InProgress;
        RPCLog.MODIFY;
        COMMIT;
        CacheMgt.ClearCacheBuffer;
        RPCLog.CALCFIELDS(Request);
        RPCLog.Request.CREATEINSTREAM(InS, TEXTENCODING::UTF8);
        ins.ReadText(FileContent);
        XmlDocument.ReadFrom(FileContent, XMLDomRequest);
        XMLDomRequest.SelectSingleNode(STRSUBSTNO(RPCTagPattern, ConstMgt.SYN_PrimaryTag, ConstMgt.SYN_Table, ConstMgt.RPC_VirtualTableName), RequestNode);
        ProcessPushRPC(RequestNode);
        XMLMgt.CreateRootXML(ResponseNode, XMLDomResponse, enum::DYM_PullType::None);
        XMLMgt.AddAttribute(ResponseNode, ConstMgt.SYN_DeviceSetup, RPCLog."Device Setup Code");
        CacheMgt.ClearOperationHint;
        CacheMgt.ClearOperationData;
        CacheMgt.ClearErrorCode;
        CLEAR(Result);
        Result:=CODEUNIT.RUN(CODEUNIT::DYM_RPCDispatcher);
        CASE Result OF TRUE: BEGIN
            RPCLog."Error Code":='';
            ErrorMessage:='';
            RPCLog."Error Description":='';
            RPCLog.Status:=RPCLog.Status::Success;
            XMLMgt.AddAttribute(ResponseNode, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_OK);
        END;
        FALSE: BEGIN
            RPCLog.Status:=RPCLog.Status::Failed;
            RPCLog."Error Code":=CacheMgt.GetErrorCode;
            RPCLog."Error Description":=GETLASTERRORTEXT;
            XMLMgt.AddAttribute(ResponseNode, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_Error);
            XMLMgt.AddAttribute(ResponseNode, ConstMgt.WSC_ErrorCode, RPCLog."Error Code");
            XMLMgt.AddAttribute(ResponseNode, ConstMgt.WSC_ErrorDescription, RPCLog."Error Description");
            CLEAR(StatsMgt);
            ErrorMessage:=DebugMgt.GetLastErrorData();
            ErrorMessage:=CopyStr(ErrorMessage, 1, MaxStrLen(EventLog.Message));
            EventLogMgt.LogError(RPCLog."Entry No", enum::DYM_EventLogSourceType::RPC, ErrorMessage, DebugMgt.GetLastErrorData());
        END;
        END;
        RPCLog."Operation Hint":=CacheMgt.GetOperationHint;
        RPCLog."Operation Data":=CacheMgt.GetOperationData;
        ProcessPushRPCResponse(ResponseNode);
        CLEAR(RPCLog.Response);
        RPCLog.Response.CREATEOUTSTREAM(OutS, TEXTENCODING::UTF8);
        XMLDomResponse.WriteTo(OutS);
        OutS.WRITETEXT();
        RPCLog.MODIFY;
    END;
    var CacheMgt: Codeunit DYM_CacheManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    EventLogMgt: Codeunit DYM_EventLogManagement;
    DebugMgt: Codeunit DYM_DebugManagement;
    XMLMgt: Codeunit DYM_XMLManagement;
    lowLevelDP: Codeunit DYM_LowLevelDataProcess;
    XMLDomResponse, XMLDomRequest: XmlDocument;
    DataoutNode, DataoutRecNode, DataInRecNode, DataInRecordsNode, DataInNode, XMLNodeResponse, RequestNode, XMLRootResponse, KeyValueNode, XMLNode, DummyNode, XMLNodeRequest, XMLNodeResponseResult, ResponseNode: XmlNode;
    DataInRecNodeList, DataInRecordsNodeList, DataInNodeList, KeyValueNodeList, XMLNodeList: XmlnodeList;
    RPCLog: Record DYM_RPCLog;
    OutS: OutStream;
    InS: InStream;
    RecId, j, l, i, m, k: Integer;
    RPCLE: BigInteger;
    SLE: Integer;
    Result: Boolean;
    LastRecID, CallPolicy, FileName: Text[250];
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    RPCTagPattern: Label '%1/%2[@tablename=''%3'']', Locked = true;
}
