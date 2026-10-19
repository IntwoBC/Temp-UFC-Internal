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

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("I6 Invoice ID"; Rec."I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Processing)
            {
                Caption = 'Processing';

                field("Integration Status"; Rec."Integration Status")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Target Invoice No."; Rec."Target Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Received At"; Rec."Received At")
                {
                    ApplicationArea = All;
                }
                field("Processed At"; Rec."Processed At")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "UFC SI Staging Lines")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Header Entry No." = field("Entry No.");
            }
        }
    }
}
