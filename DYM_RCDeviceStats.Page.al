page 84081 DYM_RCDeviceStats
{
    Caption = 'RC Device Stats';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = DYM_DeviceSetup;

    layout
    {
        area(content)
        {
            repeater("Packets per Device")
            {
                Caption = 'Packets per Device';

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Cue.Pulls"; PullsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Pulls';
                    Visible = EnabledPulls;
                }
                field("Cue.Pushes"; PushesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Pushes';
                    Visible = EnabledPushes;
                }
                field("Cue.Pending"; PendingCount)
                {
                    ApplicationArea = All;
                    Caption = 'Pending';
                    Visible = EnabledPending;
                }
                field("Cue.Success"; SuccessCount)
                {
                    ApplicationArea = All;
                    Caption = 'Success';
                    Visible = EnabledSuccess;
                }
                field("Cue.Failed"; FailedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Failed';
                    Visible = EnabledFailed;
                }
                field("Cue.Error"; ErrorCount)
                {
                    ApplicationArea = All;
                    Caption = 'Error';
                    Visible = EnabledError;
                }
                field("Cue.Total Sales Order"; SalesOrdersCount)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Orders';
                    Visible = VisibleSalesOrders;
                }
                field("Cue.Total Invoices"; SalesInvoicesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoices';
                    Visible = VisibleSalesInvoices;
                }
                field("Cue.Total Payments"; PaymentsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Payments';
                    Visible = VisiblePayments;
                }
                field("Cue.Total Return Orders"; ReturnOrdersCount)
                {
                    ApplicationArea = All;
                    Caption = 'Return Orders';
                    Visible = VisibleReturnOrders;
                }
                field("Cue.Total Invenotory Loads"; InventoryLoadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Invenotory Loads';
                    Visible = VisibleInventoryLoads;
                }
                field("Cue.Total Invenotory Unloads"; InventoryUnloadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Invenotory Unloads';
                    Visible = VisibleInventoryUnloads;
                }
                field("Cue.Total Truck Invenotory Receive"; TruckInventoryReceiveCount)
                {
                    ApplicationArea = All;
                    Caption = 'Truck Invenotory Receive';
                    Visible = VisibleTruckInventoryReceive;
                }
                field("Cue.Total Receive Inventory"; ReceiveInventoryCount)
                {
                    ApplicationArea = All;
                    Caption = 'Receive Inventory';
                    Visible = VisibleReceiveInventory;
                }
                field("Cue.Total Stock Count"; StockCount)
                {
                    ApplicationArea = All;
                    Caption = 'Stock Counts';
                    Visible = VisibleStockCount;
                }
                field("Cue.Total Sales Quotes"; SalesQuotesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quotes';
                    Visible = VisibleSalesQuotes;
                }
                field("Cue.Total Basic Stock Counts"; BasicStockCounts)
                {
                    ApplicationArea = All;
                    Caption = 'Basic Stock Counts';
                    Visible = VisibleBasicStockCounts;
                }
                field("Cue.Total Bin Movements"; BinMovementsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Bin Movements';
                    Visible = VisibleBinMovements;
                }
                field("Cue.Total Inbound Transfers"; InboundTransfersCount)
                {
                    ApplicationArea = All;
                    Caption = 'Inbound Transfers';
                    Visible = VisibleInboundTransfers;
                }
                field("Cue.Total Outbound Transfer"; OutboundTransfersCount)
                {
                    ApplicationArea = All;
                    Caption = 'Outbound Transfers';
                    Visible = VisibleOutboundTransfers;
                }
                field("Cue.Total Warehouse Receive"; WMSReceiveCount)
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Receives';
                    Visible = VisibleWMSReceive;
                }
                field("Cue.Total Shipments"; ShipmentsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Shipments';
                    Visible = VisibleShipments;
                }
                field("Cue.Total Warehouse Receipts"; WMSReceiptsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Receipts';
                    Visible = VisibleWMSReceipts;
                }
                field("Cue.Total Warehouse Put-Aways"; WMSPutAwayCount)
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Put-Aways';
                    Visible = VisibleWMSPutAway;
                }
                field("Cue.Total WMS Movements"; WMSMovementsCount)
                {
                    ApplicationArea = All;
                    Caption = 'WMS Movements';
                    Visible = VisibleWMSMovements;
                }
                field("Cue.Total Manual Movements"; ManualMovementCount)
                {
                    ApplicationArea = All;
                    Caption = 'Manual Movements';
                    Visible = VisibleManualMovement;
                }
                field("Cue.Total Warehouse Picks"; WMSPicksCount)
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Picks';
                    Visible = VisibleWMSPicks;
                }
                field("Cue.Total Warehouse Loads"; WMSLoadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Loads';
                    Visible = VisibleWMSLoads;
                }
                field("Cue.Total WMS Stock Counts"; WMSStockCount)
                {
                    ApplicationArea = All;
                    Caption = 'WMS Stock Counts';
                    Visible = VisibleWMSStockCount;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("View Packet Statistics")
            {
                ApplicationArea = All;
                Caption = 'View Packet Statistics';
                Image = ProdBOMMatrixPerVersion;

                trigger OnAction()
                begin
                    EnablePacketStatistics();
                    DisalebleSalesStatistics();
                    DisableWarehouseStatistics();
                end;
            }
            action("View Sales Statistics")
            {
                ApplicationArea = All;
                Caption = 'View Sales Statistics';
                Image = Sales;

                trigger OnAction()
                begin
                    EnableSalesStatistics();
                    DisablePacketStatistics();
                    DisableWarehouseStatistics();
                end;
            }
            action("View Warehouse Statistics")
            {
                ApplicationArea = All;
                Caption = 'View Warehouse Statistics';
                Image = Warehouse;

                trigger OnAction()
                begin
                    DisablePacketStatistics();
                    DisalebleSalesStatistics();
                    EnableWarehouseStatistics();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Pending, PendingCount, DummyBoolean);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Error, ErrorCount, DummyBoolean);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Failed, FailedCount, DummyBoolean);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Success, SuccessCount, DummyBoolean);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Pulls, PullsCount, DummyBoolean);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Pushes, PushesCount, DummyBoolean);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_SalesOrder, SalesOrdersCount, HasSalesOrders);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Invoices, SalesInvoicesCount, HasSalesInvoices);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_InvenotoryLoads, InventoryLoadsCount, HasInventoryLoads);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_InvenotoryUnloads, InventoryUnloadsCount, HasInventoryUnloads);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Payments, PaymentsCount, HasPayments);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_ReturnOrders, ReturnOrdersCount, HasReturnOrders);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_TruckInvenotoryReceive, TruckInventoryReceiveCount, HasTruckInventoryReceive);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_SalesQuotes, SalesQuotesCount, HasSalesQuotes);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_ReceiveInventory, ReceiveInventoryCount, HasReceiveInventory);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_BinMovements, BinMovementsCount, HasBinMovements);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_InboundTransfers, InboundTransfersCount, HasInboundTransfers);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_OutboundTransfers, OutboundTransfersCount, HasOutboundTransfers);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_ManualMovements, ManualMovementCount, HasManualMovement);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WarehouseLoads, WMSLoadsCount, HasWMSLoads);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WarehousePicks, WMSPicksCount, HasWMSPicks);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WarehousePutAways, WMSPutAwayCount, HasWMSPutAway);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WarehouseReceipts, WMSReceiptsCount, HasWMSReceipts);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WarehouseReceive, WMSReceiveCount, HasWMSReceive);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WMSMovements, WMSMovementsCount, HasWMSMovements);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_Shipments, ShipmentsCount, HasShipments);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_StockCount, StockCount, HasStockCount);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_BasicStockCounts, BasicStockCounts, HasBasicStockCounts);
        CheckStateVariable(Rec.Code, ConstMgt.RCS_WMSStockCounts, WMSStockCount, HasWMSStockCount);
    end;
    trigger OnOpenPage()
    begin
        EnablePacketStatistics();
        DisalebleSalesStatistics();
        DisableWarehouseStatistics();
    end;
    local procedure EnablePacketStatistics()
    begin
        EnabledError:=true;
        EnabledFailed:=true;
        EnabledSuccess:=true;
        EnabledPushes:=true;
        EnabledPulls:=true;
        EnabledPending:=true;
    end;
    local procedure DisablePacketStatistics()
    begin
        EnabledError:=false;
        EnabledFailed:=false;
        EnabledSuccess:=false;
        EnabledPushes:=false;
        EnabledPulls:=false;
        EnabledPending:=false;
    end;
    local procedure EnableSalesStatistics()
    begin
        VisibleSalesInvoices:=HasSalesInvoices;
        VisiblePayments:=HasPayments;
        VisibleReturnOrders:=HasReturnOrders;
        VisibleInventoryLoads:=HasInventoryLoads;
        VisibleInventoryUnloads:=HasInventoryUnloads;
        VisibleTruckInventoryReceive:=HasTruckInventoryReceive;
        VisibleReceiveInventory:=HasReceiveInventory;
        VisibleStockCount:=HasStockCount;
        VisibleSalesQuotes:=HasSalesQuotes;
        VisibleSalesOrders:=HasSalesOrders;
    end;
    local procedure DisalebleSalesStatistics()
    begin
        VisibleSalesInvoices:=false;
        VisiblePayments:=false;
        VisibleReturnOrders:=false;
        VisibleInventoryLoads:=false;
        VisibleInventoryUnloads:=false;
        VisibleTruckInventoryReceive:=false;
        VisibleReceiveInventory:=false;
        VisibleStockCount:=false;
        VisibleSalesQuotes:=false;
        VisibleSalesOrders:=false;
    end;
    local procedure EnableWarehouseStatistics()
    begin
        VisibleWMSReceive:=HasWMSReceive;
        VisibleShipments:=HasShipments;
        VisibleWMSReceipts:=HasWMSReceipts;
        VisibleWMSPutAway:=HasWMSPutAway;
        VisibleWMSMovements:=HasWMSMovements;
        VisibleManualMovement:=HasManualMovement;
        VisibleWMSPicks:=HasWMSPicks;
        VisibleWMSStockCount:=HasWMSStockCount;
        VisibleWMSLoads:=HasWMSLoads;
        VisibleBasicStockCounts:=HasBasicStockCounts;
        VisibleBinMovements:=HasBinMovements;
        VisibleOutboundTransfers:=HasOutboundTransfers;
        VisibleInboundTransfers:=HasInboundTransfers;
    end;
    local procedure DisableWarehouseStatistics()
    begin
        VisibleWMSReceive:=false;
        VisibleShipments:=false;
        VisibleWMSReceipts:=false;
        VisibleWMSPutAway:=false;
        VisibleWMSMovements:=false;
        VisibleManualMovement:=false;
        VisibleWMSPicks:=false;
        VisibleWMSStockCount:=false;
        VisibleWMSLoads:=false;
        VisibleBasicStockCounts:=false;
        VisibleBinMovements:=false;
        VisibleOutboundTransfers:=false;
        VisibleInboundTransfers:=false;
    end;
    local procedure CheckStateVariable(DeviceSetupCode: Code[100]; Operation: Text[100]; var OperationCount: Integer; var HasOperation: Boolean)
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    begin
        Clear(OperationCount);
        OperationCount:=LowLevelDP.Text2Integer(StateMgt.GetStateVar(DeviceSetupCode, Operation));
        if(OperationCount > 0)then HasOperation:=true;
    end;
    var ConstMgt: Codeunit DYM_ConstManagement;
    StateMgt: Codeunit DYM_StateManagement;
    DummyBoolean: Boolean;
    HasSalesInvoices, HasPayments, HasReturnOrders, HasInventoryLoads: Boolean;
    HasInventoryUnloads, HasTruckInventoryReceive, HasReceiveInventory, HasStockCount, HasSalesQuotes, HasSalesOrders: Boolean;
    HasWMSReceive, HasShipments, HasWMSReceipts, HasWMSPutAway, HasWMSMovements, HasManualMovement, HasWMSPicks, HasWMSStockCount, HasWMSLoads: Boolean;
    HasBasicStockCounts, HasBinMovements, HasOutboundTransfers, HasInboundTransfers: Boolean;
    VisibleSalesInvoices, VisiblePayments, VisibleReturnOrders, VisibleInventoryLoads: Boolean;
    VisibleInventoryUnloads, VisibleTruckInventoryReceive, VisibleReceiveInventory, VisibleStockCount, VisibleSalesQuotes, VisibleSalesOrders: Boolean;
    VisibleWMSReceive, VisibleShipments, VisibleWMSReceipts, VisibleWMSPutAway, VisibleWMSMovements, VisibleManualMovement, VisibleWMSPicks, VisibleWMSStockCount, VisibleWMSLoads: Boolean;
    VisibleBasicStockCounts, VisibleBinMovements, VisibleOutboundTransfers, VisibleInboundTransfers: Boolean;
    EnabledError, EnabledFailed, EnabledSuccess, EnabledPushes, EnabledPulls, EnabledPending: Boolean;
    SalesInvoicesCount, PaymentsCount, ReturnOrdersCount, InventoryLoadsCount: Integer;
    InventoryUnloadsCount, TruckInventoryReceiveCount, ReceiveInventoryCount, StockCount, SalesQuotesCount, SalesOrdersCount: Integer;
    WMSReceiveCount, ShipmentsCount, WMSReceiptsCount, WMSPutAwayCount, WMSMovementsCount, ManualMovementCount, WMSPicksCount, WMSStockCount, WMSLoadsCount: Integer;
    BasicStockCounts, BinMovementsCount, OutboundTransfersCount, InboundTransfersCount, ErrorCount, FailedCount, SuccessCount, PendingCount, PushesCount, PullsCount: Integer;
}
