page 84002 DYM_MobileFieldMappingList
{
    Caption = 'Mobile Field Mapping List';
    DelayedInsert = true;
    PageType = List;
    SourceTable = DYM_MobileFieldMap;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
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
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                }
                field("Field Index"; Rec."Field Index")
                {
                    ApplicationArea = All;
                }
                field("Mobile Field"; Rec."Mobile Field")
                {
                    ApplicationArea = All;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                }
                field("NAV Table Name"; Rec."NAV Table Name")
                {
                    ApplicationArea = All;
                }
                field("NAV Field Name"; Rec."NAV Field Name")
                {
                    ApplicationArea = All;
                }
                field("Sync. Priority"; Rec."Sync. Priority")
                {
                    ApplicationArea = All;
                }
                field("AutoIncrement Push Value"; Rec."AutoIncrement Push Value")
                {
                    ApplicationArea = All;
                }
                field("AutoIncrement Pull Value"; Rec."AutoIncrement Pull Value")
                {
                    ApplicationArea = All;
                }
                field("Const Value Type"; Rec."Const Value Type")
                {
                    ApplicationArea = All;
                }
                field("Const Value"; Rec."Const Value")
                {
                    ApplicationArea = All;
                }
                field(Relational; Rec.Relational)
                {
                    ApplicationArea = All;
                }
                field("EQ Relation Field No."; Rec."EQ Relation Field No.")
                {
                    ApplicationArea = All;
                }
                field("EQ Condition Field No."; Rec."EQ Condition Field No.")
                {
                    ApplicationArea = All;
                }
                field("EQ Condition Value"; Rec."EQ Condition Value")
                {
                    ApplicationArea = All;
                }
                field("Session Value"; Rec."Session Value")
                {
                    ApplicationArea = All;
                }
                field("Sync Mandatory"; Rec."Sync Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Raw Data Editable"; Rec."Raw Data Editable")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        SessionValueOnFormat(Format(Rec."Session Value"));
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if TableMap.Get(Rec."Device Role Code", Rec."Table No.", Rec."Table Index")then begin
            Rec.Direction:=enum::DYM_MobileFieldMapDirection.FromInteger(TableMap.Direction.AsInteger());
            Rec."Field Index":=10000;
        end;
    end;
    var TableMap: Record DYM_MobileTableMap;
    SessionMgt: Codeunit DYM_SessionManagement;
    local procedure SessionValueOnFormat(Text: Text[1024])
    begin
        Text:=SessionMgt.GetSessionValueDescription(Rec."Session Value");
    end;
}
