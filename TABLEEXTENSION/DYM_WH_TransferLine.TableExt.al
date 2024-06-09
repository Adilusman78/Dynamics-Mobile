tableextension 70111 DYM_WH_TransferLine extends "Transfer Line"
{
    fields
    {
    }
    var
        TransferHeader: Record "Transfer Header";

    local procedure DYM_GetTransferHeader()
    begin
        if (Rec."Document No." <> TransferHeader."No.") then if not TransferHeader.Get(Rec."Document No.") then clear(TransferHeader);
    end;

    procedure DYM_testMobileStatus()
    begin
        DYM_GetTransferHeader();
        if (TransferHeader.DYM_MobileShipStatus = TransferHeader.DYM_MobileShipStatus::"In Progress") then TransferHeader.FieldError(DYM_MobileShipStatus);
        if (TransferHeader.DYM_MobileReceiveStatus = TransferHeader.DYM_MobileReceiveStatus::"In Progress") then TransferHeader.FieldError(DYM_MobileReceiveStatus);
    end;
}
