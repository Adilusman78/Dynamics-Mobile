tableextension 84310 DYM_WH_PurchaseLine extends "Purchase Line"
{
    fields
    {
    }
    var PurchaseHeader: Record "Purchase Header";
    local procedure DYM_GetPurchaseHeader()
    begin
        if((Rec."Document Type" <> PurchaseHeader."Document Type") or (Rec."Document No." <> PurchaseHeader."No."))then if not PurchaseHeader.Get(Rec."Document Type", Rec."Document No.")then clear(PurchaseHeader);
    end;
    procedure DYM_testMobileStatus()
    begin
        DYM_GetPurchaseHeader();
        if(PurchaseHeader.DYM_MobileStatus = PurchaseHeader.DYM_MobileStatus::"In Progress")then PurchaseHeader.FieldError(DYM_MobileStatus);
    end;
}
