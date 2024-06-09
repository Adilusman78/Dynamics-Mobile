table 84019 DYM_DynamicsMobileCue
{
    Caption = 'Dynamics Mobile Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(101; Total; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Direction=CONST(Push), Internal=CONST(false), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; Pending; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Direction=CONST(Push), Internal=CONST(false), Status=CONST(Pending), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; Success; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Direction=CONST(Push), Internal=CONST(false), Status=CONST(Success), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; Failed; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Direction=CONST(Push), Internal=CONST(false), Status=CONST(Failed), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; Error; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Direction=CONST(Push), Internal=CONST(false), Status=CONST(Error), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; Pushes; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; Pulls; Integer)
        {
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Pull), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Active Roles"; Integer)
        {
            CalcFormula = Count(DYM_DeviceRole);
            Editable = false;
            FieldClass = FlowField;
        }
        field(202; "Active Groups"; Integer)
        {
            CalcFormula = Count(DYM_DeviceGroup WHERE(Disabled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(203; "Active Devices"; Integer)
        {
            CalcFormula = Count(DYM_DeviceSetup WHERE(Disabled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10001; "Date Filter"; DateTime)
        {
            FieldClass = FlowFilter;
        }
        field(10002; "Device Filter"; Code[100])
        {
            FieldClass = FlowFilter;
        }
        field(10003; "Mobile Status Filter";enum DYM_PacketCueStatus)
        {
            FieldClass = FlowFilter;
        }
        field(11001; "Total Sales Order"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Sales Order')));
        }
        field(11002; "Total Invoices"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Invoice')));
        }
        field(11003; "Total Payments"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Payment')));
        }
        field(11004; "Total Return Orders"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Return Order')));
        }
        field(11005; "Total Invenotory Loads"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Inventory Load')));
        }
        field(11006; "Total Invenotory Unloads"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Inventory Unload')));
        }
        field(11007; "Total Truck Invenotory Receive"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Truck Receive')));
        }
        field(11008; "Total Receive Inventory"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Receive Inventory')));
        }
        field(11009; "Total Stock Count"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Stock Count')));
        }
        field(11010; "Total Sales Quotes"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Sales Quote')));
        }
        field(11011; "Total Warehouse Receive"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Receive')));
        }
        field(11012; "Total Inbound Transfers"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('InboundTransfer')));
        }
        field(11013; "Total Outbound Transfer"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('OutboundTransfer')));
        }
        field(11014; "Total Shipments"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Ship')));
        }
        field(11015; "Total Basic Stock Counts"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('BasicStockCount')));
        }
        field(11016; "Total Warehouse Receipts"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Receipt')));
        }
        field(11017; "Total Warehouse Put-Aways"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('PutAway')));
        }
        field(11018; "Total WMS Movements"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('WmsMovement')));
        }
        field(11019; "Total Manual Movements"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('ManualMovement')));
        }
        field(11020; "Total Warehouse Picks"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Pick')));
        }
        field(11021; "Total Warehouse Loads"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('Load')));
        }
        field(11022; "Total WMS Stock Counts"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('WmsStockCount')));
        }
        field(11023; "Total Bin Movements"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(DYM_SyncLog WHERE(Internal=CONST(false), Direction=CONST(Push), "Entry TimeStamp"=FIELD("Date Filter"), "Device Setup Code"=FIELD("Device Filter"), "Operation Hint"=filter('BinMovement')));
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
}
