table 84202 DYM_VisitReason
{
    Caption = 'Visit Reason';
    DrillDownPageID = DYM_VisitReasons;
    LookupPageID = DYM_VisitReasons;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; Description; Text[30])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
