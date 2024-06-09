pageextension 84300 DYM_WH_LocationCard extends "Location Card"
{
    layout
    {
        addafter("Bin Policies")
        {
            group(DYM_DynamicsMobile)
            {
                Caption = 'Dynamics Mobile';

                group(DYM_DefaultQuantitiesBasic)
                {
                    Caption = 'Default quantities (Basic)';

                    field(DYM_ZeroSalesQtytoShip; Rec.DYM_ZeroSalesQtytoShip)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Sales Qty. to Ship';
                    }
                    field(DYM_ZeroPurchQtytoReceive; Rec.DYM_ZeroPurchQtytoReceive)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Purch. Qty. to Receive';
                    }
                    field(DYM_ZeroTransQtytoShip; Rec.DYM_ZeroTransQtytoShip)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Trans. Qty. to Ship';
                    }
                    field(DYM_ZeroTransQtytoReceive; Rec.DYM_ZeroTransQtytoReceive)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Trans. Qty. to Receive';
                    }
                    field(DYM_ZeroPhysInvJnlQtyPhys; Rec.DYM_ZeroPhysInvJnlQtyPhys)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Phys. Inv. Jnl. Qty. Phys. Inv.';
                    }
                }
                group(DYM_DefaultQuantitiesWMS)
                {
                    Caption = 'Default quantities (WMS)';

                    field(DYM_ZeroWhseShptQtytoShip; Rec.DYM_ZeroWhseShptQtytoShip)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Whse. Shpt. Qty. to Ship';
                    }
                    field(DYM_ZeroWhseRcptQtytoRcv; Rec.DYM_ZeroWhseRcptQtytoRcv)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Whse. Rcpt. Qty. to Rcv.';
                    }
                    field(DYM_ZeroPickQtytoHandle; Rec.DYM_ZeroPickQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Pick Qty. to Handle';
                    }
                    field(DYM_ZeroPutAwayQtytoHandle; Rec.DYM_ZeroPutAwayQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Put-Away Qty. to Handle';
                    }
                    field(DYM_ZeroMovementQtytoHandle; Rec.DYM_ZeroMovementQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Movement Qty. to Handle';
                    }
                    field(DYM_ZeroWhsePhysInvJnlQtyPhys; Rec.DYM_ZeroWhsePhysInvJnlQtyPhys)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Whse. Phys. Inv. Jnl. Qty. Phys. Inv.';
                    }
                }
                group(DYM_DefaultTrackQty)
                {
                    Caption = 'Default tracking quantities';

                    field(DYM_ZeroSalesTrackQtytoHandle; Rec.DYM_ZeroSalesTrackQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Sales Tracking Qty. to Handle';
                    }
                    field(DYM_ZeroPurchTrackQtytoHandle; Rec.DYM_ZeroPurchTrackQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Purch. Tracking Qty. to Handle';
                    }
                    field(DYM_ZeroTransShipQtytoHandle; Rec.DYM_ZeroTransShipQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Trans Ship Qty. to Handle';
                    }
                    field(DYM_ZeroTransRcvQtytoHandle; Rec.DYM_ZeroTransRcvQtytoHandle)
                    {
                        ApplicationArea = All;
                        Caption = 'Zero Trans Rcv Qty. to Handle';
                    }
                }
                group(DYM_DocumentMobileStatus)
                {
                    Caption = 'Default Mobile Status';

                    field(DYM_MobStatusTransferRcpt; Rec.DYM_MobStatusTransferRcpt)
                    {
                        ApplicationArea = All;
                        Caption = 'Mob. Receive Status Transfers';
                    }
                    field(DYM_MobStatusWhseShipment; Rec.DYM_MobStatusWhseShipment)
                    {
                        ApplicationArea = All;
                        Caption = 'Mob. Status Whse. Shipment';
                    }
                    field(DYM_MobStatusWhseReceipt; Rec.DYM_MobStatusWhseReceipt)
                    {
                        ApplicationArea = All;
                        Caption = 'Mob. Status Whse. Receipt';
                    }
                    field(DYM_MobStatusPick; Rec.DYM_MobStatusPick)
                    {
                        ApplicationArea = All;
                        Caption = 'Mob. Status Pick';
                    }
                    field(DYM_MobStatusPutaway; Rec.DYM_MobStatusPutaway)
                    {
                        ApplicationArea = All;
                        Caption = 'Mob. Status Put-away';
                    }
                    field(DYM_MobStatusMovement; Rec.DYM_MobStatusMovement)
                    {
                        ApplicationArea = All;
                        Caption = 'Mob. Status Movement';
                    }
                }
            }
        }
    }
}
