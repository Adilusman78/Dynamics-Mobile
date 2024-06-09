codeunit 70153 DYM_StateManagement
{
    var
        StateVar: Record DYM_StateVariable;

    procedure GetStateVar(StateVarContext: Code[100]; StateVarCode: Code[100]) Result: Text[100]
    begin
        clear(Result);
        if StateVar.Get(StateVarContext, StateVarCode) then exit(StateVar.Value);
    end;

    procedure SetStateVar(StateVarContext: Code[100]; StateVarCode: Code[100]; StateVarValue: Text[100])
    begin
        if not StateVar.Get(StateVarContext, StateVarCode) then begin
            StateVar.Init();
            StateVar.Context := StateVarContext;
            StateVar.Code := StateVarCode;
            StateVar.Insert();
        end;
        StateVar.Value := StateVarValue;
        StateVar.Modify();
    end;
}
