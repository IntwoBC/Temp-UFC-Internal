table 50108 "I2I Purchase Order Line Stag."
{
    Caption = 'Purchase Order Line Stag.';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "I2I Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "I2I Header Entry No."; Integer)
        {
            Caption = 'Header Entry No.';
        }
        field(3; "I2I i6 Line No."; Integer)
        {
            Caption = 'i6 Line No.';
        }
        field(4; "I2I Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; "I2I Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(6; "I2I Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(7; "I2I Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(8; "I2I Direct Unit Cost Excl. VAT"; Decimal)
        {
            Caption = 'Direct Unit Cost Excl. VAT';
        }
        field(9; "I2I Staging Status"; Enum "I2I Purch. Order Stag. Status")
        {
            Caption = 'Staging Status';
            DataClassification = CustomerContent;
            InitValue = Pending;
        }
    }
    keys
    {
        key(PK; "I2I Entry No.", "I2I Header Entry No.", "I2I i6 Line No.")
        {
            Clustered = true;
        }
    }
}
