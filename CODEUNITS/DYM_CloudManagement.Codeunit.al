codeunit 70107 DYM_CloudManagement
{
    TableNo = DYM_SyncLog;

    var
        SettingsMgt: Codeunit DYM_SettingsManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        CacheMgt: Codeunit DYM_CacheManagement;
        EventLogMgt: Codeunit DYM_EventLogManagement;
        LLDP: Codeunit DYM_LowLevelDataProcess;
        Text000: Label 'Can not find [%1] placeholder in [%2]';

    trigger OnRun()
    var
        BLOBStore: record DYM_BLOBStore;
    begin
        if (Rec."Entry No." >= 0) then begin //Process SyncLog entry
            if (Rec."Entry No." = 0) then //Call without specific record does fetch
                processFetch()
            else begin
                case Rec.Direction of
                    Rec.Direction::Pull:
                        processPull(Rec);
                    Rec.Direction::Push:
                        processPush(Rec);
                end;
            end;
        end
        else begin //Process BLOBStore entry
            BLOBStore.Get(-Rec."Entry No.");
            processPushFile(BLOBStore);
        end;
    end;

    local procedure processPush(var _syncLog: record DYM_SyncLog)
    var
        cloudInStream: InStream;
        blobOutStream: OutStream;
        directDownloadLink: Text;
    begin
        //EventLogMgt.LogFetchDebug(StrSubstNo(DBG_Pattern, 'processPush', DBG_OP_Start), '');
        directDownloadLink := parseDownloadLink(getDownloadLink(_syncLog.Path));
        downloadPacketContent(directDownloadLink, cloudInStream);
        _synclog.Packet.CreateOutStream(blobOutStream, TextEncoding::UTF8);
        CopyStream(blobOutStream, cloudInStream);
    end;

    procedure processPushFile(var _BLOBStore: record DYM_BLOBStore)
    var
        cloudInStream: InStream;
        blobOutStream: OutStream;
        directDownloadLink: Text;
    begin
        directDownloadLink := parseDownloadLink(getDownloadLink(_BLOBStore.URL));
        downloadPacketContent(directDownloadLink, cloudInStream);
        _BLOBStore.Content.CreateOutStream(blobOutStream, TextEncoding::UTF8);
        CopyStream(blobOutStream, cloudInStream);
        _BLOBStore."Content Size" := _BLOBStore.Content.Length;
        _BLOBStore.Modify();
    end;

    local procedure getDownloadLink(_packetId: Text): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        baseAddress: Text;
        requrl: Text;
        respBodyText: Text;
        PerfCounterId: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        settingsMgt.TestSetting(constMgt.CLD_AppArea());
        settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_getPacketDownloadLink());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        //BaseAddress not working in DeepCatch
        //client.SetBaseAddress(baseAddress);
        client.DefaultRequestHeaders().add('x-api-key', settingsMgt.GetSetting(constMgt.CLD_xAPIKey()));
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_getPacketDownloadLink());
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_AppArea(), settingsMgt.GetSetting(constMgt.CLD_AppArea()));
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_Path(), _packetId);
        //error(strsubstno('[%1][%2]', requrl, settingsMgt.GetSetting(constMgt.CLD_xAPIKey())));
        client.Get(baseAddress + requrl, response);
        if (response.Content.ReadAs(respBodyText)) then begin
            if (response.HttpStatusCode() <> constMgt.HTP_200()) then begin
                cacheMgt.SetStateDescription(CopyStr(StrSubstNo('[%1][%2][%3]', response.HttpStatusCode(), respBodyText, requrl), 1, cacheMgt.GetStateDescriptionMaxStrLen()));
                Error(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText));
            end;
        end
        else
            Message('Cannot read body');
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
        exit(respBodyText);
    end;

    local procedure parseDownloadLink(_downloadLink: Text): Text
    var
        json: JsonObject;
        directDownloadURL: JsonToken;
    begin
        json.ReadFrom(_downloadLink);
        json.Get('url', directDownloadURL);
        exit(directDownloadURL.AsValue().AsText());
    end;

    local procedure downloadPacketContent(_downloadLink: Text; _inStream: InStream)
    var
        client: HttpClient;
        response: HttpResponseMessage;
        responseText: Text;
        PerfCounterId: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        client.Get(_downloadLink, response);
        response.Content().ReadAs(_inStream);
        if (response.HttpStatusCode() <> constMgt.HTP_200()) then begin
            _inStream.ReadText(responseText);
            cacheMgt.SetStateDescription(CopyStr(StrSubstNo('[%1][%2][%3]', response.HttpStatusCode(), responseText, _downloadLink), 1, cacheMgt.GetStateDescriptionMaxStrLen()));
            Error(StrSubstNo('[%1][%2]', response.HttpStatusCode(), responseText));
        end;
        //EventLogmgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
    end;
    #region Pull
    local procedure processPull(var _syncLog: record DYM_SyncLog)
    var
        blobInStream: InStream;
        cloudOutStream: OutStream;
        directUploadLink: Text;
    begin
        _syncLog.CalcFields(Packet);
        _synclog.Packet.CreateInStream(blobInStream, TextEncoding::UTF8);
        directUploadLink := parseUploadLink(getUploadLink(_syncLog.Path, _syncLog."Device Setup Code", _syncLog.Packet.Length));
        uploadPacketContent(directUploadLink, blobInStream);
    end;

    local procedure getUploadLink(_packetId: Text; _deviceId: Text; _packetSize: Integer): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        baseAddress: Text;
        requrl: Text;
        respBodyText: text;
        PerfCounterId: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        settingsMgt.TestSetting(constMgt.CLD_AppArea());
        settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_getPacketUploadLink());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        //BaseAddress not working in DeepCatch
        //client.SetBaseAddress(baseAddress);
        client.DefaultRequestHeaders().add('x-api-key', settingsMgt.GetSetting(constMgt.CLD_xAPIKey()));
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_getPacketUploadLink());
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_AppArea(), settingsMgt.GetSetting(constMgt.CLD_AppArea()));
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_DeviceId(), _deviceId);
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_PacketSize(), lldp.Integer2Text(_packetSize));
        client.Get(baseAddress + requrl, response);
        if (response.Content.ReadAs(respBodyText)) then begin
            if (response.HttpStatusCode() <> constMgt.HTP_200()) then begin
                cacheMgt.SetStateDescription(CopyStr(StrSubstNo('[%1][%2][%3]', response.HttpStatusCode(), respBodyText, requrl), 1, cacheMgt.GetStateDescriptionMaxStrLen()));
                Error(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText));
            end;
        end
        else
            Message('Cannot read body');
        //EventLogmgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
        exit(respBodyText);
    end;

    local procedure parseUploadLink(_uploadLink: Text): Text
    var
        json: JsonObject;
        directUploadURL: JsonToken;
    begin
        json.ReadFrom(_uploadLink);
        json.Get('uploadPath', directUploadURL);
        exit(directUploadURL.AsValue().AsText());
    end;

    local procedure uploadPacketContent(_uploadLink: Text; _inStream: InStream)
    var
        client: HttpClient;
        packetContent: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        PerfCounterId: Integer;
    begin
        //EventLogmgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        packetContent.WriteFrom(_inStream);
        packetContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/xml');
        request.SetRequestUri(_uploadLink);
        request.Content := packetContent;
        request.Method := 'PUT';
        client.Send(request, response);
        //client.Put(_uploadLink, packetContent, response);
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
    end;
    #endregion 
    #region Fetch
    procedure processFetch()
    var
        DeviceSetup: Record DYM_DeviceSetup;
        GlobalDP: Codeunit DYM_GlobalDataProcess;
        BLOBStoreMgt: Codeunit DYM_BLOBStoreManagement;
        StreamMgt: Codeunit DYM_StreamManagement;
        FetchResponse, packetURL : Text;
        DummyInStream: InStream;
        FetchMessages: List of [Dictionary of [Integer, Text]];
        packetMessage: Dictionary of [Integer, Text];
        MessagesCount: Integer;
        PerfCounterId: Integer;
        i: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        //Fetch packets
        clear(MessagesCount);
        FetchResponse := fetchPacketsList(constMgt.CLD_PacketType_Packet());
        getFetchMessages(FetchResponse, FetchMessages);
        MessagesCount := FetchMessages.Count();
        if (MessagesCount > 0) then begin
            for i := 1 to MessagesCount do begin
                packetMessage := FetchMessages.Get(i);
                clear(StreamMgt);
                StreamMgt.initDummyInStream(DummyInStream);
                if not DeviceSetup.Get(packetMessage.Get(3)) then clear(DeviceSetup);
                CacheMgt.SetContextByCodes(DeviceSetup."Device Role Code", DeviceSetup."Device Group Code", DeviceSetup.Code);
                clear(GlobalDP);
                GlobalDP.InsertSyncLogEntry(packetMessage.Get(2), enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::None, false, false, DummyInStream, packetMessage.Get(4));
            end;
            //Commmit before marking packets as fetched
            //otherwise the packets be dropped if the commit fails
            Commit();
            MarkPacketsList(FetchResponse, constMgt.CLD_PacketType_Packet());
        end;
        //Fetch files
        clear(MessagesCount);
        FetchResponse := fetchPacketsList(constMgt.CLD_PacketType_File());
        //getFetchFiles(FetchResponse, FetchMessages);
        getFetchMessages(FetchResponse, FetchMessages);
        MessagesCount := FetchMessages.Count();
        if (MessagesCount > 0) then begin
            for i := 1 to MessagesCount do begin
                packetMessage := FetchMessages.Get(i);
                clear(BLOBStoreMgt);
                BLOBStoreMgt.insertBLOBStoreEntry(packetMessage.Get(1), packetMessage.Get(2), packetMessage.Get(3), packetMessage.Get(4), packetMessage.Get(5));
            end;
            MarkPacketsList(FetchResponse, constMgt.CLD_PacketType_File());
        end;
        //EventLogmgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
    end;

    procedure fetchPacketsList(_packetType: Text): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        baseAddress: Text;
        requrl: Text;
        respBodyText: text;
        PerfCounterId: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        settingsMgt.TestSetting(constMgt.CLD_AppArea());
        settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_fetchPacketsLink());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        //BaseAddress not working in DeepCatch
        //client.SetBaseAddress(baseAddress);
        client.DefaultRequestHeaders().add('x-api-key', settingsMgt.GetSetting(constMgt.CLD_xAPIKey()));
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_fetchPacketsLink());
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_AppArea(), settingsMgt.GetSetting(constMgt.CLD_AppArea()));
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_PacketType(), _packetType);
        client.Get(baseAddress + requrl, response);
        if (response.Content.ReadAs(respBodyText)) then begin
            //cacheMgt.SetStateDescription(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText));
            Message(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText))
        end
        else
            Message('Cannot read body');
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
        exit(respBodyText);
    end;

    procedure MarkPacketsList(_PacketsList: Text; _packetType: Text): Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        baseAddress: Text;
        requrl: Text;
        respBodyText: text;
        PerfCounterId: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        settingsMgt.TestSetting(constMgt.CLD_AppArea());
        settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_markFetchedPackets());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        //BaseAddress not working in DeepCatch
        //client.SetBaseAddress(baseAddress);
        client.DefaultRequestHeaders().add('x-api-key', settingsMgt.GetSetting(constMgt.CLD_xAPIKey()));
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_markFetchedPackets());
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_AppArea(), settingsMgt.GetSetting(constMgt.CLD_AppArea()));
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_PacketType(), _packetType);
        content.Clear();
        content.WriteFrom(_PacketsList);
        client.Post(baseAddress + requrl, content, response);
        if (response.Content.ReadAs(respBodyText)) then begin
            //cacheMgt.SetStateDescription(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText));
            Message(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText))
        end
        else
            Message('Cannot read body');
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
    end;

    procedure getFetchMessages(_packetMessage: Text; var messages: List of [Dictionary of [Integer, Text]])
    var
        packetMessageDoc: XmlDocument;
        nodeList: XmlNodeList;
        node: XmlNode;
        workNode: XmlNode;
        packetURL: Text;
        packText: Dictionary of [Integer, Text];
    begin
        clear(messages);
        if (XmlDocument.ReadFrom(_packetMessage, packetMessageDoc)) then begin
            packetMessageDoc.SelectNodes('/messages/message', nodeList);
            foreach node in nodelist do begin
                clear(packText);
                //if (node.IsXmlElement) then
                //    messages.Add(node.AsXmlElement().InnerText);
                node.SelectSingleNode('id', workNode);
                if (workNode.IsXmlElement) then //packText := packText + workNode.AsXmlElement().InnerText + ',';
                    packText.Add(1, workNode.AsXmlElement().InnerText);
                node.SelectSingleNode('url', workNode);
                if (workNode.IsXmlElement) then //packText := packText + workNode.AsXmlElement().InnerText + ',';
                    packText.add(2, workNode.AsXmlElement().InnerText);
                node.SelectSingleNode('userName', workNode);
                if (workNode.IsXmlElement) then //packText := packText + workNode.AsXmlElement().InnerText + ',';
                    packText.add(3, workNode.AsXmlElement().InnerText);
                node.SelectSingleNode('companyId', workNode);
                if (workNode.IsXmlElement) then //packText := packText + workNode.AsXmlElement().InnerText + ',';
                    packText.add(4, workNode.AsXmlElement().InnerText);
                node.SelectSingleNode('packetType', workNode);
                if (workNode.IsXmlElement) then //packText := packText + workNode.AsXmlElement().InnerText;
                    packText.add(5, workNode.AsXmlElement().InnerText);
                messages.Add(packText);
            end;
        end;
    end;
    #endregion 
    procedure testConnection(TestAppArea: Text; TestxAPIKey: Text; var ResultMsg: Text) Result: Boolean
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        baseAddress: Text;
        requrl: Text;
        respBodyText: text;
        PerfCounterId: Integer;
    begin
        Clear(Result);
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        //settingsMgt.TestSetting(constMgt.CLD_AppArea());
        //settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_fetchPacketsLink());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        client.DefaultRequestHeaders().add('x-api-key', TestxAPIKey);
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_fetchPacketsLink());
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_AppArea(), TestAppArea);
        requrl := ApplyPlaceHolderValue(requrl, constMgt.PLH_PacketType(), constMgt.CLD_PacketType_Packet());
        client.Get(baseAddress + requrl, response);
        if not (response.Content.ReadAs(ResultMsg)) then exit(false);
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
        exit(response.HttpStatusCode = ConstMgt.HTP_200());
    end;

    procedure ApplyPlaceHolderValue(InputString: Text; PlaceHolder: Text; PlaceHolderValue: Text) Result: Text
    begin
        if not (InputString.Contains(PlaceHolder)) then Error(Text000, PlaceHolder, InputString);
        Result := lldp.ReplaceSingleStr(InputString, PlaceHolder, PlaceHolderValue);
        exit(Result);
    end;
}
