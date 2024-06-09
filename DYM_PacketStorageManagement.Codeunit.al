codeunit 84034 DYM_PacketStorageManagement
{
    TableNo = DYM_SyncLog;

    trigger OnRun()
    var
        settingsMgt: codeunit DYM_SettingsManagement;
        constMgt: codeunit DYM_ConstManagement;
        cloudMgt: Codeunit DYM_CloudManagement;
        CacheMgt: Codeunit DYM_CacheManagement;
    begin
        if(Rec.Internal)then exit;
        CacheMgt.SetContextSLE(Rec."Entry No.");
        settingsMgt.TestSetting(constMgt.BOS_PacketStorageType());
        case settingsMgt.GetSetting(constMgt.BOS_PacketStorageType())of constMgt.BOS_PacketStorageType_FileSystem(): begin
            //Rec.ImportPacket(true);
            Codeunit.Run(46014911, Rec); //DYM_C_OP_PacketStorageFS
        end;
        constMgt.BOS_PacketStorageType_DMCloud(): begin
            clear(cloudMgt);
            cloudMgt.Run(Rec);
        end;
        end;
        if(Rec."Entry No." > 0)then //Run only if not in fetch mode (and not in BLOBStore mode)
 if(Rec.Direction = Rec.Direction::Push)then begin
                Rec."Packet Size":=getPacketLength(Rec);
                if(not Rec."Web Service Entry")then rec.Checksum:=getPacketChecksum(Rec);
                Rec.Modify();
            end;
    end;
    procedure getPacketLength(var _syncLog: Record DYM_SyncLog): Integer begin
        _syncLog.CalcFields(Packet);
        exit(_syncLog.Packet.Length());
    end;
    procedure getPacketChecksum(var _syncLog: Record DYM_SyncLog): Text var
        inS: InStream;
        StatsMgt: Codeunit DYM_StatisticsManagement;
    begin
        _syncLog.CalcFields(Packet);
        _syncLog.Packet.CreateInStream(inS, TextEncoding::UTF8);
        exit(StatsMgt.calcStreamChecksum(inS));
    end;
}
