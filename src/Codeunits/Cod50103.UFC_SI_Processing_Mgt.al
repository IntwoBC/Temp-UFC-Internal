codeunit 50103 "UFC SI Processing Mgt"
{
    procedure ProcessOpenEntries()
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("I2I Integration Status", Enum::"UFC SI Integration Status"::Open);
        if HeaderStaging.FindSet(true) then
            repeat
                ProcessEntry(HeaderStaging);
            until HeaderStaging.Next() = 0;
    end;

    procedure FailedEntryCount(): Integer
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("I2I Integration Status", Enum::"UFC SI Integration Status"::Failed);
        exit(HeaderStaging.Count());
    end;

    procedure ResetFailedEntries(): Integer
    var
        HeaderStaging: Record "UFC SI Header Staging";
        ResetCount: Integer;
    begin
        HeaderStaging.SetRange("I2I Integration Status", Enum::"UFC SI Integration Status"::Failed);
        while HeaderStaging.FindFirst() do begin
            ResetFailedEntry(HeaderStaging);
            ResetCount += 1;
        end;

        exit(ResetCount);
    end;

    procedure ProcessEntry(var HeaderStaging: Record "UFC SI Header Staging")
    var
        ErrorText: Text;
    begin
        if HeaderStaging."I2I Integration Status" <> Enum::"UFC SI Integration Status"::Open then
            exit;

        if not ValidateReferenceData(HeaderStaging, ErrorText) then begin
            MarkFailed(HeaderStaging, ErrorText);
            exit;
        end;

        HeaderStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Processing;
        HeaderStaging."I2I Error Message" := '';
        HeaderStaging.Modify(true);

        if not Codeunit.Run(Codeunit::"UFC SI Create Invoice", HeaderStaging) then begin
            HeaderStaging.Get(HeaderStaging."I2I Entry No.");
            MarkFailed(HeaderStaging, GetLastErrorText());
            exit;
        end;

        HeaderStaging.Get(HeaderStaging."I2I Entry No.");
        HeaderStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Success;
        HeaderStaging."I2I Error Message" := '';
        HeaderStaging."I2I Processed At" := CurrentDateTime();
        HeaderStaging.Modify(true);
        MarkLinesSuccessful(HeaderStaging."I2I Entry No.");
    end;

    local procedure ValidateReferenceData(var HeaderStaging: Record "UFC SI Header Staging"; var ErrorText: Text): Boolean
    var
        Customer: Record Customer;
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        Location: Record Location;
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
        VATMapping: Record "UFC SI VAT Mapping";
        HydrantLocation: Record "UFC SI Hydrant Location";
        LineStaging: Record "UFC SI Line Staging";
        SalesHeader: Record "Sales Header";
    begin
        Clear(ErrorText);
        if not Customer.Get(HeaderStaging."I2I Customer No.") then begin
            ErrorText := StrSubstNo('Customer %1 does not exist in Business Central.', HeaderStaging."I2I Customer No.");
            exit(false);
        end;

        if not Location.Get(HeaderStaging."I2I Location Code") then begin
            ErrorText := StrSubstNo('Header location %1 does not exist in Business Central.', HeaderStaging."I2I Location Code");
            exit(false);
        end;

        if not VATMapping.Get(HeaderStaging."I2I I6 VAT Code") then begin
            ErrorText := StrSubstNo('No VAT mapping is configured for i6 VAT code %1.', HeaderStaging."I2I I6 VAT Code");
            exit(false);
        end;

        if not VATBusinessPostingGroup.Get(VATMapping."I2I VAT Bus. Posting Group") then begin
            ErrorText := StrSubstNo('VAT Business Posting Group %1 does not exist in Business Central.', VATMapping."I2I VAT Bus. Posting Group");
            exit(false);
        end;

        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, HeaderStaging."I2I I6 Invoice ID") then begin
            ErrorText := StrSubstNo('A Business Central sales invoice already exists for i6 invoice %1.', HeaderStaging."I2I I6 Invoice ID");
            exit(false);
        end;

        if HydrantLocation.Get(HeaderStaging."I2I Location Code") then
            if HydrantLocation."I2I Auto Purchase Enabled" and (HydrantLocation."I2I Vendor No." = '') then begin
                ErrorText := StrSubstNo('Hydrant location %1 has auto purchase enabled but no vendor is configured.', HeaderStaging."I2I Location Code");
                exit(false);
            end;

        LineStaging.SetRange("I2I Header Entry No.", HeaderStaging."I2I Entry No.");
        if not LineStaging.FindSet() then begin
            ErrorText := 'No line staging records exist for the sales invoice header.';
            exit(false);
        end;

        repeat
            if not Item.Get(LineStaging."I2I Item No.") then begin
                ErrorText := StrSubstNo('Line %1: item %2 does not exist in Business Central.', LineStaging."I2I I6 Line Item Number", LineStaging."I2I Item No.");
                exit(false);
            end;

            if not Location.Get(LineStaging."I2I Location Code") then begin
                ErrorText := StrSubstNo('Line %1: location %2 does not exist in Business Central.', LineStaging."I2I I6 Line Item Number", LineStaging."I2I Location Code");
                exit(false);
            end;

            if not ItemUnitOfMeasure.Get(LineStaging."I2I Item No.", LineStaging."I2I Unit of Measure Code") then begin
                ErrorText := StrSubstNo('Line %1: unit of measure %2 is not configured for item %3.', LineStaging."I2I I6 Line Item Number", LineStaging."I2I Unit of Measure Code", LineStaging."I2I Item No.");
                exit(false);
            end;
        until LineStaging.Next() = 0;

        HeaderStaging."I2I VAT Business Posting Group" := VATMapping."I2I VAT Bus. Posting Group";
        HeaderStaging.Modify(true);
        exit(true);
    end;

    local procedure MarkFailed(var HeaderStaging: Record "UFC SI Header Staging"; ErrorText: Text)
    var
        LineStaging: Record "UFC SI Line Staging";
    begin
        HeaderStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Failed;
        HeaderStaging."I2I Error Message" := CopyStr(ErrorText, 1, MaxStrLen(HeaderStaging."I2I Error Message"));
        HeaderStaging."I2I Processed At" := CurrentDateTime();
        HeaderStaging.Modify(true);

        LineStaging.SetRange("I2I Header Entry No.", HeaderStaging."I2I Entry No.");
        if LineStaging.FindSet(true) then
            repeat
                LineStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Failed;
                LineStaging."I2I Error Message" := CopyStr(ErrorText, 1, MaxStrLen(LineStaging."I2I Error Message"));
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;

        ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Processing, HeaderStaging."I2I I6 Invoice ID", HeaderStaging."I2I Entry No.", HeaderStaging."I2I Correlation ID", ErrorText);
    end;

    local procedure ResetFailedEntry(var HeaderStaging: Record "UFC SI Header Staging")
    var
        LineStaging: Record "UFC SI Line Staging";
    begin
        HeaderStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Open;
        HeaderStaging."I2I Error Message" := '';
        HeaderStaging."I2I Processed At" := 0DT;
        HeaderStaging.Modify(true);

        LineStaging.SetRange("I2I Header Entry No.", HeaderStaging."I2I Entry No.");
        if LineStaging.FindSet(true) then
            repeat
                LineStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Open;
                LineStaging."I2I Error Message" := '';
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;
    end;

    local procedure MarkLinesSuccessful(HeaderEntryNo: Integer)
    var
        LineStaging: Record "UFC SI Line Staging";
    begin
        LineStaging.SetRange("I2I Header Entry No.", HeaderEntryNo);
        if LineStaging.FindSet(true) then
            repeat
                LineStaging."I2I Integration Status" := Enum::"UFC SI Integration Status"::Success;
                LineStaging."I2I Error Message" := '';
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;
    end;

    var
        ErrorMgt: Codeunit "UFC SI Error Mgt";
}
