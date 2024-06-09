pageextension 70113 DYM_WH_TransferOrders extends "Transfer Orders"
{
    layout
    {
        addlast(Control1)
        {
            field(DYM_MobileShipStatus; Rec.DYM_MobileShipStatus)
            {
                ApplicationArea = All;
                Caption = 'Mobile Ship Status';
            }
            field(DYM_MobileReceiveStatus; Rec.DYM_MobileReceiveStatus)
            {
                ApplicationArea = All;
                Caption = 'Mobile Receive Status';
            }
            field(DYM_MobileDevice; Rec.DYM_MobileDevice)
            {
                ApplicationArea = All;
                Caption = 'Mobile Device';
            }
        }
    }
}
