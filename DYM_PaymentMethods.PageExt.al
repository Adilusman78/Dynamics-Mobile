pageextension 84200 DYM_PaymentMethods extends "Payment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field(DYM_PaymentType; Rec.DYM_PaymentType)
            {
                ApplicationArea = All;
                Caption = 'Payment Type';
            }
        }
    }
}
