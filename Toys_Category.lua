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






 -- ==========================================
-- 🌪️ [ฟังก์ชันก้อน] ดักจับแรงสะท้อนเซิร์ฟเวอร์ + โยนใส่คนที่ใกล้ที่สุด
-- ==========================================
local function createSuperFlingSwitch(parent)
    getgenv().SuperFling_Active = false
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer
    local connection = nil

    -- 🛡️ ฟังก์ชันเช็ก Owner จากสคริปต์หลัก (ctx.Owners)
    local function isOwner(player)
        local ownersList = ctx.Owners or {
            "ชื่อOwnerคนที1",
            "ชื่อOwnerคนที2"
        }

        for _, ownerName in ipairs(ownersList) do
            if player.Name == ownerName or player.DisplayName == ownerName then
                return true
            end
        end
        return false
    end

    -- 🔍 ฟังก์ชันค้นหาผู้เล่นที่อยู่ใกล้ตัวเราที่สุดในรัศมี
    local function getNearestPlayer(maxDistance)
        local myChar = lp.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
        local myRoot = myChar.HumanoidRootPart

        local nearestTarget = nil
        local shortestDistance = maxDistance or 10

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= lp and otherPlayer.Character then
                local otherChar = otherPlayer.Character
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                local otherHum = otherChar:FindFirstChild("Humanoid")

                if otherRoot and otherHum and otherHum.Health > 0 then
                    local dist = (myRoot.Position - otherRoot.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        nearestTarget = otherPlayer
                    end
                end
            end
        end

        return nearestTarget
    end

    -- ⚡ ระบบสลับทิศทางแรงสะท้อน (Recoil Redirection Loop)
    local function toggleFlingAura(state)
        if state then
            if connection then connection:Disconnect() end
            
            connection = RunService.Heartbeat:Connect(function()
                if not getgenv().SuperFling_Active then return end
                
                pcall(function()
                    local myChar = lp.Character
                    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                    local myRoot = myChar.HumanoidRootPart

                    -- 1. ค้นหาผู้เล่นที่อยู่ใกล้ที่สุดในระยะประชิด (8 สตั๊ด)
                    local targetPlayer = getNearestPlayer(8)

                    if targetPlayer then
                        local targetChar = targetPlayer.Character
                        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")

                        if targetRoot then
                            -- 🛡️ เช็กว่าเป็น Owner หรือไม่
                            if isOwner(targetPlayer) then
                                -- ถ้าเป็น Owner -> ยอมรับแรงสะท้อนให้ตัวเรากระเด็นออกไปเอง
                                myRoot.AssemblyLinearVelocity = Vector3.new(0, 5000, 0)
                            else
                                -- 🔄 2. ดักจับก้อนแรงส่ง/แรงสะท้อนที่ตัวเรามีอยู่
                                local caughtLinear = myRoot.AssemblyLinearVelocity
                                local caughtAngular = myRoot.AssemblyAngularVelocity

                                -- 🛑 3. ปฏิเสธแรงทั้งหมดใส่ตัวเรา (สั่งล้างค่าความเร็วเราเป็น 0 ทันที)
                                myRoot.Velocity = Vector3.zero
                                myRoot.RotVelocity = Vector3.zero
                                myRoot.AssemblyLinearVelocity = Vector3.zero
                                myRoot.AssemblyAngularVelocity = Vector3.zero

                                -- 🎯 4. เปลี่ยนทิศทางแรงสะท้อน + เพิ่มพลังงาน แล้วโยนใส่เป้าหมายใกล้ที่สุด
                                local pushDirection = (targetRoot.Position - myRoot.Position).Unit
                                
                                -- นำก้อนแรงสะท้อนมาประมวลผลใหม่เพื่ออัดเข้าเป้าหมายคนนั้นคนเดียว
                                targetRoot.AssemblyLinearVelocity = pushDirection * 50000 + Vector3.new(0, 30000, 0)
                                targetRoot.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
                            end
                        end
                    end
                end)
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end

    return createSwitchButton(parent, "🌪️ สลับทิศทางแรงสะท้อนใส่คนใกล้สุด", getgenv().SuperFling_Active, function(isActive)
        getgenv().SuperFling_Active = isActive
        toggleFlingAura(isActive)
    end)
end

createSuperFlingSwitch(ToyContainer)
    
            
                

        
                    
            
            








    
    return { Container = ToyContainer, Button = CatBtnToy }
end
