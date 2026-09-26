local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function GetClientHWID()
    if gethwid then return tostring(gethwid()) end
    if get_hwid then return tostring(get_hwid()) end
    local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
    if RbxAnalyticsService then return tostring(RbxAnalyticsService:GetClientId()) end
    return tostring(Players.LocalPlayer.UserId)
end

local function ExecuteMainScript()
    if not _G.Key or _G.Key == "" then
        warn("[treeHub System] ERROR: Please enter a valid _G.Key!")
        return
    end

    local hwid = GetClientHWID()
    local localPlayer = Players.LocalPlayer
    local user = localPlayer and localPlayer.Name or "UnknownUser"
    local uid = localPlayer and tostring(localPlayer.UserId) or "0"

    local worker_url = "https://treehubbackend.antimivirus.workers.dev/"
    local fetch_endpoint = worker_url .. "?key=" .. HttpService:UrlEncode(tostring(_G.Key)) .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&user=" .. HttpService:UrlEncode(user) .. "&uid=" .. HttpService:UrlEncode(uid)

    local success, response = pcall(function()
        return game:HttpGet(fetch_endpoint, true)
    end)

    if success then
        if response:sub(1, 12) == "Unauthorized" or response:sub(1, 12) == "Server Error" or response:sub(1, 7) == "Blocked" then
            warn("[treeHub System] " .. response)
        else
            print("[treeHub System] Authentication Successful! Loading Script...")
            local main_function, err = loadstring(response)
            if main_function then
                main_function()
            else
                warn("[treeHub System] Execution Error: " .. tostring(err))
            end
        end
    else
        warn("[treeHub System] ERROR: Failed to connect to authentication server.")
    end
end

ExecuteMainScript()
