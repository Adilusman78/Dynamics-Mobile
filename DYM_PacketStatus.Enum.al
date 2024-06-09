enum 84099 DYM_PacketStatus
{
    Extensible = true;
    Caption = 'Packet Status';

    value(0; "Pending")
    {
    Caption = 'Pending';
    }
    value(1; "InProgress")
    {
    Caption = 'InProgress';
    }
    value(2; "Success")
    {
    Caption = 'Success';
    }
    value(3; "Failed")
    {
    Caption = 'Failed';
    }
    value(4; "Error")
    {
    Caption = 'Error';
    }
    value(5; "Debug")
    {
    Caption = 'Debug';
    }
    value(6; "Parsing")
    {
    Caption = 'Parsing';
    }
    value(7; "Parsed")
    {
    Caption = 'Parsed';
    }
    value(8; "ParseError")
    {
    Caption = 'ParseError';
    }
    value(9; "Loading")
    {
    Caption = 'Loading';
    }
    value(10; "Loaded")
    {
    Caption = 'Loaded';
    }
    value(11; "LoadError")
    {
    Caption = 'LoadError';
    }
}
