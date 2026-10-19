page 50113 "I2I Purchase Order Line Stag."
{
    ApplicationArea = All;
    Caption = 'Purchase Order Line Staging';
    PageType = List;
    SourceTable = "I2I Purchase Order Line Stag.";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."I2I Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Header Entry No."; Rec."I2I Header Entry No.")
                {
                    ToolTip = 'Specifies the value of the Header Entry No. field.', Comment = '%';
                }
                field("i6 Line No."; Rec."I2I i6 Line No.")
                {
                    ToolTip = 'Specifies the value of the i6 Line No. field.', Comment = '%';
                }
                field("Item No."; Rec."I2I Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Location Code"; Rec."I2I Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field("Quantity"; Rec."I2I Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."I2I Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.', Comment = '%';
                }
                field("Direct Unit Cost Excl. VAT"; Rec."I2I Direct Unit Cost Excl. VAT")
                {
                    ToolTip = 'Specifies the value of the Direct Unit Cost Excl. VAT field.', Comment = '%';
                }
                field("Staging Status"; Rec."I2I Staging Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the purchase order line creation status. Pending means awaiting processing, Processing means creation is in progress, Created means the purchase order line was created, and Failed means creation failed.';
                }
            }
        }
    }
}
