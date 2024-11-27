-------------------->> Load <<--------------------

--[[
getgenv().infiniteValue = 999999999999
getgenv().BlastRadius = 150
getgenv().NumProjectiles = 10
getgenv().GravityFactor = 0
getgenv().ZoomFactor = 3
getgenv().CrosshairScale = 0
getgenv().AllGunHaveScope = false
getgenv().AllGunExplosive = false
getgenv().AllActLikeShotgun = false
]]

local function ReturnKeyBindsAtString(Binds_Table)
	local NumerOfKeys = #Binds_Table 
	local CombinedMsg = ""
	
	for i, v in pairs(Binds_Table) do
		if i < NumerOfKeys then
			CombinedMsg = CombinedMsg..v.Name..", "
		elseif i == NumerOfKeys then
			CombinedMsg = CombinedMsg..v.Name
		end
	end
	
	return CombinedMsg
end

local scriptKeybinds = {
    ["Destroy"] = {
        Enum.KeyCode.LeftControl;
        Enum.KeyCode.P;
    };

    ["Hide"] = {
        Enum.KeyCode.LeftControl;
        Enum.KeyCode.M;
    };
}

-------------------->> Checks <<--------------------

pcall(function ()
    getgenv().DestroyGUNMODS()
end)
pcall(function ()
    for i, v in pairs(getgenv().Keybinds) do
        for name, table in pairs(scriptKeybinds) do
            for _, v2 in pairs(table) do
                if v2 == Enum.KeyCode.LeftControl then continue end
                if v == v2 then
                    getgenv().Keybinds = nil
                    print("GigaHub - Keybinds can't have '"..ReturnKeyBindsAtString(scriptKeybinds["Destroy"]).."' '"..ReturnKeyBindsAtString(scriptKeybinds["Hide"]).."'! | "..ReturnKeyBindsAtString(scriptKeybinds["Destroy"]).." = destroy script | "..ReturnKeyBindsAtString(scriptKeybinds["Hide"]).." = hide gui")
                    break
                end
            end
        end
    end
end)
pcall(function ()
    for i, v in pairs(getgenv().Parts) do
        print(v)
        v:Destroy()
        print("Destroyed!")
    end
end)

getgenv().Keybinds = getgenv().Keybinds or {Enum.KeyCode.LeftControl, Enum.KeyCode.U}
getgenv().infiniteValue = getgenv().infiniteValue or 999999999999
getgenv().BlastRadius = getgenv().BlastRadius or 150
getgenv().NumProjectiles = getgenv().NumProjectiles or 10
getgenv().GravityFactor = getgenv().GravityFactor or 0
getgenv().ZoomFactor = getgenv().ZoomFactor or 3
getgenv().CrosshairScale = getgenv().CrosshairScale or 0
getgenv().AllGunHaveScope = getgenv().AllGunHaveScope or false
getgenv().AllGunExplosive = getgenv().AllGunExplosive or false
getgenv().AllActLikeShotgun = getgenv().AllActLikeShotgun or false

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
local CoreGui           = Services.CoreGui.RobloxGui
local ReplicatedStorage = Services.ReplicatedStorage

-------------------->> Variables <<--------------------

local KeybindsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/teteArchives/GunMods/refs/heads/main/KeybindsV1.0.0.lua", true))()
local GunModlink = "https://raw.githubusercontent.com/teteArchives/GunMods/refs/heads/main/ScriptV2.0.0.lua"
local Weapons = ReplicatedStorage.Assets.Weapons
local Player = Players.LocalPlayer

-------------------->> Gui Construction <<--------------------

local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.IgnoreGuiInset = true
MainGui.ResetOnSpawn = false
MainGui.DisplayOrder = 99999999999
MainGui.Name = ""

local TopBar = Instance.new("Frame", MainGui)
TopBar.AnchorPoint = Vector2.new(0.5, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BackgroundTransparency = 0.6
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.fromScale(0.5, 0)
TopBar.Size = UDim2.fromScale(1, 0.15)
TopBar.Name = ""

-- local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", TopBar)
-- UIAspectRatioConstraint.AspectRatio = 11.889
-- UIAspectRatioConstraint.Name = ""

local UIListLayout = Instance.new("UIListLayout", TopBar)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Name = ""

local UIPadding = Instance.new("UIPadding", TopBar)
UIPadding.PaddingBottom = UDim.new(0.08, 0)
UIPadding.PaddingLeft = UDim.new(0.008, 0)
UIPadding.PaddingRight = UDim.new(0.008, 0)
UIPadding.PaddingTop = UDim.new(0.08, 0)
UIPadding.Name = ""

local KeybindText = Instance.new("TextLabel", TopBar)
KeybindText.AnchorPoint = Vector2.new(0.5, 0.5)
KeybindText.BackgroundTransparency = 1
KeybindText.Position = UDim2.fromScale(0.5, 0.5)
KeybindText.Size = UDim2.fromScale(1, 0.25)
KeybindText.Font = Enum.Font.MontserratBold
KeybindText.RichText = true
KeybindText.Text = "Nil"
KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindText.TextScaled = true
KeybindText.Name = ""

local DestroyText = KeybindText:Clone()
DestroyText.Text = "Nil"
DestroyText.Parent = TopBar

local HideText = KeybindText:Clone()
HideText.Text = "Nil"
HideText.Parent = TopBar

local GigaIncText = KeybindText:Clone()
GigaIncText.Text = "- GigaHub Inc."
GigaIncText.TextColor3 = Color3.fromRGB(255, 188, 17)
GigaIncText.Parent = TopBar

-------------------->> Functions <<--------------------

local function makeKeyBind(keybindName, keybindCallback, keys)
    pcall(function ()
        KeybindsModule.BindKeyPresses(keybindName, keybindCallback, unpack(keys))
    end)
end

local function destroyKeyBind(keybindName)
    if getgenv().binds[keybindName] ~= nil then 
		getgenv().binds[keybindName]:Disconnect()
		getgenv().binds[keybindName] = nil
	end
end

local function loadScript()
    loadstring(game:HttpGet(GunModlink, true))()
end

getgenv().DestroyGUNMODS = function ()
    repeat destroyKeyBind("KeybindText") task.wait() until getgenv().binds["KeybindText"] == nil
    repeat destroyKeyBind("DestroyText") task.wait() until getgenv().binds["DestroyText"] == nil
    repeat destroyKeyBind("HideText") task.wait() until getgenv().binds["HideText"] == nil

    pcall(function ()
        for i, v in pairs(getgenv().ModConnections) do
            v:Disconnect()
            getgenv().ModConnections[i] = nil
        end

        pcall(function()
            Player.Character.Humanoid:UnequipTools()
        end)

        -- pcall(function() if Player.Backpack:FindFirstChild("WEAPONS") ~= nil then Player.Backpack.WEAPONS:Destroy() end end)
        -- local weaponsFolder = Instance.new("Folder", Player.Backpack)
        -- weaponsFolder.Name = "WEAPONS"

        -- for _, weapon in pairs(Player.Backpack:GetChildren()) do
        --     if weapon:IsA("Tool") then
        --         weapon.Parent = weaponsFolder
        --     end
        -- end

        for i, v in pairs(Weapons:GetChildren()) do
            if v:IsA("Tool") then
                local Configuration = v:FindFirstChild("Configuration")

                if Configuration ~= nil then
                    local weapon = Player.Backpack:FindFirstChild(v.Name) -- changed weaponsFolder to player.Backpack
                    local weaponConfig = weapon:FindFirstChild("Configuration")
                    
                    if weapon ~= nil and weaponConfig ~= nil then
                        for _, Setting in pairs(Configuration:GetChildren()) do
                            pcall(function ()
                                weaponConfig:FindFirstChild(Setting.Name).Value = Setting.Value
                            end)
                        end

                        pcall(function ()
                            weapon.CurrentAmmo.Value = Configuration:FindFirstChild("AmmoCapacity").Value
                        end)
                    end
                end
            end
        end

        -- for _, weapon in pairs(weaponsFolder:GetChildren()) do
        --     weapon.Parent = Player.Backpack
        -- end

        -- pcall(function() Player.Backpack.WEAPONS:Destroy() end)
    end)

    MainGui:Destroy()
    print("Destroyed gun mods! - GigaHub Inc.")
    getgenv().DestroyGUNMODS = nil
end

-------------------->> Main <<--------------------

KeybindText.Text = "When you die press <font color='#4a4cff'>"..ReturnKeyBindsAtString(getgenv().Keybinds).."</font> to reload the script!"
makeKeyBind("KeybindText", function ()
    loadScript()
end, getgenv().Keybinds)

DestroyText.Text = "press <font color='#000000'>"..ReturnKeyBindsAtString(scriptKeybinds["Destroy"]).."</font> to destroy the script!"
makeKeyBind("DestroyText", function ()
    getgenv().DestroyGUNMODS()
end, scriptKeybinds["Destroy"])

HideText.Text = "press <font color='#000000'>"..ReturnKeyBindsAtString(scriptKeybinds["Hide"]).."</font> to hide the gui!"
makeKeyBind("HideText", function ()
    MainGui.Enabled = not MainGui.Enabled
end, scriptKeybinds["Hide"])

loadScript()
