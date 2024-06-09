table 70109 DYM_DynamicsMobileSetup
{
    Caption = 'Dynamics Mobile Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Packet Storage Path"; Text[250])
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if (CopyStr("Packet Storage Path", StrLen("Packet Storage Path"), 1) <> '\') then "Packet Storage Path" := "Packet Storage Path" + '\';
            end;
        }
        field(13; "Skip Checksum check"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(15; "Debug Mode"; Boolean)
        {
            DataClassification = SystemMetadata;
            ObsoleteState = Pending;
            ObsoleteReason = '[Debug Mode] will not be used. Replaced fully by [Debug Level] field values.';
            ObsoleteTag = '20220822_18.2.61.0';
            //trigger OnValidate()
            //begin
            //    if (not "Debug Mode") then
            //        Clear("Debug Level");
            //end;
        }
        field(16; "Debug Level"; enum DYM_DynamicsSetupDebugLevel)
        {
            DataClassification = SystemMetadata;
            //trigger OnValidate()
            //begin
            //    if ("Debug Level" <> "Debug Level"::None) then
            //        TestField("Debug Mode");
            //end;
        }
        field(17; "Settings Auto Sync"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(18; "Dashboard Calculation Days"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(51; "Process Timer Interval"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(52; "Auto Sync Intervals"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(53; "Dynamics Mobile Service URL"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(301; "Pull Disabled"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(303; "Deleting XML Disabled"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(10001; "DES Changed"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(10002; "DBS Changed"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(10003; "Dynamics Mobile initialized"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(12001; "Default settings"; BLOB)
        {
            DataClassification = SystemMetadata;
        }
        field(20101; "Packet Process Retry Enabled"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(20102; "Max Tries Count"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(20104; "Process Wait Time (sec)"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(20105; "Skip Processing Older (Days)"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(20201; "Processing Time"; Time)
        {
            DataClassification = SystemMetadata;
        }
        field(20301; "Last Processed Date"; Date)
        {
            DataClassification = SystemMetadata;
        }
        field(30001; "Packet Count"; Integer)
        {
            CalcFormula = Count(DYM_SyncLog);
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        "DBS Changed" := true;
    end;

    trigger OnModify()
    begin
        "DBS Changed" := true;
    end;

    trigger OnRename()
    begin
        Error(ConstMgt.ERR_0001, TableCaption);
    end;

    var
        ConstMgt: Codeunit DYM_ConstManagement;
}
