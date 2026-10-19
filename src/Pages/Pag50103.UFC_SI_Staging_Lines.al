page 50103 "UFC SI Staging Lines"
{
    ApplicationArea = All;
    Caption = 'UFC i6 Sales Invoice Staging Lines';
    PageType = List;
    SourceTable = "UFC SI Line Staging";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("I6 Line Item Number"; Rec."I6 Line Item Number")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Price Excl. Tax"; Rec."Unit Price Excl. Tax")
                {
                    ApplicationArea = All;
                }
                field("Ticket No."; Rec."Ticket No.")
                {
                    ApplicationArea = All;
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = All;
                }
                field(Registration; Rec.Registration)
                {
                    ApplicationArea = All;
                }
                field("Flight No."; Rec."Flight No.")
                {
                    ApplicationArea = All;
                }
                field("Integration Status"; Rec."Integration Status")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStatusStyle;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLineStatusStyle();
    end;

    local procedure SetLineStatusStyle()
    begin
        case Rec."Integration Status" of
            Enum::"UFC SI Integration Status"::Open:
                LineStatusStyle := 'StandardAccent';
            Enum::"UFC SI Integration Status"::Processing:
                LineStatusStyle := 'Attention';
            Enum::"UFC SI Integration Status"::Success:
                LineStatusStyle := 'Favorable';
            Enum::"UFC SI Integration Status"::Failed:
                LineStatusStyle := 'Unfavorable';
        end;
    end;

    var
        LineStatusStyle: Text;
}
