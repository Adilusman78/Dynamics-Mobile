table 70128 DYM_StateVariable
{
    Caption = 'State Variable';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; Context; Text[100])
        {
            Caption = 'Context';
        }
        field(2; Code; Text[100])
        {
            Caption = 'Code';
        }
        field(3; Value; Text[100])
        {
            Caption = 'Value';
        }
    }
    keys
    {
        key(Key1; Context, Code)
        {
            Clustered = true;
        }
    }
}
