-------------------->> Services <<--------------------

local cloneref = cloneref or function (...)
	return ...
end

local Services = setmetatable({}, {
	__index = function(self, service)
		return cloneref(game:FindService(service)) or cloneref(game:GetService(service)) or cloneref(game:service(service))
	end
})

local InputService = Services.UserInputService
local Input = {}
getgenv().binds = {}

-------------------->> Methods <<--------------------

function Input.BindKeyPresses(name, callback, ...)
	if getgenv().binds[name] then
		print("A keybind already exists with the same name!")
		return
	end
	
	local keys = table.pack(...)
	keys.n = nil
	
	getgenv().binds[name] = InputService.InputBegan:Connect(function(input, gpc)
		if input.KeyCode and input.KeyCode == keys[#keys] then 
			if gpc then return end
			for i, key in pairs(keys) do 
				if not InputService:IsKeyDown(key) then
					return
				end
			end
			callback()
		end
	end)

end

function Input.UnbindKeyPresses(name)
	if getgenv().binds[name] then 
		getgenv().binds[name]:Disconnect()
		getgenv().binds[name] = nil
	end
end

function Input:CheckKeyBindExist(name)
	if getgenv().binds[name] then
		return true
	else
		return false
	end
end

return Input
