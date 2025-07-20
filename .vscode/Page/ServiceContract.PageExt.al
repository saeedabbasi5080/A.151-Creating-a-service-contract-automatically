#region CR-26042025-service mangment-Creating a service contract automatically
pageextension 50903 "ServiceContractPageExt" extends "Service Contract"
{
    layout
    {
        modify("Starting Date")
        {
            trigger OnAfterValidate()
            begin
                ValidateStartingDate();
                UpdateServiceItemsImmediately();
            end;
        }

        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin
                ValidateExpirationDate();
                UpdateServiceItemsImmediately();
            end;
        }
    }

    local procedure ValidateStartingDate()
    var
        ErrorMsg: Label 'Starting Date cannot be after Expiration Date.';
    begin
        // Only validate if both dates are filled
        if (Rec."Starting Date" <> 0D) and (Rec."Expiration Date" <> 0D) then begin
            if Rec."Starting Date" > Rec."Expiration Date" then
                Error(ErrorMsg);
        end;
    end;

    local procedure ValidateExpirationDate()
    var
        ErrorMsg: Label 'Expiration Date cannot be before Starting Date.';
    begin
        // Only validate if both dates are filled
        if (Rec."Starting Date" <> 0D) and (Rec."Expiration Date" <> 0D) then begin
            if Rec."Expiration Date" < Rec."Starting Date" then
                Error(ErrorMsg);
        end;
    end;

    local procedure UpdateServiceItemsImmediately()
    var
        ServiceContractDateSyncCunit: Codeunit "ServiceContractDateSyncCunit";
    begin
        // Update service items whenever any date field is changed
        ServiceContractDateSyncCunit.UpdateServiceItemsFromContract(Rec);
    end;
}
#endregion CR-26042025-service mangment-Creating a service contract automatically 