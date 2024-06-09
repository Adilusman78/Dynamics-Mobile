page 70118 DYM_DAO_WH_ItemJournalLine
{
    PageType = API;
    SourceTable = "Item Journal Line";
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whItemJournalLine';
    EntitySetName = 'whItemJournalLines';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(journalTemplateName; Rec."Journal Template Name")
                {
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                }
                field(sourceCode; Rec."Source Code")
                {
                }
                field(lineNo; Rec."Line No.")
                {
                }
                field(itemNo; Rec."Item No.")
                {
                }
                field(documentDate; Rec."Document Date")
                {
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(documentType; Rec."Document Type")
                {
                }
                field(documentNo; Rec."Document No.")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(qtyCalculated; Rec."Qty. (Calculated)")
                {
                }
                field(amount; Rec.Amount)
                {
                }
                field(qtyPhysInventory; Rec."Qty. (Phys. Inventory)")
                {
                }
                field(binCode; Rec."Bin Code")
                {
                }
                field(qtyPerUnitOfMeasure; Rec."Qty. per Unit of Measure")
                {
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                }
                field(mobileDevice; Rec.DYM_MobileDevice)
                {
                }
            }
        }
    }
}
