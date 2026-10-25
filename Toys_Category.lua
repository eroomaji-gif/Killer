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
    -- 👥 ของเล่นที่ 2: ดึงโมเดลผู้เล่นมาวิ่งตามตัวเรา
    -- (ช่องชื่อ + ช่องจำนวน + ปุ่มซัมมอน + ปุ่มลบ)
    -- ใช้ ToyContainer เป็น Parent / ลบทั้งบล็อกนี้ได้ ส่วนอื่นไม่พัง
    -- ==========================================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer

    local MAX_CLONES = 20     -- จำนวนสูงสุดต่อครั้ง
    local SPACING = 3.5       -- ระยะห่างระหว่างตัว
    local COLUMNS = 4         -- จำนวนตัวต่อแถว (เรียงต่อท้ายตัวเรา)
    local FOLLOW_SPEED = 14   -- ยิ่งมากยิ่งตามติด

    local clones = {}         -- { model, root, motors, offset }
    local conn
    local summonId = 0
    local cachedChar, cachedMotors = nil, {}

    -- ---------- UI สไตล์เดียวกับ createSwitchButton ----------
    local function styleCapsule(obj)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = obj
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 2
        stroke.Parent = obj
    end

    local function createInput(parent, order, placeholder, defaultText)
        local box = Instance.new("TextBox")
        box.Parent = parent
        box.LayoutOrder = order
        box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        box.Size = UDim2.new(1, 0, 0, 45)
        box.Font = Enum.Font.GothamBold
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        box.Text = defaultText or ""
        box.TextColor3 = Color3.fromRGB(0, 0, 0)
        box.TextSize = 14
        box.ClearTextOnFocus = false
        styleCapsule(box)
        return box
    end

    local function createActionButton(parent, order, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.LayoutOrder = order
        btn.BackgroundColor3 = color
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextSize = 14
        styleCapsule(btn)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = ToyContainer
    TitleLabel.LayoutOrder = 10
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -10, 0, 24)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "👥 ดึงโมเดลผู้เล่นมาวิ่งตาม"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local NameBox = createInput(ToyContainer, 11, "ชื่อผู้เล่น (เว้นว่าง = ตัวเราเอง)", "")
    local CountBox = createInput(ToyContainer, 12, "จำนวน (1-" .. MAX_CLONES .. ")", "1")

    -- รับเฉพาะตัวเลข
    CountBox:GetPropertyChangedSignal("Text"):Connect(function()
        local filtered = (CountBox.Text:gsub("%D", ""))
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
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            hum.BreakJointsOnDeath = false
        end
        local root = model:FindFirstChild("HumanoidRootPart")
        if root then
            root.Anchored = true
        end
    end

    local function getTemplate(name)
        local model

        -- 1) ผู้เล่นที่อยู่ในเซิร์ฟเวอร์ -> ก๊อปตัวละครจริง
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
        if not model:FindFirstChild("HumanoidRootPart") then
            model:Destroy()
            return nil, "โมเดลนี้ไม่มี HumanoidRootPart"
        end
        return model
    end

    -- ---------- วิ่งตาม + ก๊อปท่าทางตัวเรา ----------
    local function offsetFor(i, total)
        local row = math.floor((i - 1) / COLUMNS)
        local col = (i - 1) % COLUMNS
        local inRow = math.min(COLUMNS, total - row * COLUMNS)
        local x = (col - (inRow - 1) / 2) * SPACING
        local z = SPACING * (row + 1) -- +Z = ด้านหลังตัวเรา
        return CFrame.new(x, 0, z)
    end

    local function step(dt)
        local char = lp.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        if cachedChar ~= char then
            cachedChar = char
            cachedMotors = {}
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Motor6D") then
                    cachedMotors[d.Name] = d
                end
            end
        end

        local alpha = math.clamp(dt * FOLLOW_SPEED, 0, 1)
        for _, c in ipairs(clones) do
            if c.root.Parent then
                local target = myRoot.CFrame * c.offset
                local cur = c.root.CFrame
                if (cur.Position - target.Position).Magnitude > 60 then
                    c.root.CFrame = target -- ไกลเกิน (วาป) ให้ตามทันที
                else
                    c.root.CFrame = cur:Lerp(target, alpha)
                end
                -- ก๊อปท่าทางทุกข้อต่อ (วิ่ง กระโดด นั่ง ท่าเต้น ฯลฯ)
                for name, motor in pairs(c.motors) do
                    local src = cachedMotors[name]
                    if src then
                        motor.Transform = src.Transform
                    end
                end
            end
        end
    end

    local function destroyAll()
        if conn then
            conn:Disconnect()
            conn = nil
        end
        for _, c in ipairs(clones) do
            pcall(function() c.model:Destroy() end)
        end
        clones = {}
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
            if not myRoot then
                template:Destroy()
                setStatus("❌ ตัวละครเรายังไม่พร้อม")
                return
            end

            local matched, totalMotors = 0, 0
            for i = 1, n do
                local m = template:Clone()
                m.Name = "Clone_" .. name .. "_" .. i
                local root = m:FindFirstChild("HumanoidRootPart")
                local motors = {}
                for _, d in ipairs(m:GetDescendants()) do
                    if d:IsA("Motor6D") then
                        motors[d.Name] = d
                    end
                end
                if i == 1 then
                    for mname in pairs(motors) do
                        totalMotors = totalMotors + 1
                        if char:FindFirstChild(mname, true) then
                            matched = matched + 1
                        end
                    end
                end
                local offset = offsetFor(i, n)
                root.CFrame = myRoot.CFrame * offset
                m.Parent = workspace
                table.insert(clones, { model = m, root = root, motors = motors, offset = offset })
            end
            template:Destroy()

            conn = RunService.RenderStepped:Connect(step)

            if totalMotors > 0 and matched < totalMotors / 2 then
                setStatus("⚠️ ดึง " .. n .. " ตัว แต่ rig ไม่เหมือนเรา ท่าทางอาจไม่ตรง")
            else
                setStatus("✅ ดึง " .. name .. " จำนวน " .. n .. " ตัว")
            end
        end)
    end

    createActionButton(ToyContainer, 13, "✨ ซัมมอน", Color3.fromRGB(190, 255, 190), summon)
    createActionButton(ToyContainer, 14, "🗑️ เดสทอย", Color3.fromRGB(255, 190, 190), function()
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
