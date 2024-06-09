page 70109 DYM_DAO_CR_HeartBeatStatus
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crHeartBeatStatus';
    EntitySetName = 'crHeartBeatStatuses';
    SourceTable = DYM_HeartBeat;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(jobQueueEntryId; Rec."Job Queue Entry Id")
                {
                }
                field(sessionId; Rec."Session Id")
                {
                }
                field(entryNo; Rec."Entry No.")
                {
                }
                field(entryRelationType; Rec."Entry Relation Type")
                {
                }
                field(entryRelationId; Rec."Entry Relation Id")
                {
                }
                field(operation; Rec.Operation)
                {
                }
                field(dateTime; Rec."Date Time")
                {
                }
                field(duration; Rec.Duration)
                {
                }
                field(data; Rec.Data)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
    begin
        ClearHeartBeatBuffer(Rec);
        HeartBeatMgt.GetHeartBeat(Rec);
        Rec.Reset();
        CurrPage.SetTableView(Rec);
    end;

    procedure ClearHeartBeatBuffer(var _HeartBeatBuffer: Record DYM_HeartBeat)
    begin
        _HeartBeatBuffer.Reset();
        if _HeartBeatBuffer.IsTemporary then _HeartBeatBuffer.DeleteAll();
    end;
}
