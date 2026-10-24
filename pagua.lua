-- ==========================================================
-- 🐟 โมดูลหมวดหมู่ "ปลากั้วจำลอง" (ไฟล์แยก ให้สคริปต์หลักดึงมารัน)
-- ชื่อไฟล์ใน GitHub: modules/fish_sim.lua
-- สคริปต์หลักเรียกแบบ: loadstring(game:HttpGet(URL))()(ctx)
-- ⚠️ ต้องเรียก "หลัง" toys.lua เสมอ (เพราะ toys.lua จัดลำดับปุ่มซ้ายไว้ก่อน
--    แล้วไฟล์นี้จะแทรกตัวเองต่อท้ายปุ่มของเล่น และดันปุ่มที่เหลือลงไป)
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
    -- ปุ่มหมวดของเล่น (ถ้าสคริปต์หลักไม่ได้ส่งมา ก็หาจากชื่อในแถบซ้าย)
    local CatBtnToy = ctx.CatBtnToy or SidebarFrame:FindFirstChild("CategoryToy")

    -- 1) ปุ่มหมวดหมู่ "ปลากั้วจำลอง" ที่แถบซ้าย
    local CatBtnFish = Instance.new("TextButton")
    CatBtnFish.Name = "CategoryFishSim"
    CatBtnFish.Parent = SidebarFrame
    CatBtnFish.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    CatBtnFish.Size = UDim2.new(1, 0, 0, 40)
    CatBtnFish.Font = Enum.Font.GothamBold
    CatBtnFish.Text = "🐟 ปลากั้วจำลอง"
    CatBtnFish.TextColor3 = Color3.fromRGB(255, 255, 255)
    CatBtnFish.TextSize = 13

    local CatCornerFish = Instance.new("UICorner")
    CatCornerFish.CornerRadius = UDim.new(0, 6)
    CatCornerFish.Parent = CatBtnFish

    -- 2) จัดลำดับปุ่มซ้าย (แทรกต่อท้ายของเล่น):
    --    ฆ่า+วาป -> ออโต้ -> ESP -> ของเล่น -> ปลากั้วจำลอง -> วาป+ฟาม -> ข้อมูล -> ตั้งค่า -> ผู้สร้าง
    CatBtn1.LayoutOrder = 1
    if CatBtnAuto then CatBtnAuto.LayoutOrder = 2 end
    if CatBtnESP then CatBtnESP.LayoutOrder = 3 end
    if CatBtnToy then CatBtnToy.LayoutOrder = 4 end
    CatBtnFish.LayoutOrder = 5
    CatBtnTp.LayoutOrder = 6
    CatBtnInfo.LayoutOrder = 7
    CatBtnSettings.LayoutOrder = 8
    CatBtnCreator.LayoutOrder = 9
    SidebarFrame.CanvasSize = UDim2.new(0, 0, 0, 530)

    -- 3) หน้าต่างฝั่งขวาของหมวดปลากั้วจำลอง
    local FishContainer = Instance.new("ScrollingFrame")
    FishContainer.Name = "FishContainer"
    FishContainer.Parent = MainFrame
    FishContainer.BackgroundTransparency = 1
    FishContainer.Position = UDim2.new(0, 160, 0, 50)
    FishContainer.Size = UDim2.new(1, -170, 1, -60)
    FishContainer.CanvasSize = UDim2.new(0, 0, 0, 600)
    FishContainer.ScrollBarThickness = 6
    FishContainer.Visible = false

    local FishContainerLayout = Instance.new("UIListLayout")
    FishContainerLayout.Parent = FishContainer
    FishContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FishContainerLayout.Padding = UDim.new(0, 8)

    -- ข้อความบอกว่ายังว่าง (หายเองทันทีที่ใส่ปุ่มแรกเข้ามา)
    local FishEmptyHint = Instance.new("TextLabel")
    FishEmptyHint.Name = "EmptyHint"
    FishEmptyHint.Parent = FishContainer
    FishEmptyHint.BackgroundTransparency = 1
    FishEmptyHint.Size = UDim2.new(1, -10, 0, 40)
    FishEmptyHint.Font = Enum.Font.Gotham
    FishEmptyHint.Text = "🐟 หมวดปลากั้วจำลอง — ยังไม่มีฟังก์ชัน"
    FishEmptyHint.TextColor3 = Color3.fromRGB(180, 180, 190)
    FishEmptyHint.TextSize = 14

    FishContainer.ChildAdded:Connect(function(child)
        if child ~= FishEmptyHint and not child:IsA("UIListLayout") then
            FishEmptyHint.Visible = false
        end
    end)

    -- 4) ระบบกดสลับหน้าต่าง
    -- กดปุ่มปลากั้วจำลอง -> ซ่อนทุกหน้า (รวมหน้าของเล่น) แล้วโชว์หน้านี้
    CatBtnFish.MouseButton1Click:Connect(function()
        ctx.ContentContainer.Visible = false
        ctx.TeleportContainer.Visible = false
        ctx.InfoContainer.Visible = false
        ctx.SettingsContainer.Visible = false
        ctx.CreatorContainer.Visible = false
        if ctx.AutoContainer then ctx.AutoContainer.Visible = false end
        if ctx.ESPContainer then ctx.ESPContainer.Visible = false end
        local toyPage = ctx.ToyContainer or MainFrame:FindFirstChild("ToyContainer")
        if toyPage then toyPage.Visible = false end
        FishContainer.Visible = true
    end)

    -- กดหมวดอื่น (รวมของเล่น) -> ซ่อนหน้าปลากั้วจำลอง
    local otherButtons = { CatBtn1, CatBtnTp, CatBtnInfo, CatBtnSettings, CatBtnCreator }
    if CatBtnAuto then table.insert(otherButtons, CatBtnAuto) end
    if CatBtnESP then table.insert(otherButtons, CatBtnESP) end
    if CatBtnToy then table.insert(otherButtons, CatBtnToy) end
    for _, btn in ipairs(otherButtons) do
        btn.MouseButton1Click:Connect(function()
            FishContainer.Visible = false
        end)
    end

    -- ==========================================================
    -- 👇 วางปุ่มฟังก์ชันปลากั้วจำลองตรงนี้ (ข้างใน return function) โดยใช้ FishContainer เป็น Parent
    -- ตัวอย่าง:
    -- createSwitchButton(FishContainer, "🐟 ชื่อฟังก์ชัน", false, function(isActive)
    --     -- โค้ด
    -- end)
    -- ==========================================================







-- ==========================================================
-- 🗼 ฟังก์ชันเดี่ยว: พาร์กัวร์จำลอง 100 ชั้น (ไม่มีส่วนของหมวดหมู่ปนอยู่)
-- วางไว้ "ใต้" ตัวแปร FishContainer (ในไฟล์ fish_sim_category.lua ตรงจุดที่เว้นไว้ให้วางปุ่ม)
-- ลบทั้งบล็อกนี้ทิ้งได้เลย ส่วนอื่นไม่พัง
-- ==========================================================
do
    local function createParkourSwitch(parent)
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local lp = Players.LocalPlayer

        -- ค่าปรับแต่ง
        local LEVELS = 300          -- จำนวนชั้น
        local RISE = 3              -- ความสูงต่อชั้น (เกมที่กระโดดต่ำให้ลดเหลือ 2.5)
        local GAP_ARC = 15          -- ระยะห่างระหว่างศูนย์กลางแต่ละแท่น (ยิ่งมากยิ่งกระโดดไกล)
        local TOWER_RADIUS = 26     -- รัศมีวงเกลียวของหอ
        local PAD = 10              -- ขนาดแท่นปกติ
        local CHECKPOINT_PAD = 18   -- ขนาดแท่นพักทุกๆ 10 ชั้น
        local BUILD_DELAY = 0.03    -- ความเร็วสร้างต่อชั้น (วินาที) ยิ่งน้อยยิ่งเร็ว

        getgenv().Parkour_Active = false

        local folder = nil
        local buildToken = 0

        local function destroyTower()
            buildToken = buildToken + 1 -- ยกเลิกงานสร้างที่ค้างอยู่
            if folder then
                folder:Destroy()
                folder = nil
            end
        end

        local function buildTower()
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not (hum and root) then return false end

            destroyTower()
            buildToken = buildToken + 1
            local myToken = buildToken

            folder = Instance.new("Folder")
            folder.Name = "ParkourTower"
            folder.Parent = workspace
            local myFolder = folder

            -- ตำแหน่งพื้นใต้เท้า + ทิศที่หันหน้า (ใช้ได้ทุกแมป เพราะอ้างอิงจากตัวเราเอง)
            local feetOffset = (hum.RigType == Enum.HumanoidRigType.R6) and 3 or (hum.HipHeight + root.Size.Y / 2)
            local groundY = root.Position.Y - feetOffset
            local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
            if look.Magnitude < 0.01 then look = Vector3.new(0, 0, -1) end
            look = look.Unit

            local firstPos = Vector3.new(root.Position.X, 0, root.Position.Z) + look * 9
            local centerXZ = firstPos + look * TOWER_RADIUS
            local a0 = math.atan2(-look.Z, -look.X) -- มุมของแท่นแรกเมื่อมองจากจุดศูนย์กลางหอ
            local dTheta = GAP_ARC / TOWER_RADIUS

            task.spawn(function()
                for i = 1, LEVELS do
                    if myToken ~= buildToken or not myFolder.Parent then return end

                    local angle = a0 + (i - 1) * dTheta
                    local x = centerXZ.X + math.cos(angle) * TOWER_RADIUS
                    local z = centerXZ.Z + math.sin(angle) * TOWER_RADIUS
                    local y = groundY + i * RISE
                    local isCheckpoint = (i % 10 == 0)
                    local size = isCheckpoint and CHECKPOINT_PAD or PAD

                    local pos = Vector3.new(x, y - 0.5, z)
                    local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))

                    local part = Instance.new("Part")
                    part.Name = "Level" .. i
                    part.Anchored = true
                    part.CanCollide = true
                    part.Size = Vector3.new(size, 1, size)
                    part.CFrame = CFrame.lookAt(pos, pos + tangent)
                    part.Material = isCheckpoint and Enum.Material.Neon or Enum.Material.SmoothPlastic
                    part.Color = isCheckpoint and Color3.fromRGB(255, 255, 255)
                        or Color3.fromHSV((i * 0.02) % 1, 0.8, 1)
                    part.TopSurface = Enum.SurfaceType.Smooth
                    part.BottomSurface = Enum.SurfaceType.Smooth
                    part.Transparency = 0.8
                    part.Parent = myFolder
                    TweenService:Create(part, TweenInfo.new(0.15), { Transparency = 0 }):Play()

                    -- ป้ายเลขชั้นทุกๆ 10 ชั้น
                    if isCheckpoint then
                        local gui = Instance.new("BillboardGui")
                        gui.Size = UDim2.new(0, 120, 0, 40)
                        gui.StudsOffset = Vector3.new(0, 4, 0)
                        gui.AlwaysOnTop = false
                        gui.Adornee = part
                        gui.Parent = part
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextScaled = true
                        lbl.TextColor3 = Color3.new(1, 1, 1)
                        lbl.TextStrokeTransparency = 0
                        lbl.Text = "ชั้น " .. i
                        lbl.Parent = gui
                    end

                    task.wait(BUILD_DELAY)
                end
            end)
            return true
        end

        -- ล้างตอนรันสคริปต์ซ้ำ
        local prevCleanup = getgenv().MainScript_Cleanup
        getgenv().MainScript_Cleanup = function()
            getgenv().Parkour_Active = false
            destroyTower()
            if prevCleanup then prevCleanup() end
        end

        return createSwitchButton(parent, "🗼 พาร์กัวร์จำลอง 100 ชั้น", false, function(isActive)
            getgenv().Parkour_Active = isActive
            if isActive then
                buildTower()
            else
                destroyTower() -- ลบทิ้งทันที
            end
        end)
    end

    -- ห่อ pcall: ถ้าบล็อกนี้พัง ปุ่มอื่นในหมวดยังอยู่ครบ
    local ok, err = pcall(createParkourSwitch, FishContainer)
    if not ok then warn("[พาร์กัวร์] error: " .. tostring(err)) end
end





    return { Container = FishContainer, Button = CatBtnFish }
end
