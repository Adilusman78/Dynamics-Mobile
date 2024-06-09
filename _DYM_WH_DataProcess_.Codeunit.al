codeunit 84300 "DYM_WH_DataProcess"
{
    Permissions = TableData Customer=rimd,
        TableData "Sales Header"=rimd,
        TableData "Sales Line"=rimd,
        TableData "Purchase Header"=rimd,
        TableData "Purchase Line"=rimd,
        TableData "Gen. Journal Line"=rimd,
        TableData "Item Journal Line"=rimd,
        TableData "Line Number Buffer"=rimd,
        TableData "Reservation Entry"=rimd;

    trigger OnRun()
    begin
        PreProcess();
        PushProcessPurchDocs;
        PushProcessTransferDocs;
        PushProcessNewTransfer;
        PushProcessSalesDocs;
        PushProcessPhysInventory;
        PushProcessWhseReceipts;
        PushProcessWhseDocs;
        PushProcessWhseShipments;
        PushProcessWhseInvt;
        PushProcessProdOutput;
        PushProcessConsumption;
        PushProcessBarcode;
        PushProcessBin;
        PushProcessWhseJnlLine;
        PushProcessWhseTracking;
    end;
    var MobileSetup: Record DYM_DynamicsMobileSetup;
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
    UOMAssistMgt: Codeunit DYM_UOMAssistManagement;
    TrackAssistMgt: Codeunit DYM_TrackAssistManagement;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    PostProcessMgt: Codeunit DYM_PostProcessManagement;
    RecordLinkMgt: Codeunit DYM_RecordLinkManagement;
    SDSHandler: Codeunit DYM_SessionDataStoreHandler;
    WhseEventPub: Codeunit DYM_WH_EventPublishers;
    WHHelper: Codeunit DYM_WH_Helper;
    RecRef: RecordRef;
    SLE: Integer;
    SetupRead: Boolean;
    Text001: Label 'You cannot ship this document directly as location %1 requires Warehouse Shipment.';
    Text002: Label 'You cannot receive this document directly as location %1 requires Warehouse Receipt.';
    Text003: Label 'Setting [%1] value [%2] not supported.';
    Text004: Label 'Shipping of greater quantity than its defined in the document is not allowed';
    Text005: Label 'No Transfer Receipt tracking possible should be without relation to Reservation Entry.';
    Text006: Label 'The cross reference[%1] for item[%2] in unit of measure[%3] already exist';
    #region Tag definition
    //Stock Take Line
    T_StockTakeLine: Label 'ItemJournalLine', Locked = true;
    F_StockTakeLine_LineNo: Label 'lineNo', Locked = true;
    F_StockTakeLine_Advanced: Label 'advanced', Locked = true;
    F_StockTakeLine_Date: Label 'date', Locked = true;
    F_StockTakeLine_LocationCode: Label 'locationCode', Locked = true;
    F_StockTakeLine_ItemNo: Label 'itemNo', Locked = true;
    F_StockTakeLine_VariantCode: Label 'variantCode', Locked = true;
    F_StockTakeLine_Qty: Label 'mobileQtyToProcess', Locked = true;
    F_StockTakeLine_QtyCalc: Label 'qtyCalculated', Locked = true;
    F_StockTakeLine_QtyPhysInv: Label 'qtyPhysInventory', Locked = true;
    F_StockTakeLine_BinCode: Label 'mobileBin', Locked = true;
    F_StockTakeLine_UnitofMeasureCode: Label 'unitId', Locked = true;
    F_StockTakeLine_SerialNo: Label 'serialNo', Locked = true;
    F_StockTakeLine_LotNo: Label 'lotNo', Locked = true;
    F_StockTakeLine_PackageNo: Label 'packageNo', Locked = true;
    F_StockTakeLine_ExpirationDate: Label 'expirationDate', Locked = true;
    //Sales Header
    T_SalesHead: Label 'SalesHeader', Locked = true;
    F_SalesHead_DocumentType: Label 'DocumentType', Locked = true;
    F_SalesHead_No: Label 'No', Locked = true;
    F_SalesHead_ShiptoCode: Label 'ShiptoCode', Locked = true;
    F_SalesHead_OrderDate: Label 'OrderDate', Locked = true;
    O_SalesHead_DocumentType: Label '36,1', Locked = true;
    //Sales Line
    T_SalesLine: Label 'SalesLine', Locked = true;
    F_SalesLine_DocumentType: Label 'DocumentType', Locked = true;
    F_SalesLine_DocumentNo: Label 'DocumentNo', Locked = true;
    F_SalesLine_LineNo: Label 'LineNo', Locked = true;
    F_SalesLine_Type: Label 'Type', Locked = true;
    F_SalesLine_No: Label 'No', Locked = true;
    F_SalesLine_LocationCode: Label 'LocationCode', Locked = true;
    F_SalesLine_Quantity: Label 'Quantity', Locked = true;
    F_SalesLine_OutstandingQuantity: Label 'OutstandingQuantity', Locked = true;
    F_SalesLine_QuantityToShip: Label 'QtytoShip', Locked = true;
    F_SalesLine_UnitofMeasure: Label 'UnitofMeasureCode', Locked = true;
    O_SalesLine_DocumentType: Label '37,1', Locked = true;
    O_SalesLine_Type: Label '37,5', Locked = true;
    M_SalesLine_MobileStatus: Label '18,60,15,DYM_MobileStatus,DYM_MobileDevice', Locked = true;
    //Purchase Header
    T_PurchHead: Label 'PurchaseHeader', Locked = true;
    F_PurchHead_DocumentType: Label 'DocumentType', Locked = true;
    F_PurchHead_No: Label 'No', Locked = true;
    F_PurchHead_BuyFromVendorCode: Label 'BuyFromVendorCode', Locked = true;
    F_PurchHead_PayToVendorCode: Label 'PayToVendorCode', Locked = true;
    O_PurchHead_DocumentType: Label '38,1', Locked = true;
    //Purchase Line
    T_PurchaseLine: Label 'PurchaseLine', Locked = true;
    F_PurchLine_DocumentType: Label 'DocumentType', Locked = true;
    F_PurchLine_DocumentNo: Label 'DocumentNo', Locked = true;
    F_PurchLine_LineNo: Label 'LineNo', Locked = true;
    F_PurchLine_LineType: Label 'LineType', Locked = true;
    F_PurchLine_ItemNo: Label 'No', Locked = true;
    F_PurchLine_Quantity: Label 'Quantity', Locked = true;
    F_PurchLine_QuantityToReceive: Label 'QtytoReceive', Locked = true;
    F_PurchLine_UnitofMeasureCode: Label 'UnitofMeasureCode', Locked = true;
    O_PurchLine_DocumentType: Label '39,1', Locked = true;
    O_PurchLine_LineType: Label '39,5', Locked = true;
    M_PurchLine_MobileStatus: Label '18,60,15,DYM_MobileStatus,DYM_MobileDevice', Locked = true;
    //Warehouse Activity Header
    T_WhseActHead: Label 'WarehouseActivityHeader', Locked = true;
    F_WhseActHead_Type: Label 'Type', Locked = true;
    F_WhseActHead_No: Label 'No', Locked = true;
    F_WhseActHead_LocationCode: Label 'LocationCode', Locked = true;
    O_WhseActHead_Type: Label '5766,1', Locked = true;
    //Warehouse Activity Line
    T_WhseActLine: Label 'WarehouseActivityLine', Locked = true;
    F_WhseActLine_ActivityType: Label 'ActivityType', Locked = true;
    F_WhseActLine_No: Label 'No', Locked = true;
    F_WhseActLine_LineNo: Label 'LineNo', Locked = true;
    F_WhseActLine_ItemNo: Label 'ItemNo', Locked = true;
    F_WhseActLine_VariantCode: Label 'VariantCode', Locked = true;
    F_WhseActLine_UnitOfMeasureCode: Label 'UnitofMeasureCode', Locked = true;
    F_WhseActLine_Quantity: Label 'Quantity', Locked = true;
    F_WhseActLine_QuantityToHandle: Label 'QtytoHandle', Locked = true;
    F_WhseActLine_QuantityHandled: Label 'QtyHandled', Locked = true;
    F_WhseActLine_LotNo: Label 'LotNo', Locked = true;
    F_WhseActLine_LocationCode: Label 'LocationCode', Locked = true;
    F_WhseActLine_BinCode: Label 'BinCode', Locked = true;
    F_WhseActLine_ActionType: Label 'ActionType', Locked = true;
    F_WhseActLine_ParentLineNo: Label 'parentLineNo', Locked = true;
    F_WhseActLine_Breakbulk: Label 'isSplitted', Locked = true;
    O_WhseActLine_ActivityType: Label '5767,1', Locked = true;
    O_WhseActLine_ActionType: Label '5767,7305', Locked = true;
    M_WhseActLine_MobileStatus: Label '27,29,21,DYM_MobileStatus,DYM_MobileDevice', Locked = true;
    //Transfer Header
    T_TransHead: Label 'TransferHeader', Locked = true;
    F_TransHead_No: Label 'No', Locked = true;
    F_TransHead_TransferFromCode: Label 'TransferfromCode', Locked = true;
    F_TransHead_TransferToCode: Label 'TransfertoCode', Locked = true;
    F_TransHead_IsInbound: Label 'PostingfromWhseRef', Locked = true;
    F_TransHead_IsFinished: Label 'isFinished', Locked = true;
    F_TransHead_IsNewTransfer: Label 'newTransfer', Locked = true;
    O_TransHead_IsInbound_Outbound: Label '0', Locked = true;
    O_TransHead_IsInbound_Inbound: Label '1', Locked = true;
    //Transfer Line
    T_TransLine: Label 'TransferLine', Locked = true;
    F_TransLine_DocumentNo: Label 'DocumentNo', Locked = true;
    F_TransLine_LineNo: Label 'LineNo', Locked = true;
    F_TransLine_ItemNo: Label 'ItemNo', Locked = true;
    F_TransLine_Quantity: Label 'mobileQtyToProcess', Locked = true;
    F_TransLine_QuantityToShip: Label 'QtytoShip', Locked = true;
    F_TransLine_QtyToReceive: Label 'QtytoReceive', Locked = true;
    F_TransLine_UnitofMeasureCode: Label 'UnitofMeasureCode', Locked = true;
    F_TransLine_DerivedFromLineNo: Label 'DerivedFromLineNo', Locked = true;
    F_TransLine_IsNewTransfer: Label 'newTransfer', Locked = true;
    M_TransLine_Ship_MobileStatus: Label '6,0,24,DYM_MobileShipStatus,DYM_MobileDevice', Locked = true;
    M_TransLine_Recv_MobileStatus: Label '7,0,34,DYM_MobileReceiveStatus,DYM_MobileDevice', Locked = true;
    //Warehouse Shipment Header
    T_WhseShipHead: Label 'WarehouseShipmentHeader', Locked = true;
    F_WhseShipHead_No: Label 'No', Locked = true;
    F_WhseShipHead_LocationCode: Label 'LocationCode', Locked = true;
    //Warehouse Shipment Line
    T_WhseShipLine: Label 'WarehouseShipmentLine', Locked = true;
    F_WhseShipLine_No: Label 'No', Locked = true;
    F_WhseShipLine_LineNo: Label 'LineNo', Locked = true;
    F_WhseShipLine_SourceType: Label 'SourceType', Locked = true;
    F_WhseShipLine_SourceNo: Label 'SourceNo', Locked = true;
    F_WhseShipLine_SourceDocument: Label 'SourceDocument', Locked = true;
    F_WhseShipLine_SourceLineNo: Label 'SourceLineNo', Locked = true;
    F_WhseShipLine_LocationCode: Label 'LocationCode', Locked = true;
    F_WhseShipLine_BinCode: Label 'BinCode', Locked = true;
    F_WhseShipLine_ItemNo: Label 'ItemNo', Locked = true;
    F_WhseShipLine_QuantityToShip: Label 'QuantityToShip', Locked = true;
    F_WhseShipLine_UnitOfMeasureCode: Label 'UnitOfMeasureCode', Locked = true;
    M_WhseShipLine_MobileStatus: Label '21,0,19,DYM_MobileStatus,DYM_MobileDevice', Locked = true;
    //Warehouse Receipt Header
    T_WhseRcptHead: Label 'WarehouseReceiptHeader', Locked = true;
    F_WhseRcptHead_No: Label 'No', Locked = true;
    F_WhseRcptHead_LocationCode: Label 'LocationCode', Locked = true;
    F_WhseRcptHead_VendorShipmentNo: Label 'VendorShipmentNo', Locked = true;
    //Warehouse Receipt Line
    T_WhseRcptLine: Label 'WarehouseReceiptLine', Locked = true;
    F_WhseRcptLine_No: Label 'No', Locked = true;
    F_WhseRcptLine_LineNo: Label 'LineNo', Locked = true;
    F_WhseRcptLine_SourceType: Label 'SourceType', Locked = true;
    F_WhseRcptLine_SourceSubtype: Label 'SourceSubtype', Locked = true;
    F_WhseRcptLine_SourceNo: Label 'SourceNo', Locked = true;
    F_WhseRcptLine_SourceDocument: Label 'SourceDocument', Locked = true;
    F_WhseRcptLine_LocationCode: Label 'LocationCode', Locked = true;
    F_WhseRcptLine_BinCode: Label 'BinCode', Locked = true;
    F_WhseRcptLine_ItemNo: Label 'ItemNo', Locked = true;
    F_WhseRcptLine_QuantityToReceive: Label 'QuantityToReceive', Locked = true;
    F_WhseRcptLine_UnitOfMeasureCode: Label 'UnitOfMeasureCode', Locked = true;
    M_WhseRcptLine_MobileStatus: Label '21,0,19,DYM_MobileStatus,DYM_MobileDevice', Locked = true;
    //Tracking Specification
    T_TrackSpec: Label 'ReservationEntry', Locked = true;
    F_TrackSpec_EntryNo: Label 'EntryNo', Locked = true;
    F_TrackSpec_Positive: Label 'Positive', Locked = true;
    F_TrackSpec_SourceType: Label 'SourceType', Locked = true;
    F_TrackSpec_SourceSubtype: Label 'SourceSubtype', Locked = true;
    F_TrackSpec_SourceID: Label 'SourceID', Locked = true;
    F_TrackSpec_SourceBatchName: Label 'SourceBatchName', Locked = true;
    F_TrackSpec_SourceProdOrderLine: Label 'SourceProdOrderLine', Locked = true;
    F_TrackSpec_SourceRefNo: Label 'SourceRefNo', Locked = true;
    F_TrackSpec_ItemNo: Label 'ItemNo', Locked = true;
    F_TrackSpec_VariantCode: Label 'VariantCode', Locked = true;
    F_TrackSpec_QuantityBase: Label 'QuantityBase', Locked = true;
    F_TrackSpec_Quantity: Label 'Quantity', Locked = true;
    F_TrackSpec_SerialNo: Label 'SerialNo', Locked = true;
    F_TrackSpec_LotNo: Label 'LotNo', Locked = true;
    F_TrackSpec_PackageNo: Label 'PackageNo', Locked = true;
    F_TrackSpec_ExpirationDate: Label 'ExpirationDate', Locked = true;
    F_TrackSpec_Correction: Label 'Correction', Locked = true;
    //Document Status - Obsolete
    T_DocStatus: Label 'DocStatus', Locked = true;
    F_DocStatus_DocType: Label 'DocType', Locked = true;
    F_DocStatus_DocSubType: Label 'DocSubType', Locked = true;
    F_DocStatus_DocNo: Label 'DocNo', Locked = true;
    F_DocStatus_LineNo: Label 'LineNo', Locked = true;
    F_DocStatus_Status: Label 'Status', Locked = true;
    T_Activity: Label 'Activity', Locked = true;
    F_Activity_Action: Label 'action', Locked = true;
    //Cross Refference
    T_CrossRef: Label 'CrossRef', Locked = true;
    F_CrossRef_CrossReferenceNo: Label 'crossReferenceNo', Locked = true;
    F_CrossRef_ItemNo: Label 'itemNo', Locked = true;
    F_CrossRef_UnitOfMeasure: Label 'unitOfMeasure', Locked = true;
    //ProdOrder
    T_ProdOrder: Label 'ProdOrders', Locked = true;
    F_ProdOrder_No: Label 'no', Locked = true;
    F_ProdOrder_LocationCode: Label 'locationCode', Locked = true;
    //ProdOrderLines
    T_ProdOrderLines: Label 'ProdOrderLines', Locked = true;
    F_ProdOrderLines_ProdOrderStatus: Label 'status', Locked = true;
    O_ProdOrderLines_ProdOrderStatus: Label '5406,1', Locked = true;
    F_ProdOrderLines_ProdOrderNo: Label 'prodOrderNo', Locked = true;
    F_ProdOrderLines_LineNo: Label 'lineNo', Locked = true;
    F_ProdOrderLines_ItemNo: Label 'itemNo', Locked = true;
    F_ProdOrderLines_QtyToProcess: Label 'mobileQtyToProcess', Locked = true;
    F_ProdOrderLines_OperationNo: Label 'operationNo', Locked = true;
    //ProdOrderComponents
    T_ProdOrderComp: Label 'ProdOrderComponents', Locked = true;
    F_ProdOrderComp_ProdOrderStatus: Label 'auxiliaryIndex1', Locked = true;
    O_ProdOrderComp_ProdOrderStatus: Label '5407,1', Locked = true;
    F_ProdOrderComp_ProdOrderNo: Label 'prodOrderNo', Locked = true;
    F_ProdOrderComp_ProdOrderLineNo: Label 'prodOrderLineNo', Locked = true;
    F_ProdOrderComp_LineNo: Label 'lineNo', Locked = true;
    F_ProdOrderComp_LocationCode: Label 'locationCode', Locked = true;
    F_ProdOrderComp_ItemNo: Label 'itemNo', Locked = true;
    F_ProdOrderComp_UOMCode: Label 'unitOfMeasureCode', Locked = true;
    F_ProdOrderComp_QtyToProcess: Label 'mobileQtyToProcess', Locked = true;
    F_ProdOrderComp_IsCustomAdded: Label 'isCustomAdded', Locked = true;
    //Bin
    T_Bin: Label 'Bin', Locked = true;
    F_Bin_LocationCode: Label 'locationCode', Locked = true;
    F_Bin_Code: Label 'code', Locked = true;
    F_Bin_BlockMovement: Label 'blockMovementNew', Locked = true;
    O_Bin_BlockMovement: Label '7354,12', Locked = true;
    //WhseJnlLine
    T_WhseJnlLine: Label 'WhseJnlLine', Locked = true;
    F_WhseJnlLine_ItemNo: Label 'itemNo', Locked = true;
    F_WhseJnlLine_VariantCode: Label 'variantCode', Locked = true;
    F_WhseJnlLine_LocationCode: Label 'locationCode', Locked = true;
    F_WhseJnlLine_ZoneCode: Label 'zoneCode', Locked = true;
    F_WhseJnlLine_BinCode: Label 'binCode', Locked = true;
    F_WhseJnlLine_Quantity: Label 'quantity', Locked = true;
    F_WhseJnlLine_QtyBase: Label 'qtyBase', Locked = true;
    F_WhseJnlLine_UOMCode: Label 'unitOfMeasureCode', Locked = true;
    F_WhseJnlLine_SerialNo: Label 'serialNo', Locked = true;
    F_WhseJnlLine_LotNo: Label 'lotNo', Locked = true;
    F_WhseJnlLine_PackageNo: Label 'packageNo', Locked = true;
    F_WhseJnlLine_ExpirationDate: Label 'expirationDate', Locked = true;
    F_WhseJnlLine_CorrectionType: Label 'correctionType', Locked = true;
    O_WhseJnlLine_CorrectionType_Negative: Label 'Negative', Locked = true;
    O_WhseJnlLine_CorrectionType_Positive: Label 'Positive', Locked = true;
    #endregion 
    #region Push
    procedure PreProcess()
    var
        ar_Activity: Codeunit DYM_ActiveRecManagement;
        ISHandled: Boolean;
        ActivityAction: Enum DYM_WH_ActivityAction;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(IsHandled);
        WhseEventPub.OnProcessOperationHint(IsHandled);
        if IsHandled then exit;
        CacheMgt.SetOperationHint('');
        ar_Activity.ReadTable(T_Activity);
        if ar_Activity.FindRecord then begin
            ActivityAction:=Enum::DYM_WH_ActivityAction.FromInteger(ar_Activity.IntegerField(F_Activity_Action));
            CacheMgt.SetOperationHint(Format(ActivityAction));
        end;
    end;
    procedure PushProcessSalesDocs()
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        Location: Record Location;
        Item: Record Item;
        ar_SalesHead: Codeunit DYM_ActiveRecManagement;
        ar_SalesLines: Codeunit DYM_ActiveRecManagement;
        isHandled, FullyProcessed: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_SalesHead.ReadTable(T_SalesHead)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessSales(IsHandled);
        if IsHandled then exit;
        ar_SalesHead.ReadTable(T_SalesHead);
        if ar_SalesHead.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_SalesHead.GetTableName(), ar_SalesHead.ActiveRecPK2Text());
                if SalesHeader.Get(SalesHeader."Document Type"::Order, ar_SalesHead.TextField(F_SalesHead_No))then begin
                    SalesHeader.LockTable;
                    //EK
                    //FullyProcessed := true;
                    ar_SalesLines.ReadTable(T_SalesLine);
                    ar_SalesLines.SetFieldFilter(F_SalesLine_DocumentType, ar_SalesHead.TextField(F_SalesHead_DocumentType));
                    ar_SalesLines.SetFieldFilter(F_SalesLine_DocumentNo, ar_SalesHead.TextField(F_SalesHead_No));
                    if ar_SalesLines.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_SalesLines.GetTableName(), ar_SalesLines.ActiveRecPK2Text());
                            if SalesLines.Get(SalesHeader."Document Type", SalesHeader."No.", ar_SalesLines.IntegerField(F_SalesLine_LineNo))then begin
                                Location.Get(SalesLines."Location Code");
                                if Location."Require Shipment" then Error(Text001, SalesLines."Location Code");
                                SalesLines.TestField(Type, SalesLines.Type::Item);
                                SalesLines.TestField("No.", ar_SalesLines.TextField(F_SalesLine_No));
                                SalesLines.TestField("Location Code", ar_SalesLines.TextField(F_SalesLine_LocationCode));
                                SalesLines.TestField("Unit of Measure Code", ar_SalesLines.TextField(F_SalesLine_UnitofMeasure));
                                SalesLines.TestField(Quantity, ar_SalesLines.DecimalField(F_SalesLine_Quantity));
                                if(ar_SalesLines.DecimalField(F_SalesLine_QuantityToShip) <> 0)then begin
                                    if(ar_SalesLines.DecimalField(F_SalesLine_QuantityToShip) + SalesLines."Qty. to Ship") > SalesLines."Outstanding Quantity" then begin
                                        if(SettingsMgt.GetSetting(ConstMgt.BOS_whAllowConfirmGreaterQtyInShip) = '1')then begin
                                            SalesLines.Validate(Quantity, (SalesLines.Quantity + (ar_SalesLines.DecimalField(F_TransLine_QuantityToShip) + SalesLines."Qty. to Ship" - SalesLines."Outstanding Quantity")));
                                            SalesLines.Validate("Qty. to Ship", SalesLines."Outstanding Quantity");
                                        end
                                        else
                                            error(text004);
                                    end
                                    else
                                        SalesLines.Validate("Qty. to Ship", SalesLines."Qty. to Ship" + ar_SalesLines.DecimalField(F_SalesLine_QuantityToShip));
                                    SalesLines.Modify;
                                end;
                                RecRef.GetTable(SalesLines);
                                DataLogMgt.LogDataOp_Modify(RecRef);
                            end;
                        until not ar_SalesLines.NextRecord;
                    WHHelper.UpdateDocumentMobileStatus(SalesHeader, M_SalesLine_MobileStatus);
                    RecRef.GetTable(SalesHeader);
                    DataLogMgt.LogDataOp_Modify(RecRef);
                end;
            until not ar_SalesHead.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessPurchDocs()
    var
        PurchHeader: Record "Purchase Header";
        PurchLines: Record "Purchase Line";
        Location: Record Location;
        Item: Record Item;
        ar_PurchHead: Codeunit DYM_ActiveRecManagement;
        ar_PurchLines: Codeunit DYM_ActiveRecManagement;
        IsHandled, FullyProcessed: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_PurchHead.ReadTable(T_PurchHead)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessPurchases(IsHandled);
        if IsHandled then exit;
        ar_PurchHead.ReadTable(T_PurchHead);
        if ar_PurchHead.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_PurchHead.GetTableName(), ar_PurchHead.ActiveRecPK2Text());
                if PurchHeader.Get(PurchHeader."Document Type"::Order, ar_PurchHead.TextField(F_PurchHead_No))then begin
                    PurchHeader.LockTable;
                    //EK MASTDBC
                    /*
                    FullyProcessed := true;
                    PurchHeader.TestField("Buy-from Vendor No.", ar_PurchHead.TextField(F_PurchHead_BuyFromVendorCode));
                    PurchHeader.TestField("Pay-to Vendor No.", ar_PurchHead.TextField(F_PurchHead_PayToVendorCode));
                    */
                    ar_PurchLines.ReadTable(T_PurchaseLine);
                    ar_PurchLines.SetFieldFilter(F_PurchLine_DocumentType, ar_PurchHead.TextField(F_PurchHead_DocumentType));
                    ar_PurchLines.SetFieldFilter(F_PurchLine_DocumentNo, ar_PurchHead.TextField(F_PurchHead_No));
                    if ar_PurchLines.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_PurchLines.GetTableName(), ar_PurchLines.ActiveRecPK2Text());
                            if PurchLines.Get(PurchHeader."Document Type", PurchHeader."No.", ar_PurchLines.IntegerField(F_PurchLine_LineNo))then begin
                                Location.Get(PurchLines."Location Code");
                                if Location."Require Receive" then Error(Text002, PurchLines."Location Code");
                                PurchLines.LockTable;
                                PurchLines.TestField(Type, PurchLines.Type::Item);
                                PurchLines.TestField("No.", ar_PurchLines.TextField(F_PurchLine_ItemNo));
                                if(PurchLines."Qty. to Receive" + ar_PurchLines.DecimalField(F_PurchLine_QuantityToReceive) > PurchLines.Quantity)then PurchLines.Validate(Quantity, PurchLines."Qty. to Receive" + ar_PurchLines.DecimalField(F_PurchLine_QuantityToReceive));
                                if(ar_PurchLines.DecimalField(F_PurchLine_QuantityToReceive) <> 0)then begin
                                    PurchLines.Validate("Qty. to Receive", PurchLines."Qty. to Receive" + ar_PurchLines.DecimalField(F_PurchLine_QuantityToReceive));
                                    PurchLines.Modify;
                                end;
                                RecRef.GetTable(PurchLines);
                                DataLogMgt.LogDataOp_Modify(RecRef);
                            end;
                        until not ar_PurchLines.NextRecord;
                    WHHelper.UpdateDocumentMobileStatus(PurchHeader, M_PurchLine_MobileStatus);
                    RecRef.GetTable(PurchHeader);
                    DataLogMgt.LogDataOp_Modify(RecRef);
                end;
            until not ar_PurchHead.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessWhseDocs()
    var
        LastMasterWhseActHeader: Record "Warehouse Activity Header";
        MasterWhseActHeader: Record "Warehouse Activity Header";
        MasterWhseActLine: Record "Warehouse Activity Line";
        SlaveWhseActLine: Record "Warehouse Activity Line";
        SplitWhseActLine: Record "Warehouse Activity Line";
        Bin: Record Bin;
        ar_WhseActHeader: Codeunit DYM_ActiveRecManagement;
        ar_WhseActLine: Codeunit DYM_ActiveRecManagement;
        FullyProcessed: Boolean;
        ActionTaken: Boolean;
        ManualMoveHeaderCreated: Boolean;
        MovementRequestHeaderCreated: Boolean;
        LineRetrieved: Boolean;
        IsHandled: Boolean;
        NextLine: Integer;
        SplitLineNo: Integer;
        MasterOutstandingQty: Decimal;
        SlaveLineFindMethod: Text;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_WhseActLine.ReadTable(T_WhseActLine)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessWhseDocs(IsHandled);
        if IsHandled then exit;
        clear(ManualMoveHeaderCreated);
        clear(MovementRequestHeaderCreated);
        Clear(LastMasterWhseActHeader);
        Clear(ActionTaken);
        FullyProcessed:=true;
        ar_WhseActLine.ReadTable(T_WhseActLine);
        ar_WhseActLine.SetFieldFilter(F_WhseActLine_QuantityToHandle, '<>0');
        if ar_WhseActLine.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_WhseActLine.GetTableName(), ar_WhseActLine.ActiveRecPK2Text());
                case(ar_WhseActLine.IntegerField(F_WhseActLine_ActivityType))of 12: //Create Manual Move
 begin
                    if not ManualMoveHeaderCreated then begin
                        MasterWhseActHeader.Init;
                        MasterWhseActHeader.Validate(Type, MasterWhseActHeader.Type::Movement);
                        //MasterWhseActHeader.Validate("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_WhseLocationCode));
                        MasterWhseActHeader.Validate("Location Code", ar_WhseActLine.TextField(F_WhseActLine_LocationCode));
                        Clear(MasterWhseActHeader."No.");
                        MasterWhseActHeader.Insert(true);
                        ManualMoveHeaderCreated:=true;
                        Clear(NextLine);
                        LastMasterWhseActHeader:=MasterWhseActHeader;
                        RecRef.GetTable(MasterWhseActHeader);
                        DataLogMgt.LogDataOp_Create(RecRef);
                    end;
                    NextLine+=10000;
                    MasterWhseActLine.Init;
                    MasterWhseActLine.Validate("Activity Type", MasterWhseActHeader.Type);
                    MasterWhseActLine.Validate("No.", MasterWhseActHeader."No.");
                    MasterWhseActLine.Validate("Line No.", NextLine);
                    MasterWhseActLine.Validate("Location Code", MasterWhseActHeader."Location Code");
                    MasterWhseActLine.Insert(true);
                    MasterWhseActLine.Validate("Action Type", ar_WhseActLine.OptionField(F_WhseActLine_ActionType, O_WhseActLine_ActionType));
                    MasterWhseActLine.Validate("Item No.", ar_WhseActLine.TextField(F_WhseActLine_ItemNo));
                    MasterWhseActLine.Validate("Unit of Measure Code", ar_WhseActLine.TextField(F_WhseActLine_UnitOfMeasureCode));
                    MasterWhseActLine.Validate("Bin Code", ar_WhseActLine.TextField(F_WhseActLine_BinCode));
                    MasterWhseActLine.Validate(Quantity, ar_WhseActLine.DecimalField(F_WhseActLine_QuantityToHandle));
                    MasterWhseActLine.Validate("Variant Code", ar_WhseActLine.TextField(F_WhseActLine_VariantCode));
                    MasterWhseActLine.Validate("Lot No.", ar_WhseActLine.TextField(F_WhseActLine_LotNo));
                    MasterWhseActLine.Validate("Expiration Date", TrackAssistMgt.GetLotExpirationDate(ar_WhseActLine.TextField(F_WhseActLine_ItemNo), MasterWhseActHeader."Location Code", ar_WhseActLine.TextField(F_WhseActLine_LotNo)));
                    MasterWhseActLine.Modify(true);
                    ActionTaken:=true;
                    RecRef.GetTable(MasterWhseActLine);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
                13: //Movement request
 begin
                    if not MovementRequestHeaderCreated then begin
                        MasterWhseActHeader.Init;
                        MasterWhseActHeader.Validate(Type, MasterWhseActHeader.Type::Movement);
                        //MasterWhseActHeader.Validate("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_WhseLocationCode));
                        MasterWhseActHeader.Validate("Location Code", ar_WhseActLine.TextField(F_WhseActLine_LocationCode));
                        Clear(MasterWhseActHeader."No.");
                        MasterWhseActHeader.Insert(true);
                        MovementRequestHeaderCreated:=true;
                        Clear(NextLine);
                        LastMasterWhseActHeader:=MasterWhseActHeader;
                        RecRef.GetTable(MasterWhseActHeader);
                        DataLogMgt.LogDataOp_Create(RecRef);
                    end;
                    //Take
                    NextLine+=10000;
                    MasterWhseActLine.Init;
                    MasterWhseActLine.Validate("Activity Type", MasterWhseActHeader.Type);
                    MasterWhseActLine.Validate("No.", MasterWhseActHeader."No.");
                    MasterWhseActLine.Validate("Line No.", NextLine);
                    MasterWhseActLine.Validate("Location Code", MasterWhseActHeader."Location Code");
                    MasterWhseActLine.Insert(true);
                    MasterWhseActLine.Validate("Action Type", ar_WhseActLine.OptionField(F_WhseActLine_ActionType, O_WhseActLine_ActionType));
                    MasterWhseActLine.Validate("Item No.", ar_WhseActLine.TextField(F_WhseActLine_ItemNo));
                    MasterWhseActLine.Validate("Unit of Measure Code", ar_WhseActLine.TextField(F_WhseActLine_UnitOfMeasureCode));
                    MasterWhseActLine.Validate("Bin Code", ar_WhseActLine.TextField(F_WhseActLine_BinCode));
                    MasterWhseActLine.Validate(Quantity, ar_WhseActLine.DecimalField(F_WhseActLine_Quantity));
                    MasterWhseActLine.Validate("Lot No.", ar_WhseActLine.TextField(F_WhseActLine_LotNo));
                    MasterWhseActLine.Validate("Expiration Date", TrackAssistMgt.GetLotExpirationDate(ar_WhseActLine.TextField(F_WhseActLine_ItemNo), MasterWhseActHeader."Location Code", ar_WhseActLine.TextField(F_WhseActLine_LotNo)));
                    MasterWhseActLine.Validate("Qty. to Handle", 0);
                    MasterWhseActLine.Modify(true);
                    RecRef.GetTable(MasterWhseActLine);
                    DataLogMgt.LogDataOp_Create(RecRef);
                    //Place
                    NextLine+=10000;
                    MasterWhseActLine.Init;
                    MasterWhseActLine.Validate("Activity Type", MasterWhseActHeader.Type);
                    MasterWhseActLine.Validate("No.", MasterWhseActHeader."No.");
                    MasterWhseActLine.Validate("Line No.", NextLine);
                    MasterWhseActLine.Validate("Location Code", MasterWhseActHeader."Location Code");
                    MasterWhseActLine.Insert(true);
                    MasterWhseActLine.Validate("Action Type", MasterWhseActLine."Action Type"::Place);
                    MasterWhseActLine.Validate("Item No.", ar_WhseActLine.TextField(F_WhseActLine_ItemNo));
                    MasterWhseActLine.Validate("Unit of Measure Code", ar_WhseActLine.TextField(F_WhseActLine_UnitOfMeasureCode));
                    MasterWhseActLine.Validate(Quantity, ar_WhseActLine.DecimalField(F_WhseActLine_Quantity));
                    MasterWhseActLine.Validate("Lot No.", ar_WhseActLine.TextField(F_WhseActLine_LotNo));
                    MasterWhseActLine.Validate("Expiration Date", TrackAssistMgt.GetLotExpirationDate(ar_WhseActLine.TextField(F_WhseActLine_ItemNo), MasterWhseActHeader."Location Code", ar_WhseActLine.TextField(F_WhseActLine_LotNo)));
                    MasterWhseActLine.Validate("Qty. to Handle", 0);
                    MasterWhseActLine.Modify(true);
                    clear(ActionTaken); //Does not set Mobile Status
                    RecRef.GetTable(MasterWhseActLine);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
                else
                begin //Default handler
                    Clear(MasterOutstandingQty);
                    case ar_WhseActLine.BooleanField(F_WhseActLine_Breakbulk)of false: MasterWhseActLine.Get(ar_WhseActLine.OptionField(F_WhseActLine_ActivityType, '5767,1'), ar_WhseActLine.TextField(F_WhseActHead_No), ar_WhseActLine.IntegerField(F_WhseActLine_LineNo));
                    true: MasterWhseActLine.Get(ar_WhseActLine.OptionField(F_WhseActLine_ActivityType, '5767,1'), ar_WhseActLine.TextField(F_WhseActLine_No), ar_WhseActLine.IntegerField(F_WhseActLine_ParentLineNo));
                    end;
                    MasterOutstandingQty:=MasterWhseActLine."Qty. Outstanding";
                    if(MasterWhseActLine."Qty. Outstanding" <> ar_WhseActLine.DecimalField(F_WhseActLine_QuantityToHandle))then begin
                        Clear(SplitLineNo);
                        MasterWhseActLine.Validate("Qty. to Handle", MasterWhseActLine."Qty. Outstanding" - ar_WhseActLine.DecimalField(F_WhseActLine_QuantityToHandle));
                        SplitWhseActLine.Copy(MasterWhseActLine);
                        MasterWhseActLine.SplitLine(SplitWhseActLine);
                        SplitLineNo:=SDSHandler.WAL_Split_Pop(SplitWhseActLine);
                        MasterWhseActLine.Get(MasterWhseActLine."Activity Type", MasterWhseActLine."No.", MasterWhseActLine."Line No.");
                        MasterWhseActLine.Validate("Qty. to Handle", 0);
                        MasterWhseActLine.Modify;
                        SplitWhseActLine.Get(ar_WhseActLine.OptionField(F_WhseActLine_ActivityType, O_WhseActLine_ActivityType), ar_WhseActLine.TextField(F_WhseActHead_No), SplitLineNo);
                    end
                    else
                        SplitWhseActLine.Get(MasterWhseActLine."Activity Type", MasterWhseActLine."No.", MasterWhseActLine."Line No.");
                    SplitWhseActLine.Validate("Qty. to Handle", ar_WhseActLine.DecimalField(F_WhseActLine_QuantityToHandle));
                    if not Bin.Get(SplitWhseActLine."Location Code", ar_WhseActLine.TextField(F_WhseActLine_BinCode))then Clear(Bin);
                    if(SplitWhseActLine."Zone Code" <> Bin."Zone Code")then SplitWhseActLine.Validate("Zone Code", Bin."Zone Code");
                    if(SplitWhseActLine."Bin Code" <> ar_WhseActLine.TextField(F_WhseActLine_BinCode))then SplitWhseActLine.Validate("Bin Code", ar_WhseActLine.TextField(F_WhseActLine_BinCode));
                    if((SplitWhseActLine."Lot No." <> ar_WhseActLine.TextField(F_WhseActLine_LotNo)) and (SplitWhseActLine."Qty. Handled" = 0))then SplitWhseActLine.Validate("Lot No.", ar_WhseActLine.TextField(F_WhseActLine_LotNo));
                    SplitWhseActLine.Modify(true);
                    ActionTaken:=true;
                    RecRef.GetTable(SplitWhseActLine);
                    DataLogMgt.LogDataOp_Modify(RecRef);
                    if(MasterWhseActLine."Activity Type" <> MasterWhseActLine."Activity Type"::Movement)then begin
                        SlaveWhseActLine.Reset;
                        SlaveWhseActLine.SetRange("Activity Type", MasterWhseActLine."Activity Type");
                        SlaveWhseActLine.SetRange("No.", MasterWhseActLine."No.");
                        SlaveWhseActLine.SetRange("Source Type", MasterWhseActLine."Source Type");
                        SlaveWhseActLine.SetRange("Source Subtype", MasterWhseActLine."Source Subtype");
                        SlaveWhseActLine.SetRange("Source No.", MasterWhseActLine."Source No.");
                        SlaveWhseActLine.SetRange("Source Line No.", MasterWhseActLine."Source Line No.");
                        SlaveWhseActLine.SetRange("Source Subline No.", MasterWhseActLine."Source Subline No.");
                        SlaveWhseActLine.SetRange("Source Document", MasterWhseActLine."Source Document");
                        clear(SlaveLineFindMethod);
                        case MasterWhseActLine."Activity Type" of MasterWhseActLine."Activity Type"::"Put-away": begin
                            SlaveLineFindMethod:='+'; //Find the last take line before current line
                            SlaveWhseActLine.SetRange("Action Type", SlaveWhseActLine."Action Type"::Take);
                            SlaveWhseActLine.SetFilter("Line No.", '<%1', MasterWhseActLine."Line No.");
                        end;
                        MasterWhseActLine."Activity Type"::Pick: begin
                            SlaveLineFindMethod:='-'; //Find the first place line after current line
                            SlaveWhseActLine.SetRange("Action Type", SlaveWhseActLine."Action Type"::Place);
                            SlaveWhseActLine.SetFilter("Line No.", '>%1', MasterWhseActLine."Line No.");
                        end;
                        end;
                        SlaveWhseActLine.SetRange("Qty. Outstanding", MasterOutstandingQty);
                        if not SlaveWhseActLine.Find(SlaveLineFindMethod)then SlaveWhseActLine.SetRange("Qty. Outstanding");
                        if SlaveWhseActLine.Find(SlaveLineFindMethod)then begin
                            case MasterWhseActLine."Activity Type" of MasterWhseActLine."Activity Type"::"Put-away": begin
                                //SlaveWhseActLine.Validate("Qty. to Handle (Base)", SplitWhseActLine."Qty. to Handle (Base)");
                                SlaveWhseActLine.Validate("Qty. to Handle (Base)", SlaveWhseActLine."Qty. to Handle (Base)" + SplitWhseActLine."Qty. to Handle (Base)");
                                //Manually update breakbulk lines due to use of CurrFieldNo in standard code
                                if((SlaveWhseActLine."Activity Type" = SlaveWhseActLine."Activity Type"::"Put-away") and (SlaveWhseActLine."Action Type" = SlaveWhseActLine."Action Type"::Take))then if(SlaveWhseActLine."Breakbulk No." <> 0) or SlaveWhseActLine."Original Breakbulk" then SlaveWhseActLine.UpdateBreakbulkQtytoHandle();
                            end;
                            MasterWhseActLine."Activity Type"::Pick: begin
                                if(SlaveWhseActLine."Qty. Outstanding (Base)" <> SplitWhseActLine."Qty. to Handle (Base)")then begin
                                    SlaveWhseActLine.Validate("Qty. to Handle (Base)", SlaveWhseActLine."Qty. Outstanding (Base)" - SplitWhseActLine."Qty. to Handle (Base)");
                                    SlaveWhseActLine.SplitLine(SlaveWhseActLine);
                                    SplitLineNo:=SDSHandler.WAL_Split_Pop(SlaveWhseActLine);
                                    SlaveWhseActLine.Get(SlaveWhseActLine."Activity Type", SlaveWhseActLine."No.", SlaveWhseActLine."Line No.");
                                    SlaveWhseActLine.Validate("Qty. to Handle (Base)", 0);
                                    SlaveWhseActLine.Modify;
                                    SlaveWhseActLine.Get(SplitWhseActLine."Activity Type", SplitWhseActLine."No.", SplitLineNo);
                                end
                                else
                                    SlaveWhseActLine.Validate("Qty. to Handle (Base)", SplitWhseActLine."Qty. to Handle (Base)");
                            end;
                            end;
                            if(SlaveWhseActLine."Lot No." <> SplitWhseActLine."Lot No.")then SlaveWhseActLine.Validate("Lot No.", SplitWhseActLine."Lot No.");
                            //TODO:Handle mobile device handling
                            //SlaveWhseActLine.VALIDATE ( DYM_MobileDevice , DeviceSetup.Code ) ;
                            SlaveWhseActLine.Modify(true);
                            RecRef.GetTable(SlaveWhseActLine);
                            DataLogMgt.LogDataOp_Modify(RecRef);
                        end;
                    end;
                    if not LastMasterWhseActHeader.Get(ar_WhseActLine.OptionField(F_WhseActLine_ActivityType, O_WhseActLine_ActivityType), ar_WhseActLine.TextField(F_WhseActLine_No))then Clear(LastMasterWhseActHeader);
                end;
                end;
            until not ar_WhseActLine.NextRecord;
        //MovementRequestHeader handling
        if(MovementRequestHeaderCreated)then begin
            MasterWhseActHeader.Find();
            MasterWhseActHeader.Validate(DYM_MobileStatus, MasterWhseActHeader.DYM_MobileStatus::Pending);
            MasterWhseActHeader.Modify();
        end;
        if ActionTaken then begin
            WHHelper.UpdateDocumentMobileStatus(LastMasterWhseActHeader, M_WhseActLine_MobileStatus);
            Clear(RecRef);
            RecRef.GetTable(LastMasterWhseActHeader);
            DataLogMgt.LogDataOp_Modify(RecRef);
            PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Register, '', 0, false, '');
            RecRef.Close;
        end;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessTransferDocs()
    var
        TransHeader: Record "Transfer Header";
        TransLines: Record "Transfer Line";
        ar_TransHead: Codeunit DYM_ActiveRecManagement;
        ar_TransLines: Codeunit DYM_ActiveRecManagement;
        IsHandled, FullyProcessed: Boolean;
        IsInbound: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_TransHead.ReadTable(T_TransHead)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessTransfers(IsHandled);
        if IsHandled then exit;
        ar_TransHead.ReadTable(T_TransHead);
        if ar_TransHead.FindRecord then repeat //Check for new transfer. Not using filter for backward compatibility. Regular transfers are not sending "newTransfer" tag
                if not(ar_TransHead.BooleanField(F_TransHead_IsNewTransfer))then begin
                    clear(IsInbound);
                    IsInbound:=ar_TransHead.IntegerField(F_TransHead_IsInbound);
                    DataLogMgt.LogActiveRecOp(ar_TransHead.GetTableName(), ar_TransHead.ActiveRecPK2Text());
                    if TransHeader.Get(ar_TransHead.TextField(F_TransHead_No))then begin
                        TransHeader.LockTable;
                        ar_TransLines.ReadTable(T_TransLine);
                        ar_TransLines.SetFieldFilter(F_TransLine_DocumentNo, ar_TransHead.TextField(F_TransHead_No));
                        if ar_TransLines.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_TransLines.GetTableName(), ar_TransLines.ActiveRecPK2Text());
                                if TransLines.Get(ar_TransLines.TextField(F_TransLine_DocumentNo), ar_TransLines.IntegerField(F_TransLine_LineNo))then begin
                                    TransLines.LockTable;
                                    TransLines.TestField("Item No.", ar_TransLines.TextField(F_TransLine_ItemNo));
                                    //TransLines.TESTFIELD ( Quantity , TransLinesTemp.Quantity ) ;
                                    case IsInbound of 0: if(ar_TransLines.DecimalField(F_TransLine_QuantityToShip) <> 0)then begin
                                            if(ar_TransLines.DecimalField(F_TransLine_QuantityToShip) + TransLines."Qty. to Ship") > TransLines."Outstanding Quantity" then begin
                                                If(SettingsMgt.GetSetting(ConstMgt.BOS_whAllowConfirmGreaterQtyInOutTr) = '1')then begin
                                                    TransLines.Validate(Quantity, (TransLines.Quantity + (ar_TransLines.DecimalField(F_TransLine_QuantityToShip) + TransLines."Qty. to Ship" - TransLines."Outstanding Quantity")));
                                                    TransLines.Validate("Qty. to Ship", TransLines."Outstanding Quantity");
                                                end
                                                else
                                                    error(Text004);
                                            end
                                            else
                                                TransLines.Validate("Qty. to Ship", TransLines."Qty. to Ship" + ar_TransLines.DecimalField(F_TransLine_QuantityToShip));
                                        end;
                                    1: if(ar_TransLines.DecimalField(F_TransLine_QtyToReceive) <> 0)then begin
                                            TransLines.Validate("Qty. to Receive", TransLines."Qty. to Receive" + ar_TransLines.DecimalField(F_TransLine_QtyToReceive));
                                        end;
                                    end;
                                    WhseEventPub.OnProcessTransfers_AfterLineCreated(TransLines, ar_TransHead, ar_TransLines);
                                    RecRef.GetTable(TransLines);
                                    DataLogMgt.LogDataOp_Modify(RecRef);
                                    TransLines.Modify;
                                end;
                            until not ar_TransLines.NextRecord;
                        //Handle document Mobile Status                       
                        FullyProcessed:=true;
                        TransLines.Reset;
                        TransLines.SetRange("Derived From Line No.", 0);
                        TransLines.SetRange("Document No.", TransHeader."No.");
                        IF TransLines.findset(false, false)then repeat case IsInbound of 0: If(TransLines."Outstanding Quantity" <> TransLines."Qty. to Ship")then begin
                                        FullyProcessed:=false;
                                    end;
                                1: If(TransLines."Qty. in Transit" <> TransLines."Qty. to Receive")then begin
                                        FullyProcessed:=false;
                                    end;
                                end;
                            until TransLines.Next() = 0;
                        case FullyProcessed of true: begin
                            case(IsInbound)of 0: begin
                                TransHeader.VALIDATE(DYM_MobileShipStatus, TransHeader.DYM_MobileShipStatus::Processed);
                                TransHeader.VALIDATE(DYM_MobileDevice, DeviceSetup.Code);
                            end;
                            1: begin
                                TransHeader.VALIDATE(DYM_MobileReceiveStatus, TransHeader.DYM_MobileReceiveStatus::Processed);
                                TransHeader.VALIDATE(DYM_MobileDevice, DeviceSetup.Code);
                            end;
                            end;
                        end;
                        false: begin
                            case(IsInbound)of 0: begin
                                TransHeader.VALIDATE(DYM_MobileShipStatus, TransHeader.DYM_MobileShipStatus::"Partially Processed")end;
                            1: begin
                                TransHeader.VALIDATE(DYM_MobileReceiveStatus, TransHeader.DYM_MobileReceiveStatus::"Partially Processed");
                            end;
                            end;
                        end;
                        end;
                        if(ar_TransHead.BooleanField(F_TransHead_IsFinished))then begin
                            case(ar_TransHead.TextField(F_TransHead_IsInbound))of O_TransHead_IsInbound_Outbound: TransHeader.VALIDATE(DYM_MobileShipStatus, TransHeader.DYM_MobileShipStatus::Processed);
                            O_TransHead_IsInbound_Inbound: TransHeader.VALIDATE(DYM_MobileReceiveStatus, TransHeader.DYM_MobileReceiveStatus::Processed);
                            end;
                            TransHeader.Modify();
                        end;
                        WhseEventPub.OnProcessTransfers_AfterMobileStatusSet(TransHeader, ar_TransHead);
                        TransHeader.Modify(true);
                        RecRef.GetTable(TransHeader);
                        DataLogMgt.LogDataOp_Modify(RecRef);
                    end;
                end;
            until not ar_TransHead.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessWhseShipments()
    var
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhseShipmentLines: Record "Warehouse Shipment Line";
        ar_WhseShptHead: Codeunit DYM_ActiveRecManagement;
        ar_WhseShptLines: Codeunit DYM_ActiveRecManagement;
        PostProcessParameter: Text[30];
        FullyProcessed: Boolean;
        IsHandled, Print: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_WhseShptHead.ReadTable(T_WhseShipHead)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessWhseShipments(IsHandled);
        if IsHandled then exit;
        ar_WhseShptHead.ReadTable(T_WhseShipHead);
        if ar_WhseShptHead.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_WhseShptHead.GetTableName(), ar_WhseShptHead.ActiveRecPK2Text());
                WhseShipmentHeader.Get(ar_WhseShptHead.TextField(F_WhseShipHead_No));
                FullyProcessed:=true;
                ar_WhseShptLines.ReadTable(T_WhseShipLine);
                ar_WhseShptLines.SetFieldFilter(F_WhseShipLine_No, ar_WhseShptHead.TextField(F_WhseShipHead_No));
                if ar_WhseShptLines.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_WhseShptLines.GetTableName(), ar_WhseShptLines.ActiveRecPK2Text());
                        WhseShipmentLines.Get(ar_WhseShptLines.TextField(F_WhseShipLine_No), ar_WhseShptLines.IntegerField(F_WhseShipLine_LineNo));
                        WhseShipmentLines.Validate("Qty. to Ship", WhseShipmentLines."Qty. to Ship" + ar_WhseShptLines.DecimalField(F_WhseShipLine_QuantityToShip));
                        if(WhseShipmentLines."Qty. Outstanding" <> WhseShipmentLines."Qty. to Ship")then Clear(FullyProcessed);
                        WhseShipmentLines.Modify;
                        RecRef.GetTable(WhseShipmentLines);
                        DataLogMgt.LogDataOp_Modify(RecRef);
                    until not ar_WhseShptLines.NextRecord;
                WHHelper.UpdateDocumentMobileStatus(WhseShipmentHeader, M_WhseShipLine_MobileStatus);
                Clear(PostProcessParameter);
                if Print then PostProcessParameter:=ConstMgt.PPP_Print;
                RecRef.GetTable(WhseShipmentHeader);
                DataLogMgt.LogDataOp_Modify(RecRef);
                PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, PostProcessParameter, 0, false, '');
            until not ar_WhseShptHead.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessWhseReceipts()
    var
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLines: Record "Warehouse Receipt Line";
        ar_WhseRcptHead: Codeunit DYM_ActiveRecManagement;
        ar_WhseRcptLines: Codeunit DYM_ActiveRecManagement;
        PostProcessParameter: Text[30];
        FullyProcessed: Boolean;
        IsHandled, Print: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_WhseRcptHead.ReadTable(T_WhseRcptHead)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessWhseReceipts(IsHandled);
        if IsHandled then exit;
        ar_WhseRcptHead.ReadTable(T_WhseRcptHead);
        if ar_WhseRcptHead.FindRecord then repeat WhseReceiptHeader.Get(ar_WhseRcptHead.TextField(F_WhseRcptHead_No));
                if((ar_WhseRcptHead.TextField(F_WhseRcptHead_VendorShipmentNo) <> '') and (ar_WhseRcptHead.TextField(F_WhseRcptHead_VendorShipmentNo) <> WhseReceiptHeader."Vendor Shipment No."))then begin
                    WhseReceiptHeader.Validate("Vendor Shipment No.", ar_WhseRcptHead.TextField(F_WhseRcptHead_VendorShipmentNo));
                    WhseReceiptHeader.Modify(true);
                end;
                ar_WhseRcptLines.ReadTable(T_WhseRcptLine);
                ar_WhseRcptLines.SetFieldFilter(F_WhseRcptLine_No, ar_WhseRcptHead.TextField(F_WhseRcptHead_No));
                if ar_WhseRcptLines.FindRecord then repeat WhseReceiptLines.Get(ar_WhseRcptLines.TextField(F_WhseRcptLine_No), ar_WhseRcptLines.IntegerField(F_WhseRcptLine_LineNo));
                        WhseReceiptLines.Validate("Qty. to Receive", WhseReceiptLines."Qty. to Receive" + ar_WhseRcptLines.DecimalField(F_WhseRcptLine_QuantityToReceive));
                        WhseReceiptLines.Modify;
                        RecRef.GetTable(WhseReceiptLines);
                        DataLogMgt.LogDataOp_Modify(RecRef);
                    until not ar_WhseRcptLines.NextRecord;
                WHHelper.UpdateDocumentMobileStatus(WhseReceiptHeader, M_WhseRcptLine_MobileStatus);
                Clear(PostProcessParameter);
                if Print then PostProcessParameter:=ConstMgt.PPP_Print;
                RecRef.GetTable(WhseReceiptHeader);
                DataLogMgt.LogDataOp_Modify(RecRef);
                PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, PostProcessParameter, 0, false, '');
            until not ar_WhseRcptHead.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessWhseInvt()
    var
        WhseJnlBatch: Record "Warehouse Journal Batch";
        WhseJnlLine: Record "Warehouse Journal Line";
        LastWhseJnlLine: Record "Warehouse Journal Line";
        Location: Record Location;
        Bin: Record Bin;
        ar_WhseJnlLine: Codeunit DYM_ActiveRecManagement;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        JournalLocationCode: Code[10];
        NextLine: Integer;
        IsHandled: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        Clear(IsHandled);
        WhseEventPub.OnProcessWhseInventory(IsHandled);
        if IsHandled then exit;
        if not ar_WhseJnlLine.ReadTable(T_StockTakeLine)then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_WhseJournalTemplate);
        SettingsMgt.TestSetting(ConstMgt.BOS_WhseJournalBatch);
        JournalTemplateName:=SettingsMgt.GetSetting(ConstMgt.BOS_WhseJournalTemplate);
        JournalBatchName:=SettingsMgt.GetSetting(ConstMgt.BOS_WhseJournalBatch);
        ar_WhseJnlLine.SetFieldFilter(F_StockTakeLine_Advanced, LowLevelDP.Boolean2Text(true));
        if ar_WhseJnlLine.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_WhseJnlLine.GetTableName(), ar_WhseJnlLine.ActiveRecPK2Text());
                JournalLocationCode:=ar_WhseJnlLine.TextField(F_StockTakeLine_LocationCode);
                WhseJnlBatch.Get(JournalTemplateName, JournalBatchName, JournalLocationCode);
                WHHelper.HandleWhseJnlLine(Enum::DYM_ItemJournalHandlingType::PhysInventory, JournalTemplateName, JournalBatchName, 0, //Entry Type not used for PhysInventory handling type
 ar_WhseJnlLine.TextField(F_StockTakeLine_ItemNo), ar_WhseJnlLine.TextField(F_StockTakeLine_VariantCode), ar_WhseJnlLine.TextField(F_StockTakeLine_UnitofMeasureCode), JournalLocationCode, '', //If empty, the Zone Code is retrieved from Bin
 ar_WhseJnlLine.TextField(F_StockTakeLine_BinCode), ar_WhseJnlLine.DecimalField(F_StockTakeLine_Qty), ar_WhseJnlLine.TextField(F_StockTakeLine_SerialNo), ar_WhseJnlLine.TextField(F_StockTakeLine_LotNo), ar_WhseJnlLine.TextField(F_StockTakeLine_PackageNo), ar_WhseJnlLine.DateField(F_StockTakeLine_ExpirationDate));
            until not ar_WhseJnlLine.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessWhseTracking()
    var
        ReservEntry: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        DerivedTransLine: Record "Transfer Line";
        Item: Record Item;
        WhseReceiptLine: Record "Warehouse Receipt Line";
        WhseShipmentLine: Record "Warehouse Shipment Line";
        TrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingLines: Codeunit DYM_ItemTrackingLines;
        TrackingQty: Decimal;
        LineTrackingChanged: Boolean;
        TrackingUpdated: Boolean;
        IsHandled: Boolean;
        CorrectionFilterEntryNo: BigInteger;
        "=== Active Record ===": Integer;
        ar_SalesLines: Codeunit DYM_ActiveRecManagement;
        ar_PurchLines: Codeunit DYM_ActiveRecManagement;
        ar_WhseTransferLines: Codeunit DYM_ActiveRecManagement;
        ar_WhseRcptLines: Codeunit DYM_ActiveRecManagement;
        ar_WhseShptLines: Codeunit DYM_ActiveRecManagement;
        ar_TrackSpec: Codeunit DYM_ActiveRecManagement;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        Clear(GeneralDP);
        Clear(TrackingUpdated);
        Clear(IsHandled);
        WhseEventPub.OnProcessTracking(IsHandled);
        if IsHandled then exit;
        #region Sales tracking handling
        clear(IsHandled);
        WhseEventPub.OnProcessTracking_Sales(IsHandled);
        if not IsHandled then begin
            ar_SalesLines.ReadTable(T_SalesLine);
            ar_SalesLines.SetFieldFilter(F_SalesLine_Type, LowLevelDP.OptionValue2Text(O_SalesLine_Type, SalesLine.Type::Item.AsInteger()));
            if ar_SalesLines.FindRecord then repeat SalesHeader.Get(ar_SalesLines.OptionField(F_SalesLine_DocumentType, O_SalesLine_DocumentType), ar_SalesLines.TextField(F_SalesLine_DocumentNo));
                    SalesLine.Get(ar_SalesLines.OptionField(F_SalesLine_DocumentType, O_SalesLine_DocumentType), ar_SalesLines.TextField(F_SalesLine_DocumentNo), ar_SalesLines.IntegerField(F_SalesLine_LineNo));
                    Item.Get(ar_SalesLines.TextField(F_SalesLine_No));
                    if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                        Clear(LineTrackingChanged);
                        ar_TrackSpec.ReadTable(T_TrackSpec);
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceType, LowLevelDP.Integer2Text(DATABASE::"Sales Line"));
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceSubtype, ar_SalesLines.TextField(F_SalesLine_DocumentType));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_SalesLines.TextField(F_SalesLine_DocumentNo));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceRefNo, ar_SalesLines.TextField(F_SalesLine_LineNo));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                        if ar_TrackSpec.FindRecord then repeat Clear(UOMAssistMgt);
                                Clear(TrackAssistMgt);
                                Clear(TrackingQty);
                                TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_SalesLines.TextField(F_SalesLine_No), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_SalesLines.TextField(F_SalesLine_UnitofMeasure), Item."Base Unit of Measure");
                                case ar_TrackSpec.TextField(F_TrackSpec_EntryNo) = '' of true: begin
                                    TrackAssistMgt.CreateTracking_SL(SalesLine, TrackingQty, SalesLine."Qty. per Unit of Measure", ar_TrackSpec.DateField(F_TrackSpec_ExpirationDate), 0D, ar_TrackSpec.TextField(F_TrackSpec_SerialNo), ar_TrackSpec.TextField(F_TrackSpec_LotNo), ar_TrackSpec.TextField(F_TrackSpec_PackageNo), 0);
                                end;
                                false: begin
                                    ReservEntry.Reset();
                                    ReservEntry.SetRange("Entry No.", ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo));
                                    ReservEntry.SetRange(Positive, ar_TrackSpec.BooleanField(F_TrackSpec_Positive));
                                    if(ReservEntry.FindSet())then begin
                                        TrackingSpecification.SetSourceFromReservEntry(ReservEntry);
                                        TrackingSpecification.CopyTrackingFromReservEntry(ReservEntry);
                                        TrackingSpecification."Appl.-to Item Entry":=ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo);
                                        TrackingSpecification."Qty. to Handle (Base)":=TrackingQty;
                                        TrackingSpecification."Qty. to Invoice (Base)":=TrackingQty;
                                        ItemTrackingLines.SetSource(TrackingSpecification, 0D);
                                        ItemTrackingLines.SetQtyToHandleAndInvoice(TrackingSpecification);
                                    end;
                                end;
                                end;
                            until not ar_TrackSpec.NextRecord;
                    end;
                until not ar_SalesLines.NextRecord;
        end;
        #endregion 
        #region Purchase tracking handling
        clear(IsHandled);
        WhseEventPub.OnProcessTracking_Purch(IsHandled);
        if not IsHandled then begin
            ar_PurchLines.ReadTable(T_PurchaseLine);
            ar_PurchLines.SetFieldFilter(F_PurchLine_LineType, LowLevelDP.OptionValue2Text(O_PurchLine_LineType, PurchLine.Type::Item.AsInteger()));
            if ar_PurchLines.FindRecord then repeat PurchHeader.Get(ar_PurchLines.OptionField(F_PurchLine_DocumentType, O_PurchLine_DocumentType), ar_PurchLines.TextField(F_PurchLine_DocumentNo));
                    PurchLine.Get(ar_PurchLines.OptionField(F_PurchLine_DocumentType, O_PurchLine_DocumentType), ar_PurchLines.TextField(F_PurchLine_DocumentNo), ar_PurchLines.IntegerField(F_PurchLine_LineNo));
                    Item.Get(ar_PurchLines.TextField(F_PurchLine_ItemNo));
                    if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                        ar_TrackSpec.ReadTable(T_TrackSpec);
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceType, LowLevelDP.Integer2Text(DATABASE::"Purchase Line"));
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceSubtype, ar_PurchLines.TextField(F_PurchLine_DocumentType));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_PurchLines.TextField(F_PurchLine_DocumentNo));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceRefNo, ar_PurchLines.TextField(F_PurchLine_LineNo));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                        if ar_TrackSpec.FindRecord then repeat Clear(UOMAssistMgt);
                                Clear(TrackAssistMgt);
                                Clear(TrackingQty);
                                TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_PurchLines.TextField(F_PurchLine_ItemNo), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_PurchLines.TextField(F_PurchLine_UnitofMeasureCode), Item."Base Unit of Measure");
                                case ar_TrackSpec.TextField(F_TrackSpec_EntryNo) = '' of true: begin
                                    TrackAssistMgt.CreateTracking_PL(PurchLine, TrackingQty, PurchLine."Qty. per Unit of Measure", ar_TrackSpec.DateField(F_TrackSpec_ExpirationDate), 0D, ar_TrackSpec.TextField(F_TrackSpec_SerialNo), ar_TrackSpec.TextField(F_TrackSpec_LotNo), ar_TrackSpec.TextField(F_TrackSpec_PackageNo));
                                end;
                                false: begin
                                    ReservEntry.Reset();
                                    ReservEntry.SetRange("Entry No.", ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo));
                                    ReservEntry.SetRange(Positive, ar_TrackSpec.BooleanField(F_TrackSpec_Positive));
                                    if(ReservEntry.FindSet())then begin
                                        TrackingSpecification.SetSourceFromReservEntry(ReservEntry);
                                        TrackingSpecification.CopyTrackingFromReservEntry(ReservEntry);
                                        TrackingSpecification."Appl.-to Item Entry":=ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo);
                                        TrackingSpecification."Qty. to Handle (Base)":=TrackingQty;
                                        TrackingSpecification."Qty. to Invoice (Base)":=TrackingQty;
                                        ItemTrackingLines.SetSource(TrackingSpecification, 0D);
                                        ItemTrackingLines.SetQtyToHandleAndInvoice(TrackingSpecification);
                                    end;
                                end;
                                end;
                            until not ar_TrackSpec.NextRecord;
                    end;
                until not ar_PurchLines.NextRecord;
        end;
        #endregion 
        #region Warehouse Receipt tracking handling
        clear(IsHandled);
        WhseEventPub.OnProcessTracking_WhseRcpt(IsHandled);
        if not IsHandled then begin
            ar_WhseRcptLines.ReadTable(T_WhseRcptLine);
            if ar_WhseRcptLines.FindRecord then repeat WhseReceiptLine.Get(ar_WhseRcptLines.TextField(F_WhseRcptLine_No), ar_WhseRcptLines.TextField(F_WhseRcptLine_LineNo));
                    case WhseReceiptLine."Source Type" of DATABASE::"Purchase Line": PurchLine.Get(WhseReceiptLine."Source Subtype", WhseReceiptLine."Source No.", WhseReceiptLine."Source Line No.");
                    DATABASE::"Transfer Line": TransferLine.Get(WhseReceiptLine."Source No.", WhseReceiptLine."Source Line No.");
                    end;
                    if not Item.Get(ar_WhseRcptLines.TextField(F_WhseRcptLine_ItemNo))then Clear(Item);
                    if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                        Clear(LineTrackingChanged);
                        ar_TrackSpec.ReadTable(T_TrackSpec);
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_WhseRcptLines.TextField(F_WhseRcptLine_SourceNo));
                        case WhseReceiptLine."Source Type" of DATABASE::"Purchase Line": ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceRefNo, LowLevelDP.Integer2Text(WhseReceiptLine."Source Line No."));
                        DATABASE::"Transfer Line": ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceProdOrderLine, LowLevelDP.Integer2Text(WhseReceiptLine."Source Line No."));
                        end;
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                        if ar_TrackSpec.FindRecord then repeat Clear(UOMAssistMgt);
                                case WhseReceiptLine."Source Type" of DATABASE::"Purchase Line": begin
                                    Clear(TrackingQty);
                                    TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_WhseRcptLines.TextField(F_WhseRcptLine_ItemNo), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_WhseRcptLines.TextField(F_WhseRcptLine_UnitOfMeasureCode), Item."Base Unit of Measure");
                                    TrackAssistMgt.CreateTracking_WRL(WhseReceiptLine, TrackingQty, WhseReceiptLine."Qty. per Unit of Measure", ar_TrackSpec.DateField(F_TrackSpec_ExpirationDate), 0D, ar_TrackSpec.TextField(F_TrackSpec_SerialNo), ar_TrackSpec.TextField(F_TrackSpec_LotNo), ar_TrackSpec.TextField(F_TrackSpec_PackageNo));
                                end;
                                DATABASE::"Transfer Line": begin
                                //TODO:Tracking handling
                                //TrackingBuffer."Qty. to Handle (Base)" := TrackingBuffer."Quantity (Base)" ;
                                //TrackingBuffer."Qty. to Invoice (Base)" := TrackingBuffer."Quantity (Base)" ;
                                //ItemTrackingLines.SetQtyToHandleAndInvoice ( TrackingBuffer ) ;
                                end;
                                end;
                            until not ar_TrackSpec.NextRecord;
                    end;
                until not ar_WhseRcptLines.NextRecord;
        end;
        #endregion 
        #region Warehouse Shipment tracking handling
        clear(IsHandled);
        WhseEventPub.OnProcessTracking_WhseShip(IsHandled);
        if not IsHandled then begin
            ar_WhseShptLines.ReadTable(T_WhseShipLine);
            if ar_WhseShptLines.FindRecord then repeat if not TrackingUpdated then begin
                    //TODO:Tracking handling
                    //AssistMgt.DeleteTrackingQtytoHandle ( TrackingBuffer ) ;
                    //TrackingUpdated := TRUE ;
                    end;
                    WhseShipmentLine.Get(ar_WhseShptLines.TextField(F_WhseShipLine_No), ar_WhseShptLines.IntegerField(F_WhseShipLine_LineNo));
                    if not Item.Get(ar_WhseShptLines.TextField(F_WhseShipLine_ItemNo))then Clear(Item);
                    if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                        Clear(LineTrackingChanged);
                        ar_TrackSpec.ReadTable(T_TrackSpec);
                        //EK
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceType, ar_WhseShptLines.TextField(F_WhseShipLine_SourceType));
                        //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceSubtype, ar_WhseShptLines.TextField(F_WhseRcptLine_SourceSubtype));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_WhseShptLines.TextField(F_WhseRcptLine_SourceNo));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceRefNo, ar_WhseShptLines.TextField(F_WhseShipLine_SourceLineNo));
                        ar_TrackSpec.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                        if ar_TrackSpec.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_TrackSpec.GetTableName(), ar_TrackSpec.ActiveRecPK2Text());
                                case(WhseShipmentLine."Qty. Picked (Base)" = 0)of true: begin
                                    Clear(UOmAssistMgt);
                                    Clear(TrackingQty);
                                    TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_WhseShptLines.TextField(F_WhseShipLine_ItemNo), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_WhseShptLines.TextField(F_WhseShipLine_UnitOfMeasureCode), Item."Base Unit of Measure");
                                    TrackAssistMgt.CreateTracking_WSL(WhseShipmentLine, TrackingQty, WhseShipmentLine."Qty. per Unit of Measure", 0D, 0D, '', ar_TrackSpec.TextField(F_TrackSpec_LotNo), '');
                                end;
                                false: begin
                                //TODO:Tracking handling
                                //TrackingBuffer."Qty. to Handle (Base)" := TrackingBuffer."Quantity (Base)" ;
                                //TrackingBuffer."Qty. to Invoice (Base)" := TrackingBuffer."Quantity (Base)" ;
                                //ItemTrackingLines.SetQtyToHandleAndInvoice ( TrackingBuffer ) ;
                                end;
                                end;
                            until not ar_TrackSpec.NextRecord;
                    end;
                until not ar_WhseShptLines.NextRecord;
        end;
        #endregion 
        #region Whse Transfer tracking handling (for handling existing transfers)
        clear(IsHandled);
        WhseEventPub.OnProcessTracking_Transfer(IsHandled);
        if not IsHandled then begin
            ar_WhseTransferLines.ReadTable(T_TransLine);
            if ar_WhseTransferLines.FindRecord then repeat if not(ar_WhseTransferLines.BooleanField(F_TransLine_IsNewTransfer))then begin
                        TransferHeader.Get(ar_WhseTransferLines.TextField(F_TransLine_DocumentNo));
                        TransferLine.Get(ar_WhseTransferLines.TextField(F_TransLine_DocumentNo), ar_WhseTransferLines.TextField(F_TransLine_LineNo));
                        Item.Get(ar_WhseTransferLines.TextField(F_TransLine_ItemNo));
                        if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                            #region Handle Transfer Shipment Tracking
                            ar_TrackSpec.ReadTable(T_TrackSpec);
                            //EK
                            //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceType, LowLevelDP.Integer2Text(DATABASE::"Transfer Line"));
                            //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceSubtype, LowLevelDP.Integer2Text(1)); //Fixed for Transfer Order
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_WhseTransferLines.TextField(F_TransLine_DocumentNo));
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceRefNo, ar_WhseTransferLines.TextField(F_TransLine_LineNo));
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                            if ar_TrackSpec.FindRecord then repeat Clear(UOMAssistMgt);
                                    Clear(TrackingQty);
                                    TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_WhseTransferLines.TextField(F_TransLine_ItemNo), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_WhseTransferLines.TextField(F_TransLine_UnitofMeasureCode), Item."Base Unit of Measure");
                                    case ar_TrackSpec.TextField(F_TrackSpec_EntryNo) = '' of true: begin
                                        TrackAssistMgt.CreateTracking_TL(TransferLine, TrackingQty, TransferLine."Qty. per Unit of Measure", ar_TrackSpec.DateField(F_TrackSpec_ExpirationDate), 0D, ar_TrackSpec.TextField(F_TrackSpec_SerialNo), ar_TrackSpec.TextField(F_TrackSpec_LotNo), ar_TrackSpec.TextField(F_TrackSpec_PackageNo));
                                    end;
                                    false: begin
                                        ReservEntry.Reset();
                                        ReservEntry.SetRange("Entry No.", ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo));
                                        ReservEntry.SetRange(Positive, ar_TrackSpec.BooleanField(F_TrackSpec_Positive));
                                        if(ReservEntry.FindSet())then begin
                                            TrackingSpecification.SetSourceFromReservEntry(ReservEntry);
                                            TrackingSpecification.CopyTrackingFromReservEntry(ReservEntry);
                                            TrackingSpecification."Appl.-to Item Entry":=ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo);
                                            TrackingSpecification."Qty. to Handle (Base)":=TrackingQty;
                                            TrackingSpecification."Qty. to Invoice (Base)":=TrackingQty;
                                            ItemTrackingLines.SetSource(TrackingSpecification, 0D);
                                            ItemTrackingLines.SetQtyToHandleAndInvoice(TrackingSpecification);
                                        end;
                                    end;
                                    end;
                                until not ar_TrackSpec.NextRecord;
                            #endregion 
                            #region Handle Transfer Receipt Tracking
                            ar_TrackSpec.ReadTable(T_TrackSpec);
                            //EK
                            //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceType, LowLevelDP.Integer2Text(DATABASE::"Transfer Line"));
                            //ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceSubtype, LowLevelDP.Integer2Text(1)); //Fixed for Transfer Order
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_WhseTransferLines.TextField(F_TransLine_DocumentNo));
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceProdOrderLine, ar_WhseTransferLines.TextField(F_TransLine_LineNo));
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                            if ar_TrackSpec.FindRecord then repeat Clear(UOMAssistMgt);
                                    Clear(TrackingQty);
                                    TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_WhseTransferLines.TextField(F_TransLine_ItemNo), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_WhseTransferLines.TextField(F_TransLine_UnitofMeasureCode), Item."Base Unit of Measure");
                                    case ar_TrackSpec.TextField(F_TrackSpec_EntryNo) = '' of true: Error(Text005);
                                    false: begin
                                        ReservEntry.Reset();
                                        ReservEntry.SetRange("Entry No.", ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo));
                                        ReservEntry.SetRange(Positive, ar_TrackSpec.BooleanField(F_TrackSpec_Positive));
                                        if(ReservEntry.FindSet())then begin
                                            TrackingSpecification.SetSourceFromReservEntry(ReservEntry);
                                            TrackingSpecification.CopyTrackingFromReservEntry(ReservEntry);
                                            TrackingSpecification."Appl.-to Item Entry":=ar_TrackSpec.IntegerField(F_TrackSpec_EntryNo);
                                            TrackingSpecification."Qty. to Handle (Base)":=TrackingQty;
                                            TrackingSpecification."Qty. to Invoice (Base)":=TrackingQty;
                                            ItemTrackingLines.SetSource(TrackingSpecification, 0D);
                                            ItemTrackingLines.SetQtyToHandleAndInvoice(TrackingSpecification);
                                        end;
                                    end;
                                    end;
                                until not ar_TrackSpec.NextRecord;
                        #endregion 
                        end;
                    end;
                until not ar_WhseTransferLines.NextRecord;
        end;
        #endregion 
        #region New Transfer tracking handling
        clear(IsHandled);
        WhseEventPub.OnProcessTracking_NewTransfer(IsHandled);
        if not IsHandled then begin
            ar_WhseTransferLines.ReadTable(T_TransLine);
            if ar_WhseTransferLines.FindRecord then repeat if(ar_WhseTransferLines.BooleanField(F_TransLine_IsNewTransfer))then begin
                        TransferLine.GetBySystemId(RecordLinkMgt.GetRecordLinkRecId(T_TransLine, ar_WhseTransferLines.TextField(ConstMgt.SYS_DMSRowId())));
                        if not Item.Get(ar_WhseTransferLines.TextField(F_TransLine_ItemNo))then Clear(Item);
                        if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                            Clear(LineTrackingChanged);
                            ar_TrackSpec.ReadTable(T_TrackSpec);
                            //ar_TrackingSpecification.SetFieldFilter(F_TrackSpec_SourceType, LowLevelDP.Integer2Text(DATABASE::"Transfer Line"));
                            //ar_TrackingSpecification.SetFieldFilter(F_TrackSpec_SourceSubtype, LowLevelDP.Integer2Text(1)); //Fixed for Transfer Order
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceID, ar_WhseTransferLines.TextField(F_TransLine_DocumentNo));
                            ar_TrackSpec.SetFieldFilter(F_TrackSpec_SourceRefNo, ar_WhseTransferLines.TextField(F_TransLine_LineNo));
                            //ar_TrackingSpecification.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                            if ar_TrackSpec.FindRecord then repeat Clear(UOMAssistMgt);
                                    Clear(TrackingQty);
                                    TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_WhseTransferLines.TextField(F_TransLine_ItemNo), ar_TrackSpec.DecimalField(F_TrackSpec_QuantityBase), ar_WhseTransferLines.TextField(F_TransLine_UnitofMeasureCode), Item."Base Unit of Measure");
                                    TrackAssistMgt.CreateTracking_TL(TransferLine, TrackingQty, TransferLine."Qty. per Unit of Measure", 0D, 0D, ar_TrackSpec.TextField(F_TrackSpec_SerialNo), ar_TrackSpec.TextField(F_TrackSpec_LotNo), ar_TrackSpec.TextField(F_TrackSpec_PackageNo));
                                until not ar_TrackSpec.NextRecord;
                        end;
                    end;
                until not ar_WhseTransferLines.NextRecord;
        end;
        #endregion 
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessPhysInventory()
    var
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        Item: Record Item;
        Location: Record Location;
        ar_ItemJnlLine: Codeunit DYM_ActiveRecManagement;
        ar_ReservEntry: Codeunit DYM_ActiveRecManagement;
        QtyBase: Decimal;
        IsHandled: Boolean;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        fLineNo: Text;
        fItemNo: Text;
        fUOMCode: Text;
        fQuantity: Decimal;
        fLocationCode: Text;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        Clear(IsHandled);
        WhseEventPub.OnProcessPhysInventory(IsHandled);
        if IsHandled then exit;
        if not ar_ItemJnlLine.ReadTable(T_StockTakeLine)then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_ItemJournalTemplate);
        SettingsMgt.TestSetting(ConstMgt.BOS_ItemJournalBatch);
        clear(JournalTemplateName);
        clear(JournalBatchName);
        JournalTemplateName:=SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalTemplate);
        JournalBatchName:=SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalBatch);
        if not ItemJnlBatch.Get(JournalTemplateName, JournalBatchName)then Clear(ItemJnlBatch);
        ar_ItemJnlLine.ReadTable(T_StockTakeLine);
        ar_ItemJnlLine.SetFieldFilter(F_StockTakeLine_Advanced, LowLevelDP.Integer2Text(0));
        if ar_ItemJnlLine.FindRecord then repeat clear(fLineNo);
                clear(fItemNo);
                clear(fUOMCode);
                clear(fQuantity);
                clear(fLocationCode);
                fLineNo:=ar_ItemJnlLine.TextField(F_StockTakeLine_LineNo);
                fItemNo:=ar_ItemJnlLine.TextField(F_StockTakeLine_ItemNo);
                fUOMCode:=ar_ItemJnlLine.TextField(F_StockTakeLine_UnitofMeasureCode);
                fQuantity:=ar_ItemJnlLine.DecimalField(F_StockTakeLine_QtyPhysInv);
                fLocationCode:=ar_ItemJnlLine.TextField(F_StockTakeLine_LocationCode);
                case TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")of true: begin
                    ar_ReservEntry.ReadTable(T_TrackSpec);
                    ar_ReservEntry.SetFieldFilter(F_TrackSpec_SourceRefNo, fLineNo);
                    if ar_ReservEntry.FindRecord()then repeat WHHelper.HandleItemJnlLine_NP(Enum::DYM_ItemJournalHandlingType::PhysInventory, JournalTemplateName, JournalBatchName, fItemNo, fUOMCode, fLocationCode, 0, ar_ReservEntry.DecimalField(F_TrackSpec_QuantityBase), ar_ReservEntry.TextField(F_TrackSpec_SerialNo), ar_ReservEntry.TextField(F_TrackSpec_LotNo), ar_ReservEntry.TextField(F_TrackSpec_PackageNo), ar_ReservEntry.DateField(F_TrackSpec_ExpirationDate));
                        until not ar_ReservEntry.NextRecord();
                end;
                false: begin
                    WHHelper.HandleItemJnlLine_NP_NT(Enum::DYM_ItemJournalHandlingType::PhysInventory, JournalTemplateName, JournalBatchName, fItemNo, fUOMCode, fLocationCode, 0, fQuantity);
                end;
                end;
                DataLogMgt.LogDataOp_Create(RecRef);
            until not ar_ItemJnlLine.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessBarcode()
    var
        ar_Barcode: Codeunit DYM_ActiveRecManagement;
        ItemRefference: Record "Item Reference";
        CrossReference, ItemNo, UnitOfMeasure: Text;
        IsHandled: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_Barcode.ReadTable(T_CrossRef)then exit;
        Clear(IsHandled);
        WhseEventPub.OnProcessBarcode(IsHandled);
        if IsHandled then exit;
        ar_Barcode.ReadTable(T_CrossRef);
        if(ar_Barcode.FindRecord())then repeat ItemNo:=ar_Barcode.TextField(F_CrossRef_ItemNo);
                CrossReference:=ar_Barcode.TextField(F_CrossRef_CrossReferenceNo);
                UnitOfMeasure:=ar_Barcode.TextField(F_CrossRef_UnitOfMeasure);
                ItemRefference.Reset();
                ItemRefference.SetRange("Item No.", ItemNo);
                ItemRefference.SetRange("Reference No.", CrossReference);
                ItemRefference.SetRange("Unit of Measure", UnitOfMeasure);
                if(ItemRefference.FindFirst())then begin
                    Error(StrSubstNo(Text006, CrossReference, ItemNo, UnitOfMeasure));
                end
                else
                begin
                    Clear(ItemRefference);
                    ItemRefference.Init();
                    ItemRefference.Validate("Item No.", ItemNo);
                    ItemRefference.Validate("Reference No.", CrossReference);
                    ItemRefference.Validate("Unit of Measure", UnitOfMeasure);
                    ItemRefference.Validate("Reference Type", ItemRefference."Reference Type"::"Bar Code");
                    ItemRefference.Insert();
                    RecRef.GETTABLE(ItemRefference);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
            until not ar_Barcode.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessProdOutput()
    var
        ar_ProdOrder: Codeunit DYM_ActiveRecManagement;
        ar_ProdOrderLine: Codeunit DYM_ActiveRecManagement;
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        fProdOrderStatus: Enum "Production Order Status";
        fProdOrderNo: Text;
        fLineNo: Integer;
        fItemNo: Text;
        fUOMCode: Text;
        fQuantity: Decimal;
        fLocationCode: Text;
        fOperationNo: Text;
        pLotNo: Text;
        pExpirationDate: Date;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        ar_ProdOrder.ReadTable(T_ProdOrder);
        if ar_ProdOrder.FindRecord()then repeat SettingsMgt.TestSetting(ConstMgt.BOS_Prod_Output_JournalTemplate());
                SettingsMgt.TestSetting(ConstMgt.BOS_Prod_Output_JournalBatch());
                JournalTemplateName:=SettingsMgt.GetSetting(ConstMgt.BOS_Prod_Output_JournalTemplate());
                JournalBatchName:=SettingsMgt.GetSetting(ConstMgt.BOS_Prod_Output_JournalBatch());
                ar_ProdOrderLine.ReadTable(T_ProdOrderLines);
                if ar_ProdOrderLine.FindRecord()then repeat clear(pLotNo);
                        clear(pExpirationDate);
                        fLocationCode:=ar_ProdOrder.TextField(F_ProdOrder_LocationCode);
                        fProdOrderStatus:=Enum::"Production Order Status".FromInteger(LowLevelDP.Text2OptionValue(O_ProdOrderLines_ProdOrderStatus, ar_ProdOrderLine.TextField(F_ProdOrderLines_ProdOrderStatus)));
                        fProdOrderNo:=ar_ProdOrderLine.TextField(F_ProdOrderLines_ProdOrderNo);
                        fLineNo:=ar_ProdOrderLine.IntegerField(F_ProdOrderLines_LineNo);
                        fItemNo:=ar_ProdOrderLine.TextField(F_ProdOrderLines_ItemNo);
                        fQuantity:=ar_ProdOrderLine.DecimalField(F_ProdOrderLines_QtyToProcess);
                        fOperationNo:=ar_ProdOrderLine.TextField(F_ProdOrderLines_OperationNo);
                        ProdOrderLine.Get(fProdOrderStatus, fProdOrderNo, fLineNo);
                        Item.Get(fItemNo);
                        //Assign tracking to Prod. Order Line
                        if(TrackAssistMgt.CheckIfItemTrackingIsEnabled(fItemNo))then begin
                            if TrackAssistMgt.CheckReservEntryExist(ProdOrderLine)then begin
                                pLotNo:=TrackAssistMgt.GetReservEntryLot(ProdOrderLine);
                                pExpirationDate:=TrackAssistMgt.GetReservEntryExpirationDate(ProdOrderLine);
                            end
                            else if(Item."Lot Nos." <> '')then begin
                                    pLotNo:=NoSeriesMgt.GetNextNo(Item."Lot Nos.", Today, true);
                                    if(Format(Item."Expiration Calculation") <> '')then pExpirationDate:=CalcDate(Item."Expiration Calculation");
                                    TrackAssistMgt.CreateTracking_POL(ProdOrderLine, pExpirationDate, 0D, '', pLotNo, '');
                                end;
                        end;
                        WHHelper.HandleItemJnlLine(Enum::DYM_ItemJournalHandlingType::Output, JournalTemplateName, JournalBatchName, fItemNo, fUOMCode, fLocationCode, 0, fQuantity, '', pLotNo, '', pExpirationDate, ar_ProdOrderLine.TextField(F_ProdOrderLines_ProdOrderNo), ar_ProdOrderLine.IntegerField(F_ProdOrderLines_LineNo), 0, fOperationNo);
                    until not ar_ProdOrderLine.NextRecord();
            until not ar_ProdOrder.NextRecord();
    end;
    procedure PushProcessConsumption()
    var
        ar_ProdOrderLine: Codeunit DYM_ActiveRecManagement;
        ar_ProdOrderComp: Codeunit DYM_ActiveRecManagement;
        ar_ReservEntry: Codeunit DYM_ActiveRecManagement;
        ProdOrderComp: Record "Prod. Order Component";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        fProdOrderStatus: Enum "Production Order Status";
        fProdOrderNo: Text;
        fProdOrderLineNo: Integer;
        fLineNo: Integer;
        fItemNo: Text;
        fUOMCode: Text;
        fQuantity: Decimal;
        fLocationCode: Text;
        fIsCustomAdded: Boolean;
        pLotNo: Text;
        pExpirationDate: Date;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        //If not having Prod. Order Component lines then exit
        if not ar_ProdOrderComp.ReadTable(T_ProdOrderComp)then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_Prod_Consump_JournalTemplate());
        SettingsMgt.TestSetting(ConstMgt.BOS_Prod_Consump_JournalBatch());
        JournalTemplateName:=SettingsMgt.GetSetting(ConstMgt.BOS_Prod_Consump_JournalTemplate());
        JournalBatchName:=SettingsMgt.GetSetting(ConstMgt.BOS_Prod_Consump_JournalBatch());
        ar_ProdOrderLine.ReadTable(T_ProdOrderLines);
        if ar_ProdOrderLine.FindRecord()then repeat ar_ProdOrderComp.ReadTable(T_ProdOrderComp);
                ar_ProdOrderComp.SetFieldFilter(F_ProdOrderComp_ProdOrderLineNo, ar_ProdOrderLine.TextField(F_ProdOrderLines_LineNo));
                if ar_ProdOrderComp.FindRecord()then repeat fProdOrderStatus:=Enum::"Production Order Status".FromInteger(LowLevelDP.Text2OptionValue(O_ProdOrderLines_ProdOrderStatus, ar_ProdOrderLine.TextField(F_ProdOrderLines_ProdOrderStatus)));
                        fProdOrderNo:=ar_ProdOrderComp.TextField(F_ProdOrderComp_ProdOrderNo);
                        fProdOrderLineNo:=ar_ProdOrderComp.IntegerField(F_ProdOrderComp_ProdOrderLineNo);
                        fLineNo:=ar_ProdOrderComp.IntegerField(F_ProdOrderComp_LineNo);
                        fItemNo:=ar_ProdOrderComp.TextField(F_ProdOrderComp_ItemNo);
                        fQuantity:=ar_ProdOrderComp.DecimalField(F_ProdOrderComp_QtyToProcess);
                        fLocationCode:=ar_ProdOrderComp.TextField(F_ProdOrderComp_LocationCode);
                        fIsCustomAdded:=ar_ProdOrderComp.BooleanField(F_ProdOrderComp_IsCustomAdded);
                        //Item.Get(fItemNo);
                        case fIsCustomAdded of false: ProdOrderComp.Get(fProdOrderStatus, fProdOrderNo, fProdOrderLineNo, fLineNo);
                        true: Clear(fLineNo);
                        end;
                        if(TrackAssistMgt.CheckIfItemTrackingIsEnabled(fItemNo))then begin
                            Clear(pLotNo);
                            ar_ReservEntry.ReadTable(T_TrackSpec);
                            ar_ReservEntry.SetFieldFilter(F_TrackSpec_SourceRefNo, LowLevelDP.Integer2Text(fLineNo));
                            if ar_ReservEntry.FindRecord()then repeat pLotNo:=ar_ReservEntry.TextField(F_TrackSpec_LotNo);
                                    fQuantity:=ar_ReservEntry.DecimalField(F_TrackSpec_QuantityBase);
                                    //Expiration date is retrieved from Item Ledger Entries for negative entries
                                    Clear(pExpirationDate);
                                    WHHelper.HandleItemJnlLine(Enum::DYM_ItemJournalHandlingType::Consumption, JournalTemplateName, JournalBatchName, fItemNo, fUOMCode, fLocationCode, 0, fQuantity, '', pLotNo, '', pExpirationDate, fProdOrderNo, fProdOrderLineNo, fLineNo, '');
                                until not ar_ReservEntry.NextRecord();
                        end
                        else
                        begin
                            Clear(pLotNo);
                            Clear(pExpirationDate);
                            WHHelper.HandleItemJnlLine(Enum::DYM_ItemJournalHandlingType::Consumption, JournalTemplateName, JournalBatchName, fItemNo, fUOMCode, fLocationCode, 0, fQuantity, '', pLotNo, '', pExpirationDate, fProdOrderNo, fProdOrderLineNo, fLineNo, '');
                        end;
                    until not ar_ProdOrderComp.NextRecord();
            until not ar_ProdOrderLine.NextRecord();
    end;
    procedure PushProcessBin()
    var
        ar_Bin: Codeunit DYM_ActiveRecManagement;
        Bin: Record Bin;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not ar_Bin.ReadTable(T_Bin)then exit;
        if ar_Bin.FindRecord()then repeat Bin.Get(ar_Bin.TextField(F_Bin_LocationCode), ar_Bin.TextField(F_Bin_Code));
                Bin.Validate("Block Movement", LowLevelDP.Text2OptionValue(O_Bin_BlockMovement, ar_Bin.TextField(F_Bin_BlockMovement)));
                Bin.Modify(true);
                RecRef.GetTable(Bin);
                DataLogMgt.LogDataOp_Modify(RecRef);
            until not ar_Bin.NextRecord();
    end;
    procedure PushProcessWhseJnlLine()
    var
        ar_WhseJnlLine: Codeunit DYM_ActiveRecManagement;
        WhseJnlTemplate: Record "Warehouse Journal Template";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        WhseJnlLine: Record "Warehouse Journal Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        JournalLocationCode: Code[10];
        EntryType: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not ar_WhseJnlLine.ReadTable(T_WhseJnlLine)then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_StockCorrection_WhseJournalTemplate());
        SettingsMgt.TestSetting(ConstMgt.BOS_StockCorrection_WhseJournalBatch());
        //SettingsMgt.TestSetting(ConstMgt.BOS_StockCorrection_WhseJournalLocation());
        JournalTemplateName:=SettingsMgt.GetSetting(ConstMgt.BOS_StockCorrection_WhseJournalTemplate());
        JournalBatchName:=SettingsMgt.GetSetting(ConstMgt.BOS_StockCorrection_WhseJournalBatch());
        //JournalLocationCode := SettingsMgt.GetSetting(ConstMgt.BOS_StockCorrection_WhseJournalLocation());
        if ar_WhseJnlLine.FindRecord()then repeat JournalLocationCode:=ar_WhseJnlLine.TextField(F_WhseJnlLine_LocationCode);
                WhseJnlBatch.Get(JournalTemplateName, JournalBatchName, JournalLocationCode);
                WhseJnlBatch.TestField("No. Series", '');
                case ar_WhseJnlLine.TextField(F_WhseJnlLine_CorrectionType)of O_WhseJnlLine_CorrectionType_Negative: EntryType:=0;
                O_WhseJnlLine_CorrectionType_Positive: EntryType:=1;
                else
                    EntryType:=ar_WhseJnlLine.IntegerField(F_WhseJnlLine_CorrectionType);
                end;
                WHHelper.HandleWhseJnlLine(Enum::DYM_ItemJournalHandlingType::StockCorrection, JournalTemplateName, JournalBatchName, EntryType, ar_WhseJnlLine.TextField(F_WhseJnlLine_ItemNo), ar_WhseJnlLine.TextField(F_WhseJnlLine_VariantCode), ar_WhseJnlLine.TextField(F_WhseJnlLine_UOMCode), ar_WhseJnlLine.TextField(F_WhseJnlLine_LocationCode), ar_WhseJnlLine.TextField(F_WhseJnlLine_ZoneCode), ar_WhseJnlLine.TextField(F_WhseJnlLine_BinCode), ar_WhseJnlLine.DecimalField(F_WhseJnlLine_Quantity), ar_WhseJnlLine.TextField(F_WhseJnlLine_SerialNo), ar_WhseJnlLine.TextField(F_WhseJnlLine_LotNo), ar_WhseJnlLine.TextField(F_WhseJnlLine_PackageNo), ar_WhseJnlLine.ODDateField(F_WhseJnlLine_ExpirationDate));
            until not ar_WhseJnlLine.NextRecord();
    end;
    procedure PushProcessNewTransfer()
    var
        ar_TransferHeader: Codeunit DYM_ActiveRecManagement;
        ar_TransferLine: Codeunit DYM_ActiveRecManagement;
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        NextLineNo: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        ar_TransferHeader.ReadTable(T_TransHead);
        IF ar_TransferHeader.FindRecord THEN REPEAT if(ar_TransferHeader.BooleanField(F_TransHead_IsNewTransfer))then begin
                    TransferHeader.INIT;
                    TransferHeader.VALIDATE("Transfer-from Code", ar_TransferHeader.TextField(F_TransHead_TransferFromCode));
                    TransferHeader.VALIDATE("Transfer-to Code", ar_TransferHeader.TextField(F_TransHead_TransferToCode));
                    if((TransferHeader."In-Transit Code" = '') and (SettingsMgt.CheckSetting(ConstMgt.BOS_TransferDefaultInTransitLocation())))then TransferHeader.Validate("In-Transit Code", SettingsMgt.GetSetting(ConstMgt.BOS_TransferDefaultInTransitLocation()));
                    TransferHeader.INSERT(TRUE);
                    //TransferHeader.VALIDATE("Direct Transfer", TRUE);
                    TransferHeader.VALIDATE("External Document No.", ar_TransferHeader.TextField(F_TransHead_No));
                    TransferHeader.MODIFY(TRUE);
                    CacheMgt.SetRecordMapCache(DATABASE::"Transfer Header", ar_TransferHeader.TextField(F_TransHead_No), TransferHeader.GETPOSITION(FALSE));
                    RecRef.GETTABLE(TransferHeader);
                    DataLogMgt.LogDataOp_Create(RecRef);
                    CLEAR(NextLineNo);
                    ar_TransferLine.ReadTable(T_TransLine);
                    IF ar_TransferLine.FindRecord THEN REPEAT NextLineNo+=10000;
                            TransferLine.INIT;
                            TransferLine.VALIDATE("Document No.", TransferHeader."No.");
                            TransferLine.VALIDATE("Line No.", NextLineNo);
                            TransferLine.VALIDATE("Item No.", ar_TransferLine.TextField(F_TransLine_ItemNo));
                            TransferLine.VALIDATE("Unit of Measure Code", ar_TransferLine.TextField(F_TransLine_UnitofMeasureCode));
                            TransferLine.VALIDATE(Quantity, ar_TransferLine.DecimalField(F_TransLine_Quantity));
                            TransferLine.VALIDATE("Qty. to Ship", TransferLine.Quantity);
                            TransferLine.VALIDATE("Qty. to Receive", TransferLine.Quantity);
                            TransferLine.INSERT(TRUE);
                            RecordLinkMgt.SetRecordLink(T_TransLine, ar_TransferLine.TextField(ConstMgt.SYS_DMSRowId()), Database::"Transfer Line", TransferLine.SystemId);
                            RecRef.GETTABLE(TransferLine);
                            DataLogMgt.LogDataOp_Create(RecRef);
                        UNTIL NOT ar_TransferLine.NextRecord;
                    RecRef.GETTABLE(TransferHeader);
                    PostProcessMgt.LogPostProcessOperation(RecRef, Enum::DYM_PostProcessOperationType::Post, '', 0, false, '')end;
            UNTIL NOT ar_TransferHeader.NextRecord;
    end;
    #endregion 
    #region Pull
    procedure PullProcessDynamicsMobileSetup(var DynamicsMobileSetup: Record DYM_DynamicsMobileSetup; var DynamicsMobileSetupBuffer: Record DYM_DynamicsMobileSetup)
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if DynamicsMobileSetup.Get then begin
            DynamicsMobileSetupBuffer.Init;
            DynamicsMobileSetupBuffer.Copy(DynamicsMobileSetup);
            DynamicsMobileSetupBuffer.Insert;
        end;
    end;
#endregion 
}
