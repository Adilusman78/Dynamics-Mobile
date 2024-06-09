codeunit 84024 DYM_PostProcessHandler
{
    #region Variables
    var CacheMgt: Codeunit DYM_CacheManagement;
    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
    SettingsMgt: Codeunit DYM_SettingsManagement;
    StatsMgt: Codeunit DYM_StatisticsManagement;
    DataLogMgt: Codeunit DYM_DataLogManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
    RecordLinkMgt: Codeunit DYM_RecordLinkManagement;
    PostProcessMgt: Codeunit DYM_PostProcessManagement;
    SDSHandler: Codeunit DYM_SessionDataStoreHandler;
    BindPostProcessEventSubs: Codeunit DYM_BindPostProcessEventSubs;
    MobileSetup: Record DYM_DynamicsMobileSetup;
    DeviceRole: Record DYM_DeviceRole;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceSetup: Record DYM_DeviceSetup;
    PostProcessEntry: Record DYM_PostProcessLog;
    SesstionDataStoreHandler: Codeunit DYM_SessionDataStoreHandler;
    SLE: Integer;
    SetupRead: Boolean;
    RecRef: RecordRef;
    Text001: Label 'Document [%1] not found.';
    Text002: Label 'Operation type [%1] with parameters [%2] not supported for table [%3] position [%4].';
    Text003: Label 'Post processing skipped.';
    #endregion 
    procedure SetPostProcessEntry(_PostProcessEntry: Record DYM_PostProcessLog)
    begin
        PostProcessEntry:=_PostProcessEntry;
    end;
    #region Post Process Handlers
    procedure PostProcessWhseActivityHeader()
    var
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        RegWhseActivityHeader: Record "Registered Whse. Activity Hdr.";
        RegWhseActivityLine: Record "Registered Whse. Activity Line";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
        WMSMgt: Codeunit "WMS Management";
        WhsePrint: Codeunit "Warehouse Document-Print";
        WhseActPost: Codeunit "Whse.-Activity-Post";
        PostProcessingSkipped: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        WhseActivityHeader.SetPosition(PostProcessEntry.Position);
        if not WhseActivityHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Register: begin
            if((WhseActivityHeader.Type = WhseActivityHeader.Type::Movement) or (WhseActivityHeader.Type = WhseActivityHeader.Type::"Put-away") or (WhseActivityHeader.Type = WhseActivityHeader.Type::Pick) or (WhseActivityHeader.Type = WhseActivityHeader.Type::"Invt. Movement") or (WhseActivityHeader.Type = WhseActivityHeader.Type::"Invt. Put-away"))then begin
                clear(PostProcessingSkipped);
                case WhseActivityHeader.Type of WhseActivityHeader.Type::Pick: if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_Pick)then SetStatusSkipped();
                WhseActivityHeader.Type::"Put-away": if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_PutAway)then SetStatusSkipped();
                WhseActivityHeader.Type::Movement: if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_Movement)then SetStatusSkipped();
                WhseActivityHeader.Type::"Invt. Movement": if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_InvMovement)then SetStatusSkipped();
                WhseActivityHeader.Type::"Invt. Put-away": if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_InvPutAway())then SetStatusSkipped();
                end;
                Clear(WMSMgt);
                Clear(WhseActivityRegister);
                if(WhseActivityHeader.Type = WhseActivityHeader.Type::Pick)then UpdateWhseActivityTracking(WhseActivityHeader);
                WhseActivityLine.Reset;
                WhseActivityLine.SetRange("Activity Type", WhseActivityHeader.Type);
                WhseActivityLine.SetRange("No.", WhseActivityHeader."No.");
                if WhseActivityLine.FindFirst then begin
                    if(WhseActivityHeader.Type <> WhseActivityHeader.Type::"Invt. Put-away")then begin
                        WMSMgt.CheckBalanceQtyToHandle(WhseActivityLine);
                        WhseActivityRegister.ShowHideDialog(true);
                        //Ext
                        //WhseActivityRegister.SetSkipCommit ( TRUE ) ;
                        WhseActivityRegister.Run(WhseActivityLine);
                    end
                    else
                    begin
                        WhseActPost.Run(WhseActivityLine);
                    end;
                end;
                if PostProcessEntry.Subsequent then begin
                    case WhseActivityHeader.Type of WhseActivityHeader.Type::Pick: begin
                        RegWhseActivityHeader.Reset;
                        RegWhseActivityHeader.SetRange(Type, RegWhseActivityHeader.Type::Pick);
                        RegWhseActivityHeader.SetRange("Whse. Activity No.", WhseActivityHeader."No.");
                        if RegWhseActivityHeader.FindFirst then begin
                            RegWhseActivityLine.Reset;
                            RegWhseActivityLine.SetRange("Activity Type", RegWhseActivityHeader.Type);
                            RegWhseActivityLine.SetRange("No.", RegWhseActivityHeader."No.");
                            RegWhseActivityLine.SetRange(RegWhseActivityLine."Whse. Document Type", RegWhseActivityLine."Whse. Document Type"::Shipment);
                            if RegWhseActivityLine.FindFirst then begin
                                WhseShipmentHeader.Get(RegWhseActivityLine."Whse. Document No.");
                                Clear(RecRef);
                                RecRef.GetTable(WhseShipmentHeader);
                                PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Ship, '', PostProcessEntry."Entry No.", true, '');
                                RecRef.Close;
                            end;
                        end;
                    end;
                    end;
                end;
            end;
        end;
        PostProcessEntry."Operation Type"::Print: begin
            Clear(WhsePrint);
            //Ext
            //WhsePrint.SetGlobalHideDialog ( TRUE ) ;
            WhseActivityHeader.SetRecFilter;
            case WhseActivityHeader.Type of WhseActivityHeader.Type::Pick: if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_WhsePick)then WhsePrint.PrintPickHeader(WhseActivityHeader)
                else
                    SetStatusSkipped();
            WhseActivityHeader.Type::"Put-away": if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_WhsePutAway)then WhsePrint.PrintPutAwayHeader(WhseActivityHeader)
                else
                    SetStatusSkipped();
            WhseActivityHeader.Type::Movement: if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_WhseMovement)then WhsePrint.PrintMovementHeader(WhseActivityHeader)
                else
                    SetStatusSkipped();
            end;
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', WhseActivityHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessWhseShptHeader()
    var
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhseShipmentLine: Record "Warehouse Shipment Line";
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        TransferHeader: Record "Transfer Header";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ParentEntryNo: BigInteger;
        Print: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_WhseShipment)then SetStatusSkipped();
        PostProcessEntry.TestField("Entry No.");
        WhseShipmentHeader.SetPosition(PostProcessEntry.Position);
        if not WhseShipmentHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Post: begin
            WhseShipmentLine.Reset;
            WhseShipmentLine.SetRange("No.", WhseShipmentHeader."No.");
            if WhseShipmentLine.FindFirst then begin
                Clear(WhsePostShipment);
                WhsePostShipment.SetPostingSettings(false);
                WhsePostShipment.SetPrint(false);
                //Ext
                //WhsePostShipment.SetSkipCommit ( TRUE ) ;
                WhsePostShipment.Run(WhseShipmentLine);
                WhsePostShipment.GetResultMessage;
                if PostProcessEntry.Subsequent then begin
                    PostedWhseShipmentHeader.Reset;
                    PostedWhseShipmentHeader.SetCurrentKey("Whse. Shipment No.");
                    PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", WhseShipmentHeader."No.");
                    if PostedWhseShipmentHeader.FindFirst then begin
                        PostedWhseShipmentLine.Reset;
                        PostedWhseShipmentLine.SetRange("Source Type", Database::"Transfer Line");
                        PostedWhseShipmentLine.SetRange("No.", PostedWhseShipmentHeader."No.");
                        if PostedWhseShipmentLine.FindFirst then begin
                            TransferHeader.Get(PostedWhseShipmentLine."Source No.");
                            Clear(RecRef);
                            RecRef.GetTable(TransferHeader);
                            PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Custom, ConstMgt.PPP_WhseRcptFromTransOrder, PostProcessEntry."Entry No.", true, '');
                            RecRef.Close;
                        end;
                    end;
                end;
                Clear(Print);
                Print:=PostProcessEntry.Parameters = ConstMgt.PPP_Print;
                if((Print) and (SettingsMgt.CheckSetting(ConstMgt.BOS_Print_WhseShipment)))then begin
                    PostedWhseShipmentHeader.Reset;
                    PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", WhseShipmentHeader."No.");
                    if PostedWhseShipmentHeader.FindLast then begin
                        Clear(RecRef);
                        RecRef.GetTable(PostedWhseShipmentHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                        RecRef.Close;
                    end;
                end;
            end;
        end;
        PostProcessEntry."Operation Type"::Invoice: begin
            WhseShipmentLine.Reset;
            WhseShipmentLine.SetRange("No.", WhseShipmentHeader."No.");
            if WhseShipmentLine.FindFirst then begin
                Clear(WhsePostShipment);
                WhsePostShipment.SetPostingSettings(false);
                WhsePostShipment.SetPrint(false);
                WhsePostShipment.Run(WhseShipmentLine);
                WhsePostShipment.GetResultMessage;
            end;
        end;
        PostProcessEntry."Operation Type"::Custom: begin
            case PostProcessEntry.Parameters of ConstMgt.PPP_PickFromWhseShipment: begin
                Clear(ReleaseWhseShipment);
                ReleaseWhseShipment.Release(WhseShipmentHeader);
                WhseShipmentLine.Reset;
                WhseShipmentLine.SetRange("No.", WhseShipmentHeader."No.");
                WhseShipmentLine.SetHideValidationDialog(true);
                WhseShipmentLine.CreatePickDoc(WhseShipmentLine, WhseShipmentHeader);
                if PostProcessEntry.Subsequent then begin
                    WhseActivityLine.Reset;
                    WhseActivityLine.SetRange("Whse. Document Type", WhseActivityLine."Whse. Document Type"::Shipment);
                    WhseActivityLine.SetRange("Whse. Document No.", WhseShipmentHeader."No.");
                    if WhseActivityLine.FindFirst then begin
                        WhseActivityHeader.Get(WhseActivityLine."Activity Type", WhseActivityLine."No.");
                        Clear(RecRef);
                        RecRef.GetTable(WhseActivityHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Register, '', PostProcessEntry."Entry No.", true, '');
                        RecRef.Close;
                    end;
                end;
            end;
            else
                Error(Text002, Format(PostProcessEntry."Operation Type"), PostProcessEntry.Parameters, WhseShipmentHeader.TableCaption, PostProcessEntry.Position);
            end;
        end;
        PostProcessEntry."Operation Type"::Print: begin
            PostedWhseShipmentHeader.Reset;
            PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", WhseShipmentHeader."No.");
            if PostedWhseShipmentHeader.FindLast then begin
                Clear(RecRef);
                RecRef.GetTable(PostedWhseShipmentHeader);
                PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                RecRef.Close;
            end;
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', WhseShipmentHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessWhseRcptHeader()
    var
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PostedWhseReceipt: Record "Posted Whse. Receipt Header";
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        RecRef: RecordRef;
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        Print: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_WhseReceipt)then SetStatusSkipped();
        PostProcessEntry.TestField("Entry No.");
        WhseReceiptHeader.SetPosition(PostProcessEntry.Position);
        if not WhseReceiptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Post: begin
            Clear(WhsePostReceipt);
            WhseReceiptLine.Reset;
            WhseReceiptLine.SetRange("No.", WhseReceiptHeader."No.");
            if WhseReceiptLine.FindFirst then begin
                //Ext
                //WhsePostReceipt.SetSkipCommit ( TRUE ) ;
                WhsePostReceipt.Run(WhseReceiptLine);
                if(WhseReceiptLine."Source Type" = DATABASE::"Transfer Line")then begin
                    PostedWhseReceipt.Reset;
                    PostedWhseReceipt.SetRange("Whse. Receipt No.", WhseReceiptHeader."No.");
                    if PostedWhseReceipt.FindLast then begin
                        WhseActivityLine.Reset;
                        WhseActivityLine.SetRange("Whse. Document Type", WhseActivityLine."Whse. Document Type"::Receipt);
                        WhseActivityLine.SetRange("Whse. Document No.", PostedWhseReceipt."No.");
                        if WhseActivityLine.FindFirst then begin
                            if WhseActivityHeader.Get(WhseActivityLine."Activity Type", WhseActivityLine."No.")then //Ext
                                //IF ( WhseActivityHeader."Mobile Status" = WhseActivityHeader."Mobile Status"::"0" ) THEN BEGIN
                                //  WhseActivityHeader.VALIDATE ( "Mobile Status" , WhseActivityHeader."Mobile Status"::"1" ) ;
                                //  WhseActivityHeader.MODIFY ( TRUE ) ;
                                //END ;
                                WhseActivityLine.DeleteQtyToHandle(WhseActivityLine);
                        end;
                    end;
                end;
                Clear(Print);
                Print:=PostProcessEntry.Parameters = ConstMgt.PPP_Print;
                if((Print) and (SettingsMgt.CheckSetting(ConstMgt.BOS_Print_WhseReceipt)))then begin
                    PostedWhseReceipt.Reset;
                    PostedWhseReceipt.SetRange("Whse. Receipt No.", WhseReceiptHeader."No.");
                    if PostedWhseReceipt.FindLast then begin
                        Clear(RecRef);
                        RecRef.GetTable(PostedWhseReceipt);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                        RecRef.Close;
                    end;
                end;
            end;
        end;
        PostProcessEntry."Operation Type"::Print: begin
            PostedWhseReceipt.Reset;
            PostedWhseReceipt.SetRange("Whse. Receipt No.", WhseReceiptHeader."No.");
            if PostedWhseReceipt.FindLast then begin
                Clear(RecRef);
                RecRef.GetTable(PostedWhseReceipt);
                PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                RecRef.Close;
            end;
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', WhseReceiptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessTransferHeader()
    var
        TransferHeader: Record "Transfer Header";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhseShipmentLine: Record "Warehouse Shipment Line";
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        ReleaseTransfer: Codeunit "Release Transfer Document";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        TransOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransOrderPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferShipmentHeaderDocNo, TransferReceiveHeaderDocNo: Text;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        TransferHeader.SetPosition(PostProcessEntry.Position);
        if not TransferHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Ship: begin
            if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_TransOrder_Ship()))then begin
                BindSubscription(BindPostProcessEventSubs);
                Clear(TransOrderPostShipment);
                TransOrderPostShipment.SetHideValidationDialog(true);
                TransOrderPostShipment.Run(TransferHeader);
                TransferShipmentHeaderDocNo:=SDSHandler.PP_EDL_TransferShipmentHeader_Get();
                if(TransferShipmentHeader.Get(TransferShipmentHeaderDocNo))then begin
                    RecRef.GetTable(TransferShipmentHeader);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
                UnbindSubscription(BindPostProcessEventSubs);
            end
            else
                SetStatusSkipped();
        end;
        PostProcessEntry."Operation Type"::Receive: begin
            if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_TransOrder_Receive()))then begin
                BindSubscription(BindPostProcessEventSubs);
                Clear(TransOrderPostReceipt);
                TransOrderPostReceipt.SetHideValidationDialog(true);
                TransOrderPostReceipt.Run(TransferHeader);
                TransferReceiveHeaderDocNo:=SDSHandler.PP_EDL_TransferReceiveHeader_Get();
                if(TransferReceiptHeader.Get(TransferReceiveHeaderDocNo))then begin
                    RecRef.GetTable(TransferReceiptHeader);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
                UnbindSubscription(BindPostProcessEventSubs);
            end
            else
                SetStatusSkipped();
        end;
        PostProcessEntry."Operation Type"::Custom: begin
            case PostProcessEntry.Parameters of ConstMgt.PPP_WhseShipFromTransOrder: begin
                Clear(ReleaseTransfer);
                ReleaseTransfer.Run(TransferHeader);
                Clear(GetSourceDocOutbound);
                GetSourceDocOutbound.CreateFromOutbndTransferOrder(TransferHeader);
                if PostProcessEntry.Subsequent then begin
                    WhseShipmentLine.Reset;
                    WhseShipmentLine.SetRange("Source Type", DATABASE::"Transfer Line");
                    WhseShipmentLine.SetRange("Source Subtype", 0);
                    WhseShipmentLine.SetRange("Source No.", TransferHeader."No.");
                    if WhseShipmentLine.FindFirst then begin
                        WhseShipmentHeader.Get(WhseShipmentLine."No.");
                        Clear(RecRef);
                        RecRef.GetTable(WhseShipmentHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Custom, ConstMgt.PPP_PickFromWhseShipment, PostProcessEntry."Entry No.", true, '');
                        RecRef.Close;
                    end;
                end;
            end;
            ConstMgt.PPP_WhseRcptFromTransOrder: begin
                Clear(ReleaseTransfer);
                ReleaseTransfer.Run(TransferHeader);
                Clear(GetSourceDocInbound);
                GetSourceDocInbound.CreateFromInbndTransferOrder(TransferHeader);
                if PostProcessEntry.Subsequent then begin
                    WhseReceiptLine.Reset;
                    WhseReceiptLine.SetRange("Source Type", DATABASE::"Transfer Line");
                    WhseReceiptLine.SetRange("Source Subtype", 1);
                    WhseReceiptLine.SetRange("Source No.", TransferHeader."No.");
                    if WhseReceiptLine.FindFirst then begin
                        WhseReceiptHeader.Get(WhseReceiptLine."No.");
                        Clear(RecRef);
                        RecRef.GetTable(WhseReceiptHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, '', PostProcessEntry."Entry No.", true, '');
                        RecRef.Close;
                    end;
                end;
            end;
            else
                Error(Text002, Format(PostProcessEntry."Operation Type"), PostProcessEntry.Parameters, TransferHeader.TableCaption, PostProcessEntry.Position);
            end;
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', TransferHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessPostedWhseShptHdr()
    var
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        SalesShptHeader: Record "Sales Shipment Header";
        TransShptHeader: Record "Transfer Shipment Header";
        ReturnShptHeader: Record "Return Shipment Header";
        SalesShptHeader2Print: Record "Sales Shipment Header" temporary;
        TransShptHeader2Print: Record "Transfer Shipment Header" temporary;
        ReturnShptHeader2Print: Record "Return Shipment Header" temporary;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        PostedWhseShptHeader.SetPosition(PostProcessEntry.Position);
        if not PostedWhseShptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            SalesShptHeader2Print.Reset;
            SalesShptHeader2Print.DeleteAll;
            TransShptHeader2Print.Reset;
            TransShptHeader2Print.DeleteAll;
            ReturnShptHeader2Print.Reset;
            ReturnShptHeader2Print.DeleteAll;
            PostedWhseShptLine.Reset;
            PostedWhseShptLine.SetRange("No.", PostedWhseShptHeader."No.");
            if PostedWhseShptLine.FindSet(false, false)then repeat case PostedWhseShptLine."Posted Source Document" of PostedWhseShptLine."Posted Source Document"::"Posted Shipment": if not SalesShptHeader2Print.Get(PostedWhseShptLine."Posted Source No.")then begin
                            SalesShptHeader2Print.Init;
                            SalesShptHeader2Print."No.":=PostedWhseShptLine."Posted Source No.";
                            SalesShptHeader2Print.Insert;
                        end;
                    PostedWhseShptLine."Posted Source Document"::"Posted Transfer Shipment": if not TransShptHeader2Print.Get(PostedWhseShptLine."Posted Source No.")then begin
                            TransShptHeader2Print.Init;
                            TransShptHeader2Print."No.":=PostedWhseShptLine."Posted Source No.";
                            TransShptHeader2Print.Insert;
                        end;
                    PostedWhseShptLine."Posted Source Document"::"Posted Return Shipment": if not ReturnShptHeader2Print.Get(PostedWhseShptLine."Posted Source No.")then begin
                            ReturnShptHeader2Print.Init;
                            ReturnShptHeader2Print."No.":=PostedWhseShptLine."Posted Source No.";
                            ReturnShptHeader2Print.Insert;
                        end;
                    end;
                until PostedWhseShptLine.Next = 0;
            SalesShptHeader2Print.Reset;
            if SalesShptHeader2Print.FindSet(false, false)then repeat SalesShptHeader.Get(SalesShptHeader2Print."No.");
                    Clear(RecRef);
                    RecRef.GetTable(SalesShptHeader);
                    PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                until SalesShptHeader2Print.Next = 0;
            TransShptHeader2Print.Reset;
            if TransShptHeader2Print.FindSet(false, false)then repeat TransShptHeader.Get(TransShptHeader2Print."No.");
                    Clear(RecRef);
                    RecRef.GetTable(TransShptHeader);
                    PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                until TransShptHeader2Print.Next = 0;
            ReturnShptHeader2Print.Reset;
            if ReturnShptHeader2Print.FindSet(false, false)then repeat ReturnShptHeader.Get(TransShptHeader2Print."No.");
                    Clear(RecRef);
                    RecRef.GetTable(ReturnShptHeader);
                    PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                until ReturnShptHeader2Print.Next = 0;
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', PostedWhseShptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessPostedWhseRcptHdr()
    var
        PostedWhseRcptHeader: Record "Posted Whse. Receipt Header";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TransRcptHeader: Record "Transfer Receipt Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        PutAwayHeader: Record "Warehouse Activity Header";
        PutAwayLine: Record "Warehouse Activity Line";
        PurchRcptHeader2Print: Record "Purch. Rcpt. Header" temporary;
        TransRcptHeader2Print: Record "Transfer Receipt Header" temporary;
        ReturnRcptHeader2Print: Record "Return Receipt Header" temporary;
        PutAwayHeader2Print: Record "Warehouse Activity Header" temporary;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        PostedWhseRcptHeader.SetPosition(PostProcessEntry.Position);
        if not PostedWhseRcptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            PurchRcptHeader2Print.Reset;
            PurchRcptHeader2Print.DeleteAll;
            TransRcptHeader2Print.Reset;
            TransRcptHeader2Print.DeleteAll;
            ReturnRcptHeader2Print.Reset;
            ReturnRcptHeader2Print.DeleteAll;
            PostedWhseRcptLine.Reset;
            PostedWhseRcptLine.SetRange("No.", PostedWhseRcptHeader."No.");
            if PostedWhseRcptLine.FindSet(false, false)then repeat case PostedWhseRcptLine."Posted Source Document" of PostedWhseRcptLine."Posted Source Document"::"Posted Receipt": if not PurchRcptHeader2Print.Get(PostedWhseRcptLine."Posted Source No.")then begin
                            PurchRcptHeader2Print.Init;
                            PurchRcptHeader2Print."No.":=PostedWhseRcptLine."Posted Source No.";
                            PurchRcptHeader2Print.Insert;
                        end;
                    PostedWhseRcptLine."Posted Source Document"::"Posted Transfer Receipt": if not TransRcptHeader2Print.Get(PostedWhseRcptLine."Posted Source No.")then begin
                            TransRcptHeader2Print.Init;
                            TransRcptHeader2Print."No.":=PostedWhseRcptLine."Posted Source No.";
                            TransRcptHeader2Print.Insert;
                        end;
                    PostedWhseRcptLine."Posted Source Document"::"Posted Return Receipt": if not ReturnRcptHeader2Print.Get(PostedWhseRcptLine."Posted Source No.")then begin
                            ReturnRcptHeader2Print.Init;
                            ReturnRcptHeader2Print."No.":=PostedWhseRcptLine."Posted Source No.";
                            ReturnRcptHeader2Print.Insert;
                        end;
                    end;
                    PutAwayLine.Reset;
                    PutAwayLine.SetRange("Activity Type", PutAwayLine."Activity Type"::"Put-away");
                    PutAwayLine.SetRange("Whse. Document Type", PutAwayLine."Whse. Document Type"::Receipt);
                    PutAwayLine.SetRange("Whse. Document No.", PostedWhseRcptLine."No.");
                    PutAwayLine.SetRange("Whse. Document Line No.", PostedWhseRcptLine."Line No.");
                    if PutAwayLine.FindSet(false, false)then repeat if not PutAwayHeader2Print.Get(PutAwayLine."Activity Type", PutAwayLine."No.")then begin
                                PutAwayHeader2Print.Init;
                                PutAwayHeader2Print.Type:=PutAwayLine."Activity Type";
                                PutAwayHeader2Print."No.":=PutAwayLine."No.";
                                PutAwayHeader2Print.Insert;
                            end;
                        until PutAwayLine.Next = 0;
                until PostedWhseRcptLine.Next = 0;
            if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_PurchReceipt)then begin
                PurchRcptHeader2Print.Reset;
                if PurchRcptHeader2Print.FindSet(false, false)then repeat PurchRcptHeader.Get(PurchRcptHeader2Print."No.");
                        Clear(RecRef);
                        RecRef.GetTable(PurchRcptHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                    until PurchRcptHeader2Print.Next = 0;
            end;
            if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_TransReceipt)then begin
                TransRcptHeader2Print.Reset;
                if TransRcptHeader2Print.FindSet(false, false)then repeat TransRcptHeader.Get(TransRcptHeader2Print."No.");
                        Clear(RecRef);
                        RecRef.GetTable(TransRcptHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                    until TransRcptHeader2Print.Next = 0;
            end;
            if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_SalesReturnRcpt)then begin
                ReturnRcptHeader2Print.Reset;
                if ReturnRcptHeader2Print.FindSet(false, false)then repeat ReturnRcptHeader.Get(ReturnRcptHeader2Print."No.");
                        Clear(RecRef);
                        RecRef.GetTable(ReturnRcptHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                    until ReturnRcptHeader2Print.Next = 0;
            end;
            if SettingsMgt.CheckSetting(ConstMgt.BOS_Print_WhsePutAway)then begin
                PutAwayHeader2Print.Reset;
                if PutAwayHeader2Print.FindSet(false, false)then repeat PutAwayHeader.Get(PutAwayHeader2Print.Type, PutAwayHeader2Print."No.");
                        Clear(RecRef);
                        RecRef.GetTable(PutAwayHeader);
                        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Print, '', PostProcessEntry."Entry No.", false, '');
                    until PutAwayHeader2Print.Next = 0;
            end;
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', PostedWhseRcptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessSalesShptHeader()
    var
        SalesShptHeader: Record "Sales Shipment Header";
        ReportSelection: Record "Report Selections";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        SalesShptHeader.SetPosition(PostProcessEntry.Position);
        if not SalesShptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            UpdatePrinterSelection(GetPrintReport(ReportSelection.Usage::"S.Shipment"));
            SalesShptHeader.SetRecFilter;
            REPORT.RunModal(GetPrintReport(ReportSelection.Usage::"S.Shipment"), false, false, SalesShptHeader);
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', SalesShptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessPurchRcptHeader()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ReportSelection: Record "Report Selections";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        PurchRcptHeader.SetPosition(PostProcessEntry.Position);
        if not PurchRcptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            UpdatePrinterSelection(GetPrintReport(ReportSelection.Usage::"P.Receipt"));
            PurchRcptHeader.SetRecFilter;
            REPORT.RunModal(GetPrintReport(ReportSelection.Usage::"P.Receipt"), false, false, PurchRcptHeader);
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', PurchRcptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessTransShptHeader()
    var
        TransShptHeader: Record "Transfer Shipment Header";
        ReportSelection: Record "Report Selections";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        TransShptHeader.SetPosition(PostProcessEntry.Position);
        if not TransShptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            UpdatePrinterSelection(GetPrintReport(ReportSelection.Usage::Inv2));
            TransShptHeader.SetRecFilter;
            REPORT.RunModal(GetPrintReport(ReportSelection.Usage::Inv2), false, false, TransShptHeader);
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', TransShptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessTransRcptHeader()
    var
        TransRcptHeader: Record "Transfer Receipt Header";
        ReportSelection: Record "Report Selections";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        TransRcptHeader.SetPosition(PostProcessEntry.Position);
        if not TransRcptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            UpdatePrinterSelection(GetPrintReport(ReportSelection.Usage::Inv3));
            TransRcptHeader.SetRecFilter;
            REPORT.RunModal(GetPrintReport(ReportSelection.Usage::Inv3), false, false, TransRcptHeader);
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', TransRcptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessReturnRcptHeader()
    var
        ReturnRcptHeader: Record "Return Receipt Header";
        ReportSelection: Record "Report Selections";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        ReturnRcptHeader.SetPosition(PostProcessEntry.Position);
        if not ReturnRcptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            UpdatePrinterSelection(GetPrintReport(ReportSelection.Usage::"S.Ret.Rcpt."));
            ReturnRcptHeader.SetRecFilter;
            REPORT.RunModal(GetPrintReport(ReportSelection.Usage::"S.Ret.Rcpt."), false, false, ReturnRcptHeader);
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', ReturnRcptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessReturnShptHeader()
    var
        ReturnShptHeader: Record "Return Shipment Header";
        ReportSelection: Record "Report Selections";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        ReturnShptHeader.SetPosition(PostProcessEntry.Position);
        if not ReturnShptHeader.Find then Error(Text001, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Print: begin
            UpdatePrinterSelection(GetPrintReport(ReportSelection.Usage::"P.Ret.Shpt."));
            ReturnShptHeader.SetRecFilter;
            REPORT.RunModal(GetPrintReport(ReportSelection.Usage::"P.Ret.Shpt."), false, false, ReturnShptHeader);
        end;
        else
            Error(Text002, Format(PostProcessEntry."Operation Type"), '', ReturnShptHeader.TableCaption, PostProcessEntry.Position);
        end;
    end;
    procedure PostProcessSalesHeader()
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        BLOBStore: Record DYM_BLOBStore;
        DocAttachment: Record "Document Attachment";
        SalesPost: Codeunit "Sales-Post";
        SDProcess: codeunit DYM_SL_DataProcess;
        BLOBStoreMgt: Codeunit DYM_BLOBStoreManagement;
        PostedSalesDocument: variant;
        PostSalesDocument, CreateRelation, PostProcessingSkipped: boolean;
        InS: InStream;
        SalesShipmentHeaderNo: Text;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        clear(PostProcessingSkipped);
        PostProcessEntry.TestField("Entry No.");
        SalesHeader.SetPosition(PostProcessEntry.Position);
        if not SalesHeader.Find then Error(Text001, PostProcessEntry.Position);
        if not(SalesHeader."Document Type" in[SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"])then SalesHeader.FieldError("Document Type");
        //Check supported operation types 
        if NOT(PostProcessEntry."Operation Type" IN[PostProcessEntry."Operation Type"::Ship, PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post, PostProcessEntry."Operation Type"::Custom])then Error(Text002, Format(PostProcessEntry."Operation Type"), '', SalesHeader.TableCaption, PostProcessEntry.Position);
        case PostProcessEntry."Operation Type" of PostProcessEntry."Operation Type"::Ship, PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post: begin
            clear(PostSalesDocument);
            Clear(CreateRelation);
            PostSalesDocument:=PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Ship, PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post];
            case SalesHeader."Document Type" of SalesHeader."Document Type"::Order: begin
                if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Ship, PostProcessEntry."Operation Type"::Post])then begin
                    if(PostProcessEntry.Parameters = ConstMgt.PPP_Delivery())then begin
                        if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_Delivery_Ship()))then SalesHeader.Ship:=true;
                    end
                    else if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_SalesOrder_Ship()))then SalesHeader.Ship:=true;
                end;
                if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post])then begin
                    if(PostProcessEntry.Parameters = ConstMgt.PPP_Delivery())then begin
                        if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_Delivery_Invoice()))then begin
                            SalesHeader.Invoice:=true;
                            CreateRelation:=true;
                        end;
                    end
                    else if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_SalesOrder_Invoice()))then begin
                            SalesHeader.Invoice:=true;
                            CreateRelation:=true;
                        end;
                end;
            end;
            SalesHeader."Document Type"::Invoice: begin
                if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post])then if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_SalesInvoice()))then begin
                        SalesHeader.Ship:=true;
                        SalesHeader.Invoice:=true;
                    end;
            end;
            SalesHeader."Document Type"::"Credit Memo": begin
                if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post])then if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_SalesCreditMemo()))then begin
                        SalesHeader.Ship:=true;
                        SalesHeader.Invoice:=true;
                    end;
            end;
            SalesHeader."Document Type"::"Return Order": begin
                if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post])then if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_SalesReturnOrder()))then begin
                        SalesHeader.Receive:=true;
                        SalesHeader.Invoice:=true;
                    end;
            end;
            end;
            if((not SalesHeader.Ship) and (not SalesHeader.Invoice))then clear(PostSalesDocument);
            if(PostSalesDocument)then begin
                BindSubscription(BindPostProcessEventSubs);
                SalesHeader.SetRecFilter;
                SalesPost.Run(SalesHeader);
                SalesShipmentHeaderNo:=SesstionDataStoreHandler.PP_EDL_SalesShipmentHeader_Get();
                if(SalesShipmentHeader.Get(SalesShipmentHeaderNo))then begin
                    RecRef.GetTable(SalesShipmentHeader);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
                UnbindSubscription(BindPostProcessEventSubs);
                //Create record link record for storing relation between mobile and backend Invoice No.
                if((SalesHeader."External Document No." <> '') and CreateRelation)then begin
                    SalesPost.GetPostedDocumentRecord(SalesHeader, PostedSalesDocument);
                    SalesInvoiceHeader:=PostedSalesDocument;
                    If(SalesInvoiceHeader."No." <> '')then begin
                        RecRef.GetTable(SalesInvoiceHeader);
                        DataLogMgt.LogDataOp_Create(RecRef);
                        RecordLinkMgt.SetRecordLink(SDProcess.L_T_SalesHeader(), SalesHeader."External Document No.", DATABASE::"Sales Invoice Header", SalesInvoiceHeader.SystemId);
                    end;
                end;
            end
            else
                SetStatusSkipped();
        end;
        PostProcessEntry."Operation Type"::Custom: begin
            case PostProcessEntry.Parameters of ConstMgt.PPP_ProcessSnapshots: begin
                RecRef.GetTable(SalesHeader);
                BLOBStore.findByIdentifier(DeviceSetup.Code, PostProcessEntry.Data);
                if(BLOBStore.Status = BLOBStore.Status::Pending)then BLOBStore.FieldError(BLOBStore.Status);
                BLOBStore.CalcFields(Content);
                BLOBStore.Content.CreateInStream(InS, TextEncoding::UTF8);
                DocAttachment.SaveAttachmentFromStream(InS, RecRef, BLOBStoreMgt.applyFileExtension(BLOBStore.Identifier, BLOBStore."Packet Type"));
                BLOBStore.Validate(Status, BLOBStore.Status::Processed);
                BLOBStore.Modify();
                DocAttachment.Reset();
                DocAttachment.SetRange("Table ID", RecRef.Number);
                DocAttachment.SetRange("Document Type", SalesHeader."Document Type");
                DocAttachment.SetRange("No.", SalesHeader."No.");
                if DocAttachment.FindLast()then begin
                    RecRef.GetTable(DocAttachment);
                    DataLogMgt.LogDataOp_Create(RecRef);
                end;
            end;
            end;
        end;
        end;
    end;
    procedure PostProcessPurchaseHeader()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchRecptHeader: Record "Purch. Rcpt. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchasePost: Codeunit "Purch.-Post";
        RecRef: RecordRef;
        PostPurchaseDocument: Boolean;
        PurchInvoiceHeaderNo, PurchReceiptHeaderNo, PurchCrMemoHeaderNo: Text;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        PurchaseHeader.SetPosition(PostProcessEntry.Position);
        if not PurchaseHeader.Find then Error(Text001, PostProcessEntry.Position);
        if not(PurchaseHeader."Document Type" in[PurchaseHeader."Document Type"::Order])then PurchaseHeader.FieldError("Document Type");
        //Check supported operation types 
        if not(PostProcessEntry."Operation Type" IN[PostProcessEntry."Operation Type"::Receive, PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post])then Error(Text002, Format(PostProcessEntry."Operation Type"), '', PurchaseHeader.TableCaption, PostProcessEntry.Position);
        clear(PostPurchaseDocument);
        PostPurchaseDocument:=PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Receive, PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post];
        if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Receive, PostProcessEntry."Operation Type"::Post])then if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_PurchaseOrder_Receive()))then PurchaseHeader.Receive:=true;
        if(PostProcessEntry."Operation Type" in[PostProcessEntry."Operation Type"::Invoice, PostProcessEntry."Operation Type"::Post])then if(SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_PurchaseOrder_Invoice()))then PurchaseHeader.Invoice:=true;
        if(PostPurchaseDocument)then begin
            BindSubscription(BindPostProcessEventSubs);
            PurchaseHeader.SetRecFilter;
            PurchasePost.Run(PurchaseHeader);
            PurchInvoiceHeaderNo:=SDSHandler.PP_EDL_PurchInvoiceHeader_Get();
            if(PurchInvoiceHeader.Get(PurchInvoiceHeaderNo))then begin
                RecRef.GetTable(PurchInvoiceHeader);
                DataLogMgt.LogDataOp_Create(RecRef);
            end;
            PurchReceiptHeaderNo:=SDSHandler.PP_EDL_PurchReceiveHeader_Get();
            if(PurchRecptHeader.Get(PurchReceiptHeaderNo))then begin
                RecRef.GetTable(PurchRecptHeader);
                DataLogMgt.LogDataOp_Create(RecRef);
            end;
            PurchCrMemoHeaderNo:=SDSHandler.PP_EDL_PurchCRMemoHeader_Get();
            if(PurchCrMemoHeader.Get(PurchReceiptHeaderNo))then begin
                RecRef.GetTable(PurchCrMemoHeader);
                DataLogMgt.LogDataOp_Create(RecRef);
            end;
            UnbindSubscription(BindPostProcessEventSubs);
        end
        else
            SetStatusSkipped();
    end;
    procedure PostProcessItemJnl()
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        PostProcessEntry.TestField("Entry No.");
        ItemJnlLine.SETPOSITION(PostProcessEntry.Position);
        IF NOT ItemJnlLine.FIND THEN ERROR(Text001, PostProcessEntry.Position);
        CASE PostProcessEntry."Operation Type" OF PostProcessEntry."Operation Type"::Post: BEGIN
            case ItemJnlLine."Entry Type" of ItemJnlLine."Entry Type"::"Positive Adjmt.", ItemJnlLine."Entry Type"::"Negative Adjmt.": IF NOT SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_ItemJournal())THEN SetStatusSkipped();
            ItemJnlLine."Entry Type"::Output: if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_Prod_Output())then SetStatusSkipped();
            ItemJnlLine."Entry Type"::Consumption: if not SettingsMgt.CheckSetting(ConstMgt.BOS_AutoPost_Prod_Consump())then SetStatusSkipped();
            end;
            ItemJnlLine.SETRECFILTER;
            CLEAR(ItemJnlPostBatch);
            ItemJnlPostBatch.RUN(ItemJnlLine);
        END;
        ELSE
            ERROR(Text002, FORMAT(PostProcessEntry."Operation Type"), '', ItemJnlLine.TABLECAPTION, PostProcessEntry.Position);
        END;
    end;
    #endregion 
    #region Additional
    procedure UpdateWhseActivityTracking(WhseActivityHeader: Record "Warehouse Activity Header")
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        ReservEntry: Record "Reservation Entry";
    begin
        WhseActivityLine.Reset;
        WhseActivityLine.SetRange("Activity Type", WhseActivityHeader.Type);
        WhseActivityLine.SetRange("No.", WhseActivityHeader."No.");
        if WhseActivityLine.FindSet(false, false)then repeat ReservEntry.Reset;
                ReservEntry.SetRange("Source Type", WhseActivityLine."Source Type");
                ReservEntry.SetRange("Source Subtype", WhseActivityLine."Source Subtype");
                ReservEntry.SetRange("Source ID", WhseActivityLine."Source No.");
                ReservEntry.SetRange("Source Batch Name", '');
                ReservEntry.SetRange("Source Prod. Order Line", 0);
                ReservEntry.SetRange("Source Ref. No.", WhseActivityLine."Source Line No.");
                if ReservEntry.FindSet(true, false)then repeat if((ReservEntry."Quantity (Base)" <> ReservEntry."Qty. to Handle (Base)") or (ReservEntry."Quantity (Base)" <> ReservEntry."Qty. to Invoice (Base)"))then begin
                            ReservEntry.Validate("Qty. to Handle (Base)", ReservEntry."Quantity (Base)");
                            ReservEntry.Validate("Qty. to Invoice (Base)", ReservEntry."Quantity (Base)");
                            ReservEntry.Modify;
                        end;
                    until ReservEntry.Next = 0;
            until WhseActivityLine.Next = 0;
    end;
    #endregion 
    #region Printing
    procedure GetPrintReport(Usage: enum "Report Selection Usage")Result: Integer var
        ReportSelection: Record "Report Selections";
    begin
        Clear(Result);
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage, Usage);
        if ReportSelection.FindFirst then exit(ReportSelection."Report ID");
    end;
    procedure UpdatePrinterSelection(ReportID: Integer)
    /*
    var
        Printer: Record Printer;
        PrinterSelection: Record "Printer Selection";
    */
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        if not SettingsMgt.CheckSetting(ConstMgt.BOS_DefaultPrinter)then exit;
    //TODO:Handle cloud printing
    /*
        if not Printer.Get(SettingsMgt.GetSetting(ConstMgt.BOS_DefaultPrinter)) then
            Error(Text006, SettingsMgt.GetSetting(ConstMgt.BOS_DefaultPrinter));

        if not PrinterSelection.Get(UserId, ReportID) then begin
            PrinterSelection.Init;
            PrinterSelection.Validate("User ID", UserId);
            PrinterSelection.Validate("Report ID", ReportID);
            PrinterSelection.Insert;
        end;

        PrinterSelection.Validate("Printer Name", Printer.Name);
        PrinterSelection.Modify(true);
        */
    end;
    #endregion 
    procedure SetStatusSkipped()
    begin
        SDSHandler.PP_Flag_Skipped_Set(PostProcessEntry);
        error(Text003);
    end;
}
