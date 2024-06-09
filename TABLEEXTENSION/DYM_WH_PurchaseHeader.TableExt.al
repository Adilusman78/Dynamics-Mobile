tableextension 70106 DYM_WH_PurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(84300; DYM_MobileStatus; enum DYM_BS_MobileStatus)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mobile Status';
        }
        field(84301; DYM_MobileDevice; code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code where("Device Role Type" = const(Warehouse));
            Caption = 'Mobile Device';
        }
    }
    procedure DYM_testMobileStatus()
    begin
        if (Rec.DYM_MobileStatus = Rec.DYM_MobileStatus::"In Progress") then Rec.FieldError(DYM_MobileStatus);
    end;
}
