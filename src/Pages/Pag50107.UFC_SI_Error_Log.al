page 50107 "UFC SI Error Log"
{
    ApplicationArea = All;
    Caption = 'UFC i6 Sales Invoice Error Log';
    PageType = List;
    SourceTable = "UFC SI Error Log";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Errors)
            {
                field("Created At"; Rec."I2I Created At")
                {
                    ApplicationArea = All;
                }
                field("Error Stage"; Rec."I2I Error Stage")
                {
                    ApplicationArea = All;
                }
                field("I6 Invoice ID"; Rec."I2I I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Header Entry No."; Rec."I2I Header Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Correlation ID"; Rec."I2I Correlation ID")
                {
                    ApplicationArea = All;
                }
                field(Message; Rec."I2I Message")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
