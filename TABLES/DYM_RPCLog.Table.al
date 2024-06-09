table 70121 DYM_RPCLog
{
    //RPC
    Caption = 'RPC Log';

    fields
    {
        field(1; "Entry no"; BigInteger)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
            Caption = 'Entry no';
        }
        field(2; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
            Caption = 'Entry TimeStamp';
        }
        field(3; "Status"; enum DYM_PacketStatus)
        {
            DataClassification = SystemMetadata;
            Caption = 'Status';
        }
        field(4; "Error Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Error Code';
        }
        field(5; "Error Description"; Text[250])
        {
            DataClassification = SystemMetadata;
            Caption = 'Error Description';
        }
        field(6; "Operation Hint"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Operation Hint';
        }
        field(7; "Operation Data"; Text[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Operation Data';
        }
        field(8; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Device Role Code';
        }
        field(9; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Device Group Code';
        }
        field(10; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Device Setup Code';
        }
        field(11; "Request"; Blob)
        {
            DataClassification = SystemMetadata;
            Caption = 'Request';
        }
        field(12; "Response"; Blob)
        {
            DataClassification = SystemMetadata;
            Caption = 'Response';
        }
    }
    keys
    {
        key(Pk; "Entry no")
        {
        }
    }
    var
        CacheMgt: Codeunit DYM_CacheManagement;
        Filename, BLOBTextLine, BLOBText : Text;
        InS: InStream;

    LOCAL procedure ShowBLOB(InS: InStream)
    begin
        CLEAR(BLOBText);
        WHILE NOT InS.EOS DO BEGIN
            InS.READTEXT(BLOBTextLine);
            BLOBText := BLOBText + BLOBTextLine;
        END;
        MESSAGE(BLOBText);
    end;

    procedure ShowRequest()
    begin
        CALCFIELDS(Request);
        Rec.Request.CREATEINSTREAM(InS, TextEncoding::UTF8);
        ShowBLOB(InS);
    end;

    procedure ShowResponse()
    begin
        CALCFIELDS(Response);
        Rec.Response.CREATEINSTREAM(InS, TextEncoding::UTF8);
        ShowBLOB(InS);
    end;

    procedure Execute()
    var
        ODataGW: Codeunit DYM_RPCODataGateway;
    begin
        CacheMgt.SetContextByCodes("Device Role Code", "Device Group Code", "Device Setup Code");
        CLEAR(ODataGW);
        ODataGW.ProcessRPCLog(Rec);
    end;

    procedure Enqueue()
    var
        TempBlob: Codeunit "Temp Blob";
        XMLMgt: Codeunit DYM_XMLManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        ODataGw: Codeunit DYM_RPCODataGateway;
        FileMgt: Codeunit "File Management";
        DeviceSetup: Record DYM_DeviceSetup;
        RPCLog: Record DYM_RPCLog;
        XMLDomRequest: XmlDocument;
        XMLNodeRequest: XmlNode;
        TempFile: File;
        OutS: OutStream;
        InS: InStream;
        RPCLogEntryNo: BigInteger;
        DeviceSetupCode: Code[20];
        FileName: Text[250];
        FileContent: Text;
        Text001: Label 'Unable to enqueue file %1.';
    begin
        CLEAR(Filename);
        TempBlob.CreateInStream(InS, TextEncoding::UTF8);
        TempBlob.CreateOutStream(OutS, TextEncoding::UTF8);
        FileMgt.BLOBImport(TempBlob, '');
        XMLDomRequest := XmlDocument.Create();
        InS.ReadText(FileContent);
        XmlDocument.ReadFrom(FileContent, XMLDomRequest);
        XMLDomRequest.SelectSingleNode(ConstMgt.WSC_PrimaryTag, XMLNodeRequest);
        CLEAR(DeviceSetupCode);
        DeviceSetupCode := XMLMgt.GetNodeValue(XMLNodeRequest, ConstMgt.SYN_DeviceSetup, FALSE);
        DeviceSetup.GET(DeviceSetupCode);
        CacheMgt.SetContextByCodes(DeviceSetup."Device Role Code", DeviceSetup."Device Group Code", DeviceSetup.Code);
        RPCLogEntryNo := ODataGw.InsertRPCLogEntry(FileContent);
        RPCLog.Get(RPCLogEntryNo);
        ODataGw.ProcessRPCLog(RPCLog);
    end;
}
