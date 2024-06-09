codeunit 70119 DYM_EnvIdManagement
{
    var
        SettingsMgt: Codeunit DYM_SettingsManagement;
        ConstMgt: Codeunit DYM_ConstManagement;
        CacheMgt: Codeunit DYM_CacheManagement;
        EventLogMgt: Codeunit DYM_EventLogManagement;
        CloudMgt: Codeunit DYM_CloudManagement;
        StateMgt: Codeunit DYM_StateManagement;
        Text001: Label 'Environment [%1] TimeStamp Hash does not match.';

    procedure verifyEnvId()
    var
        LocalEnvTSH, NextLocalEnvTSH, CloudEnvTSH, NewEnvTSH : Text;
    begin
        if SettingsMgt.CheckSetting(ConstMgt.BOS_DisableEnvIdCheck()) then exit;
        clear(LocalEnvTSH);
        clear(CloudEnvTSH);
        LocalEnvTSH := StateMgt.GetStateVar('', genEnvId());
        NextLocalEnvTSH := StateMgt.GetStateVar('', genNextEnvId());
        CloudEnvTSH := peekEnvTSH(genEnvId());
        case ((LocalEnvTSH = CloudEnvTSH) OR (LocalEnvTSH = '')) of
            true: //Environment TimeStamp Hash match. Everything is fine.
                begin
                    clear(NewEnvTSH);
                    NewEnvTSH := genEnvTSH();
                    StateMgt.SetStateVar('', genNextEnvId(), NewEnvTSH);
                    Commit();
                    //Critical section - pseudo poke is expected possible
                    pokeEnvTSH(genEnvId(), NewEnvTSH);
                    StateMgt.SetStateVar('', genEnvId(), NewEnvTSH);
                    Commit();
                end;
            false: //Environment TimeStamp Hash does not match. Stop all activities until environment review.
                begin
                    case (NextLocalEnvTSH = CloudEnvTSH) of
                        true: //Pseudo poke fail detected. 
                            begin
                                //Update LocalEnvTSH in order to pass back to actual TSH comparison
                                StateMgt.SetStateVar('', genEnvId(), NextLocalEnvTSH);
                                Commit;
                            end;
                        false: //Actual TimeStamp Hash mismatch. Most possibly environment has been copied
                            begin
                                StopDMJobs();
                                Commit();
                                error(Text001, SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea()));
                            end;
                    end;
                end;
        end;
    end;

    local procedure genEnvId(): Text
    begin
        SettingsMgt.TestGlobalSetting(ConstMgt.CLD_AppArea());
        exit(StrSubstNo(ConstMgt.CLD_EnvIdPattern(), SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea())));
    end;

    local procedure genNextEnvId(): Text
    begin
        SettingsMgt.TestGlobalSetting(ConstMgt.CLD_AppArea());
        exit(StrSubstNo(ConstMgt.CLD_NExtEnvIdPattern(), SettingsMgt.GetGlobalSetting(ConstMgt.CLD_AppArea())));
    end;

    local procedure genEnvTSH(): Text
    begin
        exit(CreateGuid());
    end;

    local procedure peekEnvTSH(EnvId: Text) Result: Text
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        respBodyJSON: JsonObject;
        EnvIdToken: JsonToken;
        baseAddress: Text;
        requrl: Text;
        respBodyText: Text;
        PerfCounterId: Integer;
    begin
        clear(Result);
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        settingsMgt.TestSetting(constMgt.CLD_AppArea());
        settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_getKeyValuePair());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        client.DefaultRequestHeaders().add('x-api-key', settingsMgt.GetSetting(constMgt.CLD_xAPIKey()));
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_getKeyValuePair());
        requrl := CloudMgt.ApplyPlaceHolderValue(requrl, constMgt.PLH_Key(), EnvId);
        client.Get(baseAddress + requrl, response);
        if (response.Content.ReadAs(respBodyText)) then begin
            if (response.HttpStatusCode() <> constMgt.HTP_200()) then begin
                cacheMgt.SetStateDescription(CopyStr(StrSubstNo('[%1][%2][%3]', response.HttpStatusCode(), respBodyText, requrl), 1, cacheMgt.GetStateDescriptionMaxStrLen()));
                Error(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText));
            end;
        end
        else
            Message('Cannot read body');
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
        respBodyJSON.ReadFrom(respBodyText);
        respBodyJSON.Get(genEnvId(), EnvIdToken);
        if (not EnvIdToken.AsValue().IsNull()) then Result := EnvIdToken.AsValue().AsText();
    end;

    local procedure pokeEnvTSH(EnvId: Text; EnvTSH: Text): Boolean
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        reqBodyJSON: JsonObject;
        EnvIdToken: JsonToken;
        baseAddress: Text;
        requrl: Text;
        reqBodyText: Text;
        respBodyText: Text;
        PerfCounterId: Integer;
    begin
        PerfCounterId := CacheMgt.StartPerfCounter();
        settingsMgt.TestSetting(constMgt.CLD_APIURL());
        settingsMgt.TestSetting(constMgt.CLD_AppArea());
        settingsMgt.TestSetting(constMgt.CLD_xAPIKey());
        settingsMgt.TestSetting(constMgt.CLD_URL_setKeyValuePair());
        baseAddress := settingsMgt.GetSetting(constMgt.CLD_APIURL());
        client.DefaultRequestHeaders().add('x-api-key', settingsMgt.GetSetting(constMgt.CLD_xAPIKey()));
        requrl := settingsMgt.GetSetting(constMgt.CLD_URL_setKeyValuePair());
        //requrl := CloudMgt.ApplyPlaceHolderValue(requrl, constMgt.PLH_Key(), genEnvId());
        clear(reqBodyJSON);
        reqBodyJSON.Add(EnvId, EnvTSH);
        reqBodyJSON.AsToken().WriteTo(reqBodyText);
        content.Clear();
        content.WriteFrom(reqBodyText);
        client.Post(baseAddress + requrl, content, response);
        if (response.Content.ReadAs(respBodyText)) then begin
            if (response.HttpStatusCode() <> constMgt.HTP_200()) then begin
                cacheMgt.SetStateDescription(CopyStr(StrSubstNo('[%1][%2][%3]', response.HttpStatusCode(), respBodyText, requrl), 1, cacheMgt.GetStateDescriptionMaxStrLen()));
                Error(StrSubstNo('[%1][%2]', response.HttpStatusCode(), respBodyText));
            end;
        end
        else
            Message('Cannot read body');
        //EventLogMgt.LogProcessDebug_MethodEnd();
        EventLogMgt.LogProcessDebug_APICallDuration(PerfCounterId);
    end;

    local procedure StopDMJobs()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueEntry2: Record "Job Queue Entry";
    begin
        JobQueueEntry.RESET;
        JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        //Filter Dynamics Mobile object range using the first and last codeunit in app
        JobQueueEntry.SETRANGE("Object ID to Run", Codeunit::DYM_DynamicsMobileStartup, Codeunit::DYM_EndOfObjectRange);
        JobQueueEntry.SETRANGE(Status, JobQueueEntry.Status::Ready);
        IF JobQueueEntry.FINDSET(FALSE, FALSE) THEN
            REPEAT
                JobQueueEntry2.GET(JobQueueEntry.ID);
                JobQueueEntry2.SetStatus(JobQueueEntry2.Status::"On Hold");
            UNTIL JobQueueEntry.NEXT = 0;
    end;
}
