pageextension 50101 "I2I Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {

            field("Name in Arabic"; Rec."I2I Name in Arabic")
            {
                ApplicationArea = All;
                Caption = 'Name in Arabic';
                ToolTip = 'Specifies the value of the Name field.', Comment = '%';
            }
        }
        addafter("Address 2")
        {

            field("Address in Arabic"; Rec."I2I Address in Arabic")
            {
                ApplicationArea = All;
                Caption = 'Address in Arabic';
                ToolTip = 'Specifies the value of the Address in Arabic field.', Comment = '%';
            }
        }
    }
}
