page 50109 "UFC SI Recent Entries"
{
    ApplicationArea = All;
    Caption = 'Recent Staging Entries';
    PageType = ListPart;
    SourceTable = "UFC SI Header Staging";
    SourceTableView = sorting("I2I Received At") order(descending);
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Entries)
            {
                field("I6 Invoice ID"; Rec."I2I I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."I2I Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."I2I Location Code")
                {
                    ApplicationArea = All;
                }
                field("Integration Status"; Rec."I2I Integration Status")
                {
                    ApplicationArea = All;
                }
                field("Received At"; Rec."I2I Received At")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
