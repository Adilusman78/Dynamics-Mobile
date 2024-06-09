page 70159 DYM_RCSimpleWhseDocStats
{
    Caption = 'RC Simple Whse. Doc. Stats';
    PageType = CardPart;
    SourceTable = DYM_DynamicsMobileCue;

    layout
    {
        area(content)
        {
            cuegroup(Pending)
            {
                Caption = 'Pending';
            }
            cuegroup("Partially Processed")
            {
                Caption = 'Partially Processed';
            }
            cuegroup(Processed)
            {
                Caption = 'Processed';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Sales Order List")
            {
                ApplicationArea = All;
                Caption = 'Sales Order List';
                RunObject = Page "Sales Order List";
            }
        }
    }
}
