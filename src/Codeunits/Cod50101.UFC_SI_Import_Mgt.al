codeunit 50101 "UFC SI Import Mgt"
{
    procedure ReceiveInboundPayload(PayloadText: Text): Text
    var
        Setup: Record "UFC SI Integration Setup";
        HeaderTemp: Record "UFC SI Header Staging" temporary;
        LineTemp: Record "UFC SI Line Staging" temporary;
        CorrelationId: Text;
        ErrorText: Text;
    begin
        EnsureSetup(Setup);
        CorrelationId := Format(CreateGuid());

        if not Setup."Pull Enabled" then
            LogInboundErrorAndFail(Setup, Enum::"UFC SI Error Stage"::Endpoint, '', CorrelationId, 'The UFC i6 inbound service is disabled.');

        if not BuildValidatedPayload(PayloadText, Setup."Default Source System", CorrelationId, HeaderTemp, LineTemp, ErrorText) then
            LogInboundErrorAndFail(Setup, Enum::"UFC SI Error Stage"::MandatoryValidation, HeaderTemp."I6 Invoice ID", CorrelationId, ErrorText);

        if not CheckDuplicateInvoice(HeaderTemp."I6 Invoice ID", ErrorText) then
            LogInboundErrorAndFail(Setup, Enum::"UFC SI Error Stage"::Staging, HeaderTemp."I6 Invoice ID", CorrelationId, ErrorText);

        StoreValidatedPayload(HeaderTemp, LineTemp);
        UpdatePullResult(Setup, StrSubstNo('Received and staged i6 invoice %1.', HeaderTemp."I6 Invoice ID"));
        exit(BuildSuccessResponse(HeaderTemp, CorrelationId));
    end;

    [Obsolete('i6 now pushes the EOD payload to UFC SI Inbound Service. Use ReceiveInboundPayload instead.', '1.0.0.13')]
    procedure PullFromI6()
    var
        Setup: Record "UFC SI Integration Setup";
        HeaderTemp: Record "UFC SI Header Staging" temporary;
        LineTemp: Record "UFC SI Line Staging" temporary;
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
        CorrelationId: Text;
        ErrorText: Text;
        EndpointUrl: Text;
        HeaderName: Text;
        HeaderValue: Text;
        IsHandled: Boolean;
    begin
        Error('Pull from i6 is no longer supported. i6 must send the EOD payload to the UFC SI Inbound Service.');

        EnsureSetup(Setup);
        CorrelationId := Format(CreateGuid());

        if not Setup."Pull Enabled" then begin
            UpdatePullResult(Setup, 'Pull is disabled.');
            exit;
        end;

        if Setup."Endpoint URL" = '' then begin
            ErrorText := 'The i6 endpoint URL has not been configured.';
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Endpoint, '', 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        if Setup."Authorization Type" <> Enum::"UFC SI Authorization Type"::None then begin
            IsHandled := false;
            OnResolveAuthorizationHeader(Setup, HeaderName, HeaderValue, IsHandled);
            if not IsHandled then begin
                ErrorText := 'The authorization reference could not be resolved by the approved secure credential provider.';
                ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Endpoint, '', 0, CorrelationId, ErrorText);
                UpdatePullResult(Setup, ErrorText);
                exit;
            end;

            Client.DefaultRequestHeaders().Add(HeaderName, HeaderValue);
        end;

        EndpointUrl := GetEndpointUrl(Setup);
        if not Client.Get(EndpointUrl, Response) then begin
            ErrorText := 'Business Central could not connect to the configured i6 endpoint.';
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Endpoint, '', 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        if not Response.IsSuccessStatusCode() then begin
            ErrorText := StrSubstNo('The i6 endpoint returned HTTP status %1.', Response.HttpStatusCode());
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Endpoint, '', 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        Response.Content.ReadAs(ResponseText);
        if not BuildValidatedPayload(ResponseText, Setup."Default Source System", CorrelationId, HeaderTemp, LineTemp, ErrorText) then begin
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::MandatoryValidation, HeaderTemp."I6 Invoice ID", 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        if not CheckDuplicateInvoice(HeaderTemp."I6 Invoice ID", ErrorText) then begin
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Staging, HeaderTemp."I6 Invoice ID", 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        StoreValidatedPayload(HeaderTemp, LineTemp);
        UpdatePullResult(Setup, StrSubstNo('Staged i6 invoice %1.', HeaderTemp."I6 Invoice ID"));
    end;

    procedure ImportJsonFile(PayloadText: Text; FileName: Text)
    var
        Setup: Record "UFC SI Integration Setup";
        HeaderTemp: Record "UFC SI Header Staging" temporary;
        LineTemp: Record "UFC SI Line Staging" temporary;
        CorrelationId: Text;
        ErrorText: Text;
    begin
        EnsureSetup(Setup);
        CorrelationId := Format(CreateGuid());

        if not BuildValidatedPayload(PayloadText, Setup."Default Source System", CorrelationId, HeaderTemp, LineTemp, ErrorText) then begin
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::MandatoryValidation, HeaderTemp."I6 Invoice ID", 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        if not CheckDuplicateInvoice(HeaderTemp."I6 Invoice ID", ErrorText) then begin
            ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Staging, HeaderTemp."I6 Invoice ID", 0, CorrelationId, ErrorText);
            UpdatePullResult(Setup, ErrorText);
            exit;
        end;

        StoreValidatedPayload(HeaderTemp, LineTemp);
        UpdatePullResult(Setup, StrSubstNo('Uploaded file %1 staged i6 invoice %2.', FileName, HeaderTemp."I6 Invoice ID"));
    end;

    local procedure LogInboundErrorAndFail(var Setup: Record "UFC SI Integration Setup"; ErrorStage: Enum "UFC SI Error Stage"; InvoiceId: Code[20]; CorrelationId: Text; ErrorText: Text)
    begin
        ErrorMgt.LogError(ErrorStage, InvoiceId, 0, CorrelationId, ErrorText);
        UpdatePullResult(Setup, ErrorText);
        Commit();
        Error(ErrorText);
    end;

    local procedure BuildSuccessResponse(HeaderTemp: Record "UFC SI Header Staging" temporary; CorrelationId: Text): Text
    var
        ResponseJson: JsonObject;
        ResponseText: Text;
    begin
        ResponseJson.Add('status', 'Accepted');
        ResponseJson.Add('message', 'Mandatory validation passed and the invoice was stored in staging.');
        ResponseJson.Add('i6InvoiceId', HeaderTemp."I6 Invoice ID");
        ResponseJson.Add('correlationId', CorrelationId);
        ResponseJson.Add('stagingStatus', 'Open');
        ResponseJson.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    local procedure EnsureSetup(var Setup: Record "UFC SI Integration Setup")
    begin
        if Setup.Get('SETUP') then
            exit;

        Setup.Init();
        Setup."Primary Key" := 'SETUP';
        Setup.Insert(true);
    end;

    local procedure GetEndpointUrl(Setup: Record "UFC SI Integration Setup"): Text
    begin
        if Setup."Request Query" = '' then
            exit(Setup."Endpoint URL");

        if StrPos(Setup."Endpoint URL", '?') > 0 then
            exit(Setup."Endpoint URL" + '&' + Setup."Request Query");

        exit(Setup."Endpoint URL" + '?' + Setup."Request Query");
    end;

    local procedure UpdatePullResult(var Setup: Record "UFC SI Integration Setup"; Message: Text)
    begin
        Setup."Last Pull At" := CurrentDateTime();
        Setup."Last Pull Message" := CopyStr(Message, 1, MaxStrLen(Setup."Last Pull Message"));
        Setup.Modify(true);
    end;

    local procedure BuildValidatedPayload(ResponseText: Text; SourceSystem: Code[20]; CorrelationId: Text; var HeaderTemp: Record "UFC SI Header Staging" temporary; var LineTemp: Record "UFC SI Line Staging" temporary; var ErrorText: Text): Boolean
    var
        RootJson: JsonObject;
        HeaderJson: JsonObject;
        LineJson: JsonObject;
        BodyJson: JsonArray;
        JsonToken: JsonToken;
        ShipmentDateText: Text;
        RequiredText: Text;
        RequiredQuantity: Decimal;
        LineNo: Integer;
        Index: Integer;
    begin
        Clear(ErrorText);
        HeaderTemp.DeleteAll();
        LineTemp.DeleteAll();

        if not ReadInboundJson(ResponseText, RootJson) then begin
            ErrorText := 'The i6 request payload is not valid JSON.';
            exit(false);
        end;

        if not RootJson.Get('Header', JsonToken) then begin
            ErrorText := 'Header is missing from the i6 response.';
            exit(false);
        end;
        HeaderJson := JsonToken.AsObject();

        HeaderTemp.Init();
        HeaderTemp."Entry No." := 1;
        if not GetRequiredText(HeaderJson, 'OrderNumber', RequiredText, ErrorText) then
            exit(false);
        HeaderTemp."I6 Invoice ID" := CopyStr(RequiredText, 1, MaxStrLen(HeaderTemp."I6 Invoice ID"));
        if not GetRequiredText(HeaderJson, 'CustomerNumber', RequiredText, ErrorText) then
            exit(false);
        HeaderTemp."Customer No." := CopyStr(RequiredText, 1, MaxStrLen(HeaderTemp."Customer No."));
        if not GetRequiredText(HeaderJson, 'Orderdate', ShipmentDateText, ErrorText) then
            exit(false);
        if not Evaluate(HeaderTemp."Shipment Date", ShipmentDateText) then begin
            ErrorText := 'Header.Orderdate is not a valid date.';
            exit(false);
        end;
        if not GetRequiredText(HeaderJson, 'ExternalDocumentNo', RequiredText, ErrorText) then
            exit(false);
        HeaderTemp."External Document No." := CopyStr(RequiredText, 1, MaxStrLen(HeaderTemp."External Document No."));

        HeaderTemp."I6 VAT Code" := CopyStr(GetOptionalText(HeaderJson, 'VATPERN'), 1, MaxStrLen(HeaderTemp."I6 VAT Code"));
        HeaderTemp."Location Code" := CopyStr(GetOptionalText(HeaderJson, 'Location'), 1, MaxStrLen(HeaderTemp."Location Code"));
        HeaderTemp."Source System" := SourceSystem;
        HeaderTemp."Correlation ID" := CopyStr(CorrelationId, 1, MaxStrLen(HeaderTemp."Correlation ID"));
        HeaderTemp."Integration Status" := Enum::"UFC SI Integration Status"::Open;
        HeaderTemp."Received At" := CurrentDateTime();

        if not RootJson.Get('Body', JsonToken) then begin
            ErrorText := 'Body is missing from the i6 response.';
            exit(false);
        end;
        BodyJson := JsonToken.AsArray();
        if BodyJson.Count() = 0 then begin
            ErrorText := 'Body contains no sales invoice lines.';
            exit(false);
        end;

        for Index := 0 to BodyJson.Count() - 1 do begin
            BodyJson.Get(Index, JsonToken);
            LineJson := JsonToken.AsObject();
            LineTemp.Init();
            LineTemp."Entry No." := Index + 1;
            LineTemp."Header Entry No." := HeaderTemp."Entry No.";
            if not GetRequiredInteger(LineJson, 'LineItemNumber', LineNo, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp."I6 Line Item Number" := LineNo;
            if not GetRequiredText(LineJson, 'Item', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp."Item No." := CopyStr(RequiredText, 1, MaxStrLen(LineTemp."Item No."));
            if not GetRequiredText(LineJson, 'Description', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp.Description := CopyStr(RequiredText, 1, MaxStrLen(LineTemp.Description));
            if not GetRequiredText(LineJson, 'Location', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp."Location Code" := CopyStr(RequiredText, 1, MaxStrLen(LineTemp."Location Code"));
            if not GetRequiredDecimal(LineJson, 'QuantityOrdered', RequiredQuantity, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp.Quantity := RequiredQuantity;
            if not GetRequiredText(LineJson, 'PricingUnitOfMeasure', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp."Unit of Measure Code" := CopyStr(RequiredText, 1, MaxStrLen(LineTemp."Unit of Measure Code"));
            if not GetRequiredText(LineJson, 'TicketNo', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp."Ticket No." := CopyStr(RequiredText, 1, MaxStrLen(LineTemp."Ticket No."));
            if not GetRequiredText(LineJson, 'Destination', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp.Destination := CopyStr(RequiredText, 1, MaxStrLen(LineTemp.Destination));
            if not GetRequiredText(LineJson, 'AircraftRegistration', RequiredText, ErrorText) then begin
                ErrorText := StrSubstNo('Body[%1]: %2', Index + 1, ErrorText);
                exit(false);
            end;
            LineTemp.Registration := CopyStr(RequiredText, 1, MaxStrLen(LineTemp.Registration));
            LineTemp."Flight No." := CopyStr(GetOptionalText(LineJson, 'FlightCode'), 1, MaxStrLen(LineTemp."Flight No."));
            LineTemp."Aircraft Type" := CopyStr(GetOptionalText(LineJson, 'AircraftType'), 1, MaxStrLen(LineTemp."Aircraft Type"));
            LineTemp."Sub Customer" := 'NA';
            LineTemp."Integration Status" := Enum::"UFC SI Integration Status"::Open;
            LineTemp.Insert();
        end;

        HeaderTemp.Insert();
        exit(true);
    end;

    local procedure ReadInboundJson(PayloadText: Text; var RootJson: JsonObject): Boolean
    var
        PayloadToken: JsonToken;
    begin
        if RootJson.ReadFrom(PayloadText) then
            exit(true);

        if not PayloadToken.ReadFrom(PayloadText) then
            exit(false);
        if not PayloadToken.IsValue() then
            exit(false);

        exit(RootJson.ReadFrom(PayloadToken.AsValue().AsText()));
    end;

    local procedure GetRequiredText(JsonObject: JsonObject; PropertyName: Text; var Value: Text; var ErrorText: Text): Boolean
    var
        JsonToken: JsonToken;
    begin
        Clear(Value);
        if not JsonObject.Get(PropertyName, JsonToken) then begin
            ErrorText := StrSubstNo('%1 is missing.', PropertyName);
            exit(false);
        end;

        Value := JsonToken.AsValue().AsText();
        if Value = '' then begin
            ErrorText := StrSubstNo('%1 is blank.', PropertyName);
            exit(false);
        end;

        exit(true);
    end;

    local procedure GetOptionalText(JsonObject: JsonObject; PropertyName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JsonToken) then
            exit(JsonToken.AsValue().AsText());
    end;

    local procedure GetRequiredInteger(JsonObject: JsonObject; PropertyName: Text; var Value: Integer; var ErrorText: Text): Boolean
    var
        JsonToken: JsonToken;
    begin
        Clear(Value);
        if not JsonObject.Get(PropertyName, JsonToken) then begin
            ErrorText := StrSubstNo('%1 is missing.', PropertyName);
            exit(false);
        end;

        Value := JsonToken.AsValue().AsInteger();
        if Value = 0 then begin
            ErrorText := StrSubstNo('%1 is zero or blank.', PropertyName);
            exit(false);
        end;

        exit(true);
    end;

    local procedure GetRequiredDecimal(JsonObject: JsonObject; PropertyName: Text; var Value: Decimal; var ErrorText: Text): Boolean
    var
        JsonToken: JsonToken;
    begin
        Clear(Value);
        if not JsonObject.Get(PropertyName, JsonToken) then begin
            ErrorText := StrSubstNo('%1 is missing.', PropertyName);
            exit(false);
        end;

        Value := JsonToken.AsValue().AsDecimal();
        if Value = 0 then begin
            ErrorText := StrSubstNo('%1 is zero or blank.', PropertyName);
            exit(false);
        end;

        exit(true);
    end;

    local procedure CheckDuplicateInvoice(InvoiceId: Code[20]; var ErrorText: Text): Boolean
    var
        HeaderStaging: Record "UFC SI Header Staging";
        SalesHeader: Record "Sales Header";
    begin
        HeaderStaging.SetRange("I6 Invoice ID", InvoiceId);
        if HeaderStaging.FindFirst() then begin
            ErrorText := StrSubstNo('i6 invoice %1 already exists in staging.', InvoiceId);
            exit(false);
        end;

        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, InvoiceId) then begin
            ErrorText := StrSubstNo('A Business Central sales invoice already exists for i6 invoice %1.', InvoiceId);
            exit(false);
        end;

        exit(true);
    end;

    local procedure StoreValidatedPayload(HeaderTemp: Record "UFC SI Header Staging" temporary; var LineTemp: Record "UFC SI Line Staging" temporary)
    var
        HeaderStaging: Record "UFC SI Header Staging";
        LineStaging: Record "UFC SI Line Staging";
    begin
        HeaderStaging.Init();
        HeaderStaging."I6 Invoice ID" := HeaderTemp."I6 Invoice ID";
        HeaderStaging."Customer No." := HeaderTemp."Customer No.";
        HeaderStaging."Shipment Date" := HeaderTemp."Shipment Date";
        HeaderStaging."External Document No." := HeaderTemp."External Document No.";
        HeaderStaging."I6 VAT Code" := HeaderTemp."I6 VAT Code";
        HeaderStaging."Location Code" := HeaderTemp."Location Code";
        HeaderStaging."Integration Status" := Enum::"UFC SI Integration Status"::Open;
        HeaderStaging."Received At" := HeaderTemp."Received At";
        HeaderStaging."Source System" := HeaderTemp."Source System";
        HeaderStaging."Correlation ID" := HeaderTemp."Correlation ID";
        HeaderStaging.Insert(true);

        if LineTemp.FindSet() then
            repeat
                LineStaging.Init();
                LineStaging."Header Entry No." := HeaderStaging."Entry No.";
                LineStaging."I6 Line Item Number" := LineTemp."I6 Line Item Number";
                LineStaging."Item No." := LineTemp."Item No.";
                LineStaging.Description := LineTemp.Description;
                LineStaging."Location Code" := LineTemp."Location Code";
                LineStaging.Quantity := LineTemp.Quantity;
                LineStaging."Unit of Measure Code" := LineTemp."Unit of Measure Code";
                LineStaging."Ticket No." := LineTemp."Ticket No.";
                LineStaging.Destination := LineTemp.Destination;
                LineStaging.Registration := LineTemp.Registration;
                LineStaging."Flight No." := LineTemp."Flight No.";
                LineStaging."Sub Customer" := LineTemp."Sub Customer";
                LineStaging."Aircraft Type" := LineTemp."Aircraft Type";
                LineStaging."Integration Status" := Enum::"UFC SI Integration Status"::Open;
                LineStaging.Insert(true);
            until LineTemp.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnResolveAuthorizationHeader(Setup: Record "UFC SI Integration Setup"; var HeaderName: Text; var HeaderValue: Text; var IsHandled: Boolean)
    begin
    end;

    var
        ErrorMgt: Codeunit "UFC SI Error Mgt";
}
