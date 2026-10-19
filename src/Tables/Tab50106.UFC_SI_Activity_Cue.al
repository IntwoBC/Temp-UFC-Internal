table 50106 "UFC SI Activity Cue"
{
    Caption = 'UFC i6 Sales Invoice Activities';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "I2I Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "I2I Ready to Process"; Integer)
        {
            Caption = 'Ready to Process';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("I2I Integration Status" = const(Open)));
        }
        field(11; "I2I Attention Required"; Integer)
        {
            Caption = 'Attention Required';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("I2I Integration Status" = const(Failed)));
        }
        field(12; "I2I In Progress"; Integer)
        {
            Caption = 'In Progress';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("I2I Integration Status" = const(Processing)));
        }
        field(13; "I2I Processed Successfully"; Integer)
        {
            Caption = 'Processed Successfully';
            FieldClass = FlowField;
            CalcFormula = count("UFC SI Header Staging" where("I2I Integration Status" = const(Success)));
        }
    }

    keys
    {
        key(PK; "I2I Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "I2I Primary Key" = '' then
            "I2I Primary Key" := 'CUE';
    end;
}
