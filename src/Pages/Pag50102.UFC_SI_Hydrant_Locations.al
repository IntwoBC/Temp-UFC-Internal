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
                field("Location Code"; Rec."I2I Location Code")
                {
                    ApplicationArea = All;
                }
                field("Auto Purchase Enabled"; Rec."I2I Auto Purchase Enabled")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."I2I Vendor No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
