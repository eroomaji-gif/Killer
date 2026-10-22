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
-- 🦶 ฟังก์ชันเดี่ยว: ปุ่มดรอปคิก (กระโดดถีบขาคู่ ท่าเล่นๆ)
-- เปิดสวิตช์ -> มีปุ่มกลมเล็กๆ ลอยบนจอ ลากย้ายได้ / กดแล้วตัวละครกระโดดเตะขาคู่ 1 ครั้ง
-- วางไว้ "เหนือ" บรรทัด  return { Container = ToyContainer, ... }  ใน toys.lua
-- ต้องมีตัวแปร ToyContainer กับ createSwitchButton อยู่ในขอบเขต
-- ลบทั้งบล็อกนี้ทิ้งได้เลย ส่วนอื่นไม่พัง (ห่อด้วย do ... end และไม่มี return ระดับบนสุด)
-- ==========================================================
do
    local function createDropKickSwitch(parent)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local lp = Players.LocalPlayer

        -- ===== ปรับท่าได้ที่นี่ =====
        local FORWARD_SPEED = 35   -- แรงส่ง: พุ่งไปข้างหน้ากี่ studs/วินาที (สูงสุด 50 ตั้งเกินนี้โค้ดจะบีบให้เหลือ 50)
        local THRUST_TIME = 0.35   -- ออกแรงส่งต่อเนื่องกี่วินาที (ยิ่งนานยิ่งพุ่งไกล)
        local DEBUG = true         -- true = พิมพ์ข้อความบอกสถานะในคอนโซล (ไว้หาสาเหตุถ้าไม่ทำงาน)
        local LEAN = 0.95          -- เอนตัวไปข้างหลังกี่เรเดียน (ยิ่งมากยิ่งแนวนอน)
        local LEG_EXTRA = 0.45     -- เหยียดขาไปข้างหน้าเพิ่ม
        local ARM_OUT = 0.9        -- กางแขนช่วยทรงตัว
        local MAX_TIME = 1.4       -- เวลาสูงสุดของท่า (วินาที) กันค้าง
        -- ============================

        FORWARD_SPEED = math.clamp(FORWARD_SPEED, 0, 50)
        local function dbg(...)
            if DEBUG then print("[ดรอปคิก]", ...) end
        end

        getgenv().DropKick_Active = false

        local gui = nil
        local guiConns = {}
        local renderConn = nil
        local kicking = false
        local abortKick = nil

        local function smooth(x)
            return x * x * (3 - 2 * x)
        end

        -- หมุนข้อต่อในแกนของ Part0 โดยใช้จุดข้อต่อเดิมเป็นจุดหมุน (ใช้ได้ทั้ง R6 และ R15)
        local function rotated(orig, rx, rz)
            local pos = orig.Position
            local rot = orig - pos
            return CFrame.new(pos) * CFrame.Angles(rx, 0, rz) * rot
        end

        local function findJoint(char, names)
            for _, n in ipairs(names) do
                local j = char:FindFirstChild(n, true)
                if j and j:IsA("Motor6D") then
                    return j
                end
            end
        end

        local function playKick()
            if kicking then return end
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then
                dbg("กดแล้วแต่หาตัวละครไม่เจอ หรือตายอยู่")
                return
            end

            local joints = {
                root = findJoint(char, { "Root", "RootJoint" }),
                lhip = findJoint(char, { "LeftHip", "Left Hip" }),
                rhip = findJoint(char, { "RightHip", "Right Hip" }),
                lsh = findJoint(char, { "LeftShoulder", "Left Shoulder" }),
                rsh = findJoint(char, { "RightShoulder", "Right Shoulder" }),
            }
            if not joints.root or not joints.lhip or not joints.rhip then
                warn("ดรอปคิก: ตัวละครนี้ไม่ใช่ R6/R15 หาข้อต่อไม่เจอ")
                return
            end

            local origins = {}
            for k, j in pairs(joints) do
                origins[k] = j.C0
            end

            kicking = true

            local function finish()
                if renderConn then
                    renderConn:Disconnect()
                    renderConn = nil
                end
                for k, j in pairs(joints) do
                    if j and j.Parent then
                        j.C0 = origins[k]
                    end
                end
                kicking = false
                abortKick = nil
            end
            abortKick = finish

            -- กระโดด + พุ่งไปข้างหน้านิดหน่อย (เคลื่อนที่เฉพาะตัวเรา ไม่มีแรงกระทำกับคนอื่น)
            local vy = hum.UseJumpPower and hum.JumpPower
                or math.sqrt(2 * workspace.Gravity * hum.JumpHeight)
            local look = root.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            flat = flat.Magnitude > 0.01 and flat.Unit or Vector3.new(0, 0, -1)
            hum.Jump = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            dbg("เริ่มเตะ แรงส่ง =", FORWARD_SPEED, "แรงกระโดด =", math.floor(vy))

            local startTime = os.clock()
            local endingAt, endW, lastW = nil, 0, 0

            renderConn = RunService.RenderStepped:Connect(function()
                if lp.Character ~= char or not root.Parent or hum.Health <= 0 then
                    finish()
                    return
                end

                local now = os.clock()
                local t = now - startTime
                local w

                if t < THRUST_TIME then
                    local v = root.AssemblyLinearVelocity
                    local y = v.Y
                    if t < 0.1 and y < vy * 0.6 then
                        y = vy -- ย้ำแรงกระโดดช่วงแรก เผื่อโดนเกมทับ
                    end
                    root.AssemblyLinearVelocity = Vector3.new(flat.X * FORWARD_SPEED, y, flat.Z * FORWARD_SPEED)
                end

                if not endingAt then
                    w = smooth(math.clamp((t - 0.05) / 0.2, 0, 1))
                    local grounded = hum.FloorMaterial ~= Enum.Material.Air
                    if (t > 0.35 and grounded) or t > MAX_TIME then
                        endingAt = now
                        endW = w
                    end
                else
                    local p = math.clamp((now - endingAt) / 0.2, 0, 1)
                    w = endW * (1 - smooth(p))
                    if p >= 1 then
                        finish()
                        return
                    end
                end
                lastW = w

                -- ตัวเอนไปข้างหลัง ขาพุ่งไปข้างหน้า แขนกางออก
                joints.root.C0 = rotated(origins.root, LEAN * w, 0)
                joints.lhip.C0 = rotated(origins.lhip, LEG_EXTRA * w, 0)
                joints.rhip.C0 = rotated(origins.rhip, LEG_EXTRA * w, 0)
                if joints.lsh then joints.lsh.C0 = rotated(origins.lsh, 0, -ARM_OUT * w) end
                if joints.rsh then joints.rsh.C0 = rotated(origins.rsh, 0, ARM_OUT * w) end
            end)
        end

        local function destroyGui()
            if abortKick then abortKick() end
            for _, c in ipairs(guiConns) do
                c:Disconnect()
            end
            guiConns = {}
            if gui then
                gui:Destroy()
                gui = nil
            end
        end

        local function createGui()
            destroyGui()

            local okParent, guiParent = pcall(function()
                return (gethui and gethui()) or game:GetService("CoreGui")
            end)
            if not okParent or not guiParent then
                guiParent = lp:WaitForChild("PlayerGui")
            end

            gui = Instance.new("ScreenGui")
            gui.Name = "DropKickGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 50
            if not pcall(function() gui.Parent = guiParent end) then
                gui.Parent = lp:WaitForChild("PlayerGui")
            end

            local SIZE = 60
            local btn = Instance.new("TextButton")
            btn.Name = "DropKickButton"
            btn.Parent = gui
            btn.Size = UDim2.new(0, SIZE, 0, SIZE)
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.AutoButtonColor = false
            btn.Text = "🦶"
            btn.TextSize = 28
            btn.Font = Enum.Font.GothamBold
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = btn

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 2
            stroke.Parent = btn

            -- ตำแหน่งที่จำไว้ (ในรอบการเล่นนี้) ถ้าไม่มีให้วางทางขวาของจอ
            local saved = getgenv().DropKick_Pos
            if saved then
                btn.Position = UDim2.new(0, saved.X, 0, saved.Y)
            else
                btn.Position = UDim2.new(1, -90, 0.6, 0)
            end

            local function clampToScreen(x, y)
                local cam = workspace.CurrentCamera
                local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
                return math.clamp(x, 0, vp.X - SIZE), math.clamp(y, 0, vp.Y - SIZE)
            end

            -- ระบบลากย้าย: ถ้าขยับน้อยกว่า 8 พิกเซลถือว่าเป็นการกด
            local dragging, moved = false, false
            local dragStart, startX, startY

            local function isPointer(input)
                return input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
            end

            table.insert(guiConns, btn.InputBegan:Connect(function(input)
                if isPointer(input) then
                    dragging, moved = true, false
                    dragStart = input.Position
                    startX, startY = btn.AbsolutePosition.X, btn.AbsolutePosition.Y
                end
            end))

            table.insert(guiConns, UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then
                    local dx = input.Position.X - dragStart.X
                    local dy = input.Position.Y - dragStart.Y
                    if math.abs(dx) > 8 or math.abs(dy) > 8 then
                        moved = true
                    end
                    if moved then
                        local x, y = clampToScreen(startX + dx, startY + dy)
                        btn.Position = UDim2.new(0, x, 0, y)
                    end
                end
            end))

            table.insert(guiConns, UserInputService.InputEnded:Connect(function(input)
                if dragging and isPointer(input) then
                    dragging = false
                    if moved then
                        getgenv().DropKick_Pos = Vector2.new(btn.AbsolutePosition.X, btn.AbsolutePosition.Y)
                    else
                        dbg("กดปุ่ม")
                        playKick()
                    end
                end
            end))
        end

        -- ล้างตอนรันสคริปต์ซ้ำ
        local prevCleanup = getgenv().MainScript_Cleanup
        getgenv().MainScript_Cleanup = function()
            getgenv().DropKick_Active = false
            destroyGui()
            if prevCleanup then prevCleanup() end
        end

        return createSwitchButton(parent, "🦶 ปุ่มดรอปคิก (ท่าเล่นๆ)", false, function(isActive)
            getgenv().DropKick_Active = isActive
            if isActive then
                createGui()
            else
                destroyGui()
            end
        end)
    end

    createDropKickSwitch(ToyContainer)
    end
    








    
    return { Container = ToyContainer, Button = CatBtnToy }
end
