page 70150 DYM_MobileTableMapFiltersList
{
    Caption = 'Mobile Table Map Filters List';
    DelayedInsert = true;
    PageType = List;
    SourceTable = DYM_MobileTableMapFilters;

    layout
    {
        area(content)
        {
            repeater(Control1103109000)
            {
                ShowCaption = false;

                field("Filter Field No."; Rec."Filter Field No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        UpdateTexts;
                    end;
                }
                field(FilterFieldNoText; FilterFieldNoText)
                {
                    ApplicationArea = All;
                    CaptionClass = Rec.FieldCaption("Filter Field No.");
                    Editable = false;
                }
                field("Filter Type"; Rec."Filter Type")
                {
                    ApplicationArea = All;
                }
                field("Filter Value"; Rec."Filter Value")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        SessionValue: Record DYM_SessionValues;
                        SessionValueCodeLenght: Integer;
                    begin
                        if (Rec."Filter Type" = Rec."Filter Type"::"Session Value") then begin
                            SessionValueCodeLenght := MaxStrLen(SessionValue.Code);
                            if (StrLen(Rec."Filter Value") > SessionValueCodeLenght) then Error(StrSubstNo(Text001, SessionValueCodeLenght));
                        end;
                    end;
                }
                field("FlowFilter to Field No."; Rec."FlowFilter to Field No.")
                {
                    ApplicationArea = All;
                }
                field("FlowFilter to Field Index"; Rec."FlowFilter to Field Index")
                {
                    ApplicationArea = All;
                }
                field(FlowFiltertoFieldNoText; FlowFiltertoFieldNoText)
                {
                    ApplicationArea = All;
                    CaptionClass = Rec.FieldCaption("FlowFilter to Field No.");
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookUpFlowField;
                        UpdateTexts;
                    end;
                }
                field("Device Role Code"; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                }
                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetCurrRecord()
    begin
        UpdateTexts;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateTexts;
    end;

    var
        LowLevelDP: Codeunit DYM_LowLevelDataProcess;
        SessionMgt: Codeunit DYM_SessionManagement;
        [InDataSet]
        FilterFieldNoText: Text[1024];
        [InDataSet]
        FlowFiltertoFieldNoText: Text[1024];
        aaa: Integer;
        Text001: Label 'The value of the filter must be up to %1 characters';

    procedure FormatFilterValue(var Text: Text[1024])
    var
        MobileTableMap: Record DYM_MobileTableMap;
        FieldFilterFieldNo: Integer;
    begin
        case Rec."Filter Type" of
            Rec."Filter Type"::"Session Value":
                Text := SessionMgt.GetSessionValueDescription(Rec."Filter Value");
            Rec."Filter Type"::Field:
                if Evaluate(FieldFilterFieldNo, Rec."Filter Value") then
                    Text := LowLevelDP.GetFieldName(Rec.GetParentTableNo, FieldFilterFieldNo);
        end;
    end;

    local procedure FilterFieldNoTextOnFormat(var Text: Text[1024])
    begin
        Text := LowLevelDP.GetFieldName(Rec."Table No.", Rec."Filter Field No.");
    end;

    local procedure FilterValueOnFormat(Text: Text[1024])
    begin
        FormatFilterValue(Text);
    end;

    local procedure FlowFiltertoFieldNoTextOnForma(var Text: Text[1024])
    begin
        Text := LowLevelDP.GetFieldName(Rec."Table No.", Rec."FlowFilter to Field No.");
    end;

    procedure UpdateTexts()
    begin
        FilterFieldNoText := Format(Rec."Filter Field No.");
        FilterFieldNoTextOnFormat(FilterFieldNoText);
        FilterValueOnFormat(Format(Rec."Filter Value"));
        FlowFiltertoFieldNoText := Format(Rec."FlowFilter to Field No.");
        FlowFiltertoFieldNoTextOnForma(FlowFiltertoFieldNoText);
    end;
}
