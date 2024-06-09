tableextension 84302 DYM_WH_TransferHeader extends "Transfer Header"
{
    fields
    {
        field(84300; DYM_MobileShipStatus;enum DYM_BS_MobileStatus)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mobile Ship Status';
            AccessByPermission = TableData DYM_DeviceSetup=R;
        }
        field(84301; DYM_MobileReceiveStatus;enum DYM_BS_MobileStatus)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mobile Receive Status';
            AccessByPermission = TableData DYM_DeviceSetup=R;
        }
        field(84302; DYM_MobileDevice; code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code where("Device Role Type"=const(Warehouse));
            Caption = 'Mobile Device';
            AccessByPermission = TableData DYM_DeviceSetup=R;
        }
    }
    procedure DYM_testMobileStatus()
    begin
        if(Rec.DYM_MobileShipStatus = Rec.DYM_MobileShipStatus::"In Progress")then Rec.FieldError(DYM_MobileShipStatus);
        if(Rec.DYM_MobileReceiveStatus = Rec.DYM_MobileReceiveStatus::"In Progress")then Rec.FieldError(DYM_MobileReceiveStatus);
    end;
}
