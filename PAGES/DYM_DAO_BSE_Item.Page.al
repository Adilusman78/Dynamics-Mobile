page 70106 DYM_DAO_BSE_Item
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItem';
    EntitySetName = 'bsItems';
    SourceTable = Item;
    Editable = false;
    InsertAllowed = false;
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
                field(description; Rec.Description)
                {
                }
                field(description2; Rec."Description 2")
                {
                }
                field(baseUnitofMeasure; Rec."Base Unit of Measure")
                {
                }
                field(salesUnitofMeasure; Rec."Sales Unit of Measure")
                {
                }
                field(purchUnitofMeasure; Rec."Purch. Unit of Measure")
                {
                }
                field(itemTrackingCode; Rec."Item Tracking Code")
                {
                }
                field("type"; Rec."Type")
                {
                }
                field(itemDiscGroup; Rec."Item Disc. Group")
                {
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                }
                field(blocked; Rec.Blocked)
                {
                }
                field(overReceiptCode; Rec."Over-Receipt Code")
                {
                }
                field(lotSpecificTracking; lotSpecificTracking)
                {
                }
                field(snSpecificTracking; snSpecificTracking)
                {
                }
                field(hasItemVariants; hasItemVariants)
                {
                }
            }
        }
    }
    var
        ItemTrackingCode: Record "Item Tracking Code";
        ItemVariant: Record "Item Variant";
        lotSpecificTracking: Boolean;
        snSpecificTracking: Boolean;
        hasItemVariants: Boolean;

    trigger OnAfterGetRecord()
    begin
        clear(lotSpecificTracking);
        clear(snSpecificTracking);
        clear(hasItemVariants);
        clear(ItemTrackingCode);
        if (Rec."Item Tracking Code" <> '') then if not ItemTrackingCode.Get(Rec."Item Tracking Code") then clear(ItemTrackingCode);
        lotSpecificTracking := ItemTrackingCode."Lot Specific Tracking";
        snSpecificTracking := ItemTrackingCode."SN Specific Tracking";
        ItemVariant.Reset();
        ItemVariant.SetRange("Item No.", Rec."No.");
        hasItemVariants := not ItemVariant.IsEmpty;
    end;
}
