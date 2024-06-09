page 70172 DYM_SettingsList
{
    Caption = 'Settings List';
    PageType = List;
    SourceTable = DYM_Settings;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                }
                field("Publish to"; Rec."Publish to")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Device Role"; Rec."Applies-to Device Role")
                {
                    ApplicationArea = All;
                }
                field("Mandatory for"; Rec."Mandatory for")
                {
                    ApplicationArea = All;
                }
                field("NAV Table Name"; Rec."NAV Table Name")
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
    trigger OnOpenPage()
    begin
        CurrPage.Editable(not CurrPage.LookupMode);
    end;
}
