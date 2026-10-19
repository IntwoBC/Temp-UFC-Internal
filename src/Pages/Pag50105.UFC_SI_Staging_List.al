page 50105 "UFC SI Staging List"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Staging';
    PageType = List;
    SourceTable = "UFC SI Header Staging";
    UsageCategory = None;
    CardPageId = "UFC SI Staging Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(StagingQueue)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("I6 Invoice ID"; Rec."I6 Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
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
                    StyleExpr = StatusStyle;
                }
                field("Error Message"; Rec."Error Message")
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
        area(factboxes)
        {
            part(StagingDetails; "UFC SI Staging Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProcessReady)
            {
                ApplicationArea = All;
                Caption = 'Process Ready';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Processes all open staging entries inside Business Central.';

                trigger OnAction()
                begin
                    ProcessingMgt.ProcessOpenEntries();
                    CurrPage.Update(false);
                end;
            }
            action(OpenLines)
            {
                ApplicationArea = All;
                Caption = 'Open Lines';
                Image = Lines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LineStaging: Record "UFC SI Line Staging";
                begin
                    LineStaging.SetRange("Header Entry No.", Rec."Entry No.");
                    Page.Run(Page::"UFC SI Staging Lines", LineStaging);
                end;
            }
            action(ReviewErrors)
            {
                ApplicationArea = All;
                Caption = 'Review Errors';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ErrorLog: Record "UFC SI Error Log";
                begin
                    ErrorLog.SetRange("Header Entry No.", Rec."Entry No.");
                    Page.Run(Page::"UFC SI Error Log", ErrorLog);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    local procedure SetStatusStyle()
    begin
        case Rec."Integration Status" of
            Enum::"UFC SI Integration Status"::Open:
                StatusStyle := 'StandardAccent';
            Enum::"UFC SI Integration Status"::Processing:
                StatusStyle := 'Attention';
            Enum::"UFC SI Integration Status"::Success:
                StatusStyle := 'Favorable';
            Enum::"UFC SI Integration Status"::Failed:
                StatusStyle := 'Unfavorable';
        end;
    end;

    var
        ProcessingMgt: Codeunit "UFC SI Processing Mgt";
        StatusStyle: Text;
}
