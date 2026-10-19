page 50108 "UFC SI Activities"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Integration';
    PageType = CardPart;
    SourceTable = "UFC SI Activity Cue";
    Editable = false;

    layout
    {
        area(content)
        {
            cuegroup(Integration)
            {
                Caption = 'Sales Invoice Integration';

                field("Ready to Process"; Rec."I2I Ready to Process")
                {
                    ApplicationArea = All;
                    Style = Favorable;

                    trigger OnDrillDown()
                    begin
                        OpenStaging(Enum::"UFC SI Integration Status"::Open);
                    end;
                }
                field("Attention Required"; Rec."I2I Attention Required")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        OpenStaging(Enum::"UFC SI Integration Status"::Failed);
                    end;
                }
                field("In Progress"; Rec."I2I In Progress")
                {
                    ApplicationArea = All;
                    Style = Attention;

                    trigger OnDrillDown()
                    begin
                        OpenStaging(Enum::"UFC SI Integration Status"::Processing);
                    end;
                }
                field("Processed Successfully"; Rec."I2I Processed Successfully")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        OpenStaging(Enum::"UFC SI Integration Status"::Success);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('CUE') then begin
            Rec.Init();
            Rec."I2I Primary Key" := 'CUE';
            Rec.Insert(true);
        end;
    end;

    local procedure OpenStaging(Status: Enum "UFC SI Integration Status")
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("I2I Integration Status", Status);
        Page.Run(Page::"UFC SI Staging List", HeaderStaging);
    end;
}
