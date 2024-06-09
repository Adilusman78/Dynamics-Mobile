tableextension 70104 DYM_WH_ItemJournalLine extends "Item Journal Line"
{
    fields
    {
        field(84301; DYM_MobileDevice; Code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code;
            Caption = 'Mobile Device';
        }
    }
}
