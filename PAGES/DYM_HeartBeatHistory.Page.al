page 70144 DYM_HeartBeatHistory
{
    SourceTableTemporary = true;
    SourceTable = DYM_HeartBeat;
    Caption = 'Heart Beat History';
    PageType = List;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(HeartBeat)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Queue Entry Description"; Rec."Job Queue Entry Description")
                {
                    ApplicationArea = All;
                }
                field("Entry Relation ID"; Rec."Entry Relation ID")
                {
                    ApplicationArea = All;
                }
                field("Entry Relation Type"; Rec."Entry Relation Type")
                {
                    ApplicationArea = All;
                }
                field(Operation; Rec.Operation)
                {
                    ApplicationArea = All;
                }
                field(Data; Rec.Data)
                {
                    ApplicationArea = All;
                }
                field("Date Time"; Rec."Date Time")
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field("Job Queue Entry Id"; Rec."Job Queue Entry Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Update")
            {
                ApplicationArea = All;
                Caption = 'Update';
                PromotedCategory = Process;
                Promoted = true;
                Image = History;

                trigger OnAction()
                var
                    HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
                    LowLevelDP: Codeunit DYM_LowLevelDataProcess;
                begin
                    ClearHeartBeatBuffer(Rec);
                    if (Rec.GetFilter("Job Queue Entry Id") <> '') then
                        HeartBeatMgt.GetHeartBeatHistory(Rec.GetRangeMin("Job Queue Entry Id"), Rec)
                    else
                        HeartBeatMgt.GetHeartBeatHistory(LowLevelDP.GetNullGuid(), Rec);
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
        }
    }
    procedure ClearHeartBeatBuffer(var _HeartBeatBuffer: Record DYM_HeartBeat)
    begin
        _HeartBeatBuffer.Reset();
        if _HeartBeatBuffer.IsTemporary then _HeartBeatBuffer.DeleteAll();
    end;
}
