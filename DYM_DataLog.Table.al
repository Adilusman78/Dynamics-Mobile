table 84015 DYM_DataLog
{
    Caption = 'Data Log';
    DrillDownPageID = DYM_DataLogEntries;
    LookupPageID = DYM_DataLogEntries;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Entry Type";enum DYM_DataLogEntryType)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Sync Log Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(6; Position; Text[250])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Sync Log Entry No.", "Table No.", Position)
        {
        }
        key(Key3; Position)
        {
        }
    }
    fieldgroups
    {
    }
}
