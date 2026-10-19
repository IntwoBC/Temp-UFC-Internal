table 50102 "UFC SI Line Staging"
{
    Caption = 'UFC i6 Sales Invoice Line Staging';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI Staging Lines";
    LookupPageId = "UFC SI Staging Lines";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Header Entry No."; Integer)
        {
            Caption = 'Header Entry No.';
            DataClassification = SystemMetadata;
            TableRelation = "UFC SI Header Staging"."Entry No.";
        }
        field(11; "I6 Line Item Number"; Integer)
        {
            Caption = 'i6 Line Item Number';
            DataClassification = CustomerContent;
        }
        field(12; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(13; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(16; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(17; "Unit Price Excl. Tax"; Decimal)
        {
            Caption = 'Unit Price Excl. Tax';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(18; "Ticket No."; Text[100])
        {
            Caption = 'Ticket No.';
            DataClassification = CustomerContent;
        }
        field(19; Destination; Text[100])
        {
            Caption = 'Destination';
            DataClassification = CustomerContent;
        }
        field(20; Registration; Text[100])
        {
            Caption = 'Registration';
            DataClassification = CustomerContent;
        }
        field(21; "Flight No."; Text[100])
        {
            Caption = 'Flight No.';
            DataClassification = CustomerContent;
        }
        field(22; "Sub Customer"; Text[100])
        {
            Caption = 'Sub Customer';
            DataClassification = CustomerContent;
            InitValue = 'NA';
        }
        field(23; "Aircraft Type"; Text[100])
        {
            Caption = 'Aircraft Type';
            DataClassification = CustomerContent;
        }
        field(24; "Integration Status"; Enum "UFC SI Integration Status")
        {
            Caption = 'Integration Status';
            DataClassification = SystemMetadata;
        }
        field(25; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(HeaderLine; "Header Entry No.", "I6 Line Item Number")
        {
            Unique = true;
        }
    }
}
