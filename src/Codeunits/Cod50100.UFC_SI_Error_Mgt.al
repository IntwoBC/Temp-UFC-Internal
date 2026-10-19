codeunit 50100 "UFC SI Error Mgt"
{
    procedure LogError(ErrorStage: Enum "UFC SI Error Stage"; InvoiceId: Code[20]; HeaderEntryNo: Integer; CorrelationId: Text; ErrorText: Text)
    var
        ErrorLog: Record "UFC SI Error Log";
    begin
        ErrorLog.Init();
        ErrorLog."Created At" := CurrentDateTime();
        ErrorLog."Error Stage" := ErrorStage;
        ErrorLog."I6 Invoice ID" := InvoiceId;
        ErrorLog."Header Entry No." := HeaderEntryNo;
        ErrorLog."Correlation ID" := CopyStr(CorrelationId, 1, MaxStrLen(ErrorLog."Correlation ID"));
        ErrorLog.Message := CopyStr(ErrorText, 1, MaxStrLen(ErrorLog.Message));
        ErrorLog.Insert(true);
    end;
}
