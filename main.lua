local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Hauptfenster mit eigenem Namen
local Window = OrionLib:MakeWindow({
  Name = "Z1Softwares Autorob",
  HidePremium = false,
  SaveConfig = false,
  ConfigFolder = "ProjectNexar",
  IntroEnabled = true,
  IntroText = "Project Volara "   -- dieser Parameter wird in der Original-Library ignoriert
})

    -- // Creating Tabs \\ --


    local AutorobberyTab = Window:MakeTab({
        Name = "Auto Robbery",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    local InformationTab = Window:MakeTab({
        Name = "Information",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    -- // Creating Sections \\ --

    local Section = InformationTab:AddSection({
        Name = "Information"
    })

    InformationTab:AddParagraph("Warning!", "If your device is not that good you may get thrown out of your vehicle or kicked if that happens make sure your graphics are turned down.")
    InformationTab:AddParagraph("A key work for 3 days.", "Each key is saved automatically.")

    local Section = InformationTab:AddSection({
        Name = "Are you having problems?"
    })    

        InformationTab:AddButton({
            Name = "Copy Discord",
            Callback = function()
                setclipboard("discord.gg/project-volara")
                game:GetService("StarterGui"):SetCore("SendNotification", {Title="Copied!", Text="Discord invite copied.", Duration=3})
            end
        })     

    InformationTab:AddLabel("Script not working or bugs? Open a ticket on the dc.")
    InformationTab:AddLabel("You got a error? Open a ticket on the dc.")
    InformationTab:AddLabel("Script is in Release Version R3.")

    -- // Autofarm \\ --

        local Section = AutorobberyTab:AddSection({
            Name = "Autorobbery Script"
        })

    AutorobberyTab:AddParagraph("How does it work automatically?", "You need to add this script to your auto-execute folder from your executer.")

    AutorobberyTab:AddButton({
                Name = "Copy Script",
                Callback = function()
                    setclipboard("https://raw.githubusercontent.com/ItemTo/VortexAutorob/refs/heads/main/release")
                    game:GetService("StarterGui"):SetCore("SendNotification", {Title="Copied!", Text="Autorobbery script copied.", Duration=3})
                end
            })

        local Section = AutorobberyTab:AddSection({
            Name = "Autorobbery Options"
        })

            local configFileName = "Vortex_config5.json"

    local autorobToggle = false
    local autoSellToggle = true
    local vehicleSpeedDivider = 170
    local healthAbortThreshold = 37
    local collectSpeedDivider = 28

    local function loadConfig()
        if isfile(configFileName) then
            local data = readfile(configFileName)
            local success, config = pcall(function()
                return game:GetService("HttpService"):JSONDecode(data)
            end)

            if success and config then
                autorobToggle = config.autorobToggle or false
                autoSellToggle = config.autoSellToggle or false
                vehicleSpeedDivider = config.vehicleSpeedDivider or 175
                healthAbortThreshold = config.healthAbortThreshold or 30
                collectSpeedDivider = config.collectSpeedDivider or 28
            end
        end
    end

    local function saveConfig()
        local config = {
            autorobToggle = autorobToggle,
            autoSellToggle = autoSellToggle,
            vehicleSpeedDivider = vehicleSpeedDivider,
            healthAbortThreshold = healthAbortThreshold,
            collectSpeedDivider = collectSpeedDivider
        }
        local json = game:GetService("HttpService"):JSONEncode(config)
        writefile(configFileName, json)
    end


    loadConfig()

    AutorobberyTab:AddToggle({
        Name = "Autorob",
        Default = autorobToggle,
        Callback = function(Value)
            autorobToggle = Value
            saveConfig()
        end    
    })

    AutorobberyTab:AddToggle({
        Name = "Automatically sells stolen items",
        Default = autoSellToggle,
        Callback = function(Value)
            autoSellToggle = Value
            saveConfig()
        end    
    })

    local Section = AutorobberyTab:AddSection({
        Name = "Settings (Set it so that it matches the performance of your device.)"
    })

    AutorobberyTab:AddSlider({
        Name = "Vehicle speed",
        Min = 50,
        Max = 175,
        Default = vehicleSpeedDivider,
        Increment = 5,
        Callback = function(value)
            vehicleSpeedDivider = value
            saveConfig()
        end
    })

    AutorobberyTab:AddSlider({
        Name = "Item collection speed",
        Min = 15,
        Max = 30,
        Default = collectSpeedDivider,
        Increment = 1,
        Callback = function(value)
            collectSpeedDivider = value
            saveConfig()
        end
    })

    AutorobberyTab:AddSlider({
        Name = "Life limit where it should stop farming",
        Min = 27,
        Max = 100,
        Default = healthAbortThreshold,
        Increment = 1,
        Callback = function(value)
            healthAbortThreshold = value
            saveConfig()
        end
    })

    local plr = game:GetService("Players").LocalPlayer
    local EquipRemoteEvent = game:GetService("ReplicatedStorage")["Bnl"]["d883ecf6-ecda-4c56-9855-893c1cf13308"]
    local buyRemoteEvent = game:GetService("ReplicatedStorage")["Bnl"]["0e9e7359-465e-44b1-82c2-40bd8c2ee546"]
    local sellRemoteEvent = game:GetService("ReplicatedStorage")["Bnl"]["2432026b-5c29-477d-b406-c6a1a413923a"]
    -------------------------------------------------------------------------------------------------------------------
    --local placeBombRemoteEvent = game:GetService("ReplicatedStorage")["Bnl"]["8bf54680-2fd9-4dfa-b418-35405d423321"]
    -------------------------------------------------------------------------------------------------------------------
    local fireBombRemoteEvent = game:GetService("ReplicatedStorage")["Bnl"]["cedfa9a4-6dd7-4735-a22e-db4729f2db81"]
    local robRemoteEvent = game:GetService("ReplicatedStorage")["Bnl"]["fdffc7c3-4c83-4693-8a33-380ed2d60083"]
    local ProximityPromptTimeBet = 2.5--
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local key = Enum.KeyCode.E
    local TweenService = game:GetService("TweenService")


    local function JumpOut()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer    
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid.SeatPart then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    local function ensurePlayerInVehicle()
        local player = game:GetService("Players").LocalPlayer
        local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(player.Name)
        local character = player.Character or player.CharacterAdded:Wait()

        if vehicle and character then
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            local driveSeat = vehicle:FindFirstChild("DriveSeat")

            if humanoid and driveSeat and humanoid.SeatPart ~= driveSeat then
                driveSeat:Sit(humanoid)
            end
        end
    end

    local function clickAtCoordinates(scaleX, scaleY, duration)
        local camera = game.Workspace.CurrentCamera
        local screenWidth = camera.ViewportSize.X
        local screenHeight = camera.ViewportSize.Y
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local absoluteX = screenWidth * scaleX
        local absoluteY = screenHeight * scaleY

        VirtualInputManager:SendMouseButtonEvent(absoluteX, absoluteY, 0, true, game, 0)  

        if duration and duration > 0 then
                task.wait(duration)  
            end

        VirtualInputManager:SendMouseButtonEvent(absoluteX, absoluteY, 0, false, game, 0) 
    end
    --clickAtCoordinates(0.5026, 0.8528, 0.2)

    local function plrTween(destination)
        local plr = game.Players.LocalPlayer
        local char = plr.Character

        if not char or not char.PrimaryPart then
            warn("Character or PrimaryPart not available.")
            return
        end

        local distance = (char.PrimaryPart.Position - destination).Magnitude
        local tweenDuration = distance / collectSpeedDivider

        local TweenInfoToUse = TweenInfo.new(
            tweenDuration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )

        local TweenValue = Instance.new("CFrameValue")
        TweenValue.Value = char:GetPivot()

        TweenValue.Changed:Connect(function(newCFrame)
            char:PivotTo(newCFrame)
        end)

        local targetCFrame = CFrame.new(destination)
        local tween = TweenService:Create(TweenValue, TweenInfoToUse, { Value = targetCFrame })

        tween:Play()

        tween.Completed:Wait()
        TweenValue:Destroy()
    end

    local function interactWithVisibleMeshParts(folder)
        if not folder then return end
        local player = game.Players.LocalPlayer
        local policeTeam = game:GetService("Teams"):FindFirstChild("Police")
        if not policeTeam then return end
        local function isPoliceNearby()
                for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                    if plr.Team == policeTeam and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 40 then
                        return true
                        end
                    end
                end
            return false
        end


        local player = game.Players.LocalPlayer
        local meshParts = {}

        for _, meshPart in ipairs(folder:GetChildren()) do
            if meshPart:IsA("MeshPart") and meshPart.Transparency == 0 then
                table.insert(meshParts, meshPart)
            end
        end

        table.sort(meshParts, function(a, b)
            local aDist = (a.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local bDist = (b.Position - player.Character.HumanoidRootPart.Position).Magnitude
            return aDist < bDist
        end)

        for _, meshPart in ipairs(meshParts) do

            if isPoliceNearby() then
                game.StarterGui:SetCore("SendNotification", {
                            Title = "Police is nearby",
                            Text = "Interaction aborted",
                })
                return
            end

            if player.Character.Humanoid.Health <= healthAbortThreshold then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Player is hurt",
                    Text = "Interaction aborted",
                })
            return
                    end

            if meshPart.Transparency == 1 then
                continue
            end

            if meshPart.Parent.Name == "Money" then
                local args = {meshPart, "b23", true}
                robRemoteEvent:FireServer(unpack(args))
                task.wait(ProximityPromptTimeBet)
                args[3] = false
                robRemoteEvent:FireServer(unpack(args))
            else
                local args = {meshPart, "qn9", true}
                robRemoteEvent:FireServer(unpack(args))
                task.wait(ProximityPromptTimeBet)
                args[3] = false
                robRemoteEvent:FireServer(unpack(args))
            end

        end
    end






            local function interactWithVisibleMeshParts2(folder)
                if not folder then return end
                local player = game.Players.LocalPlayer
                local policeTeam = game:GetService("Teams"):FindFirstChild("Police")
                if not policeTeam then return end

                local function isPoliceNearby()
                    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                        if plr.Team == policeTeam and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= 40 then
                                return true
                            end
                        end
                    end
                    return false
                end

                local meshParts = {}
                for _, meshPart in ipairs(folder:GetChildren()) do
                    if meshPart:IsA("MeshPart") and meshPart.Transparency == 0 then
                        table.insert(meshParts, meshPart)
                    end
                end

                table.sort(meshParts, function(a, b)
                    local aDist = (a.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    local bDist = (b.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    return aDist < bDist
                end)

                for i, meshPart in ipairs(meshParts) do
                    if isPoliceNearby() then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Police is nearby",
                            Text = "Interaction aborted",
                        })
                        return
                    end

                    if player.Character.Humanoid.Health <= healthAbortThreshold then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Player is hurt",
                            Text = "Interaction aborted",
                        })
                        return
                    end

                    if meshPart.Transparency == 1 then
                        return
                    end

                    plrTween(meshPart.Position)
                    if meshPart.Parent.Name == "Money" then
                        local args3 = {
                            [1] = meshPart,
                            [2] = "b23",
                            [3] = true,
                        }

                        robRemoteEvent:FireServer(unpack(args3))
                        task.wait(ProximityPromptTimeBet)
                        local args3 = {
                            [1] = meshPart,
                            [2] = "b23",
                            [3] = false,
                        }

                        robRemoteEvent:FireServer(unpack(args3))
                    else
                        local args4 = {
                            [1] = meshPart,
                            [2] = "qn9",
                            [3] = true
                        }

                        robRemoteEvent:FireServer(unpack(args4))
                        task.wait(ProximityPromptTimeBet)
                        local args4 = {
                            [1] = meshPart,
                            [2] = "qn9",
                            [3] = false
                        }

                        robRemoteEvent:FireServer(unpack(args4))
                    end

                    task.wait(0.1)
                end
            end

    local function tweenTo(destination)
                local plr = game.Players.LocalPlayer
                local car = Workspace.Vehicles[plr.Name]
                car:SetAttribute("ParkingBrake", true)
                car:SetAttribute("Locked", true)
                car.PrimaryPart = car:FindFirstChild("DriveSeat",true)
                car.DriveSeat:Sit(plr.Character.Humanoid)

                local distance = (car.PrimaryPart.Position - destination).Magnitude
                local tweenDuration = distance / vehicleSpeedDivider


                local TweenInfoToUse = TweenInfo.new(
                    tweenDuration,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )

                local TweenValue = Instance.new("CFrameValue")
                TweenValue.Value = car:GetPivot()

                TweenValue.Changed:Connect(function(newCFrame)
                    car:PivotTo(newCFrame)
                    car.DriveSeat.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    car.DriveSeat.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)

                local lowestY = math.huge
                for _, part in ipairs(car:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local bottomY = part.Position.Y - (part.Size.Y / 2)
                        if bottomY < lowestY then
                            lowestY = bottomY
                        end
                    end
                end

                local targetCFrame = CFrame.new(destination)
                local tween = TweenService:Create(TweenValue, TweenInfoToUse, { Value = targetCFrame })

                tween:Play()

                tween.Completed:Wait()
                car:SetAttribute("ParkingBrake", true)
                car:SetAttribute("Locked", true)
                TweenValue:Destroy()
                return
            end

    local HttpService = game:GetService('HttpService')
    local TeleportService = game:GetService('TeleportService')
    local Players = game:GetService("Players")
    local PlaceID = game.PlaceId 
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.time()

    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile("NotSameServersAutoRob.json"))
    end)

    if success and type(result) == "table" then
        AllIDs = result
    else
        AllIDs = {actualHour}
        writefile("NotSameServersVortex.json", HttpService:JSONEncode(AllIDs))
    end

    local function TPReturner()
        local Site
        if foundAnything == "" then
            Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end

        if Site.nextPageCursor then
            foundAnything = Site.nextPageCursor
        end

        for _, v in pairs(Site.data) do
            if tonumber(v.playing) < tonumber(v.maxPlayers) then
                local ServerID = tostring(v.id)
                local AlreadyVisited = false

                for _, ExistingID in ipairs(AllIDs) do
                    if ServerID == ExistingID then
                        AlreadyVisited = true
                        break
                    end
                end

                if not AlreadyVisited then
                    table.insert(AllIDs, ServerID)
                    writefile("NotSameServersAutoRob.json", HttpService:JSONEncode(AllIDs))
                    TeleportService:TeleportToPlaceInstance(PlaceID, ServerID, Players.LocalPlayer)
                    wait(4)
                    return
                end
            end
        end
    end
    local function ServerHop()
    pcall(function()
        TPReturner()
        if foundAnything ~= "" then
            TPReturner()
        end
    end)
    end

    local function MoveToDealer()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local vehicle = workspace.Vehicles:FindFirstChild(player.Name)
        if not vehicle then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Error",
                Text = "No vehicle found.",
                Duration = 3,
            })

            return
        end

        local dealers = workspace:FindFirstChild("Dealers")
        if not dealers then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Error",
                Text = "Dealers not found.",
                Duration = 3,
            })
            tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
            ServerHop()
            return
        end

        local closest, shortest = nil, math.huge
        for _, dealer in pairs(dealers:GetChildren()) do
            if dealer:FindFirstChild("Head") then
                local dist = (character.HumanoidRootPart.Position - dealer.Head.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = dealer.Head
                end
            end
        end

        if not closest then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Error",
                Text = "No dealer found.",
                Duration = 3,
            })
            tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
            ServerHop()
            return
        end

        local destination1 = closest.Position + Vector3.new(0, 5, 0)
        tweenTo(destination1)
    end



    while task.wait() do
        if autorobToggle == true then
            local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local camera = game.Workspace.CurrentCamera

    local function lockCamera()
        local rootPart = character.HumanoidRootPart

        local heightOffset = 8   -- Höhe über dem Charakter
        local backOffset = 4     -- Abstand hinter dem Charakter

        -- Kamera steht schräg hinter und über dem Charakter
        local cameraPosition = rootPart.Position 
            - rootPart.CFrame.LookVector * backOffset 
            + Vector3.new(0, heightOffset, 0)

        local lookAtPosition = rootPart.Position + Vector3.new(0, 3, 0) -- leicht über den Boden schauen

        camera.CFrame = CFrame.new(cameraPosition, lookAtPosition)
        camera.FieldOfView = 70 -- optional anpassen
    end


    game:GetService("RunService").RenderStepped:Connect(lockCamera)
    local musikPos = Vector3.new(-1739.5330810546875, 11, 3052.31103515625)
    local musikStand = Vector3.new(-1744.177001953125, 11.125, 3012.20263671875)
    local musikSafe = Vector3.new(-1743.4300537109375, 11.124999046325684, 3049.96630859375)
    ensurePlayerInVehicle()
    task.wait(.5)
    clickAtCoordinates(0.5, 0.9)
    task.wait(.5)
    tweenTo(Vector3.new(-1370.972412109375, 5.499999046325684, 3127.154541015625))
    local musikPart = workspace.Robberies["Club Robbery"].Club.Door.Accessory.Black
    local bankPart = Workspace.Robberies.BankRobbery.VaultDoor["Meshes/Tresor_Plane (2)"]
    local bankLight = game.Workspace.Robberies.BankRobbery.LightGreen.Light
    local bankLight2 = game.Workspace.Robberies.BankRobbery.LightRed.Light
    if musikPart.Rotation == Vector3.new(180, 0, 180) then
        clickAtCoordinates(0.5, 0.9)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Safe is open",
            Text = "Going to rob",
        })
local function checkContainer(container)
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Bomb" then
            return true
        end
    end
    return false
end

    local function playerHasBombGui(player)
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then return false end

        local uiElement = playerGui:FindFirstChild("A6A23F59-70AC-4DDF-8F7B-C4E1E8D6434F")
        if not uiElement then return false end

        for _, guiObject in ipairs(uiElement:GetDescendants()) do
            if (guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton")) and guiObject.Image == "rbxassetid://132706206999660" then
                return true
            end
        end

        return false
    end

    local hasBomb = checkContainer(plr.Backpack) or checkContainer(plr.Character) or playerHasBombGui(plr)

    if not hasBomb then
        ensurePlayerInVehicle()
        task.wait(0.5)
        MoveToDealer()
        task.wait(0.5)
        MoveToDealer()
        task.wait(0.5)
        local args = {
            [1] = "Bomb",
            [2] = "Dealer"
        }
        buyRemoteEvent:FireServer(unpack(args))
        task.wait(0.5)
    end

        ensurePlayerInVehicle()
        task.wait(0.5)
        tweenTo(musikPos)
        task.wait(0.5)
        JumpOut()
        task.wait(0.5)
        local args = {
            [1] = "Bomb"
        }
        EquipRemoteEvent:FireServer(unpack(args))
        task.wait(0.5)
        plrTween(musikStand)
        task.wait(0.5)
        local tool = plr.Character:FindFirstChild("Bomb")
        if tool then
            local args = { tool }
        -- Zielen starten (Rechtsklick gedrückt halten)
        mouse2press()
        wait(1)  -- 1 Sekunde halten

        -- Linksklick ausführen
        mouse1press()
        wait(0.05)  -- kurzer Klick
        mouse1release()

        -- 0.5 Sekunden warten
        wait(0.5)

        -- Zielen beenden (Rechtsklick loslassen)
        mouse2release()
            else
                warn("Tool 'Bomb' not found in the Backpack!")
        end
        task.wait(0.5)
        fireBombRemoteEvent:FireServer()
        plrTween(musikSafe)
        task.wait(1.8)
        plrTween(musikStand)
        local safeFolder = workspace.Robberies["Club Robbery"].Club
        interactWithVisibleMeshParts(safeFolder:FindFirstChild("Items"))
        interactWithVisibleMeshParts(safeFolder:FindFirstChild("Money"))
        task.wait(0.5)
        ensurePlayerInVehicle()
        if autoSellToggle == true then
            ensurePlayerInVehicle()
            MoveToDealer()
            task.wait(0.5)
            local args = {
                [1] = "Gold",
                [2] = "Dealer"
            }
            sellRemoteEvent:FireServer(unpack(args))
            sellRemoteEvent:FireServer(unpack(args))
            sellRemoteEvent:FireServer(unpack(args))
            tweenTo(Vector3.new(-1370.972412109375, 5.499999046325684, 3127.154541015625))
        end
        ensurePlayerInVehicle()
        tweenTo(Vector3.new(-1370.972412109375, 5.499999046325684, 3127.154541015625))

    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Safe is not open",
            Text = "Leave the game or wait until its cooldown reset",
        })
    end

    if bankLight2.Enabled == false and bankLight.Enabled == true then
    clickAtCoordinates(0.5, 0.9)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Bank is open",
        Text = "Going to rob",
    })
    ensurePlayerInVehicle()
    local hasBomb1 = false
    local plr = game.Players.LocalPlayer

    local function checkContainer(container)
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and item.Name == "Bomb" then
                return true
            end
        end
        return false
    end

    hasBomb1 = checkContainer(plr.Backpack) or checkContainer(plr.Character)
        if not hasBomb1 then
            ensurePlayerInVehicle()
            task.wait(0.5)
            MoveToDealer()
            task.wait(0.5)
            MoveToDealer()
            task.wait(0.5)
            local args = {
                [1] = "Bomb",
                [2] = "Dealer"
            }
            buyRemoteEvent:FireServer(unpack(args))
            task.wait(0.5)
        end
        tweenTo(Vector3.new(-1202.86181640625, 7.877995491027832, 3164.614501953125))
        tweenTo(Vector3.new(-1202.86181640625, 7.877995491027832, 3164.614501953125))
        JumpOut()
        task.wait(0.5)
        plrTween(Vector3.new(-1242.367919921875, 7.749999046325684, 3144.705322265625))
        task.wait(0.5)
        local args = {
            [1] = "Bomb"
        }
        EquipRemoteEvent:FireServer(unpack(args))
        task.wait(0.5)
        local tool = plr.Character:FindFirstChild("Bomb")
        if tool then
            local args = { tool }
        -- Zielen starten (Rechtsklick gedrückt halten)
        mouse2press()
        wait(1)  -- 1 Sekunde halten

        -- Linksklick ausführen
        mouse1press()
        wait(0.05)  -- kurzer Klick
        mouse1release()

        -- 0.5 Sekunden warten
        wait(0.5)

        -- Zielen beenden (Rechtsklick loslassen)
        mouse2release()


            else
                warn("Tool 'Bomb' not found in the Backpack!")
        end
        task.wait(.5)
        fireBombRemoteEvent:FireServer()
        plrTween(Vector3.new(-1246.291015625, 7.749999046325684, 3120.8505859375))
        task.wait(2.5)
        local safeFolder = Workspace.Robberies.BankRobbery
        interactWithVisibleMeshParts2(safeFolder:FindFirstChild("Gold"))
        interactWithVisibleMeshParts2(safeFolder:FindFirstChild("Gold"))
        interactWithVisibleMeshParts2(safeFolder:FindFirstChild("Money"))
        interactWithVisibleMeshParts2(safeFolder:FindFirstChild("Money"))
        ensurePlayerInVehicle()
        if autoSellToggle == true then
            task.wait(.5)
            MoveToDealer()
            task.wait(.5)
            MoveToDealer()
            task.wait(.5)
            local args = {
                [1] = "Gold",
                [2] = "Dealer"
            }
            sellRemoteEvent:FireServer(unpack(args))
            sellRemoteEvent:FireServer(unpack(args))
            sellRemoteEvent:FireServer(unpack(args))
            task.wait(.5)
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Bank is not open",
            Text = "Leave the game or wait until its cooldown reset",
        })

    end




    tweenTo(Vector3.new(1058.7470703125, 5.733738899230957, 2218.6943359375))
    task.wait(.5)
    local containerFolder = workspace.Robberies.ContainerRobberies
    local containers = {}
    for _, model in ipairs(containerFolder:GetChildren()) do
        if model.Name == "ContainerRobbery" then
            table.insert(containers, model)
        end
    end
    local container1 = containers[1]
    local container2 = containers[2]
    local con1Planks = container1:FindFirstChild("WoodPlanks" ,true)
    local con2Planks = container2:FindFirstChild("WoodPlanks" ,true)

    local function isPoliceNearby()
        local policeTeam = game:GetService("Teams"):FindFirstChild("Police")
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr.Team == policeTeam and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 40 then
                    return true
                    end
                end
            end
        return false
    end

    if con1Planks.Transparency == 1 then
    ensurePlayerInVehicle()
    task.wait(.5)
    MoveToDealer()
    task.wait(.5)
    local args = {
        [1] = "Bomb",
        [2] = "Dealer"
    }
    buyRemoteEvent:FireServer(unpack(args))
    task.wait(0.5)
    tweenTo(con1Planks.Position)
    tweenTo(con1Planks.Position)
    task.wait(0.5)
    JumpOut()
    task.wait(0.5)
    plrTween(con1Planks.Position)
    task.wait(0.5)
    local args = {
        [1] = "Bomb"
    }
    EquipRemoteEvent:FireServer(unpack(args))
    task.wait(0.5)
        local tool = plr.Character:FindFirstChild("Bomb")
        if tool then
            local args = { tool }
-- Zielen starten (Rechtsklick gedrückt halten)
mouse2press()
wait(1)  -- 1 Sekunde halten

-- Linksklick ausführen
mouse1press()
wait(0.05)  -- kurzer Klick
mouse1release()

-- 0.5 Sekunden warten
wait(0.5)

-- Zielen beenden (Rechtsklick loslassen)
mouse2release()


            else
                warn("Tool 'Bomb' not found in the Backpack!")
        end
    task.wait(.5)
    fireBombRemoteEvent:FireServer()
    ensurePlayerInVehicle()
    tweenTo(Vector3.new(1096.401, 57.31, 2226.765), Vector3.new(1096.401, 57.31, 2241.98))
    task.wait(2)
    tweenTo(con1Planks.Position)
    JumpOut()
    task.wait(.5)
    plrTween(con1Planks.Position)
    interactWithVisibleMeshParts2(container1:FindFirstChild("Items"))
    interactWithVisibleMeshParts2(container1:FindFirstChild("Items"))
    interactWithVisibleMeshParts2(container1:FindFirstChild("Money"))
    interactWithVisibleMeshParts2(container1:FindFirstChild("Money"))
    task.wait(.2)
    ensurePlayerInVehicle()
    task.wait(.2)
    tweenTo(Vector3.new(1096.401, 57.31, 2226.765), Vector3.new(1096.401, 57.31, 2241.98))
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Container1 not open",
            Text = "Leave the game or wait until its cooldown reset",
        })
    end

    if con2Planks.Transparency == 1 then
        ensurePlayerInVehicle()
        task.wait(.5)
        MoveToDealer()
        task.wait(.5)
        local args = {
            [1] = "Bomb",
            [2] = "Dealer"
        }
        buyRemoteEvent:FireServer(unpack(args))
        task.wait(0.5)
        tweenTo(con2Planks.Position)
        task.wait(0.5)
        JumpOut()
        task.wait(.5)
        plrTween(con2Planks.Position)
        task.wait(0.5)
        local args = {
            [1] = "Bomb"
        }
        EquipRemoteEvent:FireServer(unpack(args))
        task.wait(0.5)
        local tool = plr.Character:FindFirstChild("Bomb")
        if tool then
            local args = { tool }
-- Zielen starten (Rechtsklick gedrückt halten)
mouse2press()
wait(1)  -- 1 Sekunde halten

-- Linksklick ausführen
mouse1press()
wait(0.05)  -- kurzer Klick
mouse1release()

-- 0.5 Sekunden warten
wait(0.5)

-- Zielen beenden (Rechtsklick loslassen)
mouse2release()


            else
                warn("Tool 'Bomb' not found in the Backpack!")
        end
        task.wait(.5)
        fireBombRemoteEvent:FireServer()
        ensurePlayerInVehicle()
        tweenTo(Vector3.new(1096.401, 57.31, 2226.765), Vector3.new(1096.401, 57.31, 2241.98))
        task.wait(2)
        tweenTo(con2Planks.Position)
        JumpOut()
        task.wait(.5)
        plrTween(con2Planks.Position)
        interactWithVisibleMeshParts2(container2:FindFirstChild("Items"))
        interactWithVisibleMeshParts2(container2:FindFirstChild("Items"))
        interactWithVisibleMeshParts2(container2:FindFirstChild("Money"))
        interactWithVisibleMeshParts2(container2:FindFirstChild("Money"))
        task.wait(.5)
        ensurePlayerInVehicle()
        tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
        ServerHop()
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Container2 not open",
            Text = "Leave the game or wait until its cooldown reset",
        })
    end

    ensurePlayerInVehicle()
    tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
    ServerHop()
    end
        end
