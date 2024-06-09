page 70154 DYM_RawDataLogEntries
{
    Caption = 'Raw Data Log Entries';
    UsageCategory = History;
    ApplicationArea = All;
    PageType = List;
    SourceTable = DYM_RawDataLog;

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
                field("Sync Log Entry No."; Rec."Sync Log Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                }
                field("Record No."; Rec."Record No.")
                {
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = All;
                }
                field(Value; Rec."Field Value")
                {
                    ApplicationArea = All;
                }
                field("Blob Value"; Rec."Blob Value".HasValue())
                {
                    ApplicationArea = All;
                }
                field("Filter Flag"; Rec."Filter Flag")
                {
                    ApplicationArea = All;
                }
                field("Filter Missing"; Rec."Filter Missing")
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
