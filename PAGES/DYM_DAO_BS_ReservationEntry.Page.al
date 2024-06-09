page 70104 DYM_DAO_BS_ReservationEntry
{
    PageType = API;
    SourceTable = "Reservation Entry";
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsReservationEntry';
    EntitySetName = 'bsReservationEntries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(entryNo; Rec."Entry No.")
                {
                }
                field(positive; Rec.Positive)
                {
                }
                field(reservationStatus; Rec."Reservation Status")
                {
                }
                field(sourceType; Rec."Source Type")
                {
                }
                field(sourceSubtype; Rec."Source Subtype")
                {
                }
                field(sourceID; Rec."Source ID")
                {
                }
                field(sourceRefNo; Rec."Source Ref. No.")
                {
                }
                field(sourceBatchName; Rec."Source Batch Name")
                {
                }
                field(sourceProdOrderLine; Rec."Source Prod. Order Line")
                {
                }
                field(itemNo; Rec."Item No.")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(quantityBase; Rec."Quantity (Base)")
                {
                }
                field(qtytoHandleBase; Rec."Qty. to Handle (Base)")
                {
                }
                field(qtytoInvoiceBase; Rec."Qty. to Invoice (Base)")
                {
                }
                field(qtyInvoicedBase; Rec."Quantity Invoiced (Base)")
                {
                }
                field(serialNo; Rec."Serial No.")
                {
                }
                field(lotNo; Rec."Lot No.")
                {
                }
                field(expirationDate; LowLevelDP.ODDate2Text(ExpirationDate))
                {
                }
                field(itemBaseUOM; Item."Base Unit of Measure")
                {
                }
            }
        }
    }
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        Item: Record Item;
        ExpirationDate: date;

    trigger OnAfterGetRecord()
    begin
        CalcExpirationDate();
        if (Rec."Item No." <> Item."No.") then if not Item.get(Rec."Item No.") then clear(Item);
    end;

    procedure CalcExpirationDate()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        clear(ExpirationDate);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        ItemLedgerEntry.SetRange("Variant Code", Rec."Variant Code");
        ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");
        ItemLedgerEntry.SetRange(Positive, true);
        if ItemLedgerEntry.FindFirst() then ExpirationDate := ItemLedgerEntry."Expiration Date";
    end;
}
