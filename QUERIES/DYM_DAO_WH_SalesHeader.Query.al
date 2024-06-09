query 70141 DYM_DAO_WH_SalesHeader
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_whSalesHeader';
    EntitySetName = 'backup_whSalesHeaders';

    elements
    {
        dataitem(SalesHeader;
        "Sales Header")
        {
            column(documentType;
            "Document Type")
            {
            }
            column(no;
            "No.")
            {
            }
            column(mobileStatus;
            DYM_MobileStatus)
            {
            }
            column(mobileDevice;
            DYM_MobileDevice)
            {
            }
            column(documentDate;
            "Document Date")
            {
            }
            column(dimensionSetID;
            "Dimension Set ID")
            {
            }
            column(locationCode;
            "Location Code")
            {
            }
            column(orderDate;
            "Order Date")
            {
            }
            column(postingDate;
            "Posting Date")
            {
            }
            column(salespersonCode;
            "Salesperson Code")
            {
            }
            column(selltoAddress2;
            "Sell-to Address 2")
            {
            }
            column(selltoAddress;
            "Sell-to Address")
            {
            }
            column(selltoCity;
            "Sell-to City")
            {
            }
            column(selltoContactNo;
            "Sell-to Contact No.")
            {
            }
            column(selltoContact;
            "Sell-to Contact")
            {
            }
            column(selltoCountryRegionCode;
            "Sell-to Country/Region Code")
            {
            }
            column(selltoCounty;
            "Sell-to County")
            {
            }
            column(selltoCustomerName2;
            "Sell-to Customer Name 2")
            {
            }
            column(selltoCustomerName;
            "Sell-to Customer Name")
            {
            }
            column(selltoCustomerNo;
            "Sell-to Customer No.")
            {
            }
            column(selltoCustomerTemplateCode;
            "Sell-to Customer Templ. Code")
            {
            }
            column(selltoEMail;
            "Sell-to E-Mail")
            {
            }
            column(selltoICPartnerCode;
            "Sell-to IC Partner Code")
            {
            }
            column(selltoPhoneNo;
            "Sell-to Phone No.")
            {
            }
            column(selltoPostCode;
            "Sell-to Post Code")
            {
            }
            column(shippingAgentCode;
            "Shipping Agent Code")
            {
            }
            column(shippingAgentServiceCode;
            "Shipping Agent Service Code")
            {
            }
            column(shipmentDate;
            "Shipment Date")
            {
            }
            column(shipmentMethodCode;
            "Shipment Method Code")
            {
            }
            column(shiptoAddress2;
            "Ship-to Address 2")
            {
            }
            column(shiptoAddress;
            "Ship-to Address")
            {
            }
            column(shiptoCity;
            "Ship-to City")
            {
            }
            column(shiptoCode;
            "Ship-to Code")
            {
            }
            column(shiptoContact;
            "Ship-to Contact")
            {
            }
            column(shiptoCountryRegionCode;
            "Ship-to Country/Region Code")
            {
            }
            column(shiptoCounty;
            "Ship-to County")
            {
            }
            column(shiptoName2;
            "Ship-to Name 2")
            {
            }
            column(shiptoName;
            "Ship-to Name")
            {
            }
            column(shiptoPostCode;
            "Ship-to Post Code")
            {
            }
            column(shortcutDimension1Code;
            "Shortcut Dimension 1 Code")
            {
            }
            column(shortcutDimension2Code;
            "Shortcut Dimension 2 Code")
            {
            }
            column(transportMethod;
            "Transport Method")
            {
            }
        }
    }
}
