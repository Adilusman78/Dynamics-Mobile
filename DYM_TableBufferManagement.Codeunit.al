codeunit 84003 DYM_TableBufferManagement
{
    SingleInstance = true;

    var PullTablesArray: Array[128]of RecordRef;
    PullTablesArrayPos: Integer;
    Text001: Label 'No entry found in table buffer array for specified table [%1].';
    procedure ClearTableBuffers()
    begin
        PullTablesArrayPos:=0;
        Clear(PullTablesArray);
    end;
    procedure SetTableBuffer(var RecRef: RecordRef)
    begin
        PullTablesArrayPos+=1;
        PullTablesArray[PullTablesArrayPos]:=RecRef;
    end;
    procedure GetTableBuffer(TableNo: Integer; var Result: RecordRef)
    var
        RecRefTmp: RecordRef;
        i: Integer;
    begin
        Clear(Result);
        for i:=1 to PullTablesArrayPos do begin
            RecRefTmp:=PullTablesArray[i];
            if(RecRefTmp.Number = TableNo)then begin
                Result:=PullTablesArray[i];
                exit;
            end;
        end;
        //No entry found in array for specified table
        Error(Text001, TableNo);
    end;
}
