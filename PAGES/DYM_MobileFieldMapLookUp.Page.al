page 70148 DYM_MobileFieldMapLookUp
{
    Caption = 'Mobile Field Map LookUp';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = Card;
    SourceTable = DYM_MobileFieldMap;

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                ShowCaption = false;

                field("Mobile Field"; Rec."Mobile Field")
                {
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                }
                field("Field Index"; Rec."Field Index")
                {
                    ApplicationArea = All;
                }
                field("NAV Field Name"; Rec."NAV Field Name")
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
