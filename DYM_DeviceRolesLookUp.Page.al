page 84050 DYM_DeviceRolesLookUp
{
    Caption = 'Device Roles LookUp';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = Card;
    SourceTable = DYM_DeviceRole;

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                ShowCaption = false;

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
