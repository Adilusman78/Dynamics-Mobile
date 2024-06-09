page 84020 DYM_DAO_CR_SyncLogEntries
{
    PageType = API;
    Caption = 'DAOSyncLogEntries';
    Editable = true;
    SourceTable = DYM_SyncLog;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'crSyncLogEntry';
    EntitySetName = 'crSyncLogEntries';
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'EntryNo';
                    ApplicationArea = All;
                }
                field(direction; Rec.Direction)
                {
                    Caption = 'Direction';
                    ApplicationArea = All;
                }
                field(status; Rec.Status)
                {
                    caption = 'Status';
                    ApplicationArea = All;
                }
                field(path; Rec.Path)
                {
                    caption = 'Path';
                    ApplicationArea = All;
                }
                field(errorDescription; Rec."Error Description")
                {
                    caption = 'ErrorDescription';
                    ApplicationArea = All;
                }
                field(company; Rec.Company)
                {
                    caption = 'Company';
                    ApplicationArea = All;
                }
                field(priority; Rec.Priority)
                {
                    Caption = 'Priority';
                    ApplicationArea = All;
                }
                field(packetType; Rec."Packet Type")
                {
                    caption = 'PacketType';
                    ApplicationArea = All;
                }
                field(deviceSetupCode; Rec."Device Setup Code")
                {
                    Caption = 'DeviceSetupCode';
                    ApplicationArea = All;
                }
                field(pullType; Rec."Pull Type")
                {
                    Caption = 'PullType';
                    ApplicationArea = All;
                }
                field(entryTimeStamp; Rec."Entry TimeStamp")
                {
                    Caption = 'EntryTimeStamp';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
