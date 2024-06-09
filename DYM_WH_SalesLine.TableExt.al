tableextension 84309 DYM_WH_SalesLine extends "Sales Line"
{
    fields
    {
        field(84000; DYM_GroupCode; Code[100])
        {
            Caption = 'Group Code';
            DataClassification = CustomerContent;
        }
        field(84001; DYM_DealCode; Code[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Deal Code';
        }
        field(84002; DYM_DealDiscountPercent; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Deal Discount Percent';
        }
        field(84003; DYM_HasDealPercent; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Has Deal Percent';
        }
        field(84004; DYM_IsDealItem; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Is Deal Item';
        }
    }
    var SalesHeader: Record "Sales Header";
    local procedure DYM_GetSalesHeader()
    begin
        if((Rec."Document Type" <> SalesHeader."Document Type") or (Rec."Document No." <> SalesHeader."No."))then if not SalesHeader.Get(Rec."Document Type", Rec."Document No.")then clear(SalesHeader);
    end;
    procedure DYM_testMobileStatus()
    begin
        DYM_GetSalesHeader();
        if(SalesHeader.DYM_MobileStatus = SalesHeader.DYM_MobileStatus::"In Progress")then SalesHeader.FieldError(DYM_MobileStatus);
    end;
}
