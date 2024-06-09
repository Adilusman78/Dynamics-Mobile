table 70123 DYM_SessionValues
{
    Caption = 'Session Values';
    DrillDownPageID = DYM_SessionValuesList;
    LookupPageID = DYM_SessionValuesList;

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
