page 70122 DYM_DAO_WH_SalesInvoiceLine
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whSalesInvoiceLine';
    EntitySetName = 'whSalesInvoiceLines';
    SourceTable = "Sales Invoice Line";
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
                field(selltoCustomerNo; Rec."Sell-to Customer No.")
                {
                }
                field(documentNo; Rec."Document No.")
                {
                }
                field(lineNo; Rec."Line No.")
                {
                }
                field(type; Rec.Type)
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(postingGroup; Rec."Posting Group")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(description2; Rec."Description 2")
                {
                }
                field(unitofMeasure; Rec."Unit of Measure")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(unitPrice; Rec."Unit Price")
                {
                }
                field(vatPercent; Rec."VAT %")
                {
                }
                field(lineDiscountPercent; Rec."Line Discount %")
                {
                }
                field(lineDiscountAmount; Rec."Line Discount Amount")
                {
                }
                field(amount; Rec.Amount)
                {
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                }
                field(orderNo; Rec."Order No.")
                {
                }
                field(orderLineNo; Rec."Order Line No.")
                {
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                }
                field(invDiscountAmount; Rec."Inv. Discount Amount")
                {
                }
                field(vatBaseAmount; Rec."VAT Base Amount")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(binCode; Rec."Bin Code")
                {
                }
                field(qtyPerUnitofMeasure; Rec."Qty. per Unit of Measure")
                {
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                }
                field(quantityBase; Rec."Quantity (Base)")
                {
                }
            }
        }
    }
}
