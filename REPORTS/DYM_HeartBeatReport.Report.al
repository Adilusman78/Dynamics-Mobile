report 70100 DYM_HeartBeatReport
{
    TransactionType = Browse;
    UsageCategory = History;
    DefaultLayout = RDLC;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(DYM_HeartBeat; DYM_HeartBeat)
        {
            column(Entry_No_; "Entry No.")
            {
            }
            column(Job_Queue_Entry_Id; "Job Queue Entry Id")
            {
            }
            column(Job_Queue_Entry_Description; "Job Queue Entry Description")
            {
            }
            column(Operation; Operation)
            {
            }
            column(Data; Data)
            {
            }
            column(Date_Time; "Date Time")
            {
            }
            column(Duration; Duration)
            {
            }
            column(Entry_Relation_ID; "Entry Relation ID")
            {
            }
            column(Entry_Relation_Type; "Entry Relation Type")
            {
            }
            column(Company; Company)
            {
            }
        }
    }
    procedure GetHeartBeat(var HeartBeat: Record DYM_HeartBeat)
    var
        HeartBeatMgt: Codeunit DYM_HeartBeatManagement;
    begin
        HeartBeat.Reset();
        if HeartBeat.IsTemporary then HeartBeat.DeleteAll();
        SelectLatestVersion();
        DYM_HeartBeat.Reset();
        if (DYM_HeartBeat.FindSet()) then
            repeat
                HeartBeat.Copy(DYM_HeartBeat);
                HeartBeat.Insert();
            until DYM_HeartBeat.Next() = 0;
    end;
}
