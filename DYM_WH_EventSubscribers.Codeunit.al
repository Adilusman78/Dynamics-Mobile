codeunit 84301 DYM_WH_EventSubscribers
{
    var SDSHandler: Codeunit DYM_SessionDataStoreHandler;
    LLDP: Codeunit DYM_LowLevelDataProcess;
    ConstMgt: Codeunit DYM_WH_ConstManagement;
    //Handles retrieval of newly generated Warehouse Activity Line after split (pushes the value to SDS)
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterSplitLines', '', false, false)]
    local procedure T5767_OnAfterSplitLines(var WarehouseActivityLine: Record "Warehouse Activity Line"; NewWarehouseActivityLine: Record "Warehouse Activity Line");
    begin
        //DMSDS.SetValue(WarehouseActivityLine.GetPosition(false), LLDP.Integer2Text(NewWarehouseActivityLine."Line No."));
        SDSHandler.WAL_Split_Set(WarehouseActivityLine, NewWarehouseActivityLine);
    end;
    #region Default Quantities
    //Set "Default Quantity to Ship" to Blank depending on selected Location
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterGetSalesSetup', '', false, false)]
    local procedure T37_OnAfterGetSalesSetup(var SalesLine: Record "Sales Line"; var SalesSetup: Record "Sales & Receivables Setup");
    var
        Location: Record Location;
    begin
        if(SalesLine.Type = SalesLine.Type::Item)then if(Location.DYM_CheckZeroSalesQtytoShip(SalesLine."Location Code"))then SalesSetup."Default Quantity to Ship":=SalesSetup."Default Quantity to Ship"::Blank;
    end;
    //Initialize "Qty. to Invoice" with "Qty. Shipped not Invoiced" after posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostUpdateOrderLineModifyTempLine', '', false, false)]
    local procedure OnBeforePostUpdateOrderLineModifyTempLine(var TempSalesLine: Record "Sales Line"; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var IsHandled: Boolean);
    begin
        TempSalesLine.InitQtyToInvoice();
    end;
    //Set "Default Qty. to Receive" to Blank depending on selected Location
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterGetPurchSetup', '', false, false)]
    local procedure T39_OnAfterGetPurchSetup(var PurchaseLine: Record "Purchase Line"; var PurchSetup: Record "Purchases & Payables Setup");
    var
        Location: record Location;
    begin
        if(PurchaseLine.Type = PurchaseLine.Type::Item)then if(Location.DYM_CheckZeroPurchQtytoReceive(PurchaseLine."Location Code"))then PurchSetup."Default Qty. to Receive":=PurchSetup."Default Qty. to Receive"::Blank;
    end;
    //Set "Qty. to Ship" and "Qty. to Receive" in transfers
    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterUpdateWithWarehouseShipReceive', '', false, false)]
    local procedure T5741_OnAfterUpdateWithWarehouseShipReceive(var TransferLine: Record "Transfer Line"; CurrentFieldNo: Integer);
    var
        Location: Record Location;
    begin
        if(Location.DYM_CheckZeroTransQtytoShip(TransferLine."Transfer-from Code"))then TransferLine.Validate("Qty. to Ship", 0);
        if(not TransferLine."Direct Transfer")then if(Location.DYM_CheckZeroTransQtytoReceive(TransferLine."Transfer-to Code"))then TransferLine.Validate("Qty. to Receive", 0);
    end;
    //Set "Qty. to Ship" in Warehouse Shipments
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterValidateEvent', 'Qty. Outstanding', false, false)]
    local procedure T7321_F19_OnAfterValidateEvent(VAR Rec: Record "Warehouse Shipment Line"; VAR xRec: Record "Warehouse Shipment Line")
    var
        Location: Record Location;
    begin
        if Location.DYM_CheckZeroWhseShipmentQtytoShip(Rec."Location Code")then Rec.Validate("Qty. to Ship", 0);
    end;
    //Set "Qty. to Receive" in Warehouse Receipts
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Line", 'OnAfterValidateEvent', 'Qty. Outstanding', false, false)]
    local procedure T7317_F19_OnAfterValidateEvent(VAR Rec: Record "Warehouse Receipt Line"; VAR xRec: Record "Warehouse Receipt Line")
    var
        Location: Record Location;
        TransLine: Record "Transfer Line";
        Proceed: Boolean;
    begin
        clear(Proceed);
        if Location.DYM_CheckZeroWhseRcptQtytoReceive(Rec."Location Code")then Proceed:=true;
        If(Rec."Source Type" = DATABASE::"Transfer Line")then begin
            TransLine.Get(Rec."Source No.", Rec."Source Line No.");
            If(not TransLine."Direct Transfer")then Proceed:=true;
        end;
        if(Proceed)then Rec.Validate("Qty. to Receive", 0);
    end;
    //Set "Qty. to Handle" in Put-Away
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnBeforeWhseActivLineInsert', '', false, false)]
    local procedure C7313_OnBeforeWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; PostedWhseRcptLine: Record "Posted Whse. Receipt Line");
    var
        Location: Record Location;
    begin
        if Location.DYM_CheckZeroPutAwayQtytoHandle(WarehouseActivityLine."Location Code")then WarehouseActivityLine.Validate("Qty. to Handle", 0);
    end;
    //Set "Qty. to Handle" in Warehouse Activity Line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterWhseActivLineInsert', '', false, false)]
    local procedure C7312_OnAfterWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line");
    var
        Location: Record Location;
    begin
        if Location.DYM_CheckZeroWhseActivityQtytoHandle(WarehouseActivityLine."Location Code", WarehouseActivityLine."Activity Type")then begin
            WarehouseActivityLine.Validate("Qty. to Handle", 0);
            WarehouseActivityLine.Modify(); //No trigger is called as pairing action line might not be available yet
        end;
    end;
    //Set "Qty. (Phys. Inventory)" in Phys. Inventory Journal
    [EventSubscriber(ObjectType::Report, Report::"Calculate Inventory", 'OnBeforeInsertItemJnlLine', '', false, false)]
    local procedure R790_OnBeforeInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; var InventoryBuffer: Record "Inventory Buffer");
    var
        Location: Record Location;
    begin
        if(Location.DYM_CheckPhysInvJnlQtyPhysInv(ItemJournalLine."Location Code"))then ItemJournalLine.Validate("Qty. (Phys. Inventory)", 0);
    end;
    [EventSubscriber(ObjectType::Report, Report::"Whse. Calculate Inventory", 'OnBeforeWhseJnlLineInsert', '', false, false)]
    local procedure OnBeforeWhseJnlLineInsert(var WarehouseJournalLine: Record "Warehouse Journal Line"; var WarehouseEntry: Record "Warehouse Entry"; var NextLineNo: Integer);
    var
        Location: Record Location;
    begin
        if(Location.DYM_CheckZeroWhsePhysInvJnlQtyPhys(WarehouseJournalLine."Location Code"))then WarehouseJournalLine.Validate("Qty. (Phys. Inventory)", 0);
    end;
    #endregion 
    #region Mobile Status
    //Set "Mobile Status" in Warehouse Shipments
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseShptHeaderInsert', '', false, false)]
    local procedure R5753_OnBeforeWhseShptHeaderInsert(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; TransferLine: Record "Transfer Line");
    var
        Location: Record Location;
    begin
        if Location.DYM_AutoMobStatusWhseShipment(WarehouseShipmentHeader."Location Code")then WarehouseShipmentHeader.DYM_MobileStatus:=DYM_BS_MobileStatus::Pending;
    end;
    //Set "Mobile Status" in Warehouse Receipts
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseReceiptHeaderInsert', '', false, false)]
    local procedure R5753_OnBeforeWhseReceiptHeaderInsert(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var WarehouseRequest: Record "Warehouse Request");
    var
        Location: Record Location;
    begin
        if Location.DYM_AutoMobStatusWhseReceipt(WarehouseReceiptHeader."Location Code")then WarehouseReceiptHeader.DYM_MobileStatus:=DYM_BS_MobileStatus::Pending;
    end;
    //Set "Mobile Status" in Put-Away
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnBeforeWhseActivHeaderInsert', '', false, false)]
    local procedure C7313_OnBeforeWhseActivHeaderInsert(var WarehouseActivityHeader: Record "Warehouse Activity Header"; PostedWhseReceiptLine: Record "Posted Whse. Receipt Line");
    var
        Location: Record Location;
    begin
        if Location.DYM_AutoMobStatusWhsePutAway(WarehouseActivityHeader."Location Code")then WarehouseActivityHeader.DYM_MobileStatus:=DYM_BS_MobileStatus::Pending;
    end;
    //Set "Mobile Status" in Pick and Movement
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivHeaderInsert', '', false, false)]
    local procedure C7312_OnBeforeWhseActivHeaderInsert(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var TempWhseActivityLine: Record "Warehouse Activity Line");
    var
        Location: Record Location;
    begin
        //Handles both Pick and Movement
        if Location.DYM_AutoMobStatusWhseActivity(WarehouseActivityHeader."Location Code", WarehouseActivityHeader.Type)then WarehouseActivityHeader.DYM_MobileStatus:=DYM_BS_MobileStatus::Pending;
    end;
    //Handles "Mobile Status" in Transfer after shipping
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnRunOnBeforeCommit', '', false, false)]
    local procedure OnRunOnBeforeCommit(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header"; PostedWhseShptHeader: Record "Posted Whse. Shipment Header"; var SuppressCommit: Boolean);
    var
        Location: Record Location;
    begin
        if Location.DYM_AutoMobStatusTransferRcpt(TransferHeader."Transfer-to Code")then TransferHeader.DYM_MobileReceiveStatus:=DYM_BS_MobileStatus::Pending;
        TransferHeader.Modify();
    end;
    #endregion 
    #region Default Tracking Quantities
    /// <summary>
    /// Clears "Qty. to Handle" when entering tracking information for Sales, Purchases and Transfers
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="xRec"></param>
    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterValidateEvent', 'Quantity (Base)', false, false)]
    local procedure T336_F4_OnAfterValidateEvent(VAR Rec: Record "Tracking Specification"; VAR xRec: Record "Tracking Specification")
    var
        Location: Record Location;
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        ClearQty: Boolean;
    begin
        if((Rec."Source Type" = Database::"Purchase Line") AND (Rec."Source Subtype" = PurchaseHeader."Document Type"::Order.AsInteger()))then begin
            if(Location.DYM_CheckZeroPurchTrackQtytoHandle(Rec."Location Code"))then begin
                clear(Rec."Qty. to Handle (Base)");
                clear(Rec."Qty. to Invoice (Base)");
            end;
        end;
        if((Rec."Source Type" = Database::"Sales Line") AND (Rec."Source Subtype" = SalesHeader."Document Type"::Order.AsInteger()))then begin
            if(Location.DYM_CheckZeroSalesTrackQtytoHandle(Rec."Location Code"))then begin
                clear(Rec."Qty. to Handle (Base)");
                clear(Rec."Qty. to Invoice (Base)");
            end;
        end;
        if(Rec."Source Type" = Database::"Transfer Line")then begin
            TransferHeader.Get(Rec."Source ID");
            clear(ClearQty);
            if(Rec."Source Subtype" = 0)then ClearQty:=Location.DYM_CheckZeroTransShipQtytoHandle(Rec."Location Code");
            if(not TransferHeader."Direct Transfer")then if(Rec."Source Subtype" = 1)then ClearQty:=Location.DYM_CheckZeroTransReceiveQtytoHandle(Rec."Location Code");
            if(ClearQty)then begin
                clear(Rec."Qty. to Handle (Base)");
                clear(Rec."Qty. to Invoice (Base)");
            end;
        end;
    end;
    /// <summary>
    /// Clears "Qty. to Handle" after posting of Sales, Purchases and Transfers
    /// </summary>
    /// <param name="ReservEntry"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnUpdateItemTrackingAfterPostingOnBeforeReservEntryModify', '', false, false)]
    local procedure C99000830_OnUpdateItemTrackingAfterPostingOnBeforeReservEntryModify(var ReservEntry: Record "Reservation Entry");
    var
        Location: Record Location;
        PurchLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        SalesLine: Record "Sales Line";
        ClearQty: Boolean;
    begin
        if((ReservEntry."Source Type" = Database::"Purchase Line") AND (ReservEntry."Source Subtype" = PurchLine."Document Type"::Order.AsInteger()))then begin
            if(Location.DYM_CheckZeroPurchTrackQtytoHandle(ReservEntry."Location Code"))then begin
                clear(ReservEntry."Qty. to Handle (Base)");
                clear(ReservEntry."Qty. to Invoice (Base)");
            end;
        end;
        if((ReservEntry."Source Type" = Database::"Sales Line") AND (ReservEntry."Source Subtype" = SalesLine."Document Type"::Order.AsInteger()))then begin
            if(Location.DYM_CheckZeroSalesTrackQtytoHandle(ReservEntry."Location Code"))then begin
                clear(ReservEntry."Qty. to Handle (Base)");
                clear(ReservEntry."Qty. to Invoice (Base)");
            end;
        end;
        if(ReservEntry."Source Type" = Database::"Transfer Line")then begin
            TransLine.Get(ReservEntry."Source ID", ReservEntry."Source Ref. No.");
            clear(ClearQty);
            if(ReservEntry."Source Subtype" = 0)then ClearQty:=Location.DYM_CheckZeroTransShipQtytoHandle(ReservEntry."Location Code");
            if(not TransLine."Direct Transfer")then if(ReservEntry."Source Subtype" = 1)then ClearQty:=Location.DYM_CheckZeroTransReceiveQtytoHandle(ReservEntry."Location Code");
            if(ClearQty)then begin
                clear(ReservEntry."Qty. to Handle (Base)");
                clear(ReservEntry."Qty. to Invoice (Base)");
            end;
        end;
    end;
    /// <summary>
    /// Clears "Qty. to Handle" on Transfer Ship for newly created Reservation Entry records corresponding to created transfer derived lines
    /// </summary>
    /// <param name="NewReservEntry"></param>
    /// <param name="IsPartnerRecord"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnTransferReservEntryOnBeforeNewReservEntryModify', '', false, false)]
    local procedure C99000830_OnTransferReservEntryOnBeforeNewReservEntryModify(var NewReservEntry: Record "Reservation Entry"; IsPartnerRecord: Boolean);
    var
        Location: Record Location;
        TransLine: Record "Transfer Line";
        ClearQty: Boolean;
    begin
        if(NewReservEntry."Source Type" = Database::"Transfer Line")then begin
            TransLine.Get(NewReservEntry."Source ID", NewReservEntry."Source Ref. No.");
            clear(ClearQty);
            if(NewReservEntry."Source Subtype" = 0)then ClearQty:=Location.DYM_CheckZeroTransShipQtytoHandle(NewReservEntry."Location Code");
            if(not TransLine."Direct Transfer")then if(NewReservEntry."Source Subtype" = 1)then ClearQty:=Location.DYM_CheckZeroTransReceiveQtytoHandle(NewReservEntry."Location Code");
            if(ClearQty)then begin
                clear(NewReservEntry."Qty. to Handle (Base)");
                clear(NewReservEntry."Qty. to Invoice (Base)");
            end;
        end;
    end;
#endregion 
/*
    #region Document deletion checks
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T36_OnBeforeDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        Rec.DYM_testMobileStatus();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T37_OnBeforeDelete(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        Rec.DYM_testMobileStatus();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T38_OnBeforeDelete(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    begin
        Rec.DYM_testMobileStatus();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T39_OnBeforeDelete(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    begin
        Rec.DYM_testMobileStatus();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T5740_OnBeforeDelete(var Rec: Record "Transfer Header"; RunTrigger: Boolean)
    begin
        Rec.DYM_testMobileStatus();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T5741_OnBeforeDelete(var Rec: Record "Transfer Line"; RunTrigger: Boolean)
    begin
        Rec.DYM_testMobileStatus();
    end;
    #endregion
    */
}
