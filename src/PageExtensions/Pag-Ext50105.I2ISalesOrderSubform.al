pageextension 50105 "I2I Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Ticket No."; Rec."I2I UFC Ticket No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ticket No. field.', Comment = '%';
            }
            field("Dest."; Rec."I2I UFC Destination")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dest. field.', Comment = '%';
            }
            field("Sub Cust"; Rec."I2I UFC Sub Customer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sub Cust field.', Comment = '%';
            }
            field("Type_"; Rec."I2I UFC Aircraft Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type field.', Comment = '%';
            }
            field("Registration"; Rec."I2I UFC Registration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Registration field.', Comment = '%';
            }
            field("Flight No."; Rec."I2I UFC Flight No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Flight No. field.', Comment = '%';
            }
        }
    }
}
