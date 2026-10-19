page 50102 "UFC SI Hydrant Locations"
{
    ApplicationArea = All;
    Caption = 'UFC i6 Hydrant Locations';
    PageType = List;
    SourceTable = "UFC SI Hydrant Location";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Auto Purchase Enabled"; Rec."Auto Purchase Enabled")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
