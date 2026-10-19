enum 50101 "UFC SI Authorization Type"
{
    Extensible = false;

    value(0; None)
    {
        Caption = 'None';
    }
    value(1; ApiKey)
    {
        Caption = 'API Key';
    }
    value(2; BearerToken)
    {
        Caption = 'Bearer Token';
    }
    value(3; OAuth2)
    {
        Caption = 'OAuth 2.0';
    }
    value(4; Certificate)
    {
        Caption = 'Certificate';
    }
}
