#region CR-26042025-service mangment-Creating a service contract automatically
codeunit 50103 "ServiceContractDateSyncCunit"
{
    // This codeunit provides validation and synchronization logic
    // for Service Contract and Service Item date management

    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterServiceContractHeaderModify(var Rec: Record "Service Contract Header"; var xRec: Record "Service Contract Header")
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."Auto Service Item Date Update" then
            exit;

        if (Rec."Expiration Date" <> xRec."Expiration Date") or (Rec."Starting Date" <> xRec."Starting Date") then
            UpdateServiceItemsFromContract(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Item", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeServiceItemModify(var Rec: Record "Service Item"; var xRec: Record "Service Item")
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."Locked Service Item" then
            exit;

        // Prevent any manual changes to warranty dates
        PreventManualWarrantyDateChanges(Rec, xRec);
    end;

    local procedure PreventManualWarrantyDateChanges(var ServiceItem: Record "Service Item"; var xServiceItem: Record "Service Item")
    var
        ErrorMsg: Label 'Warranty dates cannot be changed directly in Service Item. Please make change in related Service Contract instead.';
    begin
        // Check if user is trying to manually change any warranty dates
        if (ServiceItem."Warranty Starting Date (Labor)" <> xServiceItem."Warranty Starting Date (Labor)") or
           (ServiceItem."Warranty Ending Date (Labor)" <> xServiceItem."Warranty Ending Date (Labor)") or
           (ServiceItem."Warranty Starting Date (Parts)" <> xServiceItem."Warranty Starting Date (Parts)") or
           (ServiceItem."Warranty Ending Date (Parts)" <> xServiceItem."Warranty Ending Date (Parts)") then begin

            // Revert all changes to warranty dates
            ServiceItem."Warranty Starting Date (Labor)" := xServiceItem."Warranty Starting Date (Labor)";
            ServiceItem."Warranty Ending Date (Labor)" := xServiceItem."Warranty Ending Date (Labor)";
            ServiceItem."Warranty Starting Date (Parts)" := xServiceItem."Warranty Starting Date (Parts)";
            ServiceItem."Warranty Ending Date (Parts)" := xServiceItem."Warranty Ending Date (Parts)";

            Error(ErrorMsg);
        end;
    end;

    local procedure UpdateServiceItemsFromContract(ServiceContractHeader: Record "Service Contract Header")
    var
        ServiceContractLine: Record "Service Contract Line";
        ServiceItem: Record "Service Item";
    begin
        // Update all related Service Items
        ServiceContractLine.SetRange("Contract Type", ServiceContractHeader."Contract Type");
        ServiceContractLine.SetRange("Contract No.", ServiceContractHeader."Contract No.");

        if ServiceContractLine.FindSet() then
            repeat
                if ServiceItem.Get(ServiceContractLine."Service Item No.") then begin
                    // Update all warranty dates
                    ServiceItem."Warranty Starting Date (Labor)" := ServiceContractHeader."Starting Date";
                    ServiceItem."Warranty Ending Date (Labor)" := ServiceContractHeader."Expiration Date";
                    ServiceItem."Warranty Starting Date (Parts)" := ServiceContractHeader."Starting Date";
                    ServiceItem."Warranty Ending Date (Parts)" := ServiceContractHeader."Expiration Date";

                    ServiceItem.Modify();
                end;
            until ServiceContractLine.Next() = 0;
    end;
}
#endregion CR-26042025-service mangment-Creating a service contract automatically