table 70119 DYM_RawDataLog
{
    Caption = 'Raw Data Log';

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Sync Log Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "Entry Type"; enum DYM_RawDataLogEntryType)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Table Name"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Record No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Field Name"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Attribute Name"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Field Value"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Blob Value"; BLOB)
        {
            DataClassification = SystemMetadata;
        }
        field(101; "Filter Flag"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(102; "Filter Missing"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(103; Editable; Boolean)
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
        key(Key2; "Sync Log Entry No.", "Entry Type", "Table Name", "Record No.", "Field Name", "Attribute Name", "Field Value")
        {
        }
    }
    fieldgroups
    {
    }
}
