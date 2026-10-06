--[[
    PROJECT BARUN (PB) | Official Anime Dice Script Loader
    GitHub: https://github.com/Barun080/Project-Barun
--]]

-- แบบสั้นบรรทัดเดียว (One-Liner):
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Barun080/Project-Barun/main/anime_dice_hub.lua"))()

-- แบบป้องกันเน็ตหลุด & ตรวจสอบข้อผิดพลาดในการโหลดแบบละเอียด:
local LoaderUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/anime_dice_hub.lua"

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
