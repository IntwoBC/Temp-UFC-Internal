page 50104 "UFC SI Staging Factbox"
{
    ApplicationArea = All;
    Caption = 'Staging Details';
    PageType = CardPart;
    SourceTable = "UFC SI Header Staging";
    Editable = false;

    layout
    {
        area(content)
        {
            group(Details)
            {
                Caption = 'Staging Details';

                field("Source System"; Rec."Source System")
                {
                    ApplicationArea = All;
                }
                field("Correlation ID"; Rec."Correlation ID")
                {
                    ApplicationArea = All;
                }
                field("I6 VAT Code"; Rec."I6 VAT Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Business Posting Group"; Rec."VAT Business Posting Group")
                {
                    ApplicationArea = All;
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
        }
    }
}
