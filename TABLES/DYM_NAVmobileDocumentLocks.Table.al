table 70117 DYM_NAVmobileDocumentLocks
{
    Caption = 'NAVmobile Document Locks';
    ObsoleteState = Pending;
    ObsoleteReason = 'Document locks are handled through LiveLink. Not needed any more';

    fields
    {
        field(1; documentNo; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(2; documentType; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(3; lineNo; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(4; userName; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(5; dateCreated; DateTime)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; documentNo, documentType, lineNo)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
