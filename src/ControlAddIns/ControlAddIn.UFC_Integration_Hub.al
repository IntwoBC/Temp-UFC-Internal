controladdin "UFC Integration Hub"
{
    HorizontalStretch = true;
    VerticalStretch = true;
    MinimumHeight = 340;
    MinimumWidth = 650;
    RequestedHeight = 440;
    RequestedWidth = 1000;
    // Reuse the proven dashboard resource so the hub is embedded with the
    // existing Sales dashboard script in every extension package.
    StartupScript = './resources/js/UFC_SI_Operations_Dashboard.js';

    event AddInReady();
    event OpenSales();
    event OpenSetup();

    procedure RenderHub(HubJson: Text)
}
