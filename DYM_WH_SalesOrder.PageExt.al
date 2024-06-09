pageextension 84301 DYM_WH_SalesOrder extends "Sales Order"
{
    layout
    {
        //Sales
        addlast(factboxes)
        {
            part(DYM_Signature; DYM_SalesHeaderSignature)
            {
                Caption = 'Signature';
                ApplicationArea = All;
                SubPageLink = "Document Type"=FIELD("Document Type"), "No."=FIELD("No.");
            }
        }
        //Warehouse
        addlast("Shipping and Billing")
        {
            group(DYM_DynamicsMobile)
            {
                Caption = 'Dynamics Mobile';

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
                    AccessByPermission = TableData DYM_DeviceSetup=R;

                    trigger OnAssistEdit()
                    begin
                        RecRef.GetTable(Rec);
                        DocTraceMgt.DrillDownTraceStatus(RecRef);
                    end;
                }
            }
        }
        //Route Plan
        addlast(General)
        {
            field(DYM_DeliveryPersonCode; Rec.DYM_DeliveryPersonCode)
            {
                ApplicationArea = All;
                TableRelation = DYM_DeviceSetup.Code;
                Caption = 'Delivery Person Code';
            }
            field(DYM_DeliveryStatus; Rec.DYM_DeliveryStatus)
            {
                ApplicationArea = All;
                Caption = 'Delivery Status';
            }
            field(DYM_DiscountAmountFromDeal; Rec.DYM_DiscountAmountFromDeal)
            {
                ApplicationArea = All;
                Caption = 'Discount Amount From Deal';
            }
            field(DYM_DiscountPercentFromDeal; Rec.DYM_DiscountPercentFromDeal)
            {
                ApplicationArea = All;
                Caption = 'Discount Percent From Deal';
            }
            field(DYM_TotalAmountDealCode; Rec.DYM_TotalAmountDealCode)
            {
                ApplicationArea = All;
                Caption = 'Total Amount Deal Code';
            }
            field(DYM_TotalAmountGroupCode; Rec.DYM_TotalAmountGroupCode)
            {
                ApplicationArea = All;
                Caption = 'Total Amount Group Code';
            }
        }
    }
    var DeviceSetup: Record DYM_DeviceSetup;
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
        AccentTraceStatus:=TraceStatus In[TraceStatus::Pending, TraceStatus::Failed];
    end;
}
