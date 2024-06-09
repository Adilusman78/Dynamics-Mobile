codeunit 84018 DYM_PacketScheduler
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        Schedule(Rec);
    end;
    var GlobalDP: Codeunit DYM_GlobalDataProcess;
    ConstMgt: Codeunit DYM_ConstManagement;
    CacheMgt: Codeunit DYM_CacheManagement;
    StreamMgt: Codeunit DYM_StreamManagement;
    DeviceSetup: Record DYM_DeviceSetup;
    DeviceGroup: Record DYM_DeviceGroup;
    DeviceRole: Record DYM_DeviceRole;
    InS: InStream;
    HierarchyList: List of[Text];
    DeviceId: Code[100];
    DeviceGroupId, DeviceRoleId: Code[20];
    RoleLevel, GroupLevel, DeviceLevel, HierarchyLevel: Integer;
    Hierarchy: Text;
    GeneratePerDevice: Boolean;
    GeneratePerDeviceSymbol: Label '*', Locked = true;
    Delimiter: Label ',', Locked = true;
    Text001: Label 'You must assign a parameter to the job queue entry.';
    Text002: Label 'Can not evaluate the value of [%1]';
    Text003: Label 'The device is disabled and can not make export for it';
    local procedure Schedule(JobQueueEntry: Record "Job Queue Entry")
    begin
        if(JobQueueEntry."Parameter String" = '')then Error(Text001);
        //Get Hierarchy string
        Hierarchy:=JobQueueEntry."Parameter String";
        HierarchyList:=Hierarchy.Split(Delimiter);
        HierarchyLevel:=HierarchyList.Count();
        //Hierarchy Levels
        RoleLevel:=1;
        GroupLevel:=2;
        DeviceLevel:=3;
        //Evaluate the input
        if(HierarchyLevel > DeviceLevel)then Error(StrSubstNo(Text002, Hierarchy));
        //Check if generate per device ogic is enabled
        if(HierarchyLevel = DeviceLevel)then begin
            DeviceId:=HierarchyList.Get(DeviceLevel);
            if(DeviceId = GeneratePerDeviceSymbol)then begin
                HierarchyLevel:=GroupLevel;
                GeneratePerDevice:=true;
            end;
        end;
        StreamMgt.initDummyInStream(InS);
        case HierarchyLevel of RoleLevel: begin
            DeviceRoleId:=HierarchyList.Get(RoleLevel);
            DeviceRole.Get(DeviceRoleId);
            DeviceGroup.Reset();
            DeviceGroup.SetRange("Device Role Code", DeviceRoleId);
            DeviceGroup.SetRange(Disabled, false);
            if(DeviceGroup.FindSet())then repeat CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, 0);
                    GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::Group, true, false, InS)until DeviceGroup.Next() = 0;
        end;
        GroupLevel: begin
            DeviceRoleId:=HierarchyList.Get(RoleLevel);
            DeviceRole.Get(DeviceRoleId);
            DeviceGroupId:=HierarchyList.Get(GroupLevel);
            DeviceGroup.Get(DeviceGroupId);
            if(GeneratePerDevice)then begin
                DeviceSetup.Reset();
                DeviceSetup.SetRange("Device Role Code", DeviceRoleId);
                DeviceSetup.SetRange("Device Group Code", DeviceGroupId);
                DeviceSetup.SetRange(Disabled, false);
                if(DeviceSetup.FindSet())then repeat CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, 0);
                        GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::Device, true, false, InS)until DeviceSetup.Next() = 0;
            end
            else
            begin
                CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, 0);
                GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::Group, true, false, InS)end;
        end;
        DeviceLevel: begin
            DeviceRoleId:=HierarchyList.Get(RoleLevel);
            DeviceRole.Get(DeviceRoleId);
            DeviceGroupId:=HierarchyList.Get(GroupLevel);
            DeviceGroup.Get(DeviceGroupId);
            DeviceId:=HierarchyList.Get(DeviceLevel);
            DeviceSetup.Get(DeviceId);
            if not(DeviceSetup.Disabled)then begin
                CacheMgt.SetContext(DeviceRole, DeviceGroup, DeviceSetup, 0);
                GlobalDP.InsertSyncLogEntry('', enum::DYM_PacketDirection::Push, enum::DYM_PacketType::Data, enum::DYM_PullType::Device, true, false, InS)end
            else
            begin
                Error(Text003);
            end;
        end;
        end;
    end;
}
