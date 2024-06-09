table 70111 DYM_HeartBeat
{
    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Job Queue Entry Id"; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Job Queue Entry Description"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(4; Data; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Date Time"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(6; Operation; enum DYM_JobQueueOperation)
        {
            DataClassification = SystemMetadata;
        }
        field(7; Duration; Duration)
        {
            DataClassification = SystemMetadata;
        }
        field(8; Company; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Entry Relation ID"; BigInteger)
        {
            DataClassification = SystemMetadata;
        }
        field(10; "Entry Relation Type"; enum DYM_EntryRelationType)
        {
            DataClassification = SystemMetadata;
        }
        field(11; "Session Id"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Primary; "Job Queue Entry Id", "Entry No.")
        {
        }
    }
}
