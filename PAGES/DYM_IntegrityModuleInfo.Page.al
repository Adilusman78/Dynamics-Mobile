page 70146 DYM_IntegrityModuleInfo
{
    Caption = 'Integrity Module Info';
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = DYM_IntegrityModuleInfo;
    PageType = List;

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field("App Id"; Rec."App Id")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Publisher; Rec.Publisher)
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
            action(Update)
            {
                ApplicationArea = All;
                Caption = 'Update';
                ToolTip = 'Update integrity modules list';
                Image = RefreshPlanningLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IntegrityMgt: Codeunit DYM_IntegrityManagement;
                begin
                    Clear(IntegrityMgt);
                    IntegrityMgt.UpdateIntegrityModuleList();
                end;
            }
            action(CheckIntegrity)
            {
                ApplicationArea = All;
                Caption = 'Check';
                Tooltip = 'Check integrity';
                Image = CheckList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IntegrityMgt: Codeunit DYM_IntegrityManagement;
                begin
                    Clear(IntegrityMgt);
                    if IntegrityMgt.TestModulesIntegrity(false) then Message(Text001);
                end;
            }
        }
    }
    var
        Text001: Label 'Integrity check successful.';
}
