--[[ =========================================================
    Auto-Translator bootstrap
    Idiomas suportados: pt, th
    Default: en (inglês) se não encontrar/baixar nada
========================================================= ]]

-- URLs
local urls = {}
urls.Owner = "https://raw.githubusercontent.com/RainCreatorHub/"
urls.Repository = urls.Owner .. "Scripts/refs/heads/main/"
urls.Translator = urls.Repository .. "Translator/"
urls.Utils = urls.Repository .. "Utils/"

-- Para o projeto Forsaken
urls.TrForsaken = urls.Translator .. "Forsaken/"
urls.TrFnPortuguese = urls.TrForsaken .. "Portuguese.json"
urls.TrFnThai = urls.TrForsaken .. "Thai.json"

-- Serviços
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

-- Detecta idioma (forçável por getgenv().ForsakenLang = "pt" / "th")
local function detectLang()
    local forced = (getgenv and getgenv().ForsakenLang) or nil
    if forced and (forced == "pt" or forced == "th") then
        return forced
    end
    local ok, robloxLocale = pcall(function()
        return LocalizationService.RobloxLocaleId
    end)
    if ok and robloxLocale and #robloxLocale >= 2 then
        local short = string.lower(string.sub(robloxLocale, 1, 2))
        if short == "pt" or short == "th" then
            return short
        end
    end
    return "en"
end

local LANG = detectLang()

-- Carrega JSON de forma segura
local function loadJSON(url)
    local ok1, res = pcall(game.HttpGet, game, url)
    if not ok1 then return nil end
    local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, res)
    if not ok2 then return nil end
    return decoded
end

-- Seleciona URL por idioma
local langUrlMap = {
    pt = urls.TrFnPortuguese,
    th = urls.TrFnThai
}

-- Dados de tradução (ou tabelas vazias)
local TrData = {}
if langUrlMap[LANG] then
    TrData = loadJSON(langUrlMap[LANG]) or {}
else
    TrData = {}
end

-- =========================
-- Funções de tradução
-- =========================
local T = {}

-- Tabs NUNCA têm descrição (por sua exigência anterior)
function T.tab(name)
    local tabs = TrData.Tabs
    if tabs and tabs[name] then
        return tabs[name]
    end
    return name
end

function T.section(name, desc)
    local sections = TrData.Sections
    if sections and sections[name] then
        local t = sections[name]
        return t[1] or name, t[2] or desc
    end
    return name, desc
end

function T.label(name, desc)
    local labels = TrData.Labels
    if labels and labels[name] then
        local t = labels[name]
        return t[1] or name, t[2] or desc
    end
    return name, desc
end

function T.button(name, desc)
    local buttons = TrData.Buttons
    if buttons and buttons[name] then
        local t = buttons[name]
        return t[1] or name, t[2] or desc
    end
    return name, desc
end

function T.toggle(name, desc)
    local toggles = TrData.Toggles
    if toggles and toggles[name] then
        local t = toggles[name]
        return t[1] or name, t[2] or desc
    end
    return name, desc
end

-- Mensagem de idade da conta (usamos bloco do JSON se existir, senão fallback EN)
local function getAccountMessage(days)
    local msg = "Just started?"
    local accountMsgs = TrData["Account Messages"]
    if days >= 1825 then
        msg = (accountMsgs and accountMsgs["5 years"]) or "5 years account... congrats warrior :D"
    elseif days >= 1460 then
        msg = (accountMsgs and accountMsgs["4 years"]) or "4 years account... congrats :D"
    elseif days >= 1095 then
        msg = (accountMsgs and accountMsgs["3 years"]) or "3 years account... congrats :D"
    elseif days >= 730 then
        msg = (accountMsgs and accountMsgs["2 years"]) or "2 years account... congrats :D"
    elseif days >= 365 then
        msg = (accountMsgs and accountMsgs["1 year"]) or "1 year account... congrats :D"
    elseif days >= 250 then
        msg = (accountMsgs and accountMsgs["almost 1 year"]) or "almost 1 year, keep going! :D"
    elseif days >= 150 then
        msg = (accountMsgs and accountMsgs["still new"]) or "Still new :D"
    elseif days >= 50 then
        msg = (accountMsgs and accountMsgs["still new"]) or "Still new :D"
    else
        msg = (accountMsgs and accountMsgs["just started"]) or "Just started?"
    end
    return msg
end

-- =========================================================
-- A PARTIR DAQUI É O SEU SCRIPT, COM AS STRINGS PASSANDO PELO TRADUTOR
-- =========================================================

local MoonLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/MoonLib/refs/heads/main/MoonLib.lua"))()

-- Main Window
local window = MoonLib:MakeWindow({
    Title = "Rain Hub | Forsaken",
    SubTitle = "By Zaque_blox"
})

-- Local player reference
local player = game.Players.LocalPlayer

-- Tab: Info
local infoTab = window:MakeTab({ Name = T.tab("Info") })
local secName, secDesc = T.section("Info", nil)
local section = infoTab:AddSection({ Name = secName })

do
    local n, d = T.label("Welcome", "Beautiful name!") -- A chave "Welcome" é estática; o nome do player é dinâmico e permanece
    infoTab:AddLabel({
        Name = n .. " " .. player.Name .. "!",
        Description = d
    })
end

local mensagem = getAccountMessage(player.AccountAge)
do
    local n, d = T.label("Account Age", mensagem)
    infoTab:AddLabel({
        Name = (n or "Account Age") .. ": " .. player.AccountAge .. " days",
        Description = d
    })
end

-- Seção Update
do
    local sN, sD = T.section("Update", nil)
    section = infoTab:AddSection({ Name = sN })
    local n, d = T.label("Added: Button | finish generator", "Finish the generator")
    infoTab:AddLabel({
        Name = n,
        Description = d
    })
end

-- Seção Future update
do
    local sN, sD = T.section("future update", nil)
    section = infoTab:AddSection({ Name = sN })
    local n, d = T.label("Toggle: Auto Generator", "Walk to the generator and complete, do not move!")
    infoTab:AddLabel({
        Name = n,
        Description = d
    })
end

do
    local n, d = T.label("Working?", "Yes / updated today.")
    infoTab:AddLabel({
        Name = n,
        Description = d
    })
end

do
    local n, d = T.label("Update day", "no date")
    infoTab:AddLabel({
        Name = n,
        Description = d
    })
end

-- Tab: Main
local mainTab = window:MakeTab({ Name = T.tab("Main") })
do
    local sN = T.section("Main", nil)
    section = mainTab:AddSection({ Name = sN })
end

do
    local nBtn, _ = T.button("finish generator", "Executes the command to finish the generator")
    mainTab:AddButton({
        Name = nBtn or "Finish generator",
        Callback = function()
            local map = workspace:WaitForChild("Map", 9e9)
            local ingame = map:WaitForChild("Ingame", 9e9)
            local mapInside = ingame:WaitForChild("Map", 9e9)

            for _, child in ipairs(mapInside:GetChildren()) do
                local remotes = child:FindFirstChild("Remotes")
                local remoteEvent = remotes and remotes:FindFirstChild("RE")

                if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                    remoteEvent:FireServer(unpack({}))
                end
            end
        end
    })

    local n, d = T.label("Finish generator | Button", "spamming = kick or ban")
    mainTab:AddLabel({
        Name = n,
        Description = d
    })
end

-- Tab: ESP
local espTab = window:MakeTab({ Name = T.tab("ESP") })
do
    local sN = T.section("ESP", nil)
    section = espTab:AddSection({ Name = sN })
end

-- Module: ESP for Generators
local GeneratorESP = { running = false, highlights = {} }

function GeneratorESP:checkProgress(generator)
    local progress = generator:FindFirstChild("Progress", true)
    if progress then
        local barUI = progress:FindFirstChild("BarUI")
        if barUI then
            local bar = barUI:FindFirstChild("Bar")
            local background = barUI:FindFirstChild("Background")
            if bar and background then
                return bar.Size.X.Scale >= (background.Size.X.Scale * 0.95)
            end
        end
    end
    return false
end

function GeneratorESP:manageHighlight(obj, color)
    if not self.highlights[obj] then
        local highlight = Instance.new("Highlight")
        highlight.Name = "RainHubGeneratorESP"
        highlight.Adornee = obj
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
        self.highlights[obj] = highlight
    else
        self.highlights[obj].FillColor = color
        self.highlights[obj].OutlineColor = color
    end
end

function GeneratorESP:updateHighlights()
    for obj, _ in pairs(self.highlights) do
        if not obj:IsDescendantOf(workspace) then
            self.highlights[obj]:Destroy()
            self.highlights[obj] = nil
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            local cor = self:checkProgress(obj) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
            self:manageHighlight(obj, cor)
        end
    end
end

function GeneratorESP:start()
    self.running = true
    task.spawn(function()
        while self.running do
            GeneratorESP:updateHighlights()
            task.wait(0.5)
        end
    end)
end

function GeneratorESP:stop()
    self.running = false
    for _, highlight in pairs(self.highlights) do
        highlight:Destroy()
    end
    self.highlights = {}
end

do
    local n, d = T.toggle("Generator (s)", "Highlight generators")
    espTab:AddToggle({
        Name = n,
        Description = d,
        Default = false,
        Callback = function(state)
            if state then
                GeneratorESP:start()
            else
                GeneratorESP:stop()
            end
        end
    })
end

-- Module: ESP for Rigs (Survivors and Killers)
local RigsESP = { runningSurvivors = false, runningKillers = false, highlights = {} }

function RigsESP:manageHighlight(model, cor)
    if not self.highlights[model] then
        local highlight = Instance.new("Highlight")
        highlight.Name = "RainHubRigESP"
        highlight.Adornee = model
        highlight.FillColor = cor
        highlight.OutlineColor = cor
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = model
        self.highlights[model] = highlight
    end
end

do
    local n, d = T.toggle("Survivor (s)", "Highlight Survivors")
    espTab:AddToggle({
        Name = n,
        Description = d,
        Default = false,
        Callback = function(state)
            if state then
                RigsESP.runningSurvivors = true
                task.spawn(function()
                    while RigsESP.runningSurvivors do
                        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
                        if survivorsFolder then
                            for _, model in ipairs(survivorsFolder:GetChildren()) do
                                if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                                    RigsESP:manageHighlight(model, Color3.fromRGB(0, 255, 0))
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                RigsESP.runningSurvivors = false
                for obj, highlight in pairs(RigsESP.highlights) do
                    if highlight.FillColor == Color3.fromRGB(0, 255, 0) then
                        highlight:Destroy()
                        RigsESP.highlights[obj] = nil
                    end
                end
            end
        end
    })
end

do
    local n, d = T.toggle("Killer (s)", "Highlight Killers")
    espTab:AddToggle({
        Name = n,
        Description = d,
        Default = false,
        Callback = function(state)
            if state then
                RigsESP.runningKillers = true
                task.spawn(function()
                    while RigsESP.runningKillers do
                        local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
                        if killersFolder then
                            for _, model in ipairs(killersFolder:GetChildren()) do
                                if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                                    RigsESP:manageHighlight(model, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                RigsESP.runningKillers = false
                for obj, highlight in pairs(RigsESP.highlights) do
                    if highlight.FillColor == Color3.fromRGB(255, 0, 0) then
                        highlight:Destroy()
                        RigsESP.highlights[obj] = nil
                    end
                end
            end
        end
    })
end
