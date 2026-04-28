-- borrar la gui

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function removeKnockLocal()
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = playerGui:FindFirstChild("ScreenGui")
	if not screenGui then return end
	
	local knockScreen = screenGui:FindFirstChild("KnockScreen")
	if not knockScreen then return end
	
	local localScript = knockScreen:FindFirstChildOfClass("LocalScript")
	if localScript then
		localScript:Destroy()
	end
end

-- Cuando el personaje aparece (respawn)
player.CharacterAdded:Connect(function()
	task.wait(1) -- pequeño delay para que cargue la GUI
	removeKnockLocal()
end)

-- También ejecutarlo la primera vez
if player.Character then
	task.wait(1)
	removeKnockLocal()
end

-- Godmode
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

getgenv().GODMODE = true

local function applyGod()
	if not getgenv().GODMODE then return end

	local char = LocalPlayer.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	-- guardar stats
	local jp = hum.JumpPower
	local ws = hum.WalkSpeed

	-- recrear humanoid
	local newHum = hum:Clone()
	newHum.Parent = char

	newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	newHum.BreakJointsOnDeath = false

	hum:Destroy()

	LocalPlayer.Character = char
	workspace.CurrentCamera.CameraSubject = newHum

	-- 🔥 FIX CONTROLES + SALTO
	task.wait(0.2)

	local pm = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
	local controls = pm:GetControls()

	controls:Disable()
	task.wait(0.1)

	controls:OnCharacterRemoving(char)
	task.wait()
	controls:OnCharacterAdded(char)

	task.wait(0.1)
	controls:Enable()

	-- restaurar movimiento
	newHum.UseJumpPower = true
	newHum.JumpPower = jp
	newHum.WalkSpeed = ws
	newHum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	newHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)

	-- 🔥 FIX ANIMACIONES
	local anim = char:FindFirstChild("Animate")
	if anim then
		anim.Disabled = true
		task.wait()
		anim.Disabled = false
	end

	newHum:ChangeState(Enum.HumanoidStateType.Running)

	newHum.Health = newHum.MaxHealth
end

-- activar una vez al inicio
task.spawn(function()
	task.wait(1)
	if getgenv().GODMODE then
		applyGod()
	end
end)

-- activar una vez por respawn
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if getgenv().GODMODE then
		applyGod()
	end
end)

-- para que no muera el personaje 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Toggle real
if _G.SelfReviveEvent then
    _G.SelfReviveEvent:Disconnect()
    _G.SelfReviveEvent = nil
    return
end

-- Función para activar SelfRevive
local function activateSelfRevive()
    local args = {
        [1] = "SelfRevive",
        [2] = true
    }
    ReplicatedStorage.ActivateGear:FireServer(unpack(args))
end

-- Detectar cuando llegue el evento KnockUI
_G.SelfReviveEvent = ReplicatedStorage:WaitForChild("KnockUI").OnClientEvent:Connect(function(...)
    -- No importa qué número venga (15, 23, etc)
    
    local args = {...}
    
    -- Opcional: verificar que venga algo válido
    if typeof(args[1]) == "number" then
        activateSelfRevive()
    end
end)
