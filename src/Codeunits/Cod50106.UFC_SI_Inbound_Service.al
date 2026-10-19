codeunit 50106 "UFC i6 SI Inbound Service"
{
    [ServiceEnabled]
    procedure ReceiveSalesInvoice(Payload: Text): Text
    begin
        exit(ImportMgt.ReceiveInboundPayload(Payload));
    end;

    var
        ImportMgt: Codeunit "UFC SI Import Mgt";
}

