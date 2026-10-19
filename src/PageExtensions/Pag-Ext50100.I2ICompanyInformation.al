pageextension 50100 "I2I Company Information" extends "Company Information"
{
    layout
    {
        addafter(Name)
        {
            field("Name in Arabic"; Rec."I2I Name in Arabic")
            {
                ApplicationArea = All;
                Caption = 'Name in Arabic';
            }
        }
        addafter("Address 2")
        {
            field("Address in Arabic"; Rec."I2I Address in Arabic")
            {
                Caption = 'Address in Arabic';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address in Arabic field.', Comment = '%';
            }
        }
    }
}
