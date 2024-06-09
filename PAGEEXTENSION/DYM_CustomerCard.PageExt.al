pageextension 84201 DYM_CustomerCard extends "Customer Card"
{
    layout
    {
        addlast("Address & Contact")
        {
            field(DYM_Latitude; Rec.DYM_Latitude)
            {
                ApplicationArea = All;
            }
            field(DYM_Longitude; Rec.DYM_Longitude)
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field(DYM_DeliveryPersonCode; Rec.DYM_DeliveryPersonCode)
            {
                ApplicationArea = All;
            }
            field(DYM_CustMixAndMatchGroup; Rec.DYM_CustMixAndMatchGroup)
            {
                ApplicationArea = All;
            }
        }
    }
    var DeliverPersonCode: Text[100];
}
