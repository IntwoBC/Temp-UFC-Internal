codeunit 50107 "I2I-I6 Purchase Order Import"
{
    trigger OnRun()
    var
        ErrorMgt: Codeunit "UFC SI Error Mgt";
    begin
        StagePurchasePayload(PurchasePayload, StagedOrderNumber, StagedHeaderEntryNo);
        ErrorMgt.LogPurchaseEvent(Enum::"UFC SI Error Stage"::Staging, StagedOrderNumber, StagedHeaderEntryNo, PayloadCorrelationId, 'Payload staged successfully.');
    end;

    procedure SetPurchasePayload(JsonText: Text; CorrelationId: Text)
    begin
        PurchasePayload := JsonText;
        PayloadCorrelationId := CorrelationId;
        Clear(StagedOrderNumber);
        Clear(StagedHeaderEntryNo);
    end;

    procedure GetStagedHeaderEntryNo(): Integer
    begin
        exit(StagedHeaderEntryNo);
    end;

    local procedure ProcessPurchasePayload(JsonText: Text; OrderNumber: Code[20]; CorrelationId: Text)
    var
        PurchaseHeaderStaging: Record "I2I Purchase Order Hdr Staging";
        VendorNumber: Code[20];
        DocumentDate: Date;
        LineArray: JsonArray;
        HeaderEntryNo: Integer;
        ErrorMessageL: Text[2048];
        ProcessPurchaseOrder: Codeunit "I2I UFC Purch. Order Process.";
        PurchaseImport: Codeunit "I2I-I6 Purchase Order Import";
        ErrorMgt: Codeunit "UFC SI Error Mgt";
    begin
        ClearLastError();
        if not TryReadPurchasePayload(JsonText, OrderNumber, VendorNumber, DocumentDate, LineArray) then begin
            ErrorMessageL := CopyStr(GetLastErrorText(), 1, MaxStrLen(ErrorMessageL));
            if ErrorMessageL = '' then
                ErrorMessageL := 'Purchase payload validation failed.';
            ErrorMgt.LogPurchaseEvent(Enum::"UFC SI Error Stage"::MandatoryValidation, OrderNumber, 0, CorrelationId, ErrorMessageL);
            Commit();
            Error(ErrorMessageL);
        end;

        PurchaseImport.SetPurchasePayload(JsonText, CorrelationId);
        ClearLastError();
        if not PurchaseImport.Run() then begin
            ErrorMessageL := CopyStr(GetLastErrorText(), 1, MaxStrLen(ErrorMessageL));
            if ErrorMessageL = '' then
                ErrorMessageL := 'Purchase payload staging failed.';
            ErrorMgt.LogPurchaseEvent(Enum::"UFC SI Error Stage"::Staging, OrderNumber, 0, CorrelationId, ErrorMessageL);
            Commit();
            Error(ErrorMessageL);
        end;

        HeaderEntryNo := PurchaseImport.GetStagedHeaderEntryNo();
        PurchaseHeaderStaging.Get(HeaderEntryNo);
        ProcessPurchaseOrder.CreatePurchaseOrder(PurchaseHeaderStaging, CorrelationId);
    end;

    [TryFunction]
    local procedure TryReadPurchasePayload(JsonText: Text; var OrderNumber: Code[20]; var VendorNumber: Code[20]; var DocumentDate: Date; var LineArray: JsonArray)
    begin
        ValidatePurchasePayload(JsonText, OrderNumber, VendorNumber, DocumentDate, LineArray);
    end;

    [ServiceEnabled]
    procedure ReceivePurchasePayload(JsonText: Text)
    var
        JSONObjectL: JsonObject;
        ErrorMgt: Codeunit "UFC SI Error Mgt";
        i6OrderNumber: Code[20];
        CorrelationId: Text;
    begin

        if JSONObjectL.ReadFrom(JsonText) then
            TryGetOrderNumber(JSONObjectL, i6OrderNumber);

        CorrelationId := Format(CreateGuid());
        ErrorMgt.LogPurchaseEvent(Enum::"UFC SI Error Stage"::Endpoint, i6OrderNumber, 0, CorrelationId, 'Payload received.');
        Commit();

        ProcessPurchasePayload(JsonText, i6OrderNumber, CorrelationId);
    end;

    local procedure TryGetOrderNumber(PurchasePayload: JsonObject; var OrderNumber: Code[20])
    var
        JsonTokenL: JsonToken;
        HeaderObjectL: JsonObject;
    begin
        if not PurchasePayload.Get('Header', JsonTokenL) then
            exit;
        if not JsonTokenL.IsObject() then
            exit;
        HeaderObjectL := JsonTokenL.AsObject();
        if HeaderObjectL.Get('OrderNumber', JsonTokenL) then
            if JsonTokenL.IsValue() then
                if not (JsonTokenL.AsValue().IsNull() or JsonTokenL.AsValue().IsUndefined()) then
                    OrderNumber := CopyStr(JsonTokenL.AsValue().AsText(), 1, MaxStrLen(OrderNumber));
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure StagePurchasePayload(JsonText: Text; var i6OrderNumber: Code[20]; var HeaderEntryNo: Integer)
    var
        VendorNumberL: Code[20];
        DocumentDateL: Date;
        LineArrayL: JsonArray;
    begin
        ValidatePurchasePayload(JsonText, i6OrderNumber, VendorNumberL, DocumentDateL, LineArrayL);
        InsertStagingHeader(i6OrderNumber, VendorNumberL, DocumentDateL, HeaderEntryNo, LineArrayL);
    end;

    local procedure ValidatePurchasePayload(JsonText: Text; var i6OrderNumber: Code[20]; var VendorNumber: Code[20]; var DocumentDate: Date; var LineArray: JsonArray)
    var
        PurchasePayloadL: JsonObject;
    begin
        if JsonText = '' then
            Error('Purchase payload is required.');
        if not PurchasePayloadL.ReadFrom(JsonText) then
            Error('Invalid purchase payload JSON.');
        ValidatePayloadFields(PurchasePayloadL, i6OrderNumber, VendorNumber, DocumentDate, LineArray);
    end;

    local procedure ValidatePayloadFields(PurchasePayload: JsonObject; var i6OrderNumber: Code[20]; var VendorNumber: Code[20]; var DocumentDate: Date; var LineArrayL: JsonArray): Boolean
    var
        JsonTokenL: JsonToken;
        VendorRec: Record Vendor;
        LineObjectL: JsonObject;
        i: Integer;
        ItemRec: Record Item;
        LocationRec: Record Location;
        OrderNumberTextL: Text;
        IdentifierTextL: Text;
        UOMTextL: Text;
        QuantityL: Decimal;
        HeaderObjectL: JsonObject;
    begin
        if not PurchasePayload.Get('Header', JsonTokenL) then
            Error('Header is required.');
        if not JsonTokenL.IsObject() then
            Error('Header must be an object.');
        HeaderObjectL := JsonTokenL.AsObject();

        if not HeaderObjectL.Get('OrderNumber', JsonTokenL) then
            Error('Order number is required and must not exceed 20 characters.');
        OrderNumberTextL := JsonTokenL.AsValue().AsText();
        if (OrderNumberTextL = '') or (StrLen(OrderNumberTextL) > 20) or (JsonTokenL.AsValue().AsCode() = '') then
            Error('Order number is required and must not exceed 20 characters.');
        i6OrderNumber := JsonTokenL.AsValue().AsCode();

        if not HeaderObjectL.Get('VendorNumber', JsonTokenL) then
            Error('Vendor number is required and must exist in the Vendor table.');
        IdentifierTextL := JsonTokenL.AsValue().AsText();
        if (IdentifierTextL = '') or (StrLen(IdentifierTextL) > 20) then
            Error('Vendor number is required and must exist in the Vendor table.');
        if (Format(JsonTokenL.AsValue().AsCode()) = '') or (not VendorRec.Get(JsonTokenL.AsValue().AsCode())) then
            Error('Vendor number is required and must exist in the Vendor table.');
        VendorNumber := JsonTokenL.AsValue().AsCode();

        if not HeaderObjectL.Get('POdate', JsonTokenL) then
            Error('PO date is required.');
        if JsonTokenL.AsValue().AsDate() = 0D then
            Error('PO date is required.');
        DocumentDate := JsonTokenL.AsValue().AsDate();

        if not PurchasePayload.Get('Body', JsonTokenL) then
            Error('Body is required.');

        if not JsonTokenL.IsArray then
            Error('Body must be an array.');

        LineArrayL := PurchasePayload.GetArray('Body');
        if LineArrayL.Count = 0 then
            Error('Body must contain at least one purchase order line.');

        for i := 0 to LineArrayL.Count - 1 do begin
            LineObjectL := LineArrayL.GetObject(i);

            if not LineObjectL.Get('LineNo', JsonTokenL) then
                Error('Line number is required.');
            if JsonTokenL.AsValue().AsInteger() <= 0 then
                Error('Line number must be greater than zero.');

            if not LineObjectL.Get('Item', JsonTokenL) then
                Error('Item number is required and must exist in the Item table.');
            IdentifierTextL := JsonTokenL.AsValue().AsText();
            if (IdentifierTextL = '') or (StrLen(IdentifierTextL) > 20) then
                Error('Item number is required and must exist in the Item table.');
            if (Format(JsonTokenL.AsValue().AsCode()) = '') or (not ItemRec.Get(JsonTokenL.AsValue().AsCode())) then
                Error('Item number is required and must exist in the Item table.');

            if not LineObjectL.Get('Location', JsonTokenL) then
                Error('Location code is required and must exist in the Location table.');
            IdentifierTextL := JsonTokenL.AsValue().AsText();
            if (IdentifierTextL = '') or (StrLen(IdentifierTextL) > 20) then
                Error('Location code is required and must exist in the Location table.');
            if (Format(JsonTokenL.AsValue().AsCode()) = '') or (not LocationRec.Get(JsonTokenL.AsValue().AsCode())) then
                Error('Location code is required and must exist in the Location table.');

            if not LineObjectL.Get('QuantityRecieved', JsonTokenL) then
                Error('Quantity received must be greater than zero.');
            QuantityL := JsonTokenL.AsValue().AsDecimal();
            if QuantityL <= 0 then
                Error('Quantity received must be greater than zero.');

            if not LineObjectL.Get('UnitOfMeasure', JsonTokenL) then
                Error('Unit of measure is required.');
            UOMTextL := JsonTokenL.AsValue().AsText();
            if (UOMTextL = '') or (StrLen(UOMTextL) > 10) or (JsonTokenL.AsValue().AsCode() = '') then
                Error('Unit of measure is required and must not exceed 10 characters.');
        end;

        exit(true);
    end;

    procedure InsertStagingHeader(var i6OrderNumber: Code[20]; var VendorNumber: Code[20]; var DocumentDate: Date; var HeaderEntryNo: Integer; var LineArray: JsonArray)
    var
        PurchaseHdr: Record "I2I Purchase Order Hdr Staging";
        EntryNo: Integer;
        i: Integer;
        LineObjectL: JsonObject;
        JSONValueL: JsonToken;
        i6LineNo: Integer;
        ItemNo: Code[20];
        Location: Code[20];
        Quantity: Decimal;
        UOMCode: Code[20];
    begin
        EntryNo := 0;
        i := 0;

        PurchaseHdr.LockTable();
        if PurchaseHdr.FindLast() then
            EntryNo := PurchaseHdr."I2I Entry No." + 1
        else
            EntryNo := 1;

        PurchaseHdr.Init();
        PurchaseHdr."I2I Entry No." := EntryNo;
        PurchaseHdr."I2I i6 Order Number" := i6OrderNumber;
        PurchaseHdr."I2I Vendor Number" := VendorNumber;
        PurchaseHdr."I2I Document Date" := DocumentDate;
        PurchaseHdr."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Pending;
        PurchaseHdr.Insert();

        HeaderEntryNo := PurchaseHdr."I2I Entry No.";

        for i := 0 to LineArray.Count - 1 do begin
            Clear(i6LineNo);
            Clear(ItemNo);
            Clear(Location);
            Clear(Quantity);
            Clear(UOMCode);
            LineObjectL := LineArray.GetObject(i);
            if not LineObjectL.Get('LineNo', JSONValueL) then
                Error('Line number is required.');
            i6LineNo := JSONValueL.AsValue().AsInteger();
            if not LineObjectL.Get('Item', JSONValueL) then
                Error('Item number is required.');
            ItemNo := JSONValueL.AsValue().AsCode();
            if not LineObjectL.Get('Location', JSONValueL) then
                Error('Location code is required.');
            Location := JSONValueL.AsValue().AsCode();
            if not LineObjectL.Get('QuantityRecieved', JSONValueL) then
                Error('Quantity received is required.');
            Quantity := JSONValueL.AsValue().AsDecimal();
            if not LineObjectL.Get('UnitOfMeasure', JSONValueL) then
                Error('Unit of measure is required.');
            UOMCode := JSONValueL.AsValue().AsCode();

            InsertStagingLine(HeaderEntryNo, i6LineNo, ItemNo, Location, Quantity, UOMCode);
        end;

        PurchaseHdr."I2I Processed At" := CurrentDateTime();
        PurchaseHdr.Modify();
    end;

    procedure InsertStagingLine(HeaderEntryNo: Integer; LineNo: Integer; ItemNo: Code[20]; LocationCode: Code[20]; Quantity: Decimal; UOMCode: Code[20])
    var
        PurchaseLine: Record "I2I Purchase Order Line Stag.";
        EntryNo: Integer;
    begin
        PurchaseLine.LockTable();
        PurchaseLine.SetRange("I2I Header Entry No.", HeaderEntryNo);
        PurchaseLine.SetRange("I2I i6 Line No.", LineNo);
        if PurchaseLine.FindFirst() then begin
            if (PurchaseLine."I2I Item No." <> ItemNo) or
               (PurchaseLine."I2I Location Code" <> LocationCode) or
               (PurchaseLine."I2I Unit of Measure Code" <> UOMCode) then
                Error('A staged line already exists with different item, location, or unit of measure values.');

            PurchaseLine."I2I Quantity" += Quantity;
            PurchaseLine.Modify();
            exit;
        end;

        EntryNo := 0;
        PurchaseLine.Reset();
        if PurchaseLine.FindLast() then
            EntryNo := PurchaseLine."I2I Entry No." + 1
        else
            EntryNo := 1;

        PurchaseLine.Init();
        PurchaseLine."I2I Entry No." := EntryNo;
        PurchaseLine."I2I Header Entry No." := HeaderEntryNo;
        PurchaseLine."I2I i6 Line No." := LineNo;
        PurchaseLine."I2I Item No." := ItemNo;
        PurchaseLine."I2I Location Code" := LocationCode;
        PurchaseLine."I2I Quantity" := Quantity;
        PurchaseLine."I2I Unit of Measure Code" := UOMCode;
        PurchaseLine."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Pending;
        PurchaseLine.Insert();
    end;

    var
        PurchasePayload: Text;
        PayloadCorrelationId: Text;
        StagedOrderNumber: Code[20];
        StagedHeaderEntryNo: Integer;
}
