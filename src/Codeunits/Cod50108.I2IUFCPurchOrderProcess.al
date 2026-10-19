codeunit 50108 "I2I UFC Purch. Order Process."
{
    TableNo = "I2I Purchase Order Hdr Staging";

    Permissions = tabledata "Purchase Header" = RIMD,
                  tabledata "Purchase Line" = RIMD,
                  tabledata "I2I Purchase Order Hdr Staging" = RIMD,
                  tabledata "I2I Purchase Order Line Stag." = RIMD;

    trigger OnRun()
    var
        PurchaseOrder: Record "Purchase Header";
        PurchaseLineStaging: Record "I2I Purchase Order Line Stag.";
        ErrorMgt: Codeunit "UFC SI Error Mgt";
    begin
        Rec.LockTable();
        Rec.Get(Rec."I2I Entry No.");
        Rec.TestField("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Pending);
        PurchaseLineStaging.LockTable();
        PurchaseOrder.LockTable();
        ValidateStagingOrder(Rec);
        CreateValidatedPurchaseOrder(Rec);
        ErrorMgt.LogPurchaseEvent(Enum::"UFC SI Error Stage"::Processing, Rec."I2I i6 Order Number", Rec."I2I Entry No.", ProcessingCorrelationId, 'Purchase order created successfully.');
    end;

    procedure SetCorrelationId(CorrelationId: Text)
    begin
        ProcessingCorrelationId := CorrelationId;
    end;

    procedure ProcessStagingRecords()
    var
        POHStaging: Record "I2I Purchase Order Hdr Staging";
    begin
        Clear(POHStaging);

        POHStaging.SetRange("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Pending);
        while POHStaging.FindFirst() do begin
            CreatePurchaseOrder(POHStaging);
            Commit();
        end;
    end;

    procedure CreatePurchaseOrder(POHStaging: Record "I2I Purchase Order Hdr Staging")
    begin
        CreatePurchaseOrder(POHStaging, Format(CreateGuid()));
    end;

    procedure CreatePurchaseOrder(POHStaging: Record "I2I Purchase Order Hdr Staging"; CorrelationId: Text)
    var
        POLStaging: Record "I2I Purchase Order Line Stag.";
        ErrorMessageL: Text[2048];
        ErrorMgt: Codeunit "UFC SI Error Mgt";
        PurchaseOrderProcess: Codeunit "I2I UFC Purch. Order Process.";
    begin
        POHStaging.Get(POHStaging."I2I Entry No.");
        POHStaging.TestField("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Pending);
        Commit();

        PurchaseOrderProcess.SetCorrelationId(CorrelationId);
        ClearLastError();
        if not PurchaseOrderProcess.Run(POHStaging) then begin
            ErrorMessageL := CopyStr(GetLastErrorText(), 1, MaxStrLen(ErrorMessageL));
            if ErrorMessageL = '' then
                ErrorMessageL := 'Purchase order creation failed.';
            POHStaging.LockTable();
            POHStaging.Get(POHStaging."I2I Entry No.");
            if POHStaging."I2I Staging Status" = Enum::"I2I Purch. Order Stag. Status"::Pending then begin
                POHStaging."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Failed;
                POHStaging."I2I Error Message" := ErrorMessageL;
                POHStaging.Modify();
                POLStaging.SetRange("I2I Header Entry No.", POHStaging."I2I Entry No.");
                POLStaging.SetRange("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Pending);
                POLStaging.ModifyAll("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Failed);
            end;
            ErrorMgt.LogPurchaseEvent(Enum::"UFC SI Error Stage"::Processing, POHStaging."I2I i6 Order Number", POHStaging."I2I Entry No.", CorrelationId, ErrorMessageL);
            Commit();
            Error('Staging entry %1 could not be processed: %2', POHStaging."I2I Entry No.", ErrorMessageL);
        end;

    end;

    local procedure ValidateStagingOrder(POHStaging: Record "I2I Purchase Order Hdr Staging")
    var
        PurchaseOrder: Record "Purchase Header";
        POLStaging: Record "I2I Purchase Order Line Stag.";
        VendorRec: Record Vendor;
        ItemRec: Record Item;
        LocationRec: Record Location;
        ItemUOM: Record "Item Unit of Measure";
        LineNumbers: List of [Integer];
    begin
        POHStaging.TestField("I2I i6 Order Number");
        POHStaging.TestField("I2I Vendor Number");
        POHStaging.TestField("I2I Document Date");
        if PurchaseOrder.Get(PurchaseOrder."Document Type"::Order, POHStaging."I2I i6 Order Number") then
            Error('Purchase order %1 already exists.', POHStaging."I2I i6 Order Number");

        VendorRec.Get(POHStaging."I2I Vendor Number");
        VendorRec.TestField(Blocked, VendorRec.Blocked::" ");
        POLStaging.SetRange("I2I Header Entry No.", POHStaging."I2I Entry No.");
        if not POLStaging.FindSet() then
            Error('Staging entry %1 must contain at least one line.', POHStaging."I2I Entry No.");
        repeat
            POLStaging.TestField("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Pending);
            if POLStaging."I2I i6 Line No." <= 0 then
                Error('Staging line %1 must have a positive line number.', POLStaging."I2I Entry No.");
            if LineNumbers.Contains(POLStaging."I2I i6 Line No.") then
                Error('Line number %1 occurs more than once in staging entry %2.', POLStaging."I2I i6 Line No.", POHStaging."I2I Entry No.");
            LineNumbers.Add(POLStaging."I2I i6 Line No.");
            if POLStaging."I2I Quantity" <= 0 then
                Error('Quantity must be greater than zero for line %1.', POLStaging."I2I i6 Line No.");
            POLStaging.TestField("I2I Item No.");
            POLStaging.TestField("I2I Location Code");
            POLStaging.TestField("I2I Unit of Measure Code");
            ItemRec.Get(POLStaging."I2I Item No.");
            ItemRec.TestField(Blocked, false);
            ItemRec.TestField("Purchasing Blocked", false);
            LocationRec.Get(POLStaging."I2I Location Code");
            ItemUOM.Get(POLStaging."I2I Item No.", POLStaging."I2I Unit of Measure Code");
            if ItemUOM."Qty. per Unit of Measure" <= 0 then
                Error('Quantity per unit of measure must be greater than zero for item %1 and unit %2.', ItemUOM."Item No.", ItemUOM.Code);
        until POLStaging.Next() = 0;
    end;

    [CommitBehavior(CommitBehavior::Error)]
    local procedure CreateValidatedPurchaseOrder(var POHStaging: Record "I2I Purchase Order Hdr Staging")
    var
        PurchaseOrder: Record "Purchase Header";
        POLStaging: Record "I2I Purchase Order Line Stag.";
    begin
        POHStaging."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Processing;
        POHStaging."I2I Error Message" := '';
        POHStaging.Modify();

        PurchaseOrder.Init();
        PurchaseOrder."Document Type" := PurchaseOrder."Document Type"::Order;
        PurchaseOrder."No." := POHStaging."I2I i6 Order Number";
        PurchaseOrder.Insert(true);
        PurchaseOrder.Validate("Buy-from Vendor No.", POHStaging."I2I Vendor Number");
        PurchaseOrder.Validate("Document Date", POHStaging."I2I Document Date");
        PurchaseOrder.Modify(true);

        POLStaging.SetRange("I2I Header Entry No.", POHStaging."I2I Entry No.");
        if not POLStaging.FindSet(true) then
            Error('Staging entry %1 must contain at least one line.', POHStaging."I2I Entry No.");
        repeat
            POLStaging.TestField("I2I Staging Status", Enum::"I2I Purch. Order Stag. Status"::Pending);
            POLStaging."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Processing;
            POLStaging.Modify();
            CreatePurchaseOrderLine(PurchaseOrder."No.", POLStaging."I2I i6 Line No.", POLStaging."I2I Item No.", POLStaging."I2I Location Code", POLStaging."I2I Quantity", POLStaging."I2I Unit of Measure Code");
            POLStaging."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Created;
            POLStaging.Modify();
        until POLStaging.Next() = 0;

        POHStaging."I2I Staging Status" := Enum::"I2I Purch. Order Stag. Status"::Created;
        POHStaging."I2I Order Created At" := CurrentDateTime();
        POHStaging.Modify();
    end;

    procedure CreatePurchaseOrderLine(DocumentNo: Code[20]; LineNo: Integer; ItemNo: Code[20]; Location: Code[20]; Quantity: Decimal; UOMCode: Code[20])
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);

        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
        PurchaseLine."Document No." := DocumentNo;
        PurchaseLine."Line No." := LineNo;
        PurchaseLine.Insert(true);
        PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
        PurchaseLine.Validate("No.", ItemNo);
        PurchaseLine.Validate("Location Code", Location);
        PurchaseLine.Validate("Unit of Measure Code", UOMCode);
        PurchaseLine.Validate(Quantity, Quantity);
        PurchaseLine.Modify(true);
    end;

    var
        ProcessingCorrelationId: Text;
}
