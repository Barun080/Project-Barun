--[[
    PROJECT BARUN (PB) | Official Anime Dice Script Loader
    GitHub: https://github.com/Barun080/Project-Barun
--]]

local LoaderUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/anime_dice_hub.lua"

local function loadHub()
    local code = nil

    -- 1. เช็คไฟล์ในเครื่องก่อน (Local Workspace)
    pcall(function()
        if isfile and isfile("anime_dice_hub.lua") then
            code = readfile("anime_dice_hub.lua")
        end
    end)

    -- 2. ดึงจาก GitHub แบบไม่แคช (Cache-Busting Query)
    if not code or #code < 500 then
        local freshUrl = LoaderUrl .. "?t=" .. tostring(tick())
        local okHttp, res = pcall(function()
            return game:HttpGet(freshUrl)
        end)
        if okHttp and res and #res > 500 then
            code = res
        else
            code = game:HttpGet(LoaderUrl)
        end
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
