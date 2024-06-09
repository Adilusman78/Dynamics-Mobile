page 70180 DYM_VisitEntries
{
    Caption = 'Visit Entries';
    PageType = List;
    SourceTable = DYM_VisitEntry;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Action"; Rec.Action)
                {
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; Rec."Entry TimeStamp")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = All;
                }
                field("Comment 2"; Rec."Comment 2")
                {
                    ApplicationArea = All;
                }
                field("Comment 3"; Rec."Comment 3")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Name"; Rec."Salesperson Name")
                {
                    ApplicationArea = All;
                }
                field("Sync Log Entry No."; Rec."Sync Log Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                }
                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                }
                field(Targets; Rec.Targets)
                {
                    ApplicationArea = All;
                }
                field(Samples; Rec.Samples)
                {
                    ApplicationArea = All;
                }
                field(ApprovedProducts; Rec.ApprovedProducts)
                {
                    ApplicationArea = All;
                }
                field(UnapprovedProducts; Rec.UnapprovedProducts)
                {
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                }
                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = All;
                }
                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
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
