page 84999 DYM_TableMapFilters
{
    Caption = 'Table filters';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("Direction")
            {
                field("AllDirection"; AllDirections)
                {
                    ApplicationArea = All;
                    Caption = 'All';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        AllDirections:=true;
                        Inbound:=false;
                        Outbound:=false;
                    end;
                }
                field("Inbound"; Inbound)
                {
                    ApplicationArea = All;
                    Caption = 'Inbound';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Inbound:=true;
                        AllDirections:=false;
                        Outbound:=false;
                    end;
                }
                field("Outbound"; Outbound)
                {
                    ApplicationArea = All;
                    Caption = 'Outbound';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Outbound:=true;
                        AllDirections:=false;
                        Inbound:=false;
                    end;
                }
            }
            group("Active")
            {
                field("AllActive"; AllActive)
                {
                    ApplicationArea = All;
                    Caption = 'All';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        AllActive:=true;
                        Enabled:=false;
                        Disabled:=false;
                    end;
                }
                field("Enabled"; Enabled)
                {
                    ApplicationArea = All;
                    Caption = 'Enabled';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Enabled:=true;
                        Disabled:=false;
                        AllActive:=false;
                    end;
                }
                field("Disabled"; Disabled)
                {
                    ApplicationArea = All;
                    Caption = 'Disabled';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Disabled:=true;
                        Enabled:=false;
                        AllActive:=false;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Enabled:=XEnabled;
        Disabled:=XDisabled;
        Inbound:=XInbound;
        Outbound:=XOutbound;
        AllDirections:=XAllDirections;
        AllActive:=XAllActive;
    end;
    var //Causing warning because WITH is deprecated
    Enabled, Disabled, Inbound, Outbound, AllDirections, AllActive: Boolean;
    XEnabled, XDisabled, XInbound, XOutbound, XAllDirections, XAllActive: Boolean;
    procedure getPageFilters()Result: array[6]of Boolean var
        filterArray: array[6]of Boolean;
    begin
        filterArray[1]:=AllActive;
        filterArray[2]:=Enabled;
        filterArray[3]:=Disabled;
        filterArray[4]:=AllDirections;
        filterArray[5]:=Inbound;
        filterArray[6]:=Outbound;
        exit(filterArray);
    end;
    procedure setPageFilters(AllActive: Boolean; Enabled: Boolean; Disabled: Boolean; AllDirections: Boolean; Inbound: Boolean; Outbound: Boolean)
    begin
        XAllActive:=AllActive;
        XEnabled:=Enabled;
        XDisabled:=Disabled;
        XAllDirections:=AllDirections;
        XInbound:=Inbound;
        XOutbound:=Outbound;
    end;
}
