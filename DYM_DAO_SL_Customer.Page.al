page 84203 DYM_DAO_SL_Customer
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slCustomer';
    EntitySetName = 'slCustomers';
    SourceTable = Customer;
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
                field(no; Rec."No.")
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
                field(countryRegionCode; Rec."Country/Region Code")
                {
                }
                field(phoneNo; Rec."Phone No.")
                {
                }
                field(eMail; Rec."E-Mail")
                {
                }
                field(customerPriceGroup; Rec."Customer Price Group")
                {
                }
                field(customerDiscGroup; Rec."Customer Disc. Group")
                {
                }
                field(languageCode; Rec."Language Code")
                {
                }
                field(currencyCode; Rec."Currency Code")
                {
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                }
                field(billtoCustomerNo; Rec."Bill-to Customer No.")
                {
                }
                field(latitude; Rec.DYM_Latitude)
                {
                }
                field(longitude; Rec.DYM_Longitude)
                {
                }
                field(mixAndMatchGroup; Rec.DYM_CustMixAndMatchGroup)
                {
                }
            }
        }
    }
}
