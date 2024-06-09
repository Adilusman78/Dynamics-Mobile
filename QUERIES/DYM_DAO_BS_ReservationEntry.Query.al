query 70112 DYM_DAO_BS_ReservationEntry
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'backup_bsReservationEntry';
    EntitySetName = 'backup_bsReservationEntries';

    elements
    {
        dataitem(ReservationEntry;
        "Reservation Entry")
        {
            column(entryNo;
            "Entry No.")
            {
            }
            column(positive;
            Positive)
            {
            }
            column(reservationStatus;
            "Reservation Status")
            {
            }
            column(sourceType;
            "Source Type")
            {
            }
            column(sourceSubtype;
            "Source Subtype")
            {
            }
            column(sourceID;
            "Source ID")
            {
            }
            column(sourceRefNo;
            "Source Ref. No.")
            {
            }
            column(sourceBatchName;
            "Source Batch Name")
            {
            }
            column(sourceProdOrderLine;
            "Source Prod. Order Line")
            {
            }
            column(itemNo;
            "Item No.")
            {
            }
            column(variantCode;
            "Variant Code")
            {
            }
            column(locationCode;
            "Location Code")
            {
            }
            column(quantity;
            Quantity)
            {
            }
            column(quantityBase;
            "Quantity (Base)")
            {
            }
            column(qtytoHandleBase;
            "Qty. to Handle (Base)")
            {
            }
            column(qtytoInvoiceBase;
            "Qty. to Invoice (Base)")
            {
            }
            column(qtyInvoicedBase;
            "Quantity Invoiced (Base)")
            {
            }
            column(serialNo;
            "Serial No.")
            {
            }
            column(lotNo;
            "Lot No.")
            {
            }
            column(expirationDate;
            "Expiration Date")
            {
            }
        }
    }
}
