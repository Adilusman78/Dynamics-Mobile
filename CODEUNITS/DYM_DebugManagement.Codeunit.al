codeunit 70113 DYM_DebugManagement
{
    var
        MobileSetup: Record DYM_DynamicsMobileSetup;
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        CacheMgt: Codeunit DYM_CacheManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        SetupRead: Boolean;
        SLE: Integer;
        LastError_DataPattern: Label '[%1]\[%2]\[%3]', Locked = true;
        CallStackPushError: Label 'DEBUG_CALL_STACK_PUSH', Locked = true;

    procedure isLevelActive_Trace(): Boolean
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        exit((MobileSetup."Debug Level" in [MobileSetup."Debug Level"::Trace]));
    end;

    procedure isLevelActive_Debug(): Boolean
    begin
        CacheMgt.GetSetup(MobileSetup, DeviceRole, DeviceGroup, DeviceSetup, SLE, SetupRead);
        exit((MobileSetup."Debug Level" in [MobileSetup."Debug Level"::Trace, MobileSetup."Debug Level"::Debug]));
    end;

    procedure GetLastErrorData(): Text
    begin
        Exit(STRSUBSTNO(LastError_DataPattern, GETLASTERRORCODE, GETLASTERRORTEXT, GETLASTERRORCALLSTACK));
    end;

    procedure PushCallStack()
    begin
        if not isLevelActive_Debug() then exit;
        if RaiseError() then;
    end;

    procedure GetCallStackObject(): Text
    var
        CallStackObject, CallStackMethod : Text;
    begin
        GetCallStackCallerProps(CallStackObject, CallStackMethod);
        exit(CallStackObject);
    end;

    procedure GetCallStackMethod(): Text
    var
        CallStackObject, CallStackMethod : Text;
    begin
        GetCallStackCallerProps(CallStackObject, CallStackMethod);
        exit(CallStackMethod);
    end;

    local procedure GetCallStackCallerProps(var _CallerObject: Text; var _CallerMethod: Text)
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        LastErrorCallStack, CallerLine : Text;
        CallStackLines, LineElements, LineSubElements : List of [Text];
    begin
        Clear(_CallerObject);
        Clear(_CallerMethod);
        LastErrorCallStack := GetLastErrorCallStack;
        CallStackLines := LastErrorCallStack.Split(ConstMgt.DBG_CallStackCache_LineDelimiter());
        If (CallStackLines.Count >= ConstMgt.DBG_CallStackCache_PopLevel()) then CallerLine := CallStackLines.Get(ConstMgt.DBG_CallStackCache_PopLevel());
        LineElements := CallerLine.Split(ConstMgt.DBG_CallStackCache_LineElementsDelimiter());
        if (LineElements.Count > ConstMgt.DBG_CallStackCache_CallerObjectPos()) then begin
            _CallerObject := LineElements.Get(ConstMgt.DBG_CallStackCache_CallerObjectPos());
            LineSubElements := LineElements.Get(ConstMgt.DBG_CallStackCache_CallerObjectPos() + 1).Split(ConstMgt.DBG_CallStackCache_LineSubElementsDelimiter());
            if (LineSubElements.Count >= ConstMgt.DBG_CallStackCache_CallerMethodPos()) then _CallerMethod := LineSubElements.Get(ConstMgt.DBG_CallStackCache_CallerMethodPos());
        end;
    end;

    [TryFunction]
    procedure RaiseError()
    begin
        error(CallStackPushError);
    end;
}
