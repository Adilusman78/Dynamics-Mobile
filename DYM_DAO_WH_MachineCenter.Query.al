query 84324 DYM_DAO_WH_MachineCenter
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whMachineCenter';
    EntitySetName = 'whMachineCenters';

    elements
    {
    dataitem(Machine_Center;
    "Machine Center")
    {
    column(no;
    "No.")
    {
    }
    column(name;
    "Name")
    {
    }
    column(workCenterNo;
    "Work Center No.")
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
    column(capacity;
    Capacity)
    {
    }
    column(efficiency;
    Efficiency)
    {
    }
    column(waitTime;
    "Wait Time")
    {
    }
    column(waitTimeUnitofMeasCode;
    "Wait Time Unit of Meas. Code")
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    column(openShopFloorBinCode;
    "Open Shop Floor Bin Code")
    {
    }
    column(fromProductionBinCode;
    "From-Production Bin Code")
    {
    }
    column(toProductionBinCode;
    "To-Production Bin Code")
    {
    }
    }
    }
}
