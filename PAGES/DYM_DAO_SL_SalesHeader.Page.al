page 70115 DYM_DAO_SL_SalesHeader
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slSalesHeader';
    EntitySetName = 'slSalesHeaders';
    SourceTable = "Sales Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(sellToCustomerName; Rec."Sell-to Customer Name")
                {
                }
                field(comment; Rec.Comment)
                {
                }
                field(dimensionSetID; Rec."Dimension Set ID")
                {
                }
                field(dymDeliveryPersonCode; Rec.DYM_DeliveryPersonCode)
                {
                }
                field(dymDeliveryStatus; Rec.DYM_DeliveryStatus)
                {
                }
                field(documentDate; Rec."Document Date")
                {
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                }
                field(documentType; Rec."Document Type")
                {
                }
                field(no; Rec."No.")
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
                //field(sellToAddress; Rec."Sell-to Address") { }
                //field(sellToAddress2; Rec."Sell-to Address 2") { }
                //field(sellToCity; Rec."Sell-to City") { }
                //field(sellToContact; Rec."Sell-to Contact") { }
                //field(sellToCountryRegionCode; Rec."Sell-to Country/Region Code") { }
                //field(sellToCounty; Rec."Sell-to County") { }
                //field(sellToCustomerName; Rec."Sell-to Customer Name") { }
                //field(sellToCustomerName2; Rec."Sell-to Customer Name 2") { }
                //field(sellToPostCode; Rec."Sell-to Post Code") { }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                }
                field(sellToContactNo; Rec."Sell-to Contact No.")
                {
                }
                field(sellToEMail; Rec."Sell-to E-Mail")
                {
                }
                field(sellToPhoneNo; Rec."Sell-to Phone No.")
                {
                }
                field(shipToCode; Rec."Ship-to Code")
                {
                }
                //field(shipToAddress; Rec."Ship-to Address") { }
                //field(shipToAddress2; Rec."Ship-to Address 2") { }
                //field(shipToCity; Rec."Ship-to City") { }
                //field(shipToContact; Rec."Ship-to Contact") { }
                //field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code") { }
                //field(shipToCounty; Rec."Ship-to County") { }
                //field(shipToName; Rec."Ship-to Name") { }
                //field(shipToName2; Rec."Ship-to Name 2") { }
                //field(shipToPostCode; Rec."Ship-to Post Code") { }
                field(shipmentDate; Rec."Shipment Date")
                {
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                }
                field(status; Rec.Status)
                {
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                }
                field(systemId; Rec.SystemId)
                {
                }
                field(transportMethod; Rec."Transport Method")
                {
                }
                field(visitAddress; Visit_Address)
                {
                }
                field(visitAddress2; Visit_Address2)
                {
                }
                field(visitCity; Visit_City)
                {
                }
                field(visitContact; Visit_Contact)
                {
                }
                field(visitCountryRegionCode; Visit_CountryRegionCode)
                {
                }
                field(visitCounty; Visit_County)
                {
                }
                field(visitName; Visit_Name)
                {
                }
                field(visitName2; Visit_Name2)
                {
                }
                field(visitPostCode; Visit_PostCode)
                {
                }
                field(visitLatitude; Visit_Latitude)
                {
                }
                field(visitLongitude; Visit_Longitude)
                {
                }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                }
                field(promisedDeliveryDate; Rec."Promised Delivery Date")
                {
                }
                field(DYM_DiscountAmountFromDeal; Rec.DYM_DiscountAmountFromDeal)
                {
                }
                field(DYM_DiscountPercentFromDeal; Rec.DYM_DiscountPercentFromDeal)
                {
                }
                field(DYM_TotalAmountDealCode; Rec.DYM_TotalAmountDealCode)
                {
                }
                field(DYM_TotalAmountGroupCode; Rec.DYM_TotalAmountGroupCode)
                {
                }
            }
        }
    }
    var
        Visit_Address: Text[100];
        Visit_Address2: Text[50];
        Visit_City: Text[30];
        Visit_Contact: Text[100];
        Visit_CountryRegionCode: Code[10];
        Visit_County: Text[30];
        Visit_Name: Text[100];
        Visit_Name2: Text[50];
        Visit_PostCode: Code[20];
        Visit_Latitude, Visit_Longitude : Text[30];
    trigger OnAfterGetRecord()
    begin
        CollectVisitData;
    end;

    procedure CollectVisitData()
    var
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
    begin
        Clear(Visit_Address);
        Clear(Visit_Address2);
        Clear(Visit_City);
        Clear(Visit_Contact);
        Clear(Visit_CountryRegionCode);
        Clear(Visit_County);
        Clear(Visit_Name);
        Clear(Visit_Name2);
        Clear(Visit_PostCode);
        Clear(Visit_Latitude);
        Clear(Visit_Longitude);
        if not Customer.Get(Rec."Sell-to Customer No.") then clear(Customer);
        If (Rec."Ship-to Code" <> '') then begin
            if not ShiptoAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code") then clear(ShiptoAddress);
            Visit_Address := shiptoAddress.Address;
            Visit_Address2 := shiptoAddress."Address 2";
            Visit_City := shiptoAddress.City;
            Visit_Contact := shiptoAddress.Contact;
            Visit_CountryRegionCode := ShiptoAddress."Country/Region Code";
            Visit_County := ShiptoAddress.County;
            Visit_Name := ShiptoAddress.Name;
            Visit_Name2 := ShiptoAddress."Name 2";
            Visit_PostCode := ShiptoAddress."Post Code";
            Visit_Latitude := ShiptoAddress.DYM_Latitude;
            Visit_Longitude := ShiptoAddress.DYM_Longitude;
        end
        else begin
            Visit_Address := Customer.Address;
            Visit_Address2 := Customer."Address 2";
            Visit_City := Customer.City;
            Visit_Contact := Customer.Contact;
            Visit_CountryRegionCode := Customer."Country/Region Code";
            Visit_County := Customer.County;
            Visit_Name := Customer.Name;
            Visit_Name2 := Customer."Name 2";
            Visit_PostCode := Customer."Post Code";
            Visit_Latitude := Customer.DYM_Latitude;
            Visit_Longitude := Customer.DYM_Longitude;
        end;
    end;
}
