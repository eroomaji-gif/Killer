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



-- ==========================================================
-- 🪜 โมดูลหมวดหมู่ "บันไดสี" (ไฟล์แยก ให้สคริปต์หลักดึงมารัน)
-- ชื่อไฟล์ใน GitHub: modules/color_stairs.lua
-- สคริปต์หลักเรียกแบบ: loadstring(game:HttpGet(URL))()(ctx)
-- (เรียกต่อจาก toys.lua ได้เลย หรือก่อนก็ได้)
-- ==========================================================
local function build(ctx, created)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local lp = Players.LocalPlayer

    local SidebarFrame = ctx.SidebarFrame
    local MainFrame = ctx.MainFrame
    local createSwitchButton = ctx.createSwitchButton

    -- ==========================================================
    -- ค่าปรับแต่งบันได
    -- ==========================================================
    local STEP_WIDTH = 9        -- ความกว้างบันได (ตัวละครกว้างประมาณ 4) กันเดินตก
    local STEP_DEPTH = 2        -- ความลึกต่อขั้น
    local STEP_RISE = 1         -- ความสูงต่อขั้น (ถ้าเดินขึ้นไม่ไหวให้ลดเหลือ 0.8)
    local STEP_THICK = 1.2      -- ความหนาแผ่นบันได
    local LOOKAHEAD = 3         -- สร้างล่วงหน้ากี่ขั้นข้างหน้าตัวละคร
    local MAX_STEPS = 400       -- จำกัดจำนวนขั้นสูงสุด
    local FADE_GAP = 0.05       -- หน่วงระหว่างขั้นตอนหายไป (ล่าง -> บน)
    local FADE_TIME = 0.25      -- เวลาจางของแต่ละขั้น

    -- ==========================================================
    -- 1) ปุ่มหมวดหมู่ที่แถบซ้าย
    -- ==========================================================
    local CatBtnStair = Instance.new("TextButton")
    CatBtnStair.Name = "CategoryColorStairs"
    CatBtnStair.Parent = SidebarFrame
    CatBtnStair.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    CatBtnStair.Size = UDim2.new(1, 0, 0, 40)
    CatBtnStair.Font = Enum.Font.GothamBold
    CatBtnStair.Text = "🪜 บันไดสี"
    CatBtnStair.TextColor3 = Color3.fromRGB(255, 255, 255)
    CatBtnStair.TextSize = 13

    local CatCornerStair = Instance.new("UICorner")
    CatCornerStair.CornerRadius = UDim.new(0, 6)
    CatCornerStair.Parent = CatBtnStair

    -- จัดลำดับ: วางไว้ท้ายสุดของแถบ โดยไม่ไปแตะ LayoutOrder ของปุ่มอื่น
    CatBtnStair.LayoutOrder = 50
    pcall(function()
        SidebarFrame.CanvasSize = UDim2.new(0, 0, 0, SidebarFrame.CanvasSize.Y.Offset + 50)
    end)
    table.insert(created, CatBtnStair)

    -- ==========================================================
    -- 2) หน้าต่างฝั่งขวา
    -- ==========================================================
    local StairContainer = Instance.new("ScrollingFrame")
    StairContainer.Name = "StairContainer"
    StairContainer.Parent = MainFrame
    StairContainer.BackgroundTransparency = 1
    StairContainer.Position = UDim2.new(0, 160, 0, 50)
    StairContainer.Size = UDim2.new(1, -170, 1, -60)
    StairContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
    StairContainer.ScrollBarThickness = 6
    StairContainer.Visible = false
    table.insert(created, StairContainer)

    local StairLayout = Instance.new("UIListLayout")
    StairLayout.Parent = StairContainer
    StairLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StairLayout.Padding = UDim.new(0, 8)

    -- ==========================================================
    -- 3) ระบบสลับหน้าต่าง
    -- ==========================================================
    CatBtnStair.MouseButton1Click:Connect(function()
        -- ซ่อนทุกหน้าที่ชื่อลงท้าย "Container" (ไม่ต้องไล่ชื่อทีละหน้า)
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child:IsA("GuiObject") and child ~= StairContainer and child.Name:match("Container$") then
                child.Visible = false
            end
        end
        StairContainer.Visible = true
    end)

    for _, btn in ipairs(SidebarFrame:GetChildren()) do
        if btn:IsA("TextButton") and btn ~= CatBtnStair then
            btn.MouseButton1Click:Connect(function()
                StairContainer.Visible = false
            end)
        end
    end

    -- ==========================================================
    -- 4) สถานะสี (HSV)
    -- ==========================================================
    local hue, sat, val = 0.58, 0.85, 1
    local function getColor()
        return Color3.fromHSV(hue, sat, val)
    end

    -- ระบบลาก (ใช้ร่วมกันทั้งวงล้อและสไลด์ รองรับทั้งเมาส์และจอสัมผัส)
    local dragging = nil
    local uiConns = {}
    table.insert(uiConns, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            dragging(input.Position)
        end
    end))
    table.insert(uiConns, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = nil
        end
    end))
    local function isPress(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end

    local refreshAll -- ประกาศไว้ก่อน (ใช้ในสไลด์/วงล้อ)

    -- ==========================================================
    -- 5) ปุ่มเปิด/ปิดฟังก์ชัน (แคปซูล) — วางไว้ด้านบนสุด
    -- ==========================================================
    local steps = {}      -- ขั้นบันไดตามลำดับสร้าง (ล่าง -> บน)
    local conn
    local lastTop         -- จุดบนสุดของขั้นล่าสุด
    local heading         -- ทิศที่บันไดกำลังไต่ไป

    local stairFolder = Instance.new("Folder")
    stairFolder.Name = "ColorStairs"
    stairFolder.Parent = workspace

    local function feetOffset(hum, root)
        if hum.RigType == Enum.HumanoidRigType.R6 then return 3 end
        return hum.HipHeight + root.Size.Y / 2
    end

    local function addStep()
        local topPos = lastTop + heading * STEP_DEPTH + Vector3.new(0, STEP_RISE, 0)
        local center = topPos - Vector3.new(0, STEP_THICK / 2, 0)

        local part = Instance.new("Part")
        part.Name = "Step"
        part.Anchored = true
        part.CanCollide = true
        part.Size = Vector3.new(STEP_WIDTH, STEP_THICK, STEP_DEPTH + 0.4)
        part.CFrame = CFrame.lookAt(center, center + heading)
        part.Color = getColor()
        part.Material = Enum.Material.SmoothPlastic
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Transparency = 0.8
        part.Parent = stairFolder
        TweenService:Create(part, TweenInfo.new(0.15), { Transparency = 0 }):Play()

        table.insert(steps, part)
        lastTop = topPos
    end

    -- ค่อยๆ หายไล่จากขั้นล่างสุดขึ้นไปบนสุด
    local function fadeOut(list)
        task.spawn(function()
            for _, p in ipairs(list) do
                if p.Parent then
                    p.CanCollide = false
                    TweenService:Create(p, TweenInfo.new(FADE_TIME), { Transparency = 1 }):Play()
                    task.delay(FADE_TIME + 0.05, function()
                        if p then p:Destroy() end
                    end)
                end
                task.wait(FADE_GAP)
            end
        end)
    end

    local function start()
        steps = {}
        lastTop = nil
        heading = nil

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Include
        rayParams.FilterDescendantsInstances = { stairFolder }

        conn = RunService.Heartbeat:Connect(function()
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not (hum and root) then return end

            local feet = Vector3.new(root.Position.X, root.Position.Y - feetOffset(hum, root), root.Position.Z)
            if not lastTop then lastTop = feet end

            local function horizDist()
                local o = feet - lastTop
                return Vector3.new(o.X, 0, o.Z).Magnitude
            end

            -- ลงไปยืนพื้นไกลจากบันไดเดิม -> เริ่มชุดบันไดใหม่ตรงที่ยืน
            local grounded = hum.FloorMaterial ~= Enum.Material.Air
            if grounded and horizDist() > LOOKAHEAD * STEP_DEPTH + 6 then
                local onStairs = workspace:Raycast(root.Position, Vector3.new(0, -8, 0), rayParams) ~= nil
                if not onStairs then
                    lastTop = feet
                    heading = nil
                end
            end

            -- เดินไปข้างหน้า -> สร้างบันไดต่อ
            local move = hum.MoveDirection
            local flat = Vector3.new(move.X, 0, move.Z)
            if flat.Magnitude > 0.1 then
                local desired = flat.Unit
                if not heading then heading = desired end

                if desired:Dot(heading) > 0.3 then -- ไม่สร้างตอนเดินถอยหลัง/ลงบันได
                    heading = (heading + (desired - heading) * 0.25).Unit
                    local count = 0
                    while count < 3
                        and #steps < MAX_STEPS
                        and horizDist() < LOOKAHEAD * STEP_DEPTH + 0.5
                        and feet.Y > lastTop.Y - 5 do
                        addStep()
                        count = count + 1
                    end
                end
            end
        end)
    end

    local function stop()
        if conn then
            conn:Disconnect()
            conn = nil
        end
        local old = steps
        steps = {}
        lastTop = nil
        heading = nil
        fadeOut(old)
    end

    createSwitchButton(StairContainer, "🪜 บันไดสี (เดินหน้าแล้วสร้างบันได)", false, function(isActive)
        if isActive then
            start()
        else
            stop()
        end
    end)

    -- ==========================================================
    -- 6) หัวข้อพับ/กางหน้าต่างผสมสี
    -- ==========================================================
    local PANEL_H = 250

    local Header = Instance.new("TextButton")
    Header.Name = "PaletteHeader"
    Header.Parent = StairContainer
    Header.LayoutOrder = 1
    Header.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Header.Size = UDim2.new(1, -10, 0, 34)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 13
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.AutoButtonColor = true
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    local Panel = Instance.new("Frame")
    Panel.Name = "PalettePanel"
    Panel.Parent = StairContainer
    Panel.LayoutOrder = 2
    Panel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Panel.Size = UDim2.new(1, -10, 0, PANEL_H)
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 8)
    PanelCorner.Parent = Panel

    local function setCollapsed(collapsed)
        Panel.Visible = not collapsed
        Header.Text = collapsed and "🎨 ผสมสี  ▶  (กดเพื่อเปิด)" or "🎨 ผสมสี  ▼  (กดเพื่อพับ)"
    end
    Header.MouseButton1Click:Connect(function()
        setCollapsed(Panel.Visible)
    end)
    setCollapsed(false)

    -- ==========================================================
    -- 7) วงล้อเลือกสี (สร้างจากเส้นสีหลายเส้น ไม่ต้องใช้รูปจากภายนอก)
    -- ==========================================================
    local R = 66
    local N = 90

    local Wheel = Instance.new("Frame")
    Wheel.Name = "Wheel"
    Wheel.Parent = Panel
    Wheel.BackgroundTransparency = 1
    Wheel.Position = UDim2.new(0, 10, 0, 10)
    Wheel.Size = UDim2.new(0, R * 2, 0, R * 2)

    local spokes = {}
    for i = 0, N - 1 do
        local theta = (i / N) * math.pi * 2
        local sp = Instance.new("Frame")
        sp.AnchorPoint = Vector2.new(0.5, 0.5)
        sp.BorderSizePixel = 0
        sp.Size = UDim2.new(0, 6, 0, R)
        sp.Position = UDim2.new(0, R + math.sin(theta) * R / 2, 0, R - math.cos(theta) * R / 2)
        sp.Rotation = math.deg(theta)
        sp.Parent = Wheel
        spokes[i] = sp
    end

    local WheelKnob = Instance.new("Frame")
    WheelKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    WheelKnob.Size = UDim2.new(0, 16, 0, 16)
    WheelKnob.ZIndex = 6
    WheelKnob.Parent = Wheel
    local wkc = Instance.new("UICorner")
    wkc.CornerRadius = UDim.new(1, 0)
    wkc.Parent = WheelKnob
    local wks = Instance.new("UIStroke")
    wks.Color = Color3.new(1, 1, 1)
    wks.Thickness = 2.5
    wks.Parent = WheelKnob

    local function placeKnob(theta, dist)
        WheelKnob.Position = UDim2.new(0, R + math.sin(theta) * dist, 0, R - math.cos(theta) * dist)
    end
    placeKnob(hue * math.pi * 2, R * 0.75)

    local WheelHit = Instance.new("TextButton")
    WheelHit.Parent = Wheel
    WheelHit.BackgroundTransparency = 1
    WheelHit.Text = ""
    WheelHit.Size = UDim2.new(1, 0, 1, 0)
    WheelHit.ZIndex = 10

    local function updateWheel(pos)
        local center = Wheel.AbsolutePosition + Wheel.AbsoluteSize / 2
        local dx, dy = pos.X - center.X, pos.Y - center.Y
        local theta = math.atan2(dx, -dy)
        hue = (theta / (math.pi * 2)) % 1
        local dist = math.min(math.sqrt(dx * dx + dy * dy), R - 4)
        placeKnob(theta, dist)
        refreshAll()
    end
    WheelHit.InputBegan:Connect(function(input)
        if isPress(input) then
            dragging = updateWheel
            updateWheel(input.Position)
        end
    end)

    -- ช่องแสดงตัวอย่างสีที่เลือก
    local Swatch = Instance.new("Frame")
    Swatch.AnchorPoint = Vector2.new(1, 0)
    Swatch.Position = UDim2.new(1, -10, 0, 10)
    Swatch.Size = UDim2.new(0, 70, 0, 70)
    Swatch.Parent = Panel
    local swc = Instance.new("UICorner")
    swc.CornerRadius = UDim.new(0, 10)
    swc.Parent = Swatch

    local HexLabel = Instance.new("TextLabel")
    HexLabel.AnchorPoint = Vector2.new(1, 0)
    HexLabel.Position = UDim2.new(1, -10, 0, 84)
    HexLabel.Size = UDim2.new(0, 70, 0, 18)
    HexLabel.BackgroundTransparency = 1
    HexLabel.Font = Enum.Font.Gotham
    HexLabel.TextSize = 12
    HexLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    HexLabel.Parent = Panel

    -- ==========================================================
    -- 8) สไลด์ 2 เส้น: ความเข้ม (มืด->สว่าง) และ ความจาง (ซีด->สด)
    -- ==========================================================
    local function makeSlider(y, titleText, initial, onChange)
        local lbl = Instance.new("TextLabel")
        lbl.Parent = Panel
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 12, 0, y)
        lbl.Size = UDim2.new(1, -24, 0, 16)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        lbl.Text = titleText

        local track = Instance.new("TextButton")
        track.Parent = Panel
        track.AutoButtonColor = false
        track.Text = ""
        track.BackgroundColor3 = Color3.new(1, 1, 1)
        track.Position = UDim2.new(0, 14, 0, y + 22)
        track.Size = UDim2.new(1, -28, 0, 14)
        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(1, 0)
        tc.Parent = track
        local grad = Instance.new("UIGradient")
        grad.Parent = track

        local knob = Instance.new("Frame")
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(initial, 0, 0.5, 0)
        knob.ZIndex = 3
        knob.Parent = track
        local kc = Instance.new("UICorner")
        kc.CornerRadius = UDim.new(1, 0)
        kc.Parent = knob
        local ks = Instance.new("UIStroke")
        ks.Color = Color3.new(1, 1, 1)
        ks.Thickness = 2.5
        ks.Parent = knob

        local function fromInput(pos)
            local rel = (pos.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
            rel = math.clamp(rel, 0, 1)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            onChange(rel)
        end
        track.InputBegan:Connect(function(input)
            if isPress(input) then
                dragging = fromInput
                fromInput(input.Position)
            end
        end)

        return { grad = grad, knob = knob }
    end

    local sliderVal = makeSlider(150, "🌑 ความเข้ม  (มืด ◀ ▶ สว่าง)", val, function(v)
        val = v
        refreshAll()
    end)
    local sliderSat = makeSlider(196, "💧 ความจาง  (ซีด ◀ ▶ สด)", sat, function(v)
        sat = v
        refreshAll()
    end)

    refreshAll = function()
        local col = getColor()
        Swatch.BackgroundColor3 = col
        HexLabel.Text = string.format("#%02X%02X%02X",
            math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
        WheelKnob.BackgroundColor3 = col
        sliderVal.knob.BackgroundColor3 = col
        sliderSat.knob.BackgroundColor3 = col

        for i = 0, N - 1 do
            spokes[i].BackgroundColor3 = Color3.fromHSV(i / N, sat, val)
        end

        sliderVal.grad.Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.fromHSV(hue, sat, 1))
        sliderSat.grad.Color = ColorSequence.new(Color3.fromHSV(hue, 0, val), Color3.fromHSV(hue, 1, val))
    end
    refreshAll()

    -- ==========================================================
    -- 9) ล้างทุกอย่างตอนรันสคริปต์ซ้ำ
    -- ==========================================================
    local prevCleanup = getgenv and getgenv().MainScript_Cleanup
    if getgenv then
        getgenv().MainScript_Cleanup = function()
            if conn then conn:Disconnect() conn = nil end
            for _, c in ipairs(uiConns) do c:Disconnect() end
            stairFolder:Destroy()
            if prevCleanup then prevCleanup() end
        end
    end

    return { Container = StairContainer, Button = CatBtnStair }
end

return function(ctx)
    local created = {}
    local ok, res = pcall(build, ctx, created)
    if ok then return res end
    -- พังตรงไหน เก็บกวาดของที่สร้างไปแล้ว เมนูหลักจะได้ไม่เสีย
    for _, o in ipairs(created) do pcall(function() o:Destroy() end) end
    warn("[บันไดสี] error: " .. tostring(res))
    return {}
    end
    



        
    
            
            








    
    
