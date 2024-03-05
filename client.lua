local speedInGZ = Config.inGreenZone
local speedNotInGZ = Config.outGreenZone
local isInCityZone = false 
local inRedZone = false
local EnteredNotif = false
local LeftNotif = false
local RedEnteredNotif = false
local RedLeftNotif = false

-- Enter/Leave Zone Thread
CreateThread(function()
    while true do 
        Wait(0)
        if isInCityZone then
        	SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), speedInGZ)
            DisableControlAction(2, 37, true) -- Disable Weapon wheel
            DisablePlayerFiring(PlayerPedId(), true) -- Disable firing
            DisableControlAction(0, 45, true) -- Disable reloading
            DisableControlAction(0, 24, true) -- Disable attacking
            DisableControlAction(0, 263, true) -- Disable melee attack 1
            DisableControlAction(0, 140, true) -- Disable light melee attack (R)
            DisableControlAction(0, 142, true) -- Disable left mouse button (pistol whack etc)
            SetPlayerInvincible(PlayerId(), true) -- Disable all kinds of damage to the player
        
            for k, v in pairs(GetActivePlayers()) do
                local ped = PlayerPedId(v)
                SetEntityNoCollisionEntity(PlayerPedId(), GetVehiclePedIsIn(ped, false), true)
                SetEntityNoCollisionEntity(GetVehiclePedIsIn(ped, false), GetVehiclePedIsIn(PlayerPedId(), false), true)
            end
        else
        	SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), speedNotInGZ)
        end
    end
end)

-- Notification on screen thread
CreateThread(function()
    while true do 
        Wait(0)
        if EnteredNotif then
            DrawTextOnScreen("YOU ARE IN A GREENZONE", 0.74, 0.95, 0, 255, 0, 200, 0.8, 7)
        end
        if LeftNotif then
            DrawTextOnScreen("YOU LEFT THE GREENZONE", 0.73, 0.95, 0, 255, 0, 200, 0.8, 7)
        end
        if RedEnteredNotif then
            DrawTextOnScreen("YOU LEFT THE REDZONE", 0.75, 0.95, 255, 0, 0, 200, 0.8, 7)
        end
        if RedLeftNotif then
            DrawTextOnScreen("YOU ARE IN A REDZONE", 0.77, 0.95, 255, 0, 0, 200, 0.8, 7)
        end
    end
end)

-- Spawn Green and Red Zones
CreateThread(function()
    for _, greenZoneData in pairs(Config.CircleZones.GreenZones) do
        local greenZone = CircleZone:Create(greenZoneData.coords, greenZoneData.radius, {
            name = 'sh-greenzone',
            debugPoly = false
        })
        greenZone:onPlayerInOut(function(isPointInside, point, zone)
            if isPointInside then
                EnteredNotif = true
                isInCityZone = true
                EnteredGreenzone()
            else
                EnteredNotif = false
                isInCityZone = false
                LeftGreenzone()
            end
        end)
    end

    if Config.EnableRedZone then
        for _, redZoneData in pairs(Config.CircleZones.RedZones) do
            local redZone = CircleZone:Create(redZoneData.coords, redZoneData.radius, {
                name = 'sh-redzone',
                debugPoly = false
            })
            redZone:onPlayerInOut(function(isPointInside, point, zone)
                if isPointInside then
                    inRedZone = true
                    RedEnteredNotif = true
                else
                    inRedZone = false
                    RedEnteredNotif = false
                end
            end)
        end
    end
end)

-- Add Radius Blips On Map
CreateThread(function() -- Adds the blips
    for _, greenZone in pairs(Config.CircleZones.GreenZones) do
        local greenZoneBlip = AddBlipForRadius(greenZone.coords.x, greenZone.coords.y, greenZone.coords.z, greenZone.radius)
        SetBlipColour(greenZoneBlip, 2)
        SetBlipAlpha(greenZoneBlip, 60)
    end
    if Config.EnableRedZone then
        for _, redZone in pairs(Config.CircleZones.RedZones) do
            local redZoneBlip = AddBlipForRadius(redZone.coords.x, redZone.coords.y, redZone.coords.z, redZone.radius)
            SetBlipColour(redZoneBlip, 1)
            SetBlipAlpha(redZoneBlip, 60)
        end
    end
end)

-- Enter/Leave Green Zone Functions
function EnteredGreenzone()
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    EnteredNotif = true
    Wait(5000)
    EnteredNotif = false
end

function LeftGreenzone()
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false),speedNotInGZ)
    LeftNotif = true
    Wait(5000)
    LeftNotif = false
end

-- Enter/Leave Red Zone Functions
function EnteredRedzone()
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    RedEnteredNotif = true
    Wait(5000)
    RedEnteredNotif = false
end

function LeftRedzone()
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    RedLeftNotif = true
    Wait(5000)
    RedLeftNotif = false
end

-- Draw Text on Screen Function
function DrawTextOnScreen(text, x, y, r, g, b, a, s, font)
    SetTextColour(r, g, b, a)
    SetTextFont(font)
    SetTextScale(s, s)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
