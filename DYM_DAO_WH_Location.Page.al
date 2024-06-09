page 84300 DYM_DAO_WH_Location
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAOWH';
    APIVersion = 'v1.0';
    EntityName = 'Location';
    EntitySetName = 'Location';
    Caption = 'DYM_DAO_WH_Location';
    SourceTable = Location;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(systemId; Rec.SystemId)
                {
                }
                field("code"; Rec.Code)
                {
                }
                field(name; Rec.Name)
                {
                }
            }
        }
    }
}
