page 84051 DYM_DeviceGroupsLookUp
{
    Caption = 'Device Groups LookUp';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = Card;
    SourceTable = DYM_DeviceGroup;

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                ShowCaption = false;

                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
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
