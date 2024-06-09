page 70113 DYM_DAO_SL_CustLedgerEntry
{
    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'slCustLedgerEntry';
    EntitySetName = 'slCustLedgerEntries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(documentType; Rec."Entry No.")
                {
                }
                field(documentNo; Rec."User ID")
                {
                }
                field("type"; Rec."Source Code")
                {
                }
                field(no; Rec.Open)
                {
                }
                field(variantCode; Rec."Due Date")
                {
                }
                field(locationCode; Rec."Document Date")
                {
                }
                field(binCode; Rec."External Document No.")
                {
                }
                field(unitofMeasureCode; Rec."Customer No.")
                {
                }
                field(unitofMeasure; Rec."Posting Date")
                {
                }
                field(qtyperUnitofMeasure; Rec."Document Type")
                {
                }
                field(quantity; Rec."Document No.")
                {
                }
                field(quantityBase; Rec.Description)
                {
                }
                field(qtytoShip; Rec."Customer Name")
                {
                }
                field(qtytoShipBase; Rec."Currency Code")
                {
                }
                field(quantityShipped; Rec.Amount)
                {
                }
                field(qtyShippedBase; Rec."Remaining Amount")
                {
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                }
            }
        }
    }
}
