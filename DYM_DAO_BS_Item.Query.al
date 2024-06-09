query 84101 DYM_DAO_BS_Item
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItem_backup';
    EntitySetName = 'bsItems_backup';

    elements
    {
    dataitem(Item;
    Item)
    {
    column(no;
    "No.")
    {
    }
    column(description;
    Description)
    {
    }
    column(description2;
    "Description 2")
    {
    }
    column(baseUnitofMeasure;
    "Base Unit of Measure")
    {
    }
    column(salesUnitofMeasure;
    "Sales Unit of Measure")
    {
    }
    column(purchUnitofMeasure;
    "Purch. Unit of Measure")
    {
    }
    column(itemTrackingCode;
    "Item Tracking Code")
    {
    }
    column("type";
    "Type")
    {
    }
    column(itemDiscGroup;
    "Item Disc. Group")
    {
    }
    column(itemCategoryCode;
    "Item Category Code")
    {
    }
    column(blocked;
    Blocked)
    {
    }
    column(overReceiptCode;
    "Over-Receipt Code")
    {
    }
    dataitem(ItemTrackingCodes;
    "Item Tracking Code")
    {
    SqlJoinType = LeftOuterJoin;
    DataItemLink = Code=Item."Item Tracking Code";

    column(lotSpecificTracking;
    "Lot Specific Tracking")
    {
    }
    column(snTransferTracking;
    "SN Transfer Tracking")
    {
    }
    }
    }
    }
}
