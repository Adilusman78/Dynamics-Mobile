codeunit 70141 DYM_RPCDispatcher
{
    trigger OnRun()
    var
        ObjectType: Text;
        ObjectNo: Text;
    begin
        Clear(ObjectType);
        Clear(ObjectNo);
        ObjectType := CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, ConstMgt.RPC_ObjectType, ConstMgt.RPC_SystemRecID());
        ObjectNo := CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, ConstMgt.RPC_ObjectNo, ConstMgt.RPC_SystemRecID());
        case ObjectType of
            ConstMgt.ROT_Codeunit:
                CODEUNIT.Run(LowLevelDP.Text2Integer(ObjectNo));
            ConstMgt.ROT_Report:
                REPORT.Run(LowLevelDP.Text2Integer(ObjectNo));
            ConstMgt.ROT_Command:
                Dispatch;
            else
                Error(Text001, ObjectType);
        end;
    end;

    var
        XMLMgt: Codeunit DYM_XMLManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        CacheMgt: Codeunit DYM_CacheManagement;
        SettingsMgt: Codeunit DYM_SettingsManagement;
        GLSetup: Record "General Ledger Setup";
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        SLE: Integer;
        SetupRead: Boolean;
        IntRec: Integer;
        Text001: Label 'Invalid object type [%1].';
        Text002: Label 'Command [%1] not found.';

    procedure Dispatch()
    var
        Command: Text[250];
    begin
        Clear(Command);
        Command := CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, ConstMgt.ROT_Command, ConstMgt.RPC_SystemRecID());
        case Command of
            'CreateSalesHeader':
                CreateSalesHeader;
            'CreateSalesLine':
                CreateSalesLine;
            'UpdateSalesLine':
                UpdateSalesLine;
            'DeleteSalesLine':
                DeleteSalesLine;
            'PrintSalesHeader':
                PrintSalesHeader;
            'OurFancyFunction':
                OurFancyFunction;
            'Test':
                Test();
            else
                Error(Text002, Command);
        end;
    end;
    #region Commands
    procedure Test()
    var
        Name: text;
    begin
        Name := CacheMgt.GetPushRPCCache('Name', ConstMgt.RPC_SystemRecID());
        CacheMgt.SetPullRPCCache('Result', ConstMgt.RPC_SystemRecID(), StrSubstNo('Hello %1 !', Name));
    end;

    procedure CreateSalesHeader()
    var
        SalesHeader: Record "Sales Header";
    begin
        SettingsMgt.TestSetting(ConstMgt.BOS_ResponsibilityCenter);
        SalesHeader.Init;
        SalesHeader.Validate("Document Type", LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentType', ConstMgt.RPC_SystemRecID())));
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'CustomerNo', ConstMgt.RPC_SystemRecID()));
        SalesHeader.Validate("Responsibility Center", SettingsMgt.GetSetting(ConstMgt.BOS_ResponsibilityCenter));
        SalesHeader.Modify;
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'DocumentType', LowLevelDP.Integer2Text(SalesHeader."Document Type".AsInteger()), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'No', SalesHeader."No.", ConstMgt.RPC_SystemRecID());
    end;

    procedure CreateSalesLine()
    var
        SalesLine: Record "Sales Line";
        NextLine: Integer;
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        Clear(NextLine);
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentType', ConstMgt.RPC_SystemRecID())));
        SalesLine.SetRange("Document No.", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentNo', ConstMgt.RPC_SystemRecID()));
        if SalesLine.FindLast then NextLine := SalesLine."Line No.";
        NextLine += 10000;
        SalesLine.Init;
        SalesLine.Validate("Document Type", LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentType', ConstMgt.RPC_SystemRecID())));
        SalesLine.Validate("Document No.", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentNo', ConstMgt.RPC_SystemRecID()));
        SalesLine.Validate("Line No.", NextLine);
        SalesLine.Insert(true);
        SalesLine.Validate(Type, LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'Type', ConstMgt.RPC_SystemRecID())));
        SalesLine.Validate("No.", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'No', ConstMgt.RPC_SystemRecID()));
        if (CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LocationCode', ConstMgt.RPC_SystemRecID()) <> '') then
            SalesLine.Validate("Location Code", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LocationCode', ConstMgt.RPC_SystemRecID()))
        else
            SalesLine.Validate("Location Code", DeviceSetup."Mobile Location");
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'UnitofMeasureCode', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate("Unit of Measure Code", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'UnitofMeasureCode', ConstMgt.RPC_SystemRecID()));
        SalesLine.Validate(Quantity, LowLevelDP.Text2Decimal(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'Quantity', ConstMgt.RPC_SystemRecID())));
        SalesLine.Modify(true);
        SendSalesLine(SalesLine);
    end;

    procedure UpdateSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Get(LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentType', ConstMgt.RPC_SystemRecID())), CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentNo', ConstMgt.RPC_SystemRecID()), LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LineNo', ConstMgt.RPC_SystemRecID())));
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'LocationCode', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate("Location Code", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LocationCode', ConstMgt.RPC_SystemRecID()));
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'Quantity', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate(Quantity, LowLevelDP.Text2Decimal(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'Quantity', ConstMgt.RPC_SystemRecID())));
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'UnitofMeasureCode', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate("Unit of Measure Code", CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'UnitofMeasureCode', ConstMgt.RPC_SystemRecID()));
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'LineDiscountPercent', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate("Line Discount %", LowLevelDP.Text2Decimal(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LineDiscountPercent', ConstMgt.RPC_SystemRecID())));
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'LineDiscountAmount', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate("Line Discount Amount", LowLevelDP.Text2Decimal(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LineDiscountAmount', ConstMgt.RPC_SystemRecID())));
        if CacheMgt.CheckRPCCache(enum::DYM_PacketDirection::Push, 'UnitPrice', ConstMgt.RPC_SystemRecID()) then SalesLine.Validate("Unit Price", LowLevelDP.Text2Decimal(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'UnitPrice', ConstMgt.RPC_SystemRecID())));
        SalesLine.Modify(true);
        SendSalesLine(SalesLine);
    end;

    procedure DeleteSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Get(LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentType', ConstMgt.RPC_SystemRecID())), CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'DocumentNo', ConstMgt.RPC_SystemRecID()), LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'LineNo', ConstMgt.RPC_SystemRecID())));
        SalesLine.Delete(true);
    end;

    procedure PrintSalesHeader()
    var
        Type: Integer;
    begin
        Type := LowLevelDP.Text2Integer(CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'Type', ConstMgt.RPC_SystemRecID()));
        case Type of
        end;
    end;

    procedure OurFancyFunction()
    var
        ContactNo: Code[20];
        Data: Text[30];
        Contact: Record Contact;
    begin
        ContactNo := CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'ContactNo', ConstMgt.RPC_SystemRecID());
        Data := CacheMgt.GetRPCCache(enum::DYM_PacketDirection::Push, 'Data', ConstMgt.RPC_SystemRecID());
        Contact.Get(ContactNo);
        Contact."Address 2" := Data;
        Contact.Modify;
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'OurFancyOutputData', Contact.Name + ' , ' + Contact.Address, ConstMgt.RPC_SystemRecID());
    end;
    #endregion 
    #region Additional
    procedure SendSalesLine(var SalesLine: Record "Sales Line")
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'DocumentType', LowLevelDP.Integer2Text(SalesLine."Document Type".AsInteger()), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'No', SalesLine."Document No.", ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'LineNo', LowLevelDP.Integer2Text(SalesLine."Line No."), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'Type', LowLevelDP.Integer2Text(SalesLine.Type.AsInteger()), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'ItemNo', SalesLine."No.", ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'LocationCode', SalesLine."Location Code", ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'Quantity', LowLevelDP.Decimal2Text(SalesLine.Quantity), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'UnitofMeasureCode', SalesLine."Unit of Measure Code", ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'UnitPrice', LowLevelDP.Decimal2Text(SalesLine."Unit Price"), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'LineDiscountPercent', LowLevelDP.Decimal2Text(SalesLine."Line Discount %"), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'LineDiscountAmount', LowLevelDP.Decimal2Text(SalesLine."Line Discount Amount"), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'InvDiscountAmount', LowLevelDP.Decimal2Text(SalesLine."Inv. Discount Amount"), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'LineAmount', LowLevelDP.Decimal2Text(SalesLine."Line Amount"), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'Amount', LowLevelDP.Decimal2Text(SalesLine.Amount), ConstMgt.RPC_SystemRecID());
        CacheMgt.SetRPCCache(enum::DYM_PacketDirection::Pull, 'AmountIncludingVAT', LowLevelDP.Decimal2Text(SalesLine."Amount Including VAT"), ConstMgt.RPC_SystemRecID());
    end;
    #endregion
}
