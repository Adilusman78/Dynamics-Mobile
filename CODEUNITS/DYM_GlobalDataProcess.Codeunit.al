codeunit 70125 DYM_GlobalDataProcess
{
    Permissions = TableData DYM_DynamicsMobileSetup = rimd,
        TableData DYM_DeviceSetup = rimd,
        TableData DYM_SyncLog = rimd;
    TableNo = DYM_SyncLog;

    trigger OnRun()
    begin
        process(Rec);
    end;

    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        CacheMgt: Codeunit DYM_CacheManagement;
        MobileDP: Codeunit DYM_MobileDataProcess;
        GeneralDP: Codeunit DYM_GeneralDataProcess;
        XMLMgt: Codeunit DYM_XMLManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        ConstMgt: Codeunit DYM_ConstManagement;
        SyncMgt: Codeunit DYM_SyncManagement;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        EventLogMgt: Codeunit DYM_EventLogManagement;
        ARMgt: Codeunit DYM_ActiveRecManagement;
        ActiveTableRec: Codeunit DYM_ActiveRecManagement;
        ActiveRec: Codeunit DYM_ActiveRecManagement;
        TableBufMgt: Codeunit DYM_TableBufferManagement;
        SetupRead: Boolean;
        SLE: Integer;
        AIEntryNo: Integer;
        Text004: Label 'Device Setup for Salesperson %1 does not exist.';
        Text005: Label 'Device Role %1 does not exist.';
        Text006: Label 'Incorrect use of Device Settings [%1\%2]';
        Text007: Label 'Cannot open %1.';
        Text008: Label 'Unknown Sync ID %1.';
        Text009: Label 'Packet cheskcum match with Sync Log Entry No. %1.';
        Text011: Label 'You have not specified Pull Type in table mapping for Mobile Table %1.';
        Text012: Label 'Invalid Object Type [%1].';
        Text013: Label 'Could not find packet for Sync Log Entry No. %1.';

    [CommitBehavior(CommitBehavior::Ignore)]
    procedure process(var Rec: Record DYM_SyncLog)
    var
        PullType: enum DYM_PullType;
        Challenge: Boolean;
        InS: InStream;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        CacheMgt.ClearCacheBuffer;
        CacheMgt.ClearStateDescription;
        CacheMgt.SetContextSLE(Rec."Entry No.");
        //XMLDom := XMLDom.XmlDocument() ;
        case Rec.Direction of
            Rec.Direction::Push:
                begin
                    //IF NOT Internal THEN BEGIN
                    //  CASE ( ( "Web Service Entry" ) OR ( Path = '' ) ) OF
                    //    FALSE : XMLDom.Load ( Path ) ;
                    //    TRUE : BEGIN
                    //      CALCFIELDS ( Packet ) ;
                    //      IF NOT Packet.HASVALUE THEN
                    //        ERROR ( Text013 , "Entry No." ) ;
                    //      Packet.CREATEINSTREAM ( InS ) ;
                    //      XMLDom.Load ( InS ) ;
                    //    END ;
                    //  END ;
                    //  XMLNode := XMLDom.SelectSingleNode ( ConstMgt.SYN_PrimaryTag ) ;
                    //END ;
                    case Rec.Internal of
                        true:
                            GetSyncParamsInt(Rec, PullType, Challenge);
                        false:
                            GetSyncParams(PullType, Challenge);
                    end;
                    if (UpperCase(Rec.Company) <> UpperCase(CompanyName)) then Rec.FieldError(Company);
                    CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, Rec."Entry No.");
                    CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
                    ProcessPush(Rec.Path, PullType, Challenge);
                    if Rec.Get(Rec."Entry No.") then begin
                        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
                        Rec."Device Role Code" := DeviceRole.Code;
                        Rec."Device Group Code" := DeviceGroup.Code;
                        Rec."Device Setup Code" := DeviceSetup.Code;
                        Rec.Modify;
                    end;
                end;
            Rec.Direction::Pull:
                begin
                end;
        end;
    end;

    procedure GetSyncParams(var PullType: enum DYM_PullType; var Challenge: Boolean)
    var
        DeviceRoleCode: Code[20];
        DeviceGroupCode: Code[20];
        DeviceSetupCode: Code[100];
        ChallangeText: Text[30];
        ReadPolicy: Text[30];
    begin
        Clear(DeviceRoleCode);
        Clear(DeviceGroupCode);
        Clear(DeviceSetupCode);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(ChallangeText);
        //Challenge := LowLevelDP.Text2Boolean ( XMLMgt.TryGetNodeValue ( NL , ConstMgt.SYN_Challenge , FALSE ) ) ;
        Challenge := LowLevelDP.Text2Boolean(ARMgt.GetGlobalAttribute(ConstMgt.SYN_Challenge));
        Clear(ReadPolicy);
        //ReadPolicy := XMLMgt.TryGetNodeValue ( NL , ConstMgt.WSC_ReadPolicy , FALSE ) ;
        ReadPolicy := ARMgt.GetGlobalAttribute(ConstMgt.WSC_ReadPolicy);
        if (ReadPolicy <> '') then CacheMgt.SetGlobalFlag(ConstMgt.WSC_ReadPolicy, ReadPolicy);
        case Challenge of
            true:
                begin
                    //DeviceGroupCode := XMLMgt.TryGetNodeValue ( NL , ConstMgt.SYN_DeviceGroup , FALSE ) ;
                    //DeviceSetupCode := XMLMgt.TryGetNodeValue ( NL , ConstMgt.SYN_DeviceSetup , FALSE ) ;
                    DeviceGroupCode := ARMgt.GetGlobalAttribute(ConstMgt.SYN_DeviceGroup);
                    DeviceSetupCode := ARMgt.GetGlobalAttribute(ConstMgt.SYN_DeviceSetup);
                    if (DeviceSetupCode = '') then PullType := PullType::Group;
                    if (DeviceGroupCode = '') then PullType := PullType::Device;
                    case PullType of
                        PullType::Group:
                            begin
                                if not DeviceGroup.Get(DeviceGroupCode) then Error(Text005, DeviceGroupCode);
                                DeviceSetup.Reset;
                                DeviceSetup.SetRange("Device Group Code", DeviceGroupCode);
                                DeviceSetup.SetRange(Disabled, false);
                                if not DeviceSetup.FindFirst then Error(Text004, DeviceSetupCode);
                                Clear(DeviceSetup);
                            end;
                        PullType::Device:
                            begin
                                DeviceSetup.Reset;
                                DeviceSetup.SetRange(Code, DeviceSetupCode);
                                if not DeviceSetup.FindFirst then Error(Text004, DeviceSetupCode);
                                DeviceSetup.TestField("Device Group Code");
                                if not DeviceGroup.Get(DeviceSetup."Device Group Code") then Error(Text005, DeviceSetup."Device Group Code");
                            end;
                    end;
                    DeviceRoleCode := DeviceGroup."Device Role Code";
                    DeviceGroupCode := DeviceGroup.Code;
                    if not DeviceRole.Get(DeviceRoleCode) then Error(Text008, DeviceRoleCode);
                    DeviceGroup.TestField(Disabled, false);
                    if (PullType = PullType::Group) then Clear(DeviceSetup);
                end;
            false:
                begin
                    //DeviceGroupCode := XMLMgt.TryGetNodeValue ( NL , ConstMgt.SYN_DeviceGroup , FALSE ) ;
                    //DeviceSetupCode := XMLMgt.TryGetNodeValue ( NL , ConstMgt.SYN_DeviceSetup , FALSE ) ;
                    DeviceGroupCode := ARMgt.GetGlobalAttribute(ConstMgt.SYN_DeviceGroup);
                    DeviceSetupCode := ARMgt.GetGlobalAttribute(ConstMgt.SYN_DeviceSetup);
                    if (((DeviceGroupCode = '') and (DeviceSetupCode = '')) or ((DeviceGroupCode <> '') and (DeviceSetupCode <> ''))) then Error(Text006, DeviceGroupCode, DeviceSetupCode);
                    if (DeviceSetupCode = '') then PullType := PullType::Group;
                    if (DeviceGroupCode = '') then PullType := PullType::Device;
                    case PullType of
                        PullType::Group:
                            begin
                                if not DeviceGroup.Get(DeviceGroupCode) then Error(Text005, DeviceGroupCode);
                                DeviceSetup.Reset;
                                DeviceSetup.SetRange("Device Group Code", DeviceGroupCode);
                                DeviceSetup.SetRange(Disabled, false);
                                if not DeviceSetup.FindFirst then Error(Text004, DeviceSetupCode);
                                Clear(DeviceSetup);
                            end;
                        PullType::Device:
                            begin
                                DeviceSetup.Reset;
                                DeviceSetup.SetRange(Code, DeviceSetupCode);
                                if not DeviceSetup.FindFirst then Error(Text004, DeviceSetupCode);
                                DeviceSetup.TestField("Device Group Code");
                                if not DeviceGroup.Get(DeviceSetup."Device Group Code") then Error(Text005, DeviceSetup."Device Group Code");
                            end;
                    end;
                    DeviceGroupCode := DeviceGroup."Device Role Code";
                    if not DeviceRole.Get(DeviceGroupCode) then Error(Text008, DeviceGroupCode);
                    DeviceGroup.TestField(Disabled, false);
                    DeviceSetup.TestField(Disabled, false);
                end;
        end;
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
    end;

    procedure GetSyncParamsInt(SyncLogEntry: Record DYM_SyncLog; var PullType: enum DYM_PullType; var Challenge: Boolean)
    begin
        SyncLogEntry.TestField(Internal);
        if not DeviceRole.Get(SyncLogEntry."Device Role Code") then Clear(DeviceRole);
        if not DeviceGroup.Get(SyncLogEntry."Device Group Code") then Clear(DeviceGroup);
        if not DeviceSetup.Get(SyncLogEntry."Device Setup Code") then Clear(DeviceSetup);
        PullType := SyncLogEntry."Pull Type";
        Challenge := true;
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, SyncLogEntry."Entry No.");
    end;

    procedure InsertSyncLogEntry(FileName: Text[250]; Direction: enum DYM_PacketDirection; PacketType: enum DYM_PacketType; PullType: enum DYM_PullType; Internal: Boolean; WebServiceEntry: Boolean; packetContent: InStream) Result: Integer
    begin
        InsertSyncLogEntry(FileName, Direction, PacketType, PullType, Internal, WebServiceEntry, packetContent, CompanyName);
    end;

    procedure InsertSyncLogEntry(FileName: Text[250]; Direction: enum DYM_PacketDirection; PacketType: enum DYM_PacketType; PullType: enum DYM_PullType; Internal: Boolean; WebServiceEntry: Boolean; packetContent: InStream; _company: Text) Result: Integer
    var
        SyncLog: Record DYM_SyncLog;
        OutS: OutStream;
        F: File;
        NextEntry: Integer;
    begin
        Clear(Result);
        //CLEAR ( NextEntry ) ;
        CacheMgt.GetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        //SyncLog.LOCKTABLE ( TRUE ) ;
        //SyncLog.RESET ;
        //IF SyncLog.FINDLAST THEN
        //  NextEntry := SyncLog."Entry No." ;
        //NextEntry += 1 ;
        SyncLog.Init;
        //SyncLog."Entry No." := NextEntry ;
        Clear(SyncLog."Entry No.");
        SyncLog."Entry TimeStamp" := CreateDateTime(Today, Time);
        SyncLog.Direction := Direction;
        SyncLog.Status := SyncLog.Status::Pending;
        SyncLog.Company := _company;
        SyncLog.Internal := Internal;
        SyncLog.Path := FileName;
        SyncLog."Pull Type" := PullType;
        SyncLog."Packet Type" := PacketType;
        SyncLog."Device Role Code" := DeviceRole.Code;
        SyncLog."Device Group Code" := DeviceGroup.Code;
        SyncLog."Device Setup Code" := DeviceSetup.Code;
        SyncLog."Request Entry No." := SLE;
        SyncLog."Web Service Entry" := WebServiceEntry;
        if (not packetContent.EOS()) then begin
            SyncLog.Packet.CreateOutStream(OutS, TextEncoding::UTF8);
            CopyStream(OutS, packetContent);
        end;
        if not Internal then SyncLog."Packet Size" := SyncLog.Packet.Length();
        SyncLog.Insert;
        exit(SyncLog."Entry No.");
    end;

    procedure CheckMandatorySettings(Direction: enum DYM_PacketDirection)
    var
        Settings: Record DYM_Settings;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Settings.Reset;
        case Direction of
            enum::DYM_PacketDirection::Push:
                Settings.SetFilter("Mandatory for", '%1|%2', Settings."Mandatory for"::Both, Settings."Mandatory for"::Push);
            enum::DYM_PacketDirection::Pull:
                Settings.SetFilter("Mandatory for", '%1|%2', Settings."Mandatory for"::Both, Settings."Mandatory for"::Pull);
        end;
        Settings.SetFilter("Applies-to Device Role", '%1|%2', DeviceRole.Code, '');
        if Settings.FindSet(false, false) then
            repeat
                SettingsMgt.TestSetting(Settings.Code);
            until Settings.Next = 0;
    end;

    procedure testChecksum(_SyncLog: Record DYM_SyncLog)
    var
        lSyncLog: Record DYM_SyncLog;
        doChecksumTest: Boolean;
    begin
        doChecksumTest := true;
        if (MobileSetup."Skip Checksum check") then clear(doChecksumTest);
        if (_SyncLog.CheckSum = '') then clear(doChecksumTest);
        if (_SyncLog.Direction = _SyncLog.Direction::Pull) then clear(doChecksumTest);
        if ((_SyncLog.Direction = _SyncLog.Direction::Push) and (_SyncLog.Internal)) then clear(doChecksumTest);
        if (doChecksumTest) then begin
            lSyncLog.Reset;
            lSyncLog.SetCurrentKey(Direction, Company, "NAS ID", "Device Role Code", "Device Group Code", "Device Setup Code", Checksum);
            lSyncLog.SetRange(Direction, _SyncLog.Direction);
            lSyncLog.SetRange(Company, _SyncLog.Company);
            lSyncLog.SetRange(Internal, false);
            lSyncLog.SetRange("Device Group Code", DeviceGroup.Code);
            lSyncLog.SetRange("Device Setup Code", DeviceSetup.Code);
            lSyncLog.SetRange(Checksum, _SyncLog.Checksum);
            lSyncLog.SetFilter(Status, '%1|%2', lSyncLog.Status::Success, lSyncLog.Status::InProgress);
            lSyncLog.SetFilter("Entry No.", '<>%1', _SyncLog."Entry No.");
            if lSyncLog.FindFirst then Error(Text009, lSyncLog."Entry No.");
        end;
    end;
    #region Push
    procedure ProcessPush(FileName: Text[250]; PullType: enum DYM_PullType; Challenge: Boolean)
    var
        _PacketDoc: XmlDocument;
        _NodeList: XmlNodeList;
        _Node: XmlNode;
        _ResponseDoc: XmlDocument;
        _ResponseRootNode: XmlNode;
        SyncLog: Record DYM_SyncLog;
        InS: InStream;
        i: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        CacheMgt.ClearCacheBuffer;
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        if not Challenge then CheckMandatorySettings(enum::DYM_PacketDirection::Push);
        //InitBuffers ( TRUE ) ;
        if not SyncLog.Get(SLE) then Clear(SyncLog);
        testChecksum(SyncLog);
        if not Challenge then begin
            CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
            if (SLE = 0) and (MobileSetup."Packet Process Retry Enabled") then exit;
            //if IsNull(XMLDom) then
            //    XMLDom := XMLDom.XmlDocument();
            //ProcessPullInit(XMLDomResponse, NodeRootResponse, PullType);
            ProcessPullInit(_ResponseDoc, _ResponseRootNode, PullType);
            SyncLog.CalcFields(Packet);
            SyncLog.Packet.CreateInStream(InS, TextEncoding::UTF8);
            //XMLDom.Load(InS);
            XmlDocument.ReadFrom(InS, _PacketDoc);
            /*
            XMLNodeList := XMLDom.SelectNodes(ConstMgt.SYN_PrimaryTag + '/' + ConstMgt.SYN_Table +
                                                   XMLMgt.GetXPathFilter(ConstMgt.SYN_Context, LowLevelDP.Boolean2Text(true)));
            for i := 0 to (XMLNodeList.Count - 1) do begin
                XMLNode := XMLNodeList.Item(i);
                MobileDP.ProcessContextTablePush(XMLNode);
            end;
            */
            _PacketDoc.AsXmlNode().SelectNodes(ConstMgt.SYN_PrimaryTag + '/' + ConstMgt.SYN_Table + XMLMgt.GetXPathFilter(ConstMgt.SYN_Context, LowLevelDP.Boolean2Text(true)), _NodeList);
            for i := 1 to _NodeList.Count() do begin
                _NodeList.Get(i, _Node);
                MobileDP.ProcessContextTablePush(_Node);
            end;
            //TODO: Definitely needs fix (xml handling)
            //
            //XMLNodeList := XMLDom.SelectNodes ( ConstMgt.SYN_PrimaryTag + '/' + ConstMgt.SYN_Table ) ;
            //FOR i := 0 TO ( XMLNodeList.Count - 1 ) DO BEGIN
            //  XMLNode := XMLNodeList.Item ( i ) ;
            //
            //  IF CacheMgt.CheckGlobalFlag ( ConstMgt.WSC_ReadPolicy , ConstMgt.WSC_ReadPolicy_Standard ) THEN
            //    ProcessPushTableStdRead ( XMLNode , NodeRootResponse )
            //  ELSE
            //    ProcessPushTable ( XMLNode , NodeRootResponse ) ;
            //END ;
            if ActiveTableRec.FindTable then
                repeat
                    case ActiveTableRec.CheckGlobalAttribute(ConstMgt.WSC_ReadPolicy, ConstMgt.WSC_ReadPolicy_Standard) of
                        true:
                            ProcessPushTableStdRead(_Node, _ResponseRootNode);
                        false:
                            ProcessPushTable(_Node, _ResponseRootNode);
                    end;
                until not ActiveTableRec.NextTable;
            ProcessPushCallBusinessHandler;
            //if ((SyncLog."Web Service Entry") or (Challenge)) then
            //    ProcessPullFinalize(XMLDomResponse, GeneratePullFileName(PullType, DeviceRole, DeviceGroup, DeviceSetup), PullType);
            if ((SyncLog."Web Service Entry") or (Challenge)) then ProcessPullFinalize(_ResponseDoc, GeneratePullFileName(PullType, DeviceRole, DeviceGroup, DeviceSetup), PullType);
        end
        else begin
            if ((not MobileSetup."Pull Disabled") and (Challenge)) then begin
                case SyncLog."Packet Type" of
                    SyncLog."Packet Type"::Data:
                        begin
                            if (PullType = PullType::Device) then ProcessPull(GeneratePullFileName(PullType, DeviceRole, DeviceGroup, DeviceSetup), PullType::Group);
                            ProcessPull(GeneratePullFileName(PullType, DeviceRole, DeviceGroup, DeviceSetup), PullType);
                            if (PullType = PullType::Group) then begin
                                DeviceSetup.Reset;
                                DeviceSetup.SetRange("Device Role Code", DeviceRole.Code);
                                DeviceSetup.SetRange("Device Group Code", DeviceGroup.Code);
                                DeviceSetup.SetRange(Disabled, false);
                                if DeviceSetup.FindSet(false, false) then
                                    repeat
                                        ProcessPull(GeneratePullFileName(PullType::Device, DeviceRole, DeviceGroup, DeviceSetup), PullType::Device);
                                    until DeviceSetup.Next = 0;
                            end;
                        end;
                    SyncLog."Packet Type"::DES:
                        SyncMgt.ExportDES;
                    SyncLog."Packet Type"::DBS:
                        SyncMgt.ExportDBS;
                end;
            end;
        end;
        /*
        if (not SyncLog."Web Service Entry") then
            CacheMgt.ClearCacheBuffer;
        */
        CacheMgt.ClearXMLCache;
    end;

    procedure ProcessPushTable(NodeIn: XmlNode; var NodeOut: XmlNode)
    var
        TableMap: Record DYM_MobileTableMap;
        RecRef: RecordRef;
        ResponseRecRef: RecordRef;
        TableName: Text[30];
        i: Integer;
        CRUDCycle: Integer;
        CRUDCyclesCount: Integer;
        CallTriggers: Boolean;
    begin
        Clear(MobileDP);
        Clear(AIEntryNo);
        Clear(CRUDCycle);
        Clear(CRUDCyclesCount);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        //TableName := XMLMgt.GetNodeValue ( NodeIn , ConstMgt.SYN_TableName , FALSE ) ;
        TableName := ActiveTableRec.GetTableName;
        if (TableName = ConstMgt.RPC_VirtualTableName) then begin
            ProcessPushRPC(NodeIn);
            ProcessPushRPCResponse(NodeOut);
            exit;
        end;
        TableMap.Reset;
        TableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        TableMap.SetRange("Device Role Code", DeviceRole.Code);
        TableMap.SetRange("Mobile Table", TableName);
        TableMap.SetFilter(Direction, '%1|%2', TableMap.Direction::Both, TableMap.Direction::Push);
        TableMap.SetRange(Disabled, false);
        if TableMap.FindSet(false, false) then
            repeat
                case TableMap."Use specific push handler" of
                    true:
                        CRUDCyclesCount := 0;
                    false:
                        CRUDCyclesCount := 4;
                end;
                ActiveRec.ReadTable(TableName);
                for CRUDCycle := 0 to CRUDCyclesCount do begin
                    ActiveRec.ClearFilters;
                    case CRUDCycle of //ConstMgt.CRD_None :
                                      //  CASE TableMap."Use specific push handler" OF
                                      //    TRUE : XMLNodeList := NodeIn.SelectNodes ( ConstMgt.SYN_Record ) ;
                                      //    FALSE : XMLNodeList := NodeIn.SelectNodes ( ConstMgt.SYN_Record + XMLMgt.GetXPathMissingFilter ( ConstMgt.SYN_RecordType ) ) ;
                                      //  END ;
                                      //ConstMgt.CRD_Create :
                                      //  XMLNodeList := NodeIn.SelectNodes ( ConstMgt.SYN_Record + XMLMgt.GetXPathFilter ( ConstMgt.SYN_RecordType , ConstMgt.PRS_Create ) ) ;
                                      //ConstMgt.CRD_Read :
                                      //  XMLNodeList := NodeIn.SelectNodes ( ConstMgt.SYN_Record + XMLMgt.GetXPathFilter ( ConstMgt.SYN_RecordType , ConstMgt.PRS_Read ) ) ;
                                      //ConstMgt.CRD_Update :
                                      //  XMLNodeList := NodeIn.SelectNodes ( ConstMgt.SYN_Record + XMLMgt.GetXPathFilter ( ConstMgt.SYN_RecordType , ConstMgt.PRS_Update ) ) ;
                                      //ConstMgt.CRD_Delete :
                                      //  XMLNodeList := NodeIn.SelectNodes ( ConstMgt.SYN_Record + XMLMgt.GetXPathFilter ( ConstMgt.SYN_RecordType , ConstMgt.PRS_Delete ) ) ;
                        ConstMgt.CRD_None:
                            if not TableMap."Use specific push handler" then
                                ActiveRec.SetRecordMissingAttributeFilter(ConstMgt.SYN_RecordType);
                        ConstMgt.CRD_Create:
                            ActiveRec.SetRecordAttributeFilter(ConstMgt.SYN_RecordType, ConstMgt.PRS_Create);
                        ConstMgt.CRD_Read:
                            ActiveRec.SetRecordAttributeFilter(ConstMgt.SYN_RecordType, ConstMgt.PRS_Read);
                        ConstMgt.CRD_Update:
                            ActiveRec.SetRecordAttributeFilter(ConstMgt.SYN_RecordType, ConstMgt.PRS_Update);
                        ConstMgt.CRD_Delete:
                            ActiveRec.SetRecordAttributeFilter(ConstMgt.SYN_RecordType, ConstMgt.PRS_Delete);
                    end;
                    //IF ( XMLNodeList.Count <> 0 ) THEN BEGIN
                    if (ActiveTableRec.TableRecordsCount <> 0) then begin
                        RecRef.Open(TableMap."Table No.", true);
                        ResponseRecRef.Open(TableMap."Table No.", true);
                        RecRef.Reset;
                        RecRef.DeleteAll;
                        //FOR i := 0 TO ( XMLNodeList.Count - 1 ) DO BEGIN
                        //  XMLNode := XMLNodeList.Item ( i ) ;
                        //  CacheMgt.SetRecNoContext ( i + 1 ) ;
                        //  CLEAR ( CallTriggers ) ;
                        //  CallTriggers := LowLevelDP.Text2Boolean ( XMLMgt.TryGetNodeValue ( XMLNode , ConstMgt.WSC_CallTriggers , FALSE ) ) ;
                        //  MobileDP.ProcessTablePush ( XMLNode , RecRef , TableMap , CRUDCycle ) ;
                        //END ;
                        if ActiveRec.FindRecord then
                            repeat
                                CacheMgt.SetRecNoContext(ActiveRec.GetRecordNo);
                                Clear(CallTriggers);
                                CallTriggers := LowLevelDP.Text2Boolean(ActiveRec.GetRecordAttribute(ConstMgt.WSC_CallTriggers));
                            //MobileDP.ProcessTablePush(RecRef, TableMap, CRUDCycle, ActiveRec.GetActiveRecContext);
                            until not ActiveRec.NextRecord;
                        case TableMap."Use specific push handler" of
                            true:
                                ProcessPushTableSpecific(RecRef, TableMap);
                            false:
                                GeneralDP.PushProcessGeneral(RecRef, TableMap, CRUDCycle, CallTriggers, ResponseRecRef);
                        end;
                        MobileDP.ProcessTablePull(NodeOut, ResponseRecRef, TableMap);
                        ResponseRecRef.Close;
                        RecRef.Close;
                    end;
                end;
            until TableMap.Next = 0;
    end;

    procedure ProcessPushTableSpecific(var TableData: RecordRef; var TableMap: Record DYM_MobileTableMap)
    begin
        //Switched to Raw Data
        //Customer specific Push Handlers
    end;

    procedure ProcessPushCallBusinessHandler()
    var
        IsHandled: Boolean;
    begin
        clear(IsHandled);
        OnBeforeCallBusinessHandler(IsHandled);
        if not IsHandled then CODEUNIT.Run(DeviceRole."NAV Processing Codeunit");
        OnAfterCallBusinessHandler();
    end;

    procedure ProcessPushRPC(NodeIn: XmlNode)
    var
        _NodeList: XmlNodeList;
        _Node: XmlNode;
        _KeyValueNodeList: XmlNodeList;
        _KeyValueNode: XmlNode;
        _DataInNodeList: XmlNodeList;
        _DataInNode: XmlNode;
        ObjectType: Text[250];
        ObjectNo: Text[250];
        DataIn: Text[250];
        i: Integer;
        j: Integer;
        k: Integer;
        l: Integer;
    begin
        /*
        XMLNodeList := NodeIn.SelectNodes(ConstMgt.RPC_Call);
        for i := 0 to (XMLNodeList.Count - 1) do begin
            XMLNode := XMLNodeList.Item(i);
            KeyValueNodeList := XMLNode.ChildNodes;
            for j := 0 to (KeyValueNodeList.Count - 1) do begin
                KeyValueNode := KeyValueNodeList.Item(j);
                if (KeyValueNode.Name = ConstMgt.RPC_DataIn) then begin
                    DataInNodeList := KeyValueNode.ChildNodes;
                    for k := 0 to (DataInNodeList.Count - 1) do begin
                        DataInNode := DataInNodeList.Item(k);
                        for l := 0 to (DataInNodeList.Count - 1) do begin
                            KeyValueNode := KeyValueNodeList.Item(l);
                            CacheMgt.SetRPCCache(ConstMgt.DIR_Push, DataInNode.Name, DataInNode.InnerText);
                        end;
                    end;
                end else
                    CacheMgt.SetRPCCache(ConstMgt.DIR_Push, KeyValueNode.Name, KeyValueNode.InnerText);

            end;

            CODEUNIT.Run(CODEUNIT::"RPC Dispatcher");
        end;
        */
        NodeIn.SelectNodes(ConstMgt.RPC_Call, _NodeList);
        for i := 1 to _NodeList.Count() do begin
            _NodeList.Get(i, _Node);
            _KeyValueNodeList := _Node.AsXmlElement().GetChildNodes();
            for j := 1 to _KeyValueNodeList.Count() do begin
                _KeyValueNodeList.Get(j, _KeyValueNode);
                if (_KeyValueNode.AsXmlElement().Name = ConstMgt.RPC_DataIn) then begin
                    _DataInNodeList := _KeyValueNode.AsXmlElement().GetChildNodes();
                    for k := 1 to _DataInNodeList.Count() do begin
                        _DataInNodeList.Get(k, _DataInNode);
                        for l := 1 to _DataInNodeList.Count() do begin
                            _KeyValueNodeList.Get(l, _KeyValueNode);
                            CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Push, _DataInNode.AsXmlElement().Name, _DataInNode.AsXmlElement().InnerText, ConstMgt.RPC_SystemRecID());
                        end;
                    end;
                end
                else
                    CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Push, _KeyValueNode.AsXmlElement().Name, _KeyValueNode.AsXmlElement().InnerText, ConstMgt.RPC_SystemRecID());
            end;
            CODEUNIT.Run(CODEUNIT::"DYM_RPCDispatcher");
        end;
    end;

    procedure ProcessPushRPCResponse(var NodeOut: XmlNode)
    var
        ObjectType: Text;
        ObjectNo: Text;
        _DataInNode: XmlNode;
        _DataOutNode: XmlNode;
        _DummyNode: XmlNode;
    begin
        XMLMgt.AddElement(NodeOut, ConstMgt.RPC_DataIn, '', _DatainNode);
        if CacheMgt.FindRPCCache(enum::DYM_PacketDirection::Push) then
            repeat
                XMLMgt.AddElement(_DatainNode, CacheMgt.CacheBufferRecID, CacheMgt.CacheBufferData, _DummyNode);
            until CacheMgt.NextRPCCache = 0;
        XMLMgt.AddElement(NodeOut, ConstMgt.RPC_DataOut, '', _DataoutNode);
        if CacheMgt.FindRPCCache(enum::DYM_PacketDirection::Pull) then
            repeat
                XMLMgt.AddElement(_DataoutNode, CacheMgt.CacheBufferRecID, CacheMgt.CacheBufferData, _DummyNode);
            until CacheMgt.NextRPCCache = 0;
    end;

    procedure ProcessPushContext(NodeIn: XmlNode; var NodeOut: XmlNode)
    var
        _NodeListTables: XmlNodeList;
        _NodeTable: XmlNode;
        TableName: Text[30];
        i: Integer;
    begin
        /*
        NodeListTables := NodeIn.SelectNodes(ConstMgt.SYN_Table);
        for i := 0 to (NodeListTables.Count - 1) do begin
            NodeTable := NodeListTables.Item(i);
            TableName := XMLMgt.GetNodeValue(NodeTable, ConstMgt.SYN_TableName, false);
            CacheMgt.SetTableNameFlag(TableName, ConstMgt.CBF_Context, '');
            ProcessPushTable(NodeTable, NodeOut);
        end;
        */
        NodeIn.SelectNodes(ConstMgt.SYN_Table, _NodeListTables);
        for i := 1 to _NodeListTables.Count() do begin
            _NodeListTables.Get(i, _NodeTable);
            TableName := XMLMgt.GetNodeValue(_NodeTable, ConstMgt.SYN_TableName, false);
            CacheMgt.SetTableNameFlag(TableName, ConstMgt.CBF_Context, '');
            ProcessPushTable(_NodeTable, NodeOut);
        end;
    end;

    procedure ProcessPushTableStdRead(NodeIn: XmlNode; var NodeOut: XmlNode)
    var
        TableMap: Record DYM_MobileTableMap;
        DummyParentTableMap: Record DYM_MobileTableMap;
        DummyRecRef: RecordRef;
        RecRef: RecordRef;
        ResponseRecRef: RecordRef;
        TableName: Text[30];
        i: Integer;
        CRUDCycle: Integer;
        CRUDCyclesCount: Integer;
        CallTriggers: Boolean;
        DirectResponse: Boolean;
    begin
        Clear(MobileDP);
        Clear(AIEntryNo);
        Clear(CRUDCycle);
        Clear(CRUDCyclesCount);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        //TableName := XMLMgt.GetNodeValue ( NodeIn , ConstMgt.SYN_TableName , FALSE ) ;
        TableName := ActiveTableRec.GetTableName;
        TableMap.Reset;
        TableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        TableMap.SetRange("Device Role Code", DeviceRole.Code);
        TableMap.SetRange("Mobile Table", TableName);
        TableMap.SetFilter(Direction, ConstMgt.OrFilter(2), TableMap.Direction::Both, TableMap.Direction::Pull);
        TableMap.SetRange(Disabled, false);
        if TableMap.FindSet(false, false) then
            repeat
                Clear(DummyParentTableMap);
                Clear(DummyRecRef);
                ResponseRecRef.Open(TableMap."Table No.", true);
                case TableMap."Use specific pull handler" of
                    true:
                        ProcessPullTableSpecific(DummyParentTableMap, DummyRecRef, TableMap, ResponseRecRef, enum::DYM_PullType::Device);
                    false:
                        GeneralDP.PullProcessGeneral(DummyRecRef, ResponseRecRef, TableMap, false);
                end;
                ResponseRecRef.Reset;
                MobileDP.ProcessTablePull(NodeOut, ResponseRecRef, TableMap);
                ResponseRecRef.Close;
            until TableMap.Next = 0;
    end;
    #endregion 
    #region Pull
    procedure ProcessPullInit(var PacketDoc: XmlDocument; var RootNode: XmlNode; PullType: enum DYM_PullType)
    var
        RootElement: XmlElement;
    begin
        case CacheMgt.CheckXMLCache of
            false:
                begin
                    XMLMgt.CreateRootXML(RootNode, PacketDoc, PullType);
                    XMLMgt.AddAttribute(RootNode, ConstMgt.SYN_DeviceSetup, DeviceSetup.Code);
                end;
            true:
                begin
                    CacheMgt.GetXMLCache(PacketDoc);
                    //NodeRoot := XMLDom.DocumentElement;
                    PacketDoc.GetRoot(RootElement);
                    RootNode := RootElement.AsXmlNode();
                    XMLMgt.AddAttribute(RootNode, ConstMgt.SYN_DeviceSetup, DeviceSetup.Code);
                end;
        end;
    end;

    procedure ProcessPullFinalize(var PacketDoc: XmlDocument; FileName: Text[250]; PullType: enum DYM_PullType)
    var
        TempPacketContent: Codeunit "Temp Blob";
        TempPacketInS: InStream;
        OutS: OutStream;
    begin
        case PullType of
            PullType::Group:
                begin
                    CacheMgt.SetXMLCache(PacketDoc);
                end;
            PullType::Device:
                begin
                    TempPacketContent.CreateOutStream(OutS, TextEncoding::UTF8);
                    PacketDoc.WriteTo(OutS);
                    TempPacketContent.CreateInStream(TempPacketInS, TextEncoding::UTF8);
                    InsertSyncLogEntry(FileName, enum::DYM_PacketDirection::Pull, enum::DYM_PacketType::Data, enum::DYM_PullType::Device, false, false, TempPacketInS);
                end;
        end;
    end;

    procedure ProcessPull(FileName: Text[250]; PullType: enum DYM_PullType)
    var
        PacketDoc: XmlDocument;
        RootNode: XmlNode;
        TableMap: Record DYM_MobileTableMap;
        DummyParentTableMap: Record DYM_MobileTableMap;
        DummyRecRef: RecordRef;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(DummyRecRef);
        Clear(DummyParentTableMap);
        TableBufMgt.ClearTableBuffers();
        Clear(MobileDP);
        Clear(GeneralDP);
        CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, SLE);
        CacheMgt.ClearTableMetadata();
        CheckMandatorySettings(enum::DYM_PacketDirection::Pull);
        //InitBuffers ( TRUE ) ;
        ProcessPullInit(PacketDoc, RootNode, PullType);
        TableMap.Reset;
        TableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        TableMap.SetRange("Device Role Code", DeviceRole.Code);
        TableMap.SetFilter(Direction, '%1|%2', TableMap.Direction::Both, TableMap.Direction::Pull);
        TableMap.SetRange(Disabled, false);
        TableMap.SetRange("Pull Type", TableMap."Pull Type"::None);
        if TableMap.FindFirst then Error(Text011, TableMap."Mobile Table");
        TableMap.Reset;
        TableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        TableMap.SetRange("Device Role Code", DeviceRole.Code);
        TableMap.SetFilter(Direction, '%1|%2', TableMap.Direction::Both, TableMap.Direction::Pull);
        TableMap.SetRange("Parent Table No.", 0);
        TableMap.SetRange(Disabled, false);
        case PullType of
            PullType::Group:
                TableMap.SetRange("Pull Type", TableMap."Pull Type"::Group);
            PullType::Device:
                TableMap.SetRange("Pull Type", TableMap."Pull Type"::Device);
        end;
        if TableMap.FindSet(false, false) then
            repeat
                ProcessPullTable(DummyParentTableMap, DummyRecRef, TableMap, RootNode, PullType);
            until TableMap.Next = 0;
        //Add metadata during Device pull part, which is after Group part
        if (PullType = PullType::Device) then if (SettingsMgt.CheckSetting(ConstMgt.BOS_GeneratePullPacketMetadata())) then MobileDP.ProcessMetadataPull(RootNode);
        ProcessPullFinalize(PacketDoc, FileName, PullType);
    end;

    procedure ProcessPullTable(var ParentTableMap: Record DYM_MobileTableMap; var ParentTableData: RecordRef; var TableMap: Record DYM_MobileTableMap; var XMLRoot: XmlNode; PullType: enum DYM_PullType)
    var
        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
        PacketDoc: XmlDocument;
        RootElement: XmlElement;
        RecRef: RecordRef;
        ChildTableMap: Record DYM_MobileTableMap;
        LastProcessedMobileTable: Text[30];
        PerfCounterId: Integer;
    begin
        //EventLogMgt.LogProcessDebug_MethodStart();
        //StartingTimestamp := CreateDateTime(today, time);
        PerfCounterId := CacheMgt.StartPerfCounter();
        HeartBeatMgt.CreateHeartBeat_Pull(TableMap);
        RecRef.Open(TableMap."Table No.", true);
        case TableMap."Use specific pull handler" of
            true:
                ProcessPullTableSpecific(ParentTableMap, ParentTableData, TableMap, RecRef, PullType);
            false:
                GeneralDP.PullProcessGeneral(ParentTableData, RecRef, TableMap, false);
        end;
        TableBufMgt.SetTableBuffer(RecRef);
        MobileDP.ProcessTablePull(XMLRoot, RecRef, TableMap);
        ChildTableMap.Reset;
        ChildTableMap.SetCurrentKey("Device Role Code", "Sync. Priority", "Mobile Table", Direction);
        ChildTableMap.SetRange("Device Role Code", DeviceRole.Code);
        ChildTableMap.SetFilter(Direction, '%1|%2', ChildTableMap.Direction::Both, ChildTableMap.Direction::Pull);
        ChildTableMap.SetRange("Parent Table No.", TableMap."Table No.");
        if (TableMap."Fields Defined by Table Index" = 0) then ChildTableMap.SetRange("Parent Table Index", TableMap.Index);
        ChildTableMap.SetRange("Relation Type", ChildTableMap."Relation Type"::Regular);
        ChildTableMap.SetRange(Disabled, false);
        case PullType of
            PullType::Group:
                ChildTableMap.SetRange("Pull Type", ChildTableMap."Pull Type"::Group);
            PullType::Device:
                ChildTableMap.SetRange("Pull Type", ChildTableMap."Pull Type"::Device);
        end;
        if ChildTableMap.FindSet(false, false) then
            repeat
                ProcessPullTable(TableMap, RecRef, ChildTableMap, XMLRoot, PullType);
            until ChildTableMap.Next = 0;
        LastProcessedMobileTable := TableMap."Mobile Table";
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_PullDuration(TableMap."Mobile Table", PerfCounterId, RecRef);
        RecRef.Close;
    end;

    procedure ProcessPullTableSpecific(var ParentTableMap: Record DYM_MobileTableMap; var ParentTableData: RecordRef; var TableMap: Record DYM_MobileTableMap; var TableData: RecordRef; PullType: enum DYM_PullType)
    var
        GeneralDP: Codeunit DYM_GeneralDataProcess;
        DynamicsMobileSetup: Record DYM_DynamicsMobileSetup;
        DynamicsMobileSetupBuffer: Record DYM_DynamicsMobileSetup temporary;
        DummyFieldMap: Record DYM_MobileFieldMap;
        RecRef: RecordRef;
        IsHandled: Boolean;
        PerfCounterId: Integer;
    begin
        //Customer specific Pull Handlers
        //EventLogMgt.LogProcessDebug_MethodStart();
        PerfCounterId := CacheMgt.StartPerfCounter();
        RecRef.Open(TableMap."Table No.");
        RecRef.Reset();
        if (TableMap.Key = 0) then
            GeneralDP.PullProcessAutoSelectKey(RecRef, TableMap)
        else
            RecRef.CurrentKeyIndex(TableMap.Key);
        GeneralDP.PullProcessApplyStaticFilters(RecRef, TableMap, false, DummyFieldMap);
        OnProcessPullTableSpecific(ParentTableMap, TableMap, RecRef);
        TableBufMgt.GetTableBuffer(TableMap."Table No.", TableData);
        //EventLogMgt.LogProcessInfo(StrSubstNo('[%1][%2]', TableMap."Table No.", TableData.Count), '');
        //Handled in specific handler event subscribers
        /*
        if not IsHandled then begin
            case TableMap."Table No." of
                DATABASE::DYM_DynamicsMobileSetup:
                    begin
                        Dispatcher.PullProcessDynamicsMobileSetup(DynamicsMobileSetup, DynamicsMobileSetupBuffer);
                        TableData.GetTable(DynamicsMobileSetupBuffer);
                    end;
                DATABASE::"Sales Invoice Header":
                    begin
                        Dispatcher.PullProcessReturnHeadersData(ParentTableData, RecRef, TableData, TableMap);
                    end;
                DATABASE::"Sales Invoice Line":
                    begin
                        Dispatcher.PullProcessReturnLinesData(TableData, TableMap);
                    end;
                DATABASE::"Item Ledger Entry":
                    begin
                        Dispatcher.PullProcessReturnLinesTrackingData(TableData, TableMap);
                    end;
            end;
        end;
        */
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_PullDuration(TableMap."Mobile Table", PerfCounterId, TableData);
    end;

    procedure GeneratePullFileName(PullType: enum DYM_PullType; var DeviceRole: Record DYM_DeviceRole; var DeviceGroup: Record DYM_DeviceGroup; var DeviceSetup: Record DYM_DeviceSetup) Result: Text[250]
    var
        GUID: Text[250];
        Extension: Text[250];
        RoleFileNamePrefix: Label '%1_%2_%3_%4_', Locked = true;
        DeviceFileNamePrefix: Label '%1_%2_%3_%4_%5_', Locked = true;
    begin
        Clear(Result);
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Extension := '.xml';
        case SettingsMgt.GetSetting(ConstMgt.BOS_PacketStorageType()) of
            ConstMgt.BOS_PacketStorageType_FileSystem():
                Begin
                    Result := MobileSetup."Packet Storage Path";
                    if (Result <> '') then begin
                        if (CopyStr(Result, StrLen(Result), 1) <> '\') then Result += '\';
                        case PullType of
                            PullType::Group:
                                Result += StrSubstNo(RoleFileNamePrefix, Format(PullType), DeviceRole.Code, CompanyName, DeviceGroup.Code);
                            PullType::Device:
                                Result += StrSubstNo(DeviceFileNamePrefix, Format(PullType), DeviceRole.Code, CompanyName, DeviceGroup.Code, DeviceSetup.Code);
                        end;
                        GUID := Format(CreateGuid);
                        Result += CopyStr(GUID, 2, StrLen(GUID) - 2);
                        Result += Extension;
                    end;
                end;
            ConstMgt.BOS_PacketStorageType_DMCloud():
                begin
                    GUID := Format(CreateGuid);
                    Result += CopyStr(GUID, 2, StrLen(GUID) - 2);
                end;
        end;
    end;
    #endregion 
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCallBusinessHandler(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCallBusinessHandler()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessPullTableSpecific(var ParentTableMap: Record DYM_MobileTableMap; var TableMap: Record DYM_MobileTableMap; var FilterRecordRef: RecordRef)
    begin
    end;
}
