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

                field("Source System"; Rec."I2I Source System")
                {
                    ApplicationArea = All;
                }
                field("Correlation ID"; Rec."I2I Correlation ID")
                {
                    ApplicationArea = All;
                }
                field("I6 VAT Code"; Rec."I2I I6 VAT Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Business Posting Group"; Rec."I2I VAT Business Posting Group")
                {
                    ApplicationArea = All;
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
        }
    }
}
