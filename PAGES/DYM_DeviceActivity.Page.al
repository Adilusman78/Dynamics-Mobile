page 70132 DYM_DeviceActivity
{
    Caption = 'Device Activity Log Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = DYM_DeviceActivity;
    SourceTableView = SORTING("Entry No.") ORDER(Descending);
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1103100000)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Cutomer Name"; Rec."Cutomer Name")
                {
                    ApplicationArea = All;
                }
                field("SalesPerson Code"; Rec."SalesPerson Code")
                {
                    ApplicationArea = All;
                }
                field("Vist No."; Rec."Vist No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Action; Rec.Action)
                {
                    ApplicationArea = All;
                }
                field("Visit Date"; Rec."Visit Date")
                {
                    ApplicationArea = All;
                }
                field(Distance; Rec.Distance)
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Valid Distance"; Rec."Valid Distance")
                {
                    ApplicationArea = All;
                }
                field("In Route"; Rec."In Route")
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
            }
        }
    }
}
