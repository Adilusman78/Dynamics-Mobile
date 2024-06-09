page 84018 DYM_DynamicsMobileDashboard
{
    Caption = 'Dynamics Mobile Dashboard';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Push Packets")
            {
                Caption = 'Push Packets';

                field("Push_Pending"; DashboardMgt.GetPacketsCount('', enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Pending))
                {
                    ApplicationArea = All;
                    Caption = 'Pending';
                    Importance = Promoted;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets('', enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Pending);
                    end;
                }
                field("Push_Failed"; DashboardMgt.GetPacketsCount('', enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Failed))
                {
                    ApplicationArea = All;
                    Caption = 'Failed';
                    Importance = Promoted;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets('', enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Failed);
                    end;
                }
                field("Push_Error"; DashboardMgt.GetPacketsCount('', enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Error))
                {
                    ApplicationArea = All;
                    Caption = 'Error';
                    Importance = Promoted;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets('', enum::DYM_PacketDirection::Push, enum::DYM_PacketStatus::Error);
                    end;
                }
            }
            group("Pull Packets")
            {
                Caption = 'Pull Packets';

                field("Pull_Pending"; DashboardMgt.GetPacketsCount('', enum::DYM_PacketDirection::Pull, enum::DYM_PacketStatus::Pending))
                {
                    ApplicationArea = All;
                    Caption = 'Pending';
                    Importance = Promoted;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets('', enum::DYM_PacketDirection::Pull, enum::DYM_PacketStatus::Pending);
                    end;
                }
                field("Pull_Failed"; DashboardMgt.GetPacketsCount('', enum::DYM_PacketDirection::Pull, enum::DYM_PacketStatus::Failed))
                {
                    ApplicationArea = All;
                    Caption = 'Failed';
                    Importance = Promoted;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets('', enum::DYM_PacketDirection::Pull, enum::DYM_PacketStatus::Failed);
                    end;
                }
                field("Pull_Error"; DashboardMgt.GetPacketsCount('', enum::DYM_PacketDirection::Pull, enum::DYM_PacketStatus::Error))
                {
                    ApplicationArea = All;
                    Caption = 'Error';
                    Importance = Promoted;

                    trigger OnDrillDown()
                    begin
                        DashboardMgt.DrillDownPackets('', enum::DYM_PacketDirection::Pull, enum::DYM_PacketStatus::Error);
                    end;
                }
            }
            group(General)
            {
                Caption = 'General';

                field("DashboardMgt.GetSettingsSynced"; DashboardMgt.GetSettingsSynced)
                {
                    ApplicationArea = All;
                    Caption = 'Setup Synced';
                    Importance = Promoted;
                }
                field("DashboardMgt.GetActiveGroups"; DashboardMgt.GetActiveGroups)
                {
                    ApplicationArea = All;
                    Caption = 'Active Groups';
                    Importance = Promoted;
                }
                field("DashboardMgt.GetActiveDevices"; DashboardMgt.GetActiveDevices)
                {
                    ApplicationArea = All;
                    Caption = 'Active Devices';
                    Importance = Promoted;
                }
            }
            part(subfrm_Devices; DYM_DashboardSubpage)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
    }
    var DashboardMgt: Codeunit DYM_DashboardManagement;
    ConstMgt: Codeunit DYM_ConstManagement;
}
