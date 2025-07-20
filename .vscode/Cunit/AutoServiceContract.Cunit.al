#region CR-26042025-service mangment-Creating a service contract automatically
codeunit 50901 "AutoServiceContractCunit"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        // Skip if no shipment was created
        if SalesShipmentHeader."No." = '' then
            exit;

        // Skip create service contract if not mandatory
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."Service contract automation" then
            exit;

        ProcessServiceContracts(SalesHeader, SalesShipmentHeader);
    end;

    local procedure ProcessServiceContracts(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        ServiceItem: Record "Service Item";
        SalesShipmentLine: Record "Sales Shipment Line";
        ServiceItemList: List of [Code[20]];
    begin
        // Get all service items from all shipment lines
        SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
        if SalesShipmentLine.FindSet() then
            repeat
                if ValidateServiceItemConditions(SalesShipmentLine) then begin
                    // Get service items for this line
                    ServiceItem.SetRange("Item No.", SalesShipmentLine."No.");
                    ServiceItem.SetRange("Sales/Serv. Shpt. Document No.", SalesShipmentLine."Document No.");
                    if ServiceItem.FindSet() then
                        repeat
                            if not ServiceItemList.Contains(ServiceItem."No.") then
                                ServiceItemList.Add(ServiceItem."No.");
                        until ServiceItem.Next() = 0;
                end;
            until SalesShipmentLine.Next() = 0;

        // Create service contract with all service items
        if ServiceItemList.Count > 0 then
            CreateServiceContract(SalesHeader, SalesShipmentHeader, ServiceItemList);
    end;

    local procedure ValidateServiceItemConditions(var SalesShptLine: Record "Sales Shipment Line"): Boolean
    var
        Item: Record Item;
        ServiceItemGroup: Record "Service Item Group";
    begin
        // Process only Item type shipment lines
        if SalesShptLine.Type <> SalesShptLine.Type::Item then
            exit(false);

        // Validate Item
        if not Item.Get(SalesShptLine."No.") then
            exit(false);

        // Validate Service Item Group
        if Item."Service Item Group" = '' then
            exit(false);

        if not ServiceItemGroup.Get(Item."Service Item Group") then
            exit(false);

        // Check if Service Item Group allows creating Service Items
        if not ServiceItemGroup."Create Service Item" then
            exit(false);

        exit(true);
    end;

    local procedure CreateServiceContract(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var ServiceItemList: List of [Code[20]])
    var
        ContractHeader: Record "Service Contract Header";
        ServiceItem: Record "Service Item";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ServiceItemNo: Code[20];
    begin
        // Initialize Service Management Setup
        InitializeServiceMgtSetup(ServiceMgtSetup);

        // Create the contract header
        CreateContractHeader(ContractHeader, SalesShipmentHeader, ServiceMgtSetup, NoSeriesMgt);

        // Add all service items to the contract
        foreach ServiceItemNo in ServiceItemList do begin
            if ServiceItem.Get(ServiceItemNo) then
                CreateContractLine(ContractHeader, ServiceItem, ServiceMgtSetup);
        end;
    end;

    local procedure InitializeServiceMgtSetup(var ServiceMgtSetup: Record "Service Mgt. Setup")
    begin
        ServiceMgtSetup.Get();
        if ServiceMgtSetup."Service Contract Nos." = '' then
            Error('Service Contract Nos. must be configured in Service Management Setup.');
    end;

    local procedure CreateContractHeader(var ContractHeader: Record "Service Contract Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var ServiceMgtSetup: Record "Service Mgt. Setup"; var NoSeriesMgt: Codeunit NoSeriesManagement)
    begin
        ContractHeader.Init();
        ContractHeader."Contract Type" := ContractHeader."Contract Type"::Contract;
        ContractHeader."Contract No." := NoSeriesMgt.GetNextNo(ServiceMgtSetup."Service Contract Nos.", SalesShipmentHeader."Posting Date", true);
        ContractHeader."Contact No." := SalesShipmentHeader."Sell-to Contact No.";
        ContractHeader."Bill-to Contact No." := SalesShipmentHeader."Bill-to Contact No.";
        ContractHeader."Starting Date" := SalesShipmentHeader."Posting Date";
        ContractHeader."Service Period" := ServiceMgtSetup."Default Warranty Duration";
        ContractHeader."Customer No." := SalesShipmentHeader."Sell-to Customer No.";
        ContractHeader."Bill-to Customer No." := SalesShipmentHeader."Bill-to Customer No.";
        ContractHeader."Phone No." := SalesShipmentHeader."Sell-to Phone No.";
        ContractHeader."E-Mail" := SalesShipmentHeader."Sell-to E-Mail";
        ContractHeader.Insert(true);
    end;

    local procedure CreateContractLine(var ContractHeader: Record "Service Contract Header"; var ServiceItem: Record "Service Item"; var ServiceMgtSetup: Record "Service Mgt. Setup")
    var
        ContractLine: Record "Service Contract Line";
    begin
        ContractLine.Init();
        ContractLine."Contract No." := ContractHeader."Contract No.";
        ContractLine."Contract Type" := ContractHeader."Contract Type";
        ContractLine."Line No." := GetNextLineNo(ContractHeader);
        ContractLine."Service Item No." := ServiceItem."No.";
        ContractLine.Description := ServiceItem.Description;
        ContractLine."Unit of Measure Code" := ServiceItem."Unit of Measure Code";
        ContractLine."Serial No." := ServiceItem."Serial No.";
        ContractLine."Item No." := ServiceItem."Item No.";
        ContractLine."Response Time (Hours)" := ServiceItem."Response Time (Hours)";
        ContractLine."Service Period" := ServiceMgtSetup."Default Warranty Duration";
        ContractLine.Insert(true);
    end;

    local procedure GetNextLineNo(ContractHeader: Record "Service Contract Header"): Integer
    var
        ContractLine: Record "Service Contract Line";
    begin
        ContractLine.LockTable();
        ContractLine.SetRange("Contract Type", ContractHeader."Contract Type");
        ContractLine.SetRange("Contract No.", ContractHeader."Contract No.");
        if ContractLine.FindLast() then
            exit(ContractLine."Line No." + 10000);
        exit(10000);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertShipmentLine', '', false, false)]
    local procedure OnAfterInsertShipmentLine(Var SalesHeader: Record "Sales Header"; Var SalesLine: Record "Sales Line"; Var SalesShptLine: Record "Sales Shipment Line"; previewMode: Boolean; xSalesLine: Record "Sales Line")
    begin
        // Skip ProcessServiceContracts in Preview Mode
        if PreviewMode then
            exit;
    end;

}
#endregion CR-26042025-service mangment-Creating a service contract automatically
