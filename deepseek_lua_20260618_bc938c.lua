-- MobileFly - Full Cleaned Version
-- All features preserved, junk code removed

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ====== CONFIGURATION ======
local config = {
    mobileUIPosition = UDim2.new(0.5, -100, 0.5, -40),
    toggleButtonPosition = UDim2.new(1, -70, 0, 20),
    hoverHeight = 0.8,
    hoverSpeed = 2.9,
    selectedIdle = "DefaultIdle",
    baseSpeed = 50,
    boostSpeed = 100,
    controlsLocked = false,
    buttonTheme = "modern",
    guiTheme = "default",
    showArms = true,
    fov = 70,
    smoothFov = 70,
    fovSpeed = 5,
}

-- ====== ANIMATIONS ======
local ANIMATIONS = {
    DefaultIdle = { AnimationId = "rbxassetid://11394033602", Start = 1, End = 1.22, Reverse = true, PlaybackSpeed = 0.2 },
    ChillLevitate = { AnimationId = "rbxassetid://125815409725539", Start = 1, End = 2.6, Reverse = true, PlaybackSpeed = 0.5 },
    FlashyFly = { AnimationId = "rbxassetid://83375399295408", Start = 0.9, End = 1.8, Reverse = true, PlaybackSpeed = 0.6 },
    MetroMan = { AnimationId = "rbxassetid://74645777874912", Start = 0.1, End = 1.8, Reverse = true, PlaybackSpeed = 0.7 },
    MustacheMark = { AnimationId = "rbxassetid://77807262438365", Start = 0.1, End = 3, Reverse = true, PlaybackSpeed = 1 },
    ZombieMark = { AnimationId = "rbxassetid://75532269733454", Start = 0.1, End = 3, Reverse = true, PlaybackSpeed = 1 },
    Thragg = { AnimationId = "rbxassetid://101740020467030", Start = 0, End = 2, Reverse = true, PlaybackSpeed = 1 },
    RelaxedFly = { AnimationId = "rbxassetid://132783162476851", Start = 0.1, End = 5, Reverse = true, PlaybackSpeed = 1 },
    TrackSuitMark = { AnimationId = "rbxassetid://125313210961391", Start = 0.1, End = 4, Reverse = true, PlaybackSpeed = 1 },
    LongHairMark = { AnimationId = "rbxassetid://101003076314239", Start = 0.1, End = 4, Reverse = true, PlaybackSpeed = 1 },
    FlaxanMark = { AnimationId = "rbxassetid://108933593456838", Start = 0.1, End = 4, Reverse = true, PlaybackSpeed = 1 },
    MasklessMark = { AnimationId = "rbxassetid://72952994235315", Start = 0.1, End = 4, Reverse = true, PlaybackSpeed = 1 },
    ViltrimiteMark = { AnimationId = "rbxassetid://124574039035034", Start = 0.1, End = 5, Reverse = true, PlaybackSpeed = 1 },
    PrisonerMark = { AnimationId = "rbxassetid://98385196315632", Start = 1, End = 4, Reverse = true, PlaybackSpeed = 0.6 },
    TargetMark = { AnimationId = "rbxassetid://122741335712327", Start = 1, End = 5.5, Reverse = true, PlaybackSpeed = 0.6 },
    NoGoggles = { AnimationId = "rbxassetid://77715558557237", Start = 1, End = 5, Reverse = true, PlaybackSpeed = 0.7 },
    SheistyMark = { AnimationId = "rbxassetid://121605966423204", Start = 1, End = 3.9, Reverse = true, PlaybackSpeed = 0.6 },
    AnnoyedIdle = { AnimationId = "rbxassetid://93326430026112", Start = 0.2, End = 3, Reverse = true, PlaybackSpeed = 1.2 },
    UpsideDown = { AnimationId = "rbxassetid://100566641677826", Start = 0.1, End = 3, Reverse = true, PlaybackSpeed = 1 },
    Conquest = { AnimationId = "rbxassetid://91850736796162", Start = 0.5, End = 2.5, Reverse = true, PlaybackSpeed = 0.7 },
    MohawkMark = { AnimationId = "rbxassetid://116733977004098", Start = 0.5, End = 3.5, Reverse = true, PlaybackSpeed = 1 },
    BulletProofMark = { AnimationId = "rbxassetid://95218435498795", Start = 0.5, End = 3.5, Reverse = true, PlaybackSpeed = 1 },
    Sinisterv3 = { AnimationId = "rbxassetid://110525048751383", Start = 0.5, End = 3.5, Reverse = true, PlaybackSpeed = 1 },
    BaldMark = { AnimationId = "rbxassetid://76797102013719", Start = 0.5, End = 3.5, Reverse = true, PlaybackSpeed = 1 },
    ViltrimiteIdle = { AnimationId = "rbxassetid://92901321263182", Start = 0.1, End = 4, Reverse = true, PlaybackSpeed = 1 },
    StillIdle = { AnimationId = "rbxassetid://99828067051785", Start = 0.1, End = 3.5, Reverse = true, PlaybackSpeed = 1 },
    StandardIdle = { AnimationId = "rbxassetid://99828067051785", Start = 0.1, End = 3.5, Reverse = true, PlaybackSpeed = 1 },
}

-- ====== STATE ======
local state = {
    isFlying = false,
    isHovering = false,
    boostLevel = 0,
    currentSpeed = 50,
    hoverSine = 0,
    isMoving = false,
    uiOpen = false,
    canSwitchAnim = true,
    flightDir = { F = 0, B = 0, L = 0, R = 0 },
}

local connections = {}
local hoverConnection = nil
local animTrack = nil
local velocity = nil
local gyro = nil
local renderConnection = nil
local flyButton = nil
local boostButton = nil
local toggleButton = nil
local mainFrame = nil
local animScroller = nil
local settingsFrame = nil
local statsFrame = nil
local hoverFrame = nil
local statusLabel = nil
local speedLabel = nil
local boostLabel = nil
local animLabel = nil

-- ====== CORE FUNCTIONS ======
local function UpdateSpeed()
    local b = state.boostLevel
    if b == 0 then
        state.currentSpeed = config.baseSpeed
    elseif b == 1 then
        state.currentSpeed = config.boostSpeed
    elseif b == 2 then
        state.currentSpeed = config.boostSpeed * 2.5
    elseif b == 3 then
        state.currentSpeed = config.boostSpeed * 4
    end
end

local function PlayAnimation(character, animType)
    if animTrack then
        animTrack:Stop()
        animTrack:Destroy()
        animTrack = nil
    end
    
    local humanoid = character and character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local data = nil
    if animType == "Idle" then
        data = ANIMATIONS[config.selectedIdle]
    elseif animType == "Move" then
        data = ANIMATIONS.DefaultIdle
    elseif animType == "Boost" then
        data = ANIMATIONS.DefaultIdle
    elseif animType == "Ultra" then
        data = ANIMATIONS.DefaultIdle
    end
    
    if not data then return end
    
    local anim = Instance.new("Animation")
    anim.AnimationId = data.AnimationId
    
    local track = humanoid:LoadAnimation(anim)
    if track then
        track.Looped = false
        track:Play()
        track.TimePosition = data.Start or 0
        track:AdjustSpeed(data.PlaybackSpeed or 1)
        animTrack = track
    end
end

local function StartHover(character)
    if hoverConnection then
        hoverConnection:Disconnect()
        hoverConnection = nil
    end
    
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local startY = rootPart.Position.Y
    state.hoverSine = 0
    
    hoverConnection = RunService.Heartbeat:Connect(function(delta)
        if not state.isHovering or not rootPart or not rootPart.Parent then
            return
        end
        state.hoverSine = state.hoverSine + delta * config.hoverSpeed
        local pos = rootPart.Position
        rootPart.CFrame = CFrame.new(pos.X, startY + math.sin(state.hoverSine) * config.hoverHeight, pos.Z) * rootPart.CFrame.Rotation
    end)
end

local function StopHover()
    if hoverConnection then
        hoverConnection:Disconnect()
        hoverConnection = nil
    end
end

local function StopAllAnimations()
    local char = LocalPlayer.Character
    if char then
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Animation") and child.Name == "ReplicatedIdle" then
                child:Destroy()
            end
        end
    end
    if animTrack then
        animTrack:Stop()
        animTrack:Destroy()
        animTrack = nil
    end
end

-- ====== FLIGHT CONTROL ======
function ToggleFly()
    local char = LocalPlayer.Character
    if not char then return end
    if state.isFlying then
        StopFly()
    else
        StartFly(char)
    end
end

function CycleBoost()
    if not state.isFlying then return end
    state.boostLevel = (state.boostLevel + 1) % 4
    UpdateSpeed()
    UpdateUI()
end

function StartFly(character)
    if state.isFlying then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    state.isFlying = true
    state.isHovering = true
    state.boostLevel = 0
    UpdateSpeed()
    config.smoothFov = config.fov
    
    humanoid.AutoRotate = true
    humanoid.PlatformStand = false
    
    velocity = Instance.new("BodyVelocity")
    velocity.Name = "FlightVelocity"
    velocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
    velocity.P = 4000
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.Parent = rootPart
    
    gyro = Instance.new("BodyGyro")
    gyro.Name = "FlightGyro"
    gyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
    gyro.P = 10000
    gyro.D = 500
    gyro.CFrame = rootPart.CFrame
    gyro.Parent = rootPart
    
    StartHover(character)
    PlayAnimation(character, "Idle")
    
    -- Input handlers
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local k = input.KeyCode
        if k == Enum.KeyCode.W then state.flightDir.F = 1 end
        if k == Enum.KeyCode.S then state.flightDir.B = -1 end
        if k == Enum.KeyCode.A then state.flightDir.L = -1 end
        if k == Enum.KeyCode.D then state.flightDir.R = 1 end
        if k == Enum.KeyCode.Q then CycleBoost() end
        if k == Enum.KeyCode.U then ToggleUI() end
        if k == Enum.KeyCode.X then ToggleFly() end
    end
    
    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local k = input.KeyCode
        if k == Enum.KeyCode.W then state.flightDir.F = 0 end
        if k == Enum.KeyCode.S then state.flightDir.B = 0 end
        if k == Enum.KeyCode.A then state.flightDir.L = 0 end
        if k == Enum.KeyCode.D then state.flightDir.R = 0 end
    end
    
    connections.InputBegan = UserInputService.InputBegan:Connect(onInputBegan)
    connections.InputEnded = UserInputService.InputEnded:Connect(onInputEnded)
    
    -- Render loop
    renderConnection = RunService.RenderStepped:Connect(function(delta)
        if not state.isFlying or not rootPart or not rootPart.Parent then
            return
        end
        
        -- FOV smoothing
        config.smoothFov = config.smoothFov + (config.fov - config.smoothFov) * delta * config.fovSpeed
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = config.smoothFov
        end
        
        local isMoving = math.abs(state.flightDir.F) > 0 or math.abs(state.flightDir.B) > 0 or
                         math.abs(state.flightDir.L) > 0 or math.abs(state.flightDir.R) > 0
        
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        local camCF = cam.CFrame
        local pos = rootPart.Position
        
        local moveVec = camCF:VectorToWorldSpace(Vector3.new(
            state.flightDir.L + state.flightDir.R,
            0,
            state.flightDir.F + state.flightDir.B
        ))
        
        if isMoving then
            if state.boostLevel == 1 then
                gyro.CFrame = gyro.CFrame:Lerp(CFrame.new(pos, pos + camCF.LookVector) * CFrame.Angles(math.rad(-90), 0, 0), 0.15)
            else
                gyro.CFrame = gyro.CFrame:Lerp(CFrame.new(pos, pos + camCF.LookVector), 0.15)
            end
            
            if moveVec.Magnitude > 0 then
                local targetVel = moveVec.Unit * state.currentSpeed
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    targetVel = targetVel + Vector3.new(0, state.currentSpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    targetVel = targetVel + Vector3.new(0, -state.currentSpeed, 0)
                end
                velocity.Velocity = velocity.Velocity:Lerp(targetVel, 0.85)
            end
        else
            gyro.CFrame = gyro.CFrame:Lerp(CFrame.new(pos, pos + camCF.LookVector), 0.15)
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Ascend/Descend when stationary
        if not isMoving then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity.Velocity = velocity.Velocity + Vector3.new(0, state.currentSpeed * delta * 60, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity.Velocity = velocity.Velocity + Vector3.new(0, -state.currentSpeed * delta * 60, 0)
            end
        end
    end)
    
    UpdateUI()
end

function StopFly()
    if not state.isFlying then return end
    
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        if velocity then velocity:Destroy(); velocity = nil end
        if gyro then gyro:Destroy(); gyro = nil end
    end
    
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.AutoRotate = true
        char.Humanoid.PlatformStand = false
    end
    
    StopAllAnimations()
    StopHover()
    
    if renderConnection then renderConnection:Disconnect(); renderConnection = nil end
    if connections.InputBegan then connections.InputBegan:Disconnect(); connections.InputBegan = nil end
    if connections.InputEnded then connections.InputEnded:Disconnect(); connections.InputEnded = nil end
    
    state.isFlying = false
    state.isHovering = false
    state.boostLevel = 0
    UpdateSpeed()
    UpdateUI()
end

-- ====== UI CREATION ======
local function CreateGlowButton(name, text, position, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.4, 0, 0.7, 0)
    btn.Position = position
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
    btn.BackgroundTransparency = 0.1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Color3.fromRGB(160, 100, 220)
    glow.ImageTransparency = 0.6
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.ZIndex = -1
    glow.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.05,
            Size = UDim2.new(0.42, 0, 0.75, 0)
        }):Play()
        TweenService:Create(glow, TweenInfo.new(0.2), {
            ImageTransparency = 0.4
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0.4, 0, 0.7, 0)
        }):Play()
        TweenService:Create(glow, TweenInfo.new(0.2), {
            ImageTransparency = 0.7
        }):Play()
    end)
    
    return btn
end

local function CreateMobileControls()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MobileFlyControls"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Name = "MobileControls"
    frame.Size = UDim2.new(0, 200, 0, 80)
    frame.Position = config.mobileUIPosition
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(88, 101, 242)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    local glowBorder = Instance.new("ImageLabel")
    glowBorder.Size = UDim2.new(1, 40, 1, 40)
    glowBorder.Position = UDim2.new(0, -20, 0, -20)
    glowBorder.BackgroundTransparency = 1
    glowBorder.Image = "rbxassetid://5028857084"
    glowBorder.ImageColor3 = Color3.fromRGB(160, 100, 220)
    glowBorder.ImageTransparency = 0.8
    glowBorder.ScaleType = Enum.ScaleType.Slice
    glowBorder.SliceCenter = Rect.new(24, 24, 276, 276)
    glowBorder.ZIndex = -1
    glowBorder.Parent = frame
    
    local container = Instance.new("Frame")
    container.Name = "ButtonContainer"
    container.Size = UDim2.new(1, -20, 1, -20)
    container.Position = UDim2.new(0, 10, 0, 10)
    container.BackgroundTransparency = 1
    container.Parent = frame
    
    flyButton = CreateGlowButton("FlyButton", "FLY", UDim2.new(0.05, 0, 0.15, 0), Color3.fromRGB(40, 40, 50))
    flyButton.Parent = container
    
    boostButton = CreateGlowButton("BoostButton", "BOOST", UDim2.new(0.55, 0, 0.15, 0), Color3.fromRGB(50, 40, 60))
    boostButton.Parent = container
    
    flyButton.MouseButton1Click:Connect(ToggleFly)
    boostButton.MouseButton1Click:Connect(CycleBoost)
    
    -- Dragging
    local drag = false
    local dragStart = nil
    local framePos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if config.controlsLocked then return end
            drag = true
            dragStart = input.Position
            framePos = frame.Position
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            if config.controlsLocked then return end
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
            config.mobileUIPosition = frame.Position
        end
    end)
    
    UpdateUI()
    return gui
end

-- ====== ANIMATION UI ======
local function CreateAnimationUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlightAnimationUI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Toggle Button
    toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 60, 0, 60)
    toggleButton.Position = config.toggleButtonPosition
    toggleButton.AnchorPoint = Vector2.new(1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(90, 50, 140)
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.Image = "rbxassetid://135684785837881"
    toggleButton.ScaleType = Enum.ScaleType.Fit
    toggleButton.ImageColor3 = Color3.fromRGB(240, 200, 255)
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = gui
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 70, 180)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(160, 100, 220)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 120, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 70, 180))
    })
    gradient.Rotation = 45
    gradient.Parent = toggleButton
    
    TweenService:Create(gradient, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Rotation = 405
    }):Play()
    
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Color3.fromRGB(160, 100, 220)
    glow.ImageTransparency = 0.6
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.ZIndex = -1
    glow.Parent = toggleButton
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = toggleButton
    
    -- Main Frame
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.38, 0, 0.86, 0)
    mainFrame.Position = UDim2.new(1, 400, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(1, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.Parent = gui
    
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 35)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(30, 15, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 65)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(30, 15, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 35))
    })
    mainGradient.Rotation = 90
    mainGradient.Parent = mainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    local mainBorder = Instance.new("Frame")
    mainBorder.Name = "Border"
    mainBorder.Size = UDim2.new(1, 6, 1, 6)
    mainBorder.Position = UDim2.new(0, -3, 0, -3)
    mainBorder.BackgroundTransparency = 1
    mainBorder.ZIndex = -1
    mainBorder.Parent = mainFrame
    
    local borderGradient = Instance.new("UIGradient")
    borderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 220)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(220, 120, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(160, 60, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 220))
    })
    borderGradient.Rotation = 0
    borderGradient.Parent = mainBorder
    
    TweenService:Create(borderGradient, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Rotation = 360
    }):Play()
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0.1, 0)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.7, 0, 0.8, 0)
    titleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ANIMATIONS & SETTINGS"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0.08, 0, 0.6, 0)
    closeBtn.Position = UDim2.new(0.9, 0, 0.2, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 180)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.Image = "rbxassetid://3926305904"
    closeBtn.ImageColor3 = Color3.fromRGB(255, 240, 255)
    closeBtn.ImageRectOffset = Vector2.new(284, 4)
    closeBtn.ImageRectSize = Vector2.new(24, 24)
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.5, 0)
    closeCorner.Parent = closeBtn
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabSwitcher"
    tabContainer.Size = UDim2.new(0.9, 0, 0.06, 0)
    tabContainer.Position = UDim2.new(0.05, 0, 0.13, 0)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 18, 45)
    tabContainer.BackgroundTransparency = 0.2
    tabContainer.Parent = mainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabContainer
    
    -- Animations Tab
    local animTab = Instance.new("TextButton")
    animTab.Name = "AnimationsTab"
    animTab.Size = UDim2.new(0.235, 0, 1, 0)
    animTab.Position = UDim2.new(0, 0, 0, 0)
    animTab.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    animTab.BackgroundTransparency = 0.1
    animTab.Text = "ANIMATIONS"
    animTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    animTab.TextSize = 12
    animTab.Font = Enum.Font.GothamBold
    animTab.AutoButtonColor = false
    animTab.Parent = tabContainer
    
    local animTabCorner = Instance.new("UICorner")
    animTabCorner.CornerRadius = UDim.new(0, 8)
    animTabCorner.Parent = animTab
    
    -- Button Themes Tab
    local buttonThemesTab = Instance.new("TextButton")
    buttonThemesTab.Name = "ButtonThemesTab"
    buttonThemesTab.Size = UDim2.new(0.235, 0, 1, 0)
    buttonThemesTab.Position = UDim2.new(0.255, 0, 0, 0)
    buttonThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    buttonThemesTab.BackgroundTransparency = 0.3
    buttonThemesTab.Text = "BUTTON THEMES"
    buttonThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    buttonThemesTab.TextSize = 12
    buttonThemesTab.Font = Enum.Font.GothamBold
    buttonThemesTab.AutoButtonColor = false
    buttonThemesTab.Parent = tabContainer
    
    local buttonThemesCorner = Instance.new("UICorner")
    buttonThemesCorner.CornerRadius = UDim.new(0, 8)
    buttonThemesCorner.Parent = buttonThemesTab
    
    -- GUI Themes Tab
    local guiThemesTab = Instance.new("TextButton")
    guiThemesTab.Name = "GUIThemesTab"
    guiThemesTab.Size = UDim2.new(0.235, 0, 1, 0)
    guiThemesTab.Position = UDim2.new(0.51, 0, 0, 0)
    guiThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    guiThemesTab.BackgroundTransparency = 0.3
    guiThemesTab.Text = "GUI THEMES"
    guiThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    guiThemesTab.TextSize = 12
    guiThemesTab.Font = Enum.Font.GothamBold
    guiThemesTab.AutoButtonColor = false
    guiThemesTab.Parent = tabContainer
    
    local guiThemesCorner = Instance.new("UICorner")
    guiThemesCorner.CornerRadius = UDim.new(0, 8)
    guiThemesCorner.Parent = guiThemesTab
    
    -- Settings Tab
    local settingsTab = Instance.new("TextButton")
    settingsTab.Name = "SettingsTab"
    settingsTab.Size = UDim2.new(0.235, 0, 1, 0)
    settingsTab.Position = UDim2.new(0.765, 0, 0, 0)
    settingsTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    settingsTab.BackgroundTransparency = 0.3
    settingsTab.Text = "SETTINGS"
    settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    settingsTab.TextSize = 12
    settingsTab.Font = Enum.Font.GothamBold
    settingsTab.AutoButtonColor = false
    settingsTab.Parent = tabContainer
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 8)
    settingsCorner.Parent = settingsTab
    
    -- Tab Selector
    local tabSelector = Instance.new("Frame")
    tabSelector.Name = "TabSelector"
    tabSelector.Size = UDim2.new(0.235, 0, 0.1, 0)
    tabSelector.Position = UDim2.new(0, 0, 0.9, 0)
    tabSelector.BackgroundColor3 = Color3.fromRGB(180, 130, 230)
    tabSelector.BorderSizePixel = 0
    tabSelector.Parent = tabContainer
    
    local selectorCorner = Instance.new("UICorner")
    selectorCorner.CornerRadius = UDim.new(0, 4)
    selectorCorner.Parent = tabSelector
    
    -- Animation Scroller
    animScroller = Instance.new("ScrollingFrame")
    animScroller.Name = "AnimationScroller"
    animScroller.Size = UDim2.new(0.45, -10, 0.75, -50)
    animScroller.Position = UDim2.new(0.02, 0, 0.12, 0)
    animScroller.BackgroundTransparency = 1
    animScroller.ScrollBarThickness = 8
    animScroller.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
    animScroller.ScrollBarImageTransparency = 0.3
    animScroller.Parent = mainFrame
    
    local animList = Instance.new("UIListLayout")
    animList.Name = "ListLayout"
    animList.Padding = UDim.new(0, 8)
    animList.SortOrder = Enum.SortOrder.LayoutOrder
    animList.Parent = animScroller
    
    -- Button Themes Frame
    local buttonThemesFrame = Instance.new("ScrollingFrame")
    buttonThemesFrame.Name = "ButtonThemesFrame"
    buttonThemesFrame.Size = UDim2.new(0.9, 0, 0.75, -50)
    buttonThemesFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
    buttonThemesFrame.BackgroundTransparency = 1
    buttonThemesFrame.ScrollBarThickness = 8
    buttonThemesFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
    buttonThemesFrame.ScrollBarImageTransparency = 0.3
    buttonThemesFrame.Visible = false
    buttonThemesFrame.Parent = mainFrame
    
    local buttonThemesList = Instance.new("UIListLayout")
    buttonThemesList.Name = "ButtonThemesListLayout"
    buttonThemesList.Padding = UDim.new(0, 8)
    buttonThemesList.SortOrder = Enum.SortOrder.LayoutOrder
    buttonThemesList.Parent = buttonThemesFrame
    
    -- GUI Themes Frame
    local guiThemesFrame = Instance.new("ScrollingFrame")
    guiThemesFrame.Name = "GUIThemesFrame"
    guiThemesFrame.Size = UDim2.new(0.9, 0, 0.75, -50)
    guiThemesFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
    guiThemesFrame.BackgroundTransparency = 1
    guiThemesFrame.ScrollBarThickness = 8
    guiThemesFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
    guiThemesFrame.ScrollBarImageTransparency = 0.3
    guiThemesFrame.Visible = false
    guiThemesFrame.Parent = mainFrame
    
    local guiThemesList = Instance.new("UIListLayout")
    guiThemesList.Name = "GUIThemesListLayout"
    guiThemesList.Padding = UDim.new(0, 8)
    guiThemesList.SortOrder = Enum.SortOrder.LayoutOrder
    guiThemesList.Parent = guiThemesFrame
    
    -- Settings Frame
    settingsFrame = Instance.new("ScrollingFrame")
    settingsFrame.Name = "SettingsPageFrame"
    settingsFrame.Size = UDim2.new(0.9, 0, 0.75, -50)
    settingsFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.ScrollBarThickness = 8
    settingsFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
    settingsFrame.ScrollBarImageTransparency = 0.3
    settingsFrame.Visible = false
    settingsFrame.Parent = mainFrame
    
    local settingsList = Instance.new("UIListLayout")
    settingsList.Name = "SettingsListLayout"
    settingsList.Padding = UDim.new(0, 10)
    settingsList.SortOrder = Enum.SortOrder.LayoutOrder
    settingsList.Parent = settingsFrame
    
    settingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        settingsFrame.CanvasSize = UDim2.new(0, 0, 0, settingsList.AbsoluteContentSize.Y + 20)
    end)
    
    -- Stats Frame
    statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsContainer"
    statsFrame.Size = UDim2.new(0.5, -15, 0.75, -50)
    statsFrame.Position = UDim2.new(0.5, 5, 0.12, 0)
    statsFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    statsFrame.BackgroundTransparency = 0.2
    statsFrame.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 10)
    statsCorner.Parent = statsFrame
    
    local statsContainer = Instance.new("Frame")
    statsContainer.Name = "StatsContainer"
    statsContainer.Size = UDim2.new(1, -20, 0.45, 0)
    statsContainer.Position = UDim2.new(0, 10, 0.02, 0)
    statsContainer.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
    statsContainer.BackgroundTransparency = 0.2
    statsContainer.Parent = statsFrame
    
    local statsContainerCorner = Instance.new("UICorner")
    statsContainerCorner.CornerRadius = UDim.new(0, 8)
    statsContainerCorner.Parent = statsContainer
    
    local statsTitle = Instance.new("TextLabel")
    statsTitle.Name = "StatsTitle"
    statsTitle.Size = UDim2.new(1, -10, 0.2, 0)
    statsTitle.Position = UDim2.new(0, 5, 0, 5)
    statsTitle.BackgroundTransparency = 1
    statsTitle.Text = "FLIGHT STATUS"
    statsTitle.TextColor3 = Color3.fromRGB(230, 200, 255)
    statsTitle.TextSize = 16
    statsTitle.Font = Enum.Font.GothamBold
    statsTitle.TextXAlignment = Enum.TextXAlignment.Center
    statsTitle.Parent = statsContainer
    
    -- Status
    local statusContainer = Instance.new("Frame")
    statusContainer.Name = "StatusContainer"
    statusContainer.Size = UDim2.new(1, -20, 0.15, 0)
    statusContainer.Position = UDim2.new(0, 10, 0.25, 0)
    statusContainer.BackgroundTransparency = 1
    statusContainer.Parent = statsContainer
    
    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusStat"
    statusLabel.Size = UDim2.new(0.8, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.2, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "GROUNDED"
    statusLabel.TextColor3 = Color3.fromRGB(210, 180, 240)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusContainer
    
    -- Speed
    local speedContainer = Instance.new("Frame")
    speedContainer.Name = "SpeedContainer"
    speedContainer.Size = UDim2.new(1, -20, 0.15, 0)
    speedContainer.Position = UDim2.new(0, 10, 0.45, 0)
    speedContainer.BackgroundTransparency = 1
    speedContainer.Parent = statsContainer
    
    speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedStat"
    speedLabel.Size = UDim2.new(0.8, 0, 1, 0)
    speedLabel.Position = UDim2.new(0.2, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "SPEED: 50"
    speedLabel.TextColor3 = Color3.fromRGB(210, 180, 240)
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.GothamMedium
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedContainer
    
    -- Boost
    local boostContainer = Instance.new("Frame")
    boostContainer.Name = "BoostContainer"
    boostContainer.Size = UDim2.new(1, -20, 0.15, 0)
    boostContainer.Position = UDim2.new(0, 10, 0.65, 0)
    boostContainer.BackgroundTransparency = 1
    boostContainer.Parent = statsContainer
    
    boostLabel = Instance.new("TextLabel")
    boostLabel.Name = "BoostStat"
    boostLabel.Size = UDim2.new(0.8, 0, 1, 0)
    boostLabel.Position = UDim2.new(0.2, 0, 0, 0)
    boostLabel.BackgroundTransparency = 1
    boostLabel.Text = "BOOST: OFF"
    boostLabel.TextColor3 = Color3.fromRGB(210, 180, 240)
    boostLabel.TextSize = 14
    boostLabel.Font = Enum.Font.GothamMedium
    boostLabel.TextXAlignment = Enum.TextXAlignment.Left
    boostLabel.Parent = boostContainer
    
    -- Animation
    local animContainer = Instance.new("Frame")
    animContainer.Name = "AnimContainer"
    animContainer.Size = UDim2.new(1, -20, 0.15, 0)
    animContainer.Position = UDim2.new(0, 10, 0.85, 0)
    animContainer.BackgroundTransparency = 1
    animContainer.Parent = statsContainer
    
    animLabel = Instance.new("TextLabel")
    animLabel.Name = "AnimationStat"
    animLabel.Size = UDim2.new(0.8, 0, 1, 0)
    animLabel.Position = UDim2.new(0.2, 0, 0, 0)
    animLabel.BackgroundTransparency = 1
    animLabel.Text = config.selectedIdle
    animLabel.TextColor3 = Color3.fromRGB(210, 180, 240)
    animLabel.TextSize = 12
    animLabel.Font = Enum.Font.GothamMedium
    animLabel.TextXAlignment = Enum.TextXAlignment.Left
    animLabel.Parent = animContainer
    
    -- Populate animation buttons
    local animNames = {
        "DefaultIdle", "MustacheMark", "Thragg", "RelaxedFly", "ZombieMark",
        "ChillLevitate", "StillIdle", "MetroMan", "ViltrimiteMark", "FlashyFly",
        "NoGoggles", "TargetMark", "Sinisterv3", "TrackSuitMark", "BaldMark",
        "LongHairMark", "FlaxanMark", "MasklessMark", "BulletProofMark",
        "PrisonerMark", "UpsideDown", "SheistyMark", "AnnoyedIdle",
        "ViltrimiteIdle", "Conquest", "MohawkMark"
    }
    
    for i, name in ipairs(animNames) do
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(1, -8, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
        btn.BackgroundTransparency = 0.1
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.LayoutOrder = i
        btn.Parent = animScroller
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local indicator = Instance.new("Frame")
        indicator.Name = "SelectionIndicator"
        indicator.Size = UDim2.new(0.02, 0, 0.6, 0)
        indicator.Position = UDim2.new(0.02, 0, 0.2, 0)
        indicator.BackgroundColor3 = name == config.selectedIdle and Color3.fromRGB(180, 130, 230) or Color3.fromRGB(80, 50, 100)
        indicator.Parent = btn
        
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(0.5, 0)
        indCorner.Parent = indicator
        
        btn.MouseEnter:Connect(function()
            if config.selectedIdle ~= name and state.canSwitchAnim then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.05,
                    Size = UDim2.new(1, -4, 0, 42)
                }):Play()
            end
        end)
        
        btn.MouseLeave:Connect(function()
            if config.selectedIdle ~= name then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.1,
                    Size = UDim2.new(1, -8, 0, 40)
                }):Play()
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            if not state.canSwitchAnim then return end
            if state.isFlying then
                -- Show notification
                return
            end
            
            state.canSwitchAnim = false
            config.selectedIdle = name
            
            -- Update indicators
            for _, child in pairs(animScroller:GetChildren()) do
                if child:IsA("TextButton") and child:FindFirstChild("SelectionIndicator") then
                    local ind = child.SelectionIndicator
                    if child.Name == name then
                        TweenService:Create(ind, TweenInfo.new(0.3), {
                            BackgroundColor3 = Color3.fromRGB(180, 130, 230),
                            Size = UDim2.new(0.03, 0, 0.6, 0)
                        }):Play()
                    else
                        TweenService:Create(ind, TweenInfo.new(0.3), {
                            BackgroundColor3 = Color3.fromRGB(80, 50, 100),
                            Size = UDim2.new(0.02, 0, 0.4, 0)
                        }):Play()
                    end
                end
            end
            
            animLabel.Text = name
            
            task.delay(0.5, function()
                state.canSwitchAnim = true
            end)
        end)
    end
    
    -- Button themes
    local modernBtn = Instance.new("TextButton")
    modernBtn.Name = "ModernTheme"
    modernBtn.Size = UDim2.new(1, -8, 0, 50)
    modernBtn.BackgroundColor3 = config.buttonTheme == "modern" and Color3.fromRGB(80, 50, 120) or Color3.fromRGB(35, 20, 50)
    modernBtn.BackgroundTransparency = 0.1
    modernBtn.Text = "MODERN THEME\n(Centered, Draggable)"
    modernBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modernBtn.TextSize = 12
    modernBtn.Font = Enum.Font.GothamMedium
    modernBtn.TextWrapped = true
    modernBtn.LayoutOrder = 1
    modernBtn.Parent = buttonThemesFrame
    
    local modernCorner = Instance.new("UICorner")
    modernCorner.CornerRadius = UDim.new(0, 8)
    modernCorner.Parent = modernBtn
    
    local classicBtn = Instance.new("TextButton")
    classicBtn.Name = "ClassicTheme"
    classicBtn.Size = UDim2.new(1, -8, 0, 50)
    classicBtn.BackgroundColor3 = config.buttonTheme == "classic" and Color3.fromRGB(80, 50, 120) or Color3.fromRGB(35, 20, 50)
    classicBtn.BackgroundTransparency = 0.1
    classicBtn.Text = "CLASSIC THEME\n(Right Side, Static)"
    classicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    classicBtn.TextSize = 12
    classicBtn.Font = Enum.Font.GothamMedium
    classicBtn.TextWrapped = true
    classicBtn.LayoutOrder = 2
    classicBtn.Parent = buttonThemesFrame
    
    local classicCorner = Instance.new("UICorner")
    classicCorner.CornerRadius = UDim.new(0, 8)
    classicCorner.Parent = classicBtn
    
    modernBtn.MouseButton1Click:Connect(function()
        if config.buttonTheme ~= "modern" then
            config.buttonTheme = "modern"
            config.mobileUIPosition = UDim2.new(0.5, -100, 0.5, -40)
            modernBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
            classicBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
            -- Recreate mobile controls
            if flyButton and flyButton.Parent then
                flyButton.Parent.Parent:Destroy()
            end
            CreateMobileControls()
            SaveSettings()
        end
    end)
    
    classicBtn.MouseButton1Click:Connect(function()
        if config.buttonTheme ~= "classic" then
            config.buttonTheme = "classic"
            classicBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
            modernBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
            -- Recreate mobile controls
            if flyButton and flyButton.Parent then
                flyButton.Parent.Parent:Destroy()
            end
            CreateMobileControls()
            SaveSettings()
        end
    end)
    
    -- GUI Themes (coming soon)
    local comingSoon = Instance.new("TextLabel")
    comingSoon.Name = "ComingSoon"
    comingSoon.Size = UDim2.new(1, -8, 0, 100)
    comingSoon.BackgroundTransparency = 1
    comingSoon.Text = "COMING SOON\n\nMore GUI themes will be available in future updates!"
    comingSoon.TextColor3 = Color3.fromRGB(200, 200, 200)
    comingSoon.TextSize = 14
    comingSoon.Font = Enum.Font.GothamMedium
    comingSoon.TextWrapped = true
    comingSoon.TextTransparency = 0.5
    comingSoon.LayoutOrder = 1
    comingSoon.Parent = guiThemesFrame
    
    -- Settings content
    local function CreateSettingSection(title, order)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -8, 0, 28)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(230, 200, 255)
        label.TextSize = 16
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = order
        label.Parent = settingsFrame
        return label
    end
    
    CreateSettingSection("HOVER SETTINGS", 1)
    
    -- Hover Height
    local function CreateSlider(label, value, min, max, format, callback, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -8, 0, 62)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = settingsFrame
        
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.7, 0, 0, 18)
        labelText.Position = UDim2.new(0, 0, 0, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.fromRGB(210, 180, 240)
        labelText.TextSize = 13
        labelText.Font = Enum.Font.GothamMedium
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame
        
        local valueText = Instance.new("TextLabel")
        valueText.Size = UDim2.new(0.3, 0, 0, 18)
        valueText.Position = UDim2.new(0.7, 0, 0, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = string.format(format, value)
        valueText.TextColor3 = Color3.fromRGB(250, 230, 255)
        valueText.TextSize = 13
        valueText.Font = Enum.Font.GothamBold
        valueText.TextXAlignment = Enum.TextXAlignment.Right
        valueText.Parent = frame
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 14)
        track.Position = UDim2.new(0, 0, 0, 34)
        track.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
        track.Parent = frame
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0.5, 0)
        trackCorner.Parent = track
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(180, 130, 230)
        fill.Parent = track
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0.5, 0)
        fillCorner.Parent = fill
        
        local dragging = false
        
        local function UpdateSlider(inputX)
            local width = track.AbsoluteSize.X
            local pos = math.clamp(inputX - track.AbsolutePosition.X, 0, width) / width
            local val = min + (max - min) * pos
            fill.Size = UDim2.new(pos, 0, 1, 0)
            valueText.Text = string.format(format, val)
            callback(val)
        end
        
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                UpdateSlider(input.Position.X)
            end
        end)
        
        track.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input.Position.X)
            end
        end)
        
        track.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        return frame, fill, valueText
    end
    
    -- Hover Height slider
    local hoverHeightFrame, hoverHeightFill, hoverHeightValue = CreateSlider(
        "HOVER HEIGHT",
        config.hoverHeight,
        0.5, 2,
        "%.1f",
        function(val)
            config.hoverHeight = val
            if state.isFlying and state.isHovering then
                StopHover()
                StartHover(LocalPlayer.Character)
            end
            SaveSettings()
        end,
        2
    )
    
    -- Hover Speed slider
    local hoverSpeedFrame, hoverSpeedFill, hoverSpeedValue = CreateSlider(
        "HOVER SPEED",
        config.hoverSpeed,
        1, 5,
        "%.1f",
        function(val)
            config.hoverSpeed = val
            SaveSettings()
        end,
        3
    )
    
    -- Reset Hover Button
    local resetHoverBtn = Instance.new("TextButton")
    resetHoverBtn.Name = "ResetHoverButton"
    resetHoverBtn.Size = UDim2.new(1, -8, 0, 36)
    resetHoverBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 100)
    resetHoverBtn.BackgroundTransparency = 0.1
    resetHoverBtn.Text = "RESET HOVER SETTINGS"
    resetHoverBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetHoverBtn.TextSize = 12
    resetHoverBtn.Font = Enum.Font.GothamBold
    resetHoverBtn.LayoutOrder = 4
    resetHoverBtn.Parent = settingsFrame
    
    local resetHoverCorner = Instance.new("UICorner")
    resetHoverCorner.CornerRadius = UDim.new(0, 6)
    resetHoverCorner.Parent = resetHoverBtn
    
    resetHoverBtn.MouseButton1Click:Connect(function()
        config.hoverHeight = 0.8
        config.hoverSpeed = 2.9
        hoverHeightValue.Text = "0.8"
        hoverSpeedValue.Text = "2.9"
        hoverHeightFill.Size = UDim2.new(0.2, 0, 1, 0)
        hoverSpeedFill.Size = UDim2.new(0.475, 0, 1, 0)
        if state.isFlying and state.isHovering then
            StopHover()
            StartHover(LocalPlayer.Character)
        end
        SaveSettings()
    end)
    
    CreateSettingSection("SPEED SETTINGS", 5)
    
    -- Base Speed slider
    local baseSpeedFrame, baseSpeedFill, baseSpeedValue = CreateSlider(
        "BASE SPEED",
        config.baseSpeed,
        10, 300,
        "%.0f",
        function(val)
            config.baseSpeed = math.floor(val + 0.5)
            baseSpeedValue.Text = tostring(config.baseSpeed)
            if state.boostLevel == 0 then
                UpdateSpeed()
                UpdateUI()
            end
            SaveSettings()
        end,
        6
    )
    
    -- Boost Speed slider
    local boostSpeedFrame, boostSpeedFill, boostSpeedValue = CreateSlider(
        "BOOST SPEED",
        config.boostSpeed,
        10, 600,
        "%.0f",
        function(val)
            config.boostSpeed = math.floor(val + 0.5)
            boostSpeedValue.Text = tostring(config.boostSpeed)
            if state.boostLevel > 0 then
                UpdateSpeed()
                UpdateUI()
            end
            SaveSettings()
        end,
        7
    )
    
    -- Reset Speed Button
    local resetSpeedBtn = Instance.new("TextButton")
    resetSpeedBtn.Name = "ResetSpeedButton"
    resetSpeedBtn.Size = UDim2.new(1, -8, 0, 36)
    resetSpeedBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 100)
    resetSpeedBtn.BackgroundTransparency = 0.1
    resetSpeedBtn.Text = "RESET SPEED SETTINGS"
    resetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetSpeedBtn.TextSize = 12
    resetSpeedBtn.Font = Enum.Font.GothamBold
    resetSpeedBtn.LayoutOrder = 8
    resetSpeedBtn.Parent = settingsFrame
    
    local resetSpeedCorner = Instance.new("UICorner")
    resetSpeedCorner.CornerRadius = UDim.new(0, 6)
    resetSpeedCorner.Parent = resetSpeedBtn
    
    resetSpeedBtn.MouseButton1Click:Connect(function()
        config.baseSpeed = 50
        config.boostSpeed = 100
        baseSpeedValue.Text = "50"
        boostSpeedValue.Text = "100"
        baseSpeedFill.Size = UDim2.new(40/290, 0, 1, 0)
        boostSpeedFill.Size = UDim2.new(90/590, 0, 1, 0)
        UpdateSpeed()
        UpdateUI()
        SaveSettings()
    end)
    
    CreateSettingSection("VISIBILITY SETTINGS", 9)
    
    -- Show Arms Toggle
    local armsContainer = Instance.new("Frame")
    armsContainer.Name = "ArmsContainer"
    armsContainer.Size = UDim2.new(1, -8, 0, 50)
    armsContainer.BackgroundTransparency = 1
    armsContainer.LayoutOrder = 10
    armsContainer.Parent = settingsFrame
    
    local armsLabel = Instance.new("TextLabel")
    armsLabel.Size = UDim2.new(0.7, 0, 1, 0)
    armsLabel.Position = UDim2.new(0, 0, 0, 0)
    armsLabel.BackgroundTransparency = 1
    armsLabel.Text = "SHOW ARMS IN FIRST PERSON"
    armsLabel.TextColor3 = Color3.fromRGB(210, 180, 240)
    armsLabel.TextSize = 13
    armsLabel.Font = Enum.Font.GothamMedium
    armsLabel.TextXAlignment = Enum.TextXAlignment.Left
    armsLabel.TextWrapped = true
    armsLabel.Parent = armsContainer
    
    local armsToggle = Instance.new("Frame")
    armsToggle.Name = "Toggle"
    armsToggle.Size = UDim2.new(0, 50, 0, 25)
    armsToggle.Position = UDim2.new(0.7, 0, 0.25, 0)
    armsToggle.BackgroundColor3 = config.showArms and Color3.fromRGB(160, 100, 220) or Color3.fromRGB(100, 100, 100)
    armsToggle.ClipsDescendants = true
    armsToggle.ZIndex = 16
    armsToggle.Parent = armsContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = armsToggle
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0.5, -4, 1, -4)
    toggleKnob.Position = config.showArms and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleKnob.Parent = armsToggle
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    armsToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            config.showArms = not config.showArms
            armsToggle.BackgroundColor3 = config.showArms and Color3.fromRGB(160, 100, 220) or Color3.fromRGB(100, 100, 100)
            TweenService:Create(toggleKnob, TweenInfo.new(0.3), {
                Position = config.showArms and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            SaveSettings()
        end
    end)
    
    -- Tab switching
    local function SwitchTab(tab)
        if tab == "animations" then
            TweenService:Create(tabSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0.9, 0)
            }):Play()
            animTab.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
            animTab.BackgroundTransparency = 0.1
            animTab.TextColor3 = Color3.fromRGB(255, 255, 255)
            buttonThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            buttonThemesTab.BackgroundTransparency = 0.3
            buttonThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            guiThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            guiThemesTab.BackgroundTransparency = 0.3
            guiThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            settingsTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            settingsTab.BackgroundTransparency = 0.3
            settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            animScroller.Visible = true
            buttonThemesFrame.Visible = false
            guiThemesFrame.Visible = false
            settingsFrame.Visible = false
            statsFrame.Visible = true
        elseif tab == "buttonThemes" then
            TweenService:Create(tabSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.255, 0, 0.9, 0)
            }):Play()
            buttonThemesTab.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
            buttonThemesTab.BackgroundTransparency = 0.1
            buttonThemesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
            animTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            animTab.BackgroundTransparency = 0.3
            animTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            guiThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            guiThemesTab.BackgroundTransparency = 0.3
            guiThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            settingsTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            settingsTab.BackgroundTransparency = 0.3
            settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            animScroller.Visible = false
            buttonThemesFrame.Visible = true
            guiThemesFrame.Visible = false
            settingsFrame.Visible = false
            statsFrame.Visible = false
        elseif tab == "guiThemes" then
            TweenService:Create(tabSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.51, 0, 0.9, 0)
            }):Play()
            guiThemesTab.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
            guiThemesTab.BackgroundTransparency = 0.1
            guiThemesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
            animTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            animTab.BackgroundTransparency = 0.3
            animTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            buttonThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            buttonThemesTab.BackgroundTransparency = 0.3
            buttonThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            settingsTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            settingsTab.BackgroundTransparency = 0.3
            settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            animScroller.Visible = false
            buttonThemesFrame.Visible = false
            guiThemesFrame.Visible = true
            settingsFrame.Visible = false
            statsFrame.Visible = false
        elseif tab == "settings" then
            TweenService:Create(tabSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.765, 0, 0.9, 0)
            }):Play()
            settingsTab.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
            settingsTab.BackgroundTransparency = 0.1
            settingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
            animTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            animTab.BackgroundTransparency = 0.3
            animTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            buttonThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            buttonThemesTab.BackgroundTransparency = 0.3
            buttonThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            guiThemesTab.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            guiThemesTab.BackgroundTransparency = 0.3
            guiThemesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            animScroller.Visible = false
            buttonThemesFrame.Visible = false
            guiThemesFrame.Visible = false
            settingsFrame.Visible = true
            statsFrame.Visible = false
        end
    end
    
    animTab.MouseButton1Click:Connect(function()
        SwitchTab("animations")
    end)
    
    buttonThemesTab.MouseButton1Click:Connect(function()
        SwitchTab("buttonThemes")
    end)
    
    guiThemesTab.MouseButton1Click:Connect(function()
        SwitchTab("guiThemes")
    end)
    
    settingsTab.MouseButton1Click:Connect(function()
        SwitchTab("settings")
    end)
    
    -- Close button
    closeBtn.MouseButton1Click:Connect(function()
        ToggleUI()
    end)
    
    -- Toggle button
    local function OnToggleClick()
        state.uiOpen = not state.uiOpen
        if state.uiOpen then
            mainFrame.Visible = true
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -70, 0.5, 0)
            }):Play()
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {
                ImageColor3 = Color3.fromRGB(200, 150, 255)
            }):Play()
            UpdateUI()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 400, 0.5, 0)
            }):Play()
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {
                ImageColor3 = Color3.fromRGB(240, 200, 255)
            }):Play()
            task.wait(0.5)
            if not state.uiOpen then
                mainFrame.Visible = false
            end
        end
    end
    
    toggleButton.MouseButton1Click:Connect(OnToggleClick)
    
    -- Update anim list canvas size
    animList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        animScroller.CanvasSize = UDim2.new(0, 0, 0, animList.AbsoluteContentSize.Y + 10)
    end)
    
    buttonThemesList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        buttonThemesFrame.CanvasSize = UDim2.new(0, 0, 0, buttonThemesList.AbsoluteContentSize.Y + 10)
    end)
    
    guiThemesList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        guiThemesFrame.CanvasSize = UDim2.new(0, 0, 0, guiThemesList.AbsoluteContentSize.Y + 10)
    end)
    
    return gui
end

-- ====== UI UPDATE ======
function UpdateUI()
    if flyButton and boostButton then
        if state.isFlying then
            flyButton.Text = "UNFLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(120, 40, 60)
            
            if state.boostLevel == 0 then
                boostButton.Text = "BOOST"
                boostButton.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
            elseif state.boostLevel == 1 then
                boostButton.Text = "BOOST 1"
                boostButton.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
            elseif state.boostLevel == 2 then
                boostButton.Text = "BOOST 2"
                boostButton.BackgroundColor3 = Color3.fromRGB(100, 80, 150)
            elseif state.boostLevel == 3 then
                boostButton.Text = "ULTRA"
                boostButton.BackgroundColor3 = Color3.fromRGB(150, 60, 180)
            end
        else
            flyButton.Text = "FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            boostButton.Text = "BOOST"
            boostButton.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
        end
    end
    
    if speedLabel then
        speedLabel.Text = "SPEED: " .. math.floor(state.currentSpeed)
    end
    
    if boostLabel then
        boostLabel.Text = "BOOST: " .. (state.boostLevel == 0 and "OFF" or "LEVEL " .. state.boostLevel)
    end
    
    if statusLabel then
        statusLabel.Text = state.isFlying and "IN FLIGHT" or "GROUNDED"
        statusLabel.TextColor3 = state.isFlying and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(210, 180, 240)
    end
    
    if animLabel then
        animLabel.Text = config.selectedIdle
    end
end

function ToggleUI()
    state.uiOpen = not state.uiOpen
    if state.uiOpen then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -70, 0.5, 0)
        }):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {
            ImageColor3 = Color3.fromRGB(200, 150, 255)
        }):Play()
        UpdateUI()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 400, 0.5, 0)
        }):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {
            ImageColor3 = Color3.fromRGB(240, 200, 255)
        }):Play()
        task.wait(0.5)
        if not state.uiOpen then
            mainFrame.Visible = false
        end
    end
end

-- ====== SETTINGS SAVE/LOAD ======
local SETTINGS_FILE = "MobileFly_Settings.json"

function SaveSettings()
    local data = {
        mobileUIPosition = {
            X = { Scale = config.mobileUIPosition.X.Scale, Offset = config.mobileUIPosition.X.Offset },
            Y = { Scale = config.mobileUIPosition.Y.Scale, Offset = config.mobileUIPosition.Y.Offset }
        },
        toggleButtonPosition = {
            X = { Scale = config.toggleButtonPosition.X.Scale, Offset = config.toggleButtonPosition.X.Offset },
            Y = { Scale = config.toggleButtonPosition.Y.Scale, Offset = config.toggleButtonPosition.Y.Offset }
        },
        hoverHeight = config.hoverHeight,
        hoverSpeed = config.hoverSpeed,
        selectedIdle = config.selectedIdle,
        baseSpeed = config.baseSpeed,
        boostSpeed = config.boostSpeed,
        controlsLocked = config.controlsLocked,
        buttonTheme = config.buttonTheme,
        showArms = config.showArms,
        guiTheme = config.guiTheme,
    }
    
    pcall(function()
        writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
    end)
end

function LoadSettings()
    if not isfile(SETTINGS_FILE) then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(SETTINGS_FILE))
    end)
    
    if not success or type(data) ~= "table" then return end
    
    if data.mobileUIPosition then
        config.mobileUIPosition = UDim2.new(
            data.mobileUIPosition.X.Scale,
            data.mobileUIPosition.X.Offset,
            data.mobileUIPosition.Y.Scale,
            data.mobileUIPosition.Y.Offset
        )
    end
    
    if data.toggleButtonPosition then
        config.toggleButtonPosition = UDim2.new(
            data.toggleButtonPosition.X.Scale,
            data.toggleButtonPosition.X.Offset,
            data.toggleButtonPosition.Y.Scale,
            data.toggleButtonPosition.Y.Offset
        )
    end
    
    if data.hoverHeight then
        config.hoverHeight = math.clamp(data.hoverHeight, 0.5, 2)
    end
    
    if data.hoverSpeed then
        config.hoverSpeed = math.clamp(data.hoverSpeed, 1, 5)
    end
    
    if data.baseSpeed then
        config.baseSpeed = math.clamp(data.baseSpeed, 10, 300)
    end
    
    if data.boostSpeed then
        config.boostSpeed = math.clamp(data.boostSpeed, 10, 600)
    end
    
    if data.selectedIdle and ANIMATIONS[data.selectedIdle] then
        config.selectedIdle = data.selectedIdle
    end
    
    if data.controlsLocked ~= nil then
        config.controlsLocked = data.controlsLocked
    end
    
    if data.buttonTheme then
        config.buttonTheme = data.buttonTheme
    end
    
    if data.guiTheme then
        config.guiTheme = data.guiTheme
    end
    
    if data.showArms ~= nil then
        config.showArms = data.showArms
    end
    
    UpdateSpeed()
    UpdateUI()
end

-- ====== ARMS VISIBILITY ======
local function SetupArmsVisibility()
    RunService.RenderStepped:Connect(function()
        if not config.showArms then return end
        local char = LocalPlayer.Character
        if not char then return end
        
        local parts = {
            "Left Arm", "Right Arm", "LeftHand", "RightHand",
            "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm"
        }
        
        for _, name in ipairs(parts) do
            local part = char:FindFirstChild(name)
            if part then
                part.LocalTransparencyModifier = 0
                for _, child in pairs(part:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = 0
                    elseif child:IsA("MeshPart") then
                        child.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end)
end

-- ====== INITIALIZATION ======
local function Init()
    -- Load settings
    LoadSettings()
    
    -- Create UI
    CreateMobileControls()
    CreateAnimationUI()
    SetupArmsVisibility()
    
    -- Keybind handler
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        
        if input.KeyCode == Enum.KeyCode.X then
            ToggleFly()
        end
        if input.KeyCode == Enum.KeyCode.Q then
            CycleBoost()
        end
        if input.KeyCode == Enum.KeyCode.U then
            ToggleUI()
        end
    end)
    
    -- Character events
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if state.isFlying then
            StartFly(character)
        end
        UpdateUI()
    end)
    
    LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
        if not LocalPlayer.Character then
            StopFly()
        end
    end)
    
    -- Periodic UI update
    RunService.Heartbeat:Connect(function()
        UpdateUI()
    end)
    
    -- Auto-save settings periodically
    local saveTimer = 0
    RunService.Heartbeat:Connect(function(delta)
        saveTimer = saveTimer + delta
        if saveTimer >= 5 then
            saveTimer = 0
            SaveSettings()
        end
    end)
    
    print("Mobile Fly v1.147 loaded!")
    print("Press X to toggle flight, Q to cycle boost, U for UI")
end

-- Start
Init()