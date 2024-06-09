codeunit 84016 DYM_BLOBStoreManagement
{
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    SLE: Integer;
    SetupRead: Boolean;
    BLOBPathPrefix: Label 'dms://', Locked = true;
    Text001: Label 'Invalid BLOB path [%1].';
    Text002: Label 'Cannot find BLOBStore Entry by identifier [%1][%2]';
    procedure insertBLOBStoreEntry(id: text; url: text; userId: text; companyId: text; packetType: text)
    var
        BLOBStoreEntry: Record DYM_BLOBStore;
        NextEntryNo: integer;
    begin
        Clear(NextEntryNo);
        BLOBStoreEntry.Reset;
        if BLOBStoreEntry.FindLast()then NextEntryNo:=BLOBStoreEntry."Entry No.";
        NextEntryNo+=1;
        BLOBStoreEntry.Init();
        //clear(BLOBStoreEntry."Entry No.");
        BLOBStoreEntry."Entry No.":=NextEntryNo;
        BLOBStoreEntry.Identifier:=id;
        BLOBStoreEntry.URL:=url;
        BLOBStoreEntry."Device Setup Code":=userId;
        BLOBStoreEntry.Company:=companyId;
        BLOBStoreEntry."Packet Type":=packetType;
        BLOBStoreEntry.Insert();
    end;
    procedure parseBLOBPath(_FullBLOBPath: Text)Result: Text begin
        if(StrLen(_FullBLOBPath) < 6)then Error(Text001, _FullBLOBPath);
        if(CopyStr(_FullBLOBPath, 1, 6) <> BLOBPathPrefix)then Error(Text001, _FullBLOBPath);
        Clear(Result);
        Result:=DelStr(_FullBLOBPath, 1, 6);
    end;
    procedure findBLOBStoreEntry(_DeviceSetupCode: Code[100]; _Identifier: Text)Result: Integer var
        BLOBStore: Record DYM_BLOBStore;
    begin
        Clear(Result);
        BLOBStore.Reset();
        BLOBStore.SetCurrentKey("Device Setup Code", Identifier);
        BLOBStore.SetRange("Device Setup Code", _DeviceSetupCode);
        BLOBStore.SetRange(Identifier, _Identifier);
        if BLOBStore.FindLast()then exit(BLOBStore."Entry No.")
        else
            error(Text002, _DeviceSetupCode, _Identifier);
    end;
    procedure packetType2FileExtension(_PacketType: Text)Result: Text begin
        Clear(Result);
        case _PacketType of 'image': Result:='jpg';
        end;
    end;
    procedure applyFileExtension(_Identifier: Text; _PacketType: Text)Result: Text begin
        Exit(_Identifier + '.' + packetType2FileExtension(_packetType));
    end;
    procedure Blob2MediaRef(RecRef: RecordRef; FldRef: FieldRef; Identifier: Text)
    var
        BLOBStoreMgt: Codeunit DYM_BLOBStoreManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        BLOBStore: Record DYM_BLOBStore;
        MediaRepoBuffer: Record "Media Repository" temporary;
        Ins: InStream;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if BLOBStore.existsByIdentifier(DeviceSetup.Code, BLOBStoreMgt.parseBLOBPath(Identifier))then begin
            BLOBStore.findByIdentifier(DeviceSetup.Code, BLOBStoreMgt.parseBLOBPath(Identifier));
            BLOBStore.CalcFields(Content);
            BLOBStore.Content.CreateInStream(InS, TextEncoding::UTF8);
            IF LowLevelDP.IsMedia(FldRef.RECORD.NUMBER, FldRef.NUMBER)THEN BEGIN
                MediaRepoBuffer.INIT;
                MediaRepoBuffer."File Name":=FORMAT(CREATEGUID);
                MediaRepoBuffer.Image.IMPORTSTREAM(InS, MediaRepoBuffer."File Name");
                MediaRepoBuffer.INSERT(TRUE);
                FldRef.VALUE:=MediaRepoBuffer.Image;
            END;
            BLOBStore.Validate(Status, BLOBStore.Status::Processed);
            BLOBStore.Modify();
        END;
        RecRef.Modify(true);
    end;
}
