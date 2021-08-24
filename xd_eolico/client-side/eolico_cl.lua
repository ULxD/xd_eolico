-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
---------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO --------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
xD = {}
Tunnel.bindInterface("xd_eolico",xD)
vSERVER = Tunnel.getInterface("xd_eolico")
---------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS --------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
local servico = false
local uni = false
local selecionado = 1
local locs = {
	[1] = { ['x'] = 2200.15, ['y'] = 2490.41, ['z'] = 89.38 },
    [2] = { ['x'] = 2116.98, ['y'] = 2401.58, ['z'] = 101.6 },
    [3] = { ['x'] = 2098.11, ['y'] = 2495.27, ['z'] = 91.66 },
    [4] = { ['x'] = 2360.27, ['y'] = 2290.11, ['z'] = 95.11 },
    [5] = { ['x'] = 2330.04, ['y'] = 2118.54, ['z'] = 109.14 },
    [6] = { ['x'] = 2287.08, ['y'] = 2076.34, ['z'] = 123.89 },
    [7] = { ['x'] = 2307.49, ['y'] = 1971.15, ['z'] = 132.18 },
    [8] = { ['x'] = 2266.84, ['y'] = 1916.88, ['z'] = 124.15 },
    [9] = { ['x'] = 2237.68, ['y'] = 2044.16, ['z'] = 131.67 },
    [10] = { ['x'] = 2133.84, ['y'] = 1990.06, ['z'] = 97.15 },
    [11] = { ['x'] = 2170.54, ['y'] = 1934.22, ['z'] = 99.54 },
    [12] = { ['x'] = 2053.92, ['y'] = 2001.05, ['z'] = 87.15 },
    [13] = { ['x'] = 2027.81, ['y'] = 1842.58, ['z'] = 96.6 },
    [14] = { ['x'] = 2122.5, ['y'] = 1751.3, ['z'] = 104.15 },
    [15] = { ['x'] = 2238.0, ['y'] = 1532.53, ['z'] = 75.38 },
    [16] = { ['x'] = 2207.78, ['y'] = 1403.64, ['z'] = 82.39 },
    [17] = { ['x'] = 2316.35, ['y'] = 1332.03, ['z'] = 70.65 },
    [18] = { ['x'] = 2317.81, ['y'] = 1609.37, ['z'] = 58.79 },
    [19] = { ['x'] = 2360.59, ['y'] = 1395.33, ['z'] = 59.62 },
    [20] = { ['x'] = 2403.65, ['y'] = 1422.57, ['z'] = 47.4 },
    [21] = { ['x'] = 2470.34, ['y'] = 1476.21, ['z'] = 36.21 },
}
---------------------------------------------------------------------------------------------------------------------------------
-- ENTRAR EM SERVIÇO --------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local wait = 1000
		local dist = Vdist(GetEntityCoords(PlayerPedId()),2461.72,1576.06,33.12)
		if not working then
			if dist <= 5 then
				wait = 5
				DrawText3Ds(2461.72,1576.06,33.12-1,"~g~E ~w~ INICIAR EXPEDIENTE")
				if dist <= 1.2 and IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
                    SendNUIMessage({ openNui = true })
                    SetNuiFocus(true,true)
                    vRP._CarregarObjeto("amb@medic@standing@timeofdeath@base","base","prop_notepad_01",49,60309)
				end
			end
        else
            if dist <= 5 then
				wait = 5
				DrawText3Ds(2461.72,1576.06,33.12-1,"~g~E ~w~ ENCERRAR EXPEDIENTE")
				if dist <= 1.2 and IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
                    if not uni then
                        TriggerEvent("Notify","aviso","Você precisar guardar o uniforme e os equipamentos para encerrar o expediente.")
                    else
                        working = false
                        TriggerEvent("vRP:working",false)
                        TriggerEvent("Notify","aviso","Você saiu de serviço.")
                        RemoveBlip(blips)
                    end
				end
			end
		end
		Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 1000
		local dist = Vdist(GetEntityCoords(PlayerPedId()),2471.73,1596.15,32.73)
		if working then
            if uni then
                if dist <= 5 then
                    wait = 5
                    DrawText3Ds(2471.73,1596.15,32.73-1,"~g~E ~w~ COLOCAR O UNIFORME")
                    if dist <= 1.2 and IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
                        TriggerServerEvent("setroupas","minerador")
                        CriandoBlip(locs,selecionado)
                        startWorking()
                        uni = false
                    end
                end
            else
                if dist <= 5 then
                    wait = 5
                    DrawText3Ds(2471.73,1596.15,32.73-1,"~g~E ~w~ TIRAR UNIFORME")
                    if dist <= 1.2 and IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
                        vSERVER.TiraRoupa()
                        RemoveBlip(blips)
                        uni = true
                    end
                end
            end
        end
		Wait(wait)
	end
end)


RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
    vRP.stopAnim( false)
    vRP._DeletarObjeto()
end)

RegisterNUICallback("confirm",function(data)
    vRP.stopAnim( false)
    vRP._DeletarObjeto()
	SetNuiFocus(false,false)
    working = true
    uni = true
    TriggerEvent("Notify","sucesso","Você entrou em serviço, coloque o uniforme para começar a trabalhar.",10000)
    vSERVER.checkStress()
    TriggerEvent("vRP:working",true)
end)



RegisterNetEvent("eolico:stopWorking")
AddEventHandler("eolico:stopWorking",function()
	if working then
		working = false
		TriggerEvent("vRP:working",false)
        RemoveBlip(blips)
		TriggerEvent("Notify","aviso","Seu nível de stress está muito alto para continuar trabalhando")
	end
end)

function startWorking()
	Citizen.CreateThread(function()
		while true do
			local idle = 1000
			if working then
				idle = 5
				if not servico then
					local ped = PlayerPedId()
					local vehicle = GetPlayersLastVehicle()
					local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,GetEntityCoords(ped),true)
				
					if distance <= 2000.0 then
						DrawText3Ds(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-1,"~g~E ~w~ CONSERTAR")
						if distance <= 1.2 and IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) and GetEntityModel(vehicle) == 516990260 then
                            if not uni then
                                servico = true
                                vSERVER.checkStress()
                                TriggerEvent("cancelando",true)
                                SetEntityCoords(ped,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-1)
                                vRP._playAnim(true, {task="WORLD_HUMAN_WELDING"}, false)
                                local taskBar = exports["vrp_taskbar"]:taskTwo()
                                if taskBar then
                                    TriggerEvent("progress",10000,"Consertando")
                                    SetTimeout(10000,function()
                                        servico = false
                                        vRP._DeletarObjeto()
                                        vRP._stopAnim(false)
                                        --TriggerServerEvent("trydeleteobj",ObjToNet("prop_tool_jackham"))
                                        TriggerEvent("cancelando",false)
                                        backentrega = selecionado
                                        while true do
                                            if backentrega == selecionado then
                                                selecionado = math.random(#locs)
                                            else
                                                break
                                            end
                                            Citizen.Wait(10)
                                        end
                                        vSERVER.payment()
                                        RemoveBlip(blips)
                                        CriandoBlip(locs,selecionado)
                                    end)
                                else
                                    choque()
                                    servico = false
                                    vRP._DeletarObjeto()
                                    vRP._stopAnim(false)
                                    TriggerEvent("cancelando",false)
                                    backentrega = selecionado
                                    while true do
                                        if backentrega == selecionado then
                                            selecionado = math.random(#locs)
                                        else
                                            break
                                        end
                                        Citizen.Wait(10)
                                    end
                                    RemoveBlip(blips)
                                    CriandoBlip(locs,selecionado)
                                end
                            else
                                TriggerEvent("Notify","negado","Você precisa estar com uniforme e equipamentos de segurança para trabalhar!",10000)
                            end
                        end
					end
				end
				if IsControlJustPressed(0,168) and working then
					TriggerEvent("Notify","aviso","Você precisar ir até a central para sair de serviço.")
				end
			else
				break
			end
			Citizen.Wait(idle)
		end
	end)
end

---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS --------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------


function choque()
    local ped = PlayerPedId()
    if ped then
        SetPedToRagdoll(ped,10000,10000,0,0,0,0)
        SetTimecycleModifier("REDMIST_blend")
        ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
        SetTimeout(5000,function()
            SetTimecycleModifier("hud_def_desat_Trevor")
            SetTimeout(5000,function()
                SetTimecycleModifier("")
                SetTransitionTimecycleModifier("")
                StopGameplayCamShaking()
            end)
        end)
    end
end



function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Parque Eólico")
	EndTextCommandSetBlipName(blips)
end