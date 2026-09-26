

local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local function GetClientHWID()
    local hwid = ""
    if gethwid then
        hwid = gethwid()
    elseif get_hwid then
        hwid = get_hwid()
    elseif RbxAnalyticsService then
        hwid = RbxAnalyticsService:GetClientId()
    else
        hwid = game:GetService("Players").LocalPlayer.UserId
    end
    return tostring(hwid)
end

local function ExecuteMainScript()
    if not _G.Key or _G.Key == "" then
        warn("--------------------------------------------------")
        warn("[treeHub System] HATA: Lütfen _G.Key değerini giriniz!")
        warn("--------------------------------------------------")
        return
    end

    local client_hwid = GetClientHWID()
    

    local worker_url = "https://treehubbackend.antimivirus.workers.dev/"
    local fetch_endpoint = worker_url .. "?key=" .. HttpService:UrlEncode(tostring(_G.Key)) .. "&hwid=" .. HttpService:UrlEncode(client_hwid)

    local success, response = pcall(function()
        return game:HttpGet(fetch_endpoint, true)
    end)

    if success then
        if response:sub(1, 12) == "Unauthorized" or response:sub(1, 12) == "Server Error" or response:sub(1, 7) == "Blocked" then
            warn("[treeHub System] " .. response)
        else
            print("[treeHub System] Lisans ve HWID Doğrulandı! Ana Script Çalıştırılıyor...")
            local main_function, err = loadstring(response)
            if main_function then
                main_function()
            else
                warn("[treeHub System] Script Çalıştırma Hatası: " .. tostring(err))
            end
        end
    else
        warn("[treeHub System] Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.")
    end
end

ExecuteMainScript()
