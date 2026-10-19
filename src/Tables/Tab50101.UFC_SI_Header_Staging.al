table 50101 "UFC SI Header Staging"
{
    Caption = 'UFC i6 Sales Invoice Header Staging';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI Staging List";
    LookupPageId = "UFC SI Staging List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "I6 Invoice ID"; Code[20])
        {
            Caption = 'i6 Invoice ID';
            DataClassification = CustomerContent;
        }
        field(11; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(12; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
        field(13; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(14; "I6 VAT Code"; Code[20])
        {
            Caption = 'i6 VAT Code';
            DataClassification = CustomerContent;
        }
        field(15; "VAT Business Posting Group"; Code[20])
        {
            Caption = 'VAT Business Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(16; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(17; "Integration Status"; Enum "UFC SI Integration Status")
        {
            Caption = 'Integration Status';
            DataClassification = SystemMetadata;
        }
        field(18; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(19; "Received At"; DateTime)
        {
            Caption = 'Received At';
            DataClassification = SystemMetadata;
        }
        field(20; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
            DataClassification = SystemMetadata;
        }
        field(21; "Source System"; Code[20])
        {
            Caption = 'Source System';
            DataClassification = SystemMetadata;
        }
        field(22; "Correlation ID"; Text[100])
        {
            Caption = 'Correlation ID';
            DataClassification = SystemMetadata;
        }
        field(23; "Target Invoice No."; Code[20])
        {
            Caption = 'Target Invoice No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Invoice));
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Invoice; "I6 Invoice ID")
        {
        }
        key(Status; "Integration Status", "Received At")
        {
        }
        key(Received; "Received At")
        {
        }
    }
}
