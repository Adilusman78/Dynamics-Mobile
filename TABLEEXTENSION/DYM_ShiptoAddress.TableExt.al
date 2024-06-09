tableextension 70103 DYM_ShiptoAddress extends "Ship-to Address"
{
    fields
    {
        field(84201; DYM_Latitude; Text[30])
        {
            Caption = 'Latitude';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(84202; DYM_Longitude; Text[30])
        {
            Caption = 'Longitude';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(84203; DYM_DeliveryPersonCode; Code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code;
            Caption = 'Delivery Person Code';
        }
    }
}
