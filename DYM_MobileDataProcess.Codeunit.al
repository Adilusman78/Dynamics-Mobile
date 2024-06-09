codeunit 84002 DYM_MobileDataProcess
{
    Permissions = TableData DYM_DynamicsMobileSetup=rimd;

    trigger OnRun()
    begin
    end;
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    XMLMgt: Codeunit DYM_XMLManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    EventLogMgt: Codeunit DYM_EventLogManagement;
    DataLogMgt: Codeunit DYM_DataLogManagement;
    SessionMgt: Codeunit DYM_SessionManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    AIEntryNo: Integer;
    SLE: Integer;
    SetupRead: Boolean;
    procedure ModifySetup()
    begin
        MobileSetup.Modify;
        SetupRead:=false;
    end;
    procedure ProcessTablePush(var RecRef: RecordRef; var TableMap: Record DYM_MobileTableMap; CRUDType: Integer; ActiveRecContext: Text)
    var
        FieldMap: Record DYM_MobileFieldMap;
        PushBuffer: Record DYM_CacheBuffer temporary;
        FldRef: FieldRef;
        FldType: Integer;
        SessionBased: Boolean;
        SessionValue: Text[250];
        TempText: Text[250];
        BinaryData: BigText;
        BlobFileName: Text;
        ForceValidate: Boolean;
        DirectResponse: Boolean;
        ActiveRec: Codeunit DYM_ActiveRecManagement;
    begin
        ActiveRec.SetActiveRecContext(ActiveRecContext);
        RecRef.Init;
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        DeviceSetup.CalcFields("Salesperson Name", "Location Name");
        Clear(DirectResponse);
        DirectResponse:=LowLevelDP.Text2Boolean(ActiveRec.GetRecordAttribute(ConstMgt.SYN_DirectResponse));
        FieldMap.Reset;
        FieldMap.SetCurrentKey("Device Role Code", "Table No.", "Table Index", "Sync. Priority");
        FieldMap.SetRange("Device Role Code", DeviceRole.Code);
        FieldMap.SetRange("Table No.", TableMap."Table No.");
        if(TableMap."Fields Defined by Table Index" = 0)then FieldMap.SetRange("Table Index", TableMap.Index)
        else
            FieldMap.SetRange("Table Index", TableMap."Fields Defined by Table Index");
        FieldMap.SetRange(Disabled, false);
        FieldMap.SetFilter(Direction, '%1|%2|%3', FieldMap.Direction::Both, FieldMap.Direction::Push, FieldMap.Direction::Internal);
        if FieldMap.FindSet(false, false)then begin
            repeat if(FieldMap."Field No." = 0)then begin
                    PushBuffer.Init;
                    PushBuffer."Mobile Field":=FieldMap."Mobile Field";
                    //PushBuffer.Data := XMLMgt.GetNodeValue ( NodeIn , FieldMap."Mobile Field" , TRUE ) ;
                    PushBuffer.Data:=ActiveRec.TextField(FieldMap."Mobile Field");
                    PushBuffer.Insert;
                end
                else
                begin
                    Clear(SessionBased);
                    Clear(SessionValue);
                    CacheMgt.SetFieldMapContext(FieldMap);
                    FieldMap.CalcFields(FieldMap."NAV Field Name", FieldMap."NAV Table Name");
                    FldRef:=RecRef.Field(FieldMap."Field No.");
                    FldType:=LowLevelDP.GetFieldType(RecRef.Number, FldRef.Number);
                    if((FieldMap.Direction = FieldMap.Direction::Internal) and (FieldMap."Session Value" <> ''))then begin
                        SessionBased:=true;
                        SessionValue:=SessionMgt.GetSessionValue(FieldMap."Session Value");
                    end;
                    Clear(ForceValidate);
                    ForceValidate:=LowLevelDP.Text2Boolean(ActiveRec.GetFieldAttribute(FieldMap."Mobile Field", ConstMgt.SYN_Validate));
                    if ForceValidate then CacheMgt.SetFieldFlag(TableMap."Table No.", TableMap.Index, FieldMap."Field No.", FieldMap."Field Index", FieldMap."Mobile Field", '', ConstMgt.CBF_Validate);
                    if(FieldMap.IsAutoIncrementPush)then begin
                        FldRef.Value:=AIEntryNo;
                        AIEntryNo+=1;
                    end
                    else
                    begin
                        case SessionBased of true: TempText:=SessionValue;
                        false: case FldType of ConstMgt.FDT_BLOB: ActiveRec.BLOB2BLOBFieldRef(FieldMap."Mobile Field", FldRef);
                            ConstMgt.FDT_Media: ActiveRec.BLOB2MediaFieldRef(FieldMap."Mobile Field", FldRef);
                            else
                                TempText:=ActiveRec.TextField(FieldMap."Mobile Field");
                            end;
                        end;
                        if not(FldType in[ConstMgt.FDT_BLOB, ConstMgt.FDT_Media])then begin
                            if(TempText = '')then EventLogMgt.LogWarning(SLE, enum::DYM_EventLogSourceType::Processing, StrSubstNo(ConstMgt.MSG_0024, FieldMap.GetMobileTableName, FieldMap."Mobile Field"), '');
                            if(((not SettingsMgt.CheckSetting(ConstMgt.BOS_SkipMissingTags)) and (TempText = '')) or (TempText <> ''))then LowLevelDP.Value2FldRef(FldRef, TempText);
                        end;
                    end;
                    FieldMap.CalcFields("NAV Field Name");
                end;
            until FieldMap.Next = 0;
            RecRef.Insert;
            CacheMgt.UpdateCacheBuffer(TableMap."Table No.", TableMap.Index, Format(RecRef.RecordId), enum::DYM_PacketDirection::Push, ConstMgt.CBF_Validate);
            DataLogMgt.LogDataOp_Incoming(RecRef);
            PushBuffer.Reset;
            if PushBuffer.FindSet(false, false)then repeat CacheMgt.SetCacheBufferEntry(TableMap."Table No.", 0, '', 0, 0, PushBuffer."Mobile Field", RecRef.GetPosition, enum::DYM_PacketDirection::Push, PushBuffer.Data);
                until PushBuffer.Next = 0;
            if(DirectResponse)then CacheMgt.SetRecordFlag(TableMap."Table No.", TableMap.Index, Format(RecRef.RecordId), ConstMgt.CBF_DirectResponse);
        end;
    end;
    procedure ProcessTablePull(NodeOut: XmlNode; var RecRef: RecordRef; var TableMap: Record DYM_MobileTableMap)
    var
        FieldMap: Record DYM_MobileFieldMap;
        _RecordNode: XmlNode;
        _ValueNode: XmlNode;
        _CacheNode: XmlNode;
        _TableNode: XmlNode;
        _NodeList: XmlNodeList;
        OldRecRef: RecordRef;
        FieldRef: FieldRef;
        RelCondFieldRef: FieldRef;
        RelCondFieldValue: Text[250];
        FieldType: Integer;
        TempText: Text[250];
        SkipField: Boolean;
        SkipRec: Boolean;
        SameTableInstanceFound: Boolean;
        TableNodeNo: Integer;
        BinaryData: BigText;
        BlobFileName: Text;
        BlobDataInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        DeviceSetup.CalcFields("Salesperson Name", "Location Name");
        Clear(SameTableInstanceFound);
        _CacheNode:=NodeOut;
        NodeOut.SelectNodes('/' + ConstMgt.SYN_PrimaryTag + '/' + ConstMgt.SYN_Table, _NodeList);
        for TableNodeNo:=1 to _NodeList.Count()do begin
            _NodeList.Get(TableNodeNo, _TableNode);
            if(XMLMgt.GetNodeValue(_TableNode, ConstMgt.SYN_TableName, false) = TableMap."Mobile Table")then begin
                SameTableInstanceFound:=true;
                NodeOut:=_TableNode;
            end;
        end;
        if not SameTableInstanceFound then begin
            NodeOut:=_CacheNode;
            XMLMgt.AddElement(NodeOut, ConstMgt.SYN_Table, ' ', _TableNode);
            XMLMgt.AddAttribute(_TableNode, ConstMgt.SYN_TableName, TableMap."Mobile Table");
            NodeOut:=_TableNode;
        end;
        if(TableMap.Key <> 0)then RecRef.CurrentKeyIndex(TableMap.Key);
        if RecRef.FindSet(false, false)then repeat Clear(SkipRec);
                Clear(OldRecRef);
                if not SkipRec then begin
                    XMLMgt.AddElement(NodeOut, ConstMgt.SYN_Record, '', _RecordNode);
                    if(ConstMgt.SYN_RecordType <> '')then XMLMgt.AddAttribute(_RecordNode, ConstMgt.SYN_RecordType, ConstMgt.PRS_Create);
                    FieldMap.Reset;
                    FieldMap.SetRange("Table No.", TableMap."Table No.");
                    if(TableMap."Fields Defined by Table Index" = 0)then FieldMap.SetRange("Table Index", TableMap.Index)
                    else
                        FieldMap.SetRange("Table Index", TableMap."Fields Defined by Table Index");
                    FieldMap.SetRange("Device Role Code", DeviceRole.Code);
                    FieldMap.SetRange(Disabled, false);
                    FieldMap.SetFilter(Direction, '%1|%2|%3|%4|%5', FieldMap.Direction::Both, FieldMap.Direction::Pull, FieldMap.Direction::"Internal", FieldMap.Direction::"LookUp Result", FieldMap.Direction::"Setting Value");
                    if FieldMap.FindSet(false, false)then repeat SkipField:=false;
                            Clear(TempText);
                            if((FieldMap."Field No." <> 0) or (FieldMap.Relational))then begin
                                FieldType:=LowLevelDP.GetFieldType(FieldMap."Table No.", FieldMap."Field No.");
                                if FieldMap.Direction = FieldMap.Direction::Internal then begin
                                    if((FieldMap.Direction = FieldMap.Direction::Internal) and (FieldMap."Session Value" <> ''))then TempText:=SessionMgt.GetSessionValue(FieldMap."Session Value");
                                end
                                else
                                begin
                                    if FieldMap.Relational then begin
                                        RelCondFieldRef:=RecRef.Field(FieldMap."EQ Condition Field No.");
                                        LowLevelDP.FldRefValue2Text(FieldMap, 0, RelCondFieldRef, RelCondFieldValue);
                                        if(RelCondFieldValue = FieldMap."EQ Condition Value")then begin
                                            if(FieldMap."EQ Relation Field No." = 0)then begin
                                                TempText:=FieldMap."Const Value";
                                                SkipField:=true;
                                            end
                                            else
                                                FieldRef:=RecRef.Field(FieldMap."EQ Relation Field No.");
                                        end
                                        else
                                            SkipField:=true;
                                    end
                                    else if(FieldMap."Const Value Type" <> FieldMap."Const Value Type"::Always)then FieldRef:=RecRef.Field(FieldMap."Field No.");
                                end;
                                if(FieldMap."Const Value Type" = FieldMap."Const Value Type"::Always)then begin
                                    TempText:=FieldMap."Const Value";
                                end
                                else
                                begin
                                    if((not SkipField) and (FieldMap.Direction <> FieldMap.Direction::Internal))then begin
                                        Clear(FieldType);
                                        if(LowLevelDP.GetFieldRefFieldType(FieldRef) = ConstMgt.FDT_BLOB)then begin
                                            Clear(TempText);
                                            Clear(BinaryData);
                                            Clear(BlobFileName);
                                            //if LowLevelDP.Blob2File(FieldRef, BlobFileName) then
                                            //    XMLMgt.AddBinary(_RecordNode, '', FieldMap."Mobile Field", BlobFileName, _ValueNode);
                                            FieldRef.CalcField();
                                            Clear(TempBlob);
                                            TempBlob.FromFieldRef(FieldRef);
                                            TempBlob.CreateInStream(BlobDataInStream, TextEncoding::UTF8);
                                            XMLMgt.AddBinary(_RecordNode, FieldMap."Mobile Field", BlobDataInStream, _ValueNode);
                                        end
                                        else
                                        begin
                                            if FieldMap.Relational then FieldType:=LowLevelDP.GetFieldType(FieldMap."Table No.", FieldMap."EQ Relation Field No.");
                                            LowLevelDP.FldRefValue2Text(FieldMap, FieldType, FieldRef, TempText);
                                        end;
                                    end;
                                    if(FieldMap."Const Value Type" IN[FieldMap."Const Value Type"::Null, FieldMap."Const Value Type"::"Ending Date"])then begin
                                        if(TempText = '')then TempText:=FieldMap."Const Value";
                                    end;
                                end;
                                if(LowLevelDP.IsFlowField(FieldMap."Table No.", FieldMap."Field No."))then TempText:=CacheMgt.GetFlowField(FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index", Format(RecRef.RecordId));
                            end;
                            if((FieldMap.Direction = FieldMap.Direction::Internal) and (FieldMap."Field No." = 0))then begin
                                TempText:=CacheMgt.GetInternalField(FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index", FieldMap."Mobile Field", Format(RecRef.RecordId));
                            end;
                            if(FieldMap.Direction = FieldMap.Direction::"LookUp Result")then TempText:=CacheMgt.GetLookupField(FieldMap."Table No.", FieldMap."Table Index", FieldMap."Field No.", FieldMap."Field Index", FieldMap."Mobile Field", Format(RecRef.RecordId));
                            if(FieldMap.Direction = FieldMap.Direction::"Setting Value")then TempText:=SettingsMgt.GetSetting(FieldMap."Const Value");
                            IF(FieldMap.IsAutoIncrementPull)THEN BEGIN
                                AIEntryNo+=1;
                                TempText:=LowLevelDP.Integer2Text(AIEntryNo);
                            END;
                            if not((TempText = '') and (not FieldMap."Sync Mandatory"))then XMLMgt.AddElement(_RecordNode, FieldMap."Mobile Field", TempText, _ValueNode);
                        until FieldMap.Next = 0;
                    //Handle SystemId
                    FieldRef:=RecRef.Field(RecRef.SystemIdNo());
                    XMLMgt.AddElement(_RecordNode, ConstMgt.SYS_SystemId(), FieldRef.Value, _ValueNode);
                end;
            until RecRef.Next = 0;
        NodeOut:=_CacheNode;
    end;
    procedure ProcessMetadataPull(NodeOut: XmlNode)
    var
        FieldMap: Record DYM_MobileFieldMap;
        _RecordNode: XmlNode;
        _GeneralNode: XmlNode;
        _ValueNode: XmlNode;
        _TableNode: XmlNode;
        PullTableMetadata: Dictionary of[Text, Dictionary of[Integer, Integer]];
        SingleTableMetadata: Dictionary of[Integer, Integer];
        PullTableMetadataDuration: Duration;
        i: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        XMLMgt.AddElement(NodeOut, ConstMgt.SYN_Table, ' ', _TableNode);
        XMLMgt.AddAttribute(_TableNode, ConstMgt.SYN_TableName, ConstMgt.MTD_Metadata_PrimaryTag());
        NodeOut:=_TableNode;
        XMLMgt.AddElement(NodeOut, ConstMgt.MTD_Metadata_Packet_Tag(), '', _GeneralNode);
        XMLMgt.AddElement(_GeneralNode, ConstMgt.MTD_Metadata_Packet_Timestamp(), LowLevelDP.DateTime2Text(CreateDateTime(Today, Time)), _ValueNode);
        CacheMgt.GetTableMetadataDict(PullTableMetadata);
        for i:=1 to PullTableMetadata.Count do begin
            SingleTableMetadata:=PullTableMetadata.Values.Get(i);
            PullTableMetadataDuration:=SingleTableMetadata.Values.Get(Enum::DYM_TableMetadataType::PullDuration.AsInteger());
            XMLMgt.AddElement(NodeOut, ConstMgt.SYN_Record, '', _RecordNode);
            XMLMgt.AddAttribute(_RecordNode, ConstMgt.SYN_TableName(), PullTableMetadata.Keys.Get(i));
            XMLMgt.AddElement(_RecordNode, ConstMgt.MTD_TablePull_Duration(), LowLevelDP.Duration2SecondsText(PullTableMetadataDuration), _ValueNode);
            XMLMgt.AddElement(_RecordNode, ConstMgt.MTD_TablePull_DurationDesc(), Format(PullTableMetadataDuration), _ValueNode);
            XMLMgt.AddElement(_RecordNode, ConstMgt.MTD_TablePull_RecordsCount(), Format(SingleTableMetadata.Values.Get(Enum::DYM_TableMetadataType::RecordsCount.AsInteger())), _ValueNode);
        end;
    end;
    procedure ProcessContextTablePush(NodeIn: XmlNode)
    var
        _NodeRecord: XmlNode;
        _NodeListRecords: XmlNodeList;
        TableName: Text[30];
        i: Integer;
    begin
        TableName:=XMLMgt.GetNodeValue(NodeIn, ConstMgt.SYN_TableName, false);
        NodeIn.SelectNodes(ConstMgt.SYN_Record + '/*', _NodeListRecords);
        for i:=1 to _NodeListRecords.Count()do begin
            _NodeListRecords.Get(i, _NodeRecord);
            CacheMgt.SetTableNameFlag(TableName, _NodeRecord.AsXmlAttribute().Name(), _NodeRecord.AsXmlAttribute().Value());
        end;
    end;
    procedure GetAIEntryNo(): Integer begin
        exit(AIEntryNo);
    end;
    procedure SetAIEntryNo(ExternAIEntryNo: Integer)
    begin
        AIEntryNo:=ExternAIEntryNo;
    end;
}
