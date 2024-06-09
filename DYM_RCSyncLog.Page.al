page 84082 DYM_RCSyncLog
{
    Caption = 'RC Sync Log';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = DYM_SyncLog;
    SourceTableView = WHERE(Internal=CONST(false), "Packet Type"=CONST(Data));

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Internal; Rec.Internal)
                {
                    ApplicationArea = All;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Reset Status")
            {
                ApplicationArea = All;
                Caption = '&Reset Status';
                Image = ReOpen;

                trigger OnAction()
                begin
                    Rec.ReParse(false);
                end;
            }
            action("&Statistics")
            {
                ApplicationArea = All;
                Caption = '&Statistics';
                Image = Statistics;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    Rec.ShowStatistics;
                end;
            }
            action("&Navigation")
            {
                ApplicationArea = All;
                Caption = '&Navigation';
                Image = Navigate;
                ShortCutKey = 'Ctrl+F5';

                trigger OnAction()
                begin
                    Rec.ShowNavigation;
                end;
            }
        }
    }
}
