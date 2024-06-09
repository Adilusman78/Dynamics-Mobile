page 84099 DYM_Debug
{
    Caption = 'Debug';
    SourceTable = Integer;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(list)
            {
                field(Number; Rec.Number)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        synclog: record DYM_SyncLog;
        EventLog: record DYM_EventLog;
        cloud: codeunit DYM_CloudManagement;
        rawdp: Codeunit DYM_RawDataProcessing;
        globaldp: Codeunit DYM_GlobalDataProcess;
        setupio: Codeunit DYM_SetupIOManagement;
        packetMgt: Codeunit DYM_PacketManagement;
        jobQueueDispatcher: Codeunit "Job Queue Dispatcher";
        DebugMgt: Codeunit DYM_DebugManagement;
        Job: Record "Job Queue Entry";
        TS: Record "Tracking Specification";
        RE: Record "Reservation Entry";
        postProcessEntry: Record DYM_PostProcessLog;
        PostProcessMgt: Codeunit DYM_PostProcessManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        EnvIdMgt: Codeunit DYM_EnvIdManagement;
        ins: InStream;
        linkresp: text;
        directlink: text;
        content: text;
        RestartTime: DateTime;
        dummyInstream: InStream;
        a: Codeunit "Temp Blob";
        x: Record Customer;
        tr: Record 337;
        item: record item temporary;
        BlobStore: record DYM_BLOBStore;
        Info: ModuleInfo;
        JobQueueEntry: Record "Job Queue Entry";
        ConstMgt: Codeunit DYM_ConstManagement;
        t: Time;
        TableMapFilters: Record DYM_MobileTableMapFilters;
        ReservMgt: Codeunit "Reservation Management";
        SalesLine: Record "Sales Line";
        IntegrityMgt: codeunit DYM_IntegrityManagement;
        cs, co, cm: text;
        tl, tl2, tl3, tl4: List of[Text];
        c: char;
        jobj: JsonObject;
        jtkn: JsonToken;
        jarr: JsonArray;
        TransHead: record "Transfer Header";
        ss: Record DYM_SettingsStorage;
        SetupIOHandler: Codeunit DYM_SetupIOHandler;
        DataLog: Record DYM_DataLog;
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
    begin
        //SalesHeader.get(SalesHeader."Document Type"::Invoice, 'S-INV102195');
        SalesHeader."Document Type":=SalesHeader."Document Type"::Invoice;
        SalesHeader."No.":='S-INV102195';
        TransferHeader."No.":='1001';
        SyncLog.Init;
        clear(SyncLog."Entry No.");
        synclog.Direction:=synclog.Direction::Push;
        synclog.Company:=CompanyName;
        synclog.Status:=synclog.Status::Success;
        synclog."Operation Hint":=format(Enum::DYM_DeviceActivityAction::"Truck Receive");
        synclog.Path:=TransferHeader.GetPosition();
        synclog.Insert();
        DataLog.Init();
        clear(DataLog."Entry No.");
        DataLog."Sync Log Entry No.":=synclog."Entry No.";
        DataLog."Entry Type":=DataLog."Entry Type"::Modify;
        DataLog."Table No.":=5740;
        DataLog.Position:=TransferHeader.GetPosition();
        DataLog.Insert();
        Message('Done.');
    end;
}
