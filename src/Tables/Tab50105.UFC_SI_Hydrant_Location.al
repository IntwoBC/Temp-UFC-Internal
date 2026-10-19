table 50105 "UFC SI Hydrant Location"
{
    Caption = 'UFC i6 Hydrant Location Setup';
    DataClassification = CustomerContent;
    DrillDownPageId = "UFC SI Hydrant Locations";
    LookupPageId = "UFC SI Hydrant Locations";

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(2; "Auto Purchase Enabled"; Boolean)
        {
            Caption = 'Auto Purchase Enabled';
            DataClassification = SystemMetadata;
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(PK; "Location Code")
        {
            Clustered = true;
        }
    }
}
