page 84003 DYM_BLOBStoreList
{
    Caption = 'BLOB Store Entries';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = DYM_BLOBStore;
    PromotedActionCategories = 'New,Process,Report,Process,Logs';

    layout
    {
        area(Content)
        {
            repeater(ListRepeater)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Entry TimeStamp"; Rec."Entry TimeStamp")
                {
                    ToolTip = 'Specifies the value of the Entry TimeStamp field.';
                    ApplicationArea = All;
                }
                field(Identifier; Rec.Identifier)
                {
                    ToolTip = 'Specifies the value of the Identifier field.';
                    ApplicationArea = All;
                }
                field("Packet Type"; Rec."Packet Type")
                {
                    ToolTip = 'Specifies the value of the Packet Type field.';
                    ApplicationArea = All;
                }
                field("Content Size"; Rec."Content Size")
                {
                    ToolTip = 'Specifies the value of the Content Size field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ToolTip = 'Specifies the value of the Device Setup Code field.';
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.';
                    ApplicationArea = All;
                }
                field(URL; Rec.URL)
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
                RunPageLink = "Source Type"=CONST("BLOB Loading"), "Source Entry No."=FIELD("Entry No.");
                RunPageView = SORTING("Source Entry No.");
            }
        }
    }
}
