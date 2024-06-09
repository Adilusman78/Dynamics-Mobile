pageextension 84203 DYM_SalesInvoice extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
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
        //Sales
        addlast(factboxes)
        {
            part(DYM_Signature; DYM_SalesHeaderSignature)
            {
                ApplicationArea = All;
                SubPageLink = "Document Type"=FIELD("Document Type"), "No."=FIELD("No.");
            }
        }
    }
}
