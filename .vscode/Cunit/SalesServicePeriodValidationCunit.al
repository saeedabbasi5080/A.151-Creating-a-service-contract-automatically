// #region CR-26042025-service mangment-Creating a service contract automatically
codeunit 50102 "SalesServPeriodValidationCunit"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    // local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; SkipCheckReleaseRestrictions: Boolean)
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin

        // Skip validation in Preview Mode
        if PreviewMode then
            exit;

        // Skip validation for Sales Return Orders
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
            exit;

        // Skip validation if service period is not mandatory
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."Service contract automation" then
            exit;

        ValidateServicePeriod(SalesHeader);
    end;


    local procedure ValidateServicePeriod(SalesHeader: Record "Sales Header")
    var
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin

        SetSalesLineFilters(SalesLine, SalesHeader);

        if SalesLine.FindSet() then begin
            repeat
                if Item.Get(SalesLine."No.") then begin
                    // Check if item has Service Item Group
                    if Item."Service Item Group" <> '' then begin
                        // Get Service Management Setup
                        ServiceMgtSetup.Get();

                        // Validate Default Warranty Duration
                        if Format(ServiceMgtSetup."Default Warranty Duration") = '' then begin
                            Error('Default Warranty Duration must be specified in Service Management Setup');
                        end;
                    end;
                end;
            until SalesLine.Next() = 0;
        end;
    end;

    // Process Sales Lines
    local procedure SetSalesLineFilters(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header")
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
    end;
}

// #endregion CR-26042025-service mangment-Creating a service contract automatically
