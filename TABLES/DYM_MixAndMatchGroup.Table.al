table 70113 DYM_MixAndMatchGroup
{
    Caption = 'Visit Reason';
    DrillDownPageID = DYM_MixAndMatchGroup;
    LookupPageID = DYM_MixAndMatchGroup;

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
}
