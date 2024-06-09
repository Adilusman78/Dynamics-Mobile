tableextension 70105 DYM_WH_Location extends Location
{
    fields
    {
        #region Zero Quantity Basic fields
        field(84300; DYM_ZeroSalesQtytoShip; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Sales Qty. to Ship';
        }
        field(84301; DYM_ZeroPurchQtytoReceive; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Purch. Qty. to Receive';
        }
        field(84302; DYM_ZeroTransQtytoShip; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Trans. Qty. to Ship';
        }
        field(84303; DYM_ZeroTransQtytoReceive; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Trans. Qty. to Receive';
        }
        field(84304; DYM_ZeroPhysInvJnlQtyPhys; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Phys. Inv. Jnl. Qty. Phys.';
        }
        #endregion 
        #region Zero Quantity WMS fields
        field(84320; DYM_ZeroWhseShptQtytoShip; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Whse. Shpt. Qty. to Ship';
        }
        field(84321; DYM_ZeroWhseRcptQtytoRcv; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Whse. Rcpt. Qty. to Rcv.';
        }
        field(84322; DYM_ZeroPickQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Pick Qty. to Handle';
        }
        field(84323; DYM_ZeroPutAwayQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Put-Away Qty. to Handle';
        }
        field(84324; DYM_ZeroMovementQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Movement Qty. to Handle';
        }
        field(84325; DYM_ZeroWhsePhysInvJnlQtyPhys; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Whse. Phys. Inv. Jnl. Qty. Phys.';
        }
        #endregion 
        #region Automatic Mobile Status fields
        field(84340; DYM_MobStatusWhseShipment; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mob. Status Whse. Shipment';
        }
        field(84341; DYM_MobStatusWhseReceipt; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mob. Status Whse. Receipt';
        }
        field(84342; DYM_MobStatusPick; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mob. Status Pick';
        }
        field(84343; DYM_MobStatusPutAway; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mob. Status Put-away';
        }
        field(84344; DYM_MobStatusMovement; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mob. Status Movement';
        }
        field(84345; DYM_MobStatusTransferRcpt; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Mob. Status Transfer Receipt';
        }
        #endregion 
        #region Zero Tracking Quantity fields
        field(84360; DYM_ZeroTransShipQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Trans Ship Qty. to Handle';
        }
        field(84361; DYM_ZeroTransRcvQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Trans Rcv Qty. to Handle';
        }
        field(84362; DYM_ZeroSalesTrackQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Sales Tracking Qty. to Handle';
        }
        field(84363; DYM_ZeroPurchTrackQtytoHandle; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Zero Purch. Tracking Qty. to Handle';
        }
    }
    #region Zero Quantity Basic methods
    procedure DYM_CheckZeroSalesQtytoShip(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroSalesQtytoShip);
    end;

    procedure DYM_CheckZeroPurchQtytoReceive(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroPurchQtytoReceive);
    end;

    procedure DYM_CheckZeroTransQtytoShip(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroTransQtytoShip);
    end;

    procedure DYM_CheckZeroTransQtytoReceive(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroTransQtytoReceive);
    end;

    procedure DYM_CheckPhysInvJnlQtyPhysInv(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroPhysInvJnlQtyPhys);
    end;
    #endregion 
    #region Zero Quantity WMS methods
    procedure DYM_CheckZeroWhseShipmentQtytoShip(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroWhseShptQtytoShip);
    end;

    procedure DYM_CheckZeroWhseRcptQtytoReceive(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroWhseRcptQtytoRcv);
    end;

    procedure DYM_CheckZeroPickQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroPickQtytoHandle);
    end;

    procedure DYM_CheckZeroPutAwayQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroPutAwayQtytoHandle);
    end;

    procedure DYM_CheckZeroMovementQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroMovementQtytoHandle);
    end;

    procedure DYM_CheckZeroWhseActivityQtytoHandle(_LocationCode: code[10]; _ActivityType: enum "Warehouse Activity Type") Result: Boolean
    begin
        clear(Result);
        case _ActivityType of
            _ActivityType::Pick:
                Result := DYM_CheckZeroPickQtytoHandle(_LocationCode);
            _ActivityType::"Put-away":
                Result := DYM_CheckZeroPutAwayQtytoHandle(_LocationCode);
            _ActivityType::Movement:
                Result := DYM_CheckZeroMovementQtytoHandle(_LocationCode);
        end;
    end;

    procedure DYM_CheckZeroWhsePhysInvJnlQtyPhys(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroWhsePhysInvJnlQtyPhys);
    end;
    #endregion 
    #region Automatic Mobile Status methods
    procedure DYM_AutoMobStatusWhseShipment(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_MobStatusWhseShipment);
    end;

    procedure DYM_AutoMobStatusWhseReceipt(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_MobStatusWhseReceipt);
    end;

    procedure DYM_AutoMobStatusWhsePick(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_MobStatusPick);
    end;

    procedure DYM_AutoMobStatusWhsePutAway(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_MobStatusPutaway);
    end;

    procedure DYM_AutoMobStatusWhseMovement(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_MobStatusMovement);
    end;

    procedure DYM_AutoMobStatusWhseActivity(_LocationCode: code[10]; _ActivityType: enum "Warehouse Activity Type") Result: Boolean
    begin
        clear(Result);
        case _ActivityType of
            _ActivityType::Pick:
                Result := DYM_AutoMobStatusWhsePick(_LocationCode);
            _ActivityType::"Put-away":
                Result := DYM_AutoMobStatusWhsePutAway(_LocationCode);
            _ActivityType::Movement:
                Result := DYM_AutoMobStatusWhseMovement(_LocationCode);
        end;
    end;

    procedure DYM_AutoMobStatusTransferRcpt(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_MobStatusTransferRcpt);
    end;
    #endregion 
    #region Zero Tracking Quantity methods
    procedure DYM_CheckZeroSalesTrackQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroSalesTrackQtytoHandle);
    end;

    procedure DYM_CheckZeroPurchTrackQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroPurchTrackQtytoHandle);
    end;

    procedure DYM_CheckZeroTransShipQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroTransShipQtytoHandle);
    end;

    procedure DYM_CheckZeroTransReceiveQtytoHandle(_LocationCode: code[10]): Boolean
    var
        DMLocation: Record Location;
    begin
        if not DMLocation.GET(_LocationCode) then clear(DMLocation);
        exit(DMLocation.DYM_ZeroTransRcvQtytoHandle);
    end;
    #endregion
}
