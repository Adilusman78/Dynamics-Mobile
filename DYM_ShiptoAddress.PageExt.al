pageextension 84202 DYM_ShiptoAddress extends "Ship-to Address"
{
    layout
    {
        addlast(Control3)
        {
            field(DYM_Latitude; Rec.DYM_Latitude)
            {
                ApplicationArea = All;
            }
            field(DYM_Longitude; Rec.DYM_Longitude)
            {
                ApplicationArea = All;
            }
            field(DYM_DeliveryPersonCode; Rec.DYM_DeliveryPersonCode)
            {
                ApplicationArea = All;
                TableRelation = DYM_DeviceSetup.Code;
                Caption = 'Delivery Person Code';
            }
        }
    }
}
