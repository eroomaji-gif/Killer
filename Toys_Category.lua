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

    return { Container = ToyContainer, Button = CatBtnToy }
end

