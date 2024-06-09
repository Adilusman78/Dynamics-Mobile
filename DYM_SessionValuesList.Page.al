page 84066 DYM_SessionValuesList
{
    Caption = 'Session Values List';
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = List;
    SourceTable = DYM_SessionValues;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
