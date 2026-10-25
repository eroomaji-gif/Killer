-- ==========================================================
-- 🧸 โมดูลหมวดหมู่ "ของเล่น" (ไฟล์แยก ให้สคริปต์หลักดึงมารัน)
-- ชื่อไฟล์ใน GitHub: modules/toys.lua
-- สคริปต์หลักเรียกแบบ: loadstring(game:HttpGet(URL))()(ctx)
-- ==========================================================
return function(ctx)
    -- รับของที่ต้องใช้จากสคริปต์หลัก (ตัวแปร local ของสคริปต์หลักมองเห็นจากไฟล์นี้ไม่ได้)
    local SidebarFrame = ctx.SidebarFrame
    local MainFrame = ctx.MainFrame
    local createSwitchButton = ctx.createSwitchButton

    local CatBtn1 = ctx.CatBtn1
    local CatBtnAuto = ctx.CatBtnAuto          -- อาจเป็น nil ถ้าไม่มีหมวดนี้
    local CatBtnESP = ctx.CatBtnESP            -- อาจเป็น nil
    local CatBtnTp = ctx.CatBtnTp
    local CatBtnInfo = ctx.CatBtnInfo
    local CatBtnSettings = ctx.CatBtnSettings
    local CatBtnCreator = ctx.CatBtnCreator

    -- 1) ปุ่มหมวดหมู่ "ของเล่น" ที่แถบซ้าย
    local CatBtnToy = Instance.new("TextButton")
    CatBtnToy.Name = "CategoryToy"
    CatBtnToy.Parent = SidebarFrame
    CatBtnToy.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    CatBtnToy.Size = UDim2.new(1, 0, 0, 40)
    CatBtnToy.Font = Enum.Font.GothamBold
    CatBtnToy.Text = "🧸 ของเล่น"
    CatBtnToy.TextColor3 = Color3.fromRGB(255, 255, 255)
    CatBtnToy.TextSize = 13

    local CatCornerToy = Instance.new("UICorner")
    CatCornerToy.CornerRadius = UDim.new(0, 6)
    CatCornerToy.Parent = CatBtnToy

    -- 2) จัดลำดับปุ่มซ้าย: ฆ่า+วาป -> ออโต้ -> ESP -> ของเล่น -> วาป+ฟาม -> ข้อมูล -> ตั้งค่า -> ผู้สร้าง
    CatBtn1.LayoutOrder = 1
    if CatBtnAuto then CatBtnAuto.LayoutOrder = 2 end
    if CatBtnESP then CatBtnESP.LayoutOrder = 3 end
    CatBtnToy.LayoutOrder = 4
    CatBtnTp.LayoutOrder = 5
    CatBtnInfo.LayoutOrder = 6
    CatBtnSettings.LayoutOrder = 7
    CatBtnCreator.LayoutOrder = 8
    SidebarFrame.CanvasSize = UDim2.new(0, 0, 0, 480)

    -- 3) หน้าต่างฝั่งขวาของหมวดของเล่น
    local ToyContainer = Instance.new("ScrollingFrame")
    ToyContainer.Name = "ToyContainer"
    ToyContainer.Parent = MainFrame
    ToyContainer.BackgroundTransparency = 1
    ToyContainer.Position = UDim2.new(0, 160, 0, 50)
    ToyContainer.Size = UDim2.new(1, -170, 1, -60)
    ToyContainer.CanvasSize = UDim2.new(0, 0, 0, 600)
    ToyContainer.ScrollBarThickness = 6
    ToyContainer.Visible = false

    local ToyContainerLayout = Instance.new("UIListLayout")
    ToyContainerLayout.Parent = ToyContainer
    ToyContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ToyContainerLayout.Padding = UDim.new(0, 8)

    -- ข้อความบอกว่ายังว่าง (หายเองทันทีที่ใส่ปุ่มแรกเข้ามา)
    local ToyEmptyHint = Instance.new("TextLabel")
    ToyEmptyHint.Name = "EmptyHint"
    ToyEmptyHint.Parent = ToyContainer
    ToyEmptyHint.BackgroundTransparency = 1
    ToyEmptyHint.Size = UDim2.new(1, -10, 0, 40)
    ToyEmptyHint.Font = Enum.Font.Gotham
    ToyEmptyHint.Text = "🧸 หมวดของเล่น — ยังไม่มีฟังก์ชัน"
    ToyEmptyHint.TextColor3 = Color3.fromRGB(180, 180, 190)
    ToyEmptyHint.TextSize = 14

    ToyContainer.ChildAdded:Connect(function(child)
        if child ~= ToyEmptyHint and not child:IsA("UIListLayout") then
            ToyEmptyHint.Visible = false
        end
    end)

    -- 4) ระบบกดสลับหน้าต่าง
    -- กดปุ่มของเล่น -> ซ่อนทุกหน้า แล้วโชว์หน้าของเล่น
    CatBtnToy.MouseButton1Click:Connect(function()
        ctx.ContentContainer.Visible = false
        ctx.TeleportContainer.Visible = false
        ctx.InfoContainer.Visible = false
        ctx.SettingsContainer.Visible = false
        ctx.CreatorContainer.Visible = false
        if ctx.AutoContainer then ctx.AutoContainer.Visible = false end
        if ctx.ESPContainer then ctx.ESPContainer.Visible = false end
        ToyContainer.Visible = true
    end)

    -- กดหมวดอื่น -> ซ่อนหน้าของเล่น
    local otherButtons = { CatBtn1, CatBtnTp, CatBtnInfo, CatBtnSettings, CatBtnCreator }
    if CatBtnAuto then table.insert(otherButtons, CatBtnAuto) end
    if CatBtnESP then table.insert(otherButtons, CatBtnESP) end
    for _, btn in ipairs(otherButtons) do
        btn.MouseButton1Click:Connect(function()
            ToyContainer.Visible = false
        end)
    end

    -- ==========================================================
    -- 👇 วางปุ่มฟังก์ชันของเล่นตรงนี้ (ข้างใน return function) โดยใช้ ToyContainer เป็น Parent
    -- ตัวอย่าง:
    -- createSwitchButton(ToyContainer, "🧸 ชื่อฟังก์ชัน", false, function(isActive)
    --     -- โค้ด
    -- end)
    -- ==========================================================

    






-- ==========================================================
-- 🌀 ฟังก์ชันเดี่ยว: แม่เหล็กไอเทมโคจร (ไม่มีส่วนของหมวดหมู่ปนอยู่)
-- วางไว้ "ใต้" ตัวแปร ToyContainer (ในไฟล์ toys.lua หรือที่ไหนก็ได้ที่มี ToyContainer กับ createSwitchButton)
-- ลบทั้งบล็อกนี้ทิ้งได้เลย ส่วนอื่นไม่พัง
-- ==========================================================
do
    -- ==========================================================
    -- 🌀 ของเล่นที่ 1: แม่เหล็กดูดไอเทมอิสระมาหมุนวนรอบตัว
    -- ควบคุมฟิสิกส์ของ "ชิ้นส่วนที่ไม่ได้ถูกตรึง" รอบตัว (ของที่ตกอยู่ ไอเทมที่หยิบได้ ฯลฯ)
    -- ผู้เล่นอื่นจะเห็นด้วย เฉพาะกรณีที่เกมปล่อยให้ไคลเอนต์เราเป็นเจ้าของฟิสิกส์ชิ้นนั้น
    -- ==========================================================
    local function createOrbitSwitch(parent)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local lp = Players.LocalPlayer

        local SCAN_RADIUS = 80       -- หาของในระยะกี่ studs รอบตัว
        local ORBIT_RADIUS = 9       -- รัศมีวงโคจร
        local ORBIT_SPEED = 1.6      -- ความเร็วหมุน (เรเดียนต่อวินาที)
        local MAX_PARTS = 24         -- จำนวนชิ้นสูงสุดที่ควบคุม (เยอะไป = หน่วง)
        local MAX_PART_SIZE = 15     -- ข้ามชิ้นที่ใหญ่เกินนี้ (เช่น กำแพง รถ)
        local RESCAN = 1.5           -- สแกนหาของใหม่ทุกกี่วินาที (ยิ่งนานยิ่งเบา)
        local MAX_SPEED = 120        -- จำกัดความเร็วชิ้นส่วน กันกระชากหรือพุ่งไปชนคน

        getgenv().Orbit_Active = false

        local controlled = {}  -- [part] = ค่า CanCollide เดิม
        local list = {}
        local conn
        local lastScan, lastRadius = 0, 0

        local function isFreeItem(part)
            if not part:IsA("BasePart") or part:IsA("Terrain") then return false end
            if part.Anchored then return false end
            local root = part.AssemblyRootPart
            if root and root.Anchored then return false end -- ติดอยู่กับของที่ตรึงไว้
            if part.Size.Magnitude > MAX_PART_SIZE then return false end

            -- ข้ามทุกอย่างที่เป็นส่วนของตัวละคร (เรา ผู้เล่นอื่น NPC) รวมถึงของที่ถืออยู่
            local model = part:FindFirstAncestorOfClass("Model")
            while model do
                if model:FindFirstChildOfClass("Humanoid") then return false end
                model = model:FindFirstAncestorOfClass("Model")
            end
            return true
        end

        local function boostSimulation()
            -- ขยายรัศมีที่ไคลเอนต์เราคำนวณฟิสิกส์เอง (จำเป็นต่อการคุมชิ้นส่วน)
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(lp, "SimulationRadius", 1e9)
                end
                lp.MaximumSimulationRadius = 1e9
            end)
        end

        local function scan(rootPos, character)
            local params = OverlapParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = { character }

            local found = {}
            for _, p in ipairs(workspace:GetPartBoundsInRadius(rootPos, SCAN_RADIUS, params)) do
                if isFreeItem(p) then
                    table.insert(found, p)
                end
            end
            table.sort(found, function(a, b)
                return (a.Position - rootPos).Magnitude < (b.Position - rootPos).Magnitude
            end)

            local keep = {}
            list = {}
            for i = 1, math.min(#found, MAX_PARTS) do
                local p = found[i]
                keep[p] = true
                table.insert(list, p)
                if controlled[p] == nil then
                    controlled[p] = p.CanCollide
                    p.CanCollide = false -- ไม่ให้ชิ้นส่วนที่หมุนไปชน/กระเด็นใส่คนอื่น
                end
            end

            -- ชิ้นที่หลุดจากรายการ คืนค่าให้
            for p, original in pairs(controlled) do
                if not keep[p] then
                    if p.Parent then p.CanCollide = original end
                    controlled[p] = nil
                end
            end
        end

        local function start()
            boostSimulation()
            lastScan = 0
            conn = RunService.Heartbeat:Connect(function()
                local character = lp.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then return end

                local now = os.clock()
                if now - lastRadius > 1 then
                    lastRadius = now
                    boostSimulation()
                end
                if now - lastScan > RESCAN then
                    lastScan = now
                    scan(root.Position, character)
                end

                local n = #list
                for i, part in ipairs(list) do
                    if part.Parent then
                        local angle = now * ORBIT_SPEED + (i / n) * math.pi * 2
                        local height = 1 + math.sin(now * 2 + i) * 1.5
                        local target = root.Position + Vector3.new(
                            math.cos(angle) * ORBIT_RADIUS, height, math.sin(angle) * ORBIT_RADIUS)

                        local vel = (target - part.Position) * 12
                        if vel.Magnitude > MAX_SPEED then
                            vel = vel.Unit * MAX_SPEED
                        end
                        part.AssemblyLinearVelocity = vel
                        part.AssemblyAngularVelocity = Vector3.new(2, 4, 2)
                    end
                end
            end)
        end

        local function stop()
            if conn then
                conn:Disconnect()
                conn = nil
            end
            for p, original in pairs(controlled) do
                if p.Parent then
                    p.CanCollide = original
                    p.AssemblyLinearVelocity = Vector3.zero
                    p.AssemblyAngularVelocity = Vector3.zero
                end
            end
            controlled = {}
            list = {}
        end

        -- ล้างตอนรันสคริปต์ซ้ำ
        local prevCleanup = getgenv().MainScript_Cleanup
        getgenv().MainScript_Cleanup = function()
            getgenv().Orbit_Active = false
            stop()
            if prevCleanup then prevCleanup() end
        end

        return createSwitchButton(parent, "🌀 แม่เหล็กไอเทมโคจร", false, function(isActive)
            getgenv().Orbit_Active = isActive
            if isActive then
                start()
            else
                stop()
            end
        end)
    end

    createOrbitSwitch(ToyContainer)
end







    
do
    -- ==========================================================
    -- 👥 ของเล่นที่ 2: ดึงโมเดลมาเดินตามเป็นแถวยาว (ตัวละครจริง มีแอนิเมชัน)
    -- ใช้ ToyContainer เป็น Parent / ลบทั้งบล็อกนี้ได้ ส่วนอื่นไม่พัง
    -- ==========================================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer

    local MAX_CLONES = 20
    local FOLLOW_DIST = 4.5     -- ระยะที่แต่ละตัวหยุดห่างจากตัวข้างหน้า
    local TELEPORT_DIST = 70    -- ไกลเกินนี้ (เช่นเราวาป) ให้วาร์ปตามมา
    local AI_INTERVAL = 0.1     -- คิดทางเดินทุกกี่วินาที
    local JUMP_DELAY = 0.15     -- กระโดดตามตัวข้างหน้าช้ากี่วินาที

    -- แอนิเมชันสำรอง (ใช้เมื่อไม่มี Animate ของเรา หรือ rig ไม่ตรงกัน)
    local DEFAULT_ANIMS = {
        R15 = { idle = "rbxassetid://507766666", walk = "rbxassetid://507777826",
                jump = "rbxassetid://507765000", fall = "rbxassetid://507767968",
                climb = "rbxassetid://507765644", sit = "rbxassetid://507768133" },
        R6 = { idle = "rbxassetid://180435571", walk = "rbxassetid://180426354",
               jump = "rbxassetid://125750702", fall = "rbxassetid://180436148",
               climb = "rbxassetid://180436334", sit = "rbxassetid://178130996" },
    }
    local COLLIDE_NAMES = { "HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso" }

    local clones = {}
    local conn
    local summonId = 0
    local acc, emoteAcc = 0, 0
    local emoteSet, coreKeys = {}, {}
    local cachedChar

    -- ---------- UI (สไตล์แคปซูลเดียวกับ createSwitchButton) ----------
    -- หมายเหตุ: UIStroke ที่อยู่ใน TextBox/TextButton จะไปตีขอบ "ตัวหนังสือ" (เลยดูเหมือนมีแสง)
    -- จึงตั้ง ApplyStrokeMode = Border ให้ตีขอบกรอบแทน
    local function styleCapsule(obj)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = obj
        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 2
        stroke.Parent = obj
    end

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = ToyContainer
    TitleLabel.LayoutOrder = 10
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -10, 0, 24)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "👥 ดึงโมเดลมาเดินตาม"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- แถว 1: แคปซูลช่องชื่อผู้เล่น
    local NameCapsule = Instance.new("Frame")
    NameCapsule.Parent = ToyContainer
    NameCapsule.LayoutOrder = 11
    NameCapsule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameCapsule.Size = UDim2.new(1, 0, 0, 45)
    styleCapsule(NameCapsule)

    local NameBox = Instance.new("TextBox")
    NameBox.Parent = NameCapsule
    NameBox.BackgroundTransparency = 1
    NameBox.Position = UDim2.new(0, 15, 0, 0)
    NameBox.Size = UDim2.new(1, -30, 1, 0)
    NameBox.Font = Enum.Font.GothamBold
    NameBox.PlaceholderText = "👤 ชื่อผู้เล่น (เว้นว่าง = ตัวเรา)"
    NameBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
    NameBox.Text = ""
    NameBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    NameBox.TextSize = 14
    NameBox.TextXAlignment = Enum.TextXAlignment.Left
    NameBox.ClearTextOnFocus = false

    -- แถว 2: แคปซูล "จำนวน" (ช่องตัวเลขอยู่ในแคปซูล) + ปุ่มซัมมอน/ลบอยู่ข้างๆ
    local Row = Instance.new("Frame")
    Row.Parent = ToyContainer
    Row.LayoutOrder = 12
    Row.BackgroundTransparency = 1
    Row.Size = UDim2.new(1, 0, 0, 45)

    local CountCapsule = Instance.new("Frame")
    CountCapsule.Parent = Row
    CountCapsule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CountCapsule.Size = UDim2.new(1, -106, 1, 0)
    styleCapsule(CountCapsule)

    local CountTitle = Instance.new("TextLabel")
    CountTitle.Parent = CountCapsule
    CountTitle.BackgroundTransparency = 1
    CountTitle.Position = UDim2.new(0, 15, 0, 0)
    CountTitle.Size = UDim2.new(1, -75, 1, 0)
    CountTitle.Font = Enum.Font.GothamBold
    CountTitle.Text = "👥 จำนวน"
    CountTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
    CountTitle.TextSize = 14
    CountTitle.TextXAlignment = Enum.TextXAlignment.Left

    local CountTrack = Instance.new("Frame")
    CountTrack.Parent = CountCapsule
    CountTrack.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    CountTrack.Position = UDim2.new(1, -57, 0.5, -16)
    CountTrack.Size = UDim2.new(0, 44, 0, 32)
    styleCapsule(CountTrack)

    local CountBox = Instance.new("TextBox")
    CountBox.Parent = CountTrack
    CountBox.BackgroundTransparency = 1
    CountBox.Size = UDim2.new(1, 0, 1, 0)
    CountBox.Font = Enum.Font.GothamBold
    CountBox.Text = "1"
    CountBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    CountBox.TextSize = 14
    CountBox.ClearTextOnFocus = false

    -- รับเฉพาะตัวเลข (สูงสุด 2 หลัก)
    CountBox:GetPropertyChangedSignal("Text"):Connect(function()
        local filtered = string.sub((CountBox.Text:gsub("%D", "")), 1, 2)
        if filtered ~= CountBox.Text then
            CountBox.Text = filtered
        end
    end)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = ToyContainer
    StatusLabel.LayoutOrder = 15
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, -10, 0, 24)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    StatusLabel.TextSize = 13
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function setStatus(text)
        StatusLabel.Text = text
    end

    local function createRoundButton(parent, xOffset, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.BackgroundColor3 = color
        btn.Position = UDim2.new(1, xOffset, 0, 0)
        btn.Size = UDim2.new(0, 45, 0, 45)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextSize = 20
        styleCapsule(btn)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- ---------- ชนกันไม่ได้ (กันโมเดลดันตัวเรา/ดันกันเอง) ----------
    local function collidables(model)
        local list = {}
        for _, n in ipairs(COLLIDE_NAMES) do
            local p = model:FindFirstChild(n)
            if p and p:IsA("BasePart") then
                table.insert(list, p)
            end
        end
        return list
    end

    local function noCollide(modelA, modelB, holder)
        for _, a in ipairs(collidables(modelA)) do
            for _, b in ipairs(collidables(modelB)) do
                local c = Instance.new("NoCollisionConstraint")
                c.Part0 = a
                c.Part1 = b
                c.Parent = holder
            end
        end
    end

    -- ---------- ดึงโมเดล ----------
    local function findPlayer(name)
        local lower = string.lower(name)
        for _, p in ipairs(Players:GetPlayers()) do
            if string.lower(p.Name) == lower or string.lower(p.DisplayName) == lower then
                return p
            end
        end
    end

    local function prepare(model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("LuaSourceContainer") or d:IsA("Tool") or d:IsA("ForceField") then
                d:Destroy()
            end
        end
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then
                d.CanTouch = false
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            hum.BreakJointsOnDeath = false
        end
    end

    local function getTemplate(name)
        local model

        -- 1) ผู้เล่นที่อยู่ในเซิร์ฟเวอร์ (รวมตัวเราเอง) -> ก๊อปตัวละครจริง
        local p = findPlayer(name)
        if p and p.Character then
            local src = p.Character
            src.Archivable = true
            for _, d in ipairs(src:GetDescendants()) do
                pcall(function() d.Archivable = true end)
            end
            model = src:Clone()
        end

        -- 2) ไม่อยู่ในเซิร์ฟเวอร์ -> สร้างจากบัญชี Roblox ตามชื่อ
        if not model then
            local ok, userId = pcall(function()
                return Players:GetUserIdFromNameAsync(name)
            end)
            if not ok or not userId then
                return nil, "ไม่พบชื่อผู้เล่นนี้"
            end
            local ok2, built = pcall(function()
                return Players:CreateHumanoidModelFromUserId(userId)
            end)
            if not ok2 or not built then
                return nil, "ดึงโมเดลจากบัญชีไม่สำเร็จ"
            end
            model = built
        end

        prepare(model)
        if not model:FindFirstChild("HumanoidRootPart") or not model:FindFirstChildOfClass("Humanoid") then
            model:Destroy()
            return nil, "โมเดลนี้ใช้ไม่ได้"
        end
        return model
    end

    -- ---------- แอนิเมชัน (อ่านจาก Animate ของตัวเรา) ----------
    local function ownAnimIds()
        local char = lp.Character
        local animate = char and char:FindFirstChild("Animate")
        if not animate then return nil end
        local function get(folder, child)
            local f = animate:FindFirstChild(folder)
            if not f then return nil end
            local a = (child and f:FindFirstChild(child)) or f:FindFirstChildOfClass("Animation")
            return a and a.AnimationId
        end
        return {
            idle = get("idle", "Animation1"), walk = get("walk", "WalkAnim"),
            jump = get("jump", "JumpAnim"), fall = get("fall", "FallAnim"),
            climb = get("climb", "ClimbAnim"), sit = get("sit", "SitAnim"),
        }
    end

    local function buildIds(rigType)
        local rig = (rigType == Enum.HumanoidRigType.R6) and "R6" or "R15"
        local ids = {}
        for k, v in pairs(DEFAULT_ANIMS[rig]) do ids[k] = v end
        local myHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if myHum and myHum.RigType == rigType then
            local own = ownAnimIds()
            if own then
                for k, v in pairs(own) do
                    if v and v ~= "" then ids[k] = v end
                end
            end
        end
        return ids
    end

    local function playTrack(c, name, scale)
        local track = c.tracks[name]
        if not track then return end
        if c.curName ~= name then
            if c.cur then c.cur:Stop(0.2) end
            c.cur = track
            c.curName = name
            track:Play(0.2)
        end
        if name == "walk" then
            track:AdjustSpeed(scale)
        end
    end

    -- ท่าอีโมทที่ตัวเรากำลังเล่นตอนยืนนิ่ง -> ให้โมเดลที่ยืนอยู่เล่นตาม
    local function syncEmotes(c, idle)
        for key, id in pairs(emoteSet) do
            local t = c.emotes[key]
            if not t then
                local a = Instance.new("Animation")
                a.AnimationId = id
                t = c.animator:LoadAnimation(a)
                c.emotes[key] = t
            end
            if idle then
                if not c.emotePlayed[key] then
                    c.emotePlayed[key] = true
                    t:Play(0.2)
                end
            elseif t.IsPlaying then
                t:Stop(0.2)
            end
        end
        for key, t in pairs(c.emotes) do
            if not emoteSet[key] then
                c.emotePlayed[key] = nil
                if t.IsPlaying then t:Stop(0.2) end
            end
        end
    end

    local function animate(c, dt)
        local hum, root = c.hum, c.root
        local state = hum:GetState()
        local speed = (root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude

        if state == Enum.HumanoidStateType.Freefall then
            c.air = c.air + dt
        else
            c.air = 0
        end

        local name
        if hum.Sit then
            name = "sit"
        elseif state == Enum.HumanoidStateType.Climbing then
            name = "climb"
        elseif state == Enum.HumanoidStateType.Jumping then
            name = "jump"
        elseif state == Enum.HumanoidStateType.Freefall then
            name = (c.air > 0.25) and "fall" or (c.curName or "idle")
        elseif speed > 0.75 then
            name = "walk"
        else
            name = "idle"
        end

        playTrack(c, name, math.clamp(speed / 14.5, 0.5, 2.5))
        syncEmotes(c, name == "idle")
    end

    -- ---------- สมองเดินตาม (แต่ละตัวเดินตามตัวข้างหน้า เป็นแถวยาว) ----------
    local function think(c, i, char, myRoot, myHum)
        local hum, root = c.hum, c.root

        local leaderRoot, leaderHum = myRoot, myHum
        if i > 1 then
            local p = clones[i - 1]
            leaderRoot, leaderHum = p.root, p.hum
        end

        -- ตัวละครเราเกิดใหม่ -> ตั้งค่าไม่ชนกับตัวใหม่
        if c.mineChar ~= char then
            c.mineChar = char
            c.mine:ClearAllChildren()
            noCollide(char, c.model, c.mine)
        end

        -- กระโดดตามตัวข้างหน้า
        if c.wiredTo ~= leaderHum then
            if c.jumpConn then c.jumpConn:Disconnect() end
            c.wiredTo = leaderHum
            c.jumpConn = leaderHum.StateChanged:Connect(function(_, new)
                if new == Enum.HumanoidStateType.Jumping then
                    task.delay(JUMP_DELAY, function()
                        if hum.Parent and root.Parent and leaderRoot.Parent
                            and hum.FloorMaterial ~= Enum.Material.Air
                            and (root.Position - leaderRoot.Position).Magnitude < 15 then
                            hum.Jump = true
                        end
                    end)
                end
            end)
        end

        local offset = leaderRoot.Position - root.Position
        local flat = Vector3.new(offset.X, 0, offset.Z)
        local dist = flat.Magnitude

        -- ไกลเกิน/ตกแมป -> วาร์ปมาต่อท้ายตัวข้างหน้า
        if dist > TELEPORT_DIST or math.abs(offset.Y) > 80 then
            c.model:PivotTo(leaderRoot.CFrame * CFrame.new(0, 0, FOLLOW_DIST))
            return
        end

        hum.WalkSpeed = myHum.WalkSpeed * (dist > 25 and 1.5 or 1)

        -- นั่งตามตัวข้างหน้า (เมื่ออยู่ใกล้แล้ว)
        if dist <= FOLLOW_DIST + 1 and hum.Sit ~= leaderHum.Sit then
            hum.Sit = leaderHum.Sit
        end

        if dist > FOLLOW_DIST + 0.8 and not hum.Sit then
            hum:MoveTo(leaderRoot.Position - flat.Unit * FOLLOW_DIST)
            -- เดินแล้วไม่ขยับ (ติดสิ่งกีดขวาง) -> กระโดด
            local speed = (root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
            if speed < 1 then
                c.stuck = c.stuck + AI_INTERVAL
            else
                c.stuck = 0
            end
            if c.stuck > 0.6 then
                hum.Jump = true
                c.stuck = 0
            end
        else
            hum:MoveTo(root.Position) -- หยุดยืนรอ
            c.stuck = 0
        end
    end

    local function step(dt)
        local char = lp.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local myHum = char and char:FindFirstChildOfClass("Humanoid")
        if not (myRoot and myHum) then return end

        -- จำรหัสแอนิเมชันพื้นฐานของเรา (ไว้แยกออกจากท่าอีโมท)
        if cachedChar ~= char then
            cachedChar = char
            coreKeys = {}
            for _, set in pairs(DEFAULT_ANIMS) do
                for _, id in pairs(set) do
                    coreKeys[id:match("%d+")] = true
                end
            end
            local animateScript = char:FindFirstChild("Animate")
            if animateScript then
                for _, d in ipairs(animateScript:GetDescendants()) do
                    if d:IsA("Animation") then
                        local k = tostring(d.AnimationId):match("%d+")
                        if k then coreKeys[k] = true end
                    end
                end
            end
        end

        -- ดูท่าอีโมทที่เรากำลังเล่น (เฉพาะตอนยืนนิ่ง)
        emoteAcc = emoteAcc + dt
        if emoteAcc >= 0.25 then
            emoteAcc = 0
            emoteSet = {}
            local mySpeed = (myRoot.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
            if mySpeed < 1 then
                local animator = myHum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                        local id = t.Animation and t.Animation.AnimationId
                        local key = id and tostring(id):match("%d+")
                        if key and not coreKeys[key] then
                            emoteSet[key] = id
                        end
                    end
                end
            end
        end

        acc = acc + dt
        local aiTick = acc >= AI_INTERVAL
        if aiTick then acc = 0 end

        for i, c in ipairs(clones) do
            if c.root.Parent and c.hum.Parent then
                if aiTick then think(c, i, char, myRoot, myHum) end
                animate(c, dt)
            end
        end
    end

    local function destroyAll()
        if conn then
            conn:Disconnect()
            conn = nil
        end
        for _, c in ipairs(clones) do
            if c.jumpConn then c.jumpConn:Disconnect() end
            pcall(function() c.model:Destroy() end)
        end
        clones = {}
        emoteSet = {}
        cachedChar = nil
    end

    local function summon()
        destroyAll()
        summonId = summonId + 1
        local myId = summonId

        local name = NameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then name = lp.Name end
        local n = math.clamp(math.floor(tonumber(CountBox.Text) or 1), 1, MAX_CLONES)

        setStatus("⏳ กำลังดึงโมเดล " .. name .. " ...")

        task.spawn(function()
            local template, err = getTemplate(name)
            if myId ~= summonId then
                if template then template:Destroy() end
                return
            end
            if not template then
                setStatus("❌ " .. tostring(err))
                return
            end

            local char = lp.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local myHum = char and char:FindFirstChildOfClass("Humanoid")
            if not (myRoot and myHum) then
                template:Destroy()
                setStatus("❌ ตัวละครเรายังไม่พร้อม")
                return
            end

            for i = 1, n do
                local m = template:Clone()
                m.Name = "Clone_" .. name .. "_" .. i
                local hum = m:FindFirstChildOfClass("Humanoid")
                local root = m:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    hum.WalkSpeed = myHum.WalkSpeed
                    hum.UseJumpPower = myHum.UseJumpPower
                    hum.JumpPower = myHum.JumpPower
                    hum.JumpHeight = myHum.JumpHeight

                    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
                    local mine = Instance.new("Folder")
                    mine.Name = "NoCollideMine"
                    mine.Parent = m

                    m.Parent = workspace
                    m:PivotTo(myRoot.CFrame * CFrame.new(0, 0, FOLLOW_DIST * i)) -- เรียงต่อท้ายเรา

                      -- ไม่ชนกับตัวข้างหน้า
                    if #clones > 0 then
                        noCollide(clones[#clones].model, m, root)
                    end

                    local tracks = {}
                    for key, id in pairs(buildIds(hum.RigType)) do
                        local a = Instance.new("Animation")
                        a.AnimationId = id
                        local t = animator:LoadAnimation(a)
                        t.Looped = (key ~= "jump")
                        tracks[key] = t
                    end

                    table.insert(clones, {
                        model = m, root = root, hum = hum, animator = animator, mine = mine,
                        tracks = tracks, emotes = {}, emotePlayed = {},
                        stuck = 0, air = 0,
                    })
                else
                    m:Destroy()
                end
            end
            template:Destroy()

            if #clones == 0 then
                setStatus("❌ สร้างโมเดลไม่สำเร็จ")
                return
            end

            acc, emoteAcc = 0, 0
            conn = RunService.Heartbeat:Connect(step)
            setStatus("✅ ดึง " .. name .. " จำนวน " .. #clones .. " ตัว")
        end)
    end

    -- ปุ่มข้างแคปซูล: ✨ ซัมมอน / 🗑️ ลบ
    createRoundButton(Row, -98, "✨", Color3.fromRGB(190, 255, 190), summon)
    createRoundButton(Row, -45, "🗑️", Color3.fromRGB(255, 190, 190), function()
        summonId = summonId + 1
        destroyAll()
        setStatus("🗑️ ลบโมเดลทั้งหมดแล้ว")
    end)

    -- ล้างตอนรันสคริปต์ซ้ำ (ต่อสายกับตัวล้างของแม่เหล็ก)
    local prevCleanup = getgenv().MainScript_Cleanup
    getgenv().MainScript_Cleanup = function()
        summonId = summonId + 1
        destroyAll()
        if prevCleanup then prevCleanup() end
    end
    end



    
                            
        return { Container = FishContainer, Button = CatBtnFish }
end
