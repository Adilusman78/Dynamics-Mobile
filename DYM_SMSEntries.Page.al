page 84057 DYM_SMSEntries
{
    Caption = 'SMS Entries';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = DYM_SMSEntry;
    UsageCategory = History;
    ApplicationArea = All;

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
                field("Sending Datetime"; Rec."Sending Datetime")
                {
                    ApplicationArea = All;
                }
                field(Recipient; Rec.Recipient)
                {
                    ApplicationArea = All;
                }
                field("Message text"; Rec."Message text")
                {
                    ApplicationArea = All;
                }
                field("Raw message text"; Rec."Raw message text")
                {
                    ApplicationArea = All;
                }
                field("API response"; Rec."API response")
                {
                    ApplicationArea = All;
                }
                field("Return code"; Rec."Return code")
                {
                    ApplicationArea = All;
                }
                field("Return code description"; Rec."Return code description")
                {
                    ApplicationArea = All;
                }
                field("Post Process Log Entry No."; Rec."Post Process Log Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Sync Log Entry No."; Rec."Sync Log Entry No.")
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
