page 84026 DYM_HeartBeatStatus
{
    SourceTableTemporary = true;
    SourceTable = DYM_HeartBeat;
    Caption = 'Heart Beat Status';
    PageType = List;

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
        area(Processing)
        {
            action("Show Heart Beat")
            {
                ApplicationArea = All;
                Caption = 'Show Heart Beat';
                PromotedCategory = Process;
                Promoted = true;
                Image = MaintenanceLedger;

                trigger OnAction()
                var
                    HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
                begin
                    ClearHeartBeatBuffer(Rec);
                    HeartBeatMgt.GetHeartBeat(Rec);
                    Rec.Reset();
                    CurrPage.SetTableView(Rec);
                end;
            }
        }
        area(Navigation)
        {
            group(History)
            {
                Caption = 'History';

                action("Show Job Queue Heart Beat History")
                {
                    ApplicationArea = All;
                    Caption = 'Show Job Queue Heart Beat History';
                    PromotedCategory = Process;
                    Promoted = true;
                    Image = History;

                    trigger OnAction()
                    var
                        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
                        HeartBeatBuffer: Record DYM_HeartBeat temporary;
                    begin
                        ClearHeartBeatBuffer(HeartBeatBuffer);
                        HeartBeatMgt.GetHeartBeatHistory(Rec."Job Queue Entry Id", HeartBeatBuffer);
                        HeartBeatBuffer.Reset();
                        Page.RunModal(page::DYM_HeartBeatHistory, HeartBeatBuffer);
                    end;
                }
                action("Show Full Heart Beat History")
                {
                    ApplicationArea = All;
                    Caption = 'Show Full Heart Beat History';
                    PromotedCategory = Process;
                    Promoted = true;
                    Image = History;

                    trigger OnAction()
                    var
                        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
                        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
                        HeartBeatBuffer: Record DYM_HeartBeat temporary;
                    begin
                        ClearHeartBeatBuffer(HeartBeatBuffer);
                        HeartBeatMgt.GetHeartBeatHistory(LowLevelDP.GetNullGuid(), HeartBeatBuffer);
                        HeartBeatBuffer.Reset();
                        Page.RunModal(page::DYM_HeartBeatHistory, HeartBeatBuffer);
                    end;
                }
            }
        }
    }
    procedure ClearHeartBeatBuffer(var _HeartBeatBuffer: Record DYM_HeartBeat)
    begin
        _HeartBeatBuffer.Reset();
        if _HeartBeatBuffer.IsTemporary then _HeartBeatBuffer.DeleteAll();
    end;
}
