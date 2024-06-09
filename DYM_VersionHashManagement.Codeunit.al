codeunit 84041 DYM_VersionHashManagement
{
    var IntegrityModuleVersionTemplate: Label '[%1][%2]', Locked = true;
    procedure calcIntegrityModulesVersionHash(): Integer var
        IntegrityModInfo: Record DYM_IntegrityModuleInfo;
        InstalledApps: Record "NAV App Installed App";
        CryptMgt: Codeunit DYM_CryptoManagement;
        DMModuleInfo: ModuleInfo;
        VersionHashText: TextBuilder;
        VersionHash: Integer;
    begin
        clear(VersionHashText);
        NavApp.GetCurrentModuleInfo(DMModuleInfo);
        VersionHashText.AppendLine(StrSubstNo(IntegrityModuleVersionTemplate, DMModuleInfo.Id, DMModuleInfo.AppVersion));
        IntegrityModInfo.Reset();
        if IntegrityModInfo.FindSet()then repeat if not InstalledApps.Get(IntegrityModInfo."App Id")then clear(InstalledApps);
                NavApp.GetModuleInfo(InstalledApps."App ID", DMModuleInfo);
                VersionHashText.AppendLine(StrSubstNo(IntegrityModuleVersionTemplate, DMModuleInfo.Id, DMModuleInfo.AppVersion));
            until IntegrityModInfo.Next() = 0;
        exit(CryptMgt.computeCRC(VersionHashText.ToText()));
    end;
    procedure WriteIntegrityVersionHash2State()
    var
        StateMgt: Codeunit DYM_StateManagement;
        BitMgt: Codeunit DYM_Bitwise;
        ConstMgt: Codeunit DYM_ConstManagement;
    begin
        StateMgt.SetStateVar('', ConstMgt.STV_IntegrityVersionHash(), BitMgt.bitHexText16(calcIntegrityModulesVersionHash()));
    end;
}
