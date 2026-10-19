pageextension 50106 "I2I Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Ticket No."; Rec."I2I Ticket No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ticket No. field.', Comment = '%';
            }
            field("Dest."; Rec."I2I Dest.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dest. field.', Comment = '%';
            }
            field("Sub Cust"; Rec."I2I Sub Cust")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sub Cust field.', Comment = '%';
            }
            field("Type_"; Rec."I2I Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type field.', Comment = '%';
            }
            field("Registration"; Rec."I2I Registration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Registration field.', Comment = '%';
            }
            field("Flight No."; Rec."I2I Flight No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Flight No. field.', Comment = '%';
            }
        }
    }
}
