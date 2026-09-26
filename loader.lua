
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")

local function GetClientHWID()
    local hwid = ""
    if gethwid then
        hwid = gethwid()
    elseif get_hwid then
        hwid = get_hwid()
    elseif RbxAnalyticsService then
        hwid = RbxAnalyticsService:GetClientId()
    else
        hwid = Players.LocalPlayer.UserId
    end
    return tostring(hwid)
end

local function ExecuteMainScript()
    if not _G.Key or _G.Key == "" then
        warn("[treeHub System] HATA: Lütfen _G.Key değerini giriniz!")
        return
    end

    local client_hwid = GetClientHWID()
    local localPlayer = Players.LocalPlayer
    local username = localPlayer and localPlayer.Name or "UnknownUser"
    local userId = localPlayer and tostring(localPlayer.UserId) or "0"

    local worker_url = "https://treehubbackend.antimivirus.workers.dev/"
    local fetch_endpoint = string.format(
        "%s?key=%s&hwid=%s&user=%s&uid=%s",
        worker_url,
        HttpService:UrlEncode(tostring(_G.Key)),
        HttpService:UrlEncode(client_hwid),
        HttpService:UrlEncode(username),
        HttpService:UrlEncode(userId)
    )

    local success, response = pcall(function()
        return game:HttpGet(fetch_endpoint, true)
    end)

    if success then
        if response:sub(1, 12) == "Unauthorized" or response:sub(1, 12) == "Server Error" or response:sub(1, 7) == "Blocked" then
            warn("[treeHub System] " .. response)
        else
            print("[treeHub System] Doğrulama Başarılı! Script Yükleniyor...")
            local main_function, err = loadstring(response)
            if main_function then
                main_function()
            else
                warn("[treeHub System] Script Çalıştırma Hatası: " .. tostring(err))
            end
        end
    else
        warn("[treeHub System] Sunucuya bağlanılamadı.")
    end
end

ExecuteMainScript()
