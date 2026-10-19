page 50110 "UFC SI Control Center"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Staging';
    PageType = Card;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            usercontrol(OperationsDesk; "UFC SI Operations Dashboard")
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    LoadDashboard();
                end;

                trigger RefreshDashboard()
                begin
                    LoadDashboard();
                end;

                trigger ProcessReady()
                begin
                    ProcessingMgt.ProcessOpenEntries();
                    LoadDashboard();
                end;

                trigger ResetFailed()
                var
                    ResetCount: Integer;
                begin
                    ResetCount := ProcessingMgt.FailedEntryCount();
                    if ResetCount = 0 then begin
                        LoadDashboard();
                        exit;
                    end;

                    if not Confirm(ResetFailedQst, false, ResetCount) then
                        exit;

                    ResetCount := ProcessingMgt.ResetFailedEntries();
                    if ResetCount > 0 then
                        Message(ResetCompletedMsg, ResetCount);
                    LoadDashboard();
                end;

                trigger ReviewErrors()
                var
                    ErrorLog: Record "UFC SI Error Log";
                begin
                    Page.Run(Page::"UFC SI Error Log", ErrorLog);
                    LoadDashboard();
                end;

                trigger OpenStaging()
                var
                    HeaderStaging: Record "UFC SI Header Staging";
                begin
                    Page.Run(Page::"UFC SI Staging List", HeaderStaging);
                    LoadDashboard();
                end;

                trigger OpenEntry(EntryNo: Integer)
                var
                    HeaderStaging: Record "UFC SI Header Staging";
                begin
                    if HeaderStaging.Get(EntryNo) then
                        Page.Run(Page::"UFC SI Staging Card", HeaderStaging);
                    LoadDashboard();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshDashboard)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    LoadDashboard();
                end;
            }
        }
    }

    local procedure LoadDashboard()
    var
        HeaderStaging: Record "UFC SI Header Staging";
        ErrorLog: Record "UFC SI Error Log";
        Setup: Record "UFC SI Integration Setup";
        Model: JsonObject;
        Entries: JsonArray;
        Entry: JsonObject;
        DashboardText: Text;
        EntryCount: Integer;
    begin
        Model.Add('ready', CountByStatus(Enum::"UFC SI Integration Status"::Open));
        Model.Add('failed', CountByStatus(Enum::"UFC SI Integration Status"::Failed));
        Model.Add('processing', CountByStatus(Enum::"UFC SI Integration Status"::Processing));
        Model.Add('success', CountByStatus(Enum::"UFC SI Integration Status"::Success));
        Model.Add('total', HeaderStaging.Count());
        Model.Add('errorLogCount', ErrorLog.Count());
        ErrorLog.SetRange("Header Entry No.", 0);
        Model.Add('preStagingErrorCount', ErrorLog.Count());

        if Setup.Get('SETUP') then begin
            Model.Add('inboundEnabled', Setup."Pull Enabled");
            if Setup."Last Pull At" <> 0DT then
                Model.Add('lastActivity', Format(Setup."Last Pull At"))
            else
                Model.Add('lastActivity', 'No i6 receipt or test upload has been completed.');
        end else begin
            Model.Add('inboundEnabled', false);
            Model.Add('lastActivity', 'Integration setup has not been created.');
        end;

        HeaderStaging.SetCurrentKey("Received At");
        HeaderStaging.Ascending(false);
        if HeaderStaging.FindSet() then
            repeat
                Clear(Entry);
                Entry.Add('entryNo', HeaderStaging."Entry No.");
                Entry.Add('invoiceId', HeaderStaging."I6 Invoice ID");
                Entry.Add('customerNo', HeaderStaging."Customer No.");
                Entry.Add('locationCode', HeaderStaging."Location Code");
                Entry.Add('status', Format(HeaderStaging."Integration Status"));
                Entry.Add('receivedAt', Format(HeaderStaging."Received At"));
                Entries.Add(Entry);
                EntryCount += 1;
            until (HeaderStaging.Next() = 0) or (EntryCount = 10);

        Model.Add('entries', Entries);
        Model.WriteTo(DashboardText);
        CurrPage.OperationsDesk.RenderDashboard(DashboardText);
    end;

    local procedure CountByStatus(Status: Enum "UFC SI Integration Status"): Integer
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("Integration Status", Status);
        exit(HeaderStaging.Count());
    end;

    var
        ProcessingMgt: Codeunit "UFC SI Processing Mgt";
        ResetFailedQst: Label 'Reset %1 failed staging records to Open? Correct the issue first, then select Process Ready.';
        ResetCompletedMsg: Label '%1 failed staging records were reset to Open and can now be processed again.';
}
