table 50100 "UFC SI Integration Setup"
{
    Caption = 'UFC i6 Sales Invoice Integration Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Endpoint URL"; Text[2048])
        {
            Caption = 'Legacy i6 Endpoint URL';
            DataClassification = SystemMetadata;
            ExtendedDatatype = URL;
        }
        field(11; "Request Query"; Text[2048])
        {
            Caption = 'Request Query';
            DataClassification = SystemMetadata;
        }
        field(12; "Authorization Type"; Enum "UFC SI Authorization Type")
        {
            Caption = 'Legacy Outbound Authorization Type';
            DataClassification = SystemMetadata;
        }
        field(13; "Authorization Reference"; Code[100])
        {
            Caption = 'Legacy Outbound Authorization Reference';
            DataClassification = SystemMetadata;
            ToolTip = 'Identifies the approved secure secret, certificate, or OAuth configuration. Do not store the actual credential in this setup table.';
        }
        field(14; "API Version"; Code[20])
        {
            Caption = 'API Version';
            DataClassification = SystemMetadata;
        }
        field(15; "Pull Enabled"; Boolean)
        {
            Caption = 'Inbound Service Enabled';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(16; "Default Source System"; Code[20])
        {
            Caption = 'Default Source System';
            DataClassification = SystemMetadata;
            InitValue = 'i6';
        }
        field(17; "Last Pull At"; DateTime)
        {
            Caption = 'Last i6 Receipt At';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(18; "Last Pull Message"; Text[250])
        {
            Caption = 'Last i6 Receipt Message';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP';

        if "Default Source System" = '' then
            "Default Source System" := 'i6';
    end;
}
