codeunit 84200 DYM_SL_DataProcess
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
        PreProcess;
        PushProcessDeviceActivity;
        PushProcessCustomer;
        PushProcessSalesDocs;
        PushProcessPayments;
        PushProcessTransferDocs;
        PushProcessTracking;
        PushProcessPhysInventory;
    end;
    var MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    CacheMgt: Codeunit DYM_CacheManagement;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    DataLogMgt: Codeunit DYM_DataLogManagement;
    EventLogMgt: Codeunit DYM_EventLogManagement;
    DebugMgt: Codeunit DYM_DebugManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    GeneralDP: Codeunit DYM_GeneralDataProcess;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    UOMAssistMgt: Codeunit DYM_UOMAssistManagement;
    TrackAssistMgt: Codeunit DYM_TrackAssistManagement;
    PostProcessMgt: Codeunit DYM_PostProcessManagement;
    RecordLinkMgt: Codeunit DYM_RecordLinkManagement;
    SalesHelper: Codeunit DYM_SL_Helper;
    SalesEventPub: Codeunit DYM_SL_EventPublishers;
    TableBufMgt: Codeunit DYM_TableBufferManagement;
    RecRef: RecordRef;
    FldRef: FieldRef;
    SLE: Integer;
    SetupRead: Boolean;
    //"*** Tag definition ***": ;
    Text001: Label 'You cannot ship this document directly as location %1 requires Warehouse Shipment.';
    Text002: Label 'You need to provide customer number for Sales processing.';
    Text003: Label 'You need to provide item number for Sales processing.';
    Text004: Label 'You need to provide customer number for Payment processing.';
    Text005: Label 'You need to provide paid amount for Payment processing.';
    Text007: Label 'You need to provide item number for Transfer processing.';
    Text008: Label 'You need to provide quantity for Transfer processing.';
    //Generic
    F_Generic_DMSROWID: Label 'DMS_ROWID', Locked = true;
    //SalesHeader
    T_SalesHeader: Label 'SalesHeader', Locked = true;
    F_SalesHeader_DocumentType: Label 'DocumentType', Locked = true;
    F_SalesHeader_SelltoCustomerNo: Label 'SelltoCustomerNo', Locked = true;
    F_SalesHeader_No: Label 'No', Locked = true;
    F_SalesHeader_DocumentDate: Label 'DocumentDate', Locked = true;
    F_SalesHeader_OrderDate: Label 'OrderDate', Locked = true;
    F_SalesHeader_PostingDate: Label 'PostingDate', Locked = true;
    F_SalesHeader_BilltoCustomerNo: Label 'BilltoCustomerNo', Locked = true;
    F_SalesHeader_ShiptoCode: Label 'ShiptoCode', Locked = true;
    F_SalesHeader_PaymentMethodCode: Label 'PaymentMethodCode', Locked = true;
    F_SalesHeader_PaymentTermsCode: Label 'PaymentTermsCode', Locked = true;
    F_SalesHeader_LocationCode: Label 'LocationCode', Locked = true;
    F_SalesHeader_ShipmentDate: Label 'ShipmentDate', Locked = true;
    F_SalesHeader_ShippingAgentCode: Label 'ShippingAgentCode', Locked = true;
    F_SalesHeader_RequestedDeliveryDate: Label 'RequestedDeliveryDate', Locked = true;
    F_SalesHeader_SalespersonCode: Label 'SalespersonCode', Locked = true;
    F_SalesHeader_InvoiceDiscountValue: Label 'InvoiceDiscountValue', Locked = true;
    F_SalesHeader_Signature: Label 'DYM_Signature', Locked = true;
    F_SalesHeader_ReturnReason: Label 'ReturnReason', Locked = true;
    F_SalesHeader_SourceDocumentNo: Label 'SourceDocumentNo', Locked = true;
    F_SalesHeader_IsDeliveryNoteOnly: Label 'isDeliveryNoteOnly', Locked = true;
    F_SalesHeader_DiscountPercentFromDeal: Label 'discountPercentFromDeal', Locked = true;
    F_SalesHeader_DiscountAmountFromDeal: Label 'discountAmountFromDeal', Locked = true;
    F_SalesHeader_TotalAmountDealCode: Label 'totalAmountDealCode', Locked = true;
    F_SalesHeader_TotalAmountGroupCode: Label 'totalAmountGroupCode', Locked = true;
    //SalesLine
    T_SalesLines: Label 'SalesLine', Locked = true;
    F_SalesLines_DocumentType: Label 'DocumentType', Locked = true;
    F_SalesLines_ActionType: Label 'actionType', Locked = true;
    F_SalesLines_DocumentNo: Label 'DocumentNo', Locked = true;
    F_SalesLines_LineNo: Label 'LineNo', Locked = true;
    F_SalesLines_Type: Label 'Type', Locked = true;
    F_SalesLines_No: Label 'No', Locked = true;
    F_SalesLines_LocationCode: Label 'LocationCode', Locked = true;
    F_SalesLines_VariantCode: Label 'VariantCode', Locked = true;
    F_SalesLines_UnitofMeasureCode: Label 'UnitofMeasureCode', Locked = true;
    F_SalesLines_Quantity: Label 'Quantity', Locked = true;
    F_SalesLines_UnitPrice: Label 'UnitPrice', Locked = true;
    F_SalesLines_LineDiscountAmount: Label 'LineDiscountAmount', Locked = true;
    E_SalesLines_ActionType_Return: Label '0', Locked = true;
    F_SalesLines_QuantityToShip: Label 'QuantityToShip', Locked = true;
    F_SalesLines_ReturnInventTransId: Label 'returnInventTransId', Locked = true;
    F_SalesLines_GroupCode: Label 'groupCode', Locked = true;
    F_SalesLines_DealCode: Label 'dealCode', Locked = true;
    F_SalesLines_DealDiscountPercent: Label 'dealDiscountPercent', Locked = true;
    F_SalesLines_HasDealPercent: Label 'hasDiscountFromDeal', Locked = true;
    F_SalesLines_TotalDiscount: Label 'totalLineDiscountPercent', Locked = true;
    F_SalesLine_IsDealItem: Label 'isDealItem', Locked = true;
    //Customer
    T_Customer: Label 'Customer', Locked = true;
    F_Customer_No: Label 'No', Locked = true;
    F_Customer_Name: Label 'Name', Locked = true;
    F_Customer_Address: Label 'Address', Locked = true;
    F_Customer_City: Label 'City', Locked = true;
    F_Customer_Contact: Label 'Contact', Locked = true;
    F_Customer_PhoneNo: Label 'PhoneNo', Locked = true;
    F_Customer_CustDiscountGroup: Label 'CustDiscountGroup', Locked = true;
    F_Customer_Latitude: Label 'DYM_Latitude', Locked = true;
    F_Customer_Longitude: Label 'DYM_Longitude', Locked = true;
    F_Customer_ShipToCode: Label 'ShipToCode', Locked = true;
    //TrackingSpecification
    T_TrackingSpecification: Label 'TrackingSpecification', Locked = true;
    F_TrackingSpecification_ItemNo: Label 'ItemNo', Locked = true;
    F_TrackingSpecification_VariantCode: Label 'VariantCode', Locked = true;
    F_TrackingSpecification_SourceType: Label 'SourceType', Locked = true;
    F_TrackingSpecification_SourceSubtype: Label 'SourceSubtype', Locked = true;
    F_TrackingSpecification_SourceID: Label 'SourceID', Locked = true;
    F_TrackingSpecification_SourceRefNo: Label 'SourceRefNo', Locked = true;
    F_TrackingSpecification_SerialNo: Label 'SerialNo', Locked = true;
    F_TrackingSpecification_LotNo: Label 'LotNo', Locked = true;
    F_TrackingSpecification_PackageNo: Label 'PackageNo', Locked = true;
    F_TrackingSpecification_ExpirationDate: Label 'ExpirationDate', Locked = true;
    F_TrackingSpecification_QuantityBase: Label 'QuantityBase', Locked = true;
    F_TrackingSpecification_QtytoHandleBase: Label 'QtytoHandleBase', Locked = true;
    //PaymentHeader
    T_PaymentHeader: Label 'PaymentHeader', Locked = true;
    F_PaymentHeader_no: Label 'no', Locked = true;
    F_PaymentHeader_customerNo: Label 'customerNo', Locked = true;
    F_PaymentHeader_dateCreated: Label 'dateCreated', Locked = true;
    F_PaymentHeader_DocumentType: Label 'DocumentType', Locked = true;
    F_PaymentHeader_paidAmount: Label 'paidAmount', Locked = true;
    F_PaymentHeader_totalAmount: Label 'totalAmount', Locked = true;
    //PaymentLine
    T_PaymentLine: Label 'PaymentLine', Locked = true;
    F_PaymentLine_documentNo: Label 'documentNo', Locked = true;
    F_PaymentLine_openTransId: Label 'openTransId', Locked = true;
    F_PaymentLine_amount: label 'amount', Locked = true;
    //TransferHeader
    T_TransferHeader: Label 'TransferHeader', Locked = true;
    F_TransferHeader_No: Label 'No', Locked = true;
    F_TransferHeader_TransferfromCode: Label 'TransferfromCode', Locked = true;
    F_TransferHeader_TransfertoCode: Label 'TransfertoCode', Locked = true;
    F_TransferHeader_PostingDate: Label 'PostingDate', Locked = true;
    //TransferLine
    T_TransferLine: Label 'TransferLine', Locked = true;
    F_TransferLine_DocumentNo: Label 'DocumentNo', Locked = true;
    F_TransferLine_LineNo: Label 'LineNo', Locked = true;
    F_TransferLine_ItemNo: Label 'ItemNo', Locked = true;
    F_TransferLine_Quantity: Label 'Quantity', Locked = true;
    F_TransferLine_UnitofMeasureCode: Label 'UnitofMeasureCode', Locked = true;
    //Snapshot
    T_Snapshot: Label 'Snapshot', Locked = true;
    F_Snapshot_ImageName: Label 'imageName', Locked = true;
    F_Snapshot_EntityName: Label 'entityName', Locked = true;
    F_Snapshot_EntityDMSROWID: Label 'entityDMSROWID', Locked = true;
    //Stock Take Line
    T_StockTakeLine: Label 'StockCountLineInventory', Locked = true;
    F_StockTakeLine_Date: Label 'date', Locked = true;
    F_StockTakeLine_LocationCode: Label 'locationCode', Locked = true;
    F_StockTakeLine_ItemNo: Label 'itemNo', Locked = true;
    F_StockTakeLine_Qty: Label 'quantity', Locked = true;
    F_StockTakeLine_Differrence: Label 'difference', Locked = true;
    F_StockTakeLine_QtyCalc: Label 'QuantityCalculated', Locked = true;
    F_StockTakeLine_QtyPhysInv: Label 'qtyBase', Locked = true;
    F_StockTakeLine_BinCode: Label 'binCode', Locked = true;
    F_StockTakeLine_UnitofMeasureCode: Label 'unitOfMeasure', Locked = true;
    F_StockTakeLine_LotNo: Label 'lotNo', Locked = true;
    F_StockTakeLine_LotExpirationDate: Label 'LotExpirationDate', Locked = true;
    F_StockTakeLine_SerialNo: Label 'serialNo', Locked = true;
    F_StockTakeLine_LineNo: Label 'lineNo', Locked = true;
    //Customer Activity
    T_CustomerActivity: Label 'CustomerActivity', Locked = true;
    F_CustomerActivity_CustomerNo: Label 'CustomerNo', Locked = true;
    F_CustomerActivity_CustomerTitle: Label 'CustomerTitle', Locked = true;
    F_CustomerActivity_DocumentNo: Label 'DocumentNo', Locked = true;
    F_CustomerActivity_IsDistanceValid: Label 'IsDistanceValid', Locked = true;
    F_CustomerActivity_VisitNo: Label 'VisitNo', Locked = true;
    F_CustomerActivity_OnDate: Label 'OnDate', Locked = true;
    F_CustomerActivity_InRoute: Label 'InRoute', Locked = true;
    F_CustomerActivity_Distance: Label 'Distance', Locked = true;
    F_CustomerActivity_Duration: Label 'Duration', Locked = true;
    F_CustomerActivity_Action: Label 'Action', Locked = true;
    F_CustomerActivity_Longitude: Label 'cLong', Locked = true;
    F_CustomerActivity_Latitude: Label 'Lat', Locked = true;
    F_CustomerActivity_Amount: Label 'Amount', Locked = true;
    F_CustomerActivity_Comment: Label 'Comment', Locked = true;
    F_CustomerActivity_MaxVisitDuration: Label 'MaxVisitDuration', Locked = true;
    F_CustomerActivity_MaxVisitDurationExcReasonCode: Label 'MaxVisitDurationExcReasonCode', Locked = true;
    #region Push
    procedure PushProcessSalesDocs()
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        Salesperson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
        Item: Record Item;
        ICAS: Record "Item Charge Assignment (Sales)";
        Currency: Record Currency;
        ReturnReason: record "Return Reason";
        ItemChargeAssSales: Codeunit "Item Charge Assgnt. (Sales)";
        ar_SalesHeader: Codeunit DYM_ActiveRecManagement;
        ar_SalesLines: Codeunit DYM_ActiveRecManagement;
        ar_SalesDocLineDisc: Codeunit DYM_ActiveRecManagement;
        NextLineNo: Integer;
        BlockCust: enum "Customer Blocked";
        SourceDocumentNo: Text;
        IsHandled, BlockItem, IsDelivery, IsDeliveryNoteOnly: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_SalesHeader.ReadTable(T_SalesHeader)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessSales(IsHandled);
        if IsHandled then exit;
        ar_SalesHeader.ReadTable(T_SalesHeader);
        ar_SalesHeader.SetFieldFilter(F_SalesHeader_DocumentType, StrSubstNo('%1|%2|%3|%4', 0, 1, 2, 8)); // Order, Invoice, Sales Return Order, Delivery
        if ar_SalesHeader.FindRecord then repeat CacheMgt.SetStateDescription(StrSubstNo(ConstMgt.MSG_0009, ar_SalesHeader.GetTableName, ar_SalesHeader.ActiveRecPK2Text));
                DataLogMgt.LogActiveRecOp(ar_SalesHeader.GetTableName, ar_SalesHeader.ActiveRecPK2Text);
                if(ar_SalesHeader.TextField(F_SalesHeader_SelltoCustomerNo) = '')then Error(Text002);
                Clear(BlockCust);
                if not Customer.Get(ar_SalesHeader.TextField(F_SalesHeader_SelltoCustomerNo))then Clear(Customer);
                if(Customer.Blocked <> Customer.Blocked::" ")then if SettingsMgt.CheckSetting(ConstMgt.BOS_ProcessBlockedCustomers)then begin
                        BlockCust:=Customer.Blocked;
                        Customer.Blocked:=Customer.Blocked::" ";
                        Customer.Modify;
                    end;
                SalesHeader.Init;
                case ar_SalesHeader.IntegerField(F_SalesHeader_DocumentType)of 0: //Order
 begin
                    if(SettingsMgt.GetSetting(ConstMgt.BOS_SalesOrderNos) <> '')then SalesHeader.Validate("No. Series", SettingsMgt.GetSetting(ConstMgt.BOS_SalesOrderNos));
                    Clear(SalesHeader."No.");
                    SalesHeader.Validate("Document Type", enum::"Sales Document Type"::Order);
                end;
                1: //Invoice
 begin
                    SalesHeader.Validate("Document Type", enum::"Sales Document Type"::Invoice);
                    SalesHeader."No.":=ar_SalesHeader.TextField(F_SalesHeader_No);
                end;
                2: //Return Order
 begin
                    if(SettingsMgt.GetSetting(ConstMgt.BOS_SalesReturnOrderNos()) <> '')then SalesHeader.Validate("No. Series", SettingsMgt.GetSetting(ConstMgt.BOS_SalesReturnOrderNos()));
                    clear(SalesHeader."No.");
                    if(SettingsMgt.CheckSetting(ConstMgt.BOS_CreateCreditMemo()))then begin
                        SalesHeader.Validate("Document Type", enum::"Sales Document Type"::"Credit Memo");
                    end
                    else
                    begin
                        SalesHeader.Validate("Document Type", enum::"Sales Document Type"::"Return Order");
                    end;
                end;
                8: //Delivery
 begin
                    IsDeliveryNoteOnly:=ar_SalesHeader.BooleanField(F_SalesHeader_IsDeliveryNoteOnly);
                    IsDelivery:=true;
                    SourceDocumentNo:=ar_SalesHeader.TextField(F_SalesHeader_SourceDocumentNo);
                    SalesHeader.Get(SalesHeader."Document Type"::Order, SourceDocumentNo);
                end;
                end;
                if not IsDelivery then begin
                    SalesHeader.Insert(true);
                    RecordLinkMgt.SetRecordLink(T_SalesHeader, ar_SalesHeader.TextField(ConstMgt.SYS_DMSRowId()), Database::"Sales Header", SalesHeader.SystemId);
                    RecRef.GetTable(SalesHeader);
                    DataLogMgt.LogDataOp_Create(RecRef);
                    SalesHeader.SetHideValidationDialog(true);
                    SalesHeader.Validate("Document Date", ar_SalesHeader.DateField(F_SalesHeader_DocumentDate));
                    if(ar_SalesHeader.DateField(F_SalesHeader_OrderDate) <> 0D)then SalesHeader.Validate("Order Date", ar_SalesHeader.DateField(F_SalesHeader_OrderDate))
                    else
                        SalesHeader.Validate("Order Date", ar_SalesHeader.DateField(F_SalesHeader_DocumentDate));
                    if(ar_SalesHeader.DateField(F_SalesHeader_PostingDate) <> 0D)then SalesHeader.Validate("Posting Date", ar_SalesHeader.DateField(F_SalesHeader_PostingDate))
                    else
                        SalesHeader.Validate("Posting Date", ar_SalesHeader.DateField(F_SalesHeader_DocumentDate));
                    if(ar_SalesHeader.TextField(F_SalesHeader_SelltoCustomerNo) <> '')then SalesHeader.Validate("Sell-to Customer No.", ar_SalesHeader.TextField(F_SalesHeader_SelltoCustomerNo));
                    if(ar_SalesHeader.TextField(F_SalesHeader_BilltoCustomerNo) <> '')then SalesHeader.Validate("Bill-to Customer No.", ar_SalesHeader.TextField(F_SalesHeader_BilltoCustomerNo));
                    if((ar_SalesHeader.TextField(F_SalesHeader_SelltoCustomerNo) = '') AND (ar_SalesHeader.TextField(F_SalesHeader_BilltoCustomerNo) <> ''))then SalesHeader.Validate("Sell-to Customer No.", ar_SalesHeader.TextField(F_SalesHeader_BilltoCustomerNo));
                    //z
                    if(ar_SalesHeader.TextField(F_SalesHeader_ShiptoCode) <> '')then SalesHeader.Validate("Ship-to Code", ar_SalesHeader.TextField(F_SalesHeader_ShiptoCode));
                    SalesHeader.Validate("Payment Method Code", ar_SalesHeader.TextField(F_SalesHeader_PaymentMethodCode));
                    SalesHeader.Validate("Payment Terms Code", ar_SalesHeader.TextField(F_SalesHeader_PaymentTermsCode));
                    //z
                    SalesHeader.Validate("Location Code", ar_SalesHeader.TextField(F_SalesHeader_LocationCode));
                    if(ar_SalesHeader.TextField(F_SalesHeader_ShippingAgentCode) <> '')then SalesHeader.Validate("Shipping Agent Code", ar_SalesHeader.TextField(F_SalesHeader_ShippingAgentCode));
                    SalesHeader.Validate("Shipment Date", ar_SalesHeader.DateField(F_SalesHeader_ShipmentDate));
                    SalesHeader.Validate("Requested Delivery Date", ar_SalesHeader.DateField(F_SalesHeader_RequestedDeliveryDate));
                    SalesHeader.Validate("Salesperson Code", DeviceSetup."Salesperson Code");
                    SalesHeader."External Document No.":=ar_SalesHeader.TextField(F_SalesHeader_No);
                    SalesHeader.Validate(Reserve, SalesHeader.Reserve::Never);
                    //Deal Fields for Mix and Match
                    SalesHeader.Validate(DYM_DiscountAmountFromDeal, ar_SalesHeader.DecimalField(F_SalesHeader_DiscountAmountFromDeal));
                    SalesHeader.Validate(DYM_DiscountPercentFromDeal, ar_SalesHeader.DecimalField(F_SalesHeader_DiscountPercentFromDeal));
                    SalesHeader.Validate(DYM_TotalAmountDealCode, ar_SalesHeader.TextField(F_SalesHeader_TotalAmountDealCode));
                    SalesHeader.Validate(DYM_TotalAmountGroupCode, ar_SalesHeader.TextField(F_SalesHeader_TotalAmountGroupCode));
                    if(SalesHeader.DYM_DiscountPercentFromDeal <> 0)then begin
                        SalesHeader.Validate("Invoice Discount Calculation", SalesHeader."Invoice Discount Calculation"::"%");
                        SalesHeader.Validate("Invoice Discount Value", SalesHeader.DYM_DiscountPercentFromDeal);
                    end;
                    case ar_SalesHeader.IntegerField(F_SalesHeader_DocumentType)of 1: begin //Invoice
                        if(ar_SalesHeader.DecimalField(F_SalesHeader_InvoiceDiscountValue) <> 0)then begin
                            SalesHeader."Invoice Discount Calculation":=SalesHeader."Invoice Discount Calculation"::"%";
                            SalesHeader."Invoice Discount Value":=ar_SalesHeader.DecimalField(F_SalesHeader_InvoiceDiscountValue);
                        end;
                        SalesHeader."Posting No.":=ar_SalesHeader.TextField(F_SalesHeader_No);
                        Clear(SalesHeader."No. Series");
                        Clear(SalesHeader."Posting No. Series");
                    end;
                    2: begin //Return Order
                        if(ar_SalesHeader.TextField(F_SalesHeader_ReturnReason) <> '')then begin
                            ReturnReason.Get(ar_SalesHeader.TextField(F_SalesHeader_ReturnReason));
                            case ReturnReason.DYM_ReturnReasonType of DYM_ReturnReasonType::Inventory: begin
                                SettingsMgt.TestSetting(ConstMgt.BOS_InventWarehouseId());
                                SalesHeader.Validate("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_InventWarehouseId()));
                            end;
                            DYM_ReturnReasonType::Damaged: begin
                                SettingsMgt.TestSetting(ConstMgt.BOS_DamageWarehouseId());
                                SalesHeader.Validate("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_DamageWarehouseId()));
                            end;
                            end;
                        end;
                    end;
                    end;
                    SalesEventPub.OnProcessSales_AfterHeaderCreated(SalesHeader, ar_SalesHeader);
                    SalesHeader.Modify;
                end;
                RecRef.GetTable(SalesHeader);
                FldRef:=RecRef.Field(LowLevelDP.GetFieldByName(Database::"Sales Header", F_SalesHeader_Signature));
                ar_SalesHeader.BLOB2MediaFieldRef(F_SalesHeader_Signature, FldRef);
                RecRef.Modify();
                if not Salesperson.Get(SalesHeader."Salesperson Code")then Clear(Salesperson);
                SalesLines.Reset;
                SalesLines.SetRange("Document Type", SalesHeader."Document Type");
                SalesLines.SetRange("Document No.", SalesHeader."No.");
                SalesLines.DeleteAll(true);
                ar_SalesLines.ReadTable(T_SalesLines);
                //ar_SalesLines.SetFieldFilter(F_SalesLines_DocumentType, ar_SalesHeader.TextField(F_SalesHeader_DocumentType));
                ar_SalesLines.SetFieldFilter(F_SalesLines_DocumentNo, ar_SalesHeader.TextField(F_SalesHeader_No));
                if ar_SalesLines.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_SalesLines.GetTableName, ar_SalesLines.ActiveRecPK2Text);
                        if(ar_SalesLines.TextField(F_SalesLines_No) = '')then Error(Text003);
                        Clear(BlockItem);
                        if not Item.Get(ar_SalesLines.TextField(F_SalesLines_No))then Clear(Item);
                        if Item.Blocked then if SettingsMgt.CheckSetting(ConstMgt.BOS_ProcessBlockedItems)then begin
                                Item.Blocked:=false;
                                Item.Modify;
                                BlockItem:=true;
                            end;
                        SalesLines.Reset;
                        SalesLines.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLines.SetRange("Document No.", SalesHeader."No.");
                        if SalesLines.FindLast then NextLineNo:=SalesLines."Line No.";
                        NextLineNo+=10000;
                        SalesLines.Init;
                        SalesLines."Document Type":=SalesHeader."Document Type";
                        SalesLines."Document No.":=SalesHeader."No.";
                        SalesLines."Line No.":=NextLineNo;
                        SalesLines.Validate(Type, SalesLines.Type::Item);
                        SalesLines.Validate("No.", ar_SalesLines.TextField(F_SalesLines_No));
                        if(ar_SalesLines.TextField(F_SalesLines_LocationCode) <> '')then SalesLines.Validate("Location Code", ar_SalesLines.TextField(F_SalesLines_LocationCode))
                        else
                            SalesLines.Validate("Location Code", DeviceSetup."Mobile Location");
                        if(ar_SalesLines.TextField(F_SalesLines_VariantCode) <> '')then SalesLines.Validate("Variant Code", ar_SalesLines.TextField(F_SalesLines_VariantCode));
                        SalesLines.Validate("Unit of Measure Code", ar_SalesLines.TextField(F_SalesLines_UnitofMeasureCode));
                        SalesLines.Validate(Quantity, ar_SalesLines.DecimalField(F_SalesLines_Quantity));
                        SalesLines.Validate(DYM_DealCode, ar_SalesLines.TextField(F_SalesLines_DealCode));
                        SalesLines.Validate(DYM_GroupCode, ar_SalesLines.TextField(F_SalesLines_GroupCode));
                        SalesLines.Validate(DYM_DealDiscountPercent, ar_SalesLines.DecimalField(F_SalesLines_DealDiscountPercent));
                        SalesLines.Validate(DYM_HasDealPercent, ar_SalesLines.BooleanField(F_SalesLines_HasDealPercent));
                        SalesLines.Validate("Line Discount Amount", ar_SalesLines.DecimalField(F_SalesLines_LineDiscountAmount));
                        if(SalesLines."Line Discount %" <> ar_SalesLines.DecimalField(F_SalesLines_TotalDiscount))then SalesLines.Validate("Line Discount %", ar_SalesLines.DecimalField(F_SalesLines_TotalDiscount));
                        //All non native discounts are treated like line discount
                        case ar_SalesHeader.IntegerField(F_SalesHeader_DocumentType)of 1: begin //Invoice
                            if((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) and (SalesLines."Quantity (Base)" <> 0))then begin
                                SalesLines.Validate("Unit Price", ar_SalesLines.DecimalField(F_SalesLines_UnitPrice));
                            end;
                        end;
                        2: begin //Return Order
                            if(ar_SalesHeader.TextField(F_SalesHeader_ReturnReason) <> '')then begin
                                ReturnReason.Get(ar_SalesHeader.TextField(F_SalesHeader_ReturnReason));
                                SalesLines.Validate("Return Reason Code", ReturnReason.Code);
                                if(ReturnReason."Default Location Code" <> '')then SalesLines.Validate("Location Code", ReturnReason."Default Location Code");
                                case ReturnReason.DYM_ReturnReasonType of DYM_ReturnReasonType::Inventory: begin
                                    SettingsMgt.TestSetting(ConstMgt.BOS_InventWarehouseId());
                                    SalesLines.Validate("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_InventWarehouseId()));
                                end;
                                DYM_ReturnReasonType::Damaged: begin
                                    SettingsMgt.TestSetting(ConstMgt.BOS_DamageWarehouseId());
                                    SalesLines.Validate("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_DamageWarehouseId()));
                                end;
                                end;
                            end;
                        end;
                        end;
                        SalesLines.Insert(true);
                        //Invoice Discount should be handled like that and need changes in mobile logic
                        /*
                        if (SalesHeader.DYM_DiscountPercentFromDeal <> 0) then begin
                            InvoiceDiscountPct := SalesHeader.DYM_DiscountPercentFromDeal;
                            DocumentTotals.SalesDocTotalsNotUpToDate();
                            AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(SalesLines);
                            InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, 0.01);
                            SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
                            DocumentTotals.SalesDocTotalsNotUpToDate();
                        end;
                        */
                        RecordLinkMgt.SetRecordLink(T_SalesLines, ar_SalesLines.TextField(ConstMgt.SYS_DMSRowId()), Database::"Sales Line", SalesLines.SystemId);
                        RecRef.GetTable(SalesLines);
                        DataLogMgt.LogDataOp_Create(RecRef);
                        case ar_SalesHeader.IntegerField(F_SalesHeader_DocumentType)of 0, 1, 8: begin //Invoice
                            if(SalesHeader."Invoice Discount Value" <> 0)then begin
                                SalesLines.Validate("Inv. Discount Amount", Round(SalesLines."Line Amount" * SalesHeader."Invoice Discount Value" / 100, 0.01));
                            end;
                        end;
                        end;
                        SalesLines.Modify;
                        SalesEventPub.OnProcessSales_AfterLineCreated(SalesHeader, ar_SalesHeader, SalesLines, ar_SalesLines);
                        NextLineNo+=10000;
                        if(SettingsMgt.CheckSetting(ConstMgt.BOS_ProcessBlockedItems) and BlockItem)then begin
                            Item.Blocked:=true;
                            Item.Modify;
                        end;
                    until not ar_SalesLines.NextRecord;
                if IsDelivery then begin
                    SalesHeader.VALIDATE(DYM_MobileStatus, SalesHeader.DYM_MobileStatus::Processed);
                    SalesHeader.Validate(DYM_DeliveryStatus, SalesHeader.DYM_DeliveryStatus::Delivered);
                    SalesHeader.Validate(DYM_DeliveryPersonCode, DeviceSetup.Code);
                    SalesHeader.MODIFY(true);
                end;
                Clear(ItemChargeAssSales);
                if(SalesHeader."Currency Code" = '')then Currency.InitRoundingPrecision
                else
                begin
                    SalesHeader.TestField("Currency Factor");
                    Currency.Get(SalesHeader."Currency Code");
                    Currency.TestField("Amount Rounding Precision");
                end;
                SalesLines.Reset;
                SalesLines.SetRange("Document Type", SalesHeader."Document Type");
                SalesLines.SetRange("Document No.", SalesHeader."No.");
                SalesLines.SetRange(Type, SalesLines.Type::"Charge (Item)");
                if SalesLines.FindSet(false, false)then repeat ICAS.Init;
                        ICAS."Document Type":=SalesHeader."Document Type";
                        ICAS."Document No.":=SalesHeader."No.";
                        ICAS."Document Line No.":=SalesLines."Line No.";
                        ICAS."Item Charge No.":=SalesLines."No.";
                        if(SalesLines."Inv. Discount Amount" = 0) and (SalesLines."Line Discount Amount" = 0) and (not SalesHeader."Prices Including VAT")then ICAS."Unit Cost":=SalesLines."Unit Price"
                        else if SalesHeader."Prices Including VAT" then ICAS."Unit Cost":=Round((SalesLines."Line Amount" - SalesLines."Inv. Discount Amount") / SalesLines.Quantity / (1 + SalesLines."VAT %" / 100), Currency."Unit-Amount Rounding Precision")
                            else
                                ICAS."Unit Cost":=Round((SalesLines."Line Amount" - SalesLines."Inv. Discount Amount") / SalesLines.Quantity, Currency."Unit-Amount Rounding Precision");
                        ItemChargeAssSales.CreateDocChargeAssgn(ICAS, '');
                        //ItemChargeAssSales.SuggestAssignment2(SalesLines, SalesLines.Quantity, SalesLines.Amount, 2);
                        ItemChargeAssSales.AssignItemCharges(SalesLines, SalesLines.Quantity, SalesLines.Amount, ItemChargeAssSales.AssignByAmountMenuText());
                    until SalesLines.Next = 0;
                if(SettingsMgt.CheckSetting(ConstMgt.BOS_ProcessBlockedCustomers) and (BlockCust <> BlockCust::" "))then begin
                    Customer.Blocked:=BlockCust;
                    Customer.Modify;
                end;
                RecRef.GetTable(SalesHeader);
                clear(IsHandled);
                SalesEventPub.OnProcessSales_BeforePostProcess(SalesHeader, ar_SalesHeader, IsHandled);
                if(not IsHandled)then begin
                    if not IsDelivery then begin
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, '', 0, false, '');
                    end
                    else
                    begin
                        case IsDeliveryNoteOnly of true: begin
                            PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Ship, ConstMgt.PPP_Delivery(), 0, false, '');
                        end;
                        false: begin
                            PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, ConstMgt.PPP_Delivery(), 0, false, '');
                        end;
                        end;
                    end;
                end;
                pushProcessSnapshots(T_SalesHeader, ar_SalesHeader.TextField(F_Generic_DMSROWID), RecRef);
            until not ar_SalesHeader.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessCustomer()
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        ar_Customer: Codeunit DYM_ActiveRecManagement;
        fCusmtomerNo, fLatitude, fLongitude, ShipToCode: text;
        IsHandled, UpdateCustomer, UpdateShipToCode, UpdateLatitude, UpdateLongtitude: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_Customer.ReadTable(T_Customer)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessCustomer(IsHandled);
        if IsHandled then exit;
        ar_Customer.ReadTable(T_Customer);
        if ar_Customer.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_Customer.GetTableName, ar_Customer.ActiveRecPK2Text);
                clear(fCusmtomerNo);
                fCusmtomerNo:=ar_Customer.TextField(F_Customer_No);
                if(not Customer.Get(fCusmtomerNo))then begin
                    //Create customer
                    Customer.Init;
                    Customer.Validate("No.", '');
                    Customer.Insert(true);
                    Customer.Name:=ar_Customer.TextField(F_Customer_Name);
                    Customer.Address:=ar_Customer.TextField(F_Customer_Address);
                    Customer.City:=ar_Customer.TextField(F_Customer_City);
                    Customer.Contact:=ar_Customer.TextField(F_Customer_Contact);
                    Customer."Phone No.":=ar_Customer.TextField(F_Customer_PhoneNo);
                    Customer."Customer Disc. Group":=ar_Customer.TextField(F_Customer_CustDiscountGroup);
                    Customer.Blocked:=Customer.Blocked::All;
                    //Customer."Mobile Status" := Customer."Mobile Status"::"1" ;
                    Customer.Modify;
                    SalesEventPub.OnProcessCustomer_AfterCustomerCreated(Customer, ar_Customer);
                    RecRef.GetTable(Customer);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end
                else
                begin
                    //Update customer and ship to code address coordinates
                    clear(updateCustomer);
                    clear(fLatitude);
                    clear(fLongitude);
                    fLatitude:=ar_Customer.TextField(F_Customer_Latitude);
                    fLongitude:=ar_Customer.TextField(F_Customer_Longitude);
                    ShipToCode:=ar_Customer.TextField(F_Customer_ShipToCode);
                    UpdateLatitude:=fLatitude <> '';
                    UpdateLongtitude:=fLongitude <> '';
                    if(ShipToCode <> '')then begin
                        ShipToAddress.Get(fCusmtomerNo, ShipToCode);
                        if UpdateLatitude then begin
                            ShipToAddress.Validate(DYM_Latitude, fLatitude);
                            UpdateShipToCode:=true;
                        end;
                        if UpdateLongtitude then begin
                            ShipToAddress.Validate(DYM_Longitude, fLongitude);
                            UpdateShipToCode:=true;
                        end;
                    end
                    else
                    begin
                        if UpdateLatitude then begin
                            Customer.Validate(DYM_Latitude, fLatitude);
                            updateCustomer:=true;
                        end;
                        if UpdateLongtitude then begin
                            Customer.Validate(DYM_Longitude, fLongitude);
                            updateCustomer:=true;
                        end;
                    end;
                    if(UpdateShipToCode)then begin
                        ShipToAddress.Modify(true);
                        SalesEventPub.OnProcessCustomer_AfterShipToUpdate(ShipToAddress, ar_Customer);
                        RecRef.GetTable(ShipToAddress);
                    end;
                    if(updateCustomer)then begin
                        Customer.Modify(true);
                        SalesEventPub.OnProcessCustomer_AfterCustomerUpdate(Customer, ar_Customer);
                        RecRef.GetTable(Customer);
                    end;
                    DataLogMgt.LogDataOp_Modify(RecRef);
                end;
            until not ar_Customer.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessTracking()
    var
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TransferLine: Record "Transfer Line";
        Item: Record Item;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ar_SalesHeader, ar_SalesLines: Codeunit DYM_ActiveRecManagement;
        ar_TransferHeader, ar_TransferLine: codeunit DYM_ActiveRecManagement;
        ar_TrackingSpecification: Codeunit DYM_ActiveRecManagement;
        IsHandled, LineTrackingChanged: Boolean;
        TrackingQty: Decimal;
        fSerialNo, fLotNo: code[50];
        fApplyFromEntryNo: Integer;
        PositiveTrackingEntry: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        Clear(GeneralDP);
        Clear(IsHandled);
        SalesEventPub.OnProcessTracking(IsHandled);
        if IsHandled then exit;
        #region Sales tracking handling
        clear(IsHandled);
        SalesEventPub.OnBeforePushProcessTracking_Sales(IsHandled);
        if not IsHandled then begin
            SalesReceivablesSetup.Get();
            ar_SalesLines.ReadTable(T_SalesLines);
            ar_SalesLines.SetFieldFilter(F_SalesLines_Type, LowLevelDP.Integer2Text(SalesLine.Type::Item.AsInteger()));
            if ar_SalesLines.FindRecord then repeat SalesLine.GetBySystemId(RecordLinkMgt.GetRecordLinkRecId(T_SalesLines, ar_SalesLines.TextField(ConstMgt.SYS_DMSRowId())));
                    ar_SalesHeader.ReadTable(T_SalesHeader);
                    ar_SalesHeader.SetFieldFilter(F_SalesHeader_No, ar_SalesLines.TextField(F_SalesLines_DocumentNo));
                    ar_SalesHeader.FindRecord();
                    if not Item.Get(ar_SalesLines.TextField(F_SalesLines_No))then Clear(Item);
                    ar_TrackingSpecification.ReadTable(T_TrackingSpecification);
                    if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                        Clear(LineTrackingChanged);
                        //ar_TrackingSpecification.SetFieldFilter(F_TrackingSpecification_SourceSubtype, ar_SalesLines.TextField(F_SalesLines_DocumentType));
                        ar_TrackingSpecification.SetFieldFilter(F_TrackingSpecification_SourceID, ar_SalesLines.TextField(F_SalesLines_DocumentNo));
                        ar_TrackingSpecification.SetFieldFilter(F_TrackingSpecification_SourceRefNo, ar_SalesLines.TextField(F_SalesLines_LineNo));
                        if ar_TrackingSpecification.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_TrackingSpecification.GetTableName, ar_TrackingSpecification.ActiveRecPK2Text);
                                ReservEntry.Reset;
                                ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
                                ReservEntry.SetRange("Source Subtype", ar_SalesHeader.IntegerField(F_SalesHeader_DocumentType));
                                ReservEntry.SetRange("Source ID", ar_SalesLines.TextField(F_SalesLines_DocumentNo));
                                ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                                ReservEntry.SetRange("Quantity (Base)", -ar_TrackingSpecification.DecimalField(F_TrackingSpecification_QtytoHandleBase));
                                ReservEntry.SetRange("Lot No.", ar_TrackingSpecification.TextField(F_TrackingSpecification_LotNo));
                                if not ReservEntry.FindFirst then LineTrackingChanged:=true;
                            until(not ar_TrackingSpecification.NextRecord) or (LineTrackingChanged);
                        if LineTrackingChanged then begin
                            ReservEntry.SetRange("Quantity (Base)");
                            ReservEntry.SetRange("Lot No.");
                            ReservEntry.DeleteAll;
                            if ar_TrackingSpecification.FindRecord then repeat clear(PositiveTrackingEntry);
                                    PositiveTrackingEntry:=(SalesLine."Document Type" in[SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"]);
                                    Clear(TrackingQty);
                                    TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(SalesLine."No.", ar_TrackingSpecification.DecimalField(F_TrackingSpecification_QuantityBase), SalesLine."Unit of Measure Code", ar_SalesLines.TextField(F_SalesLines_UnitofMeasureCode)); //Item."Base Unit of Measure");
                                    clear(fSerialNo);
                                    clear(fLotNo);
                                    clear(fApplyFromEntryNo);
                                    fSerialNo:=ar_TrackingSpecification.TextField(F_TrackingSpecification_SerialNo);
                                    fLotNo:=ar_TrackingSpecification.TextField(F_TrackingSpecification_LotNo);
                                    fApplyFromEntryNo:=ar_TrackingSpecification.IntegerField(F_SalesLines_ReturnInventTransId);
                                    //Handle Exact Cost Reversing
                                    if((SalesReceivablesSetup."Exact Cost Reversing Mandatory") AND (SalesLine."Document Type" in[SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"]) AND (fApplyFromEntryNo = 0))then begin
                                        fApplyFromEntryNo:=SalesHelper.GetSalesItemLedgerEntry(ar_SalesHeader.TextField(F_SalesHeader_SourceDocumentNo), SalesLine."No.", SalesLine."Variant Code", fSerialNo, fLotNo);
                                    end;
                                    if((fSerialNo <> '') or (fLotNo <> ''))then begin
                                        Clear(TrackAssistMgt);
                                        TrackAssistMgt.CreateTracking_SL(SalesLine, TrackingQty, SalesLine."Qty. per Unit of Measure", 0D, 0D, fSerialNo, fLotNo, '', fApplyFromEntryNo);
                                    end;
                                until not ar_TrackingSpecification.NextRecord;
                        end;
                    end
                    else
                    begin
                        ar_TrackingSpecification.SetFieldFilter(F_TrackingSpecification_SourceRefNo, ar_SalesLines.TextField(F_SalesLines_LineNo));
                        if ar_TrackingSpecification.FindRecord then if(ar_TrackingSpecification.IntegerField(F_SalesLines_ReturnInventTransId) <> 0)then begin
                                SalesLine.Validate("Appl.-from Item Entry", ar_TrackingSpecification.IntegerField(F_SalesLines_ReturnInventTransId));
                                SalesLine.Modify(true);
                            end;
                    end;
                until not ar_SalesLines.NextRecord;
        end;
        #endregion 
        #region Transfer tracking handling
        clear(IsHandled);
        SalesEventPub.OnProcessTracking_Transfer(IsHandled);
        if not IsHandled then begin
            ar_TransferLine.ReadTable(T_TransferLine);
            if ar_TransferLine.FindRecord then repeat TransferLine.GetBySystemId(RecordLinkMgt.GetRecordLinkRecId(T_TransferLine, ar_TransferLine.TextField(ConstMgt.SYS_DMSRowId())));
                    if not Item.Get(ar_TransferLine.TextField(F_TransferLine_ItemNo))then Clear(Item);
                    if TrackAssistMgt.CheckIfItemTrackingIsEnabled(Item."No.")then begin
                        Clear(LineTrackingChanged);
                        ar_TrackingSpecification.ReadTable(T_TrackingSpecification);
                        //ar_TrackingSpecification.SetFieldFilter(F_TrackSpec_SourceType, LowLevelDP.Integer2Text(DATABASE::"Transfer Line"));
                        //ar_TrackingSpecification.SetFieldFilter(F_TrackSpec_SourceSubtype, LowLevelDP.Integer2Text(1)); //Fixed for Transfer Order
                        ar_TrackingSpecification.SetFieldFilter(F_TrackingSpecification_SourceID, ar_TransferLine.TextField(F_TransferLine_DocumentNo));
                        ar_TrackingSpecification.SetFieldFilter(F_TrackingSpecification_SourceRefNo, ar_TransferLine.TextField(F_TransferLine_LineNo));
                        //ar_TrackingSpecification.SetFieldFilter(F_TrackSpec_QuantityBase, '<>0');
                        if ar_TrackingSpecification.FindRecord then repeat Clear(UOMAssistMgt);
                                Clear(TrackingQty);
                                TrackingQty:=UOMAssistMgt.CalcQtyUM2UM(ar_TransferLine.TextField(F_TransferLine_ItemNo), ar_TrackingSpecification.DecimalField(F_TrackingSpecification_QuantityBase), ar_TransferLine.TextField(F_TransferLine_UnitofMeasureCode), Item."Base Unit of Measure");
                                TrackAssistMgt.CreateTracking_TL(TransferLine, TrackingQty, TransferLine."Qty. per Unit of Measure", 0D, 0D, ar_TrackingSpecification.TextField(F_TrackingSpecification_SerialNo), ar_TrackingSpecification.TextField(F_TrackingSpecification_LotNo), ar_TrackingSpecification.TextField(F_TrackingSpecification_PackageNo));
                            until not ar_TrackingSpecification.NextRecord;
                    end;
                until not ar_TransferLine.NextRecord;
        end;
        #endregion 
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessPayments()
    var
        GenJnlLine: Record "Gen. Journal Line";
        ar_PaymentHeader, ar_PaymentLine: Codeunit DYM_ActiveRecManagement;
        GenJnlTemplateName, GenJnlBatchName: code[10];
        PaidAmount, AppliedAmount: Decimal;
        IsHandled: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_PaymentHeader.ReadTable(T_PaymentHeader)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessPayments(IsHandled);
        if IsHandled then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_PaymentJournalTemplateName);
        SettingsMgt.TestSetting(ConstMgt.BOS_PaymentJournalBatchName);
        clear(GenJnlTemplateName);
        clear(GenJnlBatchName);
        GenJnlTemplateName:=SettingsMgt.GetSetting(ConstMgt.BOS_PaymentJournalTemplateName());
        GenJnlBatchName:=SettingsMgt.GetSetting(ConstMgt.BOS_PaymentJournalBatchName());
        // SettingsMgt.TestSetting(ConstMgt.BOS_PaymentBalAccountType);
        // SettingsMgt.TestSetting(ConstMgt.BOS_PaymentBalAccountNo);
        ar_PaymentHeader.ReadTable(T_PaymentHeader);
        if ar_PaymentHeader.FindRecord then repeat //Generate unapplied amount line
                CLEAR(PaidAmount);
                CLEAR(AppliedAmount);
                PaidAmount:=ar_PaymentHeader.DecimalField(F_PaymentHeader_paidAmount);
                if(ar_PaymentHeader.TextField(F_PaymentHeader_customerNo) = '')then Error(Text004);
                if(PaidAmount = 0)then Error(Text005);
                ar_PaymentLine.ReadTable(T_PaymentLine);
                if ar_PaymentLine.FindRecord()THEN REPEAT AppliedAmount:=AppliedAmount + ar_PaymentLine.DecimalField(F_PaymentLine_amount);
                    UNTIL not ar_PaymentLine.NextRecord();
                IF(AppliedAmount <> PaidAmount)THEN BEGIN
                    SalesHelper.createPaymentLine(ar_PaymentHeader.TextField(F_PaymentHeader_customerNo), ar_PaymentHeader.DateField(F_PaymentHeader_dateCreated), PaidAmount - AppliedAmount, ar_PaymentHeader.TextField(F_PaymentHeader_no), '', GenJnlTemplateName, GenJnlBatchName, enum::"Gen. Journal Account Type".FromInteger(LowLevelDP.Text2Integer(SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountType))), SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountNo), GenJnlLine);
                END;
                ar_PaymentLine.ReadTable(T_PaymentLine);
                if ar_PaymentLine.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_PaymentLine.GetTableName, ar_PaymentLine.GetActiveRecContext);
                        SalesHelper.createPaymentLine(ar_PaymentHeader.TextField(F_PaymentHeader_customerNo), ar_PaymentHeader.DateField(F_PaymentHeader_dateCreated), ar_PaymentLine.DecimalField(F_PaymentLine_amount), ar_PaymentHeader.TextField(F_PaymentHeader_no), ar_PaymentLine.TextField(F_PaymentLine_openTransId), GenJnlTemplateName, GenJnlBatchName, enum::"Gen. Journal Account Type".FromInteger(LowLevelDP.Text2Integer(SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountType))), SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountNo), GenJnlLine);
                    until not ar_PaymentLine.NextRecord;
            until not ar_PaymentHeader.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessTransferDocs()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Item: Record Item;
        PostProcessLog: Record DYM_PostProcessLog;
        ar_TransHeader: Codeunit DYM_ActiveRecManagement;
        ar_TransLine: Codeunit DYM_ActiveRecManagement;
        NextLineNo: Integer;
        PostProcessLogEntryNo: BigInteger;
        IsHandled, BlockItem: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_TransHeader.ReadTable(T_TransferHeader)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessTransfers(IsHandled);
        if IsHandled then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_TransferOrderNos);
        // SettingsMgt.TestSetting(ConstMgt.BOS_TransferReplLocation);
        SettingsMgt.TestSetting(ConstMgt.BOS_TransferReplInTransit);
        ar_TransHeader.ReadTable(T_TransferHeader);
        //ar_SalesHeader.SetFieldFilter(F_SalesHeader_DocumentType, LowLevelDP.Integer2Text(2)); //Transfer Order
        if ar_TransHeader.FindRecord then repeat DataLogMgt.LogActiveRecOp(ar_TransHeader.GetTableName, ar_TransHeader.GetActiveRecContext);
                TransferHeader.Init;
                TransferHeader.Validate("No. Series", SettingsMgt.GetSetting(ConstMgt.BOS_TransferOrderNos));
                TransferHeader.Validate("No.", '');
                //TransferHeader.VALIDATE ( Mobile , TRUE ) ;
                TransferHeader.Insert(true);
                //TransferHeader.Validate("Transfer-from Code", SettingsMgt.GetSetting(ConstMgt.BOS_TransferReplLocation));
                //TransferHeader.Validate("Transfer-to Code", DeviceSetup."Mobile Location");
                TransferHeader.Validate("Transfer-from Code", ar_TransHeader.TextField(F_TransferHeader_TransferfromCode));
                TransferHeader.Validate("Transfer-to Code", ar_TransHeader.TextField(F_TransferHeader_TransfertoCode));
                TransferHeader.Validate("In-Transit Code", SettingsMgt.GetSetting(ConstMgt.BOS_TransferReplInTransit));
                if(SettingsMgt.CheckSetting(ConstMgt.BOS_UseDirectTransferOrder()))then TransferHeader.Validate("Direct Transfer", true);
                TransferHeader.Validate("Posting Date", ar_TransHeader.DateField(F_TransferHeader_PostingDate));
                TransferHeader."External Document No.":=ar_TransHeader.TextField(F_TransferHeader_No);
                //TransferHeader.Mobile := TRUE ;
                //TransferHeader."Sync Log Entry No." := SLE ;
                TransferHeader.Modify;
                SalesEventPub.OnProcessTransfers_AfterHeaderCreated(TransferHeader, ar_TransHeader);
                RecordLinkMgt.SetRecordLink(T_TransferHeader, ar_TransHeader.TextField(ConstMgt.SYS_DMSRowId()), Database::"Transfer Header", TransferHeader.SystemId);
                RecRef.GetTable(TransferHeader);
                DataLogMgt.LogDataOp_Create(RecRef);
                NextLineNo:=10000;
                TransferLine.Reset;
                TransferLine.SetRange("Document No.", TransferHeader."No.");
                TransferLine.DeleteAll(true);
                ar_TransLine.ReadTable(T_TransferLine);
                //ar_SalesLines.SetFieldFilter(F_SalesLines_DocumentType, ar_SalesHeader.TextField(F_SalesHeader_DocumentType));
                ar_TransLine.SetFieldFilter(F_TransferLine_DocumentNo, ar_TransHeader.TextField(F_TransferHeader_No));
                if ar_TransLine.FindRecord then repeat //z
                        //IF ( MobileSetup."Debug Mode" ) THEN BEGIN
                        //  RecRef.GETTABLE ( SalesLines ) ;
                        //  IF ( MobileSetup."Debug Level" >= MobileSetup."Debug Level"::State.AsInteger() ) THEN
                        //    CacheMgt.SetStateDescription ( STRSUBSTNO ( ConstMgt.MSG_0009 , RecRef.NAME ,
                        //                                                LowLevelDP.RecordRefPK2TextDescriptive ( RecRef ) ) ) ;
                        //  IF ( MobileSetup."Debug Level" >= MobileSetup."Debug Level"::Full.AsInteger() ) THEN
                        //    DataLogMgt.LogDataOperation ( enum::DYM_DataLogEntryType::Incoming , RecRef ) ;
                        //END ;
                        if(ar_TransLine.TextField(F_TransferLine_ItemNo) = '')then Error(Text007);
                        if(ar_TransLine.DecimalField(F_TransferLine_Quantity) = 0)then Error(Text008);
                        Clear(BlockItem);
                        if not Item.Get(ar_TransLine.TextField(F_TransferLine_ItemNo))then Clear(Item);
                        if Item.Blocked then if SettingsMgt.CheckSetting(ConstMgt.BOS_ProcessBlockedItems)then begin
                                Item.Blocked:=false;
                                Item.Modify;
                                BlockItem:=true;
                            end;
                        TransferLine.Init;
                        TransferLine."Document No.":=TransferHeader."No.";
                        TransferLine."Line No.":=NextLineNo;
                        TransferLine.Validate("Item No.", ar_TransLine.TextField(F_TransferLine_ItemNo));
                        //if (ar_TransLines.TextField(F_TransferLine_VariantCode) <> '') then
                        //    TransferLines.Validate("Variant Code", ar_SalesLines.TextField(F_SalesLines_VariantCode));
                        TransferLine.Validate("Unit of Measure Code", ar_TransLine.TextField(F_TransferLine_UnitofMeasureCode));
                        TransferLine.Validate(Quantity, ar_TransLine.DecimalField(F_TransferLine_Quantity));
                        TransferLine.Insert;
                        SalesEventPub.OnProcessTransfers_AfterLineCreated(TransferHeader, ar_TransHeader, TransferLine, ar_TransLine);
                        RecordLinkMgt.SetRecordLink(T_TransferLine, ar_TransLine.TextField(ConstMgt.SYS_DMSRowId()), Database::"Transfer Line", TransferLine.SystemId);
                        RecRef.GetTable(TransferLine);
                        DataLogMgt.LogDataOp_Create(RecRef);
                        if(SettingsMgt.CheckSetting(ConstMgt.BOS_ProcessBlockedItems) and BlockItem)then begin
                            Item.Blocked:=true;
                            Item.Modify;
                        end;
                        NextLineNo+=10000;
                    until not ar_TransLine.NextRecord;
                clear(IsHandled);
                SalesEventPub.OnProcessTransfers_BeforePostProcess(TransferHeader, ar_TransHeader, IsHandled);
                if not IsHandled then begin
                    RecRef.GetTable(TransferHeader);
                    PostProcessLogEntryNo:=PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Ship, '', 0, false, '');
                    PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Receive, '', PostProcessLogEntryNo, false, '');
                end;
            until not ar_TransHeader.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure pushProcessSnapshots(EntityName: Text; RowId: Text; RecRef: RecordRef)
    var
        ar_Snapshot: Codeunit DYM_ActiveRecManagement;
        BLOBStoreMgt: Codeunit DYM_BLOBStoreManagement;
        FileManagement: Codeunit "File Management";
        DocAttachment: Record "Document Attachment";
        BLOBStore: Record DYM_BLOBStore;
        InS: InStream;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_Snapshot.ReadTable(T_Snapshot)then exit;
        ar_Snapshot.ReadTable(T_Snapshot);
        ar_Snapshot.SetFieldFilter(F_Snapshot_EntityName, EntityName);
        ar_Snapshot.SetFieldFilter(F_Snapshot_EntityDMSROWID, RowId);
        if ar_Snapshot.FindRecord()then repeat PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Custom, ConstMgt.PPP_ProcessSnapshots(), 0, false, BLOBStoreMgt.parseBLOBPath(ar_Snapshot.TextField(F_Snapshot_ImageName)));
            until not ar_Snapshot.NextRecord();
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessDelivery()
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        Location: Record Location;
        Item: Record Item;
        Device: Record DYM_DeviceSetup;
        ar_SalesHead: Codeunit DYM_ActiveRecManagement;
        ar_SalesLines: Codeunit DYM_ActiveRecManagement;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleaseAfterProcess, IsHandled, FullyProcessed, IsDeliveryNoteOnly: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_SalesHead.ReadTable(T_SalesHeader)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessDelivery(IsHandled);
        if IsHandled then exit;
        ar_SalesHead.ReadTable(T_SalesHeader);
        ar_SalesHead.SetFieldFilter(F_SalesHeader_DocumentType, '8'); //Delivery
        if ar_SalesHead.FindRecord then repeat if SalesHeader.Get(SalesHeader."Document Type"::Order, ar_SalesHead.TextField(F_SalesHeader_SourceDocumentNo))then begin
                    SalesHeader.TestField(DYM_DeliveryStatus, SalesHeader.DYM_DeliveryStatus::ForDelivery);
                    SalesHeader.LockTable;
                    Clear(ReleaseAfterProcess);
                    if(SalesHeader.Status = SalesHeader.Status::Released)then begin
                        Clear(ReleaseSalesDoc);
                        ReleaseSalesDoc.Reopen(SalesHeader);
                        ReleaseAfterProcess:=True;
                    end;
                    IsDeliveryNoteOnly:=ar_SalesHead.BooleanField(F_SalesHeader_IsDeliveryNoteOnly);
                    if(ar_SalesHead.TextField(F_SalesHeader_ShiptoCode) <> '')then SalesHeader.Validate("Ship-to Code", ar_SalesHead.TextField(F_SalesHeader_ShiptoCode));
                    SalesHeader.Validate("External Document No.", ar_SalesHead.TextField(F_SalesHeader_No));
                    SalesHeader.Validate("Payment Method Code", ar_SalesHead.TextField(F_SalesHeader_PaymentMethodCode));
                    SalesHeader.Validate("Payment Terms Code", ar_SalesHead.TextField(F_SalesHeader_PaymentTermsCode));
                    SalesHeader."Posting No.":=ar_SalesHead.TextField(F_SalesHeader_No);
                    Clear(SalesHeader."No. Series");
                    Clear(SalesHeader."Posting No. Series");
                    RecordLinkMgt.SetRecordLink(T_SalesHeader, ar_SalesHead.TextField(ConstMgt.SYS_DMSRowId()), Database::"Sales Header", SalesHeader.SystemId);
                    FullyProcessed:=true;
                    Clear(SalesLines);
                    SalesLines.SetRange("Document No.", SalesHeader."No.");
                    if SalesLines.FindSet()then repeat SalesLines.Validate("Qty. to Ship", 0);
                            SalesLines.Validate("Qty. to Invoice", 0);
                            SalesLines.Modify(true);
                        until SalesLines.Next() = 0;
                    ar_SalesLines.ReadTable(T_SalesLines);
                    ar_SalesLines.SetFieldFilter(F_SalesLines_DocumentType, ar_SalesHead.TextField(F_SalesHeader_DocumentType));
                    ar_SalesLines.SetFieldFilter(F_SalesLines_DocumentNo, ar_SalesHead.TextField(F_SalesHeader_SourceDocumentNo));
                    if ar_SalesLines.FindRecord then repeat Clear(SalesLines);
                            if SalesLines.Get(SalesHeader."Document Type", SalesHeader."No.", ar_SalesLines.IntegerField(F_SalesLines_LineNo))then begin
                                Location.Get(SalesLines."Location Code");
                                if Location."Require Shipment" then Error(Text001, SalesLines."Location Code");
                                SalesLines.TestField(Type, SalesLines.Type::Item);
                                SalesLines.TestField("No.", ar_SalesLines.TextField(F_SalesLines_No));
                                if(SalesHeader.DYM_DeliveryPersonCode <> '')then begin
                                    Device.Get(SalesHeader.DYM_DeliveryPersonCode);
                                    SalesLines.Validate("Location Code", Device."Mobile Location");
                                end
                                else
                                begin
                                    SalesLines.Validate("Location Code", DeviceSetup."Mobile Location");
                                end;
                                if(ar_SalesLines.DecimalField(F_SalesLines_Quantity) <> 0)then begin
                                    SalesLines.Validate("Qty. to Ship", ar_SalesLines.DecimalField(F_SalesLines_Quantity));
                                    SalesLines.Modify(true);
                                end;
                                SalesEventPub.OnProcessDelivery_AfterLineUpdate(SalesHeader, ar_SalesHead, SalesLines, ar_SalesLines);
                                RecRef.GetTable(SalesLines);
                                DataLogMgt.LogDataOp_Modify(RecRef);
                            end;
                            RecordLinkMgt.SetRecordLink(T_SalesLines, ar_SalesLines.TextField(ConstMgt.SYS_DMSRowId()), Database::"Sales Line", SalesLines.SystemId);
                        until not ar_SalesLines.NextRecord;
                    SalesLines.Reset();
                    SalesLines.SetRange("Document No.", SalesHeader."No.");
                    if(SalesLines.FindSet())then repeat if(SalesLines.Quantity <> (SalesLines."Qty. to Ship" + SalesLines."Quantity Shipped"))then Clear(FullyProcessed);
                        until SalesLines.Next() = 0;
                    CASE FullyProcessed OF TRUE: begin
                        SalesHeader.VALIDATE(DYM_MobileStatus, SalesHeader.DYM_MobileStatus::Processed);
                        SalesHeader.Validate(DYM_DeliveryStatus, SalesHeader.DYM_DeliveryStatus::Delivered);
                        SalesHeader.Validate(DYM_DeliveryPersonCode, DeviceSetup.Code);
                    end;
                    FALSE: begin
                        SalesHeader.VALIDATE(DYM_MobileStatus, SalesHeader.DYM_MobileStatus::"Partially Processed");
                    end;
                    END;
                    SalesHeader.Modify(true);
                    RecRef.GetTable(SalesHeader);
                    FldRef:=RecRef.Field(LowLevelDP.GetFieldByName(Database::"Sales Header", F_SalesHeader_Signature));
                    ar_SalesHead.BLOB2MediaFieldRef(F_SalesHeader_Signature, FldRef);
                    RecRef.Modify();
                    if(ReleaseAfterProcess)then begin
                        clear(ReleaseSalesDoc);
                        ReleaseSalesDoc.ReleaseSalesHeader(SalesHeader, false);
                    end;
                    RecRef.GetTable(SalesHeader);
                    DataLogMgt.LogDataOp_Modify(RecRef);
                    clear(IsHandled);
                    SalesEventPub.OnProcessDelivery_BeforePostProcess(SalesHeader, ar_SalesHead, IsHandled);
                    if(not IsHandled)then begin
                        case IsDeliveryNoteOnly of true: begin
                            PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Ship, ConstMgt.PPP_Delivery(), 0, false, '');
                        end;
                        false: begin
                            PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, ConstMgt.PPP_Delivery(), 0, false, '');
                        end;
                        end;
                    end;
                end;
            until not ar_SalesHead.NextRecord;
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessPhysInventory()
    var
        ar_ItemJnlLine: Codeunit DYM_ActiveRecManagement;
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlLine: Record "Item Journal Line";
        LastItemJnlLine: Record "Item Journal Line";
        Item: Record Item;
        Location: Record Location;
        ItemJnlBatch: Record "Item Journal Batch";
        NextDocNo: Code[20];
        NextLine: Integer;
        QtyBase, QtyCalculated: Decimal;
        IsHandled: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_ItemJnlLine.ReadTable(T_StockTakeLine)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessPhysInventory(IsHandled);
        if IsHandled then exit;
        SettingsMgt.TestSetting(ConstMgt.BOS_ItemJournalTemplate);
        SettingsMgt.TestSetting(ConstMgt.BOS_ItemJournalBatch);
        SettingsMgt.TestSetting(ConstMgt.BOS_InventWarehouseId());
        SettingsMgt.TestSetting(ConstMgt.BOS_PhysicalJournalNos);
        CLEAR(NextLine);
        CLEAR(LastItemJnlLine);
        ItemJnlLine.RESET;
        ItemJnlLine.SETRANGE("Journal Template Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalTemplate));
        ItemJnlLine.SETRANGE("Journal Batch Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalBatch));
        IF ItemJnlLine.FINDLAST THEN BEGIN
            NextLine:=ItemJnlLine."Line No.";
            NextDocNo:=ItemJnlLine."Document No.";
        END;
        IF NOT ItemJnlBatch.GET(SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalTemplate), SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalBatch))THEN CLEAR(ItemJnlBatch);
        ar_ItemJnlLine.ReadTable(T_StockTakeLine);
        if ar_ItemJnlLine.FindRecord then REPEAT Clear(QtyCalculated);
                LastItemJnlLine.RESET;
                LastItemJnlLine.SETRANGE("Journal Template Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalTemplate));
                LastItemJnlLine.SETRANGE("Journal Batch Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalBatch));
                IF NOT LastItemJnlLine.FINDLAST THEN CLEAR(LastItemJnlLine);
                IF NOT Item.GET(ar_ItemJnlLine.TextField(F_StockTakeLine_ItemNo))THEN CLEAR(Item);
                IF NOT Location.GET(DeviceSetup."Mobile Location")THEN CLEAR(Location);
                ItemJnlLine.RESET;
                ItemJnlLine.SETRANGE("Journal Template Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalTemplate));
                ItemJnlLine.SETRANGE("Journal Batch Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalBatch));
                ItemJnlLine.SETRANGE("Item No.", ar_ItemJnlLine.TextField(ar_ItemJnlLine.TextField(F_StockTakeLine_ItemNo)));
                ItemJnlLine.SETRANGE("Unit of Measure Code", Item."Sales Unit of Measure");
                ItemJnlLine.SETRANGE("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_InventWarehouseId()));
                ItemJnlLine.SETRANGE("Lot No.", ar_ItemJnlLine.TextField(F_StockTakeLine_LotNo));
                IF NOT ItemJnlLine.FINDFIRST THEN BEGIN
                    ItemJnlLine.RESET;
                    NextLine+=10000;
                    ItemJnlLine.INIT;
                    ItemJnlLine.VALIDATE("Journal Template Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalTemplate));
                    ItemJnlLine.VALIDATE("Journal Batch Name", SettingsMgt.GetSetting(ConstMgt.BOS_ItemJournalBatch));
                    ItemJnlLine.VALIDATE("Line No.", NextLine);
                    ItemJnlLine.VALIDATE("Item No.", ar_ItemJnlLine.TextField(F_StockTakeLine_ItemNo));
                    ItemJnlLine.SetUpNewLine(LastItemJnlLine);
                    ItemJnlLine.INSERT(TRUE);
                    ItemJnlLine.VALIDATE("Document No.", NoSeriesMgt.GetNextNo(SettingsMgt.GetSetting(ConstMgt.BOS_PhysicalJournalNos), TODAY, TRUE));
                    ItemJnlLine.VALIDATE("Unit of Measure Code", Item."Sales Unit of Measure");
                    ItemJnlLine.VALIDATE("Posting Date", TODAY);
                    ItemJnlLine.VALIDATE("Location Code", SettingsMgt.GetSetting(ConstMgt.BOS_InventWarehouseId()));
                    ItemJnlLine.MODIFY(TRUE);
                END;
                QtyCalculated:=ar_ItemJnlLine.DecimalField(F_StockTakeLine_Qty) - ar_ItemJnlLine.DecimalField(F_StockTakeLine_Differrence);
                ItemJnlLine.VALIDATE("Phys. Inventory", TRUE);
                ItemJnlLine.VALIDATE("Qty. (Calculated)", QtyCalculated);
                ItemJnlLine.VALIDATE("Qty. (Phys. Inventory)", ar_ItemJnlLine.DecimalField(F_StockTakeLine_Qty));
                ItemJnlLine.MODIFY(TRUE);
                if(Item."Item Tracking Code" <> '')then begin
                    CLEAR(ItemJnlLineReserve);
                    ItemJnlLineReserve.DeleteLineConfirm(ItemJnlLine);
                    ItemJnlLineReserve.DeleteLine(ItemJnlLine);
                    QtyBase:=UOMAssistMgt.CalcQtyUM2UM(ItemJnlLine."Item No.", ItemJnlLine.Quantity, Item."Sales Unit of Measure", Item."Base Unit of Measure");
                    TrackAssistMgt.CreateTracking_IJL(ItemJnlLine, QtyBase, 1, ar_ItemJnlLine.DateField(F_StockTakeLine_LotExpirationDate), 0D, '', ar_ItemJnlLine.TextField(F_StockTakeLine_LotNo), '');
                end;
                RecRef.GETTABLE(ItemJnlLine);
                DataLogMgt.LogDataOp_Create(RecRef);
            until not ar_ItemJnlLine.NextRecord();
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PushProcessDeviceActivity()
    var
        DeviceActivity: Record DYM_DeviceActivity;
        ar_CustomerActivity: Codeunit DYM_ActiveRecManagement;
        IsHandled: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        EventLogMgt.LogProcessDebug_MethodStart();
        if not ar_CustomerActivity.ReadTable(T_CustomerActivity)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessDeviceActivity(IsHandled);
        if IsHandled then exit;
        ar_CustomerActivity.ReadTable(T_CustomerActivity);
        if ar_CustomerActivity.FindRecord then repeat Clear(DeviceActivity);
                DeviceActivity.Init();
                DeviceActivity.Action:=Enum::DYM_DeviceActivityAction.FromInteger(ar_CustomerActivity.IntegerField(F_CustomerActivity_Action));
                DeviceActivity."Customer No.":=ar_CustomerActivity.TextField(F_CustomerActivity_CustomerNo);
                DeviceActivity.Comment:=ar_CustomerActivity.TextField(F_CustomerActivity_Comment);
                DeviceActivity.Amount:=ar_CustomerActivity.DecimalField(F_CustomerActivity_Amount);
                DeviceActivity."Cutomer Name":=ar_CustomerActivity.TextField(F_CustomerActivity_CustomerTitle);
                DeviceActivity."Document No.":=ar_CustomerActivity.TextField(F_CustomerActivity_DocumentNo);
                DeviceActivity."In Route":=ar_CustomerActivity.BooleanField(F_CustomerActivity_InRoute);
                DeviceActivity."Visit Date":=ar_CustomerActivity.DatetimeField(F_CustomerActivity_OnDate);
                DeviceActivity.Distance:=ar_CustomerActivity.DecimalField(F_CustomerActivity_Distance);
                DeviceActivity.Duration:=ar_CustomerActivity.DecimalField(F_CustomerActivity_Duration);
                DeviceActivity."Valid Distance":=ar_CustomerActivity.BooleanField(F_CustomerActivity_IsDistanceValid);
                DeviceActivity."Vist No.":=ar_CustomerActivity.TextField(F_CustomerActivity_VisitNo);
                DeviceActivity.Latitude:=ar_CustomerActivity.TextField(F_CustomerActivity_Latitude);
                DeviceActivity.Longitude:=ar_CustomerActivity.TextField(F_CustomerActivity_Longitude);
                DeviceActivity.MaxVisitDuration:=ar_CustomerActivity.IntegerField(F_CustomerActivity_MaxVisitDuration);
                DeviceActivity.MaxVisitDurationExcReasonCode:=ar_CustomerActivity.TextField(F_CustomerActivity_MaxVisitDurationExcReasonCode);
                DeviceActivity."SalesPerson Code":=DeviceSetup."Salesperson Code";
                DeviceActivity."Device Setup Code":=DeviceSetup.Code;
                DeviceActivity.Insert(true);
                RecRef.GetTable(DeviceActivity);
                DataLogMgt.LogDataOp_Create(RecRef);
            until not ar_CustomerActivity.NextRecord();
        EventLogMgt.LogProcessDebug_MethodEnd();
    end;
    procedure PreProcess()
    var
        ar_CustomerActivity: Codeunit DYM_ActiveRecManagement;
        ISHandled: Boolean;
        ActivityAction: Enum DYM_DeviceActivityAction;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not ar_CustomerActivity.ReadTable(T_CustomerActivity)then exit;
        Clear(IsHandled);
        SalesEventPub.OnProcessOperationHint(IsHandled);
        if IsHandled then exit;
        CacheMgt.SetOperationHint('');
        ar_CustomerActivity.ReadTable(T_CustomerActivity);
        if ar_CustomerActivity.FindRecord then begin
            ActivityAction:=Enum::DYM_DeviceActivityAction.FromInteger(ar_CustomerActivity.IntegerField(F_CustomerActivity_Action));
            CacheMgt.SetOperationHint(Format(ActivityAction));
        end;
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
    procedure PullProcessReturnsData(var ParentTableMap: Record DYM_MobileTableMap; var TableMap: Record DYM_MobileTableMap; var FilterRecordRef: RecordRef)
    var
        ILEBuffer: Record "Item Ledger Entry" temporary;
        SalesInvoiceLineBuffer: Record "Sales Invoice Line" temporary;
        SalesInvoiceHeaderBuffer: Record "Sales Invoice Header" temporary;
        SalesInvoiceHeaderFilter: Record "Sales Invoice Header" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ValueEntry: Record "Value Entry";
        ILE: Record "Item Ledger Entry";
        Item: Record Item;
        CustomerRecRef: RecordRef;
        FieldRef: FieldRef;
        CustomerNo: Code[20];
        SalesQty: Decimal;
        SkipDocument: Boolean;
        IsHandled: Boolean;
        RecRefSalesInvoiceHeader, RecRefSalesInvoiceLine, RecRefILE: RecordRef;
    begin
        TableBufMgt.GetTableBuffer(Database::Customer, CustomerRecRef);
        FilterRecordRef.SetTable(SalesInvoiceHeaderFilter);
        if(CustomerRecRef.FindSet())then repeat FieldRef:=CustomerRecRef.Field(1);
                CustomerNo:=FieldRef.Value();
                SalesInvoiceHeader.Reset();
                SalesInvoiceHeader.SetCurrentKey("Sell-to Customer No.");
                SalesInvoiceHeader.CopyFilters(SalesInvoiceHeaderFilter);
                SalesInvoiceHeader.SetRange("Sell-to Customer No.", CustomerNo);
                SalesEventPub.OnPullProcessReturnsData_BeforeInvoiceLoop(SalesInvoiceHeader);
                if(SalesInvoiceHeader.FindSet())then repeat clear(SkipDocument);
                        SalesEventPub.OnPullProcessReturnsData_BeforeSkipCredited(SalesInvoiceHeader, SkipDocument, IsHandled);
                        if not IsHandled then if(SettingsMgt.CheckSetting(ConstMgt.BOS_SkipCreditedReturnInvoices()))then begin
                                SalesCrMemoHeader.Reset();
                                SalesCrMemoHeader.SetCurrentKey("Bill-to Customer No.");
                                SalesCrMemoHeader.SetRange("Bill-to Customer No.", SalesInvoiceHeader."Bill-to Customer No.");
                                SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                SalesCrMemoHeader.SetRange("Applies-to Doc. No.", SalesInvoiceHeader."No.");
                                SalesCrMemoHeader.SetFilter("Posting Date", '>=%1', SalesInvoiceHeader."Posting Date");
                                if not SalesCrMemoHeader.IsEmpty then SkipDocument:=true;
                            end;
                        if(not SkipDocument)then begin
                            SalesInvoiceLine.Reset();
                            SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                            SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
                            if(SalesInvoiceLine.FindSet())then repeat Clear(SalesQty);
                                    ValueEntry.Reset();
                                    ValueEntry.SetCurrentKey("Document No.");
                                    ValueEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");
                                    ValueEntry.SetRange("Document Line No.", SalesInvoiceLine."Line No.");
                                    ValueEntry.SetFilter("Invoiced Quantity", '<>0');
                                    if(ValueEntry.FindSet())then repeat ILE.Get(ValueEntry."Item Ledger Entry No.");
                                            if not ILEBuffer.Get(ILE."Entry No.")then begin
                                                ILEBuffer.Init();
                                                ILEBuffer.TransferFields(ILE, true);
                                                ILEBuffer."Document No.":=SalesInvoiceLine."Document No.";
                                                ILEBuffer."Document Line No.":=SalesInvoiceLine."Line No.";
                                                ILEBuffer."Shipped Qty. Not Returned":=-ILEBuffer."Shipped Qty. Not Returned";
                                                if(ILEBuffer."Shipped Qty. Not Returned" <> 0)then ILEBuffer.Insert();
                                                SalesQty+=ILEBuffer."Shipped Qty. Not Returned";
                                            end;
                                        until ValueEntry.Next() = 0;
                                    Item.Get(SalesInvoiceLine."No.");
                                    SalesQty:=UOMAssistMgt.CalcQtyUM2UM(Item."No.", SalesQty, Item."Base Unit of Measure", Item."Sales Unit of Measure");
                                    if(SalesQty <> 0)then begin
                                        SalesInvoiceLineBuffer.Init();
                                        SalesInvoiceLineBuffer.TransferFields(SalesInvoiceLine, true);
                                        SalesInvoiceLineBuffer.Quantity:=SalesQty;
                                        SalesInvoiceLineBuffer.SystemId:=SalesInvoiceLine.SystemId;
                                        SalesInvoiceLineBuffer.Insert();
                                    end;
                                until SalesInvoiceLine.Next() = 0;
                            SalesInvoiceLineBuffer.Reset();
                            SalesInvoiceLineBuffer.SetRange("Document No.", SalesInvoiceHeader."No.");
                            if not(SalesInvoiceLineBuffer.IsEmpty())then if not SalesInvoiceHeaderBuffer.Get(SalesInvoiceHeader."No.")then begin
                                    SalesInvoiceHeaderBuffer.Init();
                                    SalesInvoiceHeaderBuffer.TransferFields(SalesInvoiceHeader, true);
                                    SalesInvoiceHeaderBuffer.SystemId:=SalesInvoiceHeader.SystemId;
                                    SalesInvoiceHeaderBuffer.Insert();
                                    SalesInvoiceHeader.CalcFields(Amount, "Amount Including VAT", "Remaining Amount");
                                    //Amount
                                    CacheMgt.SetFlowField(Database::"Sales Invoice Header", 10000, SalesInvoiceHeader.FieldNo(Amount), 10000, Format(SalesInvoiceHeader.RecordId), LowLevelDP.Decimal2Text(SalesInvoiceHeader.Amount));
                                    //Amount Including VAT
                                    CacheMgt.SetFlowField(Database::"Sales Invoice Header", 10000, SalesInvoiceHeader.FieldNo("Amount Including VAT"), 10000, Format(SalesInvoiceHeader.RecordId), LowLevelDP.Decimal2Text(SalesInvoiceHeader."Amount Including VAT"));
                                    //Remaining Amount
                                    CacheMgt.SetFlowField(Database::"Sales Invoice Header", 10000, SalesInvoiceHeader.FieldNo("Remaining Amount"), 10000, Format(SalesInvoiceHeader.RecordId), LowLevelDP.Decimal2Text(SalesInvoiceHeader."Remaining Amount"));
                                end;
                        end;
                    until SalesInvoiceHeader.Next() = 0;
            until CustomerRecRef.Next() = 0;
        SalesInvoiceHeaderBuffer.Reset();
        SalesInvoiceLineBuffer.Reset();
        ILEBuffer.Reset();
        RecRefSalesInvoiceHeader.GetTable(SalesInvoiceHeaderBuffer);
        RecRefSalesInvoiceLine.GetTable(SalesInvoiceLineBuffer);
        RecRefILE.GetTable(ILEBuffer);
        TableBufMgt.SetTableBuffer(RecRefSalesInvoiceHeader);
        TableBufMgt.SetTableBuffer(RecRefSalesInvoiceLine);
        TableBufMgt.SetTableBuffer(RecRefILE);
    end;
    #endregion 
    #region Label Methods
    procedure L_T_SalesHeader(): text begin
        exit(T_SalesHeader);
    end;
    #endregion 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::DYM_GlobalDataProcess, 'OnProcessPullTableSpecific', '', false, false)]
    local procedure OnProcessPullTableSpecific(var ParentTableMap: Record DYM_MobileTableMap; var TableMap: Record DYM_MobileTableMap; var FilterRecordRef: RecordRef);
    begin
        //Call the PullProcessReturnsData method for the Sales Invoice Header table as it is the parent table
        if(TableMap."Table No." = Database::"Sales Invoice Header")then PullProcessReturnsData(ParentTableMap, TableMap, FilterRecordRef);
    end;
}
