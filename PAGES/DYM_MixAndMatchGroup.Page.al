page 70147 DYM_MixAndMatchGroup
{
    Caption = 'Mix and Match Group';
    PageType = List;
    SourceTable = DYM_MixAndMatchGroup;
    UsageCategory = Lists;
    ApplicationArea = All;

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
