table 70122 DYM_SalespersonRoute
{
    Caption = 'Salesperson Route';
    DrillDownPageID = DYM_SalespersonRoute;
    LookupPageID = DYM_SalespersonRoute;

    fields
    {
        field(1; "Salesperson Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(2; "Week No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Week No.';
        }
        field(3; Day; Option)
        {
            DataClassification = SystemMetadata;
            Caption = 'Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday,Other';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday,Other;

            trigger OnValidate()
            begin
                Clear("Original Salesperson Code");
            end;
        }
        field(4; "Customer No."; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Clear("Ship-to Code");
            end;
        }
        field(5; "Route Order"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Route Order';
        }
        field(6; "Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Customer Address"; Text[100])
        {
            CalcFormula = Lookup(Customer.Address WHERE("No." = FIELD("Customer No.")));
            Caption = 'Customer Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Customer City"; Text[50])
        {
            CalcFormula = Lookup(Customer.City WHERE("No." = FIELD("Customer No.")));
            Caption = 'Customer City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Nr. Visits"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Nr. Visits';
        }
        field(10; Channel; Code[20])
        {
            CalcFormula = Lookup(Customer."Global Dimension 1 Code" WHERE("No." = FIELD("Customer No.")));
            Caption = 'Channel';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Blocked; enum "Customer Blocked")
        {
            CalcFormula = Lookup(Customer.Blocked WHERE("No." = FIELD("Customer No.")));
            Caption = 'Blocked';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Ship-to Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(13; "Ship-to Name"; Text[100])
        {
            CalcFormula = Lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Caption = 'Ship-to Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Ship-to Address"; Text[100])
        {
            CalcFormula = Lookup("Ship-to Address".Address WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Caption = 'Ship-to Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Ship-to City"; Text[50])
        {
            CalcFormula = Lookup("Ship-to Address".City WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Caption = 'Ship-to City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Route Entry Name"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Route Entry Name';
            Editable = false;
        }
        field(17; "Route Entry Address"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Route Entry Address';
            Editable = false;
        }
        field(18; "Route Entry City"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Route Entry City';
            Editable = false;
        }
        field(19; "Route Makani Code"; Code[12])
        {
            DataClassification = SystemMetadata;
        }
        field(20; "Original Salesperson Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            begin
                TestField(Day, Day::Other);
            end;
        }
        field(101; "Mobile Device"; Code[100])
        {
            CalcFormula = Lookup(DYM_DeviceSetup.Code WHERE("Salesperson Code" = FIELD("Salesperson Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Salesperson Code", "Week No.", Day, "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
        key(Key2; "Route Order")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        UpdateRouteInfo;
    end;

    trigger OnModify()
    begin
        UpdateRouteInfo;
    end;

    trigger OnRename()
    begin
        UpdateRouteInfo;
    end;

    procedure CopyRoute()
    begin
    end;

    procedure UpdateRouteInfo()
    begin
        if ("Ship-to Code" = '') then begin
            CalcFields("Customer Name", "Customer Address", "Customer City");
            "Route Entry Name" := "Customer Name";
            "Route Entry Address" := "Customer Address";
        end
        else begin
            CalcFields("Ship-to Name", "Ship-to Address", "Ship-to City");
            "Route Entry Name" := "Ship-to Name";
            "Route Entry Address" := "Ship-to Address";
            "Route Entry City" := "Ship-to City";
        end;
    end;

    procedure UpdateRoutesInfo()
    var
        SPRoute: Record DYM_SalespersonRoute;
    begin
        SPRoute.Reset;
        if SPRoute.FindSet(true, false) then
            repeat
                SPRoute.UpdateRouteInfo;
                SPRoute.Modify;
            until SPRoute.Next = 0;
    end;
}
