codeunit 70102 DYM_BindPostProcessEventSubs
{
    EventSubscriberInstance = Manual;

    var
        SDSHandler: Codeunit DYM_SessionDataStoreHandler;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    begin
        SDSHandler.PP_EDL_SalesShipmentHeader_Set(SalesShptHdrNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', true, true)]
    local procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header"; InvtPickPutaway: Boolean)
    begin
        SDSHandler.PP_EDL_TransferShipmentHeader_Set(TransferShipmentHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', true, true)]
    local procedure OnAfterTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        SDSHandler.PP_EDL_TransferReceiveHeader_Set(TransferReceiptHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', true, true)]
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    begin
        SDSHandler.PP_EDL_PurchCRMemoHeader_Set(PurchCrMemoHdrNo);
        SDSHandler.PP_EDL_PurchInvoiceHeader_Set(PurchInvHdrNo);
        SDSHandler.PP_EDL_PurchReceiveHeader_Set(PurchRcpHdrNo);
    end;
}
