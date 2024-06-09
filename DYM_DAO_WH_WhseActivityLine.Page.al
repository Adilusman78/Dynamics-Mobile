page 84311 DYM_DAO_WH_WhseActivityLine
{
    PageType = API;
    APIPublisher = 'DynamicsMobile';
    APIGroup = 'DMDAO';
    APIVersion = 'v1.0';
    EntityName = 'whWhseActivityLine';
    EntitySetName = 'whWhseActivityLines';
    DelayedInsert = true;
    SourceTable = "Warehouse Activity Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(activityType; Rec."Activity Type")
                {
                }
                field(no; Rec."No.")
                {
                }
                field(lineNo; Rec."Line No.")
                {
                }
                field(actionType; Rec."Action Type")
                {
                }
                field(itemNo; Rec."Item No.")
                {
                }
                field(variantCode; Rec."Variant Code")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                }
                field(qtyperUnitofMeasure; Rec."Qty. per Unit of Measure")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(zoneCode; Rec."Zone Code")
                {
                }
                field(binCode; Rec."Bin Code")
                {
                }
                field(lotNo; Rec."Lot No.")
                {
                }
                field(serialNo; Rec."Serial No.")
                {
                }
                field(expirationDate; Rec."Expiration Date")
                {
                }
                field(warrantyDate; Rec."Warranty Date")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(qtyBase; Rec."Qty. (Base)")
                {
                }
                field(qtyOutstanding; Rec."Qty. Outstanding")
                {
                }
                field(qtyOutstandingBase; Rec."Qty. Outstanding (Base)")
                {
                }
                field(qtytoHandle; Rec."Qty. to Handle")
                {
                }
                field(qtytoHandleBase; Rec."Qty. to Handle (Base)")
                {
                }
                field(qtyHandled; Rec."Qty. Handled")
                {
                }
                field(qtyHandledBase; Rec."Qty. Handled (Base)")
                {
                }
                field(sourceType; Rec."Source Type")
                {
                }
                field(sourceSubtype; Rec."Source Subtype")
                {
                }
                field(sourceNo; Rec."Source No.")
                {
                }
                field(sourceLineNo; Rec."Source Line No.")
                {
                }
                field(sourceSublineNo; Rec."Source Subline No.")
                {
                }
                field(sourceDocument; Rec."Source Document")
                {
                }
                field(destinationType; Rec."Destination Type")
                {
                }
                field(destinationNo; Rec."Destination No.")
                {
                }
                field(whseDocumentType; Rec."Whse. Document Type")
                {
                }
                field(whseDocumentNo; Rec."Whse. Document No.")
                {
                }
                field(whseDocumentLineNo; Rec."Whse. Document Line No.")
                {
                }
                field(binRanking; Rec."Bin Ranking")
                {
                }
                field(binTypeCode; Rec."Bin Type Code")
                {
                }
                field(cubage; Rec.Cubage)
                {
                }
                field(weight; Rec.Weight)
                {
                }
                field(whseGroupLineIndex; WhseGroupLineIndex)
                {
                }
                field(breakbulk; Rec.Breakbulk)
                {
                }
                field(breakbulkNo; Rec."Breakbulk No.")
                {
                }
                field(originalBreakbulk; Rec."Original Breakbulk")
                {
                }
            }
        }
    }
    var WhseGroupLineIndex: Integer;
    trigger OnOpenPage()
    begin
        clear(WhseGroupLineIndex);
    end;
    trigger OnAfterGetRecord()
    var
        NewDocument: Boolean;
    begin
        //Works for Movements only
        if(Rec."Activity Type" = Rec."Activity Type"::Movement)then begin
            clear(NewDocument);
            //Clear on new document
            if((Rec."Activity Type" <> xRec."Activity Type") OR (Rec."No." <> xRec."No."))then begin
                clear(WhseGroupLineIndex);
                NewDocument:=true;
            end;
            //Increase on new take/place pair
            if(((Rec."Action Type" = Rec."Action Type"::Take) AND (xRec."Action Type" = xRec."Action Type"::Place)) OR (NewDocument))then WhseGroupLineIndex+=1;
        end;
    end;
}
