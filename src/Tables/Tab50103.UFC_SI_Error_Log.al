table 50103 "UFC SI Error Log"
{
    Caption = 'UFC i6 Sales Invoice Error Log';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI Error Log";
    LookupPageId = "UFC SI Error Log";

    fields
    {
        field(1; "I2I Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "I2I Created At"; DateTime)
        {
            Caption = 'Created At';
            DataClassification = SystemMetadata;
        }
        field(11; "I2I Error Stage"; Enum "UFC SI Error Stage")
        {
            Caption = 'Error Stage';
            DataClassification = SystemMetadata;
        }
        field(12; "I2I I6 Invoice ID"; Code[20])
        {
            Caption = 'i6 Invoice ID';
            DataClassification = CustomerContent;
        }
        field(13; "I2I Header Entry No."; Integer)
        {
            Caption = 'Header Entry No.';
            DataClassification = SystemMetadata;
            TableRelation = "UFC SI Header Staging"."I2I Entry No.";
        }
        field(14; "I2I Correlation ID"; Text[100])
        {
            Caption = 'Correlation ID';
            DataClassification = SystemMetadata;
        }
        field(15; "I2I Message"; Text[2048])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "I2I Entry No.")
        {
            Clustered = true;
        }
        key(Header; "I2I Header Entry No.", "I2I Created At")
        {
        }
    }
}
