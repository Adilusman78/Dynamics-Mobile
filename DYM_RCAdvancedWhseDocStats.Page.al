page 84084 DYM_RCAdvancedWhseDocStats
{
    Caption = 'RC Advanced Whse. Doc Stats';
    PageType = CardPart;
    SourceTable = DYM_DynamicsMobileCue;

    layout
    {
        area(content)
        {
            cuegroup(Pending)
            {
                Caption = 'Pending';
                CueGroupLayout = Wide;
            }
            cuegroup("Partially Processed")
            {
                Caption = 'Partially Processed';
            }
            cuegroup("Fully Processed")
            {
                Caption = 'Fully Processed';
            }
        }
    }
    actions
    {
    }
}
