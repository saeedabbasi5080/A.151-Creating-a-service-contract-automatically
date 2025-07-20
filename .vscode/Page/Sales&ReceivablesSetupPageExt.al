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
            }
            field("Auto Service Item Date Update"; Rec."Auto Service Item Date Update")
            {
                ApplicationArea = All;
                Caption = 'Auto Service Item Date Update';
            }
            field("Locked Service Item"; Rec."Locked Service Item")
            {
                ApplicationArea = All;
                Caption = 'Locked Service Item';
            }
        }
    }

}

#endregion CR-26042025-service mangment-Creating a service contract automatically