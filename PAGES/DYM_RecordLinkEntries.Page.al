page 70161 DYM_RecordLinkEntries
{
    SourceTable = DYM_RecordLink;
    Caption = 'Record Link Enties';
    UsageCategory = History;
    ApplicationArea = All;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                }
                field(DMS_RowId; Rec.DMS_RowId)
                {
                    ApplicationArea = All;
                }
                field(MapTableName; Rec.MapTableName)
                {
                    ApplicationArea = All;
                }
                field(RecordLinkTableNo; Rec.RecordLinkTableNo)
                {
                    ApplicationArea = All;
                }
                field(RecordLinkRecId; Rec.RecordLinkRecId)
                {
                    ApplicationArea = All;
                }
                field(RecordLinkPosition; RecordLinkPosition)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        RecordLinkPosition: Text;
        RecRef: RecordRef;
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;

    trigger OnAfterGetRecord()
    begin
        clear(RecordLinkPosition);
        if ((Rec.RecordLinkTableNo = 0) or (IsNullGuid(rec.RecordLinkRecId))) then exit;
        RecRef.Open(rec.RecordLinkTableNo);
        if RecRef.GetBySystemId(rec.RecordLinkRecId) then RecordLinkPosition := LowLevelDP.RecordRefPK2Text(RecRef);
        RecRef.Close();
    end;
}
