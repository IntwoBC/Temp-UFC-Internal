tableextension 50100 "UFC Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; "UFC Ticket No."; Text[100])
        {
            Caption = 'UFC Ticket No.';
            DataClassification = CustomerContent;
        }
        field(50101; "UFC Destination"; Text[100])
        {
            Caption = 'UFC Destination';
            DataClassification = CustomerContent;
        }
        field(50102; "UFC Registration"; Text[100])
        {
            Caption = 'UFC Registration';
            DataClassification = CustomerContent;
        }
        field(50103; "UFC Flight No."; Text[100])
        {
            Caption = 'UFC Flight No.';
            DataClassification = CustomerContent;
        }
        field(50104; "UFC Sub Customer"; Text[100])
        {
            Caption = 'UFC Sub Customer';
            DataClassification = CustomerContent;
        }
        field(50105; "UFC Aircraft Type"; Text[100])
        {
            Caption = 'UFC Aircraft Type';
            DataClassification = CustomerContent;
        }
    }
}
