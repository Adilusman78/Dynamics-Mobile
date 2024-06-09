table 70100 DYM_BLOBStore
{
    Caption = 'BLOB Store';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    LookupPageId = DYM_BLOBStoreList;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            //AutoIncrement = true;
            Editable = false;
        }
        field(2; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(3; Identifier; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(4; Status; enum DYM_BLOBStoreEntryStatus)
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Content Size"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Packet Type"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "URL"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(10; Company; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(100; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(1001; Content; BLOB)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(SearchKey; "Device Setup Code", Identifier)
        {
        }
    }
    var
        Text001: Label 'BLOBStore Entry does not contain data.';

    procedure findByIdentifier(_DeviceSetupCode: Code[100]; _Identifier: Text)
    var
        BLOBStoreMgt: Codeunit DYM_BLOBStoreManagement;
    begin
        Get(BLOBStoreMgt.findBLOBStoreEntry(_DeviceSetupCode, _Identifier));
    end;

    procedure existsByIdentifier(_DeviceSetupCode: Code[100]; _Identifier: Text): boolean
    var
        BLOBStoreMgt: Codeunit DYM_BLOBStoreManagement;
    begin
        exit(Get(BLOBStoreMgt.findBLOBStoreEntry(_DeviceSetupCode, _Identifier)));
    end;

    procedure Download()
    var
        inS: InStream;
        tempFilename: Text;
    begin
        CalcFields(Content);
        if (not Content.HasValue) then error(Text001);
        Content.CreateInStream(inS, TextEncoding::UTF8);
        tempFilename := CreateGuid();
        DownloadFromStream(inS, 'Export', '', 'All Files (*.*)|*.*', tempfilename);
    end;
}
