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







    return { Container = PvpContainer, Button = CatBtnPvp }
end
