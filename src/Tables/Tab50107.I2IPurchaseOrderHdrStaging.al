table 50107 "I2I Purchase Order Hdr Staging"
{
    Caption = 'Purchase Order Header Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "I2I Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "I2I i6 Order Number"; Code[20])
        {
            Caption = 'i6 Order Number';
        }
        field(3; "I2I Vendor Number"; Code[20])
        {
            Caption = 'Vendor Number';
        }
        field(4; "I2I Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "I2I Processed At"; DateTime)
        {
            Caption = 'Processed At';
        }
        field(6; "I2I Staging Status"; Enum "I2I Purch. Order Stag. Status")
        {
            Caption = 'Staging Status';
            DataClassification = CustomerContent;
            InitValue = Pending;
        }
        field(7; "I2I Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(8; "I2I Order Created At"; DateTime)
        {
            Caption = 'Order Created At';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "I2I Entry No.")
        {
            Clustered = true;
        }
    }
}
