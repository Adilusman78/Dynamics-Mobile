pageextension 70108 DYM_WH_PurchaseOrder extends "Purchase Order"
{
    layout
    {
        addlast("Shipping and Payment")
        {
            field(DYM_MobileStatus; Rec.DYM_MobileStatus)
            {
                ApplicationArea = All;
                Caption = 'Mobile Status';

                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(DYM_MobileDevice; Rec.DYM_MobileDevice)
            {
                ApplicationArea = All;
                Caption = 'Mobile Device';

                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(DYM_TraceStatus; TraceStatusText)
            {
                ApplicationArea = All;
                Caption = 'Trace Status';
                Editable = false;
                Style = AttentionAccent;
                StyleExpr = AccentTraceStatus;
                AccessByPermission = TableData DYM_DeviceSetup = R;

                trigger OnAssistEdit()
                begin
                    RecRef.GetTable(Rec);
                    DocTraceMgt.DrillDownTraceStatus(RecRef);
                end;
            }
        }
    }
    var
        DeviceSetup: Record DYM_DeviceSetup;
        DocTraceMgt: Codeunit DYM_DocumentTraceManagement;
        TraceStatus: enum DYM_DocumentTraceStatus;
        TraceStatusText: Text;
        AccentTraceStatus: Boolean;
        RecRef: RecordRef;

    trigger OnAfterGetRecord()
    begin
        clear(TraceStatus);
        clear(TraceStatusText);
        if not DeviceSetup.ReadPermission then exit;
        RecRef.GetTable(Rec);
        DocTraceMgt.GetTraceStatus(RecRef, TraceStatus, TraceStatusText);
        AccentTraceStatus := TraceStatus In [TraceStatus::Pending, TraceStatus::Failed];
    end;
}
