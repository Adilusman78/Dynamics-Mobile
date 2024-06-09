codeunit 70152 DYM_SL_Helper
{
    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        CacheMgt: Codeunit DYM_CacheManagement;
        StatsMgt: Codeunit DYM_StatisticsManagement;
        DataLogMgt: Codeunit DYM_DataLogmanagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        GeneralDP: Codeunit DYM_GeneralDataProcess;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        PostProcessMgt: Codeunit DYM_PostProcessManagement;
        RecRef: RecordRef;
        FldRef: FieldRef;
        SLE: Integer;
        SetupRead: Boolean;

    procedure createPaymentLine(_customerNo: code[20]; _dateCreated: Date; _amount: Decimal; _paymentNo: code[20]; _applyToDocNo: code[20]; _journalTemplateName: code[10]; _journalBatchName: code[10]; _balanceAccountType: Enum "Gen. Journal Account Type"; _balanceAccountNo: code[20]; var _createdGenJnlLine: record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LastGenJnlLine: Record "Gen. Journal Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SourceCodeSetup: Record "Source Code Setup";
        Cust: Record Customer;
        ar_PaymentHeader, ar_PaymentLine : Codeunit DYM_ActiveRecManagement;
        SDProcess: Codeunit DYM_SL_DataProcess;
        RecordLinkMgt: Codeunit DYM_RecordLinkManagement;
        NextDocNo: Code[20];
        NextLine: Integer;
        PaidAmount, AppliedAmount : Decimal;
        UseMobileNo: Boolean;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(UseMobileNo);
        UseMobileNo := SettingsMgt.CheckSetting(ConstMgt.BOS_PaymentsUseMobileNo());
        CLEAR(NextLine);
        CLEAR(LastGenJnlLine);
        LastGenJnlLine.RESET;
        LastGenJnlLine.SETRANGE("Journal Template Name", _journalTemplateName);
        LastGenJnlLine.SETRANGE("Journal Batch Name", _journalBatchName);
        IF LastGenJnlLine.FINDLAST THEN BEGIN
            NextLine := LastGenJnlLine."Line No.";
            NextDocNo := LastGenJnlLine."Document No.";
        END;
        NextLine += 10000;
        IF NOT GenJnlBatch.GET(_journalTemplateName, _journalBatchName) THEN CLEAR(GenJnlBatch);
        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", _journalTemplateName);
        GenJnlLine.VALIDATE("Journal Batch Name", _journalBatchName);
        GenJnlLine.VALIDATE("Line No.", NextLine);
        IF (NextDocNo = '') THEN BEGIN
            GenJnlLine.SetUpNewLine(LastGenJnlLine, 0, true);
            NextDocNo := GenJnlLine."Document No.";
        END;
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        case UseMobileNo of
            false:
                begin
                    NextDocNo := INCSTR(NextDocNo);
                    GenJnlLine."Document No." := NextDocNo;
                end;
            true:
                begin
                    GenJnlLine."Document No." := _paymentNo;
                end;
        end;
        GenJnlLine.VALIDATE("Posting Date", _dateCreated);
        GenJnlLine.VALIDATE("Document Date", _dateCreated);
        GenJnlLine.VALIDATE("Account Type", enum::"Gen. Journal Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", _customerNo);
        IF (GenJnlBatch."Bal. Account No." <> '') THEN BEGIN
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlBatch."Bal. Account Type");
            GenJnlLine.VALIDATE("Bal. Account No.", GenJnlBatch."Bal. Account No.");
        END;
        GenJnlLine.VALIDATE("Posting No. Series", GenJnlBatch."Posting No. Series");
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        case (LowLevelDP.IsNumStr(_applyToDocNo)) of
            true:
                begin
                    if CustLedgerEntry.Get(LowLevelDP.Text2Integer(_applyToDocNo)) then
                        GenJnlLine."Applies-to Doc. No." := CustLedgerEntry."Document No."
                    else
                        GenJnlLine."Applies-to Doc. No." := _applyToDocNo;
                end;
            false:
                GenJnlLine."Applies-to Doc. No." := _applyToDocNo;
        end;
        //Handle payments against invoices by External Document No.
        if not SalesInvHeader.GET(GenJnlLine."Applies-to Doc. No.") then begin
            if SalesInvHeader.GetBySystemId(RecordLinkMgt.GetRecordLinkRecId(SDProcess.L_T_SalesHeader(), GenJnlLine."Applies-to Doc. No.")) then GenJnlLine."Applies-to Doc. No." := SalesInvHeader."No.";
        end;
        IF SalesInvHeader.GET(GenJnlLine."Applies-to Doc. No.") THEN GenJnlLine.VALIDATE("Applies-to Doc. No.");
        IF (SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountNo) <> '') THEN BEGIN
            GenJnlLine.VALIDATE("Bal. Account Type", LowLevelDP.Text2Integer(SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountType)));
            GenJnlLine.VALIDATE("Bal. Account No.", SettingsMgt.GetSetting(ConstMgt.BOS_PaymentBalAccountNo));
        END;
        GenJnlLine.VALIDATE("Credit Amount", _amount);
        SourceCodeSetup.GET;
        IF (GenJnlLine."Source Code" <> SourceCodeSetup."Cash Receipt Journal") THEN GenJnlLine.VALIDATE("Source Code", SourceCodeSetup."Cash Receipt Journal");
        GenJnlLine.VALIDATE("External Document No.", _paymentNo);
        GenJnlLine.INSERT(TRUE);
        LastGenJnlLine := GenJnlLine;
        _createdGenJnlLine := GenJnlLine;
        RecRef.GETTABLE(GenJnlLine);
        DataLogMgt.LogDataOp_Create(RecRef);
        PostProcessMgt.LogPostProcessOperation(RecRef, enum::DYM_PostProcessOperationType::Post, '', 0, FALSE, '');
    end;

    procedure GetSalesItemLedgerEntry(_SalesInvoiceNo: Code[20]; _ItemNo: Code[20]; _VariantCode: Code[10]; _SerialNo: Code[50]; _LotNo: Code[50]) Result: Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        EntryFound: Boolean;
    begin
        clear(Result);
        clear(EntryFound);
        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Document No.", _SalesInvoiceNo);
        ValueEntry.SetRange("Item No.", _ItemNo);
        ValueEntry.SetRange("Variant Code", _VariantCode);
        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
        ValueEntry.SetFilter("Invoiced Quantity", '<%1', 0);
        if ValueEntry.FindSet() then
            repeat
                ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                if ((ItemLedgerEntry."Serial No." = _SerialNo) AND (ItemLedgerEntry."Lot No." = _LotNo)) then begin
                    EntryFound := true;
                    Result := ItemLedgerEntry."Entry No.";
                end;
            until ((ValueEntry.next = 0) or (EntryFound));
    end;
}
