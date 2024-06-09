page 84065 DYM_GenericList
{
    Caption = 'Generic List';
    PageType = List;
    SourceTable = DYM_CacheBuffer;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Data; Rec.Data)
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
