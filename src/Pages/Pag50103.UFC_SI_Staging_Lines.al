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
                field("I6 Line Item Number"; Rec."I2I I6 Line Item Number")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."I2I Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."I2I Description")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."I2I Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec."I2I Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."I2I Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Price Excl. Tax"; Rec."I2I Unit Price Excl. Tax")
                {
                    ApplicationArea = All;
                }
                field("Ticket No."; Rec."I2I Ticket No.")
                {
                    ApplicationArea = All;
                }
                field(Destination; Rec."I2I Destination")
                {
                    ApplicationArea = All;
                }
                field(Registration; Rec."I2I Registration")
                {
                    ApplicationArea = All;
                }
                field("Flight No."; Rec."I2I Flight No.")
                {
                    ApplicationArea = All;
                }
                field("Integration Status"; Rec."I2I Integration Status")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStatusStyle;
                }
                field("Error Message"; Rec."I2I Error Message")
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
        case Rec."I2I Integration Status" of
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
