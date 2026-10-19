page 50100 "UFC SI Integration Setup"
{
    ApplicationArea = All;
    Caption = 'UFC Integration Setup';
    PageType = Card;
    SourceTable = "UFC SI Integration Setup";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(InboundService)
            {
                Caption = 'Inbound i6 Service';

                field("Inbound Service Enabled"; Rec."I2I Pull Enabled")
                {
                    ApplicationArea = All;
                    Caption = 'Inbound Service Enabled';
                    ToolTip = 'Allows i6 to send its EOD sales invoice payload to the published Business Central service.';
                }
            }
            group(InboundSettings)
            {
                Caption = 'Inbound Processing';

                field("Default Source System"; Rec."I2I Default Source System")
                {
                    ApplicationArea = All;
                }
            }
            group(LastReceipt)
            {
                Caption = 'Last i6 Receipt';

                field("Last Pull At"; Rec."I2I Last Pull At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Pull Message"; Rec."I2I Last Pull Message")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadI6Json)
            {
                ApplicationArea = All;
                Caption = 'Upload Test JSON';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Temporary test tool. Uploads an i6 sales invoice JSON file, validates mandatory values, and stages only valid data.';

                trigger OnAction()
                var
                    FileName: Text;
                    FileInStream: InStream;
                    PayloadText: Text;
                    PayloadBigText: BigText;
                begin
                    if not UploadIntoStream('Upload i6 Sales Invoice JSON', '', 'JSON files (*.json)|*.json', FileName, FileInStream) then
                        exit;

                    PayloadBigText.Read(FileInStream);
                    PayloadBigText.GetSubText(PayloadText, 1);
                    ImportMgt.ImportJsonFile(PayloadText, FileName);
                    CurrPage.Update(false);
                end;
            }
            action(Uploadi6PurchaseJSON)
            {
                ApplicationArea = All;
                Caption = 'Upload Test Purchase JSON';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Temporary test tool. Uploads an i6 sales invoice JSON file, validates mandatory values, and stages only valid data.';

                trigger OnAction()
                var
                    Testing: Codeunit "I2I-I6 Purchase Order Import";
                    InstreamL: InStream;
                    DialogMsg: Label 'Please Upload Purchase .Json a File';
                    DataTxt: Text;
                    FromFileL: Text[100];
                    LineL: Text[100];
                //JSONDataL: JsonObject;
                begin
                    if UploadIntoStream(DialogMsg, '', 'JSON files (*.json)|*.json', FromFileL, InstreamL) then begin
                        while not InstreamL.EOS do begin
                            InstreamL.Read(LineL);
                            DataTxt += LineL;
                        end;

                        Testing.ReceivePurchasePayload(DataTxt);
                    end;
                end;
            }
            action(VATMapping)
            {
                ApplicationArea = All;
                Caption = 'VAT Mapping';
                Image = MapAccounts;
                RunObject = page "UFC SI VAT Mapping";
            }
            action(HydrantLocations)
            {
                ApplicationArea = All;
                Caption = 'Hydrant Locations';
                Image = Warehouse;
                RunObject = page "UFC SI Hydrant Locations";
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init();
            Rec."I2I Primary Key" := 'SETUP';
            Rec.Insert(true);
        end;
    end;

    var
        ImportMgt: Codeunit "UFC SI Import Mgt";
}
