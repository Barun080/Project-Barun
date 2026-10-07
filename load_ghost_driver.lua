--[[
    PROJECT BARUN (PB) | Official Script Loader
    GitHub: https://github.com/Barun080/Project-Barun
--]]

-- 🛡️ Early Boot Anti-AFK (กันหลุดทันทีตั้งแต่เริ่มโหลด):
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local VirtualUser = game:GetService("VirtualUser")

    if getconnections then
        for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
            pcall(function()
                if conn.Disable then conn:Disable() end
                if conn.Disconnect then conn:Disconnect() end
            end)
        end
    end

    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.zero)
        end)
    end)
end)

-- แบบสั้นบรรทัดเดียว (One-Liner):
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Barun080/Project-Barun/main/ghost_driver_hub.lua"))()

-- แบบพรีเมียม ป้องกันเน็ตหลุด แจ้งเตือนสถานะการโหลด:
local LoaderUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/ghost_driver_hub.lua"

local success, err = pcall(function()
    loadstring(game:HttpGet(LoaderUrl, true))()
end)

if not success then
    warn("[PROJECT BARUN] Loader execution error: " .. tostring(err))
end
