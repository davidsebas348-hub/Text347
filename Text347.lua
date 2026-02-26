local args = {
    [1] = "Break"
}

for i = 1, 100000000 do
    game:GetService("ReplicatedStorage").ActivateGear:FireServer(unpack(args))
end
