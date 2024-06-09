page 70170 DYM_SettingsAssignment
{
    Caption = 'Settings Assignment';
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = List;
    SourceTable = DYM_SettingsAssignment;

    layout
    {
        area(content)
        {
            repeater(RepeaterArea)
            {
                ShowCaption = false;

                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                    Visible = HierarchyVisible;
                }
                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                    Visible = HierarchyVisible;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                    Visible = HierarchyVisible;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        [InDataSet]
        HierarchyVisible: Boolean;

    trigger OnOpenPage()
    begin
        HierarchyVisible := ((Rec.GetFilter("Device Role Code") = '') AND (Rec.GetFilter("Device Group Code") = '') AND (Rec.GetFilter("Device Setup Code") = ''));
    end;
}
