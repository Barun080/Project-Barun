--[[
    PROJECT BARUN (PB) | Official Anime Dice Script Loader
    GitHub: https://github.com/Barun080/Project-Barun
--]]

-- แบบรันไฟล์ในเครื่องโดยตรง (Local File):
-- loadstring(readfile("anime_dice_hub.lua"))()

-- แบบโหลดตรงผ่าน GitHub หรือ Local Loader:
local LoaderUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/anime_dice_hub.lua"

local success, err = pcall(function()
    if isfile and isfile("anime_dice_hub.lua") then
        loadstring(readfile("anime_dice_hub.lua"))()
    else
        loadstring(game:HttpGet(LoaderUrl, true))()
    end
end)

if not success then
    warn("[PROJECT BARUN] Anime Dice Loader execution error: " .. tostring(err))
end
