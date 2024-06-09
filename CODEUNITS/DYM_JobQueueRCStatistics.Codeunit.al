codeunit 70130 DYM_JobQueueRCStatistics
{
    trigger OnRun()
    begin
        CalculateRoleCenterStatistics();
    end;

    var
        ConstMgt: Codeunit DYM_ConstManagement;
        StateMgt: Codeunit DYM_StateManagement;
        MobileSetup: Record DYM_DynamicsMobileSetup;

    local procedure CalculateRoleCenterStatistics()
    var
        Cue: Record DYM_DynamicsMobileCue;
        DeviceSetup: Record DYM_DeviceSetup;
    begin
        Clear(Cue);
        Clear(DeviceSetup);
        if not MobileSetup.Get then Clear(MobileSetup);
        if (DeviceSetup.FindSet()) then
            repeat
                Cue.Reset;
                if (MobileSetup."Dashboard Calculation Days" <> 0) then Cue.SetFilter("Date Filter", '>%1', CreateDateTime(Today - MobileSetup."Dashboard Calculation Days", 0T));
                Cue.SetRange("Device Filter", DeviceSetup.Code);
                Cue.CalcFields(Pushes, Pulls, Pending, Success, Failed, Error);
                Cue.CalcFields("Total Basic Stock Counts", "Total Warehouse Receive", "Total Inbound Transfers", "Total Outbound Transfer", "Total Shipments", "Total Warehouse Receipts", "Total Warehouse Put-Aways", "Total WMS Movements", "Total Manual Movements", "Total Warehouse Picks", "Total Warehouse Loads", "Total WMS Stock Counts", "Total Bin Movements");
                Cue.CalcFields("Total Sales Order", "Total Invoices", "Total Payments", "Total Return Orders", "Total Invenotory Loads", "Total Invenotory Unloads", "Total Truck Invenotory Receive", "Total Receive Inventory", "Total Stock Count", "Total Sales Quotes");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Pushes, Cue.Pushes);
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Pulls, Cue.Pulls);
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Pending, Cue.Pending);
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Success, Cue.Success);
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Failed, Cue.Failed);
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Error, Cue.Error);
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_SalesOrder, Cue."Total Sales Order");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Invoices, Cue."Total Invoices");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_InvenotoryLoads, Cue."Total Invenotory Loads");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_InvenotoryUnloads, Cue."Total Invenotory Unloads");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Payments, Cue."Total Payments");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_ReturnOrders, Cue."Total Return Orders");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_TruckInvenotoryReceive, Cue."Total Truck Invenotory Receive");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_SalesQuotes, Cue."Total Sales Quotes");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_StockCount, Cue."Total Stock Count");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_ReceiveInventory, Cue."Total Receive Inventory");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_BasicStockCounts, Cue."Total Basic Stock Counts");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WarehouseReceive, Cue."Total Warehouse Receive");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_BinMovements, Cue."Total Bin Movements");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_InboundTransfers, Cue."Total Inbound Transfers");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_OutboundTransfers, Cue."Total Outbound Transfer");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_Shipments, Cue."Total Shipments");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WarehouseLoads, Cue."Total Warehouse Loads");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WarehousePicks, Cue."Total Warehouse Picks");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WarehousePutAways, Cue."Total Warehouse Put-Aways");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WarehouseReceipts, Cue."Total Warehouse Receipts");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WMSStockCounts, Cue."Total WMS Stock Counts");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_WMSMovements, Cue."Total WMS Movements");
                UpdateStateVariable(DeviceSetup.Code, ConstMgt.RCS_ManualMovements, Cue."Total Manual Movements");
            until DeviceSetup.Next() = 0;
    end;

    local procedure UpdateStateVariable(DeviceSetupCode: Code[100]; Operation: Text[100]; CalculatedCount: Integer)
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    begin
        StateMgt.SetStateVar(DeviceSetupCode, Operation, LowLevelDP.Integer2Text(CalculatedCount));
    end;
}
