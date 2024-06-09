codeunit 70144 DYM_SessionDataStoreManagement
{
    SingleInstance = true;

    procedure GetValue(_Key: Text) Result: Text
    begin
        clear(Result);
        if (KeyValueStore.ContainsKey(_Key)) then exit(KeyValueStore.Get(_Key));
    end;

    procedure SetValue(_Key: text; _Value: text)
    begin
        KeyValueStore.Set(_Key, _Value);
    end;

    procedure ClearValue(_Key: text)
    begin
        KeyValueStore.Remove(_Key);
    end;

    procedure CheckKey(_Key: text): Boolean
    begin
        exit(KeyValueStore.ContainsKey(_Key));
    end;

    procedure PopValue(_Key: text) Result: text;
    begin
        clear(Result);
        if (KeyValueStore.ContainsKey(_Key)) then begin
            KeyValueStore.Get(_Key, Result);
            KeyValueStore.Remove(_Key);
        end;
    end;

    procedure CleanUp()
    begin
        clear(KeyValueStore);
    end;

    procedure GetInteger(_Key: Text) Result: Integer
    begin
        Clear(Result);
        if (KeyValueStore.ContainsKey(_Key)) then exit(lldp.Text2Integer(GetValue(_Key)));
    end;

    procedure PopInteger(_Key: Text) Result: Integer
    begin
        clear(Result);
        if (KeyValueStore.ContainsKey(_Key)) then begin
            Result := LLDP.Text2Integer(KeyValueStore.Get(_Key));
            KeyValueStore.Remove(_Key);
        end;
    end;

    var
        KeyValueStore: Dictionary of [Text, Text];
        LLDP: Codeunit DYM_LowLevelDataProcess;
}
