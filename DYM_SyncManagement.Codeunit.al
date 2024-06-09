codeunit 84017 DYM_SyncManagement
{
    trigger OnRun()
    begin
    end;
    var GlobalDP: Codeunit DYM_GlobalDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    XMLMgt: Codeunit DYM_XMLManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
    StreamMgt: Codeunit DYM_StreamManagement;
    MobileSetup: Record DYM_DynamicsMobileSetup;
    DummyInStream: InStream;
    SetupRead: Boolean;
    #region DES
    procedure ForceExportDES()
    begin
        clear(StreamMgt);
        StreamMgt.initDummyInStream(DummyInStream);
        GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::DES, enum::DYM_PullType::None, true, false, DummyInStream);
    end;
    procedure ExportDES()
    var
        l_DeviceRole: Record DYM_DeviceRole;
        l_DeviceGroup: Record DYM_DeviceGroup;
        l_DeviceSetup: Record DYM_DeviceSetup;
        l_SettingsAssignment: Record DYM_SettingsAssignment;
        TempPacketContent: Codeunit "Temp Blob";
        PacketDoc: XmlDocument;
        RootNode: XmlNode;
        Node: XmlNode;
        Node2: XmlNode;
        InS: InStream;
        OutS: OutStream;
        FileName: Text[250];
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        PacketDoc:=XmlDocument.Create();
        XmlDocument.ReadFrom(ConstMgt.DES_Init + '<' + ConstMgt.SYN_PrimaryTag + '/>', PacketDoc);
        XMLMgt.GetRootNode(PacketDoc, RootNode);
        XMLMgt.AddAttributeE(RootNode, ConstMgt.SYN_TypeTag, ConstMgt.DES_TypeValue);
        XMLMgt.AddElementNS(RootNode, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Roles, '', Node);
        l_DeviceRole.Reset;
        if l_DeviceRole.FindSet(false, false)then repeat XMLMgt.AddElementNS(Node, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Role, '', Node2);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_RoleCode, l_DeviceRole.Code);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_RoleDescription, l_DeviceRole.Description);
            until l_DeviceRole.Next = 0;
        XMLMgt.AddElementNS(RootNode, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Groups, '', Node);
        l_DeviceGroup.Reset;
        if l_DeviceGroup.FindSet(false, false)then repeat XMLMgt.AddElementNS(Node, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Group, '', Node2);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_GroupCompany, CompanyName);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_GroupRole, l_DeviceGroup."Device Role Code");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_GroupCode, l_DeviceGroup.Code);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_GroupDescription, l_DeviceGroup.Description);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_GroupEnabled, LowLevelDP.Boolean2Text(not l_DeviceGroup.Disabled));
            until l_DeviceGroup.Next = 0;
        XMLMgt.AddElementNS(RootNode, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Devices, '', Node);
        l_DeviceSetup.Reset;
        if l_DeviceSetup.FindSet(false, false)then repeat XMLMgt.AddElementNS(Node, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Device, '', Node2);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceRole, l_DeviceSetup."Device Role Code");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceGroup, l_DeviceSetup."Device Group Code");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceCode, l_DeviceSetup.Code);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceDescription, l_DeviceSetup.Description);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceEnabled, LowLevelDP.Boolean2Text(not l_DeviceSetup.Disabled));
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceLocation, l_DeviceSetup."Mobile Location");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_DeviceSalesperson, l_DeviceSetup."Salesperson Code");
            until l_DeviceSetup.Next = 0;
        XMLMgt.AddElementNS(RootNode, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Settings, '', Node);
        l_SettingsAssignment.Reset;
        if l_SettingsAssignment.FindSet(false, false)then repeat XMLMgt.AddElementNS(Node, ConstMgt.DES_NamespacePrefix(), ConstMgt.DES_NamespaceURI(), ConstMgt.DES_Setting, '', Node2);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_SettingDeviceRole, l_SettingsAssignment."Device Role Code");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_SettingDeviceGroup, l_SettingsAssignment."Device Group Code");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_SettingDeviceCode, l_SettingsAssignment."Device Setup Code");
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_SettingType, LowLevelDP.Integer2Text(l_SettingsAssignment.Type.AsInteger()));
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_SettingCode, l_SettingsAssignment.Code);
                XMLMgt.AddAttributeE(Node2, ConstMgt.DES_SettingValue, l_SettingsAssignment.Value);
            until l_SettingsAssignment.Next = 0;
        TempPacketContent.CreateOutStream(OutS, TextEncoding::UTF8);
        PacketDoc.WriteTo(OutS);
        TempPacketContent.CreateInStream(InS, TextEncoding::UTF8);
        FileName:=GenerateDESFileName;
        GlobalDP.InsertSyncLogEntry(FileName, enum::DYM_PacketDirection::Pull, enum::DYM_PacketType::DES, enum::DYM_PullType::None, false, false, InS);
    end;
    procedure GenerateDESFileName()Result: Text[250]var
        GUID: Text[250];
        Extension: Text[250];
    begin
        Clear(Result);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        Extension:='.xml';
        Result:=MobileSetup."Packet Storage Path";
        if(Result <> '')then begin
            if(CopyStr(Result, StrLen(Result), 1) <> '\')then Result+='\';
            GUID:=Format(CreateGuid);
            Result+='des_' + Format(Date2DMY(Today, 3)) + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 1)) + '_';
            Result+=CopyStr(GUID, 2, StrLen(GUID) - 2);
            Result+=Extension;
        end;
    end;
    procedure SetDESChanged()
    begin
        Clear(SetupRead);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if not MobileSetup."Settings Auto Sync" then exit;
        MobileSetup."DES Changed":=true;
        MobileSetup.Modify;
    end;
    procedure ClearDESChanged()
    begin
        Clear(SetupRead);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if not MobileSetup."Settings Auto Sync" then exit;
        Clear(MobileSetup."DES Changed");
        MobileSetup.Modify;
    end;
    #endregion 
    #region DBS
    procedure ForceExportDBS()
    begin
        clear(StreamMgt);
        StreamMgt.initDummyInStream(DummyInStream);
        GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::DBS, enum::DYM_PullType::None, true, false, DummyInStream);
    end;
    procedure ExportDBS()
    var
        l_DeviceRole: Record DYM_DeviceRole;
        TableMap: Record DYM_MobileTableMap;
        FieldMap: Record DYM_MobileFieldMap;
        TempPacketContent: Codeunit "Temp Blob";
        PacketDoc: XmlDocument;
        RootNode: XmlNode;
        RoleNode: XmlNode;
        TableNode: XmlNode;
        FieldNode: XmlNode;
        InS: InStream;
        OutS: OutStream;
        FileName: Text[250];
        NAVTableName: Text;
    begin
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        PacketDoc:=XmlDocument.Create();
        XmlDocument.ReadFrom(ConstMgt.DBS_Init + '<' + ConstMgt.SYN_PrimaryTag + '/>', PacketDoc);
        XMLMgt.GetRootNode(PacketDoc, RootNode);
        XMLMgt.AddAttributeE(RootNode, ConstMgt.SYN_TypeTag, ConstMgt.DBS_TypeValue);
        l_DeviceRole.Reset;
        if l_DeviceRole.FindSet(false, false)then repeat XMLMgt.AddElementNS(RootNode, ConstMgt.DBS_NamespacePrefix(), ConstMgt.DBS_NamespaceURI(), ConstMgt.DBS_Role, '', RoleNode);
                XMLMgt.AddAttributeE(RoleNode, ConstMgt.DBS_RoleCode, l_DeviceRole.Code);
                TableMap.Reset;
                TableMap.SetRange("Device Role Code", l_DeviceRole.Code);
                if TableMap.FindSet(false, false)then repeat NAVTableName:=LowLevelDP.GetTableName(TableMap."Table No.");
                        XMLMgt.AddElementNS(RoleNode, ConstMgt.DBS_NamespacePrefix(), ConstMgt.DBS_NamespaceURI(), ConstMgt.DBS_Table, '', TableNode);
                        XMLMgt.AddAttributeE(TableNode, ConstMgt.DBS_TableName, TableMap."Mobile Table");
                        XMLMgt.AddAttributeE(TableNode, ConstMgt.DBS_TableEnabled, LowLevelDP.Boolean2Text(not TableMap.Disabled));
                        XMLMgt.AddAttributeE(TableNode, ConstMgt.DBS_TableDirection, LowLevelDP.Integer2Text(TableMap.Direction.AsInteger()));
                        XMLMgt.AddAttributeE(TableNode, ConstMgt.DBS_TablePriority, LowLevelDP.Integer2Text(TableMap."Sync. Priority"));
                        XMLMgt.AddAttributeE(TableNode, ConstMgt.DBS_NAVTableNo, LowLevelDP.Integer2Text(TableMap."Table No."));
                        XMLMgt.AddAttributeE(TableNode, ConstMgt.DBS_NAVTableName, NAVTableName);
                        FieldMap.Reset;
                        FieldMap.SetRange("Device Role Code", TableMap."Device Role Code");
                        FieldMap.SetRange("Table No.", TableMap."Table No.");
                        FieldMap.SetRange("Table Index", TableMap.Index);
                        if FieldMap.FindSet(false, false)then repeat FieldMap.CalcFields("NAV Field Name", "NAV Field Type", "NAV Field Size");
                                XMLMgt.AddElementNS(TableNode, ConstMgt.DBS_NamespacePrefix(), ConstMgt.DBS_NamespaceURI(), ConstMgt.DBS_Field, '', FieldNode);
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_FieldName, FieldMap."Mobile Field");
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_FieldDataType, FieldMap."NAV Field Type");
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_FieldSize, LowLevelDP.Integer2Text(FieldMap."NAV Field Size"));
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_NAVFieldNo, LowLevelDP.Integer2Text(FieldMap."Field No."));
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_NAVFieldName, FieldMap."NAV Field Name");
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_FieldEnabled, LowLevelDP.Boolean2Text(not FieldMap.Disabled));
                                XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_FieldRelational, LowLevelDP.Boolean2Text(not FieldMap.Relational));
                                if(NAVTableName <> '')then //Check if table exists
 XMLMgt.AddAttributeE(FieldNode, ConstMgt.DBS_FieldInPrimaryKey, LowLevelDP.Boolean2Text(LowLevelDP.IsInPrimaryKey(FieldMap."Table No.", FieldMap."Field No.")));
                            until FieldMap.Next = 0;
                    until TableMap.Next = 0;
            until l_DeviceRole.Next = 0;
        TempPacketContent.CreateOutStream(OutS, TextEncoding::UTF8);
        PacketDoc.WriteTo(OutS);
        TempPacketContent.CreateInStream(InS, TextEncoding::UTF8);
        FileName:=GenerateDBSFileName;
        GlobalDP.InsertSyncLogEntry(FileName, enum::DYM_PacketDirection::Pull, enum::DYM_PacketType::DBS, enum::DYM_PullType::None, false, false, InS);
    end;
    procedure GenerateDBSFileName()Result: Text[250]var
        GUID: Text[250];
        Extension: Text[250];
    begin
        Clear(Result);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        Extension:='.xml';
        Result:=MobileSetup."Packet Storage Path";
        if(Result <> '')then begin
            if(CopyStr(Result, StrLen(Result), 1) <> '\')then Result+='\';
            GUID:=Format(CreateGuid);
            Result+='dbs_' + Format(Date2DMY(Today, 3)) + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 1)) + '_';
            Result+=CopyStr(GUID, 2, StrLen(GUID) - 2);
            Result+=Extension;
        end;
    end;
    procedure SetDBSChanged()
    begin
        Clear(SetupRead);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if not MobileSetup."Settings Auto Sync" then exit;
        MobileSetup."DBS Changed":=true;
        MobileSetup.Modify;
    end;
    procedure ClearDBSChanged()
    begin
        Clear(SetupRead);
        CacheMgt.GetSetup_NoContext(MobileSetup, SetupRead);
        if not MobileSetup."Settings Auto Sync" then exit;
        Clear(MobileSetup."DBS Changed");
        MobileSetup.Modify;
    end;
#endregion 
}
