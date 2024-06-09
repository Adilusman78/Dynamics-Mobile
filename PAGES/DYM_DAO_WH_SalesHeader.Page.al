page 70121 DYM_DAO_WH_SalesHeader
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whSalesHeader';
    EntitySetName = 'whSalesHeaders';
    Caption = 'DYM_DAO_WH_SalesHeader';
    SourceTable = "Sales Header";
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
                field(documentType; Rec."Document Type")
                {
                }
                field(no; Rec."No.")
                {
                }
                field(mobileStatus; Rec.DYM_MobileStatus)
                {
                }
                field(mobileDevice; Rec.DYM_MobileDevice)
                {
                }
                field(documentDate; Rec."Document Date")
                {
                }
                field(dimensionSetID; Rec."Dimension Set ID")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(orderDate; Rec."Order Date")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                }
                field(selltoAddress2; Rec."Sell-to Address 2")
                {
                }
                field(selltoAddress; Rec."Sell-to Address")
                {
                }
                field(selltoCity; Rec."Sell-to City")
                {
                }
                field(selltoContactNo; Rec."Sell-to Contact No.")
                {
                }
                field(selltoContact; Rec."Sell-to Contact")
                {
                }
                field(selltoCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                }
                field(selltoCounty; Rec."Sell-to County")
                {
                }
                field(selltoCustomerName2; Rec."Sell-to Customer Name 2")
                {
                }
                field(selltoCustomerName; Rec."Sell-to Customer Name")
                {
                }
                field(selltoCustomerNo; Rec."Sell-to Customer No.")
                {
                }
                field(selltoCustomerTemplateCode; Rec."Sell-to Customer Templ. Code")
                {
                }
                field(selltoEMail; Rec."Sell-to E-Mail")
                {
                }
                field(selltoICPartnerCode; Rec."Sell-to IC Partner Code")
                {
                }
                field(selltoPhoneNo; Rec."Sell-to Phone No.")
                {
                }
                field(selltoPostCode; Rec."Sell-to Post Code")
                {
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                }
                field(shiptoAddress2; Rec."Ship-to Address 2")
                {
                }
                field(shiptoAddress; Rec."Ship-to Address")
                {
                }
                field(shiptoCity; Rec."Ship-to City")
                {
                }
                field(shiptoCode; Rec."Ship-to Code")
                {
                }
                field(shiptoContact; Rec."Ship-to Contact")
                {
                }
                field(shiptoCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                }
                field(shiptoCounty; Rec."Ship-to County")
                {
                }
                field(shiptoName2; Rec."Ship-to Name 2")
                {
                }
                field(shiptoName; Rec."Ship-to Name")
                {
                }
                field(shiptoPostCode; Rec."Ship-to Post Code")
                {
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                }
                field(transportMethod; Rec."Transport Method")
                {
                }
            }
        }
    }
}
