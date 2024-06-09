tableextension 84300 DYM_WH_SalesHeader extends "Sales Header"
{
    fields
    {
        //Sales
        field(84200; DYM_Signature; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        //Warehouse
        field(84300; DYM_MobileStatus;enum DYM_BS_MobileStatus)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mobile Status';
            AccessByPermission = TableData DYM_DeviceSetup=R;
        }
        field(84301; DYM_MobileDevice; Code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code where("Device Role Type"=const(Warehouse));
            Caption = 'Mobile Device';
            AccessByPermission = TableData DYM_DeviceSetup=R;
        }
        field(84302; DYM_DeliveryPersonCode; Code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code where("Device Role Type"=const(Sales));
            Caption = 'Delivery Person Code';
        }
        field(84303; DYM_DeliveryStatus;Enum DYM_DeliveryStatus)
        {
            DataClassification = SystemMetadata;
            Caption = 'Delivery Status';
        }
        field(84304; DYM_DiscountPercentFromDeal; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Discount Percent From Deal';
        }
        field(84305; DYM_DiscountAmountFromDeal; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Discount Amount From Deal';
        }
        field(84306; DYM_TotalAmountDealCode; Code[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Total Amount Deal Code';
        }
        field(84307; DYM_TotalAmountGroupCode; Code[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Total Amount Group Code';
        }
    }
    procedure DYM_testMobileStatus()
    begin
        if(Rec.DYM_MobileStatus = Rec.DYM_MobileStatus::"In Progress")then Rec.FieldError(DYM_MobileStatus);
    end;
}
