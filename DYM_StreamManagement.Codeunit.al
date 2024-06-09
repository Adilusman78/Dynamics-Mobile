codeunit 84008 DYM_StreamManagement
{
    procedure initDummyInStream(var _inStream: InStream)
    var
        tempBlob: Codeunit "Temp Blob";
    begin
        clear(tempBlob);
        tempBlob.CreateInStream(_inStream, TextEncoding::UTF8);
    end;
}
