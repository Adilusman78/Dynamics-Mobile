page 84052 DYM_DeviceSetupsLookUp
{
    Caption = 'Device Setups LookUp';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = Card;
    SourceTable = DYM_DeviceSetup;

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                Editable = false;
                ShowCaption = false;

                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Mobile Location"; Rec."Mobile Location")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    procedure SetSelectionFilter(var DeviceSetupList: Record DYM_DeviceSetup)
    begin
        CurrPage.SetSelectionFilter(DeviceSetupList);
    end;
}
