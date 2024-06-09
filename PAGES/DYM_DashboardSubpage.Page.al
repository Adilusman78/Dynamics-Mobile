page 70129 DYM_DashboardSubpage
{
    Caption = 'Dashboard Subpage';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = DYM_DeviceSetup;
    SourceTableView = SORTING(Code) WHERE(Disabled = CONST(false), "Device Group Disabled" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                ShowCaption = false;

                field(tbox_Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Mobile Device';
                }
                field(tbox_Pending; Values[1])
                {
                    ApplicationArea = All;
                    Caption = 'Pending Pushes';
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Pending)
                    end;
                }
                field(tbox_Success; Values[2])
                {
                    ApplicationArea = All;
                    Caption = 'Success Pushes';
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Success)
                    end;
                }
                field(tbox_Failed; Values[3])
                {
                    ApplicationArea = All;
                    Caption = 'Failed Pushes';
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Failed)
                    end;
                }
                field(tbox_Error; Values[4])
                {
                    ApplicationArea = All;
                    Caption = 'Error Pushes';
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Error)
                    end;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("<Action1103109019>")
            {
                ApplicationArea = All;
                Caption = 'Expor&t Data';
                Image = SendTo;
                ShortCutKey = 'Ctrl+T';

                trigger OnAction()
                begin
                    Rec.ForceSync(true);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Values[1] := DashboardMgt.GetPacketsCount(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Pending);
        Values[2] := DashboardMgt.GetPacketsCount(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Success);
        Values[3] := DashboardMgt.GetPacketsCount(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Failed);
        Values[4] := DashboardMgt.GetPacketsCount(Rec.Code, enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Error);
    end;

    var
        DashboardMgt: Codeunit DYM_DashboardManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        Values: array[4] of Decimal;

    procedure GetColor(): Integer
    begin
        if (Values[4] <> 0) then exit(ConstMgt.CLR_ProblemSeverity2);
        if (Values[3] <> 0) then exit(ConstMgt.CLR_ProblemSeverity1);
        if (Values[1] <> 0) then exit(ConstMgt.CLR_Attention);
        exit(0);
    end;

    procedure ForceUpdate(SaveRecord: Boolean)
    begin
        CurrPage.Update(SaveRecord);
    end;
}
