#region CR-26042025-service mangment-Creating a service contract automatically
pageextension 50905 "ServiceItemPageExt" extends "Service Item Card"
{
    layout
    {
        modify("Warranty Starting Date (Labor)")
        {
            trigger OnAfterValidate()
            begin
                ValidateWarrantyDateChange('Warranty Starting Date (Labor)');
            end;
        }

        modify("Warranty Ending Date (Labor)")
        {
            trigger OnAfterValidate()
            begin
                ValidateWarrantyDateChange('Warranty Ending Date (Labor)');
            end;
        }

        modify("Warranty Starting Date (Parts)")
        {
            trigger OnAfterValidate()
            begin
                ValidateWarrantyDateChange('Warranty Starting Date (Parts)');
            end;
        }

        modify("Warranty Ending Date (Parts)")
        {
            trigger OnAfterValidate()
            begin
                ValidateWarrantyDateChange('Warranty Ending Date (Parts)');
            end;
        }
    }

    local procedure ValidateWarrantyDateChange(FieldName: Text)
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
        ErrorMsg: Label 'Warranty dates cannot be changed directly in Service Item. Please make change in related Service Contract instead.';
    begin
        ServiceMgtSetup.Get();
        if ServiceMgtSetup."Locked Service Item" then begin
            // Check if the field value has changed from the original record
            case FieldName of
                'Warranty Starting Date (Labor)':
                    if Rec."Warranty Starting Date (Labor)" <> xRec."Warranty Starting Date (Labor)" then
                        Error(ErrorMsg);
                'Warranty Ending Date (Labor)':
                    if Rec."Warranty Ending Date (Labor)" <> xRec."Warranty Ending Date (Labor)" then
                        Error(ErrorMsg);
                'Warranty Starting Date (Parts)':
                    if Rec."Warranty Starting Date (Parts)" <> xRec."Warranty Starting Date (Parts)" then
                        Error(ErrorMsg);
                'Warranty Ending Date (Parts)':
                    if Rec."Warranty Ending Date (Parts)" <> xRec."Warranty Ending Date (Parts)" then
                        Error(ErrorMsg);
            end;
        end;
    end;
}
#endregion CR-26042025-service mangment-Creating a service contract automatically 