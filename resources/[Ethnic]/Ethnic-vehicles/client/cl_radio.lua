Citizen.CreateThread(function()
    while true do
       Citizen.Wait(0)
       DisableReports()
    end
 end)
 
 function DisableReports()
     DisablePoliceReports()
 end