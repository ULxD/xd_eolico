local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
---------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO --------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
xD = {}
Tunnel.bindInterface("xd_eolico",xD)
vCLIENT = Tunnel.getInterface("xd_eolico")
---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS --------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

function xD.TiraRoupa()
  local source = source
  local user_id = vRP.getUserId(source)
    if user_id then						
      vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
      Citizen.Wait(2500)
      vRPclient._stopAnim(source,true)
      vRP.removeCloak(source)
    end
end


function xD.payment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local money = (math.random(600,800))
        vRP.giveMoney(user_id,money)
        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(money)).." dólares</b>.")
        print(money)
    end
end

function xD.checkStress()
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserDataTable(user_id)
	if data then
	  if data.stress >= 90 then
		TriggerClientEvent("eolico:stopWorking",source)
	  end
	end
end