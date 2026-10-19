table 50104 "UFC SI VAT Mapping"
{
    Caption = 'UFC i6 VAT Mapping';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI VAT Mapping";
    LookupPageId = "UFC SI VAT Mapping";

    fields
    {
        field(1; "I6 VAT Code"; Code[20])
        {
            Caption = 'i6 VAT Code';
            DataClassification = CustomerContent;
        }
        field(2; "VAT Business Posting Group"; Code[20])
        {
            Caption = 'VAT Business Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "I6 VAT Code")
        {
            Clustered = true;
        }
    }
}
