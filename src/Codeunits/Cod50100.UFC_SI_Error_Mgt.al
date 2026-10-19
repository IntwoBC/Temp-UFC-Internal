codeunit 50100 "UFC SI Error Mgt"
{
    procedure LogPurchaseEvent(ErrorStage: Enum "UFC SI Error Stage"; OrderNumber: Code[20]; HeaderEntryNo: Integer; CorrelationId: Text; EventText: Text)
    begin
        // The shared log's header relation belongs to sales invoice staging.
        LogError(ErrorStage, OrderNumber, 0, CorrelationId,
            StrSubstNo('Purchase order %1 (purchase staging entry %2): %3', OrderNumber, HeaderEntryNo, EventText));
    end;

    procedure LogError(ErrorStage: Enum "UFC SI Error Stage"; InvoiceId: Code[20]; HeaderEntryNo: Integer; CorrelationId: Text; ErrorText: Text)
    var
        ErrorLog: Record "UFC SI Error Log";
    begin
        ErrorLog.Init();
        ErrorLog."I2I Created At" := CurrentDateTime();
        ErrorLog."I2I Error Stage" := ErrorStage;
        ErrorLog."I2I I6 Invoice ID" := InvoiceId;
        ErrorLog."I2I Header Entry No." := HeaderEntryNo;
        ErrorLog."I2I Correlation ID" := CopyStr(CorrelationId, 1, MaxStrLen(ErrorLog."I2I Correlation ID"));
        ErrorLog."I2I Message" := CopyStr(ErrorText, 1, MaxStrLen(ErrorLog."I2I Message"));
        ErrorLog.Insert(true);
    end;
}
