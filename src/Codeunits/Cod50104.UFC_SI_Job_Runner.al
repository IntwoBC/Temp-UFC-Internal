codeunit 50104 "UFC SI Job Runner"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ProcessingMgt.ProcessOpenEntries();
    end;

    var
        ProcessingMgt: Codeunit "UFC SI Processing Mgt";
}
