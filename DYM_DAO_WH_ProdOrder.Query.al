query 84319 DYM_DAO_WH_ProdOrder
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whProdOrder';
    EntitySetName = 'whProdOrders';

    elements
    {
    dataitem(ProductionOrder;
    "Production Order")
    {
    column(status;
    Status)
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
    column(description2;
    "Description 2")
    {
    }
    column(searchDescription;
    "Search Description")
    {
    }
    column(sourceType;
    "Source Type")
    {
    }
    column(sourceNo_;
    "Source No.")
    {
    }
    column(quantity;
    Quantity)
    {
    }
    column(dueDate;
    "Due Date")
    {
    }
    column(startingDate;
    "Starting Date")
    {
    }
    column(endingDate;
    "Ending Date")
    {
    }
    column(locationCode;
    "Location Code")
    {
    }
    column(binCode;
    "Bin Code")
    {
    }
    }
    }
}
