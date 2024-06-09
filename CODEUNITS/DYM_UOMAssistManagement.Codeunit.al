codeunit 70159 DYM_UOMAssistManagement
{
    procedure CalcQtyUM2UM(ItemNo: Code[20]; Qty: Decimal; OldUM: Code[10]; NewUM: Code[10]): Decimal var
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        QtyPerUMOld: Decimal;
        QtyPerUMNew: Decimal;
    begin
        Item.Get(ItemNo);
        QtyPerUMOld:=UOMMgt.GetQtyPerUnitOfMeasure(Item, OldUM);
        QtyPerUMNew:=UOMMgt.GetQtyPerUnitOfMeasure(Item, NewUM);
        if QtyPerUMNew <> 0 then exit(Qty * QtyPerUMOld / QtyPerUMNew)
        else
            exit(0);
    end;
}
