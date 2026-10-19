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
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                }
                field("Error Stage"; Rec."Error Stage")
                {
                    ApplicationArea = All;
                }
                field("I6 Invoice ID"; Rec."I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Header Entry No."; Rec."Header Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Correlation ID"; Rec."Correlation ID")
                {
                    ApplicationArea = All;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
