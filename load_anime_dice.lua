--[[
    PROJECT BARUN (PB) | Official Anime Dice Script Loader
    GitHub: https://github.com/Barun080/Project-Barun
--]]

local LoaderUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/anime_dice_hub.lua"

local function loadHub()
    local code = nil
    if isfile and isfile("anime_dice_hub.lua") then
        code = readfile("anime_dice_hub.lua")
    else
        code = game:HttpGet(LoaderUrl, true)
    end

    if not code or #code < 500 then
        error("Downloaded script is empty or invalid!")
    end

    local fn, parseErr = loadstring(code)
    if not fn then
        error("Compile Error: " .. tostring(parseErr))
    end

    return fn()
end

local success, err = pcall(loadHub)
if not success then
    warn("[PROJECT BARUN] Anime Dice Loader execution error: " .. tostring(err))
end
