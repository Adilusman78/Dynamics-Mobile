query 70133 DYM_DAO_WH_OverReceiptCode
{
    QueryType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whOverReceiptCode';
    EntitySetName = 'whOverReceiptCodes';

    elements
    {
        dataitem(OverReceiptCode;
        "Over-Receipt Code")
        {
            column("code";
            "Code")
            {
            }
            column(default;
            Default)
            {
            }
            column(description;
            Description)
            {
            }
            column(overReceiptTolerance;
            "Over-Receipt Tolerance %")
            {
            }
            column(requiredApproval;
            "Required Approval")
            {
            }
        }
    }
}
