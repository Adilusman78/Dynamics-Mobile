codeunit 70164 DYM_WH_Helper
{
    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        CacheMgt: Codeunit DYM_CacheManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        GeneralDP: Codeunit DYM_GeneralDataProcess;
        StatsMgt: Codeunit DYM_StatisticsManagement;
        DataLogMgt: Codeunit DYM_DataLogManagement;
        EventLogMgt: Codeunit DYM_EventLogManagement;
        TrackAssistMgt: Codeunit DYM_TrackAssistManagement;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        PostProcessMgt: Codeunit DYM_PostProcessManagement;
        SDSMgt: Codeunit DYM_SessionDataStoreManagement;
        WhseEventPub: Codeunit DYM_WH_EventPublishers;
        RecRef: RecordRef;
        SLE: Integer;
        SetupRead: Boolean;
        ErrMsg_InvalidItemJournalHandlingType: Label 'Invalid Item Journal Handling Type';
        ErrMsg_Header2LinePKTransferNoSupported: Label 'Transfer of primary key filter not supported for table [%1]';

    procedure HandleWhseJnlLine(_ItemJnlHandlingType: Enum DYM_ItemJournalHandlingType; _JournalTemplateName: Code[10]; _JournalBatchName: Code[10]; _EntryType: Integer; _ItemNo: Code[20]; _VariantCode: Code[10]; _UOMCode: Code[10]; _LocationCode: Code[10]; _ZoneCode: Code[10]; _BinCode: Code[20]; _Quantity: Decimal; _SerialNo: Code[20]; _LotNo: Code[20]; _PackageNo: Code[20]; _ExpirationDate: Date)
    var
        Item: Record Item;
        Bin: Record Bin;
        WhseJnlLine: Record "Warehouse Journal Line";
        LastWhseJnlLine: Record "Warehouse Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextLine: Integer;
        QtyBase: Decimal;
    begin
        Item.Get(_ItemNo);
        WhseJnlLine.Reset;
        WhseJnlLine.SetRange("Journal Template Name", _JournalTemplateName);
        WhseJnlLine.SetRange("Journal Batch Name", _JournalBatchName);
        WhseJnlLine.SetRange("Location Code", _LocationCode);
        WhseJnlLine.SetRange("Item No.", _ItemNo);
        WhseJnlLine.SetRange("Variant Code", _VariantCode);
        WhseJnlLine.SetRange("Bin Code", _BinCode);
        WhseJnlLine.SetRange("Serial No.", _SerialNo);
        WhseJnlLine.SetRange("Lot No.", _LotNo);
        WhseJnlLine.SetRange("Package No.", _PackageNo);
        WhseJnlLine.SetRange("Unit of Measure Code", _UOMCode);
        if (WhseJnlLine.FindFirst) and (_ItemJnlHandlingType = _ItemJnlHandlingType::PhysInventory) then begin
            WhseJnlLine.Validate("Qty. (Phys. Inventory)", WhseJnlLine."Qty. (Phys. Inventory)" + _Quantity);
            WhseJnlLine."Expiration Date" := _ExpirationDate;
            WhseJnlLine.Modify(true);
            RecRef.GETTABLE(WhseJnlLine);
            DataLogMgt.LogDataOp_Modify(RecRef);
        end
        else begin
            LastWhseJnlLine.RESET;
            LastWhseJnlLine.SETRANGE("Journal Template Name", _JournalTemplateName);
            LastWhseJnlLine.SETRANGE("Journal Batch Name", _JournalBatchName);
            LastWhseJnlLine.SetRange("Location Code", _LocationCode);
            IF NOT LastWhseJnlLine.FINDLAST THEN CLEAR(LastWhseJnlLine);
            NextLine := LastWhseJnlLine."Line No.";
            WhseJnlLine.RESET;
            NextLine += 10000;
            WhseJnlLine.INIT;
            WhseJnlLine.VALIDATE("Journal Template Name", _JournalTemplateName);
            WhseJnlLine.VALIDATE("Journal Batch Name", _JournalBatchName);
            WhseJnlLine.VALIDATE("Location Code", _LocationCode);
            WhseJnlLine.VALIDATE("Line No.", NextLine);
            WhseJnlLine.SetUpNewLine(LastWhseJnlLine);
            WhseJnlLine.INSERT(TRUE);
            WhseJnlLine.Validate("Whse. Document Type", WhseJnlLine."Whse. Document Type"::"Whse. Phys. Inventory");
            if (SettingsMgt.CheckSetting(ConstMgt.BOS_StockCorrection_WhseJournalNoSeries())) then WhseJnlLine.VALIDATE("Whse. Document No.", NoSeriesMgt.GetNextNo(SettingsMgt.GetSetting(ConstMgt.BOS_PhysicalJournalNos), TODAY, TRUE));
            WhseJnlLine.VALIDATE("Item No.", _ItemNo);
            if (_VariantCode <> '') then WhseJnlLine.Validate("Variant Code", _VariantCode);
            if (_UOMCode <> '') then WhseJnlLine.VALIDATE("Unit of Measure Code", _UomCode);
            if (_ZoneCode <> '') then
                WhseJnlLine.Validate("Zone Code", _ZoneCode)
            else if Bin.Get(_LocationCode, _BinCode) then WhseJnlLine.Validate("Zone Code", bin."Zone Code");
            if (_BinCode <> '') then WhseJnlLine.Validate("Bin Code", _BinCode);
            //CorrectionType matches "Entry Type" for StockCorrection
            if (_ItemJnlHandlingType = _ItemJnlHandlingType::StockCorrection) then begin
                WhseJnlLine.Validate("Entry Type", _EntryType);
                WhseJnlLine."Phys. Inventory" := true;
                case WhseJnlLine."Entry Type" of
                    WhseJnlLine."Entry Type"::"Negative Adjmt.":
                        begin
                            WhseJnlLine.Validate("Qty. (Calculated)", _Quantity);
                            WhseJnlLine.Validate("Qty. (Phys. Inventory)", 0);
                        end;
                    WhseJnlLine."Entry Type"::"Positive Adjmt.":
                        begin
                            WhseJnlLine.Validate("Qty. (Calculated)", 0);
                            WhseJnlLine.Validate("Qty. (Phys. Inventory)", _Quantity);
                        end;
                end;
            end;
            if (_ItemJnlHandlingType = _ItemJnlHandlingType::PhysInventory) then begin
                WhseJnlLine."Phys. Inventory" := true;
                WhseJnlLine.Validate("Qty. (Phys. Inventory)", _Quantity);
            end;
            WhseJnlLine.SetUpAdjustmentBin();
            WhseJnlLine."Phys. Inventory" := false;
            WhseJnlLine.VALIDATE("Registering Date", TODAY);
            WhseJnlLine."Serial No." := _SerialNo;
            WhseJnlLine."Lot No." := _LotNo;
            WhseJnlLine."Package No." := _PackageNo;
            WhseJnlLine."Expiration Date" := _ExpirationDate;
            //WhseJnlLine.Validate(Quantity, _Quantity);
            WhseJnlLine."Phys. Inventory" := true;
            WhseJnlLine.MODIFY(TRUE);
            RecRef.GETTABLE(WhseJnlLine);
            DataLogMgt.LogDataOp_Create(RecRef);
            PostProcessMgt.LogPostProcessOperation(RecRef, Enum::DYM_PostProcessOperationType::Post, '', 0, false, '');
        end;
    end;
    #region Item Journal Line handling
    procedure HandleItemJnlLine(_ItemJnlHandlingType: Enum DYM_ItemJournalHandlingType; _JournalTemplateName: Code[10]; _JournalBatchName: Code[10]; _ItemNo: Code[20]; _UOMCode: Code[10]; _LocationCode: Code[10]; _QtyCalculated: Decimal; _QtyCounted: Decimal; _SerialNo: Code[20]; _LotNo: Code[20]; _PackageNo: Code[20]; _ExpirationDate: Date; _ProdOrderNo: Code[10]; _ProdOrderLineNo: Integer; _ProdOrderCompLineNo: Integer; _OperationNo: Code[10])
    var
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        LastItemJnlLine: Record "Item Journal Line";
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextLine: Integer;
        QtyBase: Decimal;
    begin
        Item.Get(_ItemNo);
        LastItemJnlLine.RESET;
        LastItemJnlLine.SETRANGE("Journal Template Name", _JournalTemplateName);
        LastItemJnlLine.SETRANGE("Journal Batch Name", _JournalBatchName);
        IF NOT LastItemJnlLine.FINDLAST THEN CLEAR(LastItemJnlLine);
        NextLine := LastItemJnlLine."Line No.";
        ItemJnlLine.RESET;
        ItemJnlLine.SETRANGE("Journal Template Name", _JournalTemplateName);
        ItemJnlLine.SETRANGE("Journal Batch Name", _JournalBatchName);
        ItemJnlLine.SETRANGE("Item No.", _ItemNo);
        ItemJnlLine.SETRANGE("Unit of Measure Code", _UOMCode);
        ItemJnlLine.SETRANGE("Location Code", _LocationCode);
        IF ((NOT ItemJnlLine.FINDFIRST) OR (_ItemJnlHandlingType <> _ItemJnlHandlingType::PhysInventory)) Then Begin
            ItemJnlLine.RESET;
            NextLine += 10000;
            ItemJnlLine.INIT;
            ItemJnlLine.VALIDATE("Journal Template Name", _JournalTemplateName);
            ItemJnlLine.VALIDATE("Journal Batch Name", _JournalBatchName);
            ItemJnlLine.VALIDATE("Line No.", NextLine);
            ItemJnlLine.VALIDATE("Item No.", _ItemNo);
            ItemJnlLine.SetUpNewLine(LastItemJnlLine);
            ItemJnlLine.INSERT(TRUE);
            case _ItemJnlHandlingType of
                _ItemJnlHandlingType::Output:
                    begin
                        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Output);
                        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
                        ItemJnlLine.Validate("Order No.", _ProdOrderNo);
                        ItemJnlLine.Validate("Order Line No.", _ProdOrderLineNo);
                    end;
                _ItemJnlHandlingType::Consumption:
                    begin
                        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
                        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
                        ItemJnlLine.Validate("Order No.", _ProdOrderNo);
                        ItemJnlLine.Validate("Order Line No.", _ProdOrderLineNo);
                        ItemJnlLine.Validate("Prod. Order Comp. Line No.", _ProdOrderCompLineNo);
                    end;
            end;
            //ItemJnlLine.VALIDATE("Document No.", NoSeriesMgt.GetNextNo(SettingsMgt.GetSetting(ConstMgt.BOS_PhysicalJournalNos), TODAY, TRUE));
            if (_UOMCode <> '') then ItemJnlLine.VALIDATE("Unit of Measure Code", _UomCode);
            ItemJnlLine.VALIDATE("Posting Date", TODAY);
            if (_LocationCode <> '') then ItemJnlLine.VALIDATE("Location Code", _LocationCode);
            case _ItemJnlHandlingType of
                _ItemJnlHandlingType::PhysInventory:
                    begin
                        ItemJnlLine.VALIDATE("Phys. Inventory", TRUE);
                        ItemJnlLine.VALIDATE("Qty. (Calculated)", _QtyCalculated);
                    end;
            end;
            ItemJnlLine.MODIFY(TRUE);
            RecRef.GETTABLE(ItemJnlLine);
            DataLogMgt.LogDataOp_Create(RecRef);
        END
        Else Begin
            RecRef.GETTABLE(ItemJnlLine);
            DataLogMgt.LogDataOp_Modify(RecRef);
        End;
        CLEAR(ItemJnlLineReserve);
        ItemJnlLineReserve.DeleteLineConfirm(ItemJnlLine);
        ItemJnlLineReserve.DeleteLine(ItemJnlLine);
        //Reread record
        ItemJnlLine.Find();
        case _ItemJnlHandlingType of
            _ItemJnlHandlingType::None:
                error(ErrMsg_InvalidItemJournalHandlingType);
            _ItemJnlHandlingType::PhysInventory:
                begin
                    ItemJnlLine.VALIDATE("Qty. (Phys. Inventory)", ItemJnlLine."Qty. (Phys. Inventory)" + _QtyCounted);
                end;
            _ItemJnlHandlingType::Output:
                begin
                    ItemJnlLine.Validate("Output Quantity", _QtyCounted);
                    ItemJnlLine.Validate("Operation No.", _OperationNo);
                end;
            _ItemJnlHandlingType::Consumption:
                begin
                    ItemJnlLine.Validate(Quantity, _QtyCounted);
                end;
        end;
        ItemJnlLine.MODIFY(TRUE);
        if (TrackAssistMgt.CheckIfItemTrackingIsEnabled(_ItemNo)) then begin
            TrackAssistMgt.CreateTracking_IJL(ItemJnlLine, ItemJnlLine."Quantity (Base)", 1, _ExpirationDate, 0D, _SerialNo, _LotNo, _PackageNo);
            ItemJnlLine.Modify(true);
        end;
        RecRef.GetTable(ItemJnlLine);
        if (_ItemJnlHandlingType in [_ItemJnlHandlingType::Output, _ItemJnlHandlingType::Consumption]) then PostProcessMgt.LogPostProcessOperation(RecRef, Enum::DYM_PostProcessOperationType::Post, '', 0, false, '');
    end;

    procedure HandleItemJnlLine_NP(_ItemJnlHandlingType: Enum DYM_ItemJournalHandlingType; _JournalTemplateName: Code[10]; _JournalBatchName: Code[10]; _ItemNo: Code[20]; _UOMCode: Code[10]; _LocationCode: Code[10]; _QtyCalculated: Decimal; _QtyCounted: Decimal; _SerialNo: Code[20]; _LotNo: Code[20]; _PackageNo: Code[20]; _ExpirationDate: Date)
    begin
        HandleItemJnlLine(_ItemJnlHandlingType, _JournalTemplateName, _JournalBatchName, _ItemNo, _UOMCode, _LocationCode, _QtyCalculated, _QtyCounted, _SerialNo, _LotNo, _PackageNo, _ExpirationDate, '', //_ProdOrderNo,
 0, //_ProdOrderLineNo,
 0, //_ProdOrderCompLineNo,
 ''); //_OperationNo);
    end;

    procedure HandleItemJnlLine_NP_NT(_ItemJnlHandlingType: Enum DYM_ItemJournalHandlingType; _JournalTemplateName: Code[10]; _JournalBatchName: Code[10]; _ItemNo: Code[20]; _UOMCode: Code[10]; _LocationCode: Code[10]; _QtyCalculated: Decimal; _QtyCounted: Decimal)
    begin
        HandleItemJnlLine(_ItemJnlHandlingType, _JournalTemplateName, _JournalBatchName, _ItemNo, _UOMCode, _LocationCode, _QtyCalculated, _QtyCounted, '', //_SerialNo,
 '', //_LotNo,
 '', //_PackageNo,
 0D, //_ExpirationDate,
 '', //_ProdOrderNo,
 0, //_ProdOrderLineNo,
 0, //_ProdOrderCompLineNo,
 ''); //_OperationNo);
    end;
    #endregion 
    #region Mobile Status handling
    /// <summary>
    /// Updates the Mobile Status of a document according to lines quantities fulfilment
    /// </summary>
    /// <param name="_HeaderRec">The document header record</param>
    /// <param name="_FieldList">Text containing a comma separated field list of AccFieldNo, ProcFieldNo, RefFieldNo, MobileStatusFieldNo and MobileDeviceFieldNo</param>
    procedure UpdateDocumentMobileStatus(_HeaderRec: Variant; _LinesFieldList: Text)
    var
        HeaderRecRef, LineRecRef : RecordRef;
        AccFieldNo: Integer;
        ProcFieldNo: Integer;
        RefFieldNo: Integer;
        MobileStatusFieldNo: Integer;
        MobileDeviceFieldNo: Integer;
    begin
        HeaderRecRef.GetTable(_HeaderRec);
        LineRecRef.Open(GetLineTableNo(HeaderRecRef.Number));
        Evaluate(AccFieldNo, SelectStr(1, _LinesFieldList));
        Evaluate(ProcFieldNo, SelectStr(2, _LinesFieldList));
        Evaluate(RefFieldNo, SelectStr(3, _LinesFieldList));
        if not Evaluate(MobileStatusFieldNo, SelectStr(4, _LinesFieldList)) then MobileStatusFieldNo := LowLevelDP.GetFieldByName(HeaderRecRef.Number, SelectStr(4, _LinesFieldList));
        if not Evaluate(MobileDeviceFieldNo, SelectStr(5, _LinesFieldList)) then MobileDeviceFieldNo := LowLevelDP.GetFieldByName(HeaderRecRef.Number, SelectStr(5, _LinesFieldList));
        UpdateDocumentMobileStatus(_HeaderRec, AccFieldNo, ProcFieldNo, RefFieldNo, MobileStatusFieldNo, MobileDeviceFieldNo);
    end;
    /// <summary>
    /// Updates the Mobile Status of a document according to lines quantities fulfilment
    /// </summary>
    /// <param name="_HeaderRec">The document header record</param>
    /// <param name="_AccFieldNo">Field number of accumulator qunatity field ("Qty. to Ship")</param>
    /// <param name="_ProcFieldNo">Field number of processed quantity field ("Qty. Shipped"). Can be zero.</param>
    /// <param name="_RefFieldNo">Field numer of reference quantoty field (Quantity)</param>
    /// <param name="_MobileStatusFieldNo">Field number of Mobile Status field</param>
    /// <param name="_MobileDeviceFieldNo">Field number of Mobile Device field</param>
    procedure UpdateDocumentMobileStatus(_HeaderRec: Variant; _AccFieldNo: Integer; _ProcFieldNo: Integer; _RefFieldNo: Integer; _MobileStatusFieldNo: Integer; _MobileDeviceFieldNo: Integer)
    var
        HeaderRecRef, LineRecRef : RecordRef;
        FldRef: FieldRef;
        AccFieldValue, ProcFieldValue, RefFieldValue : Decimal;
        FullyProcessed: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        HeaderRecRef.GetTable(_HeaderRec);
        VerifyMobileStatusUpdateSupportedTables(HeaderRecRef.Number);
        FullyProcessed := true;
        LineRecRef.Open(GetLineTableNo(HeaderRecRef.Number));
        LineRecRef.Reset();
        ApplyHeader2LinesFilter(HeaderRecRef, LineRecRef);
        if LineRecRef.FindSet() then
            repeat
                Clear(AccFieldValue);
                FldRef := LineRecRef.Field(_AccFieldNo);
                AccFieldValue := FldRef.Value;
                Clear(ProcFieldValue);
                if (_ProcFieldNo <> 0) then begin
                    FldRef := LineRecRef.Field(_ProcFieldNo);
                    ProcFieldValue := FldRef.Value;
                end;
                Clear(RefFieldValue);
                FldRef := LineRecRef.Field(_RefFieldNo);
                RefFieldValue := FldRef.Value;
                if (AccFieldValue + ProcFieldValue <> RefFieldValue) then Clear(FullyProcessed);
            until LineRecRef.Next() = 0;
        FldRef := HeaderRecRef.Field(_MobileStatusFieldNo);
        case FullyProcessed of
            true:
                FldRef.Value := Enum::DYM_BS_MobileStatus::Processed;
            false:
                FldRef.Value := Enum::DYM_BS_MobileStatus::"Partially Processed";
        end;
        FldRef := HeaderRecRef.Field(_MobileDeviceFieldNo);
        FldRef.Value := DeviceSetup.Code;
        HeaderRecRef.Modify();
    end;

    local procedure VerifyMobileStatusUpdateSupportedTables(_TableNo: Integer)
    var
        HeaderLineDict: Dictionary of [Integer, Integer];
    begin
        InitHeaderLineDict(HeaderLineDict);
        if not HeaderLineDict.ContainsKey(_TableNo) then Error(ErrMsg_Header2LinePKTransferNoSupported, _TableNo);
    end;

    local procedure GetLineTableNo(_HeaderTableNo: Integer) Result: Integer
    var
        HeaderLineDict: Dictionary of [Integer, Integer];
    begin
        Clear(Result);
        VerifyMobileStatusUpdateSupportedTables(_HeaderTableNo);
        InitHeaderLineDict(HeaderLineDict);
        if HeaderLineDict.ContainsKey(_HeaderTableNo) then HeaderLineDict.Get(_HeaderTableNo, Result);
    end;

    local procedure InitHeaderLineDict(var _HeaderLineDict: Dictionary of [Integer, Integer])
    begin
        _HeaderLineDict.Add(Database::"Sales Header", Database::"Sales Line");
        _HeaderLineDict.Add(Database::"Purchase Header", Database::"Purchase Line");
        _HeaderLineDict.Add(Database::"Transfer Header", Database::"Transfer Line");
        _HeaderLineDict.Add(Database::"Warehouse Activity Header", Database::"Warehouse Activity Line");
        _HeaderLineDict.Add(Database::"Warehouse Shipment Header", Database::"Warehouse Shipment Line");
        _HeaderLineDict.Add(Database::"Warehouse Receipt Header", Database::"Warehouse Receipt Line");
    end;

    local procedure ApplyHeader2LinesFilter(_HeaderRec: Variant; var _LineRecRef: RecordRef) Result: Text
    var
        HeaderRecRef: RecordRef;
        HeaderFldRef, LineFldRef : FieldRef;
        HeaderKeyRef, LineKeyRef : KeyRef;
        PKFieldPos: Integer;
    begin
        Clear(Result);
        HeaderRecRef.GetTable(_HeaderRec);
        HeaderKeyRef := HeaderRecRef.KeyIndex(1);
        LineKeyRef := _LineRecRef.KeyIndex(1);
        VerifyMobileStatusUpdateSupportedTables(HeaderRecRef.Number);
        //Assume lines have PK matching the header's one with Line No. field added at tail
        for PKFieldPos := 1 to HeaderKeyRef.FieldCount do begin
            HeaderFldRef := HeaderKeyRef.FieldIndex(PKFieldPos);
            LineFldRef := LineKeyRef.FieldIndex(PKFieldPos);
            LineFldRef.SetRange(HeaderFldRef.Value);
        end;
    end;
    #endregion
}
