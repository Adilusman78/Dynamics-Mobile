page 84016 DYM_MobileTableMappingLink
{
    Caption = 'Mobile Table Mapping Link';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Table';
    SourceTable = DYM_MobileTableMap;

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                ShowCaption = false;

                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
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
                field("Use specific push handler"; Rec."Use specific push handler")
                {
                    ApplicationArea = All;
                }
                field("Use specific pull handler"; Rec."Use specific pull handler")
                {
                    ApplicationArea = All;
                }
                field("Relation Type"; Rec."Relation Type")
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
                field("Has Sync Mandatory Fields"; Rec."Has Sync Mandatory Fields")
                {
                    ApplicationArea = All;
                }
                field("Parent Table No."; Rec."Parent Table No.")
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
            action("&Linked Tables")
            {
                ApplicationArea = All;
                Caption = '&Linked Tables';
                Image = LinkWithExisting;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page DYM_MobileTableMappingLink;
                RunPageLink = "Device Role Code"=FIELD("Device Role Code"), "Parent Table No."=FIELD("Table No."), "Parent Table Index"=FIELD(Index), "Pull Type"=FIELD("Pull Type");
                RunPageMode = Create;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if(Rec.GetFilter("Parent Table No.") <> '')then Rec."Parent Table No.":=Rec.GetRangeMin("Parent Table No.");
        if(Rec.GetFilter("Parent Table Index") <> '')then Rec."Parent Table Index":=Rec.GetRangeMin("Parent Table Index");
        if(Rec.GetFilter("Pull Type") <> '')then Rec."Pull Type":=Rec.GetRangeMin("Pull Type");
        Rec.Index:=10000;
    end;
}
