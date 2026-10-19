tableextension 50100 "UFC Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; "I2I UFC Ticket No."; Text[100])
        {
            Caption = 'UFC Ticket No.';
            DataClassification = CustomerContent;
        }
        field(50101; "I2I UFC Destination"; Text[100])
        {
            Caption = 'UFC Destination';
            DataClassification = CustomerContent;
        }
        field(50102; "I2I UFC Registration"; Text[100])
        {
            Caption = 'UFC Registration';
            DataClassification = CustomerContent;
        }
        field(50103; "I2I UFC Flight No."; Text[100])
        {
            Caption = 'UFC Flight No.';
            DataClassification = CustomerContent;
        }
        field(50104; "I2I UFC Sub Customer"; Text[100])
        {
            Caption = 'UFC Sub Customer';
            DataClassification = CustomerContent;
        }
        field(50105; "I2I UFC Aircraft Type"; Text[100])
        {
            Caption = 'UFC Aircraft Type';
            DataClassification = CustomerContent;
        }
    }
}
