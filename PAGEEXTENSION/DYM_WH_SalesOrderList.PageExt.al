pageextension 70111 DYM_WH_SalesOrderList extends "Sales Order List"
{
    layout
    {
        addlast(Control1)
        {
            field(DYM_MobileStatus; Rec.DYM_MobileStatus)
            {
                ApplicationArea = All;
                Caption = 'Mobile Status';
            }
            field(DYM_MobileDevice; Rec.DYM_MobileDevice)
            {
                ApplicationArea = All;
                Caption = 'Mobile Device';
            }
        }
    }
}
