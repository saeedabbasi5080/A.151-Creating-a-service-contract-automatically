#region CR-26042025-service mangment-Creating a service contract automatically
codeunit 50904 "ServiceContractDateSyncCunit"
{
    // This codeunit provides validation and synchronization logic
    // for Service Contract and Service Item date management

    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterServiceContractHeaderModify(var Rec: Record "Service Contract Header"; var xRec: Record "Service Contract Header")
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        ServiceMgtSetup.Get();
        if ServiceMgtSetup."Auto Service Item Date Update" then begin
            if (Rec."Expiration Date" <> xRec."Expiration Date") or (Rec."Starting Date" <> xRec."Starting Date") then
                UpdateServiceItemsFromContract(Rec);
        end;
    end;

    procedure UpdateServiceItemsFromContract(ServiceContractHeader: Record "Service Contract Header")
    var
        ServiceContractLine: Record "Service Contract Line";
        ServiceItem: Record "Service Item";
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        // Check if auto update is enabled
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."Auto Service Item Date Update" then
            exit;

        // Update all related Service Items
        ServiceContractLine.SetRange("Contract Type", ServiceContractHeader."Contract Type");
        ServiceContractLine.SetRange("Contract No.", ServiceContractHeader."Contract No.");

        if ServiceContractLine.FindSet() then
            repeat
                if ServiceItem.Get(ServiceContractLine."Service Item No.") then begin
                    // Update all warranty dates directly (including empty dates)
                    ServiceItem."Warranty Starting Date (Labor)" := ServiceContractHeader."Starting Date";
                    ServiceItem."Warranty Starting Date (Parts)" := ServiceContractHeader."Starting Date";
                    ServiceItem."Warranty Ending Date (Labor)" := ServiceContractHeader."Expiration Date";
                    ServiceItem."Warranty Ending Date (Parts)" := ServiceContractHeader."Expiration Date";

                    ServiceItem.Modify();
                end;
            until ServiceContractLine.Next() = 0;
    end;
}
#endregion CR-26042025-service mangment-Creating a service contract automatically