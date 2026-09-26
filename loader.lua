
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local function GetClientHWID()
    local hwid = ""
    if gethwid then
        hwid = gethwid()
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
        warn("[treeHub System] ERROR: Please Input  _G.Key Value!")
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
        if response:sub(1, 12) == "Unauthorized" or response:sub(1, 12) == "Server Error" then
            warn("[treeHub System] Blocked! " .. response)
        else
            print("[treeHub System] LICENSE AND HWID VERIFIED WAIT FOR MAIN SCRIPT...")
            local main_function, err = loadstring(response)
            if main_function then
                main_function()
            else
                warn("[treeHub System] Script Run Error: " .. tostring(err))
            end
        end
    else
        warn("[treeHub System] Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.")
    end
end

ExecuteMainScript()
