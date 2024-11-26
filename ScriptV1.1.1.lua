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
local UserInputService  = Services.UserInputService

-------------------->> Variables <<--------------------

local Player = Players.LocalPlayer
local Mouse1Down = false
getgenv().ModConnections = {}

-------------------->> Functions <<--------------------

local function setConfig(weaponConfig, name, val)
    if weaponConfig:FindFirstChild(name) ~= nil then
        weaponConfig:FindFirstChild(name).Value = val
    end
end

local function setMods(weaponConfig)
    setConfig(weaponConfig, "AmmoCapacity", getgenv().infiniteValue)
    setConfig(weaponConfig, "FireMode", "Automatic")
    setConfig(weaponConfig, "ShotEffect", "Arrow")
    setConfig(weaponConfig, "HitDamage", getgenv().infiniteValue)
    setConfig(weaponConfig, "GravityFactor", getgenv().GravityFactor)
    setConfig(weaponConfig, "RecoilDelay", 0)
    setConfig(weaponConfig, "RecoilDelayTime", 0)
    setConfig(weaponConfig, "RecoilMax", 0)
    setConfig(weaponConfig, "RecoilMin", 0)
    setConfig(weaponConfig, "ShotCooldown", 0)
    setConfig(weaponConfig, "TotalRecoilMax", 0)
    setConfig(weaponConfig, "BulletSpeed", getgenv().infiniteValue)
    setConfig(weaponConfig, "ChargeRate", getgenv().infiniteValue)
    setConfig(weaponConfig, "DischargeRate", getgenv().infiniteValue)
    setConfig(weaponConfig, "BlastDamage", getgenv().infiniteValue)
    setConfig(weaponConfig, "BlastPressure", getgenv().infiniteValue)
    setConfig(weaponConfig, "BlastRadius", getgenv().BlastRadius)
    setConfig(weaponConfig, "NumProjectiles", getgenv().NumProjectiles)
    setConfig(weaponConfig, "CrosshairScale", getgenv().CrosshairScale)
    setConfig(weaponConfig, "ZoomFactor", getgenv().ZoomFactor)
    setConfig(weaponConfig, "MaxDistance", getgenv().infiniteValue)
    setConfig(weaponConfig, "MuzzleFlashSize0", 0)
    setConfig(weaponConfig, "MuzzleFlashSize1", 0)
    setConfig(weaponConfig, "MinSpread", 0)
    setConfig(weaponConfig, "MaxSpread", 0)
    setConfig(weaponConfig, "FullDamageDistance", getgenv().infiniteValue)
    setConfig(weaponConfig, "ZeroDamageDistance", 0)
end

local function setUpWeapons(get, makeconnection)
    local weapons = {}

    for _, weapon in pairs(get:GetChildren()) do
        if weapon:IsA("Tool") then
            local weaponConfig = weapon:FindFirstChild("Configuration")
    
            if weaponConfig ~= nil then
                weapons[weapon.Name] = weapon
                setMods(weaponConfig)

                pcall(function ()
                    weapon.CurrentAmmo.Value = getgenv().infiniteValue
                    
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
                            if getgenv().ModConnections[Player.Name.."MouseButton1Down"] == nil then
                                getgenv().ModConnections[Player.Name.."MouseButton1Down"]:Disconnect()
                                getgenv().ModConnections[Player.Name.."MouseButton1Down"] = nil
                            end
                            if getgenv().ModConnections[Player.Name.."MouseButton1Up"] ~= nil then
                                getgenv().ModConnections[Player.Name.."MouseButton1Up"]:Disconnect()
                                getgenv().ModConnections[Player.Name.."MouseButton1Up"] = nil
                            end
                            print("Destroyed "..weapon.Name.." + "..Player.Name)
                            setUpWeapons(get, makeconnection)
                        end

                        if getgenv().ModConnections[weapon.Name.."Destroyed"] == nil then
                            getgenv().ModConnections[weapon.Name.."Destroyed"] = weapon.Destroying:Connect(onDestroying)
                        end
                        if getgenv().ModConnections[weapon.Name.."Changed"] == nil then
                            getgenv().ModConnections[weapon.Name.."Changed"] = weapon.Activated:Connect(function ()
                                weapon.CurrentAmmo.Value = getgenv().infiniteValue
                            end)
                        end
                    end
                end)
            end
        end
    end

    if makeconnection == true then
        if getgenv().ModConnections[Player.Name.."MouseButton1Down"] == nil then
            getgenv().ModConnections[Player.Name.."MouseButton1Down"] = UserInputService.InputBegan:Connect(function (input, gameProcessed)
                if not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Mouse1Down = true
                        while task.wait() and Mouse1Down == true do
                            local weapon = Player.Character:FindFirstChildOfClass("Tool")
                            
                            if weapon ~= nil then
                                if weapon.Name ~= "Railgun" then
                                    weapon:Activate()
                                    weapon:Deactivate()
                                else
                                    weapon:Activate()
                                    task.wait()
                                    weapon:Deactivate()
                                end
                            end
                        end
                    end
                end
            end)
        end

        if getgenv().ModConnections[Player.Name.."MouseButton1Up"] == nil then
            getgenv().ModConnections[Player.Name.."MouseButton1Up"] = UserInputService.InputEnded:Connect(function (input, gameProcessed)
                if not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Mouse1Down = false
                    end
                end
            end)
        end
    end

    if makeconnection == true and getgenv().ModConnections[Player.Name.."Destroyed"] == nil then
        local function onDestroying()
            if getgenv().ModConnections[Player.Name.."Destroyed"] ~= nil then
                getgenv().ModConnections[Player.Name.."Destroyed"]:Disconnect()
                getgenv().ModConnections[Player.Name.."Destroyed"] = nil
            end
            if getgenv().ModConnections[Player.Name.."MouseButton1Down"] == nil then
                getgenv().ModConnections[Player.Name.."MouseButton1Down"]:Disconnect()
                getgenv().ModConnections[Player.Name.."MouseButton1Down"] = nil
            end
            if getgenv().ModConnections[Player.Name.."MouseButton1Up"] ~= nil then
                getgenv().ModConnections[Player.Name.."MouseButton1Up"]:Disconnect()
                getgenv().ModConnections[Player.Name.."MouseButton1Up"] = nil
            end
            for i, v in pairs(weapons) do
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
