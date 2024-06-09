table 84008 DYM_EventLog
{
    Caption = 'Event Log';
    DataPerCompany = false;
    DrillDownPageID = DYM_EventLogEntries;
    LookupPageID = DYM_EventLogEntries;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "Event Type";enum DYM_EventLogEventType)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "Source Type";enum DYM_EventLogSourceType)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5; Checked; Boolean)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6; "Source Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(7; Company; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(101; Message; Text[250])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(102; Data; Blob)
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
        key(Key2; "Event Type", "Source Type", Checked)
        {
        }
        key(Key3; "Source Entry No.")
        {
        }
    }
    fieldgroups
    {
    }
}
