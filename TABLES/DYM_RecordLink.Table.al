table 70120 DYM_RecordLink
{
    fields
    {
        field(1; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(2; MapTableName; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(3; DMS_RowId; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(4; RecordLinkTableNo; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(5; RecordLinkRecId; Guid)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Primary; "Device Setup Code", MapTableName, DMS_RowId)
        {
            Clustered = false;
        }
    }
}
