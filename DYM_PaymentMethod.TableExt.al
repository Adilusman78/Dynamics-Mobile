tableextension 84200 DYM_PaymentMethod extends "Payment Method"
{
    fields
    {
        field(84200; DYM_PaymentType;enum DYM_SL_PaymentType)
        {
            DataClassification = SystemMetadata;
            Caption = 'Payment Type';
        }
    }
}
