controladdin "UFC SI Operations Dashboard"
{
    HorizontalStretch = true;
    VerticalStretch = true;
    MinimumHeight = 220;
    MinimumWidth = 650;
    RequestedHeight = 250;
    RequestedWidth = 1000;
    // The dashboard styling is installed by the startup script. This avoids a
    // stylesheet-resource resolution issue in the hosted control add-in.
    StartupScript = './resources/js/UFC_SI_Operations_Dashboard.js';

    event AddInReady();
    event RefreshDashboard();
    event ProcessReady();
    event ResetFailed();
    event ReviewErrors();
    event OpenStaging();
    event OpenEntry(EntryNo: Integer);

    procedure RenderDashboard(DashboardJson: Text)
}
