page 50101 "UFC SI VAT Mapping"
{
    ApplicationArea = All;
    Caption = 'UFC i6 VAT Mapping';
    PageType = List;
    SourceTable = "UFC SI VAT Mapping";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("I6 VAT Code"; Rec."I2I I6 VAT Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Business Posting Group"; Rec."I2I VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."I2I Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
