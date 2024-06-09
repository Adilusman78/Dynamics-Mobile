page 70168 DYM_SalespersonRoute
{
    Caption = 'Salesperson Route';
    PageType = List;
    SourceTable = DYM_SalespersonRoute;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Week No."; Rec."Week No.")
                {
                    ApplicationArea = All;
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Route Order"; Rec."Route Order")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Address"; Rec."Customer Address")
                {
                    ApplicationArea = All;
                }
                field("Customer City"; Rec."Customer City")
                {
                    ApplicationArea = All;
                }
                field("Nr. Visits"; Rec."Nr. Visits")
                {
                    ApplicationArea = All;
                }
                field(Channel; Rec.Channel)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Route Entry Name"; Rec."Route Entry Name")
                {
                    ApplicationArea = All;
                }
                field("Route Entry Address"; Rec."Route Entry Address")
                {
                    ApplicationArea = All;
                }
                field("Route Entry City"; Rec."Route Entry City")
                {
                    ApplicationArea = All;
                }
                field("Route Makani Code"; Rec."Route Makani Code")
                {
                    ApplicationArea = All;
                }
                field("Original Salesperson Code"; Rec."Original Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Mobile Device"; Rec."Mobile Device")
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
