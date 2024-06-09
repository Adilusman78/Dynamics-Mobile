query 70101 DYM_DAO_BS_Customer
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsCustomer';
    EntitySetName = 'bsCustomers';

    elements
    {
        dataitem(Cusmtomer;
        Customer)
        {
            column(no;
            "No.")
            {
            }
            column(name;
            Name)
            {
            }
            column(name2;
            "Name 2")
            {
            }
            column(address;
            Address)
            {
            }
            column(address2;
            "Address 2")
            {
            }
            column(city;
            City)
            {
            }
            column(postCode;
            "Post Code")
            {
            }
            column(phoneNo;
            "Phone No.")
            {
            }
            column(eMail;
            "E-Mail")
            {
            }
            column(customerPriceGroup;
            "Customer Price Group")
            {
            }
            column(customerDiscGroup;
            "Customer Disc. Group")
            {
            }
            column(languageCode;
            "Language Code")
            {
            }
            column(currencyCode;
            "Currency Code")
            {
            }
            column(salespersonCode;
            "Salesperson Code")
            {
            }
            column(billtoCustomerNo;
            "Bill-to Customer No.")
            {
            }
            column(shipToCode;
            "Ship-to Code")
            {
            }
        }
    }
}
