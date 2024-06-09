codeunit 70117 DYM_DynamicsMobileWebServices
{
    trigger OnRun()
    begin
    end;

    var
        CacheMgt: Codeunit DYM_CacheManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        XMLMgt: Codeunit DYM_XMLManagement;
        MobileDP: Codeunit DYM_MobileDataProcess;
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        PacketMgt: Codeunit DYM_PacketManagement;
        Base64Convert: Codeunit "Base64 Convert";
        _RequestPacket: XmlDocument;
        _ResponsePacket: XmlDocument;
        _ResponseRootNode: XmlNode;
        _RequestNode: XmlNode;
        _ResponseNode: XmlNode;
        _Node: XmlNode;
        _DummyNode: XmlNode;
        TempBlob: Codeunit "Temp Blob";
        DeviceSetup: Record DYM_DeviceSetup;
        DeviceRoleCode: Code[20];
        DeviceSetupCode: Code[100];
        TableName: Text[250];
        RequestID: Text[250];

    procedure Read(DataIn: BigText; var DataOut: BigText) Result: Boolean
    var
        ReadPolicy: Text[250];
    begin
        Clear(Result);
        //XMLDomRequest := XMLDomRequest.XmlDocument();
        //ReadDataIn(DataIn, XMLDomRequest);
        //XMLNodeRequest := XMLDomRequest.SelectSingleNode(ConstMgt.WSC_PrimaryTag);
        _RequestPacket := XmlDocument.Create();
        ReadDataIn(DataIn, _RequestPacket);
        Clear(ReadPolicy);
        ReadPolicy := XMLMgt.TryGetNodeValue(_RequestNode, ConstMgt.WSC_ReadPolicy, false);
        if (ReadPolicy = ConstMgt.WSC_ReadPolicy_Standard) then begin
            Write(DataIn, DataOut);
            exit(true);
        end;
        //InitResponse(XMLDomResponse, XMLNodeResponse);
        //ProcessDataIn(XMLNodeRequest, XMLNodeResponse);
        InitResponse(_ResponsePacket, _ResponseNode);
        ProcessDataIn(_RequestNode, _ResponseNode);
        //WriteDataOut(DataOut, XMLDomResponse);
        WriteDataOut(DataOut, _ResponsePacket);
        exit(true);
    end;

    procedure Write(DataIn: BigText; var DataOut: BigText) Result: Boolean
    var
        EntryNo: Integer;
        SyncLog: Record DYM_SyncLog;
        ResponseSyncLog: Record DYM_SyncLog;
        CallPolicy: Text[250];
        InS: InStream;
    begin
        Clear(Result);
        //XMLDomRequest := XMLDomRequest.XmlDocument();
        //ReadDataIn(DataIn, XMLDomRequest);
        _RequestPacket := XmlDocument.Create();
        ReadDataIn(DataIn, _RequestPacket);
        //XMLNodeRequest := XMLDomRequest.SelectSingleNode(ConstMgt.WSC_PrimaryTag);
        _RequestPacket.SelectSingleNode(ConstMgt.WSC_PrimaryTag(), _RequestNode);
        Clear(CallPolicy);
        CallPolicy := XMLMgt.TryGetNodeValue(_RequestNode, ConstMgt.WSC_CallPolicy, false);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        EntryNo := GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::None, false, true, InS);
        if (CallPolicy in ['', ConstMgt.WSC_CallPolicy_Direct, ConstMgt.WSC_CallPolicy_DirectResponse]) then begin
            SyncLog.Get(EntryNo);
            PacketMgt.ProcessSyncLogEntry(SyncLog);
            SyncLog.Get(EntryNo);
        end;
        InitResponse(_ResponsePacket, _ResponseNode);
        case CallPolicy of
            '', ConstMgt.WSC_CallPolicy_Direct, ConstMgt.WSC_CallPolicy_DirectResponse:
                begin
                    if (SyncLog.Status = SyncLog.Status::Success) then begin
                        Result := true;
                        XMLMgt.AddAttribute(_ResponseNode, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_OK);
                        if (CallPolicy = ConstMgt.WSC_CallPolicy_DirectResponse) then begin
                            ProcessDirectResponse(_ResponseNode, EntryNo);
                        end;
                    end
                    else begin
                        XMLMgt.AddAttribute(_ResponseNode, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_Error);
                        XMLMgt.AddAttribute(_ResponseNode, ConstMgt.WSC_ErrorDescription, SyncLog."Error Description");
                    end;
                end;
            ConstMgt.WSC_CallPolicy_Queue:
                begin
                    Result := true;
                    XMLMgt.AddAttribute(_ResponseNode, ConstMgt.WSC_ExecutionStatus, ConstMgt.WSC_ExecutionStatus_Queued);
                end;
        end;
        WriteDataOut(DataOut, _ResponsePacket);
    end;

    local procedure ProcessDataIn(var NodeIn: XmlNode; var NodeOut: XmlNode)
    var
        _Node: XmlNode;
        _NodeList: XmlNodeList;
        i: Integer;
    begin
        DeviceSetupCode := XMLMgt.GetNodeValue(NodeIn, ConstMgt.SYN_DeviceSetup, false);
        if not DeviceSetup.Get(DeviceSetupCode) then Clear(DeviceSetup);
        CacheMgt.SetContextByCodes(DeviceSetup."Device Role Code", DeviceSetup."Device Group Code", DeviceSetup.Code);
        NodeIn.SelectNodes(ConstMgt.WSC_Table, _NodeList);
        for i := 1 to _NodeList.Count() do begin
            _NodeList.Get(i, _Node);
            ProcessTableIn(_Node, NodeOut);
        end;
    end;

    local procedure ProcessTableIn(var NodeIn: XmlNode; var NodeOut: XmlNode)
    var
        _Node: XmlNode;
        _TableNode: XmlNode;
        TableMap: Record DYM_MobileTableMap;
        RecRef: RecordRef;
    begin
        TableName := XMLMgt.GetNodeValue(NodeIn, ConstMgt.WSC_TableName, false);
        RequestID := XMLMgt.GetNodeValue(NodeIn, ConstMgt.WSC_RequestID, false);
        XMLMgt.AddElement(NodeOut, ConstMgt.WSC_Table, '', _TableNode);
        XMLMgt.AddAttribute(_TableNode, ConstMgt.WSC_TableName, TableName);
        XMLMgt.AddAttribute(_TableNode, ConstMgt.WSC_RequestID, RequestID);
        TableMap.Reset;
        TableMap.SetRange("Device Role Code", DeviceSetup."Device Role Code");
        TableMap.SetRange("Mobile Table", TableName);
        if TableMap.FindFirst then begin
            RecRef.Open(TableMap."Table No.");
            ProcessTableFilters(NodeIn, TableMap, RecRef);
            MobileDP.ProcessTablePull(_TableNode, RecRef, TableMap);
            XMLMgt.AddAttribute(_TableNode, ConstMgt.WSC_TableStatus, ConstMgt.WSC_TableStatus_OK);
            RecRef.Close;
        end
        else
            XMLMgt.AddAttribute(_TableNode, ConstMgt.WSC_TableStatus, ConstMgt.WSC_TableStatus_NotFound);
    end;

    local procedure ProcessTableFilters(var NodeIn: XmlNode; TableMap: Record DYM_MobileTableMap; var RecRef: RecordRef)
    var
        _Node: XmlNode;
        _NodeList: XmlNodeList;
        FieldMap: Record DYM_MobileFieldMap;
        FldRef: FieldRef;
        i: Integer;
    begin
        NodeIn.SelectSingleNode(ConstMgt.WSC_TableFilters, _Node);
        if not _Node.AsXmlElement().IsEmpty() then
            if (_Node.AsXmlElement().InnerText <> '') then begin
                _Node.SelectNodes('*', _NodeList);
                for i := 1 to _NodeList.Count() do begin
                    _NodeList.Get(i, _Node);
                    FieldMap.Reset;
                    FieldMap.SetRange("Device Role Code", TableMap."Device Role Code");
                    FieldMap.SetRange("Table No.", TableMap."Table No.");
                    FieldMap.SetRange("Table Index", TableMap.Index);
                    FieldMap.SetRange("Mobile Field", _Node.AsXmlElement().Name);
                    FieldMap.SetRange(Disabled, false);
                    FieldMap.SetFilter(Direction, '%1|%2|%3', FieldMap.Direction::Both, FieldMap.Direction::Pull, FieldMap.Direction::Internal);
                    if FieldMap.FindSet(false, false) then
                        repeat
                            FldRef := RecRef.Field(FieldMap."Field No.");
                            FldRef.SetFilter(_Node.AsXmlElement().InnerText);
                        until FieldMap.Next = 0;
                end;
            end;
    end;

    local procedure ProcessDirectResponse(var NodeOut: XmlNode; SLE: Integer)
    var
        SyncLog: Record DYM_SyncLog;
        _DataResponsePacket: XmlDocument;
        _DataResponseNodeList: XmlNodeList;
        _DataResponseNode: XmlNode;
        _ImportedDataResponseNode: XmlNode;
        _PacketOut: XmlDocument;
        ResponseFile: File;
        ResponseInStream: InStream;
        i: Integer;
    begin
        SyncLog.Reset;
        SyncLog.SetRange("Request Entry No.", SLE);
        if SyncLog.FindFirst then begin
            _DataResponsePacket := XmlDocument.Create();
            SyncLog.CalcFields(Packet);
            synclog.Packet.CreateInStream(ResponseInStream, TextEncoding::UTF8);
            XmlDocument.ReadFrom(ResponseInStream, _DataResponsePacket);
            _DataResponsePacket.SelectNodes(ConstMgt.SYN_PrimaryTag, _DataResponseNodeList);
            for i := 1 to _DataResponseNodeList.Count() do begin
                _DataResponseNodeList.Get(i, _DataResponseNode);
                //ImportedDataResponseNode := NodeOut.OwnerDocument.ImportNode(XMLDataResponseNode, true);
                //NodeOut.AppendChild(ImportedDataResponseNode);
                NodeOut.AddAfterSelf(_DataResponseNode);
            end;
        end;
    end;

    local procedure InitResponse(var _OutPacket: XmlDocument; var _OutNode: XmlNode)
    begin
        Clear(_OutPacket);
        _OutPacket := XmlDocument.Create();
        XMLMgt.CreateRootXML(_ResponseRootNode, _OutPacket, enum::DYM_PullType::None);
        XMLMgt.AddElement(_ResponseRootNode, ConstMgt.WSC_Result, '', _OutNode);
    end;

    local procedure ReadDataIn(DataIn: BigText; var _Packet: XmlDocument)
    var
        FileName: Text[250];
        InS: InStream;
        OutS: OutStream;
        F: File;
    begin
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        DataIn.Write(OutS);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        XmlDocument.ReadFrom(InS, _Packet);
    end;

    local procedure WriteDataOut(var DataOut: BigText; _Packet: XmlDocument)
    var
        FileName: Text[250];
        InS: InStream;
        OutS: OutStream;
        F: File;
        _b64Packet: XmlDocument;
        _b64Node: XmlNode;
        _b64NodeResult: XmlNode;
    begin
        clear(TempBlob);
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        _Packet.WriteTo(OutS);
        InitResponse(_b64Packet, _b64Node);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        XMLMgt.AddElement(_b64Node, ConstMgt.B64_ResultTag(), Base64Convert.ToBase64(InS), _b64NodeResult);
        clear(TempBlob);
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        _b64Packet.WriteTo(OutS);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        DataOut.Read(InS);
    end;
}
