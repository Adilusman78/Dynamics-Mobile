tableextension 70102 DYM_ReturnReason extends "Return Reason"
{
    fields
    {
        field(84203; DYM_ReturnReasonType; enum DYM_ReturnReasonType)
        {
            DataClassification = SystemMetadata;
            Caption = 'Return Reason Type';

            trigger OnValidate()
            begin
                if (Rec.DYM_ReturnReasonType <> Rec.DYM_ReturnReasonType::None) then Rec.TestField("Default Location Code", '');
            end;
        }
    }
}
