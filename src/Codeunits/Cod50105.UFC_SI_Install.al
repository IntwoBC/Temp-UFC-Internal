codeunit 50105 "UFC SI Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "UFC SI Integration Setup";
        ActivityCue: Record "UFC SI Activity Cue";
    begin
        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Insert(true);
        end;

        if not ActivityCue.Get('CUE') then begin
            ActivityCue.Init();
            ActivityCue."Primary Key" := 'CUE';
            ActivityCue.Insert(true);
        end;
    end;
}
