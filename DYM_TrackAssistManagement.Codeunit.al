codeunit 84101 DYM_TrackAssistManagement
{
    var SettingsMgt: Codeunit DYM_SettingsManagement;
    EventLogMgt: Codeunit DYM_EventLogManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    TrackingSpec: Record "Tracking Specification" temporary;
    #region CreateTracking helper methods
    procedure CreateTracking_SL(_SourceSalesLine: Record "Sales Line"; _Qty: Decimal; _QtyperUOM: Decimal; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50]; _ApplyFromEntryNo: Integer)
    begin
        CreateSpecTracking((_SourceSalesLine."Document Type" in[_SourceSalesLine."Document Type"::"Return Order", _SourceSalesLine."Document Type"::"Credit Memo"]), DATABASE::"Sales Line", _SourceSalesLine."Document Type".AsInteger(), _SourceSalesLine."Document No.", _SourceSalesLine."Line No.", '', 0, _SourceSalesLine."No.", _Qty, _QtyperUOM, _SourceSalesLine."Location Code", _SourceSalesLine."Variant Code", _SourceSalesLine."Bin Code", _SourceSalesLine."Requested Delivery Date", _SourceSalesLine."Shipment Date", _ExpirationDate, _WarrantyDate, _SerialNo, _LotNo, _PackageNo, _ApplyFromEntryNo);
    end;
    procedure CreateTracking_PL(_SourcePurchaseLine: Record "Purchase Line"; _Qty: Decimal; _QtyperUOM: Decimal; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50])
    begin
        CreateSpecTracking(true, DATABASE::"Purchase Line", _SourcePurchaseLine."Document Type".AsInteger(), _SourcePurchaseLine."Document No.", _SourcePurchaseLine."Line No.", '', 0, _SourcePurchaseLine."No.", _Qty, _SourcePurchaseLine."Qty. per Unit of Measure", _SourcePurchaseLine."Location Code", _SourcePurchaseLine."Variant Code", _SourcePurchaseLine."Bin Code", _SourcePurchaseLine."Expected Receipt Date", 0D, _ExpirationDate, _WarrantyDate, _SerialNo, _LotNo, _PackageNo, 0);
    end;
    procedure CreateTracking_TL(_SourceTransferLine: Record "Transfer Line"; _Qty: Decimal; _QtyperUOM: Decimal; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50])
    begin
        CreateSpecTracking(false, DATABASE::"Transfer Line", 0, _SourceTransferLine."Document No.", _SourceTransferLine."Line No.", '', 0, _SourceTransferLine."Item No.", _Qty, _QtyperUOM, _SourceTransferLine."Transfer-from Code", _SourceTransferLine."Variant Code", _SourceTransferLine."Transfer-from Bin Code", _SourceTransferLine."Receipt Date", _SourceTransferLine."Shipment Date", _ExpirationDate, _WarrantyDate, _SerialNo, _LotNo, _PackageNo, 0);
    end;
    procedure CreateTracking_IJL(_SourceItemJournalLine: Record "Item Journal Line"; _Qty: Decimal; _QtyperUOM: Decimal; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50])
    begin
        CreateSpecTracking(_SourceItemJournalLine."Entry Type" in[_SourceItemJournalLine."Entry Type"::"Positive Adjmt.", _SourceItemJournalLine."Entry Type"::Output], DATABASE::"Item Journal Line", _SourceItemJournalLine."Entry Type".AsInteger(), _SourceItemJournalLine."Journal Template Name", _SourceItemJournalLine."Line No.", _SourceItemJournalLine."Journal Batch Name", _SourceItemJournalLine."Order Line No.", _SourceItemJournalLine."Item No.", _Qty, 1, _SourceItemJournalLine."Location Code", _SourceItemJournalLine."Variant Code", _SourceItemJournalLine."Bin Code", _SourceItemJournalLine."Posting Date", _SourceItemJournalLine."Posting Date", _ExpirationDate, _WarrantyDate, _SerialNo, _LotNo, _PackageNo, 0);
    end;
    procedure CreateTracking_WSL(_SourceWhseShipmentLine: Record "Warehouse Shipment Line"; _Qty: Decimal; _QtyperUOM: Decimal; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50])
    begin
        CreateSpecTracking(false, _SourceWhseShipmentLine."Source Type", _SourceWhseShipmentLine."Source Subtype", _SourceWhseShipmentLine."Source No.", _SourceWhseShipmentLine."Source Line No.", '', 0, _SourceWhseShipmentLine."Item No.", _Qty, _SourceWhseShipmentLine."Qty. per Unit of Measure", _SourceWhseShipmentLine."Location Code", _SourceWhseShipmentLine."Variant Code", _SourceWhseShipmentLine."Bin Code", 0D, 0D, _ExpirationDate, _WarrantyDate, '', _LotNo, '', 0);
    end;
    procedure CreateTracking_WRL(_SourceWhseReceiptLine: Record "Warehouse Receipt Line"; _Qty: Decimal; _QtyperUOM: Decimal; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50])
    begin
        CreateSpecTracking(true, _SourceWhseReceiptLine."Source Type", _SourceWhseReceiptLine."Source Subtype", _SourceWhseReceiptLine."Source No.", _SourceWhseReceiptLine."Source Line No.", '', 0, _SourceWhseReceiptLine."Item No.", _Qty, _SourceWhseReceiptLine."Qty. per Unit of Measure", _SourceWhseReceiptLine."Location Code", _SourceWhseReceiptLine."Variant Code", _SourceWhseReceiptLine."Bin Code", 0D, 0D, _ExpirationDate, _WarrantyDate, _SerialNo, _LotNo, _PackageNo, 0);
    end;
    procedure CreateTracking_POL(_SourceProdOrderLine: Record "Prod. Order Line"; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50])
    begin
        CreateSpecTracking(true, DATABASE::"Prod. Order Line", _SourceProdOrderLine.Status.AsInteger(), _SourceProdOrderLine."Prod. Order No.", 0, '', _SourceProdOrderLine."Line No.", _SourceProdOrderLine."Item No.", _SourceProdOrderLine.Quantity, _SourceProdOrderLine."Qty. per Unit of Measure", _SourceProdOrderLine."Location Code", _SourceProdOrderLine."Variant Code", '', Today, Today, _ExpirationDate, _WarrantyDate, '', _LotNo, '', 0);
    end;
    #endregion 
    #region Generic Create Tracking handler
    local procedure CreateSpecTracking(_Positive: Boolean; _SourceType: Integer; _SourceSubType: Integer; _SourceID: Code[20]; _SourceRefNo: Integer; _SourceBatch: Code[10]; _SourceProdOrderLine: Integer; _ItemNo: Code[20]; _Qty: Decimal; _QtyperUOM: Decimal; _LocationCode: Code[10]; _VariantCode: Code[10]; _BinCode: Code[20]; _ExpectedReceiptDate: Date; _ShipmentDate: Date; _ExpirationDate: Date; _WarrantyDate: Date; _SerialNo: Code[50]; _LotNo: Code[50]; _PackageNo: Code[50]; _ApplyFromEntryNo: Integer)
    var
        Item: Record Item;
        ITC: Record "Item Tracking Code";
        ILE: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        ReservEntryReserved: Record "Reservation Entry";
        ItemJournal: Record "Item Journal Line";
        ILEBuffer: Record "Item Ledger Entry" temporary;
        TrackingSpecificationTmp: Record "Tracking Specification" temporary;
        ItemJournalTemp: Record "Item Journal Line" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        QtyToTrack: Decimal;
        TrackQty: Decimal;
        ReservedQty: Decimal;
        ReservStatus: enum "Reservation Status";
        Proceed: Boolean;
        CurrentSourceRowID: Text[250];
        SecondSourceRowID: Text[250];
        TrackingSeesReservations, TrackingMakesReservations: Boolean;
    begin
        EventLogMgt.LogProcessDebug_MethodStart();
        if not CheckIfItemTrackingIsEnabled(_ItemNo)then exit;
        TrackingSeesReservations:=SettingsMgt.CheckSetting(ConstMgt.BOS_TrackingSeesReservations());
        TrackingMakesReservations:=SettingsMgt.CheckSetting(ConstMgt.BOS_TrackingMakesReservations());
        ILE.LockTable;
        ReservEntry.LockTable;
        if _Positive then begin
            Proceed:=false;
            ReservStatus:=ReservStatus::Prospect;
            Item.Get(_ItemNo);
            QtyToTrack:=_Qty;
            Clear(ReservEntry);
            ReservEntry."Serial No.":=_SerialNo;
            ReservEntry."Lot No.":=_LotNo;
            ReservEntry."Package No.":=_PackageNo;
            CreateReservEntry.CreateReservEntryFor(_SourceType, _SourceSubType, _SourceID, _SourceBatch, _SourceProdOrderLine, _SourceRefNo, _QtyperUOM, QtyToTrack, QtyToTrack, ReservEntry);
            CreateReservEntry.SetApplyFromEntryNo(_ApplyFromEntryNo);
            CreateReservEntry.SetDates(_WarrantyDate, _ExpirationDate);
            CreateReservEntry.CreateEntry(_ItemNo, _VariantCode, _LocationCode, Item.Description, _ExpectedReceiptDate, _ShipmentDate, 0, ReservStatus);
        end
        else
        begin
            if((_SourceType = DATABASE::"Item Journal Line") and (_SourceSubType = ItemJournal."Entry Type"::Transfer.AsInteger()))then ReservStatus:=ReservStatus::Prospect
            else
                ReservStatus:=ReservStatus::Surplus;
            QtyToTrack:=_Qty;
            ILE.Reset;
            ILE.SetCurrentKey("Item No.", "Posting Date");
            ILE.SetRange("Item No.", _ItemNo);
            ILE.SetRange("Location Code", _LocationCode);
            ILE.SetRange(Open, true);
            ILE.SetRange(Positive, true);
            if(_SerialNo <> '')then ILE.SetRange("Serial No.", _SerialNo);
            if(_LotNo <> '')then ILE.SetRange("Lot No.", _LotNo);
            if(_PackageNo <> '')then ILE.SetRange("Package No.", _PackageNo);
            ILE.SetRange("Variant Code", _VariantCode);
            if ILE.FindSet(false, false)then repeat if(TrackingSeesReservations)then ILE.CalcFields("Reserved Quantity");
                    ILEBuffer.Reset;
                    ILEBuffer.CopyFilters(ILE);
                    ILEBuffer.SetRange("Serial No.", ILE."Serial No.");
                    ILEBuffer.SetRange("Lot No.", ILE."Lot No.");
                    ILEBuffer.SetRange("Package No.", ILE."Package No.");
                    if not ILEBuffer.FindFirst()then begin
                        ILEBuffer.Init;
                        ILEBuffer.Copy(ILE);
                        ILEBuffer."Posting Date":=ILE."Expiration Date";
                        Clear(ILEBuffer."Remaining Quantity");
                        ILEBuffer.Insert;
                    end;
                    ILEBuffer.Quantity+=ILE.Quantity;
                    case TrackingSeesReservations of true: ILEBuffer."Remaining Quantity"+=(ILE."Remaining Quantity" - ILE."Reserved Quantity");
                    false: ILEBuffer."Remaining Quantity"+=(ILE."Remaining Quantity");
                    end;
                    ILEBuffer.Modify();
                until ILE.Next = 0;
            ILEBuffer.Reset;
            ILEBuffer.SetCurrentKey("Item No.", "Posting Date");
            ILEBuffer.SetAscending("Posting Date", true);
            if ILEBuffer.FindSet(false, false)then repeat if(QtyToTrack > ILEBuffer."Remaining Quantity")then begin
                        QtyToTrack-=ILEBuffer."Remaining Quantity";
                        TrackQty:=ILEBuffer."Remaining Quantity";
                    end
                    else
                    begin
                        TrackQty:=QtyToTrack;
                        QtyToTrack:=0;
                    end;
                    if((_SourceType = DATABASE::"Item Journal Line") and (_SourceSubType = ItemJournal."Entry Type"::Transfer.AsInteger()))then begin
                        CreateReservEntry.SetNewExpirationDate(_ExpirationDate);
                        Clear(ItemJournalTemp);
                        ItemJournalTemp."Serial No.":=_SerialNo;
                        ItemJournalTemp."Lot No.":=_LotNo;
                        ItemJournalTemp."Package No.":=_PackageNo;
                        CreateReservEntry.SetNewTrackingFromItemJnlLine(ItemJournalTemp);
                    end;
                    clear(ReservEntry);
                    ReservEntry."Serial No.":=ILEBuffer."Serial No.";
                    ReservEntry."Lot No.":=ILEBuffer."Lot No.";
                    ReservEntry."Package No.":=ILEBuffer."Package No.";
                    CreateReservEntry.CreateReservEntryFor(_SourceType, _SourceSubType, _SourceID, _SourceBatch, 0, _SourceRefNo, _QtyperUOM, TrackQty, TrackQty, ReservEntry);
                    if(_ApplyFromEntryNo <> 0)then CreateReservEntry.SetApplyFromEntryNo(_ApplyFromEntryNo);
                    if(TrackingMakesReservations)then begin
                        ReservStatus:=ReservStatus::Reservation;
                        TrackingSpecificationTmp.DeleteAll();
                        TrackingSpecificationTmp."Source Type":=Database::"Item Ledger Entry";
                        TrackingSpecificationTmp."Source Ref. No.":=ILEBuffer."Entry No.";
                        //Tracking data used
                        TrackingSpecificationTmp."Serial No.":=ILEBuffer."Serial No.";
                        TrackingSpecificationTmp."Lot No.":=ILEBuffer."Lot No.";
                        TrackingSpecificationTmp."Warranty Date":=ILEBuffer."Warranty Date";
                        TrackingSpecificationTmp."Expiration Date":=ILEBuffer."Expiration Date";
                        TrackingSpecificationTmp.Insert();
                        CreateReservEntry.CreateReservEntryFrom(TrackingSpecificationTmp);
                    end;
                    CreateReservEntry.CreateEntry(_ItemNo, _VariantCode, _LocationCode, Item.Description, _ExpectedReceiptDate, _ShipmentDate, 0, ReservStatus);
                    if(_SourceType = DATABASE::"Transfer Line")then begin
                        Clear(ItemTrackingMgt);
                        CurrentSourceRowID:=ItemTrackingMgt.ComposeRowID(_SourceType, _SourceSubType, _SourceID, _SourceBatch, _SourceProdOrderLine, _SourceRefNo);
                        SecondSourceRowID:=ItemTrackingMgt.ComposeRowID(_SourceType, 1, _SourceID, _SourceBatch, _SourceProdOrderLine, _SourceRefNo);
                        ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, '');
                    end;
                until((ILEBuffer.Next = 0) or (QtyToTrack = 0));
        end;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    #endregion 
    #region QtytoHandle processing
    procedure DeleteTrackingQtytoHandle(var TrackingSpecification: Record "Tracking Specification")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        TrackingSpecification.Reset;
        if TrackingSpecification.FindSet(false, false)then repeat ReservEntry.Reset;
                ReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line");
                ReservEntry.SetRange("Source Type", TrackingSpecification."Source Type");
                ReservEntry.SetRange("Source Subtype", TrackingSpecification."Source Subtype");
                ReservEntry.SetRange("Source ID", TrackingSpecification."Source ID");
                ReservEntry.SetRange("Source Batch Name", TrackingSpecification."Source Batch Name");
                ReservEntry.SetRange("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
                ReservEntry.SetRange("Source Ref. No.", TrackingSpecification."Source Ref. No.");
                ReservEntry.ModifyAll("Qty. to Handle (Base)", 0, true);
                ReservEntry.SetRange("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
                ReservEntry.SetRange("Source Ref. No.");
                ReservEntry.ModifyAll("Qty. to Handle (Base)", 0, true);
            until TrackingSpecification.Next = 0;
    end;
    procedure DeleteTrackingQtytoHandleSH(VAR SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ReservEntry: Record "Reservation Entry";
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        IF SalesLine.FINDSET(FALSE, FALSE)THEN REPEAT ReservEntry.RESET;
                ReservEntry.SetSourceFilter(DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", TRUE);
                ReservEntry.SetSourceFilter('', 0);
                //ReservEntry.SETRANGE("Mobile Processed", FALSE);
                ReservEntry.MODIFYALL("Qty. to Handle (Base)", 0);
                ReservEntry.MODIFYALL("Qty. to Invoice (Base)", 0);
            UNTIL SalesLine.NEXT = 0;
    end;
    procedure DeleteTrackingQtytoHandlePL(VAR PurchaseLine: Record "Purchase Line")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.RESET;
        ReservEntry.SetSourceFilter(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.", TRUE);
        ReservEntry.SetSourceFilter('', 0);
        //ReservEntry.SETRANGE("Mobile Processed", FALSE);
        ReservEntry.MODIFYALL("Qty. to Handle (Base)", 0);
        ReservEntry.MODIFYALL("Qty. to Invoice (Base)", 0);
        Message('DeleteTrackingQtytoHandlePL fired [%1]', ReservEntry.Count)end;
    procedure DeleteTrackingQtytoHandleTH(VAR TransferHeader: Record "Transfer Header"; Direction: Enum "Transfer Direction")
    var
        TransferLine: Record "Transfer Line";
        ReservEntry: Record "Reservation Entry";
    begin
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF TransferLine.FINDSET(FALSE, FALSE)THEN REPEAT case Direction of Direction::Outbound: begin
                    //Reset negative entry
                    ReservEntry.RESET;
                    ReservEntry.SetSourceFilter(DATABASE::"Transfer Line", 0, TransferLine."Document No.", TransferLine."Line No.", TRUE);
                    ReservEntry.SetSourceFilter('', 0);
                    ReservEntry.MODIFYALL("Qty. to Handle (Base)", 0);
                    ReservEntry.MODIFYALL("Qty. to Invoice (Base)", 0);
                    //Reset positive entry
                    ReservEntry.RESET;
                    ReservEntry.SetSourceFilter(DATABASE::"Transfer Line", 1, TransferLine."Document No.", TransferLine."Line No.", TRUE);
                    ReservEntry.SetSourceFilter('', 0);
                    ReservEntry.MODIFYALL("Qty. to Handle (Base)", 0);
                    ReservEntry.MODIFYALL("Qty. to Invoice (Base)", 0);
                end;
                Direction::Inbound: begin
                    //No filter by Line No., filter by Prod Order Line No. only
                    ReservEntry.RESET;
                    ReservEntry.SetSourceFilter(DATABASE::"Transfer Line", Direction.AsInteger(), TransferLine."Document No.", 0, TRUE);
                    ReservEntry.SetSourceFilter('', TransferLine."Line No.");
                    ReservEntry.MODIFYALL("Qty. to Handle (Base)", 0);
                    ReservEntry.MODIFYALL("Qty. to Invoice (Base)", 0);
                end;
                end;
            UNTIL TransferLine.NEXT = 0;
    end;
    #endregion 
    #region Checks and References
    local procedure FilterReservEntry(_Rec: Variant; var _ReservEntry: Record "Reservation Entry"): Boolean var
        RecRef: RecordRef;
        ProdOrderLine: Record "Prod. Order Line";
    begin
        RecRef.GetTable(_Rec);
        case RecRef.Number of Database::"Prod. Order Line": begin
            ProdOrderLine.Reset();
            RecRef.SetTable(ProdOrderLine);
            _ReservEntry.Reset();
            _ReservEntry.SetSourceFilter(DATABASE::"Prod. Order Line", ProdOrderLine.Status.AsInteger(), ProdOrderLine."Prod. Order No.", 0, false);
            _ReservEntry.SetSourceFilter('', ProdOrderLine."Line No.");
        end;
        end;
    end;
    procedure CheckIfItemTrackingIsEnabled(_ItemNo: Code[20])Result: boolean var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        clear(Result);
        if(_ItemNo = '')then exit;
        if not Item.Get(_ItemNo)then clear(Item);
        if(Item."Item Tracking Code" = '')then exit;
        if not ItemTrackingCode.Get(Item."Item Tracking Code")then clear(ItemTrackingCode);
        Exit(ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking" OR ItemTrackingCode."Package Specific Tracking");
    end;
    procedure CheckReservEntryExist(_Rec: Variant): Boolean var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Reset();
        FilterReservEntry(_Rec, ReservEntry);
        exit(not ReservEntry.IsEmpty);
    end;
    procedure GetReservEntryLot(_Rec: Variant): Code[20]var
        ReservEntry: Record "Reservation Entry";
    begin
        Clear(ReservEntry);
        ReservEntry.Reset();
        FilterReservEntry(_Rec, ReservEntry);
        if not ReservEntry.FindLast()then Clear(ReservEntry);
        exit(ReservEntry."Lot No.");
    end;
    procedure GetReservEntryExpirationDate(_Rec: Variant): Date var
        ReservEntry: Record "Reservation Entry";
    begin
        Clear(ReservEntry);
        ReservEntry.Reset();
        FilterReservEntry(_Rec, ReservEntry);
        if not ReservEntry.FindLast()then clear(ReservEntry);
        exit(ReservEntry."Expiration Date");
    end;
    procedure GetLotExpirationDate(ItemNo: Code[20]; LocationCode: Code[10]; LotNo: Code[20])Result: Date var
        ILE: Record "Item Ledger Entry";
    begin
        Clear(Result);
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking", "Lot No.", "Serial No.");
        ILE.SetRange("Item No.", ItemNo);
        ILE.SetRange("Location Code", LocationCode);
        ILE.SetRange("Lot No.", LotNo);
        if ILE.FindFirst then if(ILE."Expiration Date" <> 0D)then Result:=ILE."Expiration Date";
    end;
    #endregion 
    #region Dynamics Mobile AT
    procedure SetPointerFilterByEntryNo(var ReservEntry: Record "Reservation Entry"; EntryNo: Integer)
    begin
        ReservEntry.SetRange("Entry No.", EntryNo);
    end;
#endregion 
}
