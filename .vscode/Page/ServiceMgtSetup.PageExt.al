#region CR-26042025-service mangment-Creating a service contract automatically
pageextension 50101 "ServiceMgtSetupPageExt" extends "Service Mgt. Setup"
{
    layout
    {
        addlast(General)
        {
            field("Service contract automation"; Rec."Service contract automation")
            {
                ApplicationArea = All;
                Caption = 'Service contract automation';
                ToolTip = 'Automatically creates a service contract for the service item.';
            }
            field("Auto Service Item Date Update"; Rec."Auto Service Item Date Update")
            {
                ApplicationArea = All;
                Caption = 'Auto Service Item Date Update';
                ToolTip = 'Automatically updates the dates of related service items based on the service contract.';
            }
            field("Locked Service Item"; Rec."Locked Service Item")
            {
                ApplicationArea = All;
                Caption = 'Locked Service Item';
                ToolTip = 'Prevents changes to the dates of the service item.';
            }
        }
    }

}

#endregion CR-26042025-service mangment-Creating a service contract automatically