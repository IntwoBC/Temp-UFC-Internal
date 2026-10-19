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
                field("I6 VAT Code"; Rec."I6 VAT Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Business Posting Group"; Rec."VAT Business Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
