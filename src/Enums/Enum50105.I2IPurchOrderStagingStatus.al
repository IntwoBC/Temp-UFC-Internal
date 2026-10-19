enum 50105 "I2I Purch. Order Stag. Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Processing)
    {
        Caption = 'Processing';
    }
    value(2; Created)
    {
        Caption = 'Created';
    }
    value(3; Failed)
    {
        Caption = 'Failed';
    }
}
