codeunit 84202 DYM_SL_EventSubscribers
{
    [EventSubscriber(ObjectType::Table, DATABASE::"Return Reason", 'OnAfterValidateEvent', 'Default Location Code', true, true)]
    local procedure ReturnReason_OnAfterValidate_DefaultLocationCode(VAR Rec: Record "Return Reason"; VAR xRec: Record "Return Reason")
    begin
        if(Rec."Default Location Code" <> '')then Rec.TestField(DYM_ReturnReasonType, Rec.DYM_ReturnReasonType::None);
    end;
    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnAfterSelltoCustomerNoOnAfterValidate', '', true, true)]
    local procedure T_36_OnAfterSelltoCustomerNoOnAfterValidate(var SalesHeader: Record "Sales Header"; var xSalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        Customer.Get(SalesHeader."Sell-to Customer No.");
        if(Customer.DYM_DeliveryPersonCode <> '')then begin
            SalesHeader.DYM_DeliveryPersonCode:=Customer.DYM_DeliveryPersonCode;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Ship-to Code', true, true)]
    local procedure T36_F12_OnAfterValidateEvent(VAR Rec: Record "Sales Header"; VAR xRec: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
        ShipToAddress: Record "Ship-to Address";
    begin
        if(ShipToAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code"))then begin
            Rec.Validate(DYM_DeliveryPersonCode, ShipToAddress.DYM_DeliveryPersonCode);
            if(SalesHeader.Get(Rec."Document Type", Rec."No."))then Rec.Modify();
        end;
    end;
}
