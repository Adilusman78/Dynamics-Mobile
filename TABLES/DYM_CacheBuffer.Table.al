table 70101 DYM_CacheBuffer
{
    Caption = 'Cache Buffer';
    DrillDownPageID = DYM_GenericList;
    LookupPageID = DYM_GenericList;

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Table Index"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Field No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Field Index"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Mobile Field"; Text[30])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(6; "Record ID"; Text[150])
        {
            DataClassification = SystemMetadata;
        }
        field(7; Data; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(8; Direction; enum DYM_PacketDirection)
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Table Name"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(10; Editable; Boolean)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Table No.", "Table Index", "Table Name", "Field No.", "Field Index", "Mobile Field", "Record ID", Direction)
        {
            Clustered = true;
        }
        key(Key2; "Table No.", "Table Index", "Table Name", "Record ID")
        {
        }
    }
    fieldgroups
    {
    }
}
