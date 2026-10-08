--[[
    PROJECT BARUN (PB) | Official Loot To Forge Script Loader
    GitHub: https://github.com/Barun080/Project-Barun
--]]

-- แบบสั้นบรรทัดเดียว (One-Liner พร้อม Cache Buster):
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Barun080/Project-Barun/main/loot_to_forge_hub.lua?v=" .. tick()))()

-- ลบ UI เก่าที่เปิดค้างอยู่ทันทีก่อนโหลดใหม่
pcall(function()
    if _G.LootToForgeCleanup then
        pcall(_G.LootToForgeCleanup)
    end
    local h = gethui and gethui() or game:GetService("CoreGui")
    for _, g in ipairs(h:GetChildren()) do
        if g.Name == "ProjectBarunForge" or g.Name == "Orion" or g.Name == "ProjectBarun_LootToForge" then
            g:Destroy()
        end
    end
    local lp = game:GetService("Players").LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    if pg then
        for _, g in ipairs(pg:GetChildren()) do
            if g.Name == "ProjectBarunForge" or g.Name == "Orion" or g.Name == "ProjectBarun_LootToForge" then
                g:Destroy()
            end
        end
    end
end)

-- โหลดสคริปต์เวอร์ชันล่าสุด 100% ป้องกันแคชเก่าค้าง
local BaseUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/loot_to_forge_hub.lua"
local LoaderUrl = BaseUrl .. "?v=" .. tostring(os.time())

local success, err = pcall(function()
    local rawCode = game:HttpGet(LoaderUrl, true)
    local fn, compileErr = loadstring(rawCode)
    if not fn then
        error("Script compilation error: " .. tostring(compileErr))
    end
    fn()
end)

if not success then
    warn("[PROJECT BARUN] Loader execution error: " .. tostring(err))
end
