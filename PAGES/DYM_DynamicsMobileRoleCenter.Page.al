page 70140 DYM_DynamicsMobileRoleCenter
{
    Caption = 'Dynamics Mobile Role Center';
    PageType = RoleCenter;
    SourceTable = DYM_DynamicsMobileSetup;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            /*
            group(Control23)
            {
                ShowCaption = false;
                part(Control25; DYM_RCSimpleWhseDocStats)
                {
                    ApplicationArea = All;
                    Caption = 'Simple Warehouse';
                }
                part("Advanced Warehouse"; DYM_RCAdvancedWhseDocStats)
                {
                    ApplicationArea = All;
                    Caption = 'Advanced Warehouse';
                }
            }
            */
            group(Statistics)
            {
                ShowCaption = false;

                part("General Statistics"; DYM_RCGeneralStats)
                {
                    ApplicationArea = All;
                    Caption = 'General Statistics';
                }
                part("Device Statistics"; DYM_RCDeviceStats)
                {
                    ApplicationArea = All;
                    Caption = 'Device Statistics';
                }
                /*
                    part(DYM_SyncLog; DYM_RCSyncLog)
                    {
                        ApplicationArea = All;
                        Caption = 'Sync Log';
                    }
                    */
            }
        }
    }
    actions
    {
        area(Sections)
        {
            group(Hierarchy)
            {
                Caption = 'Hierarchy';

                action(Roles)
                {
                    ApplicationArea = All;
                    Caption = 'Roles';
                    Image = Segment;
                    RunObject = Page DYM_DeviceRolesList;
                }
                action(Groups)
                {
                    ApplicationArea = All;
                    Caption = 'Groups';
                    Image = ExplodeBOM;
                    RunObject = Page DYM_DeviceGroupsList;
                }
                action(Devices)
                {
                    ApplicationArea = All;
                    Caption = 'Devices';
                    Image = Calculate;
                    RunObject = Page DYM_DeviceSetupsList;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';

                group(BasicDocuments)
                {
                    Caption = 'Basic Documents';

                    action(SalesQuotes)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Quotes';
                        Image = NewSalesQuote;
                        RunObject = Page "Sales Quotes";
                    }
                    action(SalesOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Orders';
                        Image = SalesInvoice;
                        RunObject = Page "Sales Order List";
                    }
                    action(SalesReturnOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Return Orders';
                        Image = ReturnOrder;
                        RunObject = Page "Sales Return Order List";
                    }
                    action(SalesInvoices)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Invoices';
                        Image = SalesTaxStatement;
                        RunObject = Page "Sales Invoice List";
                    }
                    action(SalesCreditMemos)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Credit Memos';
                        Image = CreditMemo;
                        RunObject = Page "Sales Credit Memos";
                    }
                    action(PurchaseOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Orders';
                        Image = Import;
                        RunObject = Page "Purchase Order List";
                    }
                    action(TransferOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Transfer Orders';
                        Image = CreateMovement;
                        RunObject = Page "Transfer Orders";
                    }
                    action(CashReceiptJournals)
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Receipt Journals';
                        Image = CashReceiptJournal;
                        RunObject = page "Cash Receipt Journal";
                    }
                    action(PhysInventoryJournals)
                    {
                        ApplicationArea = All;
                        Caption = 'Phys. Inventory Journals';
                        Image = PhysicalInventory;
                        RunObject = Page "Phys. Inventory Journal";
                    }
                    action(PhysInventoryOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Phys. Inventory Orders';
                        Image = InventoryJournal;
                        RunObject = Page "Physical Inventory Orders";
                    }
                }
                group(WMSInventory)
                {
                    caption = 'Inventory Documents';

                    action(InventoryShipments)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Shipments';
                        Image = PostInventoryToGL;
                        RunObject = Page "Invt. Shipments";
                    }
                    action(InventoryReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Receipts';
                        Image = ReceiveLoaner;
                        RunObject = Page "Invt. Receipts";
                    }
                    action(InventoryPicks)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Picks';
                        Image = RegisterPick;
                        RunObject = Page "Inventory Picks";
                    }
                    action(InventoryPutAways)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Put-aways';
                        Image = RegisterPutAway;
                        RunObject = Page "Inventory Put-aways";
                    }
                    action(InventoryMovements)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Movements';
                        Image = CreateMovement;
                        RunObject = Page "Inventory Movements";
                    }
                }
                group(WMSDocuments)
                {
                    Caption = 'WMS Documents';

                    action(WarehouseShipments)
                    {
                        ApplicationArea = All;
                        Caption = 'Warehouse Shipments';
                        Image = PostInventoryToGL;
                        RunObject = Page "Warehouse Shipment List";
                    }
                    action(WarehouseReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Warehouse Receipts';
                        Image = ReceiveLoaner;
                        RunObject = Page "Warehouse Receipts";
                    }
                    action(WarehousePicks)
                    {
                        ApplicationArea = All;
                        Caption = 'Warehouse Picks';
                        Image = RegisterPick;
                        RunObject = Page "Warehouse Picks";
                    }
                    action(WarehousePutAways)
                    {
                        ApplicationArea = All;
                        Caption = 'Warehouse Put-aways';
                        Image = RegisterPutAway;
                        RunObject = Page "Warehouse Put-aways";
                    }
                    action(WarehouseMovements)
                    {
                        ApplicationArea = All;
                        Caption = 'Warehouse Movements';
                        Image = CreateMovement;
                        RunObject = Page "Warehouse Movements";
                    }
                    action(WhsePhysInvtJournals)
                    {
                        ApplicationArea = All;
                        Caption = 'Whse. Phys. Invt. Journals';
                        Image = PhysicalInventory;
                        RunObject = Page "Whse. Phys. Invt. Journal";
                    }
                }
                group(Production)
                {
                    Caption = 'Production';

                    action(ReleasedProdOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Released Prod. Orders';
                        Image = Production;
                        RunObject = Page "Released Production Orders";
                    }
                    action(ConsumptionJournal)
                    {
                        ApplicationArea = All;
                        Caption = 'Consumption Journal';
                        Image = ConsumptionJournal;
                        RunObject = Page "Consumption Journal";
                    }
                    action(OutputJournal)
                    {
                        ApplicationArea = All;
                        Caption = 'Output Journal';
                        Image = OutputJournal;
                        RunObject = Page "Output Journal";
                    }
                }
                group(DocumentActions)
                {
                    Caption = 'Document Actions';

                    action(ReverseNavigate)
                    {
                        ApplicationArea = All;
                        Caption = 'Reverse Navigate';
                        Image = ReverseLines;
                        RunObject = Page DYM_ReverseNavigate;
                    }
                }
            }
            group(History)
            {
                Caption = 'History';

                group(HistoryBasic)
                {
                    Caption = 'Basic (History)';

                    action(PostedSalesShipments)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Sales Shipments';
                        Image = Shipment;
                        RunObject = Page "Posted Sales Shipments";
                    }
                    action(PostedSalesInvoices)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Sales Invoices';
                        Image = Invoice;
                        RunObject = Page "Posted Sales Invoices";
                    }
                    action(PostedSalesReturnReceipt)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Sales Return Receipt';
                        Image = ReturnReceipt;
                        RunObject = Page "Posted Return Receipts";
                    }
                    action(PostedSalesCrMemos)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Sales Credit Memos';
                        Image = CreditMemo;
                        RunObject = Page "Posted Sales Credit Memos";
                    }
                    action(PostedPurchaseReceipt)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Purchase Receipts';
                        Image = Receipt;
                        RunObject = Page "Posted Purchase Receipts";
                    }
                    action(PostedPurchaseInvoice)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Purchase Invoices';
                        Image = PurchaseInvoice;
                        RunObject = Page "Posted Purchase Invoices";
                    }
                    action(PostedTransferShipment)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Transfer Shipments';
                        RunObject = Page "Posted Transfer Shipments";
                    }
                    action(PostedTransferReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Transfer Receipts';
                        RunObject = Page "Posted Transfer Receipts";
                    }
                    action(PostedDirectTransfers)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Direct Transfers';
                        RunObject = Page "Posted Direct Transfers";
                    }
                    action(PostedPhysInvtOrders)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Phys. Invt. Orders';
                        RunObject = Page "Posted Phys. Invt. Order List";
                    }
                }
                group(HistoryWMSInventory)
                {
                    Caption = 'Inventory (History)';

                    action(PostedInvtShipments)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Invt. Shipments';
                        RunObject = Page "Posted Invt. Shipments";
                    }
                    action(PostedInvtReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Invt. Receipts';
                        RunObject = Page "Posted Invt. Receipts";
                    }
                    action(PostedInvtPicks)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Invt. Picks';
                        RunObject = Page "Posted Invt. Pick List";
                    }
                    action(PostedInvtPutAways)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Invt. Put-Aways';
                        RunObject = Page "Posted Invt. Put-away List";
                    }
                    action(PostedInvtMovements)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Invt. Movements';
                        RunObject = Page "Registered Invt. Movement List";
                    }
                }
                group(HistoryWMS)
                {
                    Caption = 'WMS (History)';

                    action(PostedWhseShipments)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Whse. Shipments';
                        RunObject = Page "Posted Whse. Shipment List";
                    }
                    action(PostedWhseReceipts)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Whse. Receipts';
                        RunObject = Page "Posted Whse. Receipt List";
                    }
                    action(RegisteredWhsePicks)
                    {
                        ApplicationArea = All;
                        Caption = 'Registered Whse. Picks';
                        RunObject = Page "Registered Whse. Picks";
                    }
                    action(RegisteredWhsePutAways)
                    {
                        ApplicationArea = All;
                        Caption = 'Registered Whse. Put-Aways';
                        RunObject = Page "Registered Whse. Put-aways";
                    }
                    action(RegisteredWhseMovements)
                    {
                        ApplicationArea = All;
                        Caption = 'Registered Whse. Movements';
                        RunObject = Page "Registered Whse. Movements";
                    }
                }
            }
            group(MasterData)
            {
                Caption = 'Master Data';

                action(Customers)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    Image = Customer;
                    RunObject = Page "Customer List";
                }
                action(Vendors)
                {
                    ApplicationArea = All;
                    Caption = 'Vendors';
                    Image = Vendor;
                    RunObject = Page "Vendor List";
                }
                action(Items)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = page "Item List";
                }
                action(Locations)
                {
                    ApplicationArea = All;
                    Caption = 'Locations';
                    Image = Warehouse;
                    RunObject = Page "Location List";
                    RunPageView = SORTING(Code);
                }
                action(BinContents)
                {
                    ApplicationArea = All;
                    Caption = 'Bin Contents';
                    Image = Warehouse;
                    RunObject = Page "Bin Contents";
                }
            }
            group(Activity)
            {
                Caption = 'Activity';

                action("Sync &Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Sync &Log Entries';
                    Image = LedgerEntries;
                    RunObject = Page DYM_SyncLogEntries;
                }
                action("Ra&w Data Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Ra&w Data Log Entries';
                    Image = ItemTrackingLedger;
                    RunObject = Page DYM_RawDataLogEntries;
                    RunPageView = SORTING("Entry No.");
                }
                action("E&vent Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'E&vent Log Entries';
                    Image = WarrantyLedger;
                    RunObject = Page DYM_EventLogEntries;
                    //RunPageView = SORTING("Entry No.");
                }
                action("&Data Log Entries")
                {
                    ApplicationArea = All;
                    Caption = '&Data Log Entries';
                    Image = VATLedger;
                    RunObject = Page DYM_DataLogEntries;
                    RunPageView = SORTING("Entry No.");
                }
                action("P&ost Process Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'P&ost Process Log Entries';
                    Image = CapacityLedger;
                    RunObject = Page DYM_PostProcessLogEntries;
                    //RunPageView = SORTING("Entry No.");
                }
                action("Record Link Enites")
                {
                    ApplicationArea = All;
                    Caption = 'Record Link Entries';
                    Image = Link;
                    RunObject = Page DYM_RecordLinkEntries;
                }
                action("RPC Log Enites")
                {
                    ApplicationArea = All;
                    Caption = 'RPC Log Enites';
                    Image = Link;
                    RunObject = Page DYM_RPCLog;
                }
                action("BLOB Store Entries")
                {
                    ApplicationArea = All;
                    Caption = 'BLOB Store Entries';
                    Image = BinContent;
                    RunObject = Page DYM_BLOBStoreList;
                }
                action("S&MS Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'S&MS Log Entries';
                    Image = CheckLedger;
                    RunObject = Page DYM_SMSEntries;
                    //RunPageView = SORTING("Entry No.");
                }
                action("Device Activity Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Device Activity Entries';
                    Image = CalculatePlan;
                    RunObject = Page DYM_DeviceActivity;
                    //RunPageView = SORTING("Entry No.");
                }
            }
            /*
            group(Periodic)
            {
                Caption = 'Periodic';
                action(DYM_OnDemandProcessing)
                {
                    ApplicationArea = All;
                    Caption = 'OnDemand Processing';
                    image = Start;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    RunObject = codeunit DYM_PacketManagement;
                }
            }
            */
            group(Setup)
            {
                Caption = 'Setup';

                group(Business)
                {
                    Caption = 'Business';

                    action(SkipReason)
                    {
                        ApplicationArea = All;
                        Caption = 'Skip Reasons';
                        RunObject = page DYM_VisitReasons;
                        RunPageView = sorting(Code);
                    }
                    action(ReturnReason)
                    {
                        ApplicationArea = All;
                        Caption = 'Return Reasons';
                        RunObject = page "Return Reasons";
                    }
                    action(MixAndMatchGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Mix and Match Group';
                        RunObject = page "DYM_MixAndMatchGroup";
                    }
                }
                group(Technical)
                {
                    Caption = 'Technical';

                    action(DynamicsMobileSetup)
                    {
                        ApplicationArea = All;
                        Caption = 'Dynamics Mobile Setup';
                        Image = Setup;
                        RunObject = Page DYM_DynamicsMobileSetup;
                    }
                    action(Settings)
                    {
                        ApplicationArea = All;
                        Caption = 'Settings';
                        Image = SetupList;
                        RunObject = Page DYM_SettingsList;
                    }
                    action(SettingsAssignment)
                    {
                        ApplicationArea = All;
                        Caption = 'Settings Assignment';
                        Image = SetupColumns;
                        RunObject = Page DYM_SettingsAssignment;
                    }
                    action(SettingsAssignmentOverview)
                    {
                        ApplicationArea = All;
                        Caption = 'Settings Assignment Overview';
                        Image = SetupColumns;
                        RunObject = Page DYM_SettingsAssignmentOverview;
                    }
                    action(CopySettingsAssignment)
                    {
                        ApplicationArea = All;
                        Caption = 'Copy Settings Assignment';
                        Image = SetupColumns;
                        RunObject = Page DYM_CopySettings;
                    }
                    action(SessionValues)
                    {
                        ApplicationArea = All;
                        Caption = 'Session Values';
                        Image = SuggestSalesPrice;
                        RunObject = Page DYM_SessionValuesList;
                        RunPageView = SORTING(Code);
                    }
                    action(StateVariables)
                    {
                        ApplicationArea = All;
                        Caption = 'State Variables';
                        Image = VariableList;
                        RunObject = Page DYM_StateVariables;
                        RunPageView = SORTING(Code);
                    }
                }
                group(System)
                {
                    Caption = 'System';

                    action(JobQueueEntries)
                    {
                        ApplicationArea = All;
                        Caption = 'Job Queue Entries';
                        Image = JobTimeSheet;
                        RunObject = page "Job Queue Entries";
                    }
                    action(BackupRestore)
                    {
                        ApplicationArea = All;
                        Caption = 'Backup/Restore';
                        Image = TestDatabase;
                        RunObject = page DYM_SettingsStorageEntries;
                    }
                    action(IntegrityModuleInfo)
                    {
                        ApplicationArea = All;
                        Caption = 'Integrity Modules Info';
                        Image = AssemblyBOM;
                        RunObject = page DYM_IntegrityModuleInfo;
                    }
                    action("Heart Beat Status")
                    {
                        ApplicationArea = All;
                        Caption = 'Heart Beat Status';
                        Image = History;
                        RunObject = Page DYM_HeartBeatStatus;
                    }
                }
            }
        }
    }
    var
        SetupIOMgt: Codeunit DYM_SetupIOManagement;
}
