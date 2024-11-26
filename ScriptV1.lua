-- Game Name: فورت نايت العرب 

pcall(function ()
    for i, v in pairs(getgenv().ModConnections) do
        v:Disconnect()
        getgenv().ModConnections[i] = nil
    end
end)

-------------------->> Services <<--------------------

local cloneref = cloneref or function (...)
	return ...
end

local Services = setmetatable({}, {
	__index = function(self, service)
		return cloneref(game:FindService(service)) or cloneref(game:GetService(service)) or cloneref(game:service(service))
	end
})

local Players           = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage

-------------------->> Variables <<--------------------

local Player = Players.LocalPlayer
local Weapons = ReplicatedStorage.Assets.Weapons
getgenv().ModConnections = {}

-------------------->> Functions <<--------------------

local function setConfig(weaponConfig, name, val)
    if weaponConfig:FindFirstChild(name) ~= nil then
        weaponConfig:FindFirstChild(name).Value = val
    end
end

local function setMods(weaponConfig)
    setConfig(weaponConfig, "AmmoCapacity", 999999)
    setConfig(weaponConfig, "FireMode", "Automatic")
    setConfig(weaponConfig, "HitDamage", 999999)
    setConfig(weaponConfig, "GravityFactor", 0)
    setConfig(weaponConfig, "RecoilDelay", 0)
    setConfig(weaponConfig, "RecoilDelayTime", 0)
    setConfig(weaponConfig, "RecoilMax", 0)
    setConfig(weaponConfig, "RecoilMin", 0)
    setConfig(weaponConfig, "ShotCooldown", 0)
    setConfig(weaponConfig, "TotalRecoilMax", 0)
    setConfig(weaponConfig, "BulletSpeed", 999999)
    setConfig(weaponConfig, "ChargeRate", 999999)
    setConfig(weaponConfig, "DischargeRate", 999999)
    setConfig(weaponConfig, "BlastDamage", 999999)
    setConfig(weaponConfig, "BlastPressure", 999999)
    setConfig(weaponConfig, "BlastRadius", 50)
    setConfig(weaponConfig, "NumProjectiles", 3)
    setConfig(weaponConfig, "CrosshairScale", 0)
    setConfig(weaponConfig, "MaxDistance", 999999)
    setConfig(weaponConfig, "MaxSpread", 0)
    setConfig(weaponConfig, "FullDamageDistance", 999999)
    setConfig(weaponConfig, "ZeroDamageDistance", 0)
end

local function setUpWeapons(get, makeconnection)
    local Weapons = {}

    for _, weapon in pairs(get:GetChildren()) do
        if weapon:IsA("Tool") then
            local weaponConfig = weapon:FindFirstChild("Configuration")
    
            if weaponConfig ~= nil then
                Weapons[weapon.Name] = weapon
                setMods(weaponConfig)

                pcall(function ()
                    weapon.CurrentAmmo.Value = 999999
                    
                    if makeconnection == true then
                        local function onDestroying()
                            if getgenv().ModConnections[Player.Name.."Destroyed"] ~= nil then
                                getgenv().ModConnections[Player.Name.."Destroyed"]:Disconnect()
                                getgenv().ModConnections[Player.Name.."Destroyed"] = nil
                            end
                            if getgenv().ModConnections[weapon.Name.."Destroyed"] ~= nil then
                                getgenv().ModConnections[weapon.Name.."Destroyed"]:Disconnect()
                                getgenv().ModConnections[weapon.Name.."Destroyed"] = nil
                            end
                            if getgenv().ModConnections[weapon.Name.."Changed"] ~= nil then
                                getgenv().ModConnections[weapon.Name.."Changed"]:Disconnect()
                                getgenv().ModConnections[weapon.Name.."Changed"] = nil
                            end
                            print("Destroyed "..weapon.Name.." + "..Player.Name)
                            setUpWeapons(get, makeconnection)
                        end

                        if getgenv().ModConnections[weapon.Name.."Destroyed"] == nil then
                            getgenv().ModConnections[weapon.Name.."Destroyed"] = weapon.Destroying:Connect(onDestroying)
                        end
                        if getgenv().ModConnections[weapon.Name.."Changed"] == nil then
                            getgenv().ModConnections[weapon.Name.."Changed"] = weapon.Activated:Connect(function ()
                                weapon.CurrentAmmo.Value = 999999
                            end)
                        end
                    end
                end)
            end
        end
    end

    if makeconnection == true and getgenv().ModConnections[Player.Name.."Destroyed"] == nil then
        local function onDestroying()
            if getgenv().ModConnections[Player.Name.."Destroyed"] ~= nil then
                getgenv().ModConnections[Player.Name.."Destroyed"]:Disconnect()
                getgenv().ModConnections[Player.Name.."Destroyed"] = nil
            end
            for i, v in pairs(Weapons) do
                if getgenv().ModConnections[i.."Destroyed"] ~= nil then
                    getgenv().ModConnections[i.."Destroyed"]:Disconnect()
                    getgenv().ModConnections[i.."Destroyed"] = nil
                end
                if getgenv().ModConnections[i.."Changed"] ~= nil then
                    getgenv().ModConnections[i.."Changed"]:Disconnect()
                    getgenv().ModConnections[i.."Changed"] = nil
                end
                print("Destroyed "..i.." + "..Player.Name)
            end
            print("Destroyed "..Player.Name)
            setUpWeapons(get, makeconnection)
        end

        if getgenv().ModConnections[Player.Name.."Destroyed"] == nil then
            getgenv().ModConnections[Player.Name.."Destroyed"] = Player.Character.Destroying:Connect(onDestroying)
        end
    end
end

-------------------->> Main <<--------------------
pcall(function()
    Player.Character.Humanoid:UnequipTools()
end)
setUpWeapons(Player.Backpack, true)
