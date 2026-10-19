page 50112 "I2I Purchase Order Hdr Staging"
{
    ApplicationArea = All;
    Caption = 'Purchase Order Header Staging';
    PageType = List;
    SourceTable = "I2I Purchase Order Hdr Staging";
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
                field("i6 Order Number"; Rec."I2I i6 Order Number")
                {
                    ToolTip = 'Specifies the value of the i6 Order Number field.', Comment = '%';
                }
                field("Vendor Number"; Rec."I2I Vendor Number")
                {
                    ToolTip = 'Specifies the value of the Vendor Number field.', Comment = '%';
                }
                field("Document Date"; Rec."I2I Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("Processed At"; Rec."I2I Processed At")
                {
                    ToolTip = 'Specifies the value of the Processed At field.', Comment = '%';
                }
                field("Staging Status"; Rec."I2I Staging Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the purchase order creation status. Pending means awaiting processing, Processing means creation is in progress, Created means the purchase order was created, and Failed means creation failed.';
                }
                field("Error Message"; Rec."I2I Error Message")
                {
                    Editable = false;
                    ToolTip = 'Specifies the error that prevented purchase order creation. Failed creation rolls back the order, marks staging as Failed, and records the error in the UFC SI Error Log.';
                }
                field("Order Created At"; Rec."I2I Order Created At")
                {
                    Editable = false;
                    ToolTip = 'Specifies when the purchase order and all its lines were created successfully.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Process Pending Orders")
            {
                ApplicationArea = All;
                Caption = 'Process Pending Orders';
                Image = Process;
                ToolTip = 'Creates purchase orders for all pending staging headers. Stops at the first error; previously completed orders remain saved.';

                trigger OnAction()
                var
                    PurchaseOrderProcess: Codeunit "I2I UFC Purch. Order Process.";
                begin
                    PurchaseOrderProcess.ProcessStagingRecords();
                    CurrPage.Update(false);
                end;
            }
            action("Open Purchase Order")
            {
                ApplicationArea = All;
                Caption = 'Open Purchase Order';
                Image = Order;
                ToolTip = 'Opens the purchase order created from this staging record.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.SetRange("No.", Rec."I2I i6 Order Number");
                    if PurchaseHeader.FindFirst() then
                        Page.Run(Page::"Purchase Order", PurchaseHeader)
                    else
                        Error('No purchase order was found for external order number %1.', Rec."I2I i6 Order Number");
                end;
            }
            action("Make Pending")
            {
                ToolTip = 'Resets a failed purchase staging header and its lines to Pending so the order can be retried. Existing log messages are retained.';

                trigger OnAction()
                var
                    POHStaging: Record "I2I Purchase Order Hdr Staging";
                    POLStaging: Record "I2I Purchase Order Line Stag.";
                begin
                    POHStaging.SetRange("I2I Entry No.", Rec."I2I Entry No.");
                    if POHStaging.FindFirst() then begin
                        POHStaging.TestField("I2I Staging Status", POHStaging."I2I Staging Status"::Failed);
                        POHStaging."I2I Staging Status" := POHStaging."I2I Staging Status"::Pending;
                        POHStaging."I2I Error Message" := '';
                        POHStaging."I2I Order Created At" := 0DT;
                        POHStaging.Modify();
                    end;

                    POLStaging.SetRange("I2I Header Entry No.", Rec."I2I Entry No.");
                    if POLStaging.FindSet() then
                        repeat
                            POLStaging."I2I Staging Status" := POLStaging."I2I Staging Status"::Pending;
                            POLStaging.Modify();
                        until POLStaging.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
            action("Integration Log")
            {
                ApplicationArea = All;
                Caption = 'Integration Log';
                Image = Log;
                ToolTip = 'Shows shared UFC SI log messages for this purchase order. Purchase staging entry numbers are included in the messages; the Header Entry No. field is reserved for sales invoice staging.';

                trigger OnAction()
                var
                    ErrorLog: Record "UFC SI Error Log";
                begin
                    ErrorLog.SetRange("I2I I6 Invoice ID", Rec."I2I i6 Order Number");
                    ErrorLog.SetFilter("I2I Message", 'Purchase order *');
                    Page.Run(Page::"UFC SI Error Log", ErrorLog);
                end;
            }
        }
    }
}
