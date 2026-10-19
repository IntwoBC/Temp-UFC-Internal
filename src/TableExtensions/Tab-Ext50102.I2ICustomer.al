tableextension 50102 "I2I Customer" extends Customer
{
    fields
    {
        field(50100; "I2I Name in Arabic"; Text[200])
        {
            Caption = 'Name in Arabic';
            DataClassification = ToBeClassified;
        }
        field(50101; "I2I Address in Arabic"; Text[500])
        {
            Caption = 'Address in Arabic';
            DataClassification = ToBeClassified;
        }
    }
}
