page 84061 DYM_RevNavDeviceSetupSubPage
{
    Caption = 'Rev. Nav. Device Setup SubPage';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = DYM_DeviceSetup;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;

                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                }
                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Mobile Location"; Rec."Mobile Location")
                {
                    ApplicationArea = All;
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    procedure Refresh()
    begin
        CurrPage.Update(false);
    end;
    procedure TransferSyncLogBuffer(var DeviceSetupBuffer: Record DYM_DeviceSetup)
    var
        DataLog: Record DYM_DataLog;
        SyncLog: Record DYM_SyncLog;
    begin
        Rec.Reset;
        Rec.DeleteAll;
        DeviceSetupBuffer.Reset;
        if DeviceSetupBuffer.FindSet(false, false)then repeat Rec.Init;
                Rec.TransferFields(DeviceSetupBuffer, true);
                Rec.Insert;
            until DeviceSetupBuffer.Next = 0;
    end;
}
