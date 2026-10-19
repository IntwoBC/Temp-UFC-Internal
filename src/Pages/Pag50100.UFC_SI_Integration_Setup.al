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

                field("Inbound Service Enabled"; Rec."Pull Enabled")
                {
                    ApplicationArea = All;
                    Caption = 'Inbound Service Enabled';
                    ToolTip = 'Allows i6 to send its EOD sales invoice payload to the published Business Central service.';
                }
            }
            group(InboundSettings)
            {
                Caption = 'Inbound Processing';

                field("Default Source System"; Rec."Default Source System")
                {
                    ApplicationArea = All;
                }
            }
            group(LastReceipt)
            {
                Caption = 'Last i6 Receipt';

                field("Last Pull At"; Rec."Last Pull At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Pull Message"; Rec."Last Pull Message")
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
            Rec."Primary Key" := 'SETUP';
            Rec.Insert(true);
        end;
    end;

    var
        ImportMgt: Codeunit "UFC SI Import Mgt";
}
