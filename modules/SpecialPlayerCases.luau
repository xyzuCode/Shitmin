local Players = game:GetService("Players")

local SpecialPlayerCases = {

	["all"] = function()
		return Players:GetPlayers()
	end,

	["others"] = function(speaker)
		local t = {}
		for _, v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(t, v)
			end
		end
		return t
	end,

	["me"] = function(speaker)
		return { speaker }
	end,

	["#(%d+)"] = function(_, args, currentList)
		local returns = {}
		local amount = tonumber(args[1])
		local pool = { unpack(currentList) }

		for _ = 1, amount do
			if #pool == 0 then break end
			local i = math.random(1, #pool)
			table.insert(returns, pool[i])
			table.remove(pool, i)
		end

		return returns
	end,

	["random"] = function(speaker)
		local players = Players:GetPlayers()
		table.remove(players, table.find(players, speaker))
		return { players[math.random(1, #players)] }
	end,

	["%%(.+)"] = function(_, args)
		local returns = {}
		local team = args[1]:lower()

		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Team and plr.Team.Name:lower():sub(1, #team) == team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["team"] = function(speaker)
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Team == speaker.Team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["nonteam"] = function(speaker)
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= speaker.Team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["friends"] = function(speaker)
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["nonfriends"] = function(speaker)
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["guests"] = function()
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["bacons"] = function()
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			local c = plr.Character
			if c and (c:FindFirstChild("Pal Hair") or c:FindFirstChild("Kate Hair")) then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["age(%d+)"] = function(_, args)
		local returns = {}
		local age = tonumber(args[1])
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["group(%d+)"] = function(_, args)
		local returns = {}
		local gid = tonumber(args[1])
		for _, plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(gid) then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["alive"] = function()
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
			if h and h.Health > 0 then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["dead"] = function()
		local returns = {}
		for _, plr in pairs(Players:GetPlayers()) do
			local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
			if not h or h.Health <= 0 then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["rad(%d+)"] = function(speaker, args)
		local returns = {}
		local radius = tonumber(args[1])
		local root = speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		for _, plr in pairs(Players:GetPlayers()) do
			local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if r and (r.Position - root.Position).Magnitude <= radius then
				table.insert(returns, plr)
			end
		end
		return returns
	end,

	["nearest"] = function(speaker, _, currentList)
		local root = speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local closest, dist = nil, math.huge
		for _, plr in pairs(currentList) do
			local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if r then
				local d = (r.Position - root.Position).Magnitude
				if d < dist then
					dist = d
					closest = plr
				end
			end
		end

		return closest and { closest } or {}
	end,

	["farthest"] = function(speaker, _, currentList)
		local root = speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local farthest, dist = nil, 0
		for _, plr in pairs(currentList) do
			local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if r then
				local d = (r.Position - root.Position).Magnitude
				if d > dist then
					dist = d
					farthest = plr
				end
			end
		end

		return farthest and { farthest } or {}
	end,

	["npcs"] = function()
		local returns = {}

		for _, m in pairs(workspace:GetDescendants()) do
			if m:IsA("Model")
				and m:FindFirstChildOfClass("Humanoid")
				and m:FindFirstChild("HumanoidRootPart")
				and not Players:GetPlayerFromCharacter(m) then

				local fake = Instance.new("Player")
				fake.Name = m.Name
				fake.Character = m
				table.insert(returns, fake)
			end
		end

		return returns
	end,
}

return SpecialPlayerCases
