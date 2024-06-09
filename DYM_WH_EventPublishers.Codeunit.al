codeunit 84303 DYM_WH_EventPublishers
{
    [IntegrationEvent(false, false)]
    procedure OnProcessWhseDocs(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessPurchases(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessSales(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers_AfterMobileStatusSet(var TransHeader: Record "Transfer Header"; var ar_TransHeader: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTransfers_AfterLineCreated(var TransLine: Record "Transfer Line"; var ar_TransHeader: Codeunit DYM_ActiveRecManagement; var ar_TransLine: Codeunit DYM_ActiveRecManagement)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessWhseShipments(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessWhseReceipts(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessPhysInventory(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessWhseInventory(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_Sales(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_Purch(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_WhseShip(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_WhseRcpt(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_Transfer(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessTracking_NewTransfer(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessDocStatus(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessOperationHint(var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnProcessBarcode(var IsHandled: Boolean)
    begin
    end;
}
