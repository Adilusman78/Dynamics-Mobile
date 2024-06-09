codeunit 70161 DYM_WH_ConstManagement
{
    //EDE - Event Data Exchange
    procedure EDE_WhseReceiptLine_LocationCode(): Text
    begin
        exit(TC_EDE_WhseReceiptLine_LocationCode);
    end;

    procedure EDE_CreatePick_LocationCode(): Text
    begin
        exit(TC_EDE_CreatePick_LocationCode);
    end;

    procedure EDE_CreatePick_ActivityType(): Text
    begin
        exit(TC_EDE_CreatePick_ActivityType);
    end;

    procedure EDE_CreatePick_ActivityType_Pick(): Text
    begin
        exit(TC_EDE_CreatePick_ActivityType_Pick);
    end;

    procedure EDE_CreatePick_ActivityType_Movement(): Text
    begin
        exit(TC_EDE_CreatePick_ActivityType_Movement);
    end;

    var
        TC_EDE_WhseReceiptLine_LocationCode: Label 'WhseReceiptLine_LocationCode', Locked = true;
        TC_EDE_CreatePick_LocationCode: Label 'CreatePick_LocationCode', Locked = true;
        TC_EDE_CreatePick_ActivityType: Label 'CreatePick_ActivityType', Locked = true;
        TC_EDE_CreatePick_ActivityType_Pick: Label 'Pick', Locked = true;
        TC_EDE_CreatePick_ActivityType_Movement: Label 'Movement', Locked = true;
}
