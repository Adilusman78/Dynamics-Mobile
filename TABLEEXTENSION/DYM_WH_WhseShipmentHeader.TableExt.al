tableextension 70114 DYM_WH_WhseShipmentHeader extends "Warehouse Shipment Header"
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
}
