table 70130 DYM_VisitEntry
{
    Caption = 'Visit Entry';
    DrillDownPageID = DYM_VisitEntries;
    LookupPageID = DYM_VisitEntries;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Action"; Option)
        {
            DataClassification = SystemMetadata;
            OptionMembers = "Order",Invoice,Payment,Visit,"5G",Skipped,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"5G Invoice",,,,,,,"Load Request";
        }
        field(3; "Entry TimeStamp"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Customer No."; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = Customer."No.";
            ValidateTableRelation = false;
        }
        field(5; "Document No."; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Reason Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_VisitReason.Code;
        }
        field(7; "Salesperson Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(8; Comment; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(9; Amount; Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(10; Day; Option)
        {
            DataClassification = SystemMetadata;
            Caption = 'Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(11; "Comment 2"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(12; "Comment 3"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(101; "Customer Name"; Text[50])
        {
            DataClassification = SystemMetadata;
            Editable = true;
            FieldClass = Normal;
        }
        field(102; "Salesperson Name"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Salesperson Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Sync Log Entry No."; BigInteger)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(202; "Device Role Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = DYM_DeviceRole.Code;
        }
        field(203; "Device Group Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = DYM_DeviceGroup.Code;
        }
        field(204; "Device Setup Code"; Code[100])
        {
            DataClassification = SystemMetadata;
        }
        field(205; Targets; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(206; Samples; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(207; ApprovedProducts; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(208; UnapprovedProducts; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(209; Notes; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(1001; Latitude; Text[30])
        {
            DataClassification = SystemMetadata;
            Description = 'MA';
        }
        field(1002; Longitude; Text[30])
        {
            DataClassification = SystemMetadata;
            Description = 'MA';
        }
        field(1003; "VAT Registration No."; Code[20])
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
    }
    fieldgroups
    {
    }
}
