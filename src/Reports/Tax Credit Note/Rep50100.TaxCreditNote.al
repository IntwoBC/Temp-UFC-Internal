report 50100 "I2I Tax Credit Note"
{
    ApplicationArea = All;
    Caption = 'Tax Credit Note';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Tax Credit Note\TaxCreditNote.rdl';
    dataset
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            column(No_SalesCrMemoHeader; "No.") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Due_Date; Format("Due Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(CustomerName; CustomerName) { }
            column(CustomerNameAb; CustomerNameAb) { }
            column(CustomerAddress; CustomerAddress) { }
            column(CustomerAddressAb; CustomerAddressAb) { }
            column(ContactName; ContactName) { }
            column(CustomerPhNo; CustomerPhNo) { }
            column(Currency_Code; "Currency Code") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Amount; Amount) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(TotalVATAmount; TotalVATAmount) { }
            //Company Information Labels >>
            column(CompanyPicture; CompanyInformation.Picture) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(CompanyAddress; CompanyAddress) { }
            column(CompanyBankName; CompanyInformation."Bank Name") { }
            column(CompanySwiftCode; CompanyInformation."SWIFT Code") { }
            column(CompanyEmail; CompanyInformation."E-Mail") { }
            column(CompanyVATRegNo; CompanyInformation."VAT Registration No.") { }
            column(CompanyArabicName; CompanyInformation."I2I Name in Arabic") { }
            column(CompanyArabicAddress; CompanyInformation."I2I Address in Arabic") { }
            column(CompanyIBAN; CompanyInformation.IBAN) { }
            //Company Information Labels <<
            // English report label columns >>
            column(CreditNoteLbl; CreditNoteLbl) { }
            column(InvoiceDetailsLbl; InvoiceDetailsLbl) { }
            column(DateLbl; DateLbl) { }
            column(NumberLbl; NumberLbl) { }
            column(PeriodLbl; PeriodLbl) { }
            column(TermsLbl; TermsLbl) { }
            column(DueDateLbl; DueDateLbl) { }
            column(CurrencyLbl; CurrencyLbl) { }
            column(OriginalInvNoLbl; OriginalInvNoLbl) { }
            column(SupplyInfoLbl; SupplyInfoLbl) { }
            column(NameLbl; NameLbl) { }
            column(ContactLbl; ContactLbl) { }
            column(VATNoLbl; VATNoLbl) { }
            column(AddressLbl; AddressLbl) { }
            column(BankLbl; BankLbl) { }
            column(BeneficiaryLbl; BeneficiaryLbl) { }
            column(IBANLbl; IBANLbl) { }
            column(SwiftLbl; SwiftLbl) { }
            column(CustomerInfoLbl; CustomerInfoLbl) { }
            column(PhoneNoLbl; PhoneNoLbl) { }
            column(SerialLbl; SerialLbl) { }
            column(SupplyDateLbl; SupplyDateLbl) { }
            column(ItemDesLbl; ItemDesLbl) { }
            column(TicketNoLbl; TicketNoLbl) { }
            column(DestLbl; DestLbl) { }
            column(SubCustLbl; SubCustLbl) { }
            column(TypeLbl; TypeLbl) { }
            column(RegistrationLbl; RegistrationLbl) { }
            column(FlightNoLbl; FlightNoLbl) { }
            column(QtyLbl; QtyLbl) { }
            column(UOMLbl; UOMLbl) { }
            column(UnitPrLbl; UnitPrLbl) { }
            column(PriceExclVATLbl; PriceExclVATLbl) { }
            column(VATLbl; VATLbl) { }
            column(TotalExclLbl; TotalExclLbl) { }
            column(VATAmountLbl; VATAmountLbl) { }
            column(TotalInclLbl; TotalInclLbl) { }
            column(DueBalanceLbl; DueBalanceLbl) { }
            // English report label columns <<
            // Arabic report label columns >>
            column(CreditNoteLblAb; CreditNoteLblAb) { }
            column(InvoiceDetailsLblAb; InvoiceDetailsLblAb) { }
            column(DateLblAb; DateLblAb) { }
            column(NumberLblAb; NumberLblAb) { }
            column(PeriodLblAb; PeriodLblAb) { }
            column(TermsLblAb; TermsLblAb) { }
            column(DueDateLblAb; DueDateLblAb) { }
            column(CurrencyLblAb; CurrencyLblAb) { }
            column(OriginalInvNoLblAb; OriginalInvNoLblAb) { }
            column(SupplyInfoLblAb; SupplyInfoLblAb) { }
            column(NameLblAb; NameLblAb) { }
            column(ContactLblAb; ContactLblAb) { }
            column(VATNoLblAb; VATNoLblAb) { }
            column(AddressLblAb; AddressLblAb) { }
            column(BankLblAb; BankLblAb) { }
            column(BeneficiaryLblAb; BeneficiaryLblAb) { }
            column(IBANLblAb; IBANLblAb) { }
            column(SwiftLblAb; SwiftLblAb) { }
            column(CustomerInfoLblAb; CustomerInfoLblAb) { }
            column(PhoneNoLblAb; PhoneNoLblAb) { }
            column(SerialLblAb; SerialLblAb) { }
            column(SupplyDateLblAb; SupplyDateLblAb) { }
            column(ItemDesLblAb; ItemDesLblAb) { }
            column(TicketNoLblAb; TicketNoLblAb) { }
            column(DestLblAb; DestLblAb) { }
            column(SubCustLblAb; SubCustLblAb) { }
            column(TypeLblAb; TypeLblAb) { }
            column(RegistrationLblAb; RegistrationLblAb) { }
            column(FlightNoLblAb; FlightNoLblAb) { }
            column(QtyLblAb; QtyLblAb) { }
            column(UOMLblAb; UOMLblAb) { }
            column(UnitPrLblAb; UnitPrLblAb) { }
            column(PriceExclVATLblAb; PriceExclVATLblAb) { }
            column(VATLblAb; VATLblAb) { }
            column(TotalExclLblAb; TotalExclLblAb) { }
            column(VATAmountLblAb; VATAmountLblAb) { }
            column(TotalInclLblAb; TotalInclLblAb) { }
            column(DueBalanceLblAb; DueBalanceLblAb) { }
            // Arabic report label columns <<
            column(OriginalInvoiceText; OriginalInvoiceText) { }
            column(TotalQty; TotalQty) { }
            column(FooterLbl; FooterLbl) { }
            column(FooterLbl2; FooterLbl2) { }
            column(FooterLbl3; FooterLbl3) { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(SerialNo; SerialNo) { }
                column(Document_No_; "Document No.") { }
                column(Type; Type) { }
                column(No_; "No.") { }
                column(Shipment_Date; Format("Shipment Date", 0, '<Day,2>-<Month>-<Year4>')) { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Unit_Price; "Unit Price") { }
                column(VATPercentage; StrSubstNo('%1%', Format("VAT %", 0, '<Precision,2:2><Standard Format,0>'))) { }
                column(Line_Amount; "Line Amount") { }
                column(Amount_Including_VATL; "Amount Including VAT") { }
                column(TotalVATAmountLine; TotalVATAmountLine) { }
                column(I2ITicketNo; "I2I Ticket No.") { }
                column(I2IDest; "I2I Dest.") { }
                column(I2ISubCust; "I2I Sub Cust") { }
                column(I2IType; "I2I Type") { }
                column(I2IRegistration; "I2I Registration") { }
                column(I2IFlightNo; "I2I Flight No.") { }
                trigger OnPreDataItem()
                begin
                    TotalVATAmountLine := 0;
                    SerialNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    SerialNo += 1;
                    TotalVATAmountLine := "Amount Including VAT" - Amount;
                end;
            }
            trigger OnPreDataItem()
            begin
                TotalVATAmount := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(TotalQty);
                CalcFields(Amount, "Amount Including VAT");
                TotalVATAmount := "Amount Including VAT" - Amount;
                TotalQty := 'SubTotal: ' + Format(GetTotalQuantity(SalesCrMemoHeader."No."));
                CompanyAddress := MergeFields(CompanyInformation.Address, CompanyInformation."Address 2");
                GetCustomerData(SalesCrMemoHeader."Bill-to Customer No.", SalesCrMemoHeader."Bill-to Contact");
            end;
        }
    }
    trigger OnInitReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        TotalVATAmount: Decimal;
        SerialNo: Integer;
        TotalQty: Text[100];
        TotalVATAmountLine: Decimal;
        // Shared report captions used by the RDLC layout.
        CreditNoteLbl: Label 'Credit Note';
        CreditNoteLblAb: Label 'اﺷﻌﺎر داﺋن';
        InvoiceDetailsLbl: Label 'Invoice Details';
        InvoiceDetailsLblAb: Label 'تفاصيل الفاتورة';
        DateLbl: Label 'Date';
        DateLblAb: Label 'التاريخ';
        NumberLbl: Label 'Number';
        NumberLblAb: Label 'الرقم';
        PeriodLbl: Label 'Period';
        PeriodLblAb: Label 'الفترة';
        TermsLbl: Label 'Terms';
        TermsLblAb: Label 'الشروط';
        DueDateLbl: Label 'Due Date';
        DueDateLblAb: Label 'تاريخ الاستحقاق';
        CurrencyLbl: Label 'Currency';
        CurrencyLblAb: Label 'العملة';
        OriginalInvNoLbl: Label 'Original Invoice No.';
        OriginalInvNoLblAb: Label 'رقم الفاتورة الأصلي';
        SupplyInfoLbl: Label 'Supply Information';
        SupplyInfoLblAb: Label 'معلومات التوريد';
        NameLbl: Label 'Name';
        NameLblAb: Label 'الاسم';
        ContactLbl: Label 'Contact';
        ContactLblAb: Label 'جهة الاتصال';
        VATNoLbl: Label 'VAT No.';
        VATNoLblAb: Label 'الرقم الضريبي';
        AddressLbl: Label 'Address';
        AddressLblAb: Label 'العنوان';
        BankLbl: Label 'Bank';
        BankLblAb: Label 'البنك';
        BeneficiaryLbl: Label 'Beneficiary';
        BeneficiaryLblAb: Label 'المستفيد';
        IBANLbl: Label 'IBAN';
        IBANLblAb: Label 'رقم الآيبان';
        SwiftLbl: Label 'Swift Code';
        SwiftLblAb: Label 'رمز السويفت';
        CustomerInfoLbl: Label 'Customer Information';
        CustomerInfoLblAb: Label 'معلومات العميل';
        PhoneNoLbl: Label 'Phone';
        PhoneNoLblAb: Label 'الهاتف';
        SerialLbl: Label 'Serial';
        SerialLblAb: Label 'التسلسل';
        SupplyDateLbl: Label 'Supply Date';
        SupplyDateLblAb: Label 'تاريخ التوريد';
        ItemDesLbl: Label 'Item Description';
        ItemDesLblAb: Label 'وصف الصنف';
        TicketNoLbl: Label 'Ticket No.';
        TicketNoLblAb: Label 'رقم التذكرة';
        DestLbl: Label 'Dest.';
        DestLblAb: Label 'الوجهة';
        SubCustLbl: Label 'Sub Cust';
        SubCustLblAb: Label 'العميل الفرعي';
        TypeLbl: Label 'Type';
        TypeLblAb: Label 'النوع';
        RegistrationLbl: Label 'Registration';
        RegistrationLblAb: Label 'التسجيل';
        FlightNoLbl: Label 'Flight No.';
        FlightNoLblAb: Label 'رقم الرحلة';
        QtyLbl: Label 'Quantity/Litre';
        QtyLblAb: Label 'الكمية/اللتر';
        UOMLbl: Label 'UOM';
        UOMLblAb: Label 'وحدة القياس';
        UnitPrLbl: Label 'Unit Price ltr';
        UnitPrLblAb: Label 'سعر الوحدة لتر';
        PriceExclVATLbl: Label 'Price Excl. VAT';
        PriceExclVATLblAb: Label 'القيمة بدون ضريبة';
        VATLbl: Label 'VAT %';
        VATLblAb: Label 'ضريبية %';
        TotalExclLbl: Label 'Total Excl. VAT';
        TotalExclLblAb: Label 'الاجمالي قبل الضریبة';
        VATAmountLbl: Label 'VAT Amount';
        VATAmountLblAb: Label 'ضريبة القيمة';
        TotalInclLbl: Label 'Total Incl. VAT';
        TotalInclLblAb: Label 'الإجمالي';
        DueBalanceLbl: Label 'Due Balance';
        DueBalanceLblAb: Label 'المستحق الاجمالي';
        CompanyAddress: Text[250];
        CustomerAddress: Text[250];
        CustomerName: Text[100];
        CustomerPhNo: Text[100];
        CustomerNameAb: Text[100];
        CustomerAddressAb: Text[100];
        ContactName: Text[100];
        OriginalInvoiceText: Text[100];
        FooterLbl: Label 'Note: Zero rate (0%) is applied subject to the exception provided under Article No. 34 (Transportation services for goods or passengers outside the Kingdom and supplies';

        FooterLbl2: Label 'relating to transportation), paragraph 6 (Supply of goods and services in relation to a qualifying means of transport) of the KSA VAT Implementing Regulations.';

        FooterLbl3: Label 'ملاحظة: تطبق نسبة الصفر بالمائة (0%) مع مراعاة الاستثناء المنصوص عليه في المادة رقم 34 (خدمات النقل للبضائع أو الركاب خارج المملكة والتوريدات المتعلقة بالنقل)، الفقرة 6 (توريد السلع والخدمات فيما يتعلق بوسائل النقل المؤهلة) من اللائحة التنفيذية لضريبة القيمة المضافة في المملكة العربية السعودية.';

    procedure MergeFields(Address1: Text[100]; Address2: Text[100]) Address: Text
    begin
        if Address1 <> '' then
            Address := Address1;

        if Address2 <> '' then begin
            if Address <> '' then
                Address += ', ';

            Address += Address2;
        end;

        exit(Address);
    end;

    procedure GetCustomerData(CustomerNo: Code[20]; ContactCode: Code[20])
    var
        Customer: Record Customer;
        Contact: Record Contact;
    begin
        if Customer.Get(CustomerNo) then begin
            CustomerName := Customer.Name;
            CustomerAddress := MergeFields(Customer.Address, Customer."Address 2");
            CustomerPhNo := Customer."Phone No.";
            CustomerNameAb := Customer."I2I Name in Arabic";
            CustomerAddressAb := Customer."I2I Address in Arabic";
        end;

        if Contact.Get(ContactCode) then
            ContactName := Contact.Name;
    end;

    procedure GetTotalQuantity(DocumentNo: Code[20]): Decimal
    var
        CrMemoLines: Record "Sales Cr.Memo Line";
    begin
        OriginalInvoiceText := '';

        CrMemoLines.SetRange("Document No.", DocumentNo);
        CrMemoLines.SetLoadFields(Description, Quantity);
        if CrMemoLines.FindFirst() then
            OriginalInvoiceText := CrMemoLines.Description;
        CrMemoLines.CalcSums(Quantity);
        exit(CrMemoLines.Quantity);
    end;
}