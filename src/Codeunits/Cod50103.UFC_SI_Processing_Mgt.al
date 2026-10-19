codeunit 50103 "UFC SI Processing Mgt"
{
    procedure ProcessOpenEntries()
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("Integration Status", Enum::"UFC SI Integration Status"::Open);
        if HeaderStaging.FindSet(true) then
            repeat
                ProcessEntry(HeaderStaging);
            until HeaderStaging.Next() = 0;
    end;

    procedure FailedEntryCount(): Integer
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("Integration Status", Enum::"UFC SI Integration Status"::Failed);
        exit(HeaderStaging.Count());
    end;

    procedure ResetFailedEntries(): Integer
    var
        HeaderStaging: Record "UFC SI Header Staging";
        ResetCount: Integer;
    begin
        HeaderStaging.SetRange("Integration Status", Enum::"UFC SI Integration Status"::Failed);
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
        if HeaderStaging."Integration Status" <> Enum::"UFC SI Integration Status"::Open then
            exit;

        if not ValidateReferenceData(HeaderStaging, ErrorText) then begin
            MarkFailed(HeaderStaging, ErrorText);
            exit;
        end;

        HeaderStaging."Integration Status" := Enum::"UFC SI Integration Status"::Processing;
        HeaderStaging."Error Message" := '';
        HeaderStaging.Modify(true);

        if not Codeunit.Run(Codeunit::"UFC SI Create Invoice", HeaderStaging) then begin
            HeaderStaging.Get(HeaderStaging."Entry No.");
            MarkFailed(HeaderStaging, GetLastErrorText());
            exit;
        end;

        HeaderStaging.Get(HeaderStaging."Entry No.");
        HeaderStaging."Integration Status" := Enum::"UFC SI Integration Status"::Success;
        HeaderStaging."Error Message" := '';
        HeaderStaging."Processed At" := CurrentDateTime();
        HeaderStaging.Modify(true);
        MarkLinesSuccessful(HeaderStaging."Entry No.");
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
        if not Customer.Get(HeaderStaging."Customer No.") then begin
            ErrorText := StrSubstNo('Customer %1 does not exist in Business Central.', HeaderStaging."Customer No.");
            exit(false);
        end;

        if not Location.Get(HeaderStaging."Location Code") then begin
            ErrorText := StrSubstNo('Header location %1 does not exist in Business Central.', HeaderStaging."Location Code");
            exit(false);
        end;

        if not VATMapping.Get(HeaderStaging."I6 VAT Code") then begin
            ErrorText := StrSubstNo('No VAT mapping is configured for i6 VAT code %1.', HeaderStaging."I6 VAT Code");
            exit(false);
        end;

        if not VATBusinessPostingGroup.Get(VATMapping."VAT Business Posting Group") then begin
            ErrorText := StrSubstNo('VAT Business Posting Group %1 does not exist in Business Central.', VATMapping."VAT Business Posting Group");
            exit(false);
        end;

        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, HeaderStaging."I6 Invoice ID") then begin
            ErrorText := StrSubstNo('A Business Central sales invoice already exists for i6 invoice %1.', HeaderStaging."I6 Invoice ID");
            exit(false);
        end;

        if HydrantLocation.Get(HeaderStaging."Location Code") then
            if HydrantLocation."Auto Purchase Enabled" and (HydrantLocation."Vendor No." = '') then begin
                ErrorText := StrSubstNo('Hydrant location %1 has auto purchase enabled but no vendor is configured.', HeaderStaging."Location Code");
                exit(false);
            end;

        LineStaging.SetRange("Header Entry No.", HeaderStaging."Entry No.");
        if not LineStaging.FindSet() then begin
            ErrorText := 'No line staging records exist for the sales invoice header.';
            exit(false);
        end;

        repeat
            if not Item.Get(LineStaging."Item No.") then begin
                ErrorText := StrSubstNo('Line %1: item %2 does not exist in Business Central.', LineStaging."I6 Line Item Number", LineStaging."Item No.");
                exit(false);
            end;

            if not Location.Get(LineStaging."Location Code") then begin
                ErrorText := StrSubstNo('Line %1: location %2 does not exist in Business Central.', LineStaging."I6 Line Item Number", LineStaging."Location Code");
                exit(false);
            end;

            if not ItemUnitOfMeasure.Get(LineStaging."Item No.", LineStaging."Unit of Measure Code") then begin
                ErrorText := StrSubstNo('Line %1: unit of measure %2 is not configured for item %3.', LineStaging."I6 Line Item Number", LineStaging."Unit of Measure Code", LineStaging."Item No.");
                exit(false);
            end;
        until LineStaging.Next() = 0;

        HeaderStaging."VAT Business Posting Group" := VATMapping."VAT Business Posting Group";
        HeaderStaging.Modify(true);
        exit(true);
    end;

    local procedure MarkFailed(var HeaderStaging: Record "UFC SI Header Staging"; ErrorText: Text)
    var
        LineStaging: Record "UFC SI Line Staging";
    begin
        HeaderStaging."Integration Status" := Enum::"UFC SI Integration Status"::Failed;
        HeaderStaging."Error Message" := CopyStr(ErrorText, 1, MaxStrLen(HeaderStaging."Error Message"));
        HeaderStaging."Processed At" := CurrentDateTime();
        HeaderStaging.Modify(true);

        LineStaging.SetRange("Header Entry No.", HeaderStaging."Entry No.");
        if LineStaging.FindSet(true) then
            repeat
                LineStaging."Integration Status" := Enum::"UFC SI Integration Status"::Failed;
                LineStaging."Error Message" := CopyStr(ErrorText, 1, MaxStrLen(LineStaging."Error Message"));
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;

        ErrorMgt.LogError(Enum::"UFC SI Error Stage"::Processing, HeaderStaging."I6 Invoice ID", HeaderStaging."Entry No.", HeaderStaging."Correlation ID", ErrorText);
    end;

    local procedure ResetFailedEntry(var HeaderStaging: Record "UFC SI Header Staging")
    var
        LineStaging: Record "UFC SI Line Staging";
    begin
        HeaderStaging."Integration Status" := Enum::"UFC SI Integration Status"::Open;
        HeaderStaging."Error Message" := '';
        HeaderStaging."Processed At" := 0DT;
        HeaderStaging.Modify(true);

        LineStaging.SetRange("Header Entry No.", HeaderStaging."Entry No.");
        if LineStaging.FindSet(true) then
            repeat
                LineStaging."Integration Status" := Enum::"UFC SI Integration Status"::Open;
                LineStaging."Error Message" := '';
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;
    end;

    local procedure MarkLinesSuccessful(HeaderEntryNo: Integer)
    var
        LineStaging: Record "UFC SI Line Staging";
    begin
        LineStaging.SetRange("Header Entry No.", HeaderEntryNo);
        if LineStaging.FindSet(true) then
            repeat
                LineStaging."Integration Status" := Enum::"UFC SI Integration Status"::Success;
                LineStaging."Error Message" := '';
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;
    end;

    var
        ErrorMgt: Codeunit "UFC SI Error Mgt";
}
