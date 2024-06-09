query 70155 DYM_DAO_WH_WorkCenter
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whWorkCenter';
    EntitySetName = 'whWorkCenters';

    elements
    {
        dataitem(Work_Center;
        "Work Center")
        {
            column(no;
            "No.")
            {
            }
            column(name;
            Name)
            {
            }
            column(workCenterGroupCode;
            "Work Center Group Code")
            {
            }
            column(unitofMeasureCode;
            "Unit of Measure Code")
            {
            }
            column(capacity;
            Capacity)
            {
            }
            column(blocked;
            Blocked)
            {
            }
            column(flushingMethod;
            "Flushing Method")
            {
            }
        }
    }
}
