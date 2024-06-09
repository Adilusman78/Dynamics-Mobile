codeunit 70123 DYM_GenericListManagement
{
    trigger OnRun()
    begin
    end;

    var
        List: Record DYM_CacheBuffer temporary;
        Text001: Label 'Do you want to delete currently selected value?';

    procedure InitList()
    begin
        List.Reset;
        List.DeleteAll;
    end;

    procedure AddListEntry("Key": Integer; Value: Text)
    begin
        List.Init;
        List."Table No." := Key;
        List.Data := Value;
        List.Insert;
    end;

    procedure LookUpListByKey(var "Key": Integer)
    var
        SelectedKey: Integer;
    begin
        Clear(SelectedKey);
        List.Reset;
        if not List.FindFirst then Clear(List);
        if PAGE.RunModal(0, List) = ACTION::LookupOK then SelectedKey := List."Table No.";
        if (SelectedKey <> 0) then
            Key := SelectedKey
        else if (Key <> 0) then if Confirm(Text001, false) then Clear(Key);
    end;

    procedure LookUpListByValue(var Value: Text)
    var
        SelectedValue: Text;
    begin
        Clear(SelectedValue);
        List.Reset;
        if not List.FindFirst then Clear(List);
        if PAGE.RunModal(0, List) = ACTION::LookupOK then SelectedValue := List.Data;
        if (SelectedValue <> '') then
            Value := SelectedValue
        else if (Value <> '') then if Confirm(Text001, false) then Clear(Value);
    end;
}
