-- ==========================================================
-- ⚔️ โมดูลหมวดหมู่ "PVP" (ไฟล์แยก ให้สคริปต์หลักดึงมารัน)
-- ชื่อไฟล์ใน GitHub: modules/pvp.lua
-- สคริปต์หลักเรียกแบบ: loadstring(game:HttpGet(URL))()(ctx)
-- ⚠️ ต้องเรียก "หลัง" fish_sim.lua เสมอ (เพราะไฟล์นั้นจัดลำดับปุ่มซ้ายไว้ก่อน
--    แล้วไฟล์นี้จะแทรกตัวเองต่อท้ายปุ่มปลากั้วจำลอง และดันปุ่มที่เหลือลงไป)
-- ==========================================================
return function(ctx)
    -- รับของที่ต้องใช้จากสคริปต์หลัก
    local SidebarFrame = ctx.SidebarFrame
    local MainFrame = ctx.MainFrame
    local createSwitchButton = ctx.createSwitchButton

    local CatBtn1 = ctx.CatBtn1
    local CatBtnAuto = ctx.CatBtnAuto          -- อาจเป็น nil
    local CatBtnESP = ctx.CatBtnESP            -- อาจเป็น nil
    local CatBtnTp = ctx.CatBtnTp
    local CatBtnInfo = ctx.CatBtnInfo
    local CatBtnSettings = ctx.CatBtnSettings
    local CatBtnCreator = ctx.CatBtnCreator
    -- ปุ่มหมวดของเล่น / ปลากั้วจำลอง (ถ้าสคริปต์หลักไม่ได้ส่งมา ก็หาจากชื่อในแถบซ้าย)
    local CatBtnToy = ctx.CatBtnToy or SidebarFrame:FindFirstChild("CategoryToy")
    local CatBtnFish = ctx.CatBtnFish or SidebarFrame:FindFirstChild("CategoryFishSim")

    -- 1) ปุ่มหมวดหมู่ "PVP" ที่แถบซ้าย
    local CatBtnPvp = Instance.new("TextButton")
    CatBtnPvp.Name = "CategoryPvp"
    CatBtnPvp.Parent = SidebarFrame
    CatBtnPvp.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    CatBtnPvp.Size = UDim2.new(1, 0, 0, 40)
    CatBtnPvp.Font = Enum.Font.GothamBold
    CatBtnPvp.Text = "⚔️ PVP"
    CatBtnPvp.TextColor3 = Color3.fromRGB(255, 255, 255)
    CatBtnPvp.TextSize = 13

    local CatCornerPvp = Instance.new("UICorner")
    CatCornerPvp.CornerRadius = UDim.new(0, 6)
    CatCornerPvp.Parent = CatBtnPvp

    -- 2) จัดลำดับปุ่มซ้าย (แทรกต่อท้ายปลากั้วจำลอง):
    --    ฆ่า+วาป -> ออโต้ -> ESP -> ของเล่น -> ปลากั้วจำลอง -> PVP -> วาป+ฟาม -> ข้อมูล -> ตั้งค่า -> ผู้สร้าง
    CatBtn1.LayoutOrder = 1
    if CatBtnAuto then CatBtnAuto.LayoutOrder = 2 end
    if CatBtnESP then CatBtnESP.LayoutOrder = 3 end
    if CatBtnToy then CatBtnToy.LayoutOrder = 4 end
    if CatBtnFish then CatBtnFish.LayoutOrder = 5 end
    CatBtnPvp.LayoutOrder = 6
    CatBtnTp.LayoutOrder = 7
    CatBtnInfo.LayoutOrder = 8
    CatBtnSettings.LayoutOrder = 9
    CatBtnCreator.LayoutOrder = 10
    SidebarFrame.CanvasSize = UDim2.new(0, 0, 0, 580)

    -- 3) หน้าต่างฝั่งขวาของหมวด PVP
    local PvpContainer = Instance.new("ScrollingFrame")
    PvpContainer.Name = "PvpContainer"
    PvpContainer.Parent = MainFrame
    PvpContainer.BackgroundTransparency = 1
    PvpContainer.Position = UDim2.new(0, 160, 0, 50)
    PvpContainer.Size = UDim2.new(1, -170, 1, -60)
    PvpContainer.CanvasSize = UDim2.new(0, 0, 0, 600)
    PvpContainer.ScrollBarThickness = 6
    PvpContainer.Visible = false

    local PvpContainerLayout = Instance.new("UIListLayout")
    PvpContainerLayout.Parent = PvpContainer
    PvpContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PvpContainerLayout.Padding = UDim.new(0, 8)

    -- ข้อความบอกว่ายังว่าง (หายเองทันทีที่ใส่ปุ่มแรกเข้ามา)
    local PvpEmptyHint = Instance.new("TextLabel")
    PvpEmptyHint.Name = "EmptyHint"
    PvpEmptyHint.Parent = PvpContainer
    PvpEmptyHint.BackgroundTransparency = 1
    PvpEmptyHint.Size = UDim2.new(1, -10, 0, 40)
    PvpEmptyHint.Font = Enum.Font.Gotham
    PvpEmptyHint.Text = "⚔️ หมวด PVP — ยังไม่มีฟังก์ชัน"
    PvpEmptyHint.TextColor3 = Color3.fromRGB(180, 180, 190)
    PvpEmptyHint.TextSize = 14

    PvpContainer.ChildAdded:Connect(function(child)
        if child ~= PvpEmptyHint and not child:IsA("UIListLayout") then
            PvpEmptyHint.Visible = false
        end
    end)

    -- 4) ระบบกดสลับหน้าต่าง
    -- กดปุ่ม PVP -> ซ่อนทุกหน้า (รวมหน้าของเล่น และปลากั้วจำลอง) แล้วโชว์หน้านี้
    CatBtnPvp.MouseButton1Click:Connect(function()
        ctx.ContentContainer.Visible = false
        ctx.TeleportContainer.Visible = false
        ctx.InfoContainer.Visible = false
        ctx.SettingsContainer.Visible = false
        ctx.CreatorContainer.Visible = false
        if ctx.AutoContainer then ctx.AutoContainer.Visible = false end
        if ctx.ESPContainer then ctx.ESPContainer.Visible = false end
        local toyPage = ctx.ToyContainer or MainFrame:FindFirstChild("ToyContainer")
        if toyPage then toyPage.Visible = false end
        local fishPage = ctx.FishContainer or MainFrame:FindFirstChild("FishContainer")
        if fishPage then fishPage.Visible = false end
        PvpContainer.Visible = true
    end)

    -- กดหมวดอื่น (รวมของเล่น และปลากั้วจำลอง) -> ซ่อนหน้า PVP
    local otherButtons = { CatBtn1, CatBtnTp, CatBtnInfo, CatBtnSettings, CatBtnCreator }
    if CatBtnAuto then table.insert(otherButtons, CatBtnAuto) end
    if CatBtnESP then table.insert(otherButtons, CatBtnESP) end
    if CatBtnToy then table.insert(otherButtons, CatBtnToy) end
    if CatBtnFish then table.insert(otherButtons, CatBtnFish) end
    for _, btn in ipairs(otherButtons) do
        btn.MouseButton1Click:Connect(function()
            PvpContainer.Visible = false
        end)
    end

    -- ==========================================================
    -- 👇 วางปุ่มฟังก์ชัน PVP ตรงนี้ (ข้างใน return function) โดยใช้ PvpContainer เป็น Parent
    -- ตัวอย่าง:
    -- createSwitchButton(PvpContainer, "⚔️ ชื่อฟังก์ชัน", false, function(isActive)
    --     -- โค้ด
    -- end)
    -- ==========================================================



                
-- ==========================================================
-- 🎯 ฟังก์ชันเดี่ยว: เอมบอดผู้เล่นใกล้สุด (ไม่มีส่วนของหมวดหมู่ปนอยู่)
-- วางไว้ "ใต้" ตัวแปร PvpContainer (ในไฟล์ pvp.lua ตรงจุดที่เว้นไว้ให้วางปุ่ม)
-- โหมดไกล = ล็อกกล้องใส่หัวผู้เล่นใกล้สุดทุกเฟรม + ดักเมาส์ให้ชี้ไปที่หัว (ถ้า executor รองรับ)
-- โหมดใกล้ = ฮุกสกิล (Tool / คลิก / ปุ่มสกิล / แอนิเมชันสกิล) แล้ววาร์ปไปหลังเป้าหมายและหันหน้าใส่
-- ลบทั้งบล็อกนี้ทิ้งได้เลย ส่วนอื่นไม่พัง
-- ==========================================================
do
    local function createEmbedPlayer(parent)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local lp = Players.LocalPlayer

        -- ค่าปรับแต่ง
        local TEAM_CHECK = true     -- ไม่ล็อกเพื่อนร่วมทีม
        local AIM_PART = "Head"     -- ส่วนที่เล็ง (ไม่เจอจะใช้ HumanoidRootPart)
        local AIM_SMOOTH = 1        -- 1 = ล็อกแน่นทุกเฟรม, น้อยลง = นุ่มลง (เช่น 0.3)
        local PREDICT = 0.05        -- เล็งนำหน้าเป้าที่กำลังวิ่ง (วินาที) 0 = ปิด
        local TP_BEHIND = 3         -- ระยะที่วาร์ปไปอยู่หลังเป้าหมาย
        local STICK_TIME = 0.8      -- ตามติด+หันหน้าใส่เป้าหมายหลังฮุกสกิลกี่วินาที (โหมดใกล้)
        local SKILL_COOLDOWN = 0.12 -- กันฮุกซ้ำหลายทางพร้อมกัน
        local RETREAT_MODE = true    -- ตีเสร็จแล้ววาร์ปกลับจุดเดิม
        local RETREAT_ON_HIT = true  -- โดนตีกลับระหว่างอยู่ใกล้เป้าหมาย -> ถอยทันที

        getgenv().EmbedPlayer_Active = false
        getgenv().EmbedPlayer_AimPart = nil
        getgenv().EmbedPlayer_AimPos = nil

        local mode = "far"          -- "far" = ไกล, "near" = ใกล้
        local toolConns = {}
        local conns = {}
        local stickUntil, stickTarget = 0, nil
        local lastSkill = 0
        local originCF = nil         -- จุดที่เรายืนก่อนวาร์ปเข้าไปตี

        local SKILL_KEYS = {}
        for _, k in ipairs({
            Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.F, Enum.KeyCode.Z,
            Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.G, Enum.KeyCode.T,
            Enum.KeyCode.Y, Enum.KeyCode.H, Enum.KeyCode.B, Enum.KeyCode.N,
        }) do
            SKILL_KEYS[k] = true
        end

        -- หาผู้เล่นที่อยู่ใกล้เราที่สุด
        local function nearestPlayer()
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return nil end
            local best, bestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    local sameTeam = TEAM_CHECK and p.Team ~= nil and p.Team == lp.Team
                    if hum and r and hum.Health > 0 and not sameTeam then
                        local d = (r.Position - root.Position).Magnitude
                        if d < bestDist then
                            best, bestDist = p, d
                        end
                    end
                end
            end
            return best
        end

        -- วาร์ปไปหลังเป้าหมาย + หันหน้าใส่
        local function teleportBehind(root, targetRoot)
            local pos = (targetRoot.CFrame * CFrame.new(0, 0, TP_BEHIND)).Position
            root.CFrame = CFrame.lookAt(pos, Vector3.new(targetRoot.Position.X, pos.Y, targetRoot.Position.Z))
            root.AssemblyLinearVelocity = Vector3.zero
        end



                    local function retreat()
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and originCF then
                root.CFrame = originCF
                root.AssemblyLinearVelocity = Vector3.zero
            end
            originCF = nil
            stickTarget = nil
            stickUntil = 0
            end


            
        -- โหมดใกล้: ถูกเรียกเมื่อฮุกเจอว่าเรากำลังใช้สกิล
        local function onSkill()
            if not getgenv().EmbedPlayer_Active or mode ~= "near" then return end
            local now = os.clock()
            if now - lastSkill < SKILL_COOLDOWN then return end
            lastSkill = now

            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local target = nearestPlayer()
            local tr = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not (root and tr) then return end
        if not originCF then originCF = root.CFrame end
            stickTarget = target
            stickUntil = now + STICK_TIME
            teleportBehind(root, tr)
        end

        -- ทำงานทุกเฟรม (หลังกล้องอัปเดต)
        local function onFrame()
            if not getgenv().EmbedPlayer_Active then return end
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if mode == "far" then
                -- ล็อกกล้องใส่เป้าหมายใกล้สุดทุกเฟรม
                local target = nearestPlayer()
                local tchar = target and target.Character
                local part = tchar and (tchar:FindFirstChild(AIM_PART) or tchar:FindFirstChild("HumanoidRootPart"))
                local cam = workspace.CurrentCamera
                if part and cam then
                    local pos = part.Position + part.AssemblyLinearVelocity * PREDICT
                    getgenv().EmbedPlayer_AimPart = part
                    getgenv().EmbedPlayer_AimPos = pos
                    local goal = CFrame.lookAt(cam.CFrame.Position, pos)
                    cam.CFrame = (AIM_SMOOTH >= 1) and goal or cam.CFrame:Lerp(goal, AIM_SMOOTH)
                else
                    getgenv().EmbedPlayer_AimPart = nil
                end
            else
                getgenv().EmbedPlayer_AimPart = nil
                -- โหมดใกล้: ตามติด+หันหน้าใส่เป้าหมายช่วงสั้นๆ หลังฮุกสกิล
                local tp = stickTarget
                local tr = tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart")
                if os.clock() < stickUntil and tr then
                    teleportBehind(root, tr)
                                elseif stickTarget then
                    if RETREAT_MODE then
                        retreat()
                    else
                        stickTarget = nil
                        originCF = nil
                        end
                end
            end
        end

        -- ดักเมาส์ (Hit/Target/UnitRay) ให้ชี้ไปที่หัวเป้าหมาย (ติดตั้งครั้งเดียวต่อเซสชัน)
        local function installSilentAim()
            if getgenv().EmbedPlayer_HookInstalled then return end
            if not (hookmetamethod and newcclosure and checkcaller) then return end
            local mouse = lp:GetMouse()
            local ok = pcall(function()
                local old
                old = hookmetamethod(game, "__index", newcclosure(function(self, key)
                    local part = getgenv().EmbedPlayer_AimPart
                    if part and self == mouse and not checkcaller() then
                        local pos = getgenv().EmbedPlayer_AimPos
                        if pos then
                            if key == "Hit" then
                                return CFrame.new(pos)
                            elseif key == "Target" then
                                return part
                            elseif key == "UnitRay" then
                                local origin = workspace.CurrentCamera.CFrame.Position
                                return Ray.new(origin, (pos - origin).Unit)
                            end
                        end
                    end
                    return old(self, key)
                end))
            end)
            if ok then
                getgenv().EmbedPlayer_HookInstalled = true
            end
        end

        -- ฮุกสกิลทางที่ 1: Tool.Activated
        local function hookTool(tool)
            if toolConns[tool] then return end
            toolConns[tool] = tool.Activated:Connect(onSkill)
        end

        local function hookCharacter(char)
            for _, c in ipairs(char:GetChildren()) do
                if c:IsA("Tool") then hookTool(c) end
            end
            table.insert(conns, char.ChildAdded:Connect(function(c)
                if c:IsA("Tool") then hookTool(c) end
            end))

            -- ฮุกสกิลทางที่ 3: ตัวละครเริ่มเล่นแอนิเมชันสกิล (Priority Action ขึ้นไป)
             task.spawn(function()
                local hum = char:WaitForChild("Humanoid", 5)
                if hum then
                    local last = hum.Health
                    table.insert(conns, hum.HealthChanged:Connect(function(h)
                        if RETREAT_ON_HIT and stickTarget and h < last then
                            retreat()
                        end
                        last = h
                    end))
                end
                local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5))
                -- ...ส่วน animator เดิมต่อด้านล่างเหมือนเดิม
                if animator then
                    table.insert(conns, animator.AnimationPlayed:Connect(function(track)
                        local pr = track.Priority
                        if pr ~= Enum.AnimationPriority.Core and pr.Value >= Enum.AnimationPriority.Action.Value then
                            onSkill()
                        end
                    end))
                end
            end)
        end

        -- ฮุกสกิลทางที่ 2: คลิกซ้าย / ปุ่มสกิลบนคีย์บอร์ด
        local function onInput(input, processed)
            if processed or UserInputService:GetFocusedTextBox() then return end
            local t = input.UserInputType
            if t == Enum.UserInputType.MouseButton1
                or (t == Enum.UserInputType.Keyboard and SKILL_KEYS[input.KeyCode]) then
                onSkill()
            end
        end

        local function stop()
            pcall(function() RunService:UnbindFromRenderStep("EmbedPlayerAim") end)
            for _, c in ipairs(conns) do c:Disconnect() end
            conns = {}
            for _, c in pairs(toolConns) do c:Disconnect() end
            toolConns = {}
            stickTarget = nil
            originCF = nil
            getgenv().EmbedPlayer_AimPart = nil
            getgenv().EmbedPlayer_AimPos = nil
        end

        local function start()
            stop()
            installSilentAim()
            if lp.Character then hookCharacter(lp.Character) end
            table.insert(conns, lp.CharacterAdded:Connect(hookCharacter))
            table.insert(conns, UserInputService.InputBegan:Connect(onInput))
            RunService:BindToRenderStep("EmbedPlayerAim", Enum.RenderPriority.Camera.Value + 1, onFrame)
        end

        -- ล้างตอนรันสคริปต์ซ้ำ
        local prevCleanup = getgenv().MainScript_Cleanup
        getgenv().MainScript_Cleanup = function()
            getgenv().EmbedPlayer_Active = false
            stop()
            if prevCleanup then prevCleanup() end
        end

        -- ---------- ปุ่มเปิด/ปิด ----------
        local switch = createSwitchButton(parent, "🎯 เอมบอดใกล้สุด", false, function(isActive)
            getgenv().EmbedPlayer_Active = isActive
            if isActive then
                start()
            else
                stop()
            end
        end)
        switch.LayoutOrder = 1

        -- ---------- แคปซูลเลือกโหมด ไกล / ใกล้ ----------
        local function styleCapsule(obj)
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = obj
            local stroke = Instance.new("UIStroke")
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- ตีขอบกรอบ ไม่ตีขอบตัวหนังสือ
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 2
            stroke.Parent = obj
        end

        local Capsule = Instance.new("Frame")
        Capsule.Parent = parent
        Capsule.LayoutOrder = 2
        Capsule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Capsule.Size = UDim2.new(1, 0, 0, 45)
        styleCapsule(Capsule)

        local ModeTitle = Instance.new("TextLabel")
        ModeTitle.Parent = Capsule
        ModeTitle.BackgroundTransparency = 1
        ModeTitle.Position = UDim2.new(0, 15, 0, 0)
        ModeTitle.Size = UDim2.new(1, -150, 1, 0)
        ModeTitle.Font = Enum.Font.GothamBold
        ModeTitle.Text = "🎯 โหมด"
        ModeTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
        ModeTitle.TextSize = 13
        ModeTitle.TextXAlignment = Enum.TextXAlignment.Left

        local function createModeButton(xOffset, text)
            local btn = Instance.new("TextButton")
            btn.Parent = Capsule
            btn.Position = UDim2.new(1, xOffset, 0.5, -16)
            btn.Size = UDim2.new(0, 58, 0, 32)
            btn.Font = Enum.Font.GothamBold
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            btn.TextSize = 12
            styleCapsule(btn)
            return btn
        end

        local FarBtn = createModeButton(-131, "🔫 ไกล")
        local NearBtn = createModeButton(-69, "⚔️ ใกล้")

        local function updateModeVisual()
            FarBtn.BackgroundColor3 = (mode == "far") and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(235, 235, 235)
            NearBtn.BackgroundColor3 = (mode == "near") and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(235, 235, 235)
        end
        updateModeVisual()

        FarBtn.MouseButton1Click:Connect(function()
            mode = "far"
            stickTarget = nil
            updateModeVisual()
        end)
        NearBtn.MouseButton1Click:Connect(function()
            mode = "near"
            getgenv().EmbedPlayer_AimPart = nil
            updateModeVisual()
        end)

        return switch
    end

    -- ห่อ pcall: ถ้าบล็อกนี้พัง ปุ่มอื่นในหมวดยังอยู่ครบ
    local ok, err = pcall(createEmbedPlayer, PvpContainer)
    if not ok then warn("[เอมบอด] error: " .. tostring(err)) end
    end


    return { Container = PvpContainer, Button = CatBtnPvp }
end
