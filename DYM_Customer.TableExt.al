tableextension 84201 DYM_Customer extends Customer
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
            Caption = 'Delivery Person Code';
            TableRelation = DYM_DeviceSetup.Code;
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(84204; DYM_CustMixAndMatchGroup; Code[100])
        {
            Caption = 'Mix And Match Group';
            TableRelation = DYM_MixAndMatchGroup.Code;
            DataClassification = EndUserPseudonymousIdentifiers;
        }
    }
}
