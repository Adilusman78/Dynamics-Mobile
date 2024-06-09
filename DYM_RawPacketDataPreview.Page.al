page 84017 DYM_RawPacketDataPreview
{
    Caption = 'Raw Packet Data Preview';
    PageType = List;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                ShowCaption = true;
                FreezeColumn = Number;

                field(Number; Rec.Number)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = '#';
                    Width = 5;
                }
                field("CellData [1]"; CellData[1])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[1];
                    Editable = CellEditable01;
                    Visible = CellVisible01;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [2]"; CellData[2])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[2];
                    Editable = CellEditable02;
                    Visible = CellVisible02;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [3]"; CellData[3])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[3];
                    Editable = CellEditable03;
                    Visible = CellVisible03;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [4]"; CellData[4])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[4];
                    Editable = CellEditable04;
                    Visible = CellVisible04;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [5]"; CellData[5])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[5];
                    Editable = CellEditable05;
                    Visible = CellVisible05;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [6]"; CellData[6])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[6];
                    Editable = CellEditable06;
                    Visible = CellVisible06;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [7]"; CellData[7])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[7];
                    Editable = CellEditable07;
                    Visible = CellVisible07;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [8]"; CellData[8])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[8];
                    Editable = CellEditable08;
                    Visible = CellVisible08;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [9]"; CellData[9])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[9];
                    Editable = CellEditable09;
                    Visible = CellVisible09;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [10]"; CellData[10])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[10];
                    Editable = CellEditable10;
                    Visible = CellVisible10;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [11]"; CellData[11])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[11];
                    Editable = CellEditable11;
                    Visible = CellVisible11;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [12]"; CellData[12])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[12];
                    Editable = CellEditable12;
                    Visible = CellVisible12;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [13]"; CellData[13])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[13];
                    Editable = CellEditable13;
                    Visible = CellVisible13;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [14]"; CellData[14])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[14];
                    Editable = CellEditable14;
                    Visible = CellVisible14;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [15]"; CellData[15])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[15];
                    Editable = CellEditable15;
                    Visible = CellVisible15;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [16]"; CellData[16])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[16];
                    Editable = CellEditable16;
                    Visible = CellVisible16;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [17]"; CellData[17])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[17];
                    Editable = CellEditable17;
                    Visible = CellVisible17;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [18]"; CellData[18])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[18];
                    Editable = CellEditable18;
                    Visible = CellVisible18;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [19]"; CellData[19])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[19];
                    Editable = CellEditable19;
                    Visible = CellVisible19;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [20]"; CellData[20])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[20];
                    Editable = CellEditable20;
                    Visible = CellVisible20;

                    trigger OnValidate()
                    begin
                        UpdateRDL;
                    end;
                }
                field("CellData [21]"; CellData[21])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[21];
                    Editable = CellEditable21;
                    Visible = CellVisible21;
                }
                field("CellData [22]"; CellData[22])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[22];
                    Editable = CellEditable22;
                    Visible = CellVisible22;
                }
                field("CellData [23]"; CellData[23])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[23];
                    Editable = CellEditable23;
                    Visible = CellVisible23;
                }
                field("CellData [24]"; CellData[24])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[24];
                    Editable = CellEditable24;
                    Visible = CellVisible24;
                }
                field("CellData [25]"; CellData[25])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[25];
                    Editable = CellEditable25;
                    Visible = CellVisible25;
                }
                field("CellData [26]"; CellData[26])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[26];
                    Editable = CellEditable26;
                    Visible = CellVisible26;
                }
                field("CellData [27]"; CellData[27])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[27];
                    Editable = CellEditable27;
                    Visible = CellVisible27;
                }
                field("CellData [28]"; CellData[28])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[28];
                    Editable = CellEditable28;
                    Visible = CellVisible28;
                }
                field("CellData [29]"; CellData[29])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[29];
                    Editable = CellEditable29;
                    Visible = CellVisible29;
                }
                field("CellData [30]"; CellData[30])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[30];
                    Editable = CellEditable30;
                    Visible = CellVisible30;
                }
                field("CellData [31]"; CellData[31])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[31];
                    Editable = CellEditable31;
                    Visible = CellVisible31;
                }
                field("CellData [32]"; CellData[32])
                {
                    ApplicationArea = All;
                    CaptionClass = CellName[32];
                    Editable = CellEditable32;
                    Visible = CellVisible32;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        Clear(CellPos);
        Clear(CellName);
        Clear(CellData);
        Data.Reset;
        Data.SetRange("Record ID", Format(Rec.Number));
        if Data.FindSet(false, false)then repeat CellPos+=1;
                if((CellPos > FieldOffset) and ((CellPos - FieldOffset) <= ArrayLen(CellData)))then begin
                    CellName[CellPos - FieldOffset]:=Data."Mobile Field";
                    CellData[CellPos - FieldOffset]:=Data.Data;
                    CellEditable[CellPos - FieldOffset]:=Data.Editable;
                    UpdateCellEditableNonArray(CellPos - FieldOffset);
                end;
            until Data.Next = 0;
    end;
    trigger OnInit()
    begin
        MobileFieldMap.Reset;
    end;
    trigger OnOpenPage()
    begin
        Rec.SetRange(Number, 1, RowCount);
        CalcCellVisible;
        UpdateCellVisibleNonArray;
    end;
    var MobileFieldMap: Record DYM_MobileFieldMap;
    Data: Record DYM_CacheBuffer temporary;
    RowCount: Integer;
    MobileTableName: Text[30];
    CellName: array[32]of Text[30];
    CellData: array[32]of Text[250];
    CellVisible: array[32]of Boolean;
    CellEditable: array[32]of Boolean;
    CellPos: Integer;
    FieldOffset: Integer;
    CellVisible01: Boolean;
    CellVisible02: Boolean;
    CellVisible03: Boolean;
    CellVisible04: Boolean;
    CellVisible05: Boolean;
    CellVisible06: Boolean;
    CellVisible07: Boolean;
    CellVisible08: Boolean;
    CellVisible09: Boolean;
    CellVisible10: Boolean;
    CellVisible11: Boolean;
    CellVisible12: Boolean;
    CellVisible13: Boolean;
    CellVisible14: Boolean;
    CellVisible15: Boolean;
    CellVisible16: Boolean;
    CellVisible17: Boolean;
    CellVisible18: Boolean;
    CellVisible19: Boolean;
    CellVisible20: Boolean;
    CellVisible21: Boolean;
    CellVisible22: Boolean;
    CellVisible23: Boolean;
    CellVisible24: Boolean;
    CellVisible25: Boolean;
    CellVisible26: Boolean;
    CellVisible27: Boolean;
    CellVisible28: Boolean;
    CellVisible29: Boolean;
    CellVisible30: Boolean;
    CellVisible31: Boolean;
    CellVisible32: Boolean;
    CellEditable01: Boolean;
    CellEditable02: Boolean;
    CellEditable03: Boolean;
    CellEditable04: Boolean;
    CellEditable05: Boolean;
    CellEditable06: Boolean;
    CellEditable07: Boolean;
    CellEditable08: Boolean;
    CellEditable09: Boolean;
    CellEditable10: Boolean;
    CellEditable11: Boolean;
    CellEditable12: Boolean;
    CellEditable13: Boolean;
    CellEditable14: Boolean;
    CellEditable15: Boolean;
    CellEditable16: Boolean;
    CellEditable17: Boolean;
    CellEditable18: Boolean;
    CellEditable19: Boolean;
    CellEditable20: Boolean;
    CellEditable21: Boolean;
    CellEditable22: Boolean;
    CellEditable23: Boolean;
    CellEditable24: Boolean;
    CellEditable25: Boolean;
    CellEditable26: Boolean;
    CellEditable27: Boolean;
    CellEditable28: Boolean;
    CellEditable29: Boolean;
    CellEditable30: Boolean;
    CellEditable31: Boolean;
    CellEditable32: Boolean;
    procedure SetData(DeviceRoleCode: Code[20]; l_MobileTableName: Text[30]; l_RowCount: Integer; var l_Data: Record DYM_CacheBuffer)
    var
        TableMap: Record DYM_MobileTableMap;
    begin
        RowCount:=l_RowCount;
        MobileTableName:=l_MobileTableName;
        Data.Reset;
        Data.DeleteAll;
        l_Data.Reset;
        if l_Data.FindSet(false, false)then repeat Data.Init;
                Data.Copy(l_Data);
                Data.Insert;
            until l_Data.Next = 0;
    end;
    procedure UpdateFieldOffset(Step: Integer)
    begin
        FieldOffset+=Step;
        if(FieldOffset < 0)then FieldOffset:=0;
    end;
    procedure UpdateRDL()
    var
        RDL: Record DYM_RawDataLog;
        CacheMgt: Codeunit DYM_CacheManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        i: Integer;
    begin
        for i:=1 to ArrayLen(CellData)do begin
            RDL.Reset;
            RDL.SetRange("Sync Log Entry No.", CacheMgt.GetContextSLE);
            RDL.SetRange("Entry Type", enum::DYM_RawDataLogEntryType::Field);
            RDL.SetRange("Table Name", MobileTableName);
            RDL.SetRange("Record No.", Rec.Number);
            RDL.SetRange("Field Name", CellName[i]);
            RDL.SetFilter("Field Value", '<>%1', CellData[i]);
            if RDL.FindFirst then begin
                RDL."Field Value":=CellData[i];
                RDL.Modify;
            end;
        end;
    end;
    procedure CalcCellVisible()
    var
        xRecID: Text;
    begin
        Clear(CellPos);
        Clear(CellVisible);
        Clear(CellEditable);
        Clear(xRecID);
        Data.Reset;
        Data.SetCurrentKey("Table No.", "Table Index", "Table Name", "Record ID");
        if Data.FindSet(false, false)then repeat if((Data."Record ID" <> xRecID) and (xRecID <> ''))then Clear(CellPos);
                CellPos+=1;
                if((CellPos > FieldOffset) and ((CellPos - FieldOffset) <= ArrayLen(CellData)))then CellVisible[CellPos - FieldOffset]:=true;
                xRecID:=Data."Record ID";
            until Data.Next = 0;
    end;
    procedure UpdateCellVisibleNonArray()
    var
        i: Integer;
    begin
        CellVisible01:=CellVisible[1];
        CellVisible02:=CellVisible[2];
        CellVisible03:=CellVisible[3];
        CellVisible04:=CellVisible[4];
        CellVisible05:=CellVisible[5];
        CellVisible06:=CellVisible[6];
        CellVisible07:=CellVisible[7];
        CellVisible08:=CellVisible[8];
        CellVisible09:=CellVisible[9];
        CellVisible10:=CellVisible[10];
        CellVisible11:=CellVisible[11];
        CellVisible12:=CellVisible[12];
        CellVisible13:=CellVisible[13];
        CellVisible14:=CellVisible[14];
        CellVisible15:=CellVisible[15];
        CellVisible16:=CellVisible[16];
        CellVisible17:=CellVisible[17];
        CellVisible18:=CellVisible[18];
        CellVisible19:=CellVisible[19];
        CellVisible20:=CellVisible[20];
        CellVisible21:=CellVisible[21];
        CellVisible22:=CellVisible[22];
        CellVisible23:=CellVisible[23];
        CellVisible24:=CellVisible[24];
        CellVisible25:=CellVisible[25];
        CellVisible26:=CellVisible[26];
        CellVisible27:=CellVisible[27];
        CellVisible28:=CellVisible[28];
        CellVisible29:=CellVisible[29];
        CellVisible30:=CellVisible[30];
        CellVisible31:=CellVisible[31];
        CellVisible32:=CellVisible[32];
    end;
    procedure UpdateCellEditableNonArray(CellNo: Integer)
    begin
        case CellNo of 1: CellEditable01:=CellEditable[1];
        2: CellEditable02:=CellEditable[2];
        3: CellEditable03:=CellEditable[3];
        4: CellEditable04:=CellEditable[4];
        5: CellEditable05:=CellEditable[5];
        6: CellEditable06:=CellEditable[6];
        7: CellEditable07:=CellEditable[7];
        8: CellEditable08:=CellEditable[8];
        9: CellEditable09:=CellEditable[9];
        10: CellEditable10:=CellEditable[10];
        11: CellEditable11:=CellEditable[11];
        12: CellEditable12:=CellEditable[12];
        13: CellEditable13:=CellEditable[13];
        14: CellEditable14:=CellEditable[14];
        15: CellEditable15:=CellEditable[15];
        16: CellEditable16:=CellEditable[16];
        17: CellEditable17:=CellEditable[17];
        18: CellEditable18:=CellEditable[18];
        19: CellEditable19:=CellEditable[19];
        20: CellEditable20:=CellEditable[20];
        21: CellEditable21:=CellEditable[21];
        22: CellEditable22:=CellEditable[22];
        23: CellEditable23:=CellEditable[23];
        24: CellEditable24:=CellEditable[24];
        25: CellEditable25:=CellEditable[25];
        26: CellEditable26:=CellEditable[26];
        27: CellEditable27:=CellEditable[27];
        28: CellEditable28:=CellEditable[28];
        29: CellEditable29:=CellEditable[29];
        30: CellEditable30:=CellEditable[30];
        31: CellEditable31:=CellEditable[31];
        32: CellEditable32:=CellEditable[32];
        end;
    end;
}
