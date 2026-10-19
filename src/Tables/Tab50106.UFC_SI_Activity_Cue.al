table 50106 "UFC SI Activity Cue"
{
    Caption = 'UFC i6 Sales Invoice Activities';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Ready to Process"; Integer)
        {
            Caption = 'Ready to Process';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("Integration Status" = const(Open)));
        }
        field(11; "Attention Required"; Integer)
        {
            Caption = 'Attention Required';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("Integration Status" = const(Failed)));
        }
        field(12; "In Progress"; Integer)
        {
            Caption = 'In Progress';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("Integration Status" = const(Processing)));
        }
        field(13; "Processed Successfully"; Integer)
        {
            Caption = 'Processed Successfully';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("Integration Status" = const(Success)));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'CUE';
    end;
}
