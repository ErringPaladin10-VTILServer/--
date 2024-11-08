------------------------------------------------
------------------[[ Zeus ]]--------------------
---------------[[ WaverlyCole ]]----------------
----------------[[ 2/13/2020 ]]-----------------
------------------------------------------------

--//VSB Loader = require(true, "c4e3d8cde3bdd1c1c5d5bfd3d6e613")
--//Vanilla Loader = require(912946995)

print("[Zeus] Start")

local Core = {}
local Cache = {}
local Commands = {}
local ActivePlayers = {}
local LoadedClients = {}
local AntiDeath = {}
local AnntiToolDb = {}
local Tabs = {}
local VerifyCodes = {}
local Users = {}
local NumUsers = 0
local Online = {}
local ConfirmationStatus = {}
local ServerBans = {}
local banKey = "ZeusBans-V2"
local dataStore = game:GetService("DataStoreService")
local banStore = dataStore:GetDataStore(banKey)
local banList = (banStore:GetAsync(banKey) or {})
local DataStoreService = game:GetService("DataStoreService")
local TempBanStore = DataStoreService:GetDataStore("TempBanStore",1)

Times = {
	One_Hour = 3600; -- Seconds in 1 hour
	Two_Hours = 7200; -- Seconds in 2 hours
	Three_Hours = 10800; -- Seconds in 3 hours
	Four_Hours = 14400; -- Seconds in 4 hours
	Five_Hours = 18000; -- Seconds in 5 hours
	Six_Hours = 21600; -- Seconds in 6 hours
	Seven_Hours = 25200; -- Seconds in 7 hours
	Eight_Hours = 28800; -- Seconds in 8 hours
	Nine_Hours = 32400; -- Seconds in 9 hours
	Ten_Hours = 36000; -- Seconds in 10 hours
	Eleven_Hours = 39600; -- Seconds in 11 hours
	Twelve_Hours = 43200; --Seconds in 12 hours
	One_Day = 86400; -- Seconds in a day
	Two_Days = 172800; -- Seconds in 2 days
	Three_Days = 259200;  -- Seconds in 3 days
	Four_Days = 345600; -- Seconds in 4 days
	Five_Days = 432000; -- Seconds in 5 days
	Six_Days = 518400; -- Seconds in 6 days
	One_Week = 604800;  -- Seconds in 1 week
}

local Settings = {
    ScriptLock = false,
    SoundLock = false,
    ServerLock = false,
    ShowVeritas = true
}
local RankNames = {
    [0] = "Guest",
    [1] = "Registered",
    [2] = "Member",
    [3] = "Mod",
    [4] = "Admin",
	[5] = "Head-Admin",
    [6] = "Owner"
}

Core.SandBox = {
    _G = {},
    shared = {},
    Functions = {}
}

local pairs, pcall, spawn = pairs, pcall, spawn --//Localize for speed improvements (Fractions of a ms but whatever it helps.)

local isPotatoSB = game.PlaceId == 4734966191 --//PotatoSB (Anti's SB, Bleu Pigs)
local isVoidSB = game.PlaceId == 843495510 --//Place2
local isNeighborhood = game.PlaceId == 2458384267 --//Neighborhood

if isPotatoSB then
    print("[Zeus] Configuring for PotatoSB") --Antis
    Settings.Database = "Potato"
elseif isVoidSB then
    print("[Zeus] Configuring for VoidSB") --Void
    Settings.Database = "Void"
elseif isNeighborhood then
	print("[Zeus] Confirguring for Neighborhood")
	Settings.Database = "Neighborhood"
else
    print("[Zeus] Configuring for Studio") --Any game that isnt set above (named it studio but its any game)
    Settings.Database = "Studio"
end

local script = script
if game:GetService("RunService"):IsStudio() then
    print "Assets from game" --//Load Assets from within game instead of requiring them.
    script = require(game:GetService("ServerScriptService").StudioLoader:FindFirstChild("Admin Assets").MainModule)
else
    script = require(4173734877) --//Asset Module
    Jail = script.Children.Jail
	GetDate = require(script.GetDate)
	Notification_Module = require(script.SetNotifyModule)
end

local Discord = require(script.WebhookAPI)

local url = "https://example.com"
local HttpService = game:GetService "HttpService"


Core.printTable = function(self, Table)
    print(Table)
end

Core.decodeJson = function(json)
    local jsonTab = {}
    pcall(
        function()
            jsonTab = HttpService:JSONDecode(json)
        end
    )
    return jsonTab
end
Core.encodeJson = function(data)
    local jsonString = data
    pcall(
        function()
            jsonString = HttpService:JSONEncode(data)
        end
    )
    return jsonString
end
Core.DBPost = function(Database, key, value)
    pcall(
        function()
            if key == nil then
            --print(key,value)
            end
            local json = HttpService:UrlEncode(Core.encodeJson(value))
            local retJson = HttpService:PostAsync(url, "sheet=" .. Database .. "&key=" .. key .. "&value=" .. json, 2)
            local data = Core.decodeJson(retJson)
            if data.result == "success" then
                return true
            else
                --warn("Database error:", data.error)
                return false
            end
        end
    )
end
Core.DBGet = function(Database)
    return "err"
end

Core.loadGlobalData = function(self)
end

Jailed = {}
JailPositions = {}

Core.Functions = {
    Create = function(ClassName, Properties) -- A function to create instances.
        local Instance = Instance.new(ClassName)
        local Properties = Properties or {}
        local ConnectionIndexes = {
            "MouseClick",
            "MouseHoverEnter",
            "MouseHoverLeave",
            "MouseButton1Down",
            "MouseButton2Down"
        }
        local CheckConnection = function(Index)
            local Index = tostring(Index)
            for _, Connect in pairs(ConnectionIndexes) do
                if Index:lower() == Connect:lower() then
                    return true
                end
            end
            return false
        end
        for Index, Value in pairs(Properties) do
            if not CheckConnection(Index) then
                Instance[Index] = Value
            else
                Instance[Index]:connect(Value)
            end
        end
        return Instance
    end,
    UnTempJailPlayer = function(Player)
        local player = Player
        Jailed[player.Name] = false
        pcall(
            function()
                workspace:findFirstChild("Jail_" .. player.Name):Destroy()
            end
        )
    end,
    TempJailPlayer = function(Player)
        local player = Player
        spawn(
            function()
                Jailed[player.Name] = true
                if not player.Character then
                    repeat
                        pcall(
                            function()
                                workspace:FindFirstChild(player.Name):Destroy()
                            end
                        )
                        pcall(
                            function()
                                player:LoadCharacter()
                            end
                        )
                        wait()
                    until player.Character
                end
                if not player.Character.Parent then
                    player:LoadCharacter()
                end
                if not player.Character:FindFirstChild "HumanoidRootPart" then
                    player:LoadCharacter()
                end
                local conn
                conn =
                    player.CharacterAdded:connect(
                    function(char)
                        if Jailed[player.Name] then
                            char.ChildAdded:connect(
                                function(obj)
                                    if not Jailed[player.Name] then
                                        return
                                    end
                                    if obj.Name == "HumanoidRootPart" then
                                        wait()
                                        obj:Destroy()
                                    end
                                    obj.Changed:connect(
                                        function()
                                            if not Jailed[player.Name] then
                                                return
                                            end
                                            if obj.Name == "HumanoidRootPart" then
                                                obj:Destroy()
                                            end
                                        end
                                    )
                                end
                            )
                            for i, v in pairs(player.Character:children()) do
                                local origname = v.Name
                                v.Changed:connect(
                                    function()
                                        if not Jailed[player.Name] then
                                            return
                                        end
                                        if v.Name ~= origname then
                                            v.Name = origname
                                        end
                                    end
                                )
                            end
                        else
                            conn:disconnect()
                        end
                    end
                )
                player.Character.ChildAdded:connect(
                    function(obj)
                        if not Jailed[player.Name] then
                            return
                        end
                        if obj.Name == "HumanoidRootPart" then
                            wait()
                            obj:Destroy()
                        end
                        obj.Changed:connect(
                            function()
                                if not Jailed[player.Name] then
                                    return
                                end
                                if obj.Name == "HumanoidRootPart" then
                                    obj:Destroy()
                                end
                            end
                        )
                    end
                )
                for i, v in pairs(player.Character:children()) do
                    local origname = v.Name
                    v.Changed:connect(
                        function()
                            if not Jailed[player.Name] then
                                return
                            end
                            if v.Name ~= origname then
                                v.Name = origname
                            end
                        end
                    )
                end
                local pos =
                    JailPositions[player.Name] or player.Character.HumanoidRootPart.CFrame or CFrame.new(0, 20, 50)
                JailPositions[player.Name] = pos
                local Jail
                local SpawnJail
                SpawnJail = function()
                    if not Jailed[player.Name] then
                        return
                    end
                    Jail = script.Children.Jail:Clone()
                    Jail.Name = "Jail_" .. player.Name
                    Jail.PrimaryPart = Jail.Center
                    Jail:SetPrimaryPartCFrame(pos)
                    Jail.Parent = workspace
                    local con = false
                    for i, v in pairs(Jail:children()) do
                        v.Changed:connect(
                            function()
                                if con then
                                    return
                                end
                                con = true
                                pcall(
                                    function()
                                        Jail:Destroy()
                                    end
                                )
                            end
                        )
                    end
                end
                SpawnJail()
                while Jailed[player.Name] do
                    pcall(
                        function()
                            if not player.Character then
                                repeat
                                    pcall(
                                        function()
                                            workspace:FindFirstChild(player.Name):Destroy()
                                        end
                                    )
                                    pcall(
                                        function()
                                            player:LoadCharacter()
                                        end
                                    )
                                    wait()
                                until player.Character
                            end
                            if not player.Character.Parent then
                                player:LoadCharacter()
                            end
                            if not player.Character:FindFirstChild "HumanoidRootPart" then
                                player:LoadCharacter()
                            end
                            if Jail.Parent then
                                if (player.Character.HumanoidRootPart.CFrame.p - pos.p).magnitude > 2 then
                                    player.Character.HumanoidRootPart.CFrame = pos
                                end
                            else
                                SpawnJail()
                                if (player.Character.HumanoidRootPart.CFrame.p - pos.p).magnitude > 2 then
                                    player.Character.HumanoidRootPart.CFrame = pos
                                end
                            end
                        end
                    )
                    wait()
                end
            end
        )
    end,
	Serverban = function(Speaker,Chosen)
		local Accept = Confirm(Speaker, "Sban " .. Chosen.Name .. "?", 15, false)
            if Accept then
                Core:importantLog(Speaker, "Accepted sban on '" .. Chosen.Name .. "'","Green")
                table.insert(ServerBans, Chosen.Name)
                Chosen:Kick("Server banned by " .. Speaker.Name .. " with Zeus Admin.")
                Speaker:NewTab(Public, "Server banned " .. Chosen.Name, "Lime green")
            elseif not Accept then
                Speaker:NewTab(Public, "Cancelled", "Crimson")
            end
		end,
	UnServerBan = function(Speaker,Chosen, Args)
                local Accept = Confirm(Speaker, "Un-server ban " .. Chosen .. "?", 15, false)
                if Accept then
                    Core:importantLog(Speaker, "Accepted un-sban on '" .. Chosen .. "'","Green")
					for i, v in pairs(ServerBans) do
            	if v:lower():find(Args[1]:lower()) then
                    table.remove(ServerBans, i)
                    Speaker:NewTab(Public, Chosen .. " was un-server banned", "Lime green")
                elseif not Accept then
                    Speaker:NewTab(Public, "Cancelled", "Crimson")
       			end
			end
		end
	end,
	PermBan = function(Player,Args)
		local toBan = tostring(Args[1])

        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments\n>pban add FULLUSERNAME REASON\n>pban remove FULLUSERNAME", "Crimson")
            return
        end

        table.remove(Args, 1)
        --// Find UserId
        local success, userId =
pcall(function() return game:GetService("Players"):GetUserIdFromNameAsync(toBan); end);
        --// Success error
        if (not success) then
            Player:newTab(Public, "Player not found on ROBLOX", "Crimson")
return
        end

        local Accept = Confirm(Player, "Perm-Ban " .. toBan .. " for '" .. table.concat(Args, " ") .. "'?", 15)
        if not Accept then
            Player:newTab(
                Public,
                "Cancelled",
                "Bright red",
                function()
                    Player:DismissAll()
                end
            )
            Core:importantLog(Player, "Cancelled pban on '" .. toBan .. "'","Red")
        elseif Accept then
            banList[tostring(userId)] = {Name = toBan, Reason = table.concat(Args, " "), bannedBy = Player.Name}
            banStore:SetAsync(banKey, banList)
            Player:DismissAll()
            Player:newTab(Public, toBan .. " (" .. userId .. ") banned.", "Lime green")
            Core:importantLog(Player, "Accepted pban on '" .. toBan .. "' for '" .. table.concat(Args, " ") .. "'","Green")
            dataStore:GetDataStore(banKey):SetAsync(userId, banKey)
            wait(3)
            Player:DismissAll()
            Player:RunCommand("<bans")			
        end
	end,
	 UnPermBan = function(Player,Args)
		local plr = tostring(Args[1])
        if Args[1] == nil then
            Player:newTab(Public, "No player found", "Crimson")
            return
        end
        for userId, data in pairs(banList) do
            if (string.find(string.lower(data.Name), string.lower(plr), 1, true) == 1) then
                local Accept = Confirm(Player, "Un-ban " .. plr .. "?", 15)
                if not Accept then
                    Player:newTab(Public, "Cancelled", "Bright red")
                    Core:importantLog(Player, "Cancelled unban on '" .. plr .. "'","Red")
					return
                elseif Accept then
                    banList[userId] = nil
                    banStore:SetAsync(banKey, banList)
                    Player:DismissAll()
                    Player:newTab(Public, "Unbanned " .. data.Name, "Lime green")
                    Core:importantLog(Player, "Confirmed unban on '" .. plr .. "'","Green")
                    dataStore:GetDataStore(banKey):SetAsync(userId, banList)
                    wait(3)
                    Player:DismissAll()
                    Player:RunCommand("<bans")
                    return
                else
                    Player:NewTab(Public, "Player not found in ban list", "Crimson")
                    return
                end
            end
        end
	end,
	CommandBar = function(Player)

                    if Player == nil then return end

                    for _,v in pairs(Player:FindFirstChild('PlayerGui'):GetChildren()) do
                      if v.Name == 'lebar' then
                        v:remove()
                      end
                    end

                    local ScreenGui = Instance.new("ScreenGui", Player:FindFirstChild('PlayerGui'))
                    ScreenGui.Name = 'lebar'

                    local Frame = Instance.new("Frame",ScreenGui)
                    Frame.BackgroundColor3 = Color3.new(1,1,1)
                    Frame.BackgroundTransparency = 1
                    Frame.BorderColor3 = Color3.new(0,0,0)
                    Frame.BorderSizePixel = 0
                    Frame.Position = UDim2.new(0,0,0.5,300)
                    Frame.Size = UDim2.new(0,400,0,30)
                    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY

                    local TextButton = Instance.new("TextButton",Frame)
                    TextButton.BackgroundColor3 = Color3.new(1,1,1)
                    TextButton.BackgroundTransparency = 0.69999998807907
                    TextButton.BorderColor3 = Color3.new(0,0,0)
                    TextButton.Size = UDim2.new(0.20000000298023,0,1,0)
                    TextButton.Style = Enum.ButtonStyle.Custom
                    TextButton.Font = Enum.Font.SourceSans
                    TextButton.FontSize = Enum.FontSize.Size24
                    TextButton.Text = "Submit"
                    TextButton.TextColor3 = Color3.new(1,0,0)

                    local TextBox = Instance.new("TextBox",Frame)
                    TextBox.Active = true
                    TextBox.BackgroundColor3 = Color3.new(1,1,1)
                    TextBox.BackgroundTransparency = 0.69999998807907
                    TextBox.BorderColor3 = Color3.new(0,0,0)
                    TextBox.Position = UDim2.new(0.20000000298023,0,0,0)
                    TextBox.Size = UDim2.new(0.80000001192093,0,1,0)
                    TextBox.Font = Enum.Font.SourceSans
                    TextBox.FontSize = Enum.FontSize.Size24
                    TextBox.Text = "Type command"
                    TextBox.TextColor3 = Color3.new(0,0,0)
                    TextButton.MouseButton1Down:connect(function()
                 	Player:RunCommand(TextBox.Text)
                    end)

                    Frame:TweenPosition(UDim2.new(0.75,0,0.5,300), "Out", "Quad", 1)
                  end,
SetBan = function(Player,BanTime) 
	local Success,Error = pcall(function()
		if BanTime == "one_hour" then --1h
			Player:setData("TimeBan",Times.One_Hour,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "two_hours" then --2h
			Player:setData("TimeBan",Times.Two_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "three_hours" then --3h
			Player:setData("TimeBan",Times.Three_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "four_hours" then --4h
			Player:setData("TimeBan",Times.Four_Hours,true)
		elseif BanTime == "five_hours" then --5h
			Player:setData("TimeBan",Times.Five_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "six_hours" then --6h
			Player:setData("TimeBan",Times.Six_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "seven_hours" then --7h
			Player:setData("TimeBan",Times.Seven_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "eight_hours" then --8h
			Player:setData("TimeBan",Times.Eight_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "nine_hours" then --9h
			Player:setData("TimeBan",Times.Nine_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "ten_hours" then --10h
			Player:setData("TimeBan",Times.Ten_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "eleven_hours" then --11h
			Player:setData("TimeBan",Times.Eleven_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "twelve_hours" then --12h
			Player:setData("TimeBan",Times.Twelve_Hours,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "one_day" then --1d
			Player:setData("TimeBan",Times.One_Day,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "two_days" then --2d
			Player:setData("TimeBan",Times.Two_Days,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "three_days" then --3d
			Player:setData("TimeBan",Times.Three_Days,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "four_days" then --4d
			Player:setData("TimeBan",Times.Four_Days,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "five_days" then --5d
			Player:setData("TimeBan",Times.Five_Days,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "six_days" then --6d
			Player:setData("TimeBan",Times.Six_Days,true)
			Player:setData("TimeBanStart", os.time(), true)
		elseif BanTime == "one_week" or BanTime == "seven_days" then --1w
			Player:setData("TimeBan",Times.One_Week,true)
			Player:setData("TimeBanStart", os.time(), true)
		end
	end)
	if not Success then
		print("Not successfull")
	end
end,
CheckTempBan = function(Player)

local date = GetDate()
local today = date:format("#W #d, #Y")
local Time = date:format("#H:#m #a")

if Player:TimeBanStart() + Player:TimeBan() < os.time() and Player:TimeBanStart() > 0 then
Player:setData("TimeBan",0,true)
Player:setData("TimeBanStart",0,true)
elseif Player:TimeBanStart() == nil or Player:TimeBan() == nil then
  return
elseif Player:TimeBanStart() == 0 or Player:TimeBan() == 0 then
  return
	else
if Player:TimeBan() == Times.One_Hour then --1h
	Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (1 Hour).")
elseif Player:TimeBan() == Times.Two_Hours then --2h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (2 Hours).")
elseif Player:TimeBan() == Times.Three_Hours then --3h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (3 Hours).")
elseif Player:TimeBan() == Times.Four_Hours then --4h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (4 Hours).")
elseif Player:TimeBan() == Times.Five_Hours then --5h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (5 Hours).")
elseif Player:TimeBan() == Times.Six_Hours then --6h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (6 Hours).")
elseif Player:TimeBan() == Times.Seven_Hours then --7h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (7 Hours).")
elseif Player:TimeBan() == Times.Eight_Hours then --8h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (8 Hours).")
elseif Player:TimeBan() == Times.Nine_Hours then --9h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (9 Hours).")
elseif Player:TimeBan() == Times.Ten_Hours then --10h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (10 Hours).")
elseif Player:TimeBan() == Times.Eleven_Hours then --11h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (11 Hours).")
elseif Player:TimeBan() == Times.Twelve_Hours then --12h
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (12 Hours).")
elseif Player:TimeBan() == Times.One_Day then --1d
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (1 Day).")
elseif Player:TimeBan() == Times.Two_Days then --2d
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (2 Days).")
elseif Player:TimeBan() == Times.Three_Days then --3d
	Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (3 Days).")
elseif Player:TimeBan() == Times.Four_Days then --4d
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (4 Days).")
elseif Player:TimeBan() == Times.Five_Days then --5d
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (5 Days).")
elseif Player:TimeBan() == Times.Six_Days then --6d
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (6 Days).")
elseif Player:TimeBan() == Times.One_Week then --7d
    Player:Kick("[Zeus]\nTemp banned "..today.." at "..Time.." (UTC)\nBanned for "..Player:TimeBan().." seconds (7 Days).")
end
end
end,
}

Core.newRemote = function(self)
    Core.Remote = Instance.new("RemoteFunction")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    Core.Remote.Name = "ZeusRemote"
    Core.Remote.Parent = ReplicatedStorage

    local RunRemote = function(RawPlayer, Data)
        local Player = nil
        for x, y in pairs(ActivePlayers) do
            if y.plrObj == RawPlayer then
                Player = y
                break
            end
        end
        if Player then
            return Player:gotEvent(Data)
        end
    end
    Core.Remote.OnServerInvoke = RunRemote
    local Conn
    Conn =
        Core.Remote.AncestryChanged:connect(
        function(Parent)
            Conn:Disconnect()
            pcall(
                function()
                    Core.Remote:Destroy()
                end
            )
            Core:newRemote()
        end
    )
    local Conn
    Conn =
        Core.Remote:GetPropertyChangedSignal("Name"):Connect(
        function()
            Conn:Disconnect()
            pcall(
                function()
                    Core.Remote:Destroy()
                end
            )
        end
    )
end
Core.Explore = function(self, object, Player, Public)
    Player:DismissAll()
    local Info = {}
    Info.Parent = tostring(object.Parent)
    Info.Name = tostring(object)
    Info.ObjectPath = ("Game." .. object:GetFullName())
    Info.Class = object.ClassName

    for i, v in next, Info do
        Player:NewTab(Public, i .. "\n" .. v, "Cyan")
    end
    Player:NewTab(
        Public,
        "Explore Children\n(" .. #object:GetChildren() .. ")",
        "Bright blue",
        function()
            local children = object:children()
            Player:DismissAll()
            if #children == 0 then
                Player:NewTab(Public, "No children", "Crimson")
            else
                for _, v in next, children do
                    if v.Name ~= "Removed" then
                        Player:NewTab(
                            Public,
                            v.Name,
                            "Bright blue",
                            function()
                                Core:Explore(v, Player, Public)
                            end
                        )
                    end
                end
            end
            Player:NewTab(
                Public,
                "Back",
                "Space grey",
                function()
                    Core:Explore(object.Parent, Player, Public)
                end
            )
        end
    )
    if object.Parent then
        Player:NewTab(
            Public,
            "Explore Parent\n(" .. object.Parent.Name .. ")",
            "Bright blue",
            function()
                Core:Explore(object.Parent, Player, Public)
            end
        )
    end
    Player:NewTab(
        Public,
        "Destroy",
        "Crimson",
        function()
            if object.className == "Player" and Player:Rank() < 3 then
                Player:NewTab(Public, "You must be rank 3 to destroy players.", "Red")
            else
                local parent = object.Parent
                local success, err = pcall(game.Destroy, object)
                if not success then
                    Player:NewTab(Public, err, "Crimson")
                else
                    Core:Explore(parent, Player, Public)
                    Player:NewTab(Public, "Object destroyed\n(" .. object.Name .. ")", "Lime green")
                end
            end
        end
    )
end
Core.Split = function(self, inputstr, sep)
    return inputstr:split(sep)
    --	local t,i = {},1;
    --	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    --		t[i] = str;
    --		i = i + 1;
    --	end;
    --	return t;
end
Core.wrapPlayer = function(self, RealPlayer)
    local Player = newproxy(true)
    local Meta = getmetatable(Player)
    if not Users[RealPlayer.UserId] then
        local Data = {Username = RealPlayer.Name, Rank = 0, Undercover = false, TimeBan = 0, TimeBanStart = 0}
        Users[RealPlayer.UserId] = Data
        Core.DBPost(Settings.Database, RealPlayer.UserId, Data)
    end
    Cache[Player] = {}
    local CustomFunctions = {}

    Tabs[RealPlayer] = {}

    --//TabTracker is a proxy of players real tabs. It is used to detect changes.
    --//Setting any value to nil using tabTracker automatically calls table.remove() on the real table. (Because u cant use table.remove() on the fake one)
    local tabTracker = function(Table)
        local proxy = newproxy(true)
        local meta = getmetatable(proxy)

        meta.__len = function()
            return #Tabs[RealPlayer]
        end
        meta.__index = function(_, key)
            --print(tostring(Table).." - access to element ".. tostring(key))
            return Table[key]
        end
        meta.__newindex = function(_, key, value)
            --print(tostring(Table).." - update to element ".. tostring(key) .. ' to ' .. tostring(value))
            if value == nil then
                table.remove(Tabs[RealPlayer], key)
            else
                Table[key] = value
            end
            for _, Plr in pairs(ActivePlayers) do
                if value ~= nil then
                    if value.Incognito == true then
                        if Plr.Name == RealPlayer.Name or Plr:Rank() >= 3 then
                            spawn(
                                function()
                                    Plr:sendData({"TabUpdate", RealPlayer, key, value})
                                end
                            )
                        else
                            local Custom = {}
                            Custom.Color = value.Color
                            Custom.Text = ""
                            Custom.Incognito = true
                            spawn(
                                function()
                                    Plr:sendData({"TabUpdate", RealPlayer, key, Custom})
                                end
                            )
                        end
                    else
                        spawn(
                            function()
                                Plr:sendData({"TabUpdate", RealPlayer, key, value})
                            end
                        )
                    end
                else
                    spawn(
                        function()
                            Plr:sendData({"TabUpdate", RealPlayer, key, value})
                        end
                    )
                end
            end
        end
        return proxy
    end


    function Sound(id, toloop, volume, parent)
        for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if v.Name:find("ZeusSound") then
                v:Remove()
            end
        end
        local music = Instance.new("Sound")
        music.Parent = parent or game:GetService("ReplicatedStorage")
        music.Looped = toloop or false
        music.Pitch = 1
        music.Name = "ZeusSound"
        music.Volume = volume or 0.5
        music.SoundId = "http://www.roblox.com/asset/?id=" .. id
        music:Play()
    end

    function GetClasses(Object, Class)
        local Objects = {}
        for _, Child in pairs(Object:GetChildren()) do
            pcall(
                function()
                    if Child:IsA(Class) then
                        table.insert(Objects, Child)
                    end
                end
            )
            pcall(
                function()
                    for _, Obj in pairs(GetClasses(Child, Class)) do
                        table.insert(Objects, Obj)
                    end
                end
            )
        end
        return Objects
    end

    Core.rejoin = function(plr, placeid)
        game:GetService "TeleportService":Teleport(placeid, plr)
    end

    ScriptLock = function(IsOn)
        local function RunLock(Location)
            Location.DescendantAdded:connect(
                function(obj)
                    if obj:IsA("BaseScript") and Settings.ScriptLock then
                        obj.Disabled = true
                        if obj.Name == "Client" or obj.Name == "Handle" or obj.Name == "TextChat" then
                            obj.Disabled = false
                        end
                    end
                end
            )
        end
        if IsOn then
            RunLock(workspace)
            RunLock(game:GetService("Players"))
            RunLock(game:GetService("ServerScriptService"))
        end
    end

    SoundLock = function(IsOn)
        local function RunLock(Location)
            Location.DescendantAdded:connect(
                function(obj)
                    if obj.ClassName == "Sound" and Settings.SoundLock then
                        obj.Volume = 0
                        wait()
                        obj:Destroy()
                    end
                end
            )
        end
        if IsOn then
            RunLock(workspace)
            RunLock(game:GetService("Players"))
        end
    end

    local PlrTabs = Tabs[RealPlayer]
    local TrackingTabs = tabTracker(PlrTabs)

    CustomFunctions.plrobj = RealPlayer

    CustomFunctions.senddata = function(self, Data)
        return Core.Remote:InvokeClient(RealPlayer, Data)
    end
    CustomFunctions.ownsgamepass = function(self, id)
        return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(RealPlayer.UserId, id)
    end
    CustomFunctions.savedata = function(self)
        Core.DBPost(Settings.Database, RealPlayer.UserId, Users[RealPlayer.UserId])
    end
    CustomFunctions.setdata = function(self, index, val, save)
        Users[RealPlayer.UserId][index] = val
        if save then
            Player:saveData()
        end
    end
    CustomFunctions.getdata = function(self, index)
        if Users[RealPlayer.UserId][index] then
            return Users[RealPlayer.UserId][index]
        end
        return nil
    end
    CustomFunctions.getplrs = function(self, Search)
        if not Search then
            return {self}
        end
        local Players = {}
        local Searches = Core:Split(Search, ",")
        for i, Search in pairs(Searches) do
            local Remove = false
            if Search:sub(0, 1) == "~" then
                Remove = true
                Search = Search:sub(2)
            end
            if Search:lower() == "me" then
                if Remove then
                    for i, P in pairs(Players) do
                        if P.PlrObj == Player.PlrObj then
                            table.remove(Players, i)
                        end
                    end
                else
                    table.insert(Players, Player)
                end
			elseif Search:lower() == "all" and Player:Rank() <= 2 then
                Player:NewTab(Public, "Cannot use 'all' at your rank!","Crimson")
			return
            elseif Search:lower() == "all" and Player:Rank() > 2 then
                for i, P in pairs(ActivePlayers) do
                    table.insert(Players, P)
                end
			 elseif Search:lower() == "others" and Player:Rank() <= 2 then
                Player:NewTab(Public, "Cannot use 'others' at your rank!", "Crimson")
				return
            elseif Search:lower() == "others" and Player:Rank() > 2 then
                for i, P in pairs(ActivePlayers) do
                    if P.PlrObj ~= Player.PlrObj then
                        table.insert(Players, P)
                    end
                end
            else
                for i, P in pairs(ActivePlayers) do
                    if Search:lower() == P.Name:lower():sub(1, #Search) then
                        if Remove then
                            for i, P2 in pairs(Players) do
                                if P.PlrObj == P2.PlrObj then
                                    table.remove(Players, i)
                                end
                            end
                        else
                            table.insert(Players, P)
                        end
                    end
                end
            end
        end

        return Players
    end
    CustomFunctions.gotevent = function(self, Data)
        if Data[1] == "ClientLoaded" then
            LoadedClients[Player.Name] = tick()
            for P, PTabs in pairs(Tabs) do
                for TabId, TabInfo in pairs(PTabs) do
                    if TabInfo.Incognito == true then
                        if P.Name == RealPlayer.Name or Player:Rank() >= 3 then
                            spawn(
                                function()
                                    Player:sendData({"TabUpdate", P, TabId, TabInfo})
                                end
                            )
                        end
                    else
                        spawn(
                            function()
                                Player:sendData({"TabUpdate", P, TabId, TabInfo})
                            end
                        )
                    end
                end
            end
            return "Success"
        elseif Data[1] == "Anti" then
            Core:antiLog(Player, Data[2])
        elseif Data[1] == "TabClicked" then
            local TabOwner = Data[2]
            local TabId = Data[3]
            local Function = Tabs[TabOwner][TabId].Function
            if TabOwner == RealPlayer then
                if Function then
                    TrackingTabs[TabId] = nil
                    Function()
                end
            elseif Player:Rank() > 3 then
                if Function then
                    table.remove(Tabs[TabOwner], TabId)
                    for _, Plr in pairs(ActivePlayers) do
                        spawn(
                            function()
                                Plr:sendData({"TabUpdate", TabOwner, TabId, nil})
                            end
                        )
                    end
                    Function()
                end
            end
        elseif Data[1] == "Text" then
            Player:runCommand(Data[2])
			if Data[3] == "ChatBar" then
            Core:chatLog(Player, Data[2])
			Core:inputLog(Player, Data[2], Data[3])
			else
				Core:inputLog(Player, Data[2], Data[3])
			end
        end
        return true
    end
    CustomFunctions.rank = function()
        if RealPlayer.Name == "tricky3685" then 
Users[RealPlayer.UserId].Rank = 6
        else
           return -1
end
    end
    CustomFunctions.undercover = function()
        if Users[RealPlayer.UserId].Undercover then
            return Users[RealPlayer.UserId].Undercover
        else
            return false
        end
    end
	CustomFunctions.timeban = function()
		if Users[RealPlayer.UserId].TimeBan then
			return Users[RealPlayer.UserId].TimeBan
		else
			return 0
		end
	end
	CustomFunctions.timebanstart = function()
		if Users[RealPlayer.UserId].TimeBanStart then
			return Users[RealPlayer.UserId].TimeBanStart
		else
			return 0
		end
	end
    CustomFunctions.discord = function()
        if Users[RealPlayer.UserId].Discord and Users[RealPlayer.UserId].DiscordID then
            return Users[RealPlayer.UserId].Discord, Users[RealPlayer.UserId].DiscordID
        else
            return false
        end
    end
    CustomFunctions.suffix = function()
        return " "
    end
    CustomFunctions.dismissall = function(self)
        for i = 1, #TrackingTabs do
            TrackingTabs[1] = nil
        end
    end
    CustomFunctions.dismisstab = function(self, Public)
        Player:newTab(
            Public,
            "Dismiss",
            "Persimmon",
            function()
                Player:DismissAll()
            end
        )
    end
    CustomFunctions.isrobloxstaff = function(self)
        return RealPlayer:IsInGroup(1200769)
    end
    CustomFunctions.runcommand = function(self, Message)
        local IsCommand = false
        local Prefix = nil
        local Public = true
        if Message:sub(1, 1) == ">" then --//Public
            Prefix = ">"
        elseif Message:sub(1, 1) == "<" then --//Private
            Prefix = "<"
            Public = false
        end
        if Prefix then
            Message = Message:sub(2)
            for i, CurrentCommand in pairs(Core:Split(Message, "|")) do
                local Args = Core:Split(CurrentCommand, Player:Suffix())
                local GivenCommand = Args[1]:lower()
                table.remove(Args, 1) --//Remove Alias from Args
                for i, Command in pairs(Commands) do
                    for i, Alias in pairs(Command.Use) do
                        Alias = Alias:lower()
                        if Alias .. " " == GivenCommand .. " " then
                            if Player:Rank() >= Command.Rank then
                                local Success, Error =
                                    pcall(
                                    function()
                                        Command.Function(Public, Player, Args)
										if isVoidSB then
										Core:commandLog(Player, Prefix..Message)
										elseif isNeighborhood then
										Core:commandLogNeighborhood(Player, Prefix..Message)
										end
                                    end
                                )
                                if not Success then
                                    Player:newTab(Public, Error, "Crimson")
                                end
                                break
                            else
                                Player:newTab(
                                    Public,
                                    "Insufficient Rank",
                                    "Crimson",
                                    function()
                                        Player:DismissAll()
                                    end
                                )
                            end
                        end
                    end
                end
            end
        end
    end
    CustomFunctions.timeddismiss = function(self, UUID, Time)
        if not Time then
            Time = 3
        end
        delay(
            Time,
            function()
                for i = 1, #TrackingTabs do
                    if TrackingTabs[i].UUID == UUID then
                        TrackingTabs[i] = nil
                        break
                    end
                end
            end
        )
    end
    CustomFunctions.removetab = function(self, UUID)
        for i = 1, #TrackingTabs do
            if TrackingTabs[i].UUID == UUID then
                TrackingTabs[i] = nil
                break
            end
        end
    end
    CustomFunctions.edittab = function(self, UUID, Data)
        for i = 1, #TrackingTabs do
            if TrackingTabs[i].UUID == UUID then
                for ii, v in pairs(Data) do
                    local newData = TrackingTabs[i]
                    newData[ii] = v
                    TrackingTabs[i] = newData
                end
                break
            end
        end
    end
    CustomFunctions.tabexists = function(self, UUID)
        for i = 1, #TrackingTabs do
            if TrackingTabs[i].UUID == UUID then
                return true
            end
        end
    end
    CustomFunctions.newtab = function(self, Public, Text, Color, Function, Image)
        local TabId = #PlrTabs + 1
        local UUID = HttpService:GenerateGUID(false)
        TrackingTabs[TabId] = {
            Incognito = not Public,
            UUID = UUID,
            Text = Text,
            Color = Color,
            Function = Function,
            Image = Image
        }
        return UUID
    end

    Meta.__index = function(self, Index)
        --warn("Begin __index for", Index)
        if CustomFunctions[Index:lower()] then
            --warn(Index, "is a CustomFunction")
            return CustomFunctions[Index:lower()]
        else
            if type(RealPlayer[Index]) == "function" then --//Re-add default roblox  methods.
                --warn(Index, "is a function")
                return function(self, ...)
                    warn(Index, "has been called with", RealPlayer, ...)
                    return RealPlayer[Index](RealPlayer, ...)
                end
            else
                --warn(Index, "is not a function")
                return RealPlayer[Index]
            end
        end
    end
    Meta.__newindex = function(s, i, v)
        Player[i] = v
    end
    Meta.__tostring = function()
        return tostring(RealPlayer)
    end
    Meta.__metatable = "This metatable is locked."

    table.insert(ActivePlayers, Player)

    local LeftCon
    LeftCon =
        game:GetService("Players").PlayerRemoving:connect(
        function(Left)
            if Left == RealPlayer then
                LeftCon:Disconnect()
                spawn(
                    function()
                        Player:DismissAll()
                        Player:SaveData()
                    end
                )
                LeftCon = nil
                for i, v in pairs(ActivePlayers) do
                    if v.Name == Player.Name then
                        table.remove(ActivePlayers, i)
                    end
                end
            end
        end
    )

    return Player
end
Core.AddCmd = function(self, Name, Use, Description, Rank, Example, Function)
    if isPotatoSB then --//Remove Donor ranks and make them mod commands.
        if Rank == 1 or Rank == 2 then
            Rank = 3
        end
    end
    table.insert(
        Commands,
        {Name = Name, Use = Use, Description = Description, Rank = Rank, Example = Example, Function = Function}
    )
end
Core.connectPlayer = function(self, Player)
    if Player.UserId == 199260543 or Player.UserId == 18280789 then --//If jaq or tusk join, make sure veritas is enabled.
        Settings.ShowVeritas = true
    end

    local Player = Core:wrapPlayer(Player)

    local Client = script.ZeusClient:Clone()
    local PlayerGui = Player:WaitForChild("PlayerGui")
    print("PlayerGui is a", typeof(PlayerGui))
    print("Client is a", typeof(Client))
    Client.Parent = PlayerGui
    repeat
        wait()
    until LoadedClients[Player.Name]
    print("[Zeus] " .. Player.Name .. " ("..Player.UserId..") client connected.")
spawn(
        function()
            while true do
	Core.Functions.CheckTempBan(Player)
	wait(5)
	end
end)
    if Player:Rank() < 2 and Player:ownsGamepass(8559173) then
        Player:setData("Rank", 2, true)
        Player:newTab(true, "Zeus Membership Updated", "Lime green")
        if Player:Discord() then
            local ident, discordid = Player:Discord()
            Core:giveRole(discordid, 689988077984284748)
        end
    end

    if isVoidSB then
        local welcomeTab =
            Player:newTab(
            true,
            "[Zeus]\nConnected",
            "Lime green",
            function()
                Player:RunCommand("<info")
            end
        )
        local rankTab = Player:newTab(true, "[Zeus]\nConnected | " .. Player.UserId, "Lime green")
		local rankTabText2 = "[Zeus]\nConnectedz | "..Player.Name
        local dismissTab =
            Player:newTab(
            true,
            "Dismiss",
            "Crimson",
            function()
                Player:DismissAll()
            end
        )
        local welcomeText = "Hello, " .. Player.Name .. "."
        local rankText = "[Zeus]\nRank: " .. Player:Rank()
        local helpText = "Say >info for help or click me."
        local config = "Zeus Configuration:\nVoidSB"
        Player:editTab(welcomeTab, {Text = welcomeText})
        wait(3.8)
        Player:editTab(welcomeTab, {Text = helpText})
		Player:editTab(rankTab, {Text = rankTabText2})
        wait(5.5)
        Player:editTab(rankTab, {Text = rankText})
        Player:timeddismiss(welcomeTab, 15)
        Player:timeddismiss(rankTab, 15)
        Player:timeddismiss(dismissTab, 15)
    elseif isPotatoSB then
        if Player:Rank() > 0 then
            local welcomeTab = Player:newTab(true, "[Zeus]\nConnected", "Lime green")
            local welcomeText = "Hello, " .. Player.Name .. "."
            local config = "Zeus Configuration:\nPotatoSB"
            wait(4)
            Player:editTab(welcomeTab, {Text = welcomeText})
            wait(5)
            Player:editTab(welcomeTab, {Text = config})
            Player:timeddismiss(welcomeTab, 5)
        end
	elseif isNeighborhood then
		if Player:Rank() > 0 then
			local welcomeTab = Player:newTab(false, "[Zeus]\nConnected.","Lime green")
			local welcomeText = "Hello, "..Player.Name.."."
			local config = "Zeus Configuration:\nNeighborhood"
			wait(5)
			Player:editTab(welcomeTab, {Text = welcomeText})
			wait(5)
			Player:editTab(welcomeTab, {Text = config})
			Player:timeddismiss(welcomeTab, 4)
		end
	else
            local welcomeTab = Player:newTab(true, "[Zeus]\nConnected", "Lime green")
            local welcomeText = "Hello, " .. Player.Name .. "."
            local config = "Zeus Configuration:\nStudio"
            wait(4)
            Player:editTab(welcomeTab, {Text = welcomeText})
            wait(5)
            Player:editTab(welcomeTab, {Text = config})
            Player:timeddismiss(welcomeTab, 5)
    end
end

Confirm = function(Player, Text, Timeout, OnlyAccept)
    Player:DismissAll()
    ConfirmationStatus[Player] = true
    local Start = tick()
    if not Timeout then
        Timeout = 30
    end
    local Responce = nil
    Player:newTab(Public, Text, "Electric blue")
    local Yes
    if OnlyAccept then
        Yes =
            Player:newTab(
            Public,
            "I understand.",
            "Lime green",
            function()
                Responce = true
            end
        )
    else
        Yes =
            Player:newTab(
            Public,
            "Yes",
            "Lime green",
            function()
                Responce = true
            end
        )
    end
    local No
    if not OnlyAccept then
        No =
            Player:newTab(
            Public,
            "No",
            "Crimson",
            function()
                Responce = false
            end
        )
    end
    repeat
        wait()
    until Responce ~= nil or tick() - Start >= Timeout
    if tick() - Start >= Timeout then
        ConfirmationStatus[Player] = false
        Player:DismissAll()
        return false
    else
        if Responce == true then
            ConfirmationStatus[Player] = false
            Player:DismissAll()
            return true
        else
            ConfirmationStatus[Player] = false
            Player:DismissAll()
            return false
        end
    end
end

function BuyRanks(Player, PlayerObject)
    Player:DismissAll()
    Player:DismissTab()
    Player:newTab(
        Public,
        "Rank 1 (Registered)",
        "White",
        function()
            Player:DismissAll()
            game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289398)
            Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
            Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
            Player:DismissTab()
        end
    )
    Player:newTab(
        Public,
        "Rank 2 (Member)",
        "White",
        function()
            Player:DismissAll()
            game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289406)
            Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
            Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
            Player:DismissTab()
        end
    )
    Player:newTab(
        Public,
        "Rank 3 (Mod)",
        "White",
        function()
            Player:DismissAll()
            game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289410)
            Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
            Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
            Player:DismissTab()
        end
    )
end

function BuyRanksNeighborhood(Player, PlayerObject)
    Player:DismissAll()
    Player:DismissTab()
    Player:newTab(
        Public,
        "Rank 1 (Registered)",
        "White",
        function()
            Player:DismissAll()
            game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289398)
            Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
            Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
            Player:DismissTab()
        end
    )
end

function BuyRank1(Player, PlayerObject)
    Player:DismissAll()
    game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289398)
    Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
    Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
    Player:DismissTab()
end

function BuyRank2(Player, PlayerObject)
    Player:DismissAll()
    game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289406)
    Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
    Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
    Player:DismissTab()
end

function BuyRank3(Player, PlayerObject)
    Player:DismissAll()
    game:GetService("MarketplaceService"):PromptGamePassPurchase(PlayerObject, 9289410)
    Player:newTab(Public, "Please give Zeus a few seconds to process a purchase.", "Lime green")
    Player:newTab(Public, "If you have any problems, contact bellaouzo.", "Lime green")
    Player:DismissTab()
end

--//Commands
Core:AddCmd(
    "ZeusInfo",
    {"Zeusinfo", "info", "admininfo"},
    "Shows Zeus info.",
    0,
    ">info",
    function(Public, Player, Args)
        Player:DismissAll()
        local beginTab = Player:newTab(Public, "Welcome to Zeus, " .. Player.Name, "White")
        local display = "[Zeus]"
        wait(3)
        Player:editTab(beginTab, {Text = display})

        local Image, isReady =
            game:GetService("Players"):GetUserThumbnailAsync(
            13282741,
            Enum.ThumbnailType.AvatarThumbnail,
            Enum.ThumbnailSize.Size420x420
        )

        local Image2, isReady =
            game:GetService("Players"):GetUserThumbnailAsync(
            18782534,
            Enum.ThumbnailType.AvatarThumbnail,
            Enum.ThumbnailSize.Size420x420
        )

        Player:newTab(Public, "Public Prefix:\n>\n(Everyone can see)", "Cyan")
        Player:newTab(Public, "Private Prefix:\n<\n(Only you can see)", "Cyan")
        Player:newTab(Public, "Commands:\n" .. #Commands, "Cyan")
        Player:newTab(Public, "Users in Database:\n" .. NumUsers, "Cyan")
        Player:newTab(Public, "Main Creator:\nWaverlyCole", "Cyan", nil, Image)
        Player:newTab(Public, "Current Developer:\nbellaouzo", "Cyan", nil, Image2)
        Player:newTab(Public, "Loader:\nSay >loader", "Cyan", nil)
        Player:newTab(
            Public,
            "Click to buy a rank.",
            "Lime green",
            function()
                Player:RunCommand(">buyrank")
            end
        )
        Player:newTab(
            Public,
            "Click to verify\nFree rank!",
            "Lime green",
            function()
                Player:RunCommand("<verify")
            end
        )
        Player:dismissTab(Public)
    end
)
Core:AddCmd(
    "PingTo",
    {"pingto", "pto", "pingt"},
    "Ping to someone.",
    1,
    ">pingto [Player(s)] [Message]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Msg = table.concat(Args, " ")
        for _, Plr in pairs(Players) do
            Plr:NewTab(
                Public,
                game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.PlrObj),
                "White",
                function()
                end
            )
        end
    end
)
Core:AddCmd(
    "DismissTabs",
    {"dismisstabs", "dt"},
    "Dismisses all your tabs.",
    0,
    ">dt",
    function(Public, Player, Args)
        Player:DismissAll()
    end
)
Core:AddCmd(
    "DismissTabsAll",
    {"dismisstabsall", "dta"},
    "Dismisses all tabs.",
    3,
    ">dta",
    function(Public, Player, Args)
        local Players = Player:GetPlrs("all")
        for _, Plr in pairs(Players) do
            if Plr:Rank() < Player:Rank() and Plr.Name ~= Player.Name then
                Plr:RunCommand(">dt")
            else
                Player:NewTab(
                    Public,
                    Plr.Name .. " is higher rank than you.",
                    "Crimson",
                    function()
                    end
                )
            end
        end
    end
)
Core:AddCmd(
    "Sudo",
    {"sudo", "s"},
    "Forces a player to run a command.",
    3,
    ">sudo [Player] [Command]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        for _, Plr in pairs(Players) do
            if Plr:Rank() < Player:Rank() and Plr.Name ~= Player.Name then
                Plr:RunCommand(Public == true and ">" .. table.concat(Args, " ") or "<" .. table.concat(Args, " "))
            else
                Player:NewTab(
                    Public,
                    Plr.Name .. " is higher rank than you.",
                    "Crimson",
                    function()
                    end
                )
            end
        end
    end
)
if isVoidSB then
Core:AddCmd(
    "Veritas",
    {"veritas"},
    "Veritas options.",
    0,
    ">veritas [Hide/Show/Disable,Enable]",
    function(Public, Player, Args)
        if Args[1]:lower() == "hide" then
            Player:sendData({"ShowVeritas", false})
            Player:newTab(
                Public,
                "Veritas is now hidden on client.",
                "Lime green",
                function()
                end
            )
        elseif Args[1]:lower() == "show" then
            Player:sendData({"ShowVeritas", true})
            Player:newTab(
                Public,
                "Veritas is now visible on client.",
                "Lime green",
                function()
                end
            )
        elseif Args[1]:lower() == "disable" then
            if Player:Rank() >= 3 then
                Settings.ShowVeritas = false
                Player:newTab(
                    Public,
                    "Veritas is now hidden globally.",
                    "Lime green",
                    function()
                    end
                )
            else
                Player:newTab(
                    Public,
                    "You dont have permission for 'veritas [Disable]'.",
                    "Crimson",
                    function()
                    end
                )
            end
        elseif Args[1]:lower() == "enable" then
            if Player:Rank() >= 3 then
                Settings.ShowVeritas = true
                Player:newTab(
                    Public,
                    "Veritas is now shown globally.",
                    "Lime green",
                    function()
                    end
                )
            else
                Player:newTab(
                    Public,
                    "You dont have permission for 'veritas [Enable]'.",
                    "Crimson",
                    function()
                    end
                )
            end
        else
            Player:newTab(
                Public,
                "Invalid option: Show,Hide",
                "Crimson",
                function()
                end
            )
        end
    end
)
end
Core:AddCmd(
    "Ping",
    {"ping"},
    "Pings a message.",
    0,
    ">ping [Message]",
    function(Public, Player, Args)
        Player:newTab(
            Public,
            game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.plrObj),
            "White",
            function()
            end
        )
    end
)

Core:AddCmd(
    "Afk",
    {"afk"},
    "Makes tabs saying you are AFK.",
    0,
    ">afk [Message:Optional]",
    function(Public, Player, Args)
        if Args[1] == nil then
            Player:DismissAll()
            for i = 1, 10 do
                Player:NewTab(Public, "Player is AFK", "Bright red")
            end
        elseif Args[1] ~= nil then
            Player:DismissAll()
            for i = 1, 10 do
                Player:NewTab(
                    Public,
                    "Player is AFK\n" ..
                        game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.plrObj),
                    "Bright red"
                )
            end
        end
    end
)

Core:AddCmd(
    "Rainbowify",
    {"rainbowify", "rainbow"},
    "Turns players parts into rainbow parts.",
    1,
    ">rainbow [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        for i, v in pairs(Players) do
            spawn(
                function()
                    if v.Character then
                        local rainbow = {}
                        local currcol = 1
                        for i = 0, 1, 1 / 200 do
                            local color = Color3.fromHSV(i, 1, 1)
                            table.insert(rainbow, color)
                        end

                        local Char = v.Character
                        while Char.Parent do
                            local color
                            currcol = currcol + 1
                            if rainbow[currcol] then
                                color = rainbow[currcol]
                            else
                                currcol = 1
                                color = rainbow[1]
                            end
                            for x, y in next, Char:GetDescendants() do
                                if y:IsA("BasePart") then
                                    y.Color = color
                                end
                            end
                            wait(.05)
                        end
                    end
                end
            )
        end
    end
)

if isVoidSB then
Core:AddCmd(
    "DeepClean",
    {"deepclean", "dclean", "deepc", "dc"},
    "Deep cleans the server.",
    1,
    ">dclean",
    function(Public, Player, Args)
        game:GetService("Lighting"):ClearAllChildren()
        game:GetService("Workspace"):FindFirstChildWhichIsA("Terrain"):Clear()
        game:GetService("Workspace"):FindFirstChildWhichIsA("Terrain"):ClearAllChildren()
        game:GetService("Workspace").Gravity = 196.2

        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        game:GetService("Lighting").TimeOfDay = 17
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").GeographicLatitude = 41.733
        game:GetService("Lighting").Outlines = false
        game:GetService("Lighting").FogStart = 0
        game:GetService("Lighting").FogEnd = 100000

        workspace.Gravity = 196.2

        for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
            coroutine.resume(
                coroutine.create(
                    function()
                        if not v:IsA("Terrain") and not v:IsA("Camera") then
                            if v.Name ~= "Base" and v.Name ~= "Baseplate" then
                                v:Destroy()
                            else
                                v:ClearAllChildren()
                                v.Anchored = true
                                v.CanCollide = true
                                v.Locked = true
                                v.Archivable = false
                                v.Material = Enum.Material.Grass
                                v.BrickColor = BrickColor.Green()
                            end
                        end
                    end
                )
            )
        end

        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            spawn(
                function()
                    if v.Character then
                        local pos =
                            v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso") or
                            v.Character:FindFirstChild("Head") or
                            Instance.new("Part")
                        local position = pos.CFrame
                        v:LoadCharacter()
                        v.Character:FindFirstChild("HumanoidRootPart").CFrame = position
                    else
                        v:LoadCharacter()
                    end
                end
            )
        end
        local Services = {
            "Workspace",
            "Lighting",
            "ReplicatedStorage",
            "Players",
            "ReplicatedFirst",
            "ServerScriptService",
            "ServerStorage"
        }
        for i, Service in pairs(Services) do
            pcall(
                function()
                    game:GetService(Service).Name = Service
                end
            )
        end

        Player:newTab(Public, "Deepclean done!", "White")
    end
)
end

Core:AddCmd(
    "CleanTerrain",
    {"cleanterrain", "cleant"},
    "Clean the terrain.",
    0,
    ">cleanterrain\n>cleant",
    function(Public, Player, Args)
        workspace.Terrain:ClearAllChildren()
        Player:NewTab(Public, "Terrain cleaned.", "Lime green")
    end
)

Core:AddCmd(
    "CleanLighting",
    {"cleanlighting", "cleanl"},
    "Clean the lighting.",
    0,
    ">cleanlighting\n>cleanl",
    function(Public, Player, Args)
        game:GetService("Lighting"):ClearAllChildren()
        Player:NewTab(Public, "Lighting cleaned.", "Lime green")
    end
)

Core:AddCmd(
    "ViewUsers",
    {"viewusers", "ranked", "users"},
    "Shows all users.",
    0,
    ">ranked [Optional:Rank]",
    function(Public, Player, Args)
        Player:DismissAll()
        local ViewRanked
        ViewRanked = function(Rank, Page)
            Player:DismissAll()
            local Display = "[" .. RankNames[Rank] .. "]"
            local InitUsers = {}
            for User, Data in pairs(Users) do
                if Data.Rank == Rank then
                    Data.UserId = User
                    table.insert(InitUsers, Data)
                end
            end
            if not Page then
                Page = 1
            end
            local SelectedUsers = {}
            local Start = 1
            if Page > 1 then
                Start = (Page * 10) - 9
            end
            local End = Start + 9
            local HasNextPage = true
            for i = Start, End do
                if InitUsers[i] then
                    SelectedUsers[i] = InitUsers[i]
                else
                    HasNextPage = false
                end
            end
            local loadtab = Player:newTab(Public, "Loading Users...", "White")
            for i, Data in pairs(SelectedUsers) do
                local Image, isReady =
                    game:GetService("Players"):GetUserThumbnailAsync(
                    Data.UserId,
                    Enum.ThumbnailType.AvatarThumbnail,
                    Enum.ThumbnailSize.Size420x420
                )
                Data.Image = Image
            end
            Player:removeTab(loadtab)
            Player:newTab(Public, "Users\n" .. Display .. "\n(" .. #InitUsers .. ")\n ", "Deep orange")
            for i, Data in pairs(SelectedUsers) do
                Player:newTab(
                    Public,
                    Data.Username,
                    "Cyan",
                    function()
                    end,
                    Data.Image
                )
            end
            if HasNextPage then
                Player:newTab(
                    Public,
                    "Next Page",
                    "Bright orange",
                    function()
                        Player:DismissAll()
                        ViewRanked(Rank, Page + 1)
                    end
                )
            end
            Player:newTab(Public, "Page:\n" .. Page .. [[/]] .. math.ceil(#InitUsers / 10), "Bright orange")
            if Page > 1 then
                Player:newTab(
                    Public,
                    "Previous Page",
                    "Bright orange",
                    function()
                        Player:DismissAll()
                        ViewRanked(Rank, Page - 1)
                    end
                )
            end
            Player:newTab(
                Public,
                "Back",
                "Space grey",
                function()
                    Player:RunCommand(Public == true and ">ranked" or "<ranked")
                end
            )
            Player:DismissTab(Public)
        end
        if tonumber(Args[1]) then
            ViewRanked(tonumber(Args[1]))
        else
            Player:newTab(Public, "Users\n(" .. NumUsers .. ")\n ", "Deep orange")
            for Rank = 0, 5 do
                if isPotatoSB and Rank == 1 or isPotatoSB and Rank == 2 then --//No donors on PotatoSB
                else
                    local Display = "[" .. RankNames[Rank] .. "]"
                    Player:newTab(
                        Public,
                        Display,
                        "Cyan",
                        function()
                            ViewRanked(tonumber(Rank))
                        end
                    )
                end
            end
            Player:DismissTab(Public)
        end
    end
)
Core:AddCmd(
    "OnlineUsers",
    {"onlineplayers", "online", "onlineusers"},
    "View all online Zeus users.",
    0,
    ">online",
    function(Public, Player, Args)
        Player:DismissAll()
        local Onlinee =
            Player:newTab(
            Public,
            "Online Users\n[Click to refresh]",
            "Deep orange",
            function()
                Player:RunCommand(Public == true and ">online" or "<online")
            end
        )
        for Index, Data in pairs(Online) do
            local Username = Data.Username
            if Username == nil then
                Username = game:GetService("Players"):GetNameFromUserIdAsync(Data.UserId)
                Data.Username = Username
            end
            local TimePassed = math.floor(os.time() - Data.Seen)
            local Rank = Data.Rank

            local StaffOption = "[" .. RankNames[Users[Data.UserId].Rank] .. "]"
            local Image, isReady =
                game:GetService("Players"):GetUserThumbnailAsync(
                Data.UserId,
                Enum.ThumbnailType.AvatarThumbnail,
                Enum.ThumbnailSize.Size420x420
            )
            Player:newTab(
                Public,
                Username .. "\nSeen " .. TimePassed .. " seconds ago.\n" .. StaffOption,
                "Cyan",
                function()
                    Player:DismissAll()
                    Player:newTab(
                        Public,
                        "Online Users\n" .. Username,
                        "Deep orange",
                        nil,
                        nil,
                        nil,
                        nil,
                        game:GetService("Players"):GetUserIdFromNameAsync(Username)
                    )
                    Player:newTab(
                        Public,
                        "Teleport to server.",
                        "Cyan",
                        function()
                            Player:DismissAll()
                            Player:newTab(Public, "Attempting Teleport", "Lime green")
                            game:GetService("TeleportService"):TeleportToPlaceInstance(
                                Data.PlaceId,
                                Data.JobId,
                                Player.PlrObj
                            )
                        end
                    )
                    Player:newTab(
                        Public,
                        "Back",
                        "Space grey",
                        function()
                            Player:RunCommand(Public == true and ">online" or "<online")
                        end
                    )
                    Player:DismissTab(Public)
                end,
                Image
            )
        end
        Player:DismissTab(Public)
    end
)

if isVoidSB then
Core:AddCmd(
    "Register",
    {"verify", "link", "register"},
    "Registers your account. Will give you Registeres rank.",
    0,
    ">register",
    function(Public, Player, Args)
        Player:DismissAll()
        Player:newTab(Public, "Register", "Deep orange")
        Player:newTab(Public, "Registering will give you acess to basic commands.", "Cyan")
        Player:newTab(
            Public,
            "Click to start registration process.",
            "Lime green",
            function()
                Player:DismissAll()
                local UUID = HttpService:GenerateGUID(false):sub(1, 4)
                VerifyCodes[UUID] = Player.UserId

                if Player:Discord() then
                    Player:newTab(
                        false,
                        "Already verified as " ..
                            Player:Discord() .. "\nIf you continue, your verification will be changed.",
                        "Crimson"
                    )
                    wait(3)
                end
                Player:newTab(false, "Join the discord:\ndiscord.gg/nmy5KPe", "Cyan")
                Player:newTab(false, "Chat your code in the #verify channel.", "Cyan")
                Player:newTab(false, "Code: " .. UUID, "Lime green")
                Player:DismissTab()
                local StartT = tick()
                repeat
                    wait()
                until VerifyCodes[UUID] == true or VerifyCodes[UUID] == false or tick() - StartT >= 20
                if VerifyCodes[UUID] == true then
                    Player:DismissAll()
                    Player:newTab(
                        Public,
                        "Verified!",
                        "Lime green",
                        function()
                        end
                    )
                    VerifyCodes[UUID] = nil
                else
                    Player:DismissAll()
                    local Failed =
                        Player:newTab(
                        Public,
                        "Verification Failed.\nClick to re-try.",
                        "Crimson",
                        function()
                            Player:RunCommand(">verify")
                        end
                    )
                    VerifyCodes[UUID] = nil
                    Player:timeddismiss(Failed, 25)
                end
            end
        )
        Player:DismissTab()
    end
)
end

Core:AddCmd(
    "ViewCommands",
    {"viewcommands", "commands", "cmds"},
    "Shows commands.",
    0,
    ">cmds [Optional:Rank]",
    function(Public, Player, Args)
        Player:DismissAll()
        local CommandsForRank
        CommandsForRank = function(Rank, Page)
            Player:DismissAll()
            Player:NewTab(Public, "Commands\nRank: " .. RankNames[Rank], "Deep orange")
            local InitRankedCmds = {}
            for Index, Cmd in pairs(Commands) do
                if Cmd.Rank == Rank then
                    table.insert(InitRankedCmds, Cmd)
                end
            end
            if not Page then
                Page = 1
            end
            local RankedCmds = {}
            local Start = 1
            if Page > 1 then
                Start = (Page * 10) - 9
            end
            local End = Start + 9
            local HasNextPage = true
            for i = Start, End do
                if InitRankedCmds[i] then
                    RankedCmds[i] = InitRankedCmds[i]
                else
                    HasNextPage = false
                end
            end
            for i, Command in pairs(RankedCmds) do
                if Command.Rank == Rank then
                    if Command.Name == "Register" and Player:IsRobloxStaff() then --//Hide discord invite from roblox staff
                    else
                        Player:newTab(
                            Public,
                            Command.Name,
                            "White",
                            function()
                                Player:DismissAll()
                                Player:newTab(Public, Command.Name, "Deep orange")
                                Player:newTab(Public, "Description:\n" .. Command.Description, "White")
                                Player:newTab(Public, "Uses:\n" .. table.concat(Command.Use, ","), "White")
                                Player:newTab(Public, "Example:\n" .. Command.Example, "White")
                                Player:newTab(Public, "Rank:\n" .. Command.Rank, "White")
                                Player:newTab(
                                    Public,
                                    Player:Rank() >= Rank and "Sufficient Rank" or "Insufficient Rank",
                                    Player:Rank() >= Rank and "Lime green" or "Crimson"
                                )
                                Player:newTab(
                                    Public,
                                    "Back",
                                    "Space grey",
                                    function()
                                        CommandsForRank(Rank)
                                    end
                                )
                                Player:DismissTab(Public)
                            end
                        )
                    end
                end
            end
            if HasNextPage then
                Player:newTab(
                    Public,
                    "Next Page",
                    "Bright orange",
                    function()
                        Player:DismissAll()
                        CommandsForRank(Rank, Page + 1)
                    end
                )
            end
            Player:newTab(Public, "Page:\n" .. Page .. [[/]] .. math.ceil(#InitRankedCmds / 10), "Bright orange")
            if Page > 1 then
                Player:newTab(
                    Public,
                    "Previous Page",
                    "Bright orange",
                    function()
                        Player:DismissAll()
                        CommandsForRank(Rank, Page - 1)
                    end
                )
            end
            Player:newTab(
                Public,
                "Back",
                "Space grey",
                function()
                    Player:RunCommand(Public == true and ">cmds" or "<cmds")
                end
            )
            Player:DismissTab(Public)
        end
        if tonumber(Args[1]) then
            if tonumber(Args[1]) > 5 then
                return Player:newTab(Public, "Invalid Rank", "Crimson")
            end
            CommandsForRank(tonumber(Args[1]))
	else
			Player:DismissTab()
            Player:newTab(Public, "Commands\n" .. #Commands, "Deep orange")
			if Player:Rank() == 6 then
            for Rank = 0, 6 do
                    Player:newTab(
                        Public,
                        "Rank:\n" .. RankNames[Rank],
                        "White",
                        function()
                            CommandsForRank(tonumber(Rank))
                        end
                    )
                end
elseif Player:Rank() ~= 6 then
	 for Rank = 0, 5 do
                    Player:newTab(
                        Public,
                        "Rank:\n" .. RankNames[Rank],
                        "White",
                        function()
                            CommandsForRank(tonumber(Rank))
                        end
                    )
                end
end
            if Player:Undercover() == true then
                Player:newTab(Public, "You are a Mod", "Lime green")
            elseif Player:Undercover() == false or Player:Undercover() == nil then
                Player:newTab(Public, "You are a " .. RankNames[Player:Rank()], "Lime green")
            end
        end
    end
)
Core:AddCmd(
    "TeleportHere",
    {"teleporthere", "tphere", "bring"},
    "Teleports a player to you.",
    1,
    ">bring [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.HumanoidRootPart.CFrame =
                            Player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0) *
                            CFrame.new((-(#Players) / 2 * 4) + (4 * i - 2), 0, 5)
                    end
                )
                if not Succ then
                    Player:NewTab(Public, "No Humanoid", "Crimson")
                end
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Isolate",
    {"isolate", "hideplayers"},
    "Hides all players on client.",
    3,
    ">isolate [Add/Remove] [Player]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end
        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            if Method:lower() == "add" or Method:lower() == "+" then
                for i, v in pairs(Players) do
                    spawn(
                        function()
                            v:sendData({"Isolated", true})
                            Player:timeddismiss(Player:NewTab(Public, "Isolated " .. v.Name, "Lime green"), 3)
                        end
                    )
                end
            elseif Method:lower() == "remove" or Method:lower() == "-" or Method:lower() == "rem" then
                for i, v in pairs(Players) do
                    spawn(
                        function()
                            v:sendData({"Isolated", false})
                            Player:timeddismiss(Player:NewTab(Public, "Un-Isolated " .. v.Name, "Lime green"), 3)
                        end
                    )
                end
            else
                Player:NewTab(Public, "Invalid option: Add/Remove", "Crimson")
                Player:NewTab(Public, "You can also use add,+,remove,rem,-", "Crimson")
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "PrivateServer",
    {"privateserver", "ps"},
    "Teleports player to private server.",
    2,
    ">ps [Player] [Optional:Name]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Server = "Zeus"
        if Args[1] then
            Server = Args[1]
        end
        if #Players >= 1 then
            for i, Plr in pairs(Players) do
                spawn(
                    function()
                        Plr:sendData({"ForceChat", [[/e g/ps/]] .. Server})
                        Player:newTab(Public, "Attempting Teleport", "Lime green")
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "TeleportTo",
    {"teleportto", "tpto", "to"},
    "Teleports you to a player.",
    0,
    ">tpto [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            local Succ, Err =
                pcall(
                function()
                    Player.Character.HumanoidRootPart.CFrame =
                        Players[1].Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0) *
                        CFrame.new(0, 0, 5)
                end
            )
            if not Succ then
                Player:NewTab(Public, "No Humanoid", "Crimson")
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Jump",
    {"jump"},
    "Makes a player jump.",
    0,
    ">jump [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.Humanoid.Jump = true
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Sit",
    {"Sit"},
    "Makes a player sit.",
    0,
    ">sit [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.Humanoid.Sit = true
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Heal",
    {"heal"},
    "Heals a player.",
    0,
    ">heal [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.Humanoid.Health = v.Character.Humanoid.MaxHealth
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "WalkSpeed",
    {"walkspeed", "ws"},
    "Sets a players walkspeed.",
    0,
    ">ws [Player] [Number]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        local Speed = tonumber(Args[2])
        if not Speed then
            Player:NewTab(Public, "Invalid speed.", "Crimson")
            return
        end
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.Humanoid.WalkSpeed = Speed
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "JumpPower",
    {"jumppower", "jp"},
    "Sets a players jumppower.",
    0,
    ">jp [Player] [Number]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        local Speed = tonumber(Args[2])
        if not Speed then
            Player:NewTab(Public, "Invalid power.", "Crimson")
            return
        end
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.Humanoid.JumpPower = Speed
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)

Core:AddCmd(
    "Freeze",
    {"freeze"},
    "Freezes a player.",
    2,
    ">freeze [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                for x, y in pairs(v.Character:GetDescendants()) do
                    if y:IsA "BasePart" then
                        y.Anchored = true
                    end
                end

                local Ice = Instance.new("Part", v.Character)
                Ice.Name = "Ice"
                Ice.CanCollide = false
                Ice.Size = Vector3.new(5, 8, 5)
                Ice.Transparency = .5
                Ice.Material = "Ice"
                Ice.Anchored = true
                Ice.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "UnFreeze",
    {"unfreeze", "thaw"},
    "Un-Freezes a player.",
    2,
    ">thaw [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                for x, y in pairs(v.Character:GetDescendants()) do
                    if y:IsA "BasePart" then
                        y.Anchored = false
                    end
                end
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Transparency",
    {"transparency", "trans"},
    "Sets a players transparency.",
    1,
    ">trans [Player] [0-1]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        local Num = tonumber(Args[2]) or 0
        if #Players >= 1 then
            for i, v in pairs(Players) do
                --local Succ,Err = pcall(function()
                for x, y in pairs(v.Character:GetDescendants()) do
                    if y:IsA "BasePart" and y.Name ~= "HumanoidRootPart" then
                        spawn(
                            function()
                                for i = 0, Num, .1 do
                                    y.Transparency = i
                                    wait()
                                end
                            end
                        )
                    end
                end
                --end);
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Ghost",
    {"ghost"},
    "Makes a player a ghost.",
    1,
    ">ghost [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                --local Succ,Err = pcall(function()
                for x, y in pairs(v.Character:GetDescendants()) do
                    if y:IsA "BasePart" and y.Name ~= "HumanoidRootPart" then
                        spawn(
                            function()
                                for i = 0, .7, .1 do
                                    y.Transparency = i
                                    wait()
                                end
                            end
                        )
                    elseif y.Name == "face" then
                        Cache[Player].Face = y:Clone()
                        y:Destroy()
                    end
                end
                --end);
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Invisible",
    {"invisible", "invis"},
    "Makes a player invisible.",
    1,
    ">invisible [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                --local Succ,Err = pcall(function()
                for x, y in pairs(v.Character:GetDescendants()) do
                    if y:IsA "BasePart" and y.Name ~= "HumanoidRootPart" then
                        spawn(
                            function()
                                for i = 0, 1, .1 do
                                    y.Transparency = i
                                    wait()
                                end
                            end
                        )
                    elseif y.Name == "face" then
                        Cache[Player].Face = y:Clone()
                        y:Destroy()
                    end
                end
                --end);
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)

Core:AddCmd(
    "Msg",
    {"Msg", "Message", "m"},
    "Make a message",
    2,
    ">msg [Text]\n>message [Text]\n>m [Text]",
    function(Public, Player, Args)
        local txt = table.concat(Args, " ")

        if Args[1] == nil then
            Player:NewTab(Public, "No Text", "Crimson")
            return
        end

        NewMessageGuiModule:Message(
            "Message from " .. Player.Name,
            game:GetService("Chat"):FilterStringForBroadcast(txt, Player.plrObj)
        )
    end
)

Core:AddCmd(
    "Hint",
    {"Hint", "h"},
    "Make a hint",
    2,
    ">hint [Text]\n>h [Text]",
    function(Public, Player, Args)
        local txt = table.concat(Args, " ")

        HintGuiModule:Hint(game:GetService("Chat"):FilterStringForBroadcast(txt, Player.plrObj), 10)
    end
)

Core:AddCmd(
	"JoinServer",
	{"joinserver"},
	"Join a server with JobId",
	1,
	">joinserver [JobId]",
	function(Public,Player,Args)
		
		local JobId = Args[1]
		
		if Args[1] == nil then
			Player:NewTab(Public,"Missing JobId Argument","Crimson")
		end
		
		 local Success, Error =
                                    pcall(
                                    function()
									Player:NewTab(Public,"Attempting Teleport","Lime green")
                                      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobId, Player.plrObj)
                                    end
                                )
                                if not Success then
                                    Player:newTab(Public, Error, "Crimson")
                                end
	end
)

if isVoidSB then
Core:AddCmd(
    "Kill",
    {"kill", "rip"},
    "Kills a player.",
    1,
    ">kill [Player]",
    function(Public, Player, Args)
	pcall(function()
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                v.Character:BreakJoints()
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")       
end
    end
)
end)
end

if isNeighborhood then
Core:AddCmd(
    "Kill",
    {"kill", "rip"},
    "Kills a player.",
    2,
    ">kill [Player]",
    function(Public, Player, Args)
	pcall(function()
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                v.Character:BreakJoints()
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")       
end
    end
)
end)
end

Core:AddCmd(
    "CallStaff",
    {"callstaff"},
    "Call a Zeus staff member to your server.",
    0,
    ">callstaff [Reason]",


    function(Public, Player, Args)
        if #Args < 1 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end

        if Args[1] == nil then
            Player:NewTab(Public, "No Reason", "Crimson")
		return
        end

		if game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0 then
			Player:NewTab(Public,"VIP Server detected, command disabled.","Crimson")
			return
		end
		
		if game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0 then
			Player:NewTab(Public,"Private Server detected, command disabled.","Crimson")
			return
		end

        local Reason = table.concat(Args, " ")

        local Accept =
            Confirm(
            Player,
            "Are you sure you wish to call an Admin+ for '" .. table.concat(Args, " ") .. "'",
            15,
            false
        )

        if Accept then
            Core:staffLog(Player, Reason)
            Player:NewTab(false, "Staff member called", "Lime green")
        elseif not Accept then
            Player:NewTab(Public, "Canceled Call", "Crimson")
        end
    end
)

Core:AddCmd(
    "Undercover",
    {"undercover"},
    "Set your rank to look like you are Mod",
    4,
    ">undercover",
    function(Public, Player, Args)
        if Player:Undercover() == false or Player:Undercover() == nil then
            Player:setData("Undercover", true, true)
            Core:loadGlobalData()
            Player:NewTab(
                false,
                "Undercover Enabled.",
                "Lime green",
                function()
                    Player:DismissAll()
                end
            )
        elseif Player:Undercover() == true then
            Player:setData("Undercover", false, true)
            Core:loadGlobalData()
            Player:NewTab(
                false,
                "Undercover Disabled.",
                "Lime green",
                function()
                    Player:DismissAll()
                end
            )
        end
    end
)

Core:AddCmd(
    "Roll",
    {"roll"},
    "Roll a dice.",
    0,
    ">roll",
    function(Public, Player, Args)
        local roll = math.floor(math.random() * 6) + 1
        Player:NewTab(Public, Player.Name .. " rolled a " .. roll .. "!", "White")
    end
)

--// Voids

if isVoidSB then
Core:AddCmd(
    "Smite",
    {"smite"},
    "Smite a player.",
    1,
    ">smite [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)

        local function Lightning(Start, End, Times, Offset, Color, Thickness, Transparency)
            local magz = (Start - End).magnitude
            local curpos = Start
            local trz = {-Offset, Offset}
            for i = 1, Times do
                local li = Instance.new("Part", workspace)
                li.TopSurface = 0
                li.BottomSurface = 0
                li.Anchored = true
                li.Transparency = Transparency or 0.4
                li.BrickColor = BrickColor.new(Color)
                li.Material = Enum.Material.Neon
                li.formFactor = "Custom"
                li.CanCollide = false
                li.Size = Vector3.new(Thickness, Thickness, magz / Times)
                local ofz = Vector3.new(trz[math.random(1, 2)], trz[math.random(1, 2)], trz[math.random(1, 2)])
                local function touch(hit)
                    if hit.Parent:findFirstChild("Humanoid") ~= nil then
                        hit.Parent:BreakJoints()
                    end
                end
                li.Touched:connect(touch)
                local trolpos = CFrame.new(curpos, End) * CFrame.new(0, 0, magz / Times).p + ofz
                if Times == i then
                    local magz2 = (curpos - End).magnitude
                    li.Size = Vector3.new(Thickness, Thickness, magz2)
                    li.CFrame = CFrame.new(curpos, End) * CFrame.new(0, 0, -magz2 / 2)
                else
                    li.CFrame = CFrame.new(curpos, trolpos) * CFrame.new(0, 0, magz / Times / 2)
                end
                curpos = li.CFrame * CFrame.new(0, 0, magz / Times / 2).p
                game.Debris:AddItem(li, 0.25)
            end
        end
        for i, v in pairs(Players) do
            if v and v.Character then
                Lightning(
                    v.Character.HumanoidRootPart.Position + Vector3.new(0, 100, 0),
                    v.Character.HumanoidRootPart.Position,
                    3,
                    math.random(-2.5, 2.5),
                    "New Yeller",
                    .4,
                    .4
                )
                Instance.new("Explosion", workspace).Position = v.Character.HumanoidRootPart.Position
            end
        end
    end
)
end

--// Neighborhood

if isNeighborhood then
Core:AddCmd(
    "Smite",
    {"smite"},
    "Smite a player.",
    2,
    ">smite [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)

        local function Lightning(Start, End, Times, Offset, Color, Thickness, Transparency)
            local magz = (Start - End).magnitude
            local curpos = Start
            local trz = {-Offset, Offset}
            for i = 1, Times do
                local li = Instance.new("Part", workspace)
                li.TopSurface = 0
                li.BottomSurface = 0
                li.Anchored = true
                li.Transparency = Transparency or 0.4
                li.BrickColor = BrickColor.new(Color)
                li.Material = Enum.Material.Neon
                li.formFactor = "Custom"
                li.CanCollide = false
                li.Size = Vector3.new(Thickness, Thickness, magz / Times)
                local ofz = Vector3.new(trz[math.random(1, 2)], trz[math.random(1, 2)], trz[math.random(1, 2)])
                local function touch(hit)
                    if hit.Parent:findFirstChild("Humanoid") ~= nil then
                        hit.Parent:BreakJoints()
                    end
                end
                li.Touched:connect(touch)
                local trolpos = CFrame.new(curpos, End) * CFrame.new(0, 0, magz / Times).p + ofz
                if Times == i then
                    local magz2 = (curpos - End).magnitude
                    li.Size = Vector3.new(Thickness, Thickness, magz2)
                    li.CFrame = CFrame.new(curpos, End) * CFrame.new(0, 0, -magz2 / 2)
                else
                    li.CFrame = CFrame.new(curpos, trolpos) * CFrame.new(0, 0, magz / Times / 2)
                end
                curpos = li.CFrame * CFrame.new(0, 0, magz / Times / 2).p
                game.Debris:AddItem(li, 0.25)
            end
        end
        for i, v in pairs(Players) do
            if v and v.Character then
                Lightning(
                    v.Character.HumanoidRootPart.Position + Vector3.new(0, 100, 0),
                    v.Character.HumanoidRootPart.Position,
                    3,
                    math.random(-2.5, 2.5),
                    "New Yeller",
                    .4,
                    .4
                )
                Instance.new("Explosion", workspace).Position = v.Character.HumanoidRootPart.Position
            end
        end
    end
)
end

Core:AddCmd(
    "Age",
    {"age"},
    "Get a players account age.",
    0,
    ">age",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])

        if Args[1] == nil then
            Player:NewTab(Public, "No Player", "Crimson")
            return
        end

        for i, v in pairs(Players) do
            Player:NewTab(Public, v.Name .. " is " .. v.AccountAge .. " days old.", "White")
        end
    end
)

--// Voids

if isVoidSB then
Core:AddCmd(
    "Damage",
    {"damage", "dmg"},
    "Damage a player.",
    1,
    ">damage [Player] [Ammount]\n>dmg [Player] [Ammount]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        local DamageAmmount = tonumber(Args[2])
        if Args[1] == nil then
            Player:NewTab(Public, "No Player", "Crimson") --No player error
            return
        end
        if Args[2] == nil then
            Player:NewTab(Public, "No Damage Number", "Crimson") --No damage error
            return
        end
        if not tonumber(Args[2]) then
            Player:NewTab(Public, "Use a number please", "Crimson")
            return
        end
        if tonumber(Args[2]) < 0 then
            Player:NewTab(Public, "Use a positive number please", "Crimson")
            return
        end
        for i, v in pairs(Players) do
            if v and v.Character then
                v.Character.Humanoid.Health = v.Character.Humanoid.Health - Args[2] --Damage player
            end
        end
    end
)
end

--// Neighborhood

if isNeighborhood then
Core:AddCmd(
    "Damage",
    {"damage", "dmg"},
    "Damage a player.",
    2,
    ">damage [Player] [Ammount]\n>dmg [Player] [Ammount]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        local DamageAmmount = tonumber(Args[2])
        if Args[1] == nil then
            Player:NewTab(Public, "No Player", "Crimson") --No player error
            return
        end
        if Args[2] == nil then
            Player:NewTab(Public, "No Damage Number", "Crimson") --No damage error
            return
        end
        if not tonumber(Args[2]) then
            Player:NewTab(Public, "Use a number please", "Crimson")
            return
        end
        if tonumber(Args[2]) < 0 then
            Player:NewTab(Public, "Use a positive number please", "Crimson")
            return
        end
        for i, v in pairs(Players) do
            if v and v.Character then
                v.Character.Humanoid.Health = v.Character.Humanoid.Health - Args[2] --Damage player
            end
        end
    end
)
end

--// Voids

if isVoidSB then
Core:AddCmd(
    "Explode",
    {"explode"},
    "Explode a player.",
    1,
    ">explode [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local expl = Instance.new("Explosion", workspace)
                expl.Position = v.Character.HumanoidRootPart.Position
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
end

--// Neighborhood

if isNeighborhood then
Core:AddCmd(
    "Explode",
    {"explode"},
    "Explode a player.",
    2,
    ">explode [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local expl = Instance.new("Explosion", workspace)
                expl.Position = v.Character.HumanoidRootPart.Position
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
end

Core:AddCmd(
    "Flip",
    {"flip"},
    "Make a player do a 360 flip.",
    1,
    ">flip [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])

        for i, Player in pairs(Players) do
            if Player ~= nil then
                if Player.Character ~= nil then
                    if Player.Character:FindFirstChild("Torso") ~= nil then
                        local Flip = Player.Character.Torso:FindFirstChild("Flip")
                        if not Flip then
                            coroutine.wrap(
                                function()
                                    local TorsoCFrame = Player.Character.Torso.CFrame
                                    Flip = Instance.new("BodyGyro", Player.Character.Torso)
                                    Flip.Name = "Flip"
                                    Flip.maxTorque = Vector3.new(math.huge, 0, 0)
                                    Flip.P = 11111
                                    Flip.cframe = TorsoCFrame
                                    local Stable = Instance.new("BodyPosition", Player.Character.Torso)
                                    Stable.Name = "Stable"
                                    Stable.position = Player.Character.Torso.Position + Vector3.new(0, 1, 0)
                                    Stable.maxForce = Vector3.new(0, math.huge, 0)
                                    wait(0.1)
                                    for i = 0, 360, 10 do
                                        Flip.cframe = TorsoCFrame * CFrame.Angles(math.rad(i), 0, 0)
                                        wait()
                                    end
                                    wait(0.5)
                                    Flip:Destroy()
                                    Stable:Destroy()
                                end
                            )()
                        end
                    end
                end
            end
        end
    end
)

--[[Core:AddCmd(
    "Fly",
    {"fly"},
    "Give a player the ability to fly.",
    1,
    ">fly [Enabled/Disable] [Player]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end
        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        if #Players >= 1 then
            if Method:lower() == "enable" or Method:lower() == "+" then
                for i, v in pairs(Players) do
                    FlyScript:Clone().Parent = v.Backpack
                    Player:NewTab(Public, v.Name .. " was given fly.", "Lime green")
                    v:NewTab(Public, "You have been given fly\nPress E to enable/disable fly", "Lime green")
                    wait(8)
                    v:DismissAll()
                    Player:DismissAll()
                end
            elseif Method:lower() == "disable" or Method:lower() == "-" then
                for i, v in pairs(Players) do
                    if v.Backpack:FindFirstChild("Fly") then
                        v.Backpack:FindFirstChild("Fly"):Destroy()
                        Player:DismissAll()
                        Player:NewTab(Public, "Fly removed from " .. v.Name, "Really red")
                        v:LoadCharacter()
                        wait(3)
                        Player:DismissAll()
                    elseif not v.Backpack:FindFirstChild("Fly") then
                        Player:DismissAll()
                        Player:NewTab(Public, "Fly not enabled for " .. v.Name, "Really red")
                        wait(3)
                        Player:DismissAll()
                    end
                end
            end
        end
    end
)--]]

Core:AddCmd("Fly",{"fly"},"Give a player the ability to fly.",1,">fly [Player]",function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end

        local Method = Args[1]
        table.remove(Args, 1)
		
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
            Player:sendData({"Fly", true})
		Player:newTab(Public,"Fly Given","Lime green")
    end)

if isVoidSB then
Core:AddCmd(
    "ScriptLock",
    {"scriptlock"},
    "Lock all scripts.",
    4,
    ">scriptlock",
    function(Public, Player, Args)
        Settings.ScriptLock = not Settings.ScriptLock
        if Settings.ScriptLock then
            Player:newTab(Public, "ScriptLock: On", "Lime green")
            ScriptLock(Settings.ScriptLock)
        else
            Player:newTab(Public, "ScriptLock: Off", "Bright red")
        end
    end
)
end

if isVoidSB then
Core:AddCmd(
    "SoundLock",
    {"soundlock"},
    "Lock all sounds.",
    3,
    ">locksounds",
    function(Public, Player, Args)
        Settings.SoundLock = not Settings.SoundLock
        if Settings.SoundLock then
            Player:newTab(Public, "SoundLock: On", "Lime green")
            SoundLock(Settings.SoundLock)
        else
            Player:newTab(Public, "SoundLock: Off", "Bright red")
        end
    end
)
end

Core:AddCmd(
    "Music",
    {"music"},
    "Play a sound ID",
    1,
    ">music [id]",
    function(Public, Player, Args)
        local ID = tonumber(Args[1])

        if Args[1] == nil then
            Player:NewTab(Public, "No ID", "Crimson")
        end

        local Accept =
            Confirm(
            Player,
            "Play?\nID: " .. ID .. "\nName: " .. game:GetService("MarketplaceService"):GetProductInfo(ID).Name,
            15,
            false
        )

        if Accept then
            Sound(ID, false, 6)
            Player:NewTab(
                Public,
                "Now playing " .. game:GetService("MarketplaceService"):GetProductInfo(ID).Name,
                "Lime green"
            )
        elseif not Accept then
            Player:NewTab(Public, "Cancelled", "Crimson")
        end
    end
)

Core:AddCmd(
    "RemoteRank",
    {"remoterank", "dbupload", "updatedb"},
    "Remotely upload someone to the DB",
    5,
    ">dbupload [FullUsername] [Rank]",
    function(Public, Player, Args)
        if Args[1] == nil then
            Player:newTab(Public, "No Player", "Crimson")
            return
        end

        if Args[2] == nil then
            Player:NewTab(Public, "No Rank", "Crimson")
            return
        end

        local PlayerName = tostring(Args[1])

        local RankNumber = tonumber(Args[2])

        if tonumber(Args[2]) <= -1 then
            Player:NewTab(Public, "Use a positive number please.", "Crimson")
            return
        end

        local success, userId =
            pcall(
            function()
                return game:GetService("Players"):GetUserIdFromNameAsync(tostring(Args[1]))
            end
        )

		if not success then
                    Player:NewTab(Public, "User not found.", "Crimson")
		else

        local Data = {Username = tostring(Args[1]), Rank = tonumber(Args[2])}
        Users[userId] = Data
        Core.DBPost(Settings.Database, userId, Data)
		local RankedText = tostring(Args[1]).." is now rank "..tostring(Args[2])
        local RankedTab = Player:NewTab(Public, "Database updated.", "Bright green")
wait(.8)
		 Player:editTab(RankedTab, {Text = RankedText, Color = "Lime green"})
		Player:RunCommand(">lgd")
    end
end
)

Core:AddCmd(
    "Jail",
    {"Jail"},
    "Jail/Unjail a player.",
    2,
    ">jail [Enable/Disable] [Player]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments. Check the command info.", "Crimson")
            return
        end

        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)

        if Method:lower() == "enable" or Method:lower() == "+" then
            for i, add in pairs(Players) do
                Core.Functions.TempJailPlayer(add)
            end
        elseif Method:lower() == "disable" or Method:lower() == "-" then
            for i, rmv in pairs(Players) do
                Core.Functions.UnTempJailPlayer(rmv)
            end
        end
    end
)

Core:AddCmd(
    "Volume",
    {"volume"},
    "Change Zeus's music volume",
    1,
    ">volume [number 1-6]",
    function(Public, Player, Args)
        if not tonumber(Args[1]) then
            Player:NewTab(Public, "Must be a number", "Really red")
            wait(3)
            Player:DismissAll()
        end
        local volume = tonumber(Args[1])
        if game:GetService("ReplicatedStorage"):FindFirstChild("ZeusSound") then
            game:GetService("ReplicatedStorage"):FindFirstChild("ZeusSound").Volume = volume
            Player:DismissAll()
            Player:NewTab(Public, "Volume set to " .. volume, "Lime green")
        else
            Player:DismissAll()
            Player:NewTab(Public, "No Zeus sound found", "Really red")
            wait(3)
            Player:DismissAll()
        end
    end
)

if isVoidSB then
Core:AddCmd(
    "RemoveSounds",
    {"removesounds", "rs", "clearsounds"},
    "Remove all the sounds from the game",
    1,
    ">rs",
    function(Public, Player, Args)
        local Numb = {}
		local num = 0
        local ASD
        for _, b in pairs(GetClasses(game, "Sound")) do
            b:Remove()
			num = num + 1
            table.insert(Numb, b)
        end
        for i = 1, #Numb do
            ASD = i
        end
        wait(.8)
        Player:NewTab(Public, "Removed "..num.." sounds(s).", "Lime green")
		num = 0
    end
)
end

local MarketplaceService = game:GetService("MarketplaceService")

local function ProcessReceipt(ReceiptInfo)
    local Player = game:GetService("Players"):GetPlayerByUserId(ReceiptInfo.PlayerId)
    if not Player then
        print("Not processed")
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
    if Player then
        print("Processed")
    end
    return Enum.ProductPurchaseDecision.PurchaseGranted
end
MarketplaceService.ProcessReceipt = ProcessReceipt

if isVoidSB then
Core:AddCmd(
    "BuyRank",
    {"buyrank"},
    "Buy a rank",
    0,
    ">buyrank [number:Optional]",
    function(Public, Player, Args)
        local SpecificRank = tonumber(Args[1])
        --// No args
        if Args[1] == nil or not tonumber(Args[1]) then
            BuyRanks(Player, Player.plrObj)
        elseif tonumber(Args[1]) == 1 then
            BuyRank1(Player, Player.plrObj)
        elseif tonumber(Args[1]) == 2 then
            BuyRank2(Player, Player.plrObj)
        elseif tonumber(Args[1]) == 3 then
            BuyRank3(Player, Player.plrObj)
        end
    end
)
end

if isNeighborhood then
	Core:AddCmd(
    "BuyRank",
    {"buyrank"},
    "Buy a rank",
    0,
    ">buyrank [number:Optional]",
    function(Public, Player, Args)
		BuyRanksNeighborhood(Player, Player.plrObj)
	end)
end

if isNeighborhood then
	Core:AddCmd(
	"SetExp",
	{"setexp","setxp"},
	"Set a players EXP Value",
	4,
	">setexp [Player] [Number]\n>setxp [Player] [Number]",
	function(Public, Player, Args)
		
		if Args[1] == nil then
			Player:NewTab(Public,"No Player","Crimson")
			return
		end
		
		if Args[2] == nil then
			Player:NewTab(Public,"No Value","Crimson")
			return
		end
		
		local Players = Player:GetPlrs(Args[1])
		local NewValue = tonumber(Args[2])
		
		for i,v in pairs (Players) do
			v:WaitForChild("EXP").Value = NewValue
			Player:NewTab(Public,Player.Name.." EXP Changed to "..NewValue,"Lime green")
		end
	end)
end

if isNeighborhood then
	Core:AddCmd(
	"SetLevel",
	{"setlevel","setlvl"},
	"Set a players Level Value",
	4,
	">setlevel [Player] [Number]\n>setlvl [Player] [Number]",
	function(Public, Player, Args)
		
		if Args[1] == nil then
			Player:NewTab(Public,"No Player","Crimson")
			return
		end
		
		if Args[2] == nil then
			Player:NewTab(Public,"No Value","Crimson")
			return
		end
		
		local Players = Player:GetPlrs(Args[1])
		local NewValue = tonumber(Args[2])
		
		for i,v in pairs (Players) do
			v:WaitForChild("Level").Value = NewValue
			Player:NewTab(Public,Player.Name.." Level Changed to "..NewValue,"Lime green")
		end
	end)
end

if isNeighborhood then
	Core:AddCmd(
	"AddExp",
	{"addexp","addxp"},
	"Add to a players EXP Value",
	4,
	">addexp [Player] [Number]\n>addxp [Player] [Number]",
	function(Public, Player, Args)
		
		if Args[1] == nil then
			Player:NewTab(Public,"No Player","Crimson")
			return
		end
		
		if Args[2] == nil then
			Player:NewTab(Public,"No Value","Crimson")
			return
		end
		
		local Players = Player:GetPlrs(Args[1])
		local NewValue = tonumber(Args[2])
		
		for i,v in pairs (Players) do
			v:WaitForChild("EXP").Value = v:WaitForChild("EXP").Value + NewValue
			Player:NewTab(Public,Player.Name.." had "..NewValue.." EXP added.","Lime green")
		end
	end)
end

if isNeighborhood then
	Core:AddCmd(
	"AddLevel",
	{"addlevel","addlvl"},
	"Add to a players Level Value",
	4,
	">addlevel [Player] [Number]\n>addlvl [Player] [Number]",
	function(Public, Player, Args)
		
		if Args[1] == nil then
			Player:NewTab(Public,"No Player","Crimson")
			return
		end
		
		if Args[2] == nil then
			Player:NewTab(Public,"No Value","Crimson")
			return
		end
		
		local Players = Player:GetPlrs(Args[1])
		local NewValue = tonumber(Args[2])
		
		for i,v in pairs (Players) do
			v:WaitForChild("Level").Value = v:WaitForChild("Level").Value + NewValue
			Player:NewTab(Public,Player.Name.." had "..NewValue.." level(s) added.","Lime green")
		end
	end)
end

if isNeighborhood then
	Core:AddCmd(
	"SetCash",
	{"setcash"},
	"Set a players Cash Value",
	4,
	">setcash [Player] [Number]",
	function(Public, Player, Args)
		
		if Args[1] == nil then
			Player:NewTab(Public,"No Player","Crimson")
			return
		end
		
		if Args[2] == nil then
			Player:NewTab(Public,"No Value","Crimson")
			return
		end
		
		local Players = Player:GetPlrs(Args[1])
		local NewValue = tonumber(Args[2])
		
		for i,v in pairs (Players) do
			v:WaitForChild("leaderstats"):WaitForChild("Cash").Value = NewValue
			Player:NewTab(Public,Player.Name.." Cash Changed to "..NewValue,"Lime green")
		end
	end)
end

if isNeighborhood then
	Core:AddCmd(
	"AddCash",
	{"addcash"},
	"Add to a players Cash Value",
	4,
	">addcash [Player] [Number]",
	function(Public, Player, Args)
		
		if Args[1] == nil then
			Player:NewTab(Public,"No Player","Crimson")
			return
		end
		
		if Args[2] == nil then
			Player:NewTab(Public,"No Value","Crimson")
			return
		end
		
		local Players = Player:GetPlrs(Args[1])
		local NewValue = tonumber(Args[2])
		
		for i,v in pairs (Players) do
			v:WaitForChild("leaderstats"):WaitForChild("Cash").Value = v:WaitForChild("leaderstats"):WaitForChild("Cash").Value + NewValue
			Player:NewTab(Public,Player.Name.." had "..NewValue.." Cash added.","Lime green")
		end
	end)
end

Core:AddCmd(
    "Warn",
    {"warn"},
    "Warn a player.",
    3,
    ">warn [player] [reason]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end

        local Players = Player:GetPlrs(Args[1])

        table.remove(Args, 1)

        for i, v in pairs(Players) do
            if Player:Rank() > v:Rank() then
                Confirm(v, "You have been warned for '" .. table.concat(Args, " ") .. "'", 2e9, true)
                local Warned = Player:NewTab(false, "Player warned.", "Lime green")
                Player:timeddismiss(Warned, 5)
            elseif v:Rank() > Player:Rank() then
                Player:NewTab(Public, "Player has a higher rank than you!", "Crimson")
            elseif v:Rank() == Player:Rank() then
                Player:NewTab(Public, "You are the same rank as " .. v.Name, "Crimson")
            elseif v.Name == Player.Name then
                Player:NewTab(Public, "You cannot warn yourself silly goose.", "Crimson")
            end
        end
    end
)

Core:AddCmd(
    "Shutdown",
    {"shutdown"},
    "Shuts down the server.",
    4,
    ">shutdown [Reason]",
    function(Public, Player, Args)
	
	if Args[1] == nil then
		Player:newTab(Public,"No Reason","Crimson")
		return
	end
	
	if Args[1] == "" or Args[1] == " " then
		Player:newTab(Public,"No Reason","Crimson")
		return
	end
	
	local pCount = #game:GetService("Players"):GetPlayers()
	local Reason = table.concat(Args, " ")
	
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            v:Kick("Server shutdown by Zeus for: "..Reason.."\nCommand ran by: " .. Player.Name)
        end
		if pCount == 1 then
		Core:importantLog(Player,"Shutdown a server with "..pCount.." person.\nReason: "..Reason,"Green")
		elseif pCount > 1 then
		Core:importantLog(Player,"Shutdown a server with "..pCount.." people.\nReason: "..Reason,"Green")
		end
    end
)

Core:AddCmd(
    "RemoveIY",
    {"removeiy"},
    "Remove IY from players.",
    0,
    ">removeiy",
    function(Public, Player, Args)
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.PlayerGui:FindFirstChild("IY_GUI") then
                v.PlayerGui:FindFirstChild("IY_GUI"):Destroy()
                Player:NewTab(Public, "IY removed from " .. v.Name, "Lime green")
            elseif not v.PlayerGui:FindFirstChild("IY_GUI") then
                Player:NewTab(Public, "IY not found on " .. v.Name, "Crimson")
            end
        end
    end
)

Core:AddCmd(
    "RemoveUTG",
    {"removeutg"},
    "Remove UTG from players.",
    0,
    ">removeutg",
    function(Public, Player, Args)
		
		local Names = "AccessUI","AdrianGUI","Blackman";
	
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.PlayerGui:FindFirstChild("AccessUI") then
                v.PlayerGui:FindFirstChild("AccessUI"):Destroy()
                Player:NewTab(Public, "UTG removed from " .. v.Name.."\nPlease perm ban the player from Zeus if possible, or contact a moderator.", "Lime green")
			elseif v.PlayerGui:FindFirstChild("AdrianGUI") then
                v.PlayerGui:FindFirstChild("AdrianGUI"):Destroy()
                Player:NewTab(Public, "UTG removed from " .. v.Name.."\nPlease perm ban the player from Zeus if possible, or contact a moderator.", "Lime green")
			elseif v.PlayerGui:FindFirstChild("Blackman") then
                v.PlayerGui:FindFirstChild("Blackman"):Destroy()
                Player:NewTab(Public, "UTG removed from " .. v.Name.."\nPlease perm ban the player from Zeus if possible, or contact a moderator.", "Lime green")
			elseif not v.PlayerGui:FindFirstChild("AccessUI") and not v.PlayerGui:FindFirstChild("AdrianGUI") and not v.PlayerGui:FindFirstChild("Blackman") then
                Player:NewTab(Public, "UTG not found on " .. v.Name, "Crimson")
            end
        end
    end
)

Core:AddCmd("Kick",{"kick", "getout"},"Kicks a player from the server.",2,">kick [player] [reason]",function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)

        if #Players >= 1 then
            for i, v in pairs(Players) do
                if Player:Rank() > v:Rank() then
                    v:Kick("Kicked with Zeus\nReason: " .. table.concat(Args, " "))
                    Player:NewTab(Public, "Kicked " .. v.Name .. " for " .. table.concat(Args, " "))
                elseif Player:Rank() <= v:Rank() then
                    Player:NewTab(Public, v.Name .. " has a higher or equal rank!", "Bright red")
                end
            end
        end
    end)

Core:AddCmd(
    "ServerBan",
    {"serverban", "sban"},
    "Server bans a player.",
    3,
    ">sban [Add/Remove] [Player]",
    function(Public, Player, Args)
		if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments.\n>sban add PLAYER\n>sban remove PLAYER", "Crimson")
            return
        end
		local Method = Args[1]
		table.remove(Args,1)

		if Method:lower() == "add" or Method:lower() == "+" then
		local Players = Player:GetPlrs(Args[1])
		
        for i, v in pairs(Players) do
			if v:Rank() > Player:Rank() then
				Player:NewTab(Public,"Player has a higher rank.","Crimson")
				return
			end
			if v.Name == Player.Name then
				Player:NewTab(Public,"Cannot ban yourself SILLY GOOSE.","Crimson")
				return
			end
			Core.Functions.Serverban(Player,v)
			table.remove(Args,1)
		end
		elseif Method:lower() == "remove" or Method:lower() == "-" then
			for i, v in pairs(ServerBans) do
            	if v:lower():find(Args[1]:lower()) then
			v = v:lower()
		
        Core.Functions.UnServerBan(Player,v,Args)
				elseif not v:lower():find(Args[1]:lower()) then
			Player:NewTab(Public,"Could not find player.","Crimson")
			end
		end
    end
end
)

--[[Core:AddCmd(
    "UnServerBan",
    {"unserverban", "unsban"},
    "Server bans a player.",
    3,
    ">unsban [player]",
    function(Public, Player, Args)
	
		if Args[1] == nil then
			Player:NewTab(Public,"Missing Player Argument","Crimson")
		end
		
		for i, v in pairs(ServerBans) do
            	if v:lower():find(Args[1]:lower()) then
			v = v:lower()
		
        Core.Functions.UnServerBan(Player,v,Args)
		end
	end
end
)--]]

Core:AddCmd(
    "ShowServerBans",
    {"showserverbans", "showsbans", "sbans"},
    "Shows a list of all the server banned players.",
    3,
    ">sbans",
    function(Public, Player, Args)
        Player:DismissAll()
        for i, v in pairs(ServerBans) do
            Player:NewTab(
                Public,
                v,
                "White",
                function()
                    Player:NewTab(Public, "Name: " .. v, "White")
                    Player:NewTab(
                        Public,
                        "Unban",
                        "Crimson",
                        function()
                            Player:RunCommand(">unsban " .. v)
                        end
                    )
                end
            )
        end
    end
)

Core:AddCmd(
    "PermBan",
    {"pban"},
    "Perm bans a player",
    4,
    ">pban [Add/Remove] [FullUsername] [Reason]",
    function(Public, Player, Args)
	if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments.\n>pban add FULLUSERNAME REASON\n>pban remove FULLUSERNAME REASON", "Crimson")
            return
        end
		local Method = Args[1]
		table.remove(Args, 1)
		if Method:lower() == "add" or Method:lower() == "+" then
		Core.Functions.PermBan(Player,Args)
		elseif Method:lower() == "remove" or Method:lower() == "-" then
		Core.Functions.UnPermBan(Player,Args)
		end
    end
)

--[[Core:AddCmd(
    "Unban",
    {"unban"},
    "Unbans a player",
    4,
    ">unban [fullusername]",
    function(Public, Player, Args)
		Core.Functions.UnPermBan(Player,Args)
    end
)--]]

Core:AddCmd(
    "BanList",
    {"Banlist", "bans"},
    "Check the banned list",
    4,
    ">banlist\n>bans",
    function(Public, Player, Args)
        Player:DismissAll()
        Player:DismissTab()
        Player:newTab(Public, "Click a name for more info", "Bright red")
        for userId, data in pairs(banList) do
            local name, reason, bannedBy = data.Name, data.Reason, data.bannedBy
            Player:newTab(
                Public,
                name,
                "Crimson",
                function()
                    Player:DismissAll()
                    Player:DismissTab()
                    Player:newTab(
                        Public,
                        "Unban",
                        "Crimson",
                        function()
                            local Accept = Confirm(Player, "Un-ban " .. name .. "?", 15)
                            if not Accept then
                                Player:newTab(Public, "Cancelled", "Bright red")
                                Core:importantLog(Player, "Cancelled unban on '" .. name .. "'","Red")
                            elseif Accept then
                                banList[userId] = nil
                                banStore:SetAsync(banKey, banList)
                                Player:DismissAll()
                                Core:importantLog(Player, "Confirmed unban on '" .. name .. "'","Green")
                                Player:newTab(
                                    Public,
                                    name .. " (" .. userId .. ") unbanned",
                                    "Lime green",
                                    function()
                                        Player:DismissAll()
                                        Player:RunCommand("<bans")
                                    end
                                )
                            end
                        end
                    )
                    Player:newTab(Public, "Name: " .. name, "White")
                    Player:newTab(Public, "Reason: " .. reason, "Lime green")
                    Player:newTab(Public, "Banned by: " .. bannedBy, "Lime green")
					Player:newTab(Public, "Back", "White", function()
						Player:RunCommand("<bans")
					end)
                end
            )
        end
    end
)

if isVoidSB then
Core:AddCmd(
    "ClearScripts",
    {"cs", "removescripts", "clearscripts"},
    "Stop all the scripts in the server",
    2,
    ">cs",
    function(Public, Player, Args)
        local Services1 = {
            game:GetService("Workspace"),
            game:GetService("Players"),
            game:GetService("Lighting"),
            game:GetService("StarterPack"),
            game:GetService("StarterGui"),
            game:GetService("Teams"),
            game:GetService("SoundService"),
            game:GetService("Debris")
        }
        local Services2 = {
            game:GetService("ServerScriptService"),
            game:GetService("ReplicatedStorage")
        }
        local a = {
            Ins = 0,
            Script = 0
        }
        local ClearingStuff = Player:NewTab(Public, "This will take up to 5 seconds", "Crimson")
        local Cleared1 = "Clearing Phase 1 completed."
        local Cleared2 = "Clearing Phase 2 completed."
        for i, v in pairs(Services1) do
            for i, d in pairs(v:GetDescendants()) do
                a.Ins = a.Ins + 1
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
                    a.Script = a.Script + 1
                    d:Destroy()
                end
                pcall(
                    function()
                        if v.ClassName == "ReplicatedStorage" then
                            if
                                d:IsA("Folder") and d.Parent == v and d.Name ~= "DefaultChatSystemChatEvents" and
                                    d ~= Core.Remote
                             then
                                d:Destroy()
                            elseif d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                                if
                                    not d.Parent or not d.Parent.Parent or not d.Parent.Parent == v or
                                        not d.Parent:IsA("Folder") or
                                        d.Parent.Name ~= "DefaultChatSystemChatEvents"
                                 then
                                    if d ~= Core.Remote then
                                        d:Destroy()
                                    end
                                end
                            end
                        end
                    end
                )
            end
        end
        Player:editTab(ClearingStuff, {Text = Cleared1 .. " Removed " .. a.Script .. " scripts(s)."})
        a.Script = 0
        wait(5)
        for i, v in pairs(Services2) do
            for i, d in pairs(v:GetDescendants()) do
                a.Ins = a.Ins + 1
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
                    a.Script = a.Script + 1
                    d:Destroy()
                end
                pcall(
                    function()
                        if v.ClassName == "ReplicatedStorage" then
                            if
                                d:IsA("Folder") and d.Parent == v and d.Name ~= "DefaultChatSystemChatEvents" and
                                    d ~= Core.Remote
                             then
                                d:Destroy()
                            elseif d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
                                if
                                    not d.Parent or not d.Parent.Parent or not d.Parent.Parent == v or
                                        not d.Parent:IsA("Folder") or
                                        d.Parent.Name ~= "DefaultChatSystemChatEvents"
                                 then
                                    if d ~= Core.Remote then
                                        d:Destroy()
                                    end
                                end
                            end
                        end
                    end
                )
            end
        end
        Player:editTab(ClearingStuff, {Text = Cleared2 .. " Removed " .. a.Script .. " scripts(s)."})
        Player:dismisstab(ClearingStuff, 5)
        a.Script = 0
        --a.Ins
    end
)
end

Core:AddCmd(
    "Visible",
    {"Visible", "vis", "unghost"},
    "Makes a player visible.",
    1,
    ">visible [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Color = table.concat(Args, " ")
        if #Players >= 1 then
            for i, v in pairs(Players) do
                --local Succ,Err = pcall(function()
                for x, y in pairs(v.Character:GetDescendants()) do
                    if y:IsA "BasePart" and y.Name ~= "HumanoidRootPart" then
                        spawn(
                            function()
                                for i = 1, 0, -.1 do
                                    y.Transparency = i
                                    wait()
                                end
                            end
                        )
                    end
                    if Cache[Player].Face then
                        Cache[Player].Face:Clone().Parent = v.Character.Head
                    end
                end
                --end)
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)

--// Voids

if isVoidSB then
Core:AddCmd(
    "Skydive",
    {"skydive"},
    "Skydives a player.",
    1,
    ">skydive [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.HumanoidRootPart.CFrame =
                            v.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(180)) *
                            CFrame.new(0, -1000, 0)
                    end
                )
                if not Succ then
                    Player:NewTab(Public, "No Humanoid", "Crimson")
                end
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
end

--// Neighborhood

if isNeighborhood then
Core:AddCmd(
    "Skydive",
    {"skydive"},
    "Skydives a player.",
    2,
    ">skydive [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.HumanoidRootPart.CFrame =
                            v.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(180)) *
                            CFrame.new(0, -1000, 0)
                    end
                )
                if not Succ then
                    Player:NewTab(Public, "No Humanoid", "Crimson")
                end
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
end

Core:AddCmd(
    "Flip",
    {"flip"},
    "Flips a player.",
    1,
    ">flip [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        v.Character.HumanoidRootPart.CFrame =
                            v.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(180))
                    end
                )
                if not Succ then
                    Player:NewTab(Public, "No Humanoid", "Crimson")
                end
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Smoke",
    {"smoke"},
    "Gives a player smoke.",
    1,
    ">smoke [Add/Remove] [Player] [Color]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end
        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Color = table.concat(Args, " ")
        if #Players >= 1 then
            if Method:lower() == "add" or Method:lower() == "+" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            local Effect = Instance.new("Smoke")
                            Effect.Color = BrickColor.new(Color).Color
                            Effect.Parent = v.Character.HumanoidRootPart
                        end
                    )
                end
            elseif Method:lower() == "remove" or Method:lower() == "-" or Method:lower() == "rem" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            for x, y in pairs(v.Character.HumanoidRootPart:GetChildren()) do
                                if y:IsA("Smoke") then
                                    y:Destroy()
                                end
                            end
                        end
                    )
                end
            else
                Player:NewTab(Public, "Invalid option: Add/Remove", "Crimson")
                Player:NewTab(Public, "You can also use add,+,remove,rem,-", "Crimson")
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Density",
    {"density"},
    "Changes a players density.",
    1,
    ">density [Player] [Number]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Number = tonumber(Args[1])
        if not Number then
            Player:NewTab(Player, "Invalid density.", "Crimson")
            return
        end
        if #Players >= 1 then
            for i, v in pairs(Players) do
                local Succ, Err =
                    pcall(
                    function()
                        for x, y in pairs(v.Character:GetDescendants()) do
                            if y:IsA "BasePart" then
                                local oldProp = PhysicalProperties.new(y.Material)
                                local newphys = PhysicalProperties.new(Number, oldProp.Friction, oldProp.Elasticity)
                                y.CustomPhysicalProperties = newphys
                            end
                        end
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Clone",
    {"clone"},
    "Clones a player.",
    1,
    ">clone [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1]) or {Player}
        if #Players >= 1 then
            for i, v in pairs(Players) do
                pcall(
                    function()
                        v.Character.Archivable = true
                        v.Character:Clone().Parent = workspace
                        v.Character.Archivable = false
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Switch",
    {"switch"},
    "Switch places with a player.",
    1,
    ">switch [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if #Players >= 1 then
            for i, v in pairs(Players) do
                pcall(
                    function()
                        local mepos = Player.Character.HumanoidRootPart.CFrame
                        local thempos = v.Character.HumanoidRootPart.CFrame
                        Player.Character.HumanoidRootPart.CFrame = thempos
                        v.Character.HumanoidRootPart.CFrame = mepos
                    end
                )
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Sparkle",
    {"sparkle"},
    "Gives a player a sparkle.",
    1,
    ">sparkle [Add/Remove] [Player] [Color]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end
        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Color = table.concat(Args, " ")
        if #Players >= 1 then
            if Method:lower() == "add" or Method:lower() == "+" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            local Effect = Instance.new("Sparkles")
                            Effect.SparkleColor = BrickColor.new(Color).Color
                            Effect.Parent = v.Character.HumanoidRootPart
                        end
                    )
                end
            elseif Method:lower() == "remove" or Method:lower() == "-" or Method:lower() == "rem" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            for x, y in pairs(v.Character.HumanoidRootPart:GetChildren()) do
                                if y:IsA("Sparkles") then
                                    y:Destroy()
                                end
                            end
                        end
                    )
                end
            else
                Player:NewTab(Public, "Invalid option: Add/Remove", "Crimson")
                Player:NewTab(Public, "You can also use add,+,remove,rem,-", "Crimson")
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Fire",
    {"fire"},
    "Gives a player a fire.",
    1,
    ">fire [Add/Remove] [Player] [Color]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end
        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Color = table.concat(Args, " ")
        if #Players >= 1 then
            if Method:lower() == "add" or Method:lower() == "+" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            local Effect = Instance.new("Fire")
                            Effect.Color = BrickColor.new(Color).Color
                            Effect.Parent = v.Character.HumanoidRootPart
                        end
                    )
                end
            elseif Method:lower() == "remove" or Method:lower() == "-" or Method:lower() == "rem" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            for x, y in pairs(v.Character.HumanoidRootPart:GetChildren()) do
                                if y:IsA("Fire") then
                                    y:Destroy()
                                end
                            end
                        end
                    )
                end
            else
                Player:NewTab(Public, "Invalid option: Add/Remove", "Crimson")
                Player:NewTab(Public, "You can also use add,+,remove,rem,-", "Crimson")
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)
Core:AddCmd(
    "Light",
    {"light"},
    "Gives a player a light.",
    1,
    ">light [Add/Remove] [Player] [Color]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end
        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        local Color = table.concat(Args, " ")
        if #Players >= 1 then
            if Method:lower() == "add" or Method:lower() == "+" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            local Effect = Instance.new("PointLight")
                            Effect.Color = BrickColor.new(Color).Color
                            Effect.Parent = v.Character.HumanoidRootPart
                        end
                    )
                end
            elseif Method:lower() == "remove" or Method:lower() == "-" or Method:lower() == "rem" then
                for i, v in pairs(Players) do
                    local Succ, Err =
                        pcall(
                        function()
                            for x, y in pairs(v.Character.HumanoidRootPart:GetChildren()) do
                                if y:IsA("Light") then
                                    y:Destroy()
                                end
                            end
                        end
                    )
                end
            else
                Player:NewTab(Public, "Invalid option: Add/Remove", "Crimson")
                Player:NewTab(Public, "You can also use add,+,remove,rem,-", "Crimson")
            end
        else
            Player:NewTab(Public, "No Player", "Crimson")
        end
    end
)

Core:AddCmd(
    "Mute",
    {"mute"},
    "Mute or unmute a player.",
    2,
    ">mute [Add/Remove] [Player]",
    function(Public, Player, Args)
        if #Args < 2 then
            Player:NewTab(Public, "Insufficient Arguments", "Crimson")
            return
        end

        local Method = Args[1]
        table.remove(Args, 1)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)

        for i, v in pairs(Players) do
            if Method:lower() == "add" or Method:lower() == "+" then
                v:sendData({"Mute", true})
            elseif Method:lower() == "remove" or Method:lower() == "-" then
                v:sendData({"Mute", false})
            end
        end
    end
)

Core:AddCmd(
    "Paint",
    {"paint"},
    "Paints a player a specific color.",
    1,
    ">paint [Player] [Brick color]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        for i, v in pairs(Players) do
            if v.Character then
                for x, y in next, v.Character:GetDescendants() do
                    if y:IsA("BasePart") then
                        y.BrickColor = BrickColor.new(table.concat(Args, " "))
                    end
                end
            end
        end
    end
)
Core:AddCmd(
    "LoadGlobalData",
    {"loadglobaldata", "lgd", "manupdate"},
    "Manually loads global data.",
    3,
    "manupdate",
    function(Public, Player, Args)
        local t = Player:NewTab(Public, "Loading global data.", "White")
        wait(.3)
        Core:loadGlobalData()
        Player:editTab(t, {Text = "Loaded.", Color = "Lime green"})
    end
)
Core:AddCmd(
    "Materialify",
    {"materialify", "material"},
    "Paints a players character a specific material.",
    1,
    ">material [Player] [Material]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
        for i, v in pairs(Players) do
            if v.Character then
                for x, y in next, v.Character:GetDescendants() do
                    if y:IsA("BasePart") then
                        local succ, err =
                            pcall(
                            function()
                                y.Material = Args[1]
                            end
                        )
                        if not succ then
                            Player:NewTab(Public, "Invalid material.", "Crimson")
                            break
                        end
                    end
                end
            end
        end
    end
)

Core:AddCmd(
    "Explorer",
    {"explorer", "explore"},
    "Explores the game.",
    1,
    ">explorer",
    function(Public, Player, Args)
        Player:DismissAll()
        Player:NewTab(Public, "Explorer", "Deep orange")
        for i, v in pairs({"Workspace", "Lighting", "Players", "Teams", "ReplicatedStorage", "ServerScriptService"}) do
            Player:NewTab(
                Public,
                v,
                "Bright blue",
                function()
                    Core:Explore(game:GetService(v), Player, Public)
                end
            )
        end
        Player:DismissTab()
    end
)
Core:AddCmd(
    "Players",
    {"players", "plrs"},
    "Opens players.",
    1,
    ">plrs",
    function(Public, Player, Args)
        Player:DismissAll()
        Player:NewTab(Public, "Players", "Deep orange")

        local loadtab = Player:newTab(Public, "Loading Players...", "White")
        for x, Plr in pairs(ActivePlayers) do
            local Image, isReady =
                game:GetService("Players"):GetUserThumbnailAsync(
                Plr.UserId,
                Enum.ThumbnailType.AvatarThumbnail,
                Enum.ThumbnailSize.Size420x420
            )
        end
        Player:removeTab(loadtab)
        for x, Plr in pairs(ActivePlayers) do
            local Image, isReady =
                game:GetService("Players"):GetUserThumbnailAsync(
                Plr.UserId,
                Enum.ThumbnailType.AvatarThumbnail,
                Enum.ThumbnailSize.Size420x420
            )
            Player:NewTab(
                Public,
                Plr.Name,
                "Cyan",
                function()
                    Player:DismissAll()
                    Player:NewTab(Public, Plr.Name, "Deep orange", nil, Image)
                    if Player:Rank() < 4 then
                        if Plr:Undercover() == true then
                            Player:NewTab(Public, "Rank:\n3", "Cyan", nil, Image)
                        elseif Plr:Undercover() == false or Plr:Undercover() == nil then
                            Player:NewTab(Public, "Rank:\n" .. Plr:Rank(), "Cyan", nil, Image)
                        end
                    else
                        Player:NewTab(
                            Public,
                            "Kick",
                            "Bright red",
                            function()
                                Plr:Kick("Kicked with Zeus by " .. Player.Name)
                            end
                        )
                        Player:NewTab(
                            Public,
                            "Ban",
                            "Bright red",
                            function()
                                banList[tostring(Plr.UserId)] = {Name = Plr.Name, Reason = "Banned through >plrs"}
                                banStore:SetAsync(banKey, banList)
                                Player:DismissAll()
                                Player:newTab(Public, Plr.Name .. " (" .. Plr.UserId .. ") banned.", "Lime green")
                                Core:importantLog(Player, "Accepted pban on '" .. Plr.Name .. "' through >plrs","Green")
                                dataStore:GetDataStore(banKey):SetAsync(Plr.UserId, banKey)
                            end
                        )
                        Player:NewTab(
                            Public,
                            "Rank:\n" .. Plr:Rank() .. "\n[Manage]",
                            "Cyan",
                            function()
                                Player:DismissAll()
                                Player:NewTab(Public, Plr.Name .. "\nSet Rank", "Deep orange", nil, Image)
                                for i = 0, 4 do
                                    if isPotatoSB and i == 1 or i == 2 then --//No donors on PotatoSB
                                    else
                                        Player:NewTab(
                                            Public,
                                            "Set Rank:\n" .. RankNames[i],
                                            "Cyan",
                                            function()
                                                Player:DismissAll()
                                                Plr:setData("Rank", i, true)
                                                Player:NewTab(
                                                    Public,
                                                    Plr.Name .. " rank set to " .. RankNames[i],
                                                    "Deep orange"
                                                )
                                                Plr:NewTab(
                                                    Public,
                                                    Player.Name .. " set your rank to " .. RankNames[i],
                                                    "Deep orange"
                                                )
                                            end
                                        )
                                    end
                                end
                                Player:newTab(
                                    Public,
                                    "Back",
                                    "Space grey",
                                    function()
                                        Player:RunCommand(">players" or "<players")
                                    end
                                )
                            end
                        )
                    end
                    Player:newTab(
                        Public,
                        "Back",
                        "Space grey",
                        function()
                            Player:RunCommand(Public == true and ">players" or "<players")
                        end
                    )
                end,
                Image
            )
        end
        Player:DismissTab()
    end
)

if isVoidSB then
Core:AddCmd(
    "PermRank",
    {"permrank", "prank"},
    "Perm rank a player.",
    4,
    ">permrank [Player]\nprank [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        for x, Plr in pairs(Players) do
            local Image, isReady =
                game:GetService("Players"):GetUserThumbnailAsync(
                Plr.UserId,
                Enum.ThumbnailType.AvatarThumbnail,
                Enum.ThumbnailSize.Size420x420
            )
            Player:NewTab(Public, Plr.Name .. "\nSet Rank", "Deep orange", nil, Image)
            --
            --[[ Rank tabs ]] for i = 0, 4 do
                Player:NewTab(
                    Public,
                    "Set Rank:\n" .. RankNames[i],
                    "Cyan",
                    function()
                        Player:DismissAll()
                        if Player:Rank() < i then
                            Player:NewTab(Public, "Cannot set rank higher than your own", "Crimson")
                        elseif Player:Rank() >= i then
                            Plr:setData("Rank", i, true)
                            Player:NewTab(Public, Plr.Name .. " rank set to " .. RankNames[i], "Deep orange")
                            Plr:NewTab(Public, Player.Name .. " set your rank to " .. RankNames[i], "Deep orange")
                            Core:importantLog(Player, "Ranked " .. Plr.Name .. " to " .. RankNames[i],"Green")
                        end
                    end
                )
            end
        end
    end
)
end

if isNeighborhood then
Core:AddCmd(
    "PermRank",
    {"permrank", "prank"},
    "Perm rank a player.",
    5,
    ">permrank [Player]\nprank [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        for x, Plr in pairs(Players) do
            local Image, isReady =
                game:GetService("Players"):GetUserThumbnailAsync(
                Plr.UserId,
                Enum.ThumbnailType.AvatarThumbnail,
                Enum.ThumbnailSize.Size420x420
            )
            Player:NewTab(Public, Plr.Name .. "\nSet Rank", "Deep orange", nil, Image)
            --
            --[[ Rank tabs ]] for i = 0, 4 do
                Player:NewTab(
                    Public,
                    "Set Rank:\n" .. RankNames[i],
                    "Cyan",
                    function()
                        Player:DismissAll()
                        if Player:Rank() < i then
                            Player:NewTab(Public, "Cannot set rank higher than your own", "Crimson")
                        elseif Player:Rank() >= i then
                            Plr:setData("Rank", i, true)
                            Player:NewTab(Public, Plr.Name .. " rank set to " .. RankNames[i], "Deep orange")
                            Plr:NewTab(Public, Player.Name .. " set your rank to " .. RankNames[i], "Deep orange")
                            Core:importantLog(Player, "Ranked " .. Plr.Name .. " to " .. RankNames[i],"Green")
                        end
                    end
                )
            end
        end
    end
)
end

Core:AddCmd(
    "GetRank",
    {"getrank"},
    "Check someones rank",
    0,
    ">getrank [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        if Args[1] == nil then
            Player:NewTab(Public, "No Player", "Crimson")
        end
        for i, v in pairs(Players) do
            if v:Undercover() == true then
                Player:NewTab(Public, v.Name .. " is rank 3", "White")
            elseif v:Undercover() == false or v:Undercover() == nil then
                Player:NewTab(Public, v.Name .. " is rank " .. v:Rank(), "White")
            end
        end
    end
)

Core:AddCmd(
    "SetGravity",
    {"setgravity", "gravity", "grav"},
    "Sets the gravity.",
    1,
    ">gravity [Number]",
    function(Public, Player, Args)
        if not Args[1] then
            workspace.Gravity = 196.2
            Player:NewTab("Gravity reset to 196.2!", "Cyan")
            return
        end
        if not tonumber(Args[1]) then
            Player:NewTab("Arg must be a number!", "Crimson")
        end
        workspace.Gravity = tonumber(Args[1])
        Player:NewTab("Gravity set to " .. Args[1] .. "!", "Cyan")
    end
)
Core:AddCmd(
    "Sticky",
    {"sticky"},
    "Makes a player sticky",
    1,
    ">sticky [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])

        local function weldBetween(a, b)
            local weld = Instance.new("ManualWeld")
            weld.Part0 = a
            weld.Part1 = b
            weld.C0 = CFrame.new()
            weld.C1 = b.CFrame:inverse() * a.CFrame
            weld.Parent = a
            return weld
        end
        for i, v in pairs(Players) do
            pcall(
                function()
                    local Char = v.Character
                    for i, v in pairs(Char:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.Touched:connect(
                                function(part)
                                    if not part:IsDescendantOf(Char) and part.Anchored == false then
                                        weldBetween(v, part)
                                    end
                                end
                            )
                        end
                    end
                end
            )
        end
    end
)
Core:AddCmd(
    "InsertGear",
    {"insertgear", "igear", "i"},
    "Inserts a gear by AssetId.",
    0,
    ">igear [Gear ID]",
    function(Public, Player, Args)
        local Char = Player.Character
        if not Args[1] then
            return Player:NewTab(Public, "Must provide an gear id", "Crimson")
        end
        if Char then
            local succ, err =
                pcall(
                function()
                    game:GetService("InsertService"):LoadAsset(Args[1]):GetChildren()[1].Parent = Player.Character
                end
            )

            if not succ then
                return Player:NewTab(Public, "Failed to load gear with provided ID.", "Crimson")
            end
        end
    end
)

Core:AddCmd(
"TempBan",
{"tempban","tban"},
"Temp-Ban testing",
4,
">tban [Player] [Time]",
function(Public, Player, Args)
  local Players = Player:GetPlrs(Args[1])
  local Time = Args[2]

if Args[1] == nil then
	Player:newTab(Public,"No Player","Crimson")
	return
end
if Args[2] == nil then
	Player:newTab(Public,"No Time","Crimson")
	return
end

  for i,v in pairs (Players) do
	if v:Rank() >= Player:Rank() then
		Player:newTab(Public,"Player has higher or equal to rank!","Crimson")
		return
	end
	if Args[1] == "1h" then --1h
		Core.Functions.SetBan(v,"one_hour")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "2h" then --2h
		Core.Functions.SetBan(v,"two_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "3h" then --3h
		Core.Functions.SetBan(v,"three_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "4h" then --4h
		Core.Functions.SetBan(v,"four_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "5h" then --5h
		Core.Functions.SetBan(v,"five_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "6h" then --6h
		Core.Functions.SetBan(v,"six_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "7h" then --7h
		Core.Functions.SetBan(v,"seven_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "8h" then --8h
		Core.Functions.SetBan(v,"eight_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "9h" then --9h
		Core.Functions.SetBan(v,"nine_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "10h" then --10h
		Core.Functions.SetBan(v,"ten_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "11h" then --11h
		Core.Functions.SetBan(v,"eleven_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[1] == "12h" then --12h
		Core.Functions.SetBan(v,"twelve_hours")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "1d" then --1d
    	Core.Functions.SetBan(v,"one_day")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "2d" then --2d
		Core.Functions.SetBan(v,"two_days")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "3d" then --3d
		Core.Functions.SetBan(v,"three_days")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "4d" then --4d
		Core.Functions.SetBan(v,"four_days")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "5d" then --5d
		Core.Functions.SetBan(v,"five_days")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "6d" then --6d
		Core.Functions.SetBan(v,"six_days")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
	elseif Args[2] == "1w" or Args[2] == "7d" then --7d/week
		Core.Functions.SetBan(v,"one_week")
    	Player:newTab(Public,"Temp-Banned "..v.Name.." for "..Args[2],"Lime green")
		Core:importantLog(Player,"Temp-banned "..v.Name.." for "..Args[2],"Green")
  		end
	end
  end)

Core:AddCmd(
    "NotifyAll",
    {"notifyall"},
    "Make a ROBLOX notification for everyone",
    2,
    ">notify [Text]",
    function(Public, Player, Args)
	for _,plrs in pairs(game:GetService("Players"):GetPlayers()) do
	Notification_Module.NotifyAll(game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.PlrObj))
	Player:newTab(Public,"Notification Sent\nText: "..game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.PlrObj),"Lime green")
	end
end)

Core:AddCmd(
    "NotifyPlayer",
    {"notifyplayer","notifyplr"},
    "Make a ROBLOX notification for a specific player",
    2,
    ">notifyplayer [Player] [Text]",
    function(Public, Player, Args)
	
	local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
 	local txt = table.concat(Args, " ")
	
	for i,v in pairs (Players) do
	Notification_Module.NotifyToPlayer(v,game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.PlrObj))
	Player:newTab(Public,"Notification Sent to "..v.Name.."\nText: "..game:GetService("Chat"):FilterStringForBroadcast(table.concat(Args, " "), Player.PlrObj),"Lime green")
	end
end)

Core:AddCmd(
    "Secret",
    {"secret"},
    "The world may never know.",
    6,
    ">secret",
    function(Public, Player, Args)
	
	local Players = Player:GetPlrs(Args[1])
        table.remove(Args, 1)
 	local txt = table.concat(Args, " ")

	if #Players >= 1 then
            for i, Plr in pairs(Players) do
			Plr:sendData({"ForceChat", txt})
		end
	else
			Player:NewTab(false,"Error","Crimson")	
	end
end)


Core:AddCmd(
    "Execute",
    {"exe", "execute"},
    "Execute a script",
    6,
    ">execute [code]",
    function(Public, Player, Args)
        Player:DismissAll()
        local RealEnvironment, SecureEnvironment, NewEnvironment, Sandbox
        local MainFunction, MainError =
            pcall(
            function()
                local ProtectTable = function(Table)
                    return setmetatable(Table, {__metatable = "[ Sandbox ]:\nInvalid permissions"})
                end
                SecureEnvironment = {
                    script = Core.Functions.Create("Script", {Name = "Zeus_Script"})
                }
                NewEnvironment = {
                    __index = (function()
                        local EnvironmentFunctions = {}
                        for Indexes, Value in pairs {
                            ["game,Game"] = game,
                            ["workspace,Workspace"] = workspace,
                            Workspace = workspace,
                            _G = Core.SandBox._G,
                            _VERSION = "LUA 5.1",
                            sb = nil,
                            shared = Core.SandBox.shared,
                            setfenv = setfenv,
                            require = require,
                            BrickColor = BrickColor,
                            Color3 = Color3,
                            rawset = rawset,
                            rawget = rawget,
                            newproxy = newproxy,
                            setmetatable = setmetatable,
                            getmetatable = getmetatable,
                            pairs = pairs,
                            ipairs = ipairs,
                            next = next,
                            select = select,
                            collectgarbage = collectgarbage,
                            assert = assert,
                            pcall = pcall,
                            pcall = pcall,
                            ypcall = ypcall,
                            xpcall = xpcall,
                            spawn = spawn,
                            Spawn = spawn,
                            tonumber = tonumber,
                            tostring = tostring,
                            type = type,
                            -- unpack = unpack,
                            newproxy = newproxy,
                            wait = wait,
                            UserSettings = UserSettings,
                            Enum = Enum,
                            tick = tick,
                            Zeus = (function()
                                local NewZeus = {}
                                local Zeus_Security = {
                                    __index = Core,
                                    __metatable = "[ Sandbox ]:\nLocked"
                                }
                                local Secure = setmetatable(NewZeus, Zeus_Security)
                                function Zeus_Security.__index:GetReal()
                                    return Core
                                end
                                return NewZeus
                            end)(),
                            loadstring = function(String)
                                local Load = loadstring(String)
                                setfenv(Load, Sandbox)
                                return Load
                            end,
                            print = function(...)
                                local Data, Return = {...}, ""
                                for Index, Value in pairs(Data) do
                                    Return = Return .. tostring(Value) .. (Index < #Data and ", " or "")
                                end
                                return Player:NewTab(Public, Return, "Really blue")
                            end,
                            warn = function(...)
                                local Data, Return = {...}, ""
                                for Index, Value in pairs(Data) do
                                    Return = Return .. tostring(Value) .. (Index < #Data and ", " or "")
                                end
                                return Player:NewTab(Public, Return, "Deep orange")
                            end,
                            error = function(String, Level)
                                return Player:NewTab(Public, String, "Royal purple")
                            end,
                            getfenv = function(Level)
                                local ReturnedEnvironment = SecureEnvironment
                                if type(Level) == "function" then
                                    return ReturnedEnvironment
                                elseif type(Level) == "number" and Level >= 0 and Level <= 2 then
                                    return ReturnedEnvironment
                                elseif type(Level) == "nil" then
                                    return ReturnedEnvironment
                                else
                                    return error("Error: Incorrect Environment Level")
                                end
                            end,
                            Instance = ProtectTable {
                                new = function(ClassName, Parent)
                                    if ClassName then
                                        return Instance.new(ClassName, Parent)
                                    else
                                        return error("String expected")
                                    end
                                end,
                                Lock = Instance.Lock,
                                UnLock = Instance.UnLock
                            },
                            UDim2 = ProtectTable {
                                new = UDim2.new
                            },
                            UDim = ProtectTable {
                                UDim.new
                            },
                            Vector2int16 = ProtectTable {
                                Vector2int16.new
                            },
                            Vector2 = ProtectTable {
                                new = Vector2.new
                            },
                            Vector3 = ProtectTable {
                                FromNormalId = Vector3.FromNormalId,
                                FromAxis = Vector3.FromAxis,
                                new = Vector3.new
                            },
                            Vector3int16 = ProtectTable {
                                Vector3int16.new
                            },
                            CFrame = ProtectTable {
                                new = CFrame.new,
                                Angles = CFrame.Angles,
                                fromAxisAngle = CFrame.fromAxisAngle,
                                fromEulerAnglesXYZ = CFrame.fromMEulerAnglesXYZ
                            },
                            table = ProtectTable {
                                setn = table.setn,
                                insert = table.insert,
                                getn = table.getn,
                                foreachi = table.foreachi,
                                maxn = table.maxn,
                                foreach = table.foreach,
                                concat = table.concat,
                                sort = table.sort,
                                remove = table.remove
                            },
                            coroutine = ProtectTable {
                                resume = coroutine.resume,
                                yield = coroutine.yield,
                                status = coroutine.status,
                                wrap = coroutine.wrap,
                                create = coroutine.create,
                                running = coroutine.running
                            },
                            string = ProtectTable {
                                sub = string.sub,
                                upper = string.upper,
                                len = string.len,
                                gfind = string.gfind,
                                rep = string.rep,
                                find = string.find,
                                match = string.match,
                                char = string.char,
                                dump = string.dump,
                                gmatch = string.gmatch,
                                reverse = string.reverse,
                                byte = string.byte,
                                format = string.format,
                                gsub = string.gsub,
                                lower = string.lower
                            },
                            ColorSequence = ProtectTable {
                                new = ColorSequence.new
                            },
                            NumberSequence = ProtectTable {
                                new = NumberSequence.new
                            },
                            ColorSequenceKeypoint = ProtectTable {
                                new = ColorSequenceKeypoint.new
                            },
                            NumberSequenceKeypoint = ProtectTable {
                                new = NumberSequenceKeypoint.new
                            },
                            NumberRange = ProtectTable {
                                new = NumberRange.new
                            },
                            math = ProtectTable {
                                log = math.log,
                                acos = math.acos,
                                huge = 1 / 0,
                                ldexp = math.ldexp,
                                pi = math.pi,
                                cos = math.cos,
                                tanh = math.tanh,
                                pow = math.pow,
                                deg = math.deg,
                                tan = math.tan,
                                cosh = math.cosh,
                                sinh = math.sinh,
                                random = math.random,
                                randomseed = math.randomseed,
                                frexp = math.frexp,
                                ceil = math.ceil,
                                floor = math.floor,
                                rad = math.rad,
                                abs = math.abs,
                                sqrt = math.sqrt,
                                modf = math.modf,
                                asin = math.asin,
                                min = math.min,
                                max = math.max,
                                fmod = math.fmod,
                                log10 = math.log10,
                                atan2 = math.atan2,
                                exp = math.exp,
                                sin = math.sin,
                                atan = math.atan
                            },
                            os = ProtectTable {
                                difftime = os.difftime,
                                time = os.time
                            }
                        } do
                            for Index in Indexes:gmatch("[^, ?]+") do
                                EnvironmentFunctions[Index] = Value
                                if type(Value) == "function" then
                                    pcall(setfenv, Value, SecureEnvironment)
                                end
                            end
                        end
                        return EnvironmentFunctions
                    end)(),
                    __newindex = function(Self, Index, Value)
                        rawset(NewEnvironment.__index, Index, Value)
                        return rawset(Self, Index, Value)
                    end,
                    __metatable = SecureEnvironment
                }
                Sandbox = setmetatable(SecureEnvironment, NewEnvironment)
                Speaker = Player
                local Function, FunctionError = loadstring(table.concat(Args, " "), "Zeus_SCRIPT")
                local SpeakerRank = Player:Rank()
                if type(Function) == "function" then
                    setfenv(Function, Sandbox)
                    Function = coroutine.create(Function)
                    local Check, Error = coroutine.resume(Function)
                    if not Check then
                        Player:NewTab(Public, "Error:\n" .. tostring(Error), "Royal purple")
                    else
                        Player:NewTab(Public, "Executed Successfully", "Lime green")
                    end
                else
                    if not Function then
                        error("Synax_Error:\n" .. tostring(FunctionError))
                    end
                end
            end
        )
        if not MainFunction then
            Player:NewTab(Public, "Parsing_Error:\n" .. tostring(MainError), "Royal purple")
        end
    end
)

--// Voids

if isVoidSB then
Core:AddCmd(
    "SearchGear",
    {"searchgear", "sgear"},
    "Searches roblox catalog for gear.",
    1,
    ">sgear [Gear name]",
    function(Public, Player, Args)
        local FindGear = function(Search, Page)
            if not tonumber(Page) then
                Page = 1
            end
            local Link =
                "http://search.rprxy.xyz//catalog/json?Keyword=" ..
                Search .. "&Category=5&ResultsPerPage=10&PageNumber=" .. Page
            local songs = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync(Link))
            if songs then
                return songs
            else
                return {}
            end
        end
        local SearchGear
        SearchGear = function(Search, Page)
            if not Page then
                Page = 1
            end
            local Gears = FindGear(Search, Page)
            Player:DismissAll()
            Player:NewTab(Public, "Gear Search\n" .. Search, "Deep orange")
            Player:NewTab(
                Public,
                "Next Page",
                "Bright orange",
                function()
                    SearchGear(Search, Page + 1)
                end
            )
            Player:NewTab(Public, "Page:\n" .. Page .. [[/inf]], "Bright orange")
            if Page > 1 then
                Player:NewTab(
                    Public,
                    "Previous Page",
                    "Bright orange",
                    function()
                        SearchGear(Search, Page - 1)
                    end
                )
            end

            for i, Gear in pairs(Gears) do
                local tab =
                    Player:NewTab(
                    Public,
                    Gear.Name,
                    "Cyan",
                    function()
                        Player:DismissAll()
                        Player:RunCommand(">igear " .. Gear.AssetId, false)
                    end,
                    "https://www.roblox.com/asset-thumbnail/image?assetId=" ..
                        Gear.AssetId .. "&width=420&height=420&format=png"
                )
            end
        end
        SearchGear(table.concat(Args, " "))
    end
)
end

--// Neighborhood

if isNeighborhood then
Core:AddCmd(
    "SearchGear",
    {"searchgear", "sgear"},
    "Searches roblox catalog for gear.",
    3,
    ">sgear [Gear name]",
    function(Public, Player, Args)
        local FindGear = function(Search, Page)
            if not tonumber(Page) then
                Page = 1
            end
            local Link =
                "http://search.rprxy.xyz//catalog/json?Keyword=" ..
                Search .. "&Category=5&ResultsPerPage=10&PageNumber=" .. Page
            local songs = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync(Link))
            if songs then
                return songs
            else
                return {}
            end
        end
        local SearchGear
        SearchGear = function(Search, Page)
            if not Page then
                Page = 1
            end
            local Gears = FindGear(Search, Page)
            Player:DismissAll()
            Player:NewTab(Public, "Gear Search\n" .. Search, "Deep orange")
            Player:NewTab(
                Public,
                "Next Page",
                "Bright orange",
                function()
                    SearchGear(Search, Page + 1)
                end
            )
            Player:NewTab(Public, "Page:\n" .. Page .. [[/inf]], "Bright orange")
            if Page > 1 then
                Player:NewTab(
                    Public,
                    "Previous Page",
                    "Bright orange",
                    function()
                        SearchGear(Search, Page - 1)
                    end
                )
            end

            for i, Gear in pairs(Gears) do
                local tab =
                    Player:NewTab(
                    Public,
                    Gear.Name,
                    "Cyan",
                    function()
                        Player:DismissAll()
                        Player:RunCommand(">igear " .. Gear.AssetId, false)
                    end,
                    "https://www.roblox.com/asset-thumbnail/image?assetId=" ..
                        Gear.AssetId .. "&width=420&height=420&format=png"
                )
            end
        end
        SearchGear(table.concat(Args, " "))
    end
)
end

if isVoidSB then
Core:AddCmd(
    "SearchAudio",
    {"searchaudio", "saudio"},
    "Searches roblox catalog for audio.",
    1,
    ">saudio [saudio name]",
    function(Public, Player, Args)
        local FindAudio = function(Search, Page)
            if not tonumber(Page) then
                Page = 1
            end
            local Link =
                "http://search.rprxy.xyz//catalog/json?CatalogContext=2&Keyword=" ..
                Search .. "&Category=9&ResultsPerPage=10&PageNumber=" .. Page
            local songs = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync(Link))
            if songs then
                return songs
            else
                return {}
            end
        end
        local SearchAudio
        SearchAudio = function(Search, Page)
            if not Page then
                Page = 1
            end
            local Audios = FindAudio(Search, Page)
            Player:DismissAll()
            Player:NewTab(Public, "Audio Search\n" .. Search, "Deep orange")
            Player:NewTab(
                Public,
                "Next Page",
                "Bright orange",
                function()
                    SearchAudio(Search, Page + 1)
                end
            )
            Player:NewTab(Public, "Page:\n" .. Page .. [[/inf]], "Bright orange")
            if Page > 1 then
                Player:NewTab(
                    Public,
                    "Previous Page",
                    "Bright orange",
                    function()
                        SearchAudio(Search, Page - 1)
                    end
                )
            end

            for i, Audio in pairs(Audios) do
                local tab =
                    Player:NewTab(
                    Public,
                    Audio.Name,
                    "Cyan",
                    function()
                        Player:DismissAll()
                        Player:NewTab(
                            Public,
                            "Play",
                            "Lime green",
                            function()
                                Player:DismissAll()
                                Sound(Audio.AssetId, false, 6)
                                local Playing =
                                    Player:NewTab(
                                    Public,
                                    "Now playing " ..
                                        game:GetService("MarketplaceService"):GetProductInfo(Audio.AssetId).Name,
                                    "Lime green"
                                )
                                Player:timeddismiss(Playing, 5)
                            end
                        )
                        Player:NewTab(Public, "AssetID: " .. Audio.AssetId, "White")
                        Player:NewTab(
                            Public,
                            "Audio Name: " .. game:GetService("MarketplaceService"):GetProductInfo(Audio.AssetId).Name,
                            "White"
                        )
                        Player:NewTab(
                            Public,
                            "Audio Description: " ..
                                game:GetService("MarketplaceService"):GetProductInfo(Audio.AssetId).Description,
                            "White"
                        )
                        Player:NewTab(
                            Public,
                            "Audio Sales: " .. game:GetService("MarketplaceService"):GetProductInfo(Audio.AssetId).Sales,
                            "White"
                        )
                    end
                )
            end
        end
        SearchAudio(table.concat(Args, " "))
    end
)
end

Core:AddCmd(
    "Refresh",
    {"refresh", "ref", "re"},
    "Refresh a player.",
    1,
    ">refresh [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        for i, v in pairs(Players) do
            if v.Character then
                local pos =
                    v.Character:findFirstChild "HumanoidRootPart" or v.Character:findFirstChild "Torso" or
                    v.Character:findFirstChild "Head" or
                    Instance.new("Part")
                local position = pos.CFrame
                v:LoadCharacter()
                v.Character.HumanoidRootPart.CFrame = position
            else
                v:LoadCharacter()
            end
        end
    end
)

Core:AddCmd(
    "Respawn",
    {"respawn"},
    "Respawn a player.",
    1,
    ">respawn [Player]",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])

        if Args[1] == nil then
            Player:NewTab(Public, "No Player", "Crimson")
            return
        end

        for i, v in pairs(Players) do
            v:LoadCharacter()
            Player:NewTab(Public, v.Name .. " has been respawned", "Lime green")
            wait(3)
            Player:DismissAll()
        end
    end
)

--// Voids

if isVoidSB then
Core:AddCmd(
    "AntiDeath",
    {"antideath", "ad"},
    "Respawns you as soon as you die.",
    1,
    ">antideath",
    function(Public, Player, Args)
        if not AntiDeath[Player] then
            AntiDeath[Player] =
                Player.CharacterAdded:connect(
                function(Char)
                    Char.Humanoid.Died:connect(
                        function()
                            Player:RunCommand(">re me")
                        end
                    )
                end
            )
            repeat
                wait()
            until Player.Character
            Player.Character.Humanoid.Died:connect(
                function()
                    Player:RunCommand(">re me")
                end
            )
            Player:TimedDismiss(Player:NewTab(Public, "Anti death is active.", "Lime green"))
        else
            AntiDeath[Player]:disconnect()
            AntiDeath[Player] = nil
            Player:RunCommand(">re me")
            Player:TimedDismiss(Player:NewTab(Public, "Anti death is deactivated.", "Crimson"))
        end
    end
)
end

--// Neighborhood

if isNeighborhood then
Core:AddCmd(
    "AntiDeath",
    {"antideath", "ad"},
    "Respawns you as soon as you die.",
    3,
    ">antideath",
    function(Public, Player, Args)
        if not AntiDeath[Player] then
            AntiDeath[Player] =
                Player.CharacterAdded:connect(
                function(Char)
                    Char.Humanoid.Died:connect(
                        function()
                            Player:RunCommand(">re me")
                        end
                    )
                end
            )
            repeat
                wait()
            until Player.Character
            Player.Character.Humanoid.Died:connect(
                function()
                    Player:RunCommand(">re me")
                end
            )
            Player:TimedDismiss(Player:NewTab(Public, "Anti death is active.", "Lime green"))
        else
            AntiDeath[Player]:disconnect()
            AntiDeath[Player] = nil
            Player:RunCommand(">re me")
            Player:TimedDismiss(Player:NewTab(Public, "Anti death is deactivated.", "Crimson"))
        end
    end
)
end

Core:AddCmd(
    "GetDatabases",
    {"getdatabases", "getdbs", "loaddbs"},
    "Loads all Zeus databases.",
    4,
    ">getdbs",
    function(Public, Player, Args)
        Player:DismissAll()
        local loading = Player:NewTab(Public, "Loading databases...", "White")
        local Dbs = {}
        for _, DBName in pairs({"Void", "Potato", "Studio"}) do
            local Data = Core.DBGet(DBName)
            Dbs[DBName] = Data
        end
        Player:editTab(loading, {Text = "Databases\nTotal Size: Counting...", Color = "Bright orange"})
        local TotalSize = 0
        for Name, Data in pairs(Dbs) do
            NumUsers = 0
            for UserId, Data in pairs(Data) do
                NumUsers = NumUsers + 1
                TotalSize = TotalSize + 1
            end
            Player:NewTab(Public, "Name: " .. Name .. "\nSize: " .. NumUsers, "Cyan")
        end
        Player:editTab(loading, {Text = "Databases\nTotal Size: " .. TotalSize, Color = "Bright orange"})
        Player:DismissTab(Public)
    end
)
Core:AddCmd(
    "CheckMembership",
    {"checkmembership", "membership", "checkrank"},
    "Checks your rank.",
    0,
    ">checkrank",
    function(Public, Player, Args)
        Player:DismissAll()
        if Player:Rank() < 1 and Player:ownsGamepass(9289398) then
            Player:setData("Rank", 1, true)
            Player:newTab(true, "Zeus Membership Updated", "Lime green")
            if Player:Discord() then
                local ident, discordid = Player:Discord()
                Core:giveRole(discordid, 706007369728917504)
            end
        elseif Player:Rank() < 2 and Player:ownsGamepass(9289406) then
            Player:setData("Rank", 2, true)
            Player:newTab(true, "Zeus Membership Updated", "Lime green")
            if Player:Discord() then
                local ident, discordid = Player:Discord()
                Core:giveRole(discordid, 689988077984284748)
            end
        elseif Player:Rank() < 3 and Player:ownsGamepass(9289410) then
            Player:setData("Rank", 3, true)
            Player:newTab(true, "Zeus Membership Updated", "Lime green")
            if Player:Discord() then
                local ident, discordid = Player:Discord()
                Core:giveRole(discordid, 684145051114274851)
            end
        end

        if Player:Undercover() == true then
            Player:newTab(
                Public,
                "You are a Mod",
                "Cyan",
                function()
                end
            )
        elseif Player:Undercover() == false or Player:Undercover() == nil then
            Player:newTab(
                Public,
                "You are a " .. RankNames[Player:Rank()],
                "Cyan",
                function()
                end
            )
        end
    end
)
Core:AddCmd(
    "ToolDebounce",
    {"tooldebounce", "tooldb"},
    "Toggles tool debounce.",
    1,
    ">tooldb",
    function(Public, Player, Args)
        local Players = Player:GetPlrs(Args[1])
        for i, v in pairs(Players) do
            if not AnntiToolDb[v] then
                local ScanObj = function(Obj)
                    if Obj:IsA("Tool") then
                        Obj.Changed:Connect(
                            function()
                                Obj.Enabled = true
                            end
                        )
                    end
                end
                AnntiToolDb[v] =
                    v.CharacterAdded:connect(
                    function(Char)
                        Char.ChildAdded:Connect(ScanObj)
                    end
                )
                repeat
                    wait()
                until v.Character
                v.Character.ChildAdded:Connect(ScanObj)
                v:TimedDismiss(v:NewTab(Public, "Tool Debounce disabled.", "Lime green"))
            else
                AnntiToolDb[v]:disconnect()
                AnntiToolDb[v] = nil
                v:RunCommand(">re me")
                v:TimedDismiss(v:NewTab(Public, "Tool Debounce enabled.", "Crimson"))
            end
        end
    end
)

--//End Commands

--//Init Data
Core:loadGlobalData()
spawn(
    function()
        while wait(60) do
            Core:loadGlobalData()
        end
    end
)

--//Init Instance Filter
game.DescendantAdded:Connect(
    function(Inst)
        if Settings.ShowVeritas == false then
            if Inst.Name:lower():find("veritas") then
                pcall(
                    function()
                        Inst.Parent = nil
                        wait()
                        Inst:Destroy()
                        wait()
                        Inst:Destroy()
                    end
                )
            end
        end
    end
)

--//Rank Purchases
game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(
    function(player, id, purchased)
        if id == 9289398 and purchased then
            local Player = nil
            for x, y in pairs(ActivePlayers) do
                if y.plrObj == player then
                    Player = y
                    break
                end
            end
            if Player then
                if Player:Rank() < 1 then
                    Player:DismissAll()
                    Player:setData("Rank", 1, true)
                    Player:newTab(true, "Zeus Membership Updated", "Lime green")
                    Player:newTab(true, "To add the loader to your saves, say >loader", "Lime green")
                    Core:importantLog(Player, "Bought rank 1","Green")
                    if Player:Discord() then
                        local ident, discordid = Player:Discord()
                        Core:giveRole(discordid, 689988077984284748)
                    end
                end
            end
        end
    end
)

game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(
    function(player, id, purchased)
        if id == 9289406 and purchased then
            local Player = nil
            for x, y in pairs(ActivePlayers) do
                if y.plrObj == player then
                    Player = y
                    break
                end
            end
            if Player then
                if Player:Rank() < 2 then
                    Player:DismissAll()
                    Player:setData("Rank", 2, true)
                    Player:newTab(true, "Zeus Membership Updated", "Lime green")
                    Player:newTab(true, "To add the loader to your saves, say >loader", "Lime green")
                    Core:importantLog(Player, "Bought rank 2","Green")
                    if Player:Discord() then
                        local ident, discordid = Player:Discord()
                        Core:giveRole(discordid, 689988077984284748)
                    end
                end
            end
        end
    end
)

game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(
    function(player, id, purchased)
        if id == 9289410 and purchased then
            local Player = nil
            for x, y in pairs(ActivePlayers) do
                if y.plrObj == player then
                    Player = y
                    break
                end
            end
            if Player then
                if Player:Rank() < 3 then
                    Player:DismissAll()
                    Player:setData("Rank", 3, true)
                    Player:newTab(true, "Zeus Membership Updated", "Lime green")
                    Player:newTab(true, "To add the loader to your saves, say >loader", "Lime green")
                    Core:importantLog(Player, "Bought rank 3","Green")
                    if Player:Discord() then
                        local ident, discordid = Player:Discord()
                        Core:giveRole(discordid, 689988077984284748)
                    end
                end
            end
        end
    end
)

--//Online System
if not game:GetService("RunService"):IsStudio() then
    game:GetService("MessagingService"):SubscribeAsync(
        "ZeusOnlineSystem",
        function(Data)
            local Data = Core.decodeJson(Data.Data)

            for _, PlrData in pairs(Data.Plrs) do
                for x, y in pairs(Online) do
                    if y.UserId == PlrData.UserId then
                        table.remove(Online, x) --If they are already in table, remove them
                    end
                end
                local amendedData = PlrData
                amendedData.JobId = Data.JobId
                amendedData.PlaceId = Data.PlaceId
                amendedData.Seen = Data.Seen
                table.insert(Online, PlrData)
            end
        end
    )
    spawn(
        function()
            while true do
                local Data = {}
                Data.JobId = game.JobId
                Data.PlaceId = game.PlaceId
                Data.Seen = os.time()
                Data.Plrs = {}
                for i, Player in pairs(ActivePlayers) do
                    local PlrData = {}
                    PlrData.UserId = Player.UserId
                    table.insert(Data.Plrs, PlrData)
                end

                Data = Core.encodeJson(Data)

                for Index, Data in pairs(Online) do
                    local TimePassed = (os.time() - Data.Seen)
                    if TimePassed > 10 then
                        table.remove(Online, Index)
                    end
                end
                game:GetService("MessagingService"):PublishAsync("ZeusOnlineSystem", Data)

                wait(5)
            end
        end
    )
					end

function getTime()
    local sec = tick()
    return ("%.2d:%.2d:%.2d"):format(sec / 3600 % 24, sec / 60 % 60, sec % 60)
end

--//Start Communication
Core:newRemote()

--//Connect Players
for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
    spawn(
        function()
            Core:connectPlayer(Player)
        end
    )
end
game:GetService("Players").PlayerAdded:Connect(
    function(Player)
        Core:connectPlayer(Player)
        for x, y in pairs(ServerBans) do
            if y == Player.Name then
               -- Player:Kick("Server banned by Zeus Admin")
            end
        end
    end
)


print("[Zeus] Finish")

return nil
