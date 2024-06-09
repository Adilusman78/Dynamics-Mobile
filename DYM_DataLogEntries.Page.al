page 84014 DYM_DataLogEntries
{
    Caption = 'Data Log Entries';
    UsageCategory = History;
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = List;
    SourceTable = DYM_DataLog;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                ShowCaption = false;

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; Rec."Entry TimeStamp")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Sync Log Entry No."; Rec."Sync Log Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field(PositionWithNames; DataLogMgt.GetPositionWithNames(Rec))
                {
                    Caption = 'Position';
                    ApplicationArea = All;
                }
            }
        }
    }
    var DataLogMgt: Codeunit DYM_DataLogmanagement;
}
