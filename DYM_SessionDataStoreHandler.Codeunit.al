codeunit 84045 DYM_SessionDataStoreHandler
{
    var SDSMgt: Codeunit DYM_SessionDataStoreManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    K_PPR_StatusFlag_Template: Label 'PP_StatusFlag [%1]', Locked = true;
    V_PPR_StatusFlag_Skipped: Label 'Skipped', Locked = true;
    K_PP_SalesShipmentHeader: Label 'SalesShipmentHeader', Locked = true;
    K_PP_TransferShipmentHeader: Label 'TransferShipmentHeader', Locked = true;
    K_PP_TransferReceiveHeader: Label 'TransferReceiveHeader', Locked = true;
    K_PP_PurchReceiptHeader: Label 'PurchReceiptHeader', Locked = true;
    K_PP_PurchInvoiceHeader: Label 'PurchInvoiceHeader', Locked = true;
    K_PP_PurchCRMemoHeader: Label 'PurchCRMemoHeader', Locked = true;
    #region WhseActivityLine_Split
    procedure WAL_Split_Set(WarehouseActivityLine: Record "Warehouse Activity Line"; NewWarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        SDSMgt.SetValue(WAL_Split_GetKey(WarehouseActivityLine), LowLevelDP.Integer2Text(NewWarehouseActivityLine."Line No."));
    end;
    procedure WAL_Split_Pop(WarehouseActivityLine: Record "Warehouse Activity Line"): Integer begin
        exit(SDSMgt.PopInteger(WAL_Split_GetKey(WarehouseActivityLine)));
    end;
    procedure WAL_Split_GetKey(WarehouseActivityLine: Record "Warehouse Activity Line"): Text begin
        exit(WarehouseActivityLine.GetPosition(false));
    end;
    #endregion 
    #region PPR_StatusFlag
    procedure PP_Flag_Skipped_Set(PostProcessEntry: Record DYM_PostProcessLog)
    begin
        SDSMgt.SetValue(PP_Flag_Skipped_GetKey(PostProcessEntry), V_PPR_StatusFlag_Skipped);
    end;
    procedure PP_Flag_Skipped_Pop(PostProcessEntry: Record DYM_PostProcessLog): Boolean begin
        Exit(SDSMgt.PopValue(PP_Flag_Skipped_GetKey(PostProcessEntry)) = V_PPR_StatusFlag_Skipped);
    end;
    procedure PP_Flag_Skipped_GetKey(PostProcessEntry: Record DYM_PostProcessLog): Text begin
        exit(StrSubstNo(K_PPR_StatusFlag_Template, LowLevelDP.Integer2Text(PostProcessEntry."Entry No.")));
    end;
    #endregion 
    #region PPR_Extended_Document_Logging
    procedure PP_EDL_SalesShipmentHeader_Set(SalesShipmentHeaderNo: Text)
    begin
        SDSMgt.SetValue(K_PP_SalesShipmentHeader, SalesShipmentHeaderNo);
    end;
    procedure PP_EDL_SalesShipmentHeader_Get(): Text begin
        exit(SDSMgt.GetValue(K_PP_SalesShipmentHeader));
    end;
    procedure PP_EDL_TransferShipmentHeader_Set(SalesShipmentHeaderNo: Text)
    begin
        SDSMgt.SetValue(K_PP_TransferShipmentHeader, SalesShipmentHeaderNo);
    end;
    procedure PP_EDL_TransferShipmentHeader_Get(): Text begin
        exit(SDSMgt.GetValue(K_PP_TransferShipmentHeader));
    end;
    procedure PP_EDL_TransferReceiveHeader_Set(TransferShipmentHeaderNo: Text)
    begin
        SDSMgt.SetValue(K_PP_TransferReceiveHeader, TransferShipmentHeaderNo);
    end;
    procedure PP_EDL_TransferReceiveHeader_Get(): Text begin
        exit(SDSMgt.GetValue(K_PP_TransferReceiveHeader));
    end;
    procedure PP_EDL_PurchReceiveHeader_Set(PurchReceiptHeaderNo: Text)
    begin
        SDSMgt.SetValue(K_PP_PurchReceiptHeader, PurchReceiptHeaderNo);
    end;
    procedure PP_EDL_PurchReceiveHeader_Get(): Text begin
        exit(SDSMgt.GetValue(K_PP_PurchReceiptHeader));
    end;
    procedure PP_EDL_PurchInvoiceHeader_Set(PurchInvoiceHeaderNo: Text)
    begin
        SDSMgt.SetValue(K_PP_PurchInvoiceHeader, PurchInvoiceHeaderNo);
    end;
    procedure PP_EDL_PurchInvoiceHeader_Get(): Text begin
        exit(SDSMgt.GetValue(K_PP_PurchInvoiceHeader));
    end;
    procedure PP_EDL_PurchCRMemoHeader_Set(PurchCRMemoHeaderNo: Text)
    begin
        SDSMgt.SetValue(K_PP_PurchCRMemoHeader, PurchCRMemoHeaderNo);
    end;
    procedure PP_EDL_PurchCRMemoHeader_Get(): Text begin
        exit(SDSMgt.GetValue(K_PP_PurchCRMemoHeader));
    end;
#endregion 
}
