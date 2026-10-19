table 50103 "UFC SI Error Log"
{
    Caption = 'UFC i6 Sales Invoice Error Log';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI Error Log";
    LookupPageId = "UFC SI Error Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Created At"; DateTime)
        {
            Caption = 'Created At';
            DataClassification = SystemMetadata;
        }
        field(11; "Error Stage"; Enum "UFC SI Error Stage")
        {
            Caption = 'Error Stage';
            DataClassification = SystemMetadata;
        }
        field(12; "I6 Invoice ID"; Code[20])
        {
            Caption = 'i6 Invoice ID';
            DataClassification = CustomerContent;
        }
        field(13; "Header Entry No."; Integer)
        {
            Caption = 'Header Entry No.';
            DataClassification = SystemMetadata;
            TableRelation = "UFC SI Header Staging"."Entry No.";
        }
        field(14; "Correlation ID"; Text[100])
        {
            Caption = 'Correlation ID';
            DataClassification = SystemMetadata;
        }
        field(15; Message; Text[2048])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Header; "Header Entry No.", "Created At")
        {
        }
    }
}
