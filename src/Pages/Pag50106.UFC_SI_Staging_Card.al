page 50106 "UFC SI Staging Card"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Staging';
    PageType = Card;
    SourceTable = "UFC SI Header Staging";
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."I2I Entry No.")
                {
                    ApplicationArea = All;
                }
                field("I6 Invoice ID"; Rec."I2I I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."I2I Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."I2I Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."I2I External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."I2I Location Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Processing)
            {
                Caption = 'Processing';

                field("Integration Status"; Rec."I2I Integration Status")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."I2I Error Message")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Target Invoice No."; Rec."I2I Target Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Received At"; Rec."I2I Received At")
                {
                    ApplicationArea = All;
                }
                field("Processed At"; Rec."I2I Processed At")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "UFC SI Staging Lines")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "I2I Header Entry No." = field("I2I Entry No.");
            }
        }
    }
}
