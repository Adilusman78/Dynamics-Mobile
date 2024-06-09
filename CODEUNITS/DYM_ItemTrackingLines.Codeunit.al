codeunit 70128 DYM_ItemTrackingLines
{
    var
        Text001: Label 'Dynamics Mobile Advanced Tracking is not implemented.';

    procedure SetSource(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date)
    var
        IsHandled: Boolean;
    begin
        clear(IsHandled);
        OnSetSource(TrackingSpecification, AvailabilityDate, IsHandled);
        if not IsHandled then Error(Text001);
    end;

    procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification") OK: Boolean
    var
        IsHandled: Boolean;
    begin
        clear(IsHandled);
        OnSetQtyToHandleAndInvoice(TrackingSpecification, IsHandled);
        if not IsHandled then Error(Text001);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetSource(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date; var IsHandled: Boolean)
    begin
    end;
}
