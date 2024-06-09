pageextension 70112 DYM_WH_TransferOrder extends "Transfer Order"
{
    layout
    {
        addlast(content)
        {
            group(DYM_DynamicsMobile)
            {
                Caption = 'Dynamics Mobile';

                field(DYM_MobileShipStatus; Rec.DYM_MobileShipStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Mobile Ship Status';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(DYM_MobileReceiveStatus; Rec.DYM_MobileReceiveStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Mobile Receive Status';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(DYM_MobileDevice; Rec.DYM_MobileDevice)
                {
                    ApplicationArea = All;
                    Caption = 'Mobile Device';
                    Editable = true;
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
