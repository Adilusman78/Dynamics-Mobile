page 84204 DYM_DAO_SL_ShiptoAddress
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slShiptoAddress';
    EntitySetName = 'slShiptoAddresses';
    SourceTable = "Ship-to Address";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("code"; Rec."Code")
                {
                }
                field(customerNo; Rec."Customer No.")
                {
                }
                field(name; Rec.Name)
                {
                }
                field(name2; Rec."Name 2")
                {
                }
                field(address; Rec.Address)
                {
                }
                field(address2; Rec."Address 2")
                {
                }
                field(city; Rec.City)
                {
                }
                field(postCode; Rec."Post Code")
                {
                }
                field(phoneNo; Rec."Phone No.")
                {
                }
                field(eMail; Rec."E-Mail")
                {
                }
                field(latitude; Rec.DYM_Latitude)
                {
                }
                field(longitude; Rec.DYM_Longitude)
                {
                }
            }
        }
    }
}
