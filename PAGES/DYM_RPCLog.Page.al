page 70166 DYM_RPCLog
{
    Caption = 'RPC Log';
    UsageCategory = History;
    ApplicationArea = All;
    PromotedActionCategories = 'New, Process, Report, Data, Logs, Action';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = DYM_RPCLog;
    SourceTableView = SORTING("Entry no") ORDER(Descending);

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Entry No"; Rec."Entry no")
                {
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; Rec."Entry TimeStamp")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Operation Hint"; Rec."Operation Hint")
                {
                    ApplicationArea = All;
                }
                field("Operation Data"; Rec."Operation Data")
                {
                    ApplicationArea = All;
                }
                field("Error Code"; Rec."Error Code")
                {
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
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
        area(Reporting)
        {
            group(Process)
            {
                action("Show request")
                {
                    ApplicationArea = All;
                    Caption = 'Show request';
                    Promoted = true;
                    PromotedCategory = Category4;
                    Image = SendElectronicDocument;

                    trigger OnAction()
                    begin
                        Rec.ShowRequest();
                    end;
                }
                action("Show response")
                {
                    ApplicationArea = All;
                    Caption = 'Show response';
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Image = TransmitElectronicDoc;

                    trigger OnAction()
                    begin
                        Rec.ShowResponse();
                    end;
                }
                action("EventLog entries")
                {
                    ApplicationArea = All;
                    Caption = 'EventLog';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = WarrantyLedger;
                    PromotedCategory = Category5;
                    RunObject = page DYM_EventLogEntries;
                    RunPageLink = "Source Type" = const(RPC), "Source Entry No." = FIELD("Entry No");
                    RunPageView = SORTING("Source Entry No.");
                }
            }
            group(Action)
            {
                action("Enqueue")
                {
                    ApplicationArea = All;
                    Caption = 'Enqueue';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Image = CopyToTask;

                    trigger OnAction()
                    begin
                        Rec.Enqueue();
                    end;
                }
                action("Execute")
                {
                    ApplicationArea = All;
                    Caption = 'Execute';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Image = Action;

                    trigger OnAction()
                    begin
                        Rec.Execute();
                    end;
                }
            }
        }
    }
}
