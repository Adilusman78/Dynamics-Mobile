query 84105 DYM_DAO_ItemTrackingCode
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'bsItemTrackingCode';
    EntitySetName = 'bsItemTrackingCodes';

    elements
    {
    dataitem(ItemTrackingCode;
    "Item Tracking Code")
    {
    column("code";
    Code)
    {
    }
    column(description;
    Description)
    {
    }
    column(snSpecificTracking;
    "SN Specific Tracking")
    {
    }
    column(lotSpecificTracking;
    "Lot Specific Tracking")
    {
    }
    column(useExpirationDates;
    "Use Expiration Dates")
    {
    }
    column(manExpirDateEntryReqd;
    "Man. Expir. Date Entry Reqd.")
    {
    }
    }
    }
}
