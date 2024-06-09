page 70142 DYM_EventLogEntries
{
    Caption = 'Event Log Entries';
    UsageCategory = History;
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    MultipleNewLines = false;
    PageType = List;
    SourceTable = DYM_EventLog;

    layout
    {
        area(content)
        {
            repeater(Control1103110000)
            {
                Editable = false;
                ShowCaption = false;

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    Visible = SourceFieldsVisible;
                }
                field("Source Entry No."; Rec."Source Entry No.")
                {
                    ApplicationArea = All;
                    Visible = SourceFieldsVisible;
                }
                field("Event Type"; Rec."Event Type")
                {
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; LowLevelDP.DateTime2Text(Rec."Entry TimeStamp"))
                {
                    ApplicationArea = All;
                }
                field(Checked; Rec.Checked)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                }
                field("Data Available"; Rec.Data.HasValue)
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
            group("F&unctions")
            {
                Caption = 'F&unctions';

                action("Check selected")
                {
                    ApplicationArea = All;
                    Caption = 'Check selected';
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CheckSelected;
                    end;
                }
                action("Show Data")
                {
                    ApplicationArea = All;
                    Caption = 'Show Data';
                    Image = RelatedInformation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ShowData();
                    end;
                }
            }
        }
    }
    var
        ConstMgt: Codeunit DYM_ConstManagement;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        SourceFieldsVisible: Boolean;
        Text001: Label 'There is not data for Event Log Entry No. [%1].';

    trigger OnOpenPage()
    begin
        SourceFieldsVisible := Rec.GetFilter("Source Entry No.") = '';
    end;

    procedure CheckSelected()
    var
        EventLog: Record DYM_EventLog;
    begin
        EventLog.Reset;
        CurrPage.SetSelectionFilter(EventLog);
        EventLog.ModifyAll(Checked, true);
    end;

    procedure GetColor() Result: Integer
    begin
        Clear(Result);
        case Rec."Event Type" of
            Rec."Event Type"::Info, Rec."Event Type"::Warning:
                exit(0);
            Rec."Event Type"::Error:
                exit(ConstMgt.CLR_ProblemSeverity1);
            Rec."Event Type"::Debug:
                exit(ConstMgt.CLR_Debug);
        end;
    end;

    procedure ShowData()
    var
        Data: Text;
        TempText: Text;
        InS: InStream;
    begin
        Rec.CalcFields(Data);
        if (Rec.Data.HasValue) then begin
            Rec.Data.CreateInStream(InS, TextEncoding::UTF8);
            while not ins.EOS do begin
                Ins.ReadText(TempText);
                Data := Data + TempText;
            end;
            Message(Data);
        end
        else
            Message(Text001, Rec."Entry No.");
    end;
}
