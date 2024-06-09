query 84322 DYM_DAO_WH_ProdOrderRouteLine
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whProdOrderRouteLine';
    EntitySetName = 'whProdOrderRouteLines';

    elements
    {
    dataitem(Prod__Order_Routing_Line;
    "Prod. Order Routing Line")
    {
    column(status;
    Status)
    {
    }
    column(prodOrderNo;
    "Prod. Order No.")
    {
    }
    column(routingNo;
    "Routing No.")
    {
    }
    column(routingReferenceNo;
    "Routing Reference No.")
    {
    }
    column(operationNo;
    "Operation No.")
    {
    }
    column(routingLinkCode;
    "Routing Link Code")
    {
    }
    column(routingStatus;
    "Routing Status")
    {
    }
    column(type;
    Type)
    {
    }
    column(no;
    "No.")
    {
    }
    column(description;
    Description)
    {
    }
    column(flushingMethod;
    "Flushing Method")
    {
    }
    column(startingDateTime;
    "Starting Date-Time")
    {
    }
    column(endingDateTime;
    "Ending Date-Time")
    {
    }
    column(setupTime;
    "Setup Time")
    {
    }
    column(setupTimeUnitofMeasCode;
    "Setup Time Unit of Meas. Code")
    {
    }
    column(runTime;
    "Run Time")
    {
    }
    column(runTimeUnitofMeasCode;
    "Run Time Unit of Meas. Code")
    {
    }
    column(moveTime;
    "Move Time")
    {
    }
    column(moveTimeUnitofMeasCode;
    "Move Time Unit of Meas. Code")
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
    }
    }
}
