table 70104 DYM_DeviceActivity
{
    DataClassification = SystemMetadata;
    Caption = 'Device Activity';

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Customer No."; Code[30])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Comment"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Document No."; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Valid Distance"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Vist No."; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Visit Date"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(8; "In Route"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Distance"; Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(10; "Duration"; Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(11; "Longitude"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(12; "Latitude"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(13; "Action"; Enum DYM_DeviceActivityAction)
        {
            DataClassification = SystemMetadata;
        }
        field(14; "Amount"; Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(15; "Task Subject"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(16; "Task Id"; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(17; "Task template name"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(18; "Task template Id"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(19; "Cutomer Name"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(20; "Reason code"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(21; "No Order Reason"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(22; "SalesPerson Code"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(23; "NAV Document No."; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(24; "MaxVisitDuration"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(25; "MaxVisitDurationExcReasonCode"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(26; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceSetup.Code;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}
