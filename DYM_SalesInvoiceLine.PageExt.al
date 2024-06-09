pageextension 84213 DYM_SalesInvoiceLine extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(DYM_DealCode; Rec.DYM_DealCode)
            {
                ApplicationArea = All;
                Caption = 'Deal Code';
            }
            field(DYM_GroupCode; Rec.DYM_GroupCode)
            {
                ApplicationArea = All;
                Caption = 'Group Code';
            }
            field(DYM_DealDiscountPercent; Rec.DYM_DealDiscountPercent)
            {
                ApplicationArea = All;
                Caption = 'Deal Discount Percent';
            }
            field(DYM_HasDealPercent; Rec.DYM_HasDealPercent)
            {
                ApplicationArea = All;
                Caption = 'Has Deal Percent';
            }
            field(DYM_IsDealItem; Rec.DYM_IsDealItem)
            {
                ApplicationArea = All;
                Caption = 'Is Deal Item';
            }
        }
    }
}
