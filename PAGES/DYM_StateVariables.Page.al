page 70175 DYM_StateVariables
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = DYM_StateVariable;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Context; Rec.Context)
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
