page 70167 DYM_SalesHeaderSignature
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(DYM_Signature; Rec.DYM_Signature)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
