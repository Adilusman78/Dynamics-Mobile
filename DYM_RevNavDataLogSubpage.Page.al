page 84059 DYM_RevNavDataLogSubpage
{
    Caption = 'Rev. Nav. Data Log Subpage';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = DYM_DataLog;
    SourceTableTemporary = true;
    SourceTableView = SORTING(Position);

    layout
    {
        area(content)
        {
            repeater(Control5)
            {
                ShowCaption = false;

                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
                field("Sync Log Entry No."; Rec."Sync Log Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    procedure Refresh()
    begin
        CurrPage.Update(false);
    end;
    procedure TransferDataLogBuffer(var DataLogBuffer: Record DYM_DataLog)
    begin
        Rec.Reset;
        Rec.DeleteAll;
        DataLogBuffer.Reset;
        if DataLogBuffer.FindSet(false, false)then repeat Rec.Init;
                Rec.TransferFields(DataLogBuffer, true);
                Rec.Insert;
            until DataLogBuffer.Next = 0;
    end;
}
