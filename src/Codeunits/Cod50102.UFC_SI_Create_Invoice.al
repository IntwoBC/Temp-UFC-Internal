codeunit 50102 "UFC SI Create Invoice"
{
    TableNo = "UFC SI Header Staging";

    trigger OnRun()
    begin
        CreateSalesInvoice(Rec);
    end;

    local procedure CreateSalesInvoice(var HeaderStaging: Record "UFC SI Header Staging")
    var
        LineStaging: Record "UFC SI Line Staging";
        HydrantLocation: Record "UFC SI Hydrant Location";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NextLineNo: Integer;
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := HeaderStaging."I2I I6 Invoice ID";
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", HeaderStaging."I2I Customer No.");
        SalesHeader.Validate("Posting Date", HeaderStaging."I2I Shipment Date");
        SalesHeader.Validate("Shipment Date", HeaderStaging."I2I Shipment Date");
        SalesHeader.Validate("External Document No.", HeaderStaging."I2I External Document No.");
        SalesHeader.Validate("Location Code", HeaderStaging."I2I Location Code");
        SalesHeader.Validate("VAT Bus. Posting Group", HeaderStaging."I2I VAT Business Posting Group");
        SalesHeader.Modify(true);

        LineStaging.SetRange("I2I Header Entry No.", HeaderStaging."I2I Entry No.");
        if LineStaging.FindSet() then
            repeat
                NextLineNo += 10000;
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := NextLineNo;
                SalesLine.Insert(true);
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", LineStaging."I2I Item No.");
                SalesLine.Validate(Description, LineStaging."I2I Description");
                SalesLine.Validate("Location Code", LineStaging."I2I Location Code");
                SalesLine.Validate(Quantity, LineStaging."I2I Quantity");
                SalesLine.Validate("Unit of Measure Code", LineStaging."I2I Unit of Measure Code");
                SalesLine."I2I UFC Ticket No." := LineStaging."I2I Ticket No.";
                SalesLine."I2I UFC Destination" := LineStaging."I2I Destination";
                SalesLine."I2I UFC Registration" := LineStaging."I2I Registration";
                SalesLine."I2I UFC Flight No." := LineStaging."I2I Flight No.";
                SalesLine."I2I UFC Sub Customer" := LineStaging."I2I Sub Customer";
                SalesLine."I2I UFC Aircraft Type" := LineStaging."I2I Aircraft Type";
                SalesLine.Modify(true);

                LineStaging."I2I Unit Price Excl. Tax" := SalesLine."Unit Price";
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;

        HeaderStaging."I2I Target Invoice No." := SalesHeader."No.";
        HeaderStaging.Modify(true);

        if HydrantLocation.Get(HeaderStaging."I2I Location Code") then
            if HydrantLocation."I2I Auto Purchase Enabled" then
                OnCreateHydrantPurchase(SalesHeader, HeaderStaging, HydrantLocation."I2I Vendor No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateHydrantPurchase(var SalesHeader: Record "Sales Header"; HeaderStaging: Record "UFC SI Header Staging"; VendorNo: Code[20])
    begin
    end;
}
