page 70165 DYM_RevNavSyncLogSubPage
{
    Caption = 'Rev. Nav. Sync Log Subpage';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = DYM_SyncLog;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;

                field("Entry TimeStamp"; Rec."Entry TimeStamp")
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
                field(Path; Rec.Path)
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
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Image = Open;

                trigger OnAction()
                var
                    SyncLog: Record DYM_SyncLog;
                begin
                    SyncLog.Reset();
                    SyncLog.Get(Rec."Entry No.");
                    SyncLog.SetRecFilter();
                    Page.RunModal(Page::DYM_SyncLogEntries, SyncLog);
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
    procedure Refresh()
    begin
        CurrPage.Update(false);
    end;

    procedure TransferSyncLogBuffer(var SyncLogBuffer: Record DYM_SyncLog)
    var
        DataLog: Record DYM_DataLog;
        SyncLog: Record DYM_SyncLog;
    begin
        Rec.Reset;
        Rec.DeleteAll;
        SyncLogBuffer.Reset;
        if SyncLogBuffer.FindSet(false, false) then
            repeat
                Rec.Init;
                Rec.TransferFields(SyncLogBuffer, true);
                Rec.Insert;
            until SyncLogBuffer.Next = 0;
    end;
}
