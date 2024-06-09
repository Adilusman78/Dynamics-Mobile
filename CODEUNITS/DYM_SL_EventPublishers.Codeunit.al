codeunit 70150 DYM_SL_EventPublishers
{
    [IntegrationEvent(false, false)]
    procedure OnProcessSales(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessSales_AfterHeaderCreated(var SalesHeader: Record "Sales Header"; var ar_SalesHeader: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessSales_AfterLineCreated(var SalesHeader: Record "Sales Header"; var ar_SalesHeader: Codeunit DYM_ActiveRecManagement; var SalesLine: Record "Sales Line"; var ar_SalesLine: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessSales_BeforePostProcess(var SalesHeader: Record "Sales Header"; var ar_SalesHeader: Codeunit DYM_ActiveRecManagement; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessCustomer(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessCustomer_AfterCustomerCreated(var Customer: Record Customer; var ar_Customer: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessCustomer_AfterCustomerUpdate(var Customer: Record Customer; var ar_Customer: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessCustomer_AfterShipToUpdate(var ShipTo: Record "Ship-to Address"; var ar_Customer: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessPayments(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers_AfterHeaderCreated(var TransferHeader: Record "Transfer Header"; var ar_TransferHeader: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers_AfterLineCreated(var TransferHeader: Record "Transfer Header"; var ar_TransferHeader: Codeunit DYM_ActiveRecManagement; var TransferLine: Record "Transfer Line"; var ar_TransferLine: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers_BeforePostProcess(var TransferHeader: Record "Transfer Header"; var ar_TransferHeader: Codeunit DYM_ActiveRecManagement; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforePushProcessTracking_Sales(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_Transfer(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessDelivery(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessDelivery_AfterLineUpdate(var SalesHeader: Record "Sales Header"; var ar_SalesHeader: Codeunit DYM_ActiveRecManagement; var SalesLine: Record "Sales Line"; var ar_SalesLine: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessDelivery_BeforePostProcess(var SalesHeader: Record "Sales Header"; var ar_SalesHeader: Codeunit DYM_ActiveRecManagement; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessPhysInventory(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessDeviceActivity(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessOperationHint(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnPullProcessReturnsData_BeforeInvoiceLoop(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnPullProcessReturnsData_BeforeSkipCredited(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SkipDocument: Boolean; var IsHandled: Boolean)
    begin
    end;
}
