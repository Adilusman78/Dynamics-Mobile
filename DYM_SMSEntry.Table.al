table 84022 DYM_SMSEntry
{
    Caption = 'SMS Entry';

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Sending Datetime"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(3; Recipient; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Message text"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Raw message text"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(6; "API response"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Return code"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Return code description"; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(101; "Post Process Log Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(102; "Sync Log Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Sync Log Entry No.", "Post Process Log Entry No.")
        {
        }
    }
    fieldgroups
    {
    }
}
