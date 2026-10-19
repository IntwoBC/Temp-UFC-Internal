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
        SalesHeader."No." := HeaderStaging."I6 Invoice ID";
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", HeaderStaging."Customer No.");
        SalesHeader.Validate("Posting Date", HeaderStaging."Shipment Date");
        SalesHeader.Validate("Shipment Date", HeaderStaging."Shipment Date");
        SalesHeader.Validate("External Document No.", HeaderStaging."External Document No.");
        SalesHeader.Validate("Location Code", HeaderStaging."Location Code");
        SalesHeader.Validate("VAT Bus. Posting Group", HeaderStaging."VAT Business Posting Group");
        SalesHeader.Modify(true);

        LineStaging.SetRange("Header Entry No.", HeaderStaging."Entry No.");
        if LineStaging.FindSet() then
            repeat
                NextLineNo += 10000;
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := NextLineNo;
                SalesLine.Insert(true);
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", LineStaging."Item No.");
                SalesLine.Validate(Description, LineStaging.Description);
                SalesLine.Validate("Location Code", LineStaging."Location Code");
                SalesLine.Validate(Quantity, LineStaging.Quantity);
                SalesLine.Validate("Unit of Measure Code", LineStaging."Unit of Measure Code");
                SalesLine."UFC Ticket No." := LineStaging."Ticket No.";
                SalesLine."UFC Destination" := LineStaging.Destination;
                SalesLine."UFC Registration" := LineStaging.Registration;
                SalesLine."UFC Flight No." := LineStaging."Flight No.";
                SalesLine."UFC Sub Customer" := LineStaging."Sub Customer";
                SalesLine."UFC Aircraft Type" := LineStaging."Aircraft Type";
                SalesLine.Modify(true);

                LineStaging."Unit Price Excl. Tax" := SalesLine."Unit Price";
                LineStaging.Modify(true);
            until LineStaging.Next() = 0;

        HeaderStaging."Target Invoice No." := SalesHeader."No.";
        HeaderStaging.Modify(true);

        if HydrantLocation.Get(HeaderStaging."Location Code") then
            if HydrantLocation."Auto Purchase Enabled" then
                OnCreateHydrantPurchase(SalesHeader, HeaderStaging, HydrantLocation."Vendor No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateHydrantPurchase(var SalesHeader: Record "Sales Header"; HeaderStaging: Record "UFC SI Header Staging"; VendorNo: Code[20])
    begin
    end;
}
