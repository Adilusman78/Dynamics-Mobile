page 84008 DYM_SyncLogEntries
{
    Caption = 'Sync Log Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Process,Report,Logs';
    SourceTable = DYM_SyncLog;
    SourceTableView = SORTING("Entry No.")ORDER(Descending);
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1103100000)
            {
                Editable = false;
                FreezeColumn = "Entry No.";
                ShowCaption = false;

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; Rec."Entry TimeStamp")
                {
                    ApplicationArea = All;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                }
                field(Internal; Rec.Internal)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Packet Size"; Rec."Packet Size")
                {
                    ApplicationArea = All;
                }
                field("Opertion Hint"; Rec."Operation Hint")
                {
                    ApplicationArea = All;
                }
                field(Path; Rec.Path)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.OpenPacket;
                    end;
                }
                field("Error Description"; Rec."Error Description")
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
                field(Priority; Rec.Priority)
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
                field("Pull Type"; Rec."Pull Type")
                {
                    ApplicationArea = All;
                }
                field("Packet Type"; Rec."Packet Type")
                {
                    ApplicationArea = All;
                }
                field("Last State"; Rec."Last State")
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
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
            action("&Enqueue")
            {
                ApplicationArea = All;
                Caption = '&Enqueue';
                Image = CopyToTask;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Enqueue();
                end;
            }
            action("&Download")
            {
                ApplicationArea = All;
                Caption = '&Download';
                Image = MoveDown;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Download();
                end;
            }
            action("Manual Process")
            {
                ApplicationArea = All;
                Caption = '&Manual Process';
                Image = ServiceItem;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.ManualProcess();
                end;
            }
            action("Debug")
            {
                ApplicationArea = All;
                Caption = 'Debug';
                Image = DebugNext;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if(Rec.Count > 1)then begin
                        if Confirm(Text001, false)then begin
                            if Rec.FindSet()then repeat Rec.Debug(true);
                                until Rec.Next() = 0;
                        end
                        else
                        begin
                            exit;
                        end;
                    end
                    else
                    begin
                        Rec.Debug(false);
                    end;
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
            action("Re-&Load")
            {
                ApplicationArea = All;
                Caption = 'Re-&Load';
                Image = ExportShipment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if(Rec.Count > 1)then begin
                        if Confirm(Text002, false)then begin
                            if Rec.FindSet()then repeat Rec.ReLoad(true);
                                until Rec.Next() = 0;
                        end
                        else
                        begin
                            exit;
                        end;
                    end
                    else
                    begin
                        Rec.ReLoad(false);
                    end;
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
            action("Re-&Parse")
            {
                ApplicationArea = All;
                Caption = 'Re-&Parse';
                Image = ImportLog;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if(Rec.Count > 1)then begin
                        if Confirm(Text003, false)then begin
                            if Rec.FindSet()then repeat Rec.ReParse(true);
                                until Rec.Next() = 0;
                        end
                        else
                        begin
                            exit;
                        end;
                    end
                    else
                    begin
                        Rec.ReParse(false);
                    end;
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
            action("Re-P&rocess")
            {
                ApplicationArea = All;
                Caption = 'Re-P&rocess';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if(Rec.Count > 1)then begin
                        if Confirm(Text004, false)then begin
                            if Rec.FindSet()then repeat Rec.ReProcess(true);
                                until Rec.Next() = 0;
                        end
                        else
                        begin
                            exit;
                        end;
                    end
                    else
                    begin
                        Rec.ReProcess(false);
                    end;
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
        }
        area(Reporting)
        {
            action("&Statistics")
            {
                ApplicationArea = All;
                Caption = '&Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
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
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+F5';

                trigger OnAction()
                begin
                    Rec.ShowNavigation;
                end;
            }
            action(SmartNavigate)
            {
                ApplicationArea = All;
                Caption = 'Smart Navigate';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.SmartNavigate();
                end;
            }
        }
        area(Navigation)
        {
            action("Ra&w Data Log Entries")
            {
                ApplicationArea = All;
                Caption = 'Ra&w Data Log Entries';
                Image = ItemTrackingLedger;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page DYM_RawDataLogEntries;
                RunPageLink = "Sync Log Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Sync Log Entry No.", "Entry Type", "Table Name", "Record No.", "Field Name", "Attribute Name", "Field Value");
            }
            action("E&vent Log Entries")
            {
                ApplicationArea = All;
                Caption = 'E&vent Log Entries';
                Image = WarrantyLedger;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page DYM_EventLogEntries;
                RunPageLink = "Source Type"=CONST(Processing), "Source Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Source Entry No.");
            }
            action("&Data Log Entries")
            {
                ApplicationArea = All;
                Caption = '&Data Log Entries';
                Image = VATLedger;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page DYM_DataLogEntries;
                RunPageLink = "Sync Log Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Sync Log Entry No.", "Table No.");
            }
            action("P&ost Process Log Entries")
            {
                ApplicationArea = All;
                Caption = 'P&ost Process Log Entries';
                Image = CapacityLedger;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page DYM_PostProcessLogEntries;
                RunPageLink = "Sync Log Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Sync Log Entry No.");
            }
            action("S&MS Log Entries")
            {
                ApplicationArea = All;
                Caption = 'S&MS Log Entries';
                Image = CheckLedger;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page DYM_SMSEntries;
                RunPageLink = "Sync Log Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Sync Log Entry No.", "Post Process Log Entry No.");
            }
        }
    }
    var Text001: Label 'You have been selected multiple synclog entries to be set to Debug status. If you set the status to Debug the Sync Log Entries can not be handled. Do you want to continue?';
    Text002: Label 'You have been selected multiple synclog entries to be set to Pending status. If you try to load the packet will be loaded from storage location. Do you want to continue?';
    Text003: Label 'You have been selected multiple synclog entries to be set to Loaded status. If you re-parse the entry the system will try to parse and process it again. The raw data will be read again from packet. Do you want to continue?';
    Text004: Label 'You have been selected multiple synclog entries to be set to Parsed status. If you re-process the entry the system will try to execute business logic with current raw data. Do you want to continue?';
}
