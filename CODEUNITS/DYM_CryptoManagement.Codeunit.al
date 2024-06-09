codeunit 70110 DYM_CryptoManagement
{
    // Code translated from the following resources:
    // http://sanity-free.org/134/standard_crc_16_in_csharp.html
    // https://ozeki.hu/p_5890-crc-16-calculation.html
    // https://en.wikipedia.org/wiki/Cyclic_redundancy_check
    var
        Polynomial: Label 'A001', Locked = true;
        CRCTable: array[256] of Integer;
        bit: Codeunit DYM_Bitwise;

    procedure computeCRC(textValue: Text): Integer
    var
        i, index, crc : Integer;
        textValueChar: Byte;
    begin
        generateCRCTable();
        clear(crc);
        for i := 0 to (StrLen(textValue) - 1) do begin
            textValueChar := textValue[i + 1];
            index := bit.bitXor8(bit.bitLo(crc), textValueChar);
            crc := bit.bitXor16(bit.bitShr16(crc, 8), CRCTable[index + 1]);
        end;
        exit(crc);
    end;

    procedure generateCRCTable()
    var
        tableLoop, bitLoop : Integer;
        cellValue, tempValue : Integer;
    begin
        for tableLoop := 0 to (ArrayLen(CRCTable) - 1) do begin
            cellValue := 0;
            tempValue := tableLoop;
            for bitLoop := 0 to 7 do begin
                if (bit.bitAnd16(bit.bitXor16(cellValue, tempValue), bit.bitHex16('0001')) <> 0) then
                    cellValue := bit.bitXor16(bit.bitShr16(cellValue, 1), bit.bitHex16(Polynomial))
                else
                    cellValue := bit.bitShr16(cellValue, 1);
                tempValue := bit.bitShr16(tempValue, 1);
            end;
            CRCTable[tableLoop + 1] := cellValue;
        end;
    end;

    procedure getCRCTableData(index: integer): Integer
    begin
        exit(CRCTable[index]);
    end;
}
