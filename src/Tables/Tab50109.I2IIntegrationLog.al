// table 50109 "I2I Integration Log"
// {
//     Caption = 'Integration Log';
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "I2I Entry No."; Integer)
//         {
//             Caption = 'Entry No.';
//         }
//         field(2; "I2I Entity Type"; Enum "I2I Log Entity Type")
//         {
//             Caption = 'Entity Type';
//         }
//         field(3; "I2I i6 Order Number"; Code[20])
//         {
//             Caption = 'i6 Order Number';
//         }
//         field(4; "I2I Header Entry No."; Integer)
//         {
//             Caption = 'Header Entry No.';
//         }
//         field(5; "I2I Integration Status"; Enum "I2I Integration Status")
//         {
//             Caption = 'Integration Status';
//         }
//         field(6; "I2I Error Message"; Text[2048])
//         {
//             Caption = 'Error Message';
//         }
//         field(7; "I2I Logged At"; DateTime)
//         {
//             Caption = 'Logged At';
//         }
//         field(8; "I2I Logged By"; Code[50])
//         {
//             Caption = 'Logged By';
//         }
//         field(9; "I2I Payload"; Blob)
//         {
//             Caption = 'Payload';
//         }
//     }
//     keys
//     {
//         key(PK; "I2I Entry No.")
//         {
//             Clustered = true;
//         }
//         key(OrderKey; "I2I i6 Order Number") { }
//     }

//     trigger OnInsert()
//     begin
//         "I2I Logged At" := CurrentDateTime();
//         "I2I Logged By" := CopyStr(UserId(), 1, MaxStrLen("I2I Logged By"));
//     end;
// }