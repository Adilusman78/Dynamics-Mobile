codeunit 70108 DYM_ConstManagement
{
    var MobileFieldMap: Record DYM_MobileFieldMap;
    SyncLog: Record DYM_SyncLog;
    PostProcessLog: Record DYM_PostProcessLog;
    EventLog: Record DYM_EventLog;
    DataLog: Record DYM_DataLog;
    Error_0001: Label 'You cannot rename records in %1 table.';
    #region Messages
    Message_0001: Label 'Changing the %1 field will delete the setting for %2. Do you want to continue?';
    Message_0002: Label 'Are you sure you want to perform synchronization?';
    Message_0003: Label 'XML Files (*.xml)|*.xml|Packet Files (*.packet)|*.packet|CHL Files (*.chl)|*.chl|Push files (*.push)|*.push|All Files (*.*)|*.*';
    Message_0004: Label 'You must specify dimension filter first.';
    Message_0005: Label 'Do you want to delete the %1?';
    Message_0006: Label 'Reply to  ';
    Message_0007: Label 'Message   ';
    Message_0008: Label 'Press "ENTER" to send the message !';
    Message_0009: Label 'Processing Buffer [%1] Record [%2].';
    Message_0010: Label 'Creating document in table [%1] record [%2].';
    Message_0011: Label 'Modifying document in table [%1] record [%2].';
    Message_0015: Label 'Message has been sent to %1';
    Message_0016: Label 'Please complete the form before sending.';
    Message_0019: Label 'Message has been sent to Group of Users.';
    Message_0020: Label 'Message has been sent to All users.';
    Message_0021: Label 'You must specify setting with type [%1] code [%2] for Device Role [%3] Device Group [%4] Device [%5].';
    Message_0022: Label 'You must specify setting with type [%1] code [%2] for Device Role [%3] Device Group [%4].';
    Message_0023: Label 'You must specify setting with type [%1] code [%2] for Device Role [%3].';
    Message_0024: Label 'Field value not found in packet file for table [%1] field [%2]';
    #endregion 
    #region Version (DMV)
    procedure DMV_Version(): Text[250]begin
        exit('Dynamics Mobile 4.20 for NAV 2017 W1');
    end;
    #endregion 
    #region Sync (SYN)
    procedure SYN_PrimaryTag(): Text[250]begin
        exit('NavMobileSync');
    end;
    procedure SYN_TypeTag(): Text[250]begin
        exit('type');
    end;
    procedure SYN_Table(): Text[250]begin
        exit('table');
    end;
    procedure SYN_TableName(): Text[250]begin
        exit('tablename');
    end;
    procedure SYN_Record(): Text[250]begin
        exit('r');
    end;
    procedure SYN_RecordType(): Text[250]begin
        exit('status');
    end;
    procedure SYN_DeviceSetup(): Text[250]begin
        exit('salesmancode');
    end;
    procedure SYN_DeviceGroup(): Text[250]begin
        exit('roleid');
    end;
    procedure SYN_DeviceRole(): Text[250]begin
        exit('syncid');
    end;
    procedure SYN_SyncType(): Text[250]begin
        exit('synctype');
    end;
    procedure SYN_Challenge(): Text[250]begin
        exit('challange');
    end;
    procedure SYN_PullInit(): Text[250]begin
        exit('<?xml version="1.0" encoding="UTF-8"?>');
    end;
    procedure SYN_PullNode(): Text[250]begin
        exit('string');
    end;
    procedure SYN_Validate(): Text[250]begin
        exit('validate');
    end;
    procedure SYN_DirectResponse(): Text[250]begin
        exit(WSC_CallPolicy_DirectResponse);
    end;
    procedure SYN_Context(): Text[250]begin
        exit('context');
    end;
    #endregion 
    #region Metadata (MTD)
    procedure MTD_Metadata_PrimaryTag(): Text[250]begin
        exit('$metadata');
    end;
    procedure MTD_Metadata_Packet_Tag(): Text[250]begin
        exit('packet');
    end;
    procedure MTD_Metadata_Packet_Timestamp(): Text[250]begin
        exit('timestamp');
    end;
    procedure MTD_TablePull_Duration(): Text[250]begin
        exit('duration');
    end;
    procedure MTD_TablePull_DurationDesc(): Text[250]begin
        exit('durationDesc');
    end;
    procedure MTD_TablePull_RecordsCount(): Text[250]begin
        exit('recordsCount');
    end;
    #endregion 
    #region Constants (CNS)
    procedure CNS_Const(): Text[250]begin
        exit('CONST');
    end;
    #endregion 
    #region Field Data Types (FDT)
    procedure FDT_Integer(): Integer begin
        exit(34559);
    end;
    procedure FDT_Option(): Integer begin
        exit(35583);
    end;
    procedure FDT_BigInteger(): Integer begin
        exit(36095);
    end;
    procedure FDT_Decimal(): Integer begin
        exit(12799);
    end;
    procedure FDT_Boolean(): Integer begin
        exit(34047);
    end;
    procedure FDT_Date(): Integer begin
        exit(11775);
    end;
    procedure FDT_Time(): Integer begin
        exit(11776);
    end;
    procedure FDT_DateTime(): Integer begin
        exit(37375);
    end;
    procedure FDT_Code(): Integer begin
        //EXIT ( 35071 ) ;
        exit(31489);
    end;
    procedure FDT_Text(): Integer begin
        //EXIT ( 11519 ) ;
        exit(31488);
    end;
    procedure FDT_BLOB(): Integer begin
        exit(33793);
    end;
    procedure FDT_Media(): Integer begin
        exit(26207);
    end;
    #endregion 
    #region Field Classes (FDC)
    procedure FDC_Normal(): Integer begin
        exit(0);
    end;
    procedure FDC_FlowField(): Integer begin
        exit(1);
    end;
    procedure FDC_FlowFilter(): Integer begin
        exit(2);
    end;
    #endregion 
    #region Validate Text (VTX)
    procedure VTX_InvalidChars(): Text[30]begin
        exit(' ()-.');
    end;
    procedure VTX_SearchChars(): Text[30]begin
        exit('."\/');
    end;
    procedure VTX_ReplaceChars(): Text[30]begin
        exit('____');
    end;
    #endregion 
    #region Devices Structure (DES)
    procedure DES_NamespacePrefix(): Text begin
        exit('des');
    end;
    procedure DES_NamespaceURI(): Text[250]begin
        exit('http://www.mobile-affairs.com/xmlns/des');
    end;
    procedure DES_Init(): Text[250]begin
        exit('<?xml version="1.0"?>');
    end;
    procedure DES_TypeValue(): Text[250]begin
        exit('des');
    end;
    procedure DES_Roles(): Text[250]begin
        exit('roles');
    end;
    procedure DES_Role(): Text[250]begin
        exit('role');
    end;
    procedure DES_RoleCode(): Text[250]begin
        exit('code');
    end;
    procedure DES_RoleDescription(): Text[250]begin
        exit('description');
    end;
    procedure DES_Groups(): Text[250]begin
        exit('groups');
    end;
    procedure DES_Group(): Text[250]begin
        exit('group');
    end;
    procedure DES_GroupCompany(): Text[250]begin
        exit('company');
    end;
    procedure DES_GroupRole(): Text[250]begin
        exit('role');
    end;
    procedure DES_GroupCode(): Text[250]begin
        exit('code');
    end;
    procedure DES_GroupDescription(): Text[250]begin
        exit('description');
    end;
    procedure DES_GroupEnabled(): Text[250]begin
        exit('enabled');
    end;
    procedure DES_Devices(): Text[250]begin
        exit('devices');
    end;
    procedure DES_Device(): Text[250]begin
        exit('device');
    end;
    procedure DES_DeviceRole(): Text[250]begin
        exit('role');
    end;
    procedure DES_DeviceGroup(): Text[250]begin
        exit('group');
    end;
    procedure DES_DeviceCode(): Text[250]begin
        exit('code');
    end;
    procedure DES_DeviceDescription(): Text[250]begin
        exit('description');
    end;
    procedure DES_DeviceEnabled(): Text[250]begin
        exit('enabled');
    end;
    procedure DES_DeviceLocation(): Text[250]begin
        exit('location');
    end;
    procedure DES_DeviceSalesperson(): Text[250]begin
        exit('salesperson');
    end;
    procedure DES_Settings(): Text[250]begin
        exit('settings');
    end;
    procedure DES_Setting(): Text[250]begin
        exit('setting');
    end;
    procedure DES_SettingDeviceRole(): Text[250]begin
        exit('devicerole');
    end;
    procedure DES_SettingDeviceGroup(): Text[250]begin
        exit('devicegroup');
    end;
    procedure DES_SettingDeviceCode(): Text[250]begin
        exit('devicecode');
    end;
    procedure DES_SettingType(): Text[250]begin
        exit('type');
    end;
    procedure DES_SettingCode(): Text[250]begin
        exit('code');
    end;
    procedure DES_SettingValue(): Text[250]begin
        exit('value');
    end;
    #endregion 
    #region Database Structure (DBS)
    procedure DBS_NamespacePrefix(): Text[250]begin
        exit('dbs');
    end;
    procedure DBS_NamespaceURI(): Text[250]begin
        exit('http://www.mobile-affairs.com/xmlns/dbs');
    end;
    procedure DBS_Init(): Text[250]begin
        exit('<?xml version="1.0"?>');
    end;
    procedure DBS_TypeValue(): Text[250]begin
        exit('dbs');
    end;
    procedure DBS_Role(): Text[250]begin
        exit('role');
    end;
    procedure DBS_RoleCode(): Text[250]begin
        exit('rolecode');
    end;
    procedure DBS_Table(): Text[250]begin
        exit('table');
    end;
    procedure DBS_TableName(): Text[250]begin
        exit('syncname');
    end;
    procedure DBS_TableEnabled(): Text[250]begin
        exit('enabled');
    end;
    procedure DBS_TableDirection(): Text[250]begin
        exit('direction');
    end;
    procedure DBS_TablePriority(): Text[250]begin
        exit('priority');
    end;
    procedure DBS_NAVTableName(): Text[250]begin
        exit('bename');
    end;
    procedure DBS_NAVTableNo(): Text[250]begin
        exit('beid');
    end;
    procedure DBS_Field(): Text[250]begin
        exit('field');
    end;
    procedure DBS_FieldName(): Text[250]begin
        exit('syncname');
    end;
    procedure DBS_FieldDataType(): Text[250]begin
        exit('bedatatype');
    end;
    procedure DBS_FieldSQLDataType(): Text[250]begin
        exit('sqldatatype');
    end;
    procedure DBS_FieldSize(): Text[250]begin
        exit('fieldsize');
    end;
    procedure DBS_FieldInPrimaryKey(): Text[250]begin
        exit('primarykey');
    end;
    procedure DBS_FieldEnabled(): Text[250]begin
        exit('enabled');
    end;
    procedure DBS_NAVFieldNo(): Text[250]begin
        exit('beido');
    end;
    procedure DBS_NAVFieldName(): Text[250]begin
        exit('bename');
    end;
    procedure DBS_FieldRelational(): Text[250]begin
        exit('relational');
    end;
    #endregion 
    #region Cache Buffer Flags (CBF)
    procedure CBF_Validate(): Text[250]begin
        exit(SYN_Validate);
    end;
    procedure CBF_DirectResponse(): Text[250]begin
        exit(WSC_CallPolicy_DirectResponse);
    end;
    procedure CBF_Context(): Text[250]begin
        exit(SYN_Context);
    end;
    procedure CBF_Key(): Text[250]begin
        exit('key');
    end;
    #endregion 
    #region Settings (BOS)
    procedure BOS_ProcessBlockedCustomers(): Text[250]begin
        exit('Process Blocked Customers');
    end;
    procedure BOS_ProcessBlockedItems(): Text[250]begin
        exit('Process Blocked Items');
    end;
    procedure BOS_CustomerWorkType(): Text[250]begin
        exit('Customer Work Type');
    end;
    procedure BOS_CustomerWorkType_Billto(): Text[250]begin
        exit('Bill-to');
    end;
    procedure BOS_CustomerWorkType_Sellto(): Text[250]begin
        exit('Sell-to');
    end;
    procedure BOS_BaseLocationFilter(): Text[250]begin
        exit('Base Location Filter');
    end;
    procedure BOS_DateTimeOffset(): Text[250]begin
        exit('DateTimeOffset');
    end;
    procedure BOS_UseCustomerBalance(): Text[250]begin
        exit('Use Customer Balance');
    end;
    procedure BOS_UsePayments(): Text[250]begin
        exit('Use Payments');
    end;
    procedure BOS_UseTransfers(): Text[250]begin
        exit('Use Transfers');
    end;
    procedure BOS_UseNamesInMapping(): Text[250]begin
        exit('Use Names In Mapping');
    end;
    procedure BOS_PaymentJournalTemplateName(): Text[250]begin
        exit('Payment Journal Template Name');
    end;
    procedure BOS_PaymentJournalBatchName(): Text[250]begin
        exit('Payment Journal Batch Name');
    end;
    procedure BOS_SalesOrderNos(): Text[250]begin
        exit('Sales Order Nos.');
    end;
    procedure BOS_SalesReturnOrderNos(): Text[250]begin
        exit('Sales Return Order Nos.');
    end;
    procedure BOS_CreateCreditMemo(): Text[250]begin
        exit('CreateCreditMemo');
    end;
    procedure BOS_PrinterSelection(): Text[250]begin
        exit('PrinterSelection');
    end;
    procedure BOS_PaymentBalAccountType(): Text[250]begin
        exit('Payment Bal. Account Type');
    end;
    procedure BOS_PaymentBalAccountNo(): Text[250]begin
        exit('Payment Bal. Account No.');
    end;
    procedure BOS_TransferReplLocation(): Text[250]begin
        exit('Transfer Repl. Location');
    end;
    procedure BOS_TransferReplInTransit(): Text[250]begin
        exit('Transfer Repl. In-Transit');
    end;
    procedure BOS_TransferOrderNos(): Text[250]begin
        exit('Transfer Order Nos.');
    end;
    procedure BOS_UseDirectTransferOrder(): Text[250]begin
        exit('UseDirectTransferOrder');
    end;
    procedure BOS_TransferDefaultInTransitLocation(): Text[250]begin
        exit('TransferDefaultInTransitLocation');
    end;
    procedure BOS_WhseJournalTemplate(): Text[250]begin
        exit('Whse. Journal Template');
    end;
    procedure BOS_WhseJournalBatch(): Text[250]begin
        exit('Whse. Journal Batch');
    end;
    procedure BOS_WhseJournalNoSeries(): Text[250]begin
        exit('Whse. Journal No. Series');
    end;
    procedure BOS_ItemJournalSourceCode(): Text[250]begin
        exit('ItemJournalSourceCode');
    end;
    procedure BOS_ItemJournalTemplate(): Text[250]begin
        exit('ItemJournalTemplate');
    end;
    procedure BOS_ItemJournalBatch(): Text[250]begin
        exit('ItemJournalBatch');
    end;
    procedure BOS_ItemJournalNoSeries(): Text[250]begin
        exit('ItemJournalNoSeries');
    end;
    procedure BOS_ReclassJournalTemplate(): Text[250]begin
        EXIT('Reclass Journal Template');
    end;
    procedure BOS_ReclassJournalBatch(): Text[250]begin
        EXIT('Reclass Journal Batch');
    end;
    procedure BOS_ReclassJournalNos()Result: Text[250]begin
        EXIT('Reclass Journal Nos.');
    end;
    procedure BOS_PhysicalJournalNos()Result: Text[250]begin
        EXIT('Physical Journal Nos.');
    end;
    procedure BOS_SkipMissingTags(): Text[250]begin
        exit('Skip Missing Tags');
    end;
    procedure BOS_ResponsibilityCenter(): Text[250]begin
        exit('Responsibility Center');
    end;
    procedure BOS_AutoPost_Pick(): Text[250]begin
        exit('AutoPost_Pick');
    end;
    procedure BOS_AutoPost_PutAway(): Text[250]begin
        exit('AutoPost_PutAway');
    end;
    procedure BOS_AutoPost_Movement(): Text[250]begin
        exit('AutoPost_Movement');
    end;
    procedure BOS_AutoPost_InvMovement(): Text[250]begin
        exit('AutoPost_InvMovement');
    end;
    procedure BOS_AutoPost_InvPutAway(): Text[250]begin
        exit('AutoPost_InvPutAway');
    end;
    procedure BOS_AutoPost_WhseShipment(): Text[250]begin
        exit('AutoPost_WhseShipment');
    end;
    procedure BOS_AutoPost_WhseReceipt(): Text[250]begin
        exit('AutoPost_WhseReceipt');
    end;
    procedure BOS_AutoPost_SalesInvoice(): Text[250]begin
        exit('AutoPost_SalesInvoice');
    end;
    procedure BOS_AutoPost_SalesCreditMemo(): Text[250]begin
        exit('AutoPost_SalesCreditMemo');
    end;
    procedure BOS_AutoPost_SalesReturnOrder(): Text[250]begin
        exit('AutoPost_SalesReturnOrder');
    end;
    procedure BOS_AutoPost_SalesOrder_Ship(): Text[250]begin
        exit('AutoPost_SalesOrder_Ship');
    end;
    procedure BOS_AutoPost_SalesOrder_Invoice(): Text[250]begin
        exit('AutoPost_SalesOrder_Invoice');
    end;
    procedure BOS_AutoPost_PurchaseOrder(): Text[250]begin
        exit('AutoPost_PurchaseOrder');
    end;
    procedure BOS_AutoPost_PurchaseOrder_Receive(): Text[250]begin
        exit('AutoPost_PurchaseOrder_Receive');
    end;
    procedure BOS_AutoPost_PurchaseOrder_Invoice(): Text[250]begin
        exit('AutoPost_PurchaseOrder_Invoice');
    end;
    procedure BOS_AutoPost_TransOrder_Ship(): Text[250]begin
        exit('AutoPost_TransOrder_Ship');
    end;
    procedure BOS_AutoPost_TransOrder_Receive(): Text[250]begin
        exit('AutoPost_TransOrder_Receive');
    end;
    procedure BOS_AutoPost_ItemJournal(): Text[250]begin
        exit('AutoPost_ItemJournal');
    end;
    procedure BOS_AutoPost_WhseJournal(): Text[250]begin
        exit('AutoPost_WhseJournal');
    end;
    procedure BOS_AutoPost_VendorReceipt(): Text[250]begin
        exit('AutoPost_VendorReceipt');
    end;
    procedure BOS_DefaultPrinter(): Text[250]begin
        exit('Default Printer');
    end;
    procedure BOS_Print_WhseShipment(): Text[250]begin
        exit('Print_WhseShipment');
    end;
    procedure BOS_Print_WhseReceipt(): Text[250]begin
        exit('Print_WhseReceipt');
    end;
    procedure BOS_Print_WhsePick(): Text[250]begin
        exit('Print_WhsePick');
    end;
    procedure BOS_Print_WhsePutAway(): Text[250]begin
        exit('Print_WhsePutAway');
    end;
    procedure BOS_Print_WhseMovement(): Text[250]begin
        exit('Print_WhseMovement');
    end;
    procedure BOS_Print_PurchReceipt(): Text[250]begin
        exit('Print_PurchReceipt');
    end;
    procedure BOS_Print_TransReceipt(): Text[250]begin
        exit('Print_TransReceipt');
    end;
    procedure BOS_Print_SalesReturnRcpt(): Text[250]begin
        exit('Print_SalesReturnReceipt');
    end;
    procedure BOS_bulkSMSActive(): Text[250]begin
        exit('bulkSMS Active');
    end;
    procedure BOS_bulkSMSAPIURL(): Text[250]begin
        exit('bulkSMS API URL');
    end;
    procedure BOS_bulkSMSUsername(): Text[250]begin
        exit('bulkSMS Username');
    end;
    procedure BOS_bulkSMSPassword(): Text[250]begin
        exit('bulkSMS Password');
    end;
    procedure BOS_StockTakeWorkType()Result: Text[250]begin
        exit('StockTake Work Type');
    end;
    procedure BOS_InventWarehouseId()Result: text[250]begin
        exit('InventWarehouseId');
    end;
    procedure BOS_MainWarehouseId()Result: text[250]begin
        exit('MainWarehouseId');
    end;
    procedure BOS_LoadWarehouseId()Result: text[250]begin
        exit('LoadWarehouseId');
    end;
    procedure BOS_UnloadWarehouseId()Result: text[250]begin
        exit('UnloadWarehouseId');
    end;
    procedure BOS_DamageWarehouseId()Result: text[250]begin
        exit('DamageWarehouseId');
    end;
    procedure BOS_StockTakeWorkType_Inventory()Result: Text[250]begin
        exit('Inventory');
    end;
    procedure BOS_StockTakeWorkType_Warehouse()Result: Text[250]begin
        exit('Warehouse');
    end;
    procedure BOS_PacketStorageType()Result: Text begin
        exit('PacketStorageType');
    end;
    procedure BOS_PacketStorageType_FileSystem()Result: Text begin
        exit('FileSystem');
    end;
    procedure BOS_PacketStorageType_Azure()Result: Text begin
        exit('Azure');
    end;
    procedure BOS_PacketStorageType_DMCloud()Result: Text begin
        exit('DMCloud');
    end;
    procedure BOS_SalesOrderHistoryDays(): Text[250]begin
        exit('SalesOrderHistoryDays');
    end;
    procedure BOS_MaxJobProcessCalls(): Text[250]begin
        exit('MaxJobProcessCalls');
    end;
    procedure BOS_JobProcessCallDelay(): Text[250]begin
        exit('JobProcessCallDelay');
    end;
    procedure BOS_whAllowConfirmGreaterQtyInOutTr(): Text[250]begin
        exit('whAllowConfirmGreaterQtyInOutTr');
    end;
    procedure BOS_whAllowConfirmGreaterQtyInShip(): Text[250]begin
        exit('whAllowConfirmGreaterQtyInShip');
    end;
    procedure BOS_TrackingSeesReservations(): Text[250]begin
        exit('TrackingSeesReservations');
    end;
    procedure BOS_TrackingMakesReservations(): Text[250]begin
        exit('TrackingMakesReservations');
    end;
    procedure BOS_PaymentsUseMobileNo(): Text[250]begin
        exit('PaymentsUseMobileNo');
    end;
    procedure BOS_DisableEnvIdCheck(): Text[250]begin
        exit('DisableEnvIdCheck');
    end;
    procedure BOS_SkipCreditedReturnInvoices(): Text[250]begin
        exit('SkipCreditedReturnInvoices');
    end;
    procedure BOS_ReverseNavigateDateFilter(): Text[250]begin
        exit('ReverseNavigateDateFilter');
    end;
    procedure BOS_AutoPost_Delivery_Ship(): Text[250]begin
        exit('AutoPost_Delivery_Ship');
    end;
    procedure BOS_AutoPost_Delivery_Invoice(): Text[250]begin
        exit('AutoPost_Delivery_Invoice');
    end;
    procedure BOS_HeartBeatRecordCount(): Text[250]begin
        exit('HeartBeatRecordCount');
    end;
    procedure BOS_HeartBeatActive(): Text[250]begin
        exit('HeartBeatActive');
    end;
    procedure BOS_GeneratePullPacketMetadata(): Text[250]begin
        exit('GeneratePullPacketMetadata');
    end;
    procedure BOS_Prod_Output_JournalTemplate(): Text[250]begin
        exit('Prod_Output_JournalTemplate');
    end;
    procedure BOS_Prod_Output_JournalBatch(): Text[250]begin
        exit('Prod_Output_JournalBatch');
    end;
    procedure BOS_AutoPost_Prod_Output(): Text[250]begin
        exit('AutoPost_Prod_Output');
    end;
    procedure BOS_Prod_Consump_JournalTemplate(): Text[250]begin
        exit('Prod_Consump_JournalTemplate');
    end;
    procedure BOS_Prod_Consump_JournalBatch(): Text[250]begin
        exit('Prod_Consump_JournalBatch');
    end;
    procedure BOS_AutoPost_Prod_Consump(): Text[250]begin
        exit('AutoPost_Prod_Consump');
    end;
    procedure BOS_StockCorrection_WhseJournalTemplate(): Text[250]begin
        exit('StockCorrection_WhseJournalTemplate');
    end;
    procedure BOS_StockCorrection_WhseJournalBatch(): Text[250]begin
        exit('StockCorrection_WhseJournalBatch');
    end;
    procedure BOS_StockCorrection_WhseJournalNoSeries(): Text[250]begin
        exit('StockCorrection_WhseJournalNoSeries');
    end;
    #endregion 
    #region Settings Publish Value (SPV)
    procedure SPV_NoValue(): Text[250]begin
        exit('[No Value]');
    end;
    #endregion 
    #region Byte Codes - ASCII (BYT)
    procedure BYT_TAB(): Integer begin
        exit(9);
    end;
    #endregion 
    #region Colors (CLR)
    procedure CLR_Attention(): Integer begin
        exit(770049);
    end;
    procedure CLR_ProblemSeverity1(): Integer begin
        exit(33023);
    end;
    procedure CLR_ProblemSeverity2(): Integer begin
        exit(255);
    end;
    procedure CLR_Debug(): Integer begin
        exit(16711680);
    end;
    #endregion 
    #region Filename Format String (FFS)
    procedure FFS_DateTime(): Text[250]begin
        exit('<Year4><Month,2><Date,2><Hours><Minutes><Seconds>');
    end;
    #endregion 
    #region Report Procedure Call (RPC)
    procedure RPC_Result(): Text[250]begin
        exit('result');
    end;
    procedure RPC_VirtualTableName(): Text[250]begin
        exit('$rpc');
    end;
    procedure RPC_Call(): Text[250]begin
        exit('call');
    end;
    procedure RPC_ObjectType(): Text[250]begin
        exit('objecttype');
    end;
    procedure RPC_ObjectNo(): Text[250]begin
        exit('objectno');
    end;
    procedure RPC_DataIn(): Text[250]begin
        exit('datain');
    end;
    procedure RPC_DataOut(): Text[250]begin
        exit('dataout');
    end;
    procedure RPC_DataKey(): Text[250]begin
        exit('key');
    end;
    procedure RPC_Records(): Text[250]begin
        EXIT('records');
    end;
    procedure RPC_SystemRecID(): Text[250]begin
        EXIT('-1');
    end;
    #endregion 
    #region RPC Object Types (ROT)
    procedure ROT_Codeunit(): Text[250]begin
        exit('codeunit');
    end;
    procedure ROT_Report(): Text[250]begin
        exit('report');
    end;
    procedure ROT_Dataport(): Text[250]begin
        exit('dataport');
    end;
    procedure ROT_Command(): Text[250]begin
        exit('command');
    end;
    #endregion 
    #region Context (CTX)
    procedure CTX_ContextVariable(): Text[250]begin
        exit('$' + SYN_Context);
    end;
    procedure CTX_Setting(): Text[250]begin
        exit('$setting');
    end;
    #endregion 
    #region Packet Record Status (PRS)
    procedure PRS_Create(): Text[250]begin
        exit('inserted');
    end;
    procedure PRS_Read(): Text[250]begin
        exit('read');
    end;
    procedure PRS_Update(): Text[250]begin
        exit('updated');
    end;
    procedure PRS_Delete(): Text[250]begin
        exit('deleted');
    end;
    #endregion 
    #region CRUD (CRD)
    procedure CRD_None(): Integer begin
        exit(0);
    end;
    procedure CRD_Create(): Integer begin
        exit(1);
    end;
    procedure CRD_Read(): Integer begin
        exit(2);
    end;
    procedure CRD_Update(): Integer begin
        exit(3);
    end;
    procedure CRD_Delete(): Integer begin
        exit(4);
    end;
    #endregion 
    #region Web Services (WSC)
    procedure WSC_PrimaryTag(): Text[250]begin
        exit('NavMobileSync');
    end;
    procedure WSC_DeviceRole(): Text[250]begin
        exit('devicerole');
    end;
    procedure WSC_Table(): Text[250]begin
        exit('table');
    end;
    procedure WSC_TableName(): Text[250]begin
        exit('tablename');
    end;
    procedure WSC_TableFilters(): Text[250]begin
        exit('filters');
    end;
    procedure WSC_TableData(): Text[250]begin
        exit('data');
    end;
    procedure WSC_TableStatus(): Text[250]begin
        exit('status');
    end;
    procedure WSC_TableStatus_OK(): Text[250]begin
        exit('OK');
    end;
    procedure WSC_TableStatus_NotFound(): Text[250]begin
        exit('notfound');
    end;
    procedure WSC_Result(): Text[250]begin
        exit('result');
    end;
    procedure WSC_ErrorDescription(): Text[250]begin
        exit('errorDescription');
    end;
    procedure WSC_RequestID(): Text[250]begin
        exit('requestID');
    end;
    procedure WSC_CallTriggers(): Text[250]begin
        exit('calltriggers');
    end;
    procedure WSC_ErrorCode(): Text[250]begin
        EXIT('errorCode');
    end;
    #endregion 
    #region WS Execution Status (WSC)
    procedure WSC_ExecutionStatus(): Text[250]begin
        exit('executionStatus');
    end;
    procedure WSC_ExecutionStatus_OK(): Text[250]begin
        exit('ok');
    end;
    procedure WSC_ExecutionStatus_Queued(): Text[250]begin
        exit('queued');
    end;
    procedure WSC_ExecutionStatus_Error(): Text[250]begin
        exit('error');
    end;
    #endregion 
    #region WS Call Policy (WSC)
    procedure WSC_CallPolicy(): Text[250]begin
        exit('callpolicy');
    end;
    procedure WSC_CallPolicy_Direct(): Text[250]begin
        exit('direct');
    end;
    procedure WSC_CallPolicy_DirectResponse(): Text[250]begin
        exit('directresponse');
    end;
    procedure WSC_CallPolicy_Queue(): Text[250]begin
        exit('queue');
    end;
    #endregion 
    #region WS Read Policy (WSC)
    procedure WSC_ReadPolicy(): Text[250]begin
        exit('readpolicy');
    end;
    procedure WSC_ReadPolicy_Direct(): Text[250]begin
        exit('direct');
    end;
    procedure WSC_ReadPolicy_Standard(): Text[250]begin
        exit('standard');
    end;
    #endregion 
    #region Base64 Encoding (B64)
    procedure B64_ResultTag(): Text[250]begin
        exit('b64result');
    end;
    procedure B64_FileExtension(): Text[250]begin
        exit('.b64');
    end;
    procedure B64_XMLDateType(): Text[250]begin
        exit('bin.base64');
    end;
    #endregion 
    #region Record Cache Mapping (RCM)
    procedure RCM_Id(): Integer begin
        exit(-1);
    end;
    #endregion 
    #region Statistics (STA)
    procedure STA_HaveLongValue(): Text[250]begin
        exit('[Value]');
    end;
    #endregion 
    #region Post Process Parameters (PPP)
    procedure PPP_WhseShipFromTransOrder(): Text[250]begin
        exit('WhseShipFromTransOrder');
    end;
    procedure PPP_WhseRcptFromTransOrder(): Text[250]begin
        exit('WhseRcptFromTransOrder');
    end;
    procedure PPP_PickFromWhseShipment(): Text[250]begin
        exit('PickFromWhseShipment');
    end;
    procedure PPP_ProcessSnapshots(): Text[250]begin
        exit('ProcessSnapshots');
    end;
    procedure PPP_Print(): Text[250]begin
        exit('Print');
    end;
    procedure PPP_Delivery(): Text[250]begin
        exit('Delivery');
    end;
    #endregion 
    #region Post Processing (PPR)
    procedure PPR_PostProcessActive(): Text[250]begin
        exit('Post Process Active');
    end;
    #endregion 
    #region Role Center Statistics RCS
    procedure RCS_Pending(): Text[250]begin
        exit('PENDING');
    end;
    procedure RCS_Success(): Text[250]begin
        exit('SUCCESS');
    end;
    procedure RCS_Failed(): Text[250]begin
        exit('FAILED');
    end;
    procedure RCS_Error(): Text[250]begin
        exit('ERROR');
    end;
    procedure RCS_Pushes(): Text[250]begin
        exit('PUSHES');
    end;
    procedure RCS_Pulls(): Text[250]begin
        exit('PULLS');
    end;
    procedure RCS_SalesOrder(): Text[250]begin
        exit('SALES ORDERS');
    end;
    procedure RCS_Invoices(): Text[250]begin
        exit('SALES INVOICES');
    end;
    procedure RCS_Payments(): Text[250]begin
        exit('PAYMENTS');
    end;
    procedure RCS_ReturnOrders(): Text[250]begin
        exit('RETURN ORDERS');
    end;
    procedure RCS_InvenotoryLoads(): Text[250]begin
        exit('INVENTORY LOADS');
    end;
    procedure RCS_InvenotoryUnloads(): Text[250]begin
        exit('INVENTORY UNLOADS');
    end;
    procedure RCS_TruckInvenotoryReceive(): Text[250]begin
        exit('TRUCK INVENTORY RECEIVE');
    end;
    procedure RCS_ReceiveInventory(): Text[250]begin
        exit('RECEIVE INVENTORY');
    end;
    procedure RCS_StockCount(): Text[250]begin
        exit('STOCK COUNT');
    end;
    procedure RCS_SalesQuotes(): Text[250]begin
        exit('SALES QUOTES');
    end;
    procedure RCS_WarehouseReceive(): Text[250]begin
        exit('WAREHOUSE RECEIVES');
    end;
    procedure RCS_InboundTransfers(): Text[250]begin
        exit('INBOUND TRANSFERS');
    end;
    procedure RCS_OutboundTransfers(): Text[250]begin
        exit('OUTBOUND TRANSFERS');
    end;
    procedure RCS_Shipments(): Text[250]begin
        exit('SHIPMENTS');
    end;
    procedure RCS_BasicStockCounts(): Text[250]begin
        exit('BASIC STOCK COUNTS');
    end;
    procedure RCS_WarehouseReceipts(): Text[250]begin
        exit('WAREHOUSE RECEIPTS');
    end;
    procedure RCS_WarehousePutAways(): Text[250]begin
        exit('WAREHOUSE PUT-AWAYS');
    end;
    procedure RCS_WMSMovements(): Text[250]begin
        exit('WMS MOVEMENTS');
    end;
    procedure RCS_ManualMovements(): Text[250]begin
        exit('MANUAL MOVEMENTS');
    end;
    procedure RCS_WarehousePicks(): Text[250]begin
        exit('WAREHOUSE PICKS');
    end;
    procedure RCS_WarehouseLoads(): Text[250]begin
        exit('WAREHOUSE LOADS');
    end;
    procedure RCS_WMSStockCounts(): Text[250]begin
        exit('WMS STOCK COUNTS');
    end;
    procedure RCS_BinMovements(): Text[250]begin
        exit('BIN MOVEMENTS');
    end;
    #endregion 
    #region Filters
    procedure OrFilter(VarCount: Integer)Result: Text[250]var
        i: Integer;
    begin
        Clear(Result);
        for i:=1 to(VarCount - 1)do Result:=Result + '%' + Format(i) + '|';
        Result:=Result + '%' + Format(VarCount);
    end;
    #endregion 
    #region Check Point (CHP)
    procedure CHP_SetupCheckPointTimerIntervals(): Integer begin
        exit(100);
    end;
    #endregion 
    #region Dynamics NAV Server (SRV)
    procedure SRV_ServerConfigFilenamePatternWithInstance(): Text[250]begin
        exit('%1\Instances\%2\CustomSettings.config');
    end;
    procedure SRV_ServerConfigFilenamePatternNoInstance(): Text[250]begin
        exit('%1\CustomSettings.config');
    end;
    procedure SRV_ServerNamePattern(): Text[250]begin
        exit('%1\%2');
    end;
    procedure SRV_ConfigFileValueTag(): Text[250]begin
        exit('@value');
    end;
    procedure SRV_DatabaseServerTagFilter(): Text[250]begin
        exit('//appSettings/add[@key=''DatabaseServer'']');
    end;
    procedure SRV_DatabaseInstanceTagFilter(): Text[250]begin
        exit('//appSettings/add[@key=''DatabaseInstance'']');
    end;
    #endregion 
    #region SQL Server (SQL)
    procedure SQL_ScriptFilenameExtension(): Text[250]begin
        exit('sql');
    end;
    procedure SQL_ConnectionStringPattern(): Text[250]begin
        exit('server=%1;database=%2;integrated security=true');
    end;
    procedure SQL_BatchDelimiter()Result: Text[250]begin
        exit('GO');
    end;
    procedure SQL_ScriptType_Apply(): Integer begin
        exit(0); //Apply script
    end;
    procedure SQL_ScriptType_Revert(): Integer begin
        exit(1); //Revert sctipt
    end;
    #endregion 
    #region Object Ranges (RNG)
    procedure RNG_FirstId(): Integer begin
        EXIT(46014505);
    end;
    procedure RNG_LastId(): Integer begin
        EXIT(46015504);
    end;
    procedure RNG_JobQueue_OnPrem(): Integer begin
        exit(46014510);
    end;
    procedure RNG_JobQueue_SaaS(): Integer begin
        exit(84005);
    end;
    procedure RNG_Range_OnPrem_FromId(): Integer begin
        exit(46014505);
    end;
    procedure RNG_Range_OnPrem_ToId(): Integer begin
        exit(46015504);
    end;
    procedure RNG_Range_SaaS_FromId(): Integer begin
        exit(84000);
    end;
    procedure RNG_Range_SaaS_ToId(): Integer begin
        exit(85000);
    end;
    #endregion 
    #region Session Values (SES)
    procedure SES_Prefix(): Text[250]begin
        exit('$');
    end;
    procedure SES_DRC(): Text[250]begin
        exit('DRC');
    end;
    procedure SES_DGC(): Text[250]begin
        exit('DGC');
    end;
    procedure SES_DSC(): Text[250]begin
        exit('DSC');
    end;
    procedure SES_DTO(): Text[250]begin
        exit('DTO');
    end;
    procedure SES_SPC(): Text[250]begin
        exit('SPC');
    end;
    procedure SES_SPN(): Text[250]begin
        exit('SPN');
    end;
    procedure SES_DML(): Text[250]begin
        exit('DML');
    end;
    procedure SES_TDY(): Text[250]begin
        exit('TDY');
    end;
    procedure SES_WDT(): Text[250]begin
        exit('WDT');
    end;
    procedure SES_TIM(): Text[250]begin
        exit('TIM');
    end;
    procedure SES_BLC(): Text[250]begin
        exit('BLC');
    end;
    procedure SES_DPC(): Text[250]begin
        exit('DPC');
    end;
    procedure SES_SOH(): Text[250]begin
        exit('SOH');
    end;
    #endregion 
    #region Cloud (CLD)
    procedure "CLD_APIURL"(): Text begin
        exit('cloud_APIURL');
    end;
    procedure "CLD_xAPIKey"(): Text begin
        exit('cloud_xAPIKey');
    end;
    procedure "CLD_AppArea"(): Text begin
        exit('cloud_AppArea');
    end;
    procedure "CLD_PacketType_Packet"(): Text begin
        exit('packet');
    end;
    procedure "CLD_PacketType_File"(): Text begin
        exit('file');
    end;
    procedure "CLD_EnvIdPattern"(): Text begin
        exit('EnvId_%1');
    end;
    procedure "CLD_NextEnvIdPattern"(): Text begin
        exit('Next' + CLD_EnvIdPattern());
    end;
    procedure "CLD_URL_getPacketDownloadLink"(): Text begin
        exit('cloud_url_getPacketDownloadLink')end;
    procedure "CLD_URL_getPacketUploadLink"(): Text begin
        exit('cloud_url_getPacketUploadLink')end;
    procedure "CLD_URL_fetchPacketsLink"(): Text begin
        exit('cloud_url_fetchPacketsLink');
    end;
    procedure "CLD_URL_markFetchedPackets"(): Text begin
        exit('cloud_url_markFetchedPackets');
    end;
    procedure "CLD_URL_getKeyValuePair"(): Text begin
        exit('cloud_url_getKeyValuePair');
    end;
    procedure "CLD_URL_setKeyValuePair"(): Text begin
        exit('cloud_url_setKeyValuePair');
    end;
    #endregion 
    #region Placeholders (PLH)
    procedure "PLH_AppArea"(): Text begin
        exit('{{AppArea}}')end;
    procedure "PLH_Path"(): Text begin
        exit('{{Path}}')end;
    procedure "PLH_DeviceId"(): Text begin
        exit('{{DeviceId}}')end;
    procedure "PLH_PacketSize"(): Text begin
        exit('{{PacketSize}}')end;
    procedure "PLH_PacketType"(): Text begin
        exit('{{PacketType}}');
    end;
    procedure "PLH_Key"(): Text begin
        exit('{{Key}}');
    end;
    #endregion 
    #region HTTP Status Codes (HTP)
    procedure HTP_200(): Integer begin
        exit(200);
    end;
    #endregion 
    #region System (SYS)
    procedure SYS_SystemId(): Text begin
        exit('SystemId');
    end;
    procedure SYS_DMSRowId(): Text begin
        exit('DMS_ROWID');
    end;
    #endregion 
    #region Mapping Flags (MFL)
    procedure MFL_Reverse(): Text begin
        exit('Reverse');
    end;
    #endregion 
    #region State Variables (STV)
    procedure STV_IntegrityVersionHash(): Text begin
        exit('IntegrityVersionHash');
    end;
    #endregion 
    #region Messages (MSG)
    procedure MSG_0001(): Text[250]begin
        exit(Message_0001);
    end;
    procedure MSG_0002(): Text[250]begin
        exit(Message_0002);
    end;
    procedure MSG_0003(): Text[250]begin
        exit(Message_0003);
    end;
    procedure MSG_0004(): Text[250]begin
        exit(Message_0004);
    end;
    procedure MSG_0005(): Text[250]begin
        exit(Message_0005);
    end;
    procedure MSG_0006(): Text[250]begin
        exit(Message_0006);
    end;
    procedure MSG_0007(): Text[250]begin
        exit(Message_0007);
    end;
    procedure MSG_0008(): Text[250]begin
        exit(Message_0008);
    end;
    procedure MSG_0009(): Text[250]begin
        exit(Message_0009);
    end;
    procedure MSG_0010(): Text[250]begin
        exit(Message_0010);
    end;
    procedure MSG_0011(): Text[250]begin
        exit(Message_0011);
    end;
    procedure MSG_0015(): Text[250]begin
        exit(Message_0015);
    end;
    procedure MSG_0016(): Text[250]begin
        exit(Message_0016);
    end;
    procedure MSG_0019(): Text[250]begin
        exit(Message_0019);
    end;
    procedure MSG_0020(): Text[250]begin
        exit(Message_0020);
    end;
    procedure MSG_0021(): Text[250]begin
        exit(Message_0021);
    end;
    procedure MSG_0022(): Text[250]begin
        exit(Message_0022);
    end;
    procedure MSG_0023(): Text[250]begin
        exit(Message_0023);
    end;
    procedure MSG_0024(): Text[250]begin
        exit(Message_0024);
    end;
    #endregion 
    #region Errors (ERR)
    procedure ERR_0001(): Text[250]begin
        exit(Error_0001);
    end;
    #endregion 
    #region AppInfo (APP)
    procedure APP_OnPrem_ID(): Text begin
        exit('{004c3dd0-43e9-4aa1-8db2-def6bcd919b5}');
    end;
    procedure APP_SaaS_ID(): Text begin
        exit('{9213351d-a55c-4380-8fc5-747a6de9d428}');
    end;
    #endregion 
    #region Debug (DBG)
    procedure DBG_CallStackCache_LineDelimiter(): Text begin
        exit('\');
    end;
    procedure DBG_CallStackCache_PopLevel(): Integer begin
        //The depth level of the Call Stack where target Caller/Method should be found
        exit(4);
    end;
    procedure DBG_CallStackCache_LineElementsDelimiter(): Text begin
        exit('.');
    end;
    procedure DBG_CallStackCache_LineSubElementsDelimiter(): Text begin
        exit(' ');
    end;
    procedure DBG_CallStackCache_CallerObjectPos(): Integer begin
        exit(1);
    end;
    procedure DBG_CallStackCache_CallerMethodPos(): Integer begin
        exit(1);
    end;
    procedure DBG_T_MethodStart(): Text begin
        exit('[MST][%1][%2]');
    end;
    procedure DBG_T_MethodEnd(): Text begin
        exit('[MED][%1][%2]');
    end;
    procedure DBG_T_PullDuration(): Text begin
        exit('[PUL][%1][%2]');
    end;
    procedure DBG_T_APICallDuration(): Text begin
        exit('[API][%1][%2]');
    end;
    #endregion 
    #region HeartBeat (HRT)
    procedure HRT_MessagePattern_Pull(): Text begin
        exit('[%1][%2][%3]');
    end;
    procedure HRT_RecordMessagePattern_Records(): Text begin
        exit('[%1][%2][%3][%4]');
    end;
    procedure HRT_DefaultHeartBeatRecordNumber(): Integer begin
        exit(10000);
    end;
    #endregion 
    #region Default Setting Values (DSV)
    procedure DSV_PacketStorageType(): Text begin
        exit('DMCloud');
    end;
    procedure DSV_cloud_APIURL(): Text begin
        exit('https://api.portal.dynamicsmobile.com	');
    end;
    procedure DSV_cloud_url_fetchPacketsLink(): Text begin
        exit('/mobile/erp/pull/{{AppArea}}?format=xml&packetType={{PacketType}}	');
    end;
    #endregion 
    #region Assisted Setup Help
    procedure ASH_AssistedSetupVideoURL(): Text begin
        exit('https://www.youtube.com/watch?v=' + ASH_AssistedSetupVideoId());
    end;
    procedure ASH_AssistedSetupEmbeddedVideoURL(): Text begin
        exit('https://www.youtube.com/embed/' + ASH_AssistedSetupVideoId());
    end;
    local procedure ASH_AssistedSetupVideoId(): Text begin
        exit('P6kXGmQQ1pM');
    end;
    procedure ASH_AssistedSetupDocURL(): Text begin
        exit('https://docs.dynamicsmobile.com/platform/erp-integrations');
    end;
#endregion 
}
