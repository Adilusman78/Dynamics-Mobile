page 70124 DYM_DAO_WH_WhseActivityHeader
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whWhseActivityHeader';
    EntitySetName = 'whWhseActivityHeaders';
    Caption = 'DYM_DAO_WH_WhseActivityHeader';
    SourceTable = "Warehouse Activity Header";
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
                field("type"; Rec.Type)
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
                field(locationCode; Rec."Location Code")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(sourceType; Rec."Source Type")
                {
                }
                field(sourceSubtype; Rec."Source Subtype")
                {
                }
                field(sourceNo; Rec."Source No.")
                {
                }
                field(sourceDocument; Rec."Source Document")
                {
                }
                field(destinationType; Rec."Destination Type")
                {
                }
                field(destinationNo; Rec."Destination No.")
                {
                }
            }
        }
    }
}
