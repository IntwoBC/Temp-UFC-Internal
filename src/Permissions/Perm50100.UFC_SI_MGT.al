permissionset 50100 "UFC SI MGT"
{
    Assignable = true;
    Caption = 'UFC i6 Sales Invoice Management';

    Permissions =
        tabledata "UFC SI Integration Setup" = RIMD,
        tabledata "UFC SI Header Staging" = RIMD,
        tabledata "UFC SI Line Staging" = RIMD,
        tabledata "UFC SI Error Log" = RIMD,
        tabledata "UFC SI VAT Mapping" = RIMD,
        tabledata "UFC SI Hydrant Location" = RIMD,
        tabledata "UFC SI Activity Cue" = RIMD,
        codeunit "UFC SI Error Mgt" = X,
        codeunit "UFC SI Import Mgt" = X,
        codeunit "UFC SI Create Invoice" = X,
        codeunit "UFC SI Processing Mgt" = X,
        codeunit "UFC SI Job Runner" = X,
        codeunit "UFC i6 SI Inbound Service" = X,
        page "UFC SI Integration Setup" = X,
        page "UFC SI VAT Mapping" = X,
        page "UFC SI Hydrant Locations" = X,
        page "UFC SI Staging Lines" = X,
        page "UFC SI Staging Factbox" = X,
        page "UFC SI Staging List" = X,
        page "UFC SI Staging Card" = X,
        page "UFC SI Error Log" = X,
        page "UFC SI Activities" = X,
        page "UFC SI Recent Entries" = X,
        page "UFC SI Control Center" = X,
        page "UFC Integration Dashboard" = X;
}
