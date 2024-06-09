codeunit 70104 DYM_Bitwise
{
    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        byteHexText: Label '0123456789ABCDEF', Locked = true;
    #region Overloads
    procedure bitAnd8(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitAnd(Operand1, Operand2, 8));
    end;

    procedure bitAnd16(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitAnd(Operand1, Operand2, 16));
    end;

    procedure bitOr8(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitOr(Operand1, Operand2, 8));
    end;

    procedure bitOr16(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitOr(Operand1, Operand2, 16));
    end;

    procedure bitXor8(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitXor(Operand1, Operand2, 8));
    end;

    procedure bitXor16(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitXor(Operand1, Operand2, 16));
    end;

    procedure bitNot8(Operand: Integer) Result: Integer
    begin
        exit(bitNot(Operand, 8));
    end;

    procedure bitNot16(Operand: Integer) Result: Integer
    begin
        exit(bitNot(Operand, 16));
    end;

    procedure bitShl8(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitShl(Operand1, Operand2, 8));
    end;

    procedure bitShl16(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitShl(Operand1, Operand2, 16));
    end;

    procedure bitShr8(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitShr(Operand1, Operand2, 8));
    end;

    procedure bitShr16(Operand1: Integer; Operand2: Integer) Result: Integer
    begin
        exit(bitShr(Operand1, Operand2, 16));
    end;
    #endregion 
    #region Realization
    local procedure bitAnd(Operand1: Integer; Operand2: Integer; OperandSize: Byte) Result: Integer
    var
        bitLoop: Byte;
    begin
        clear(Result);
        for bitLoop := 1 to OperandSize do begin
            if ((Operand1 MOD 2 = 1) AND (Operand2 MOD 2 = 1)) then Result := Result + LowLevelDP.Power_Int(2, BitLoop - 1);
            Operand1 := Operand1 DIV 2;
            Operand2 := Operand2 DIV 2;
        end;
    end;

    local procedure bitOr(Operand1: Integer; Operand2: Integer; OperandSize: Byte) Result: Integer
    var
        bitLoop: Byte;
    begin
        clear(Result);
        for bitLoop := 1 to OperandSize do begin
            if ((Operand1 MOD 2 = 1) OR (Operand2 MOD 2 = 1)) then Result := Result + LowLevelDP.Power_Int(2, BitLoop - 1);
            Operand1 := Operand1 DIV 2;
            Operand2 := Operand2 DIV 2;
        end;
    end;

    local procedure bitXor(Operand1: Integer; Operand2: Integer; OperandSize: Byte) Result: Integer
    var
        bitLoop: Byte;
    begin
        clear(Result);
        for bitLoop := 1 to OperandSize do begin
            if (((Operand1 MOD 2 = 1) AND (Operand2 MOD 2 = 0)) OR ((Operand1 MOD 2 = 0) AND (Operand2 MOD 2 = 1))) then Result := Result + LowLevelDP.Power_Int(2, BitLoop - 1);
            Operand1 := Operand1 DIV 2;
            Operand2 := Operand2 DIV 2;
        end;
    end;

    local procedure bitNot(Operand: Integer; OperandSize: Byte) Result: Integer
    var
        bitLoop: Byte;
    begin
        clear(Result);
        for bitLoop := 1 to OperandSize do begin
            if (Operand MOD 2 = 0) then Result := Result + LowLevelDP.Power_Int(2, BitLoop - 1);
            Operand := Operand DIV 2;
        end;
    end;

    local procedure bitShl(Operand1: Integer; Operand2: Integer; OperandSize: Byte) Result: Integer
    var
        bitLoop: Byte;
    begin
        clear(Result);
        for bitLoop := 1 to (OperandSize - Operand2) do begin
            if (Operand1 MOD 2 = 1) then Result := Result + LowLevelDP.Power_Int(2, BitLoop + Operand2 - 1);
            Operand1 := Operand1 DIV 2;
        end;
    end;

    local procedure bitShr(Operand1: Integer; Operand2: Integer; OperandSize: Byte) Result: Integer
    var
        bitLoop: Byte;
    begin
        clear(Result);
        for bitLoop := 1 to OperandSize do begin
            if (bitLoop > Operand2) then if (Operand1 MOD 2 = 1) then Result := Result + LowLevelDP.Power_Int(2, BitLoop - Operand2 - 1);
            Operand1 := Operand1 DIV 2;
        end;
    end;

    procedure bitHi(Operand: Integer) Result: Integer
    begin
        exit(bitAnd16(Operand, bitHex16('FF00')));
    end;

    procedure bitLo(Operand: Integer) Result: Integer
    begin
        exit(bitAnd16(Operand, bitHex16('00FF')));
    end;
    #endregion 
    #region HexText
    procedure bitHexText8(Operand: Integer) Result: Text[2]
    begin
        clear(Result);
        Result := Result + CopyStr(byteHexText, Operand DIV LowLevelDP.Power_Int(2, 4) + 1, 1);
        Result := Result + CopyStr(byteHexText, Operand MOD LowLevelDP.Power_Int(2, 4) + 1, 1);
    end;

    procedure bitHexText16(Operand: Integer) Result: Text[4]
    begin
        clear(Result);
        Result := Result + bitHexText8(Operand DIV LowLevelDP.Power_Int(2, 8));
        Result := Result + bitHexText8(Operand MOD LowLevelDP.Power_Int(2, 8));
    end;

    procedure bitHex8(Operand: Text[2]) Result: Integer
    begin
        clear(Result);
        Result := Result + (StrPos(byteHexText, UpperCase(Operand[1])) - 1) * LowLevelDP.Power_Int(2, 4);
        Result := Result + (StrPos(byteHexText, UpperCase(Operand[2])) - 1);
    end;

    procedure bitHex16(Operand: Text[4]) Result: Integer
    begin
        clear(Result);
        Result := Result + bitHex8(Hex16Hi(Operand)) * LowLevelDP.Power_Int(2, 8);
        Result := Result + bitHex8(Hex16Lo(Operand));
    end;

    local procedure Hex16Hi(Operand: Text[4]) Result: Text[2]
    begin
        exit(CopyStr(Operand, 1, 2));
    end;

    procedure Hex16Lo(Operand: Text[4]) Result: Text[2]
    begin
        exit(CopyStr(Operand, 3, 2));
    end;
    #endregion
}
