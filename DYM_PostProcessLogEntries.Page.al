page 84056 DYM_PostProcessLogEntries
{
    Caption = 'Post Process Log Entries';
    UsageCategory = History;
    ApplicationArea = All;
    PageType = List;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Process,Logs';
    SourceTable = DYM_PostProcessLog;
    SourceTableView = SORTING("Entry No.")ORDER(Descending);

    //UsageCategory = History;
    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                FreezeColumn = "Entry No.";
                Editable = false;

                field("Sync Log Entry No."; Rec."Sync Log Entry No.")
                {
                    ApplicationArea = All;
                    Visible = SyncLogEntryNoVisible;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field(PositionWithNames; PostProcessMgt.GetPositionWithNames(Rec))
                {
                    Caption = 'Position';
                    ApplicationArea = All;
                }
                field("Operation Type"; Rec."Operation Type")
                {
                    ApplicationArea = All;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                }
                field("Start TimeStamp"; Rec."Start TimeStamp")
                {
                    ApplicationArea = All;
                }
                field("End TimeStamp"; Rec."End TimeStamp")
                {
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; Rec."Entry TimeStamp")
                {
                    ApplicationArea = All;
                }
                field(Parameters; Rec.Parameters)
                {
                    ApplicationArea = All;
                }
                field(Data; Rec.Data)
                {
                    ApplicationArea = All;
                }
                field(Dependancy; Rec.Dependancy)
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field(Subsequent; Rec.Subsequent)
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("&Reset status")
            {
                ApplicationArea = All;
                Caption = '&Reset status';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if(Rec.Count > 1)then begin
                        if Confirm(StrSubstNo(Text001, Rec.Count), false)then begin
                            if Rec.FindSet()then repeat Rec.ResetStatus(true);
                                until Rec.Next() = 0;
                        end
                        else
                        begin
                            exit;
                        end;
                    end
                    else
                    begin
                        Rec.ResetStatus(false);
                    end;
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
        }
        area(Navigation)
        {
            action("E&vent Log Entries")
            {
                ApplicationArea = All;
                Caption = 'E&vent Log Entries';
                Image = WarrantyLedger;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page DYM_EventLogEntries;
                RunPageLink = "Source Type"=CONST("Post-Processing"), "Source Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Source Entry No.");
            }
            action("S&MS Log Entries")
            {
                ApplicationArea = All;
                Caption = 'S&MS Log Entries';
                Image = CheckLedger;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page DYM_SMSEntries;
                RunPageLink = "Sync Log Entry No."=FIELD("Sync Log Entry No."), "Post Process Log Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Sync Log Entry No.", "Post Process Log Entry No.");
            }
        }
    }
    var PostProcessMgt: Codeunit DYM_PostProcessManagement;
    SyncLogEntryNoVisible: Boolean;
    Text001: Label 'You have selected [%1] Post Process Log entries to be set to Pending status. If you set the status to Pending for the selected Post Process Log Entries the system will try to execute business logic. Do you want to continue?';
    trigger OnOpenPage()
    begin
        SyncLogEntryNoVisible:=(Rec.GetFilter("Sync Log Entry No.") = '');
    end;
}
