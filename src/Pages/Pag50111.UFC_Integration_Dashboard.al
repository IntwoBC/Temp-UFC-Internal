page 50111 "UFC Integration Dashboard"
{
    ApplicationArea = All;
    Caption = 'UFC Integration Dashboard';
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            usercontrol(IntegrationHub; "UFC Integration Hub")
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    LoadHub();
                end;

                trigger OpenSales()
                begin
                    Page.RunModal(Page::"UFC SI Control Center");
                    LoadHub();
                end;

                trigger OpenSetup()
                begin
                    Page.RunModal(Page::"UFC SI Integration Setup");
                    LoadHub();
                end;

                trigger OpenPurchase()
                begin
                    Page.RunModal(Page::"I2I Purchase Order Hdr Staging");
                    LoadHub();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshDashboard)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    LoadHub();
                end;
            }
        }
    }

    local procedure LoadHub()
    var
        HeaderStaging: Record "UFC SI Header Staging";
        Model: JsonObject;
        HubText: Text;
    begin
        Model.Add('salesReady', CountByStatus(Enum::"UFC SI Integration Status"::Open));
        Model.Add('salesFailed', CountByStatus(Enum::"UFC SI Integration Status"::Failed));
        Model.Add('salesProcessing', CountByStatus(Enum::"UFC SI Integration Status"::Processing));
        Model.Add('salesTotal', HeaderStaging.Count());
        Model.WriteTo(HubText);
        CurrPage.IntegrationHub.RenderHub(HubText);
    end;

    local procedure CountByStatus(Status: Enum "UFC SI Integration Status"): Integer
    var
        HeaderStaging: Record "UFC SI Header Staging";
    begin
        HeaderStaging.SetRange("I2I Integration Status", Status);
        exit(HeaderStaging.Count());
    end;
}
