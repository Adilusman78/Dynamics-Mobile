table 70118 DYM_PostProcessLog
{
    Caption = 'Post Process Log';

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Sync Log Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; Status; enum DYM_PostProcessPacketStatus)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(5; Position; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Operation Type"; enum DYM_PostProcessOperationType)
        {
            DataClassification = SystemMetadata;
        }
        field(7; Message; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Start TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(9; "End TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(10; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(11; Parameters; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(12; Dependancy; BigInteger)
        {
            DataClassification = SystemMetadata;
        }
        field(13; Company; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(14; Subsequent; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(15; Data; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(102; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(103; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceGroup.Code;
        }
        field(104; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(201; "Retries count"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(202; "Next Process TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(203; Priority; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Sync Log Entry No.")
        {
        }
        key(Key3; "Table No.", "Operation Type", Status, "Entry TimeStamp")
        {
        }
        key(Key4; Dependancy)
        {
        }
        key(Key5; "Table No.", Position)
        {
        }
    }
    var
        Text001: Label 'Are you sure you want to reset the entry status from status Success?';

    procedure ResetStatus(Force: Boolean)
    begin
        if (Status = Status::Success) then if not Force then if not Confirm(Text001, false) then exit;
        LockTable;
        Clear(Status);
        Modify;
        Commit;
    end;
}
