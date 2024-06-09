page 84001 DYM_MobileTableMappingList
{
    Caption = 'Mobile Table Mapping List';
    DelayedInsert = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Table';
    SourceTable = DYM_MobileTableMap;
    SourceTableView = SORTING("Device Role Code", "Table No.", Index);

    layout
    {
        area(content)
        {
            repeater(grid_TablesList)
            {
                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                }
                field("Parent Table No."; Rec."Parent Table No.")
                {
                    ApplicationArea = All;
                    Visible = ParentTableNoVisible;
                }
                field("Parent Table Index"; Rec."Parent Table Index")
                {
                    ApplicationArea = All;
                    Visible = ParentTableIndexVisible;
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field("Mobile Table"; Rec."Mobile Table")
                {
                    ApplicationArea = All;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                }
                field("Pull Type"; Rec."Pull Type")
                {
                    ApplicationArea = All;
                }
                field("Linked Tables"; Rec."Linked Tables")
                {
                    ApplicationArea = All;
                }
                field("Use specific push handler"; Rec."Use specific push handler")
                {
                    ApplicationArea = All;
                }
                field("Use specific pull handler"; Rec."Use specific pull handler")
                {
                    ApplicationArea = All;
                }
                field("Sync. Priority"; Rec."Sync. Priority")
                {
                    ApplicationArea = All;
                }
                field(Index; Rec.Index)
                {
                    ApplicationArea = All;
                }
                field("Key"; Rec."Key")
                {
                    ApplicationArea = All;
                }
                field("Fields Defined by Table Index"; Rec."Fields Defined by Table Index")
                {
                    ApplicationArea = All;
                }
                field("Has Sync Mandatory Fields"; Rec."Has Sync Mandatory Fields")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Related)
            {
                Caption = 'Related';

                action("Fi&elds")
                {
                    ApplicationArea = All;
                    Caption = 'Fi&elds';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page DYM_MobileFieldMappingList;
                    RunPageLink = "Device Role Code"=FIELD("Device Role Code"), "Table No."=FIELD("Table No."), "Table Index"=FIELD(Index);
                    ShortCutKey = 'Ctrl+E';
                }
                action("Fil&ters")
                {
                    ApplicationArea = All;
                    Caption = 'Fil&ters';
                    Image = UseFilters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page DYM_MobileTableMapFiltersList;
                    RunPageLink = "Device Role Code"=FIELD("Device Role Code"), "Table No."=FIELD("Table No."), "Table Index"=FIELD(Index);
                    ShortCutKey = 'Ctrl+T';
                }
                action("&Linked tables")
                {
                    ApplicationArea = All;
                    Caption = '&Linked tables';
                    Image = LinkWithExisting;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page DYM_MobileTableMappingLink;
                    RunPageLink = "Device Role Code"=FIELD("Device Role Code"), "Parent Table No."=FIELD("Table No."), "Parent Table Index"=FIELD(Index), "Pull Type"=FIELD("Pull Type");
                }
                action("&Table Map Filters")
                {
                    ApplicationArea = All;
                    Caption = '&Table Map Filters';
                    Image = FilterLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        TableMapFilters: Page DYM_TableMapFilters;
                        filterTablesMap: array[5]of Boolean;
                    begin
                        Clear(TableMapFilters);
                        TableMapFilters.setPageFilters(XAllActive, XEnabled, XDisabled, XAllDirections, XInbound, XOutbound);
                        if(TableMapFilters.RunModal() = Action::OK)then begin
                            InitFilterTableMap(TableMapFilters.getPageFilters());
                            //Active
                            if(AllActive)then begin
                                Rec.SetFilter(Rec.Disabled, '');
                            end;
                            if(Enabled)then begin
                                Rec.SetFilter(Rec.Disabled, 'No');
                            end;
                            if(Disable)then begin
                                Rec.SetFilter(Rec.Disabled, 'Yes');
                            end;
                            //Directions
                            if(AllDirections)then begin
                                Rec.SetFilter(Rec.Direction, '');
                            end;
                            if(Inbound)then begin
                                Rec.SetFilter(Rec.Direction, 'Push|Both');
                            end;
                            if(Outbound)then begin
                                Rec.SetFilter(Rec.Direction, 'Pull|Both');
                            end;
                            setLocalFilters(AllActive, Enabled, Disable, AllDirections, Inbound, Outbound);
                        end;
                    end;
                }
            }
        }
    }
    trigger OnInit()
    begin
        ParentTableIndexVisible:=true;
        ParentTableNoVisible:=true;
    end;
    trigger OnOpenPage()
    begin
        HasParentFilter:=(Rec.GetFilter("Parent Table No.") <> '');
        ParentTableNoVisible:=not HasParentFilter;
        ParentTableIndexVisible:=not HasParentFilter;
    end;
    var HasParentFilter: Boolean;
    [InDataSet]
    ParentTableNoVisible: Boolean;
    [InDataSet]
    ParentTableIndexVisible: Boolean;
    AllDirections, AllActive, Enabled, Disable, Inbound, Outbound: Boolean;
    XAllDirections, XAllActive, XEnabled, XDisabled, XInbound, XOutbound: Boolean;
    procedure InitFilterTableMap(filterTablesMap: array[6]of Boolean)
    begin
        AllActive:=filterTablesMap[1];
        Enabled:=filterTablesMap[2];
        Disable:=filterTablesMap[3];
        AllDirections:=filterTablesMap[4];
        Inbound:=filterTablesMap[5];
        Outbound:=filterTablesMap[6];
    end;
    procedure setLocalFilters(AllActive: Boolean; Enabled: Boolean; Disabled: Boolean; AllDirections: Boolean; Inbound: Boolean; Outbound: Boolean)
    begin
        XAllActive:=AllActive;
        XEnabled:=Enabled;
        XDisabled:=Disabled;
        XAllDirections:=AllDirections;
        XInbound:=Inbound;
        XOutbound:=Outbound;
    end;
}
