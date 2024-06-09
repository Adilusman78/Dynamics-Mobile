codeunit 70127 DYM_IntegrityManagement
{
    var
        Text001: Label '%1 modules updated to Integrity Modules list.';
        Text002: Label 'Integrity check failed. Missing module found:\App Id: [%1]\Name: [%2]\Publisher: [%3].';

    procedure UpdateIntegrityModuleList()
    var
        InstalledApps: Record "NAV App Installed App";
        VersionHashMgt: Codeunit DYM_VersionHashManagement;
        DMModuleInfo: ModuleInfo;
        AppModuleInfo: ModuleInfo;
        AppDependentModules: List of [ModuleDependencyInfo];
        AppDependentModuleInfo: ModuleDependencyInfo;
        AppDepModulesCount: Integer;
        AppDepModulesPos: Integer;
        DMDepModulesCount: Integer;
        DMDepModuleFound: Boolean;
    begin
        NavApp.GetCurrentModuleInfo(DMModuleInfo);
        Clear(DMDepModulesCount);
        InstalledApps.Reset;
        If InstalledApps.FindSet(false, false) then
            repeat
                NavApp.GetModuleInfo(InstalledApps."App ID", AppModuleInfo);
                Clear(DMDepModuleFound);
                Clear(AppDepModulesCount);
                Clear(AppDepModulesPos);
                AppDependentModules := AppModuleInfo.Dependencies;
                AppDepModulesCount := AppDependentModules.Count;
                if (AppDepModulesCount > 0) then begin
                    repeat
                        AppDepModulesPos += 1;
                        AppDependentModuleInfo := AppDependentModules.Get(AppDepModulesPos);
                        if (AppDependentModuleInfo.Id = DMModuleInfo.Id) then DMDepModuleFound := true;
                    until ((AppDepModulesPos = AppDepModulesCount) or (DMDepModuleFound));
                    if DMDepModuleFound then begin
                        DMDepModulesCount += 1;
                        WriteModuleDepInfoToIntegrityList(AppModuleInfo);
                    end;
                end;
            until InstalledApps.Next() = 0;
        VersionHashMgt.WriteIntegrityVersionHash2State();
        Message(Text001, DMDepModulesCount);
    end;

    procedure TestModulesIntegrity(_Silent: Boolean) Result: Boolean
    var
        IntegrityInfo: Record DYM_IntegrityModuleInfo;
        InstalledApps: Record "NAV App Installed App";
        VersionHashMgt: Codeunit DYM_VersionHashManagement;
        EndOfLoop: Boolean;
    begin
        Result := true;
        IntegrityInfo.Reset;
        if IntegrityInfo.FindSet(false, false) then
            repeat
                if not InstalledApps.Get(IntegrityInfo."App Id") then clear(Result);
                EndOfLoop := not Result;
                If not EndOfLoop then EndOfLoop := IntegrityInfo.Next() = 0;
            until EndOfLoop;
        if ((not Result) and (not _Silent)) then Error(Text002, IntegrityInfo."App Id", IntegrityInfo.Name, IntegrityInfo.Publisher);
        VersionHashMgt.WriteIntegrityVersionHash2State();
    end;

    local procedure WriteModuleDepInfoToIntegrityList(_ModuleDepInfo: ModuleInfo)
    var
        IntegrityInfo: Record DYM_IntegrityModuleInfo;
    begin
        if not IntegrityInfo.Get(_ModuleDepInfo.Id) then begin
            IntegrityInfo.Init();
            IntegrityInfo."App Id" := _ModuleDepInfo.Id;
            IntegrityInfo.Insert();
        end;
        IntegrityInfo.Name := _ModuleDepInfo.Name;
        IntegrityInfo.Publisher := _ModuleDepInfo.Publisher;
        IntegrityInfo.Modify();
    end;
}
