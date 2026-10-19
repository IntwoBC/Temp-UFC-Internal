tableextension 50104 "I2I Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50100; "I2I Ticket No."; Text[100])
        {
            Caption = 'Ticket No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "I2I Dest."; Text[100])
        {
            Caption = 'Dest.';
            DataClassification = ToBeClassified;
        }
        field(50102; "I2I Sub Cust"; Text[100])
        {
            Caption = 'Sub Cust';
            DataClassification = ToBeClassified;
        }
        field(50103; "I2I Type"; Text[100])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(50104; "I2I Registration"; Text[100])
        {
            Caption = 'Registration';
            DataClassification = ToBeClassified;
        }
        field(50105; "I2I Flight No."; Text[100])
        {
            Caption = 'Flight No.';
            DataClassification = ToBeClassified;
        }
    }
}
