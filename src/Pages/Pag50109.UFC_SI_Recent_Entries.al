page 50109 "UFC SI Recent Entries"
{
    ApplicationArea = All;
    Caption = 'Recent Staging Entries';
    PageType = ListPart;
    SourceTable = "UFC SI Header Staging";
    SourceTableView = sorting("Received At") order(descending);
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Entries)
            {
                field("I6 Invoice ID"; Rec."I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Integration Status"; Rec."Integration Status")
                {
                    ApplicationArea = All;
                }
                field("Received At"; Rec."Received At")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
