table 50102 "UFC SI Line Staging"
{
    Caption = 'UFC i6 Sales Invoice Line Staging';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI Staging Lines";
    LookupPageId = "UFC SI Staging Lines";

    fields
    {
        field(1; "I2I Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "I2I Header Entry No."; Integer)
        {
            Caption = 'Header Entry No.';
            DataClassification = SystemMetadata;
            TableRelation = "UFC SI Header Staging"."I2I Entry No.";
        }
        field(11; "I2I I6 Line Item Number"; Integer)
        {
            Caption = 'i6 Line Item Number';
            DataClassification = CustomerContent;
        }
        field(12; "I2I Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(13; "I2I Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; "I2I Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(15; "I2I Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(16; "I2I Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(17; "I2I Unit Price Excl. Tax"; Decimal)
        {
            Caption = 'Unit Price Excl. Tax';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(18; "I2I Ticket No."; Text[100])
        {
            Caption = 'Ticket No.';
            DataClassification = CustomerContent;
        }
        field(19; "I2I Destination"; Text[100])
        {
            Caption = 'Destination';
            DataClassification = CustomerContent;
        }
        field(20; "I2I Registration"; Text[100])
        {
            Caption = 'Registration';
            DataClassification = CustomerContent;
        }
        field(21; "I2I Flight No."; Text[100])
        {
            Caption = 'Flight No.';
            DataClassification = CustomerContent;
        }
        field(22; "I2I Sub Customer"; Text[100])
        {
            Caption = 'Sub Customer';
            DataClassification = CustomerContent;
            InitValue = 'NA';
        }
        field(23; "I2I Aircraft Type"; Text[100])
        {
            Caption = 'Aircraft Type';
            DataClassification = CustomerContent;
        }
        field(24; "I2I Integration Status"; Enum "UFC SI Integration Status")
        {
            Caption = 'Integration Status';
            DataClassification = SystemMetadata;
        }
        field(25; "I2I Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "I2I Entry No.")
        {
            Clustered = true;
        }
        key(HeaderLine; "I2I Header Entry No.", "I2I I6 Line Item Number")
        {
            Unique = true;
        }
    }
}
