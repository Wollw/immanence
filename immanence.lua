addon.name      = 'immanence';                    -- The name of the addon.
addon.author    = 'wolliw';                     -- The name of the addon author.
addon.version   = '0.1';                        -- The version of the addon. (No specific format, x.x at least recommended.)
addon.desc      = 'Scholar Immanence skillchain handler.';    -- (Optional) The description of the addon.
addon.link      = '';      -- (Optional) The link to the addons homepage.

require 'common';

local CommandSettingMap = {
    sc = "Skillchain",
    skillchain = "Skillchain",

    h = "UseHelix",
    helix = "UseHelix",
};

local Settings = {
    Skillchain = 9,
    UseHelix = false,
};

local VariantTables = {
    Skillchain = {},
};

local SkillchainTable = {
	[1] = {property = 'Transfixion', elements = 'Light'},
	[2] = {property = 'Compression', elements = 'Dark'},

	[3] = {property = 'Liquefaction', elements = 'Fire'},
	[4] = {property = 'Induration', elements = 'Ice'},
	[5] = {property = 'Detonation', elements = 'Wind'},
	[6] = {property = 'Scission', elements = 'Earth'},
	[7] = {property = 'Impaction', elements = 'Lightning'},
	[8] = {property = 'Reverberation', elements = 'Water'},
	
	[9] = {property = 'Fusion', elements = 'Fire / Light'},
	[10] = {property = 'Gravitation', elements = 'Earth / Dark'},
	[11] = {property = 'Fragmentation', elements = 'Wind / Lightning'},
	[12] = {property = 'Distortion', elements = 'Water / Ice'},

	[13] = {property = 'Six Step - Earth Wind [Naked]', elements = 'Earth -> Wind -> ...'},
	[14] = {property = 'Six Step - Earth Wind', elements = 'Earth -> Wind -> ...'},
	[15] = {property = 'Six Step - Earth Fire', elements = 'Earth -> Fire -> ...'},
	[16] = {property = 'Three Step - Fusion', elements = 'Fire -> Fire / Light'},
	[17] = {property = 'Three Step - Fusion [Helix]', elements = 'Fire -> Fire / Light'},
};


local setOrToggle = function(setting, arg)
	if arg == "true" or arg == "on" then
		return true;
	elseif arg == "false" or arg == "off" then
		return false;
	elseif arg == "toggle" then
		return not setting;
	else
		return setting;
	end
end

local firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

local tableContains = function(t, value)
	for k, v in pairs(t) do
		if v == value then
			return k;
		end
	end
	return nil;
end

local rotate = function(setting, length, arg) 
	local direction;
	if not arg then
		return setting;
	elseif arg == "next" then
		if setting + 1 > length then
			return 1;
		else
			return setting + 1;
		end
	elseif arg == "prev" or arg == "previous" then
		if setting - 1 < 1 then
			return length;
		else
			return setting - 1;
		end
	else
		return setting;
	end
end

local getVariantFromName = function (table, name)
	for k, v in pairs(table) do
		if v == name then
			return k;
		end
	end
	return nil;
end

local setOrRotate = function(table, setting, arg)
	if arg and tableContains(table, arg) then
		return getVariantFromName(table, arg);
	else
		return rotate(setting, #table, arg);
	end
end

local tableContains = function(t, value)
	for k, v in pairs(t) do
		if v == value then
			return k;
		end
	end
	return nil;
end


local setToggleOrRotate = function (table, setting, arg)
	if table then
		return setOrRotate(table, setting, arg);
	else
		return setOrToggle(setting, arg);
	end
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_callback1', function ()
    for k,v in pairs(SkillchainTable) do
        VariantTables.Skillchain[k] = v.property;
    end
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_callback1', function ()
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_callback1', function (e)
    local args = e.command:args();
	if (args[1] == '/imm') then

        local setting = CommandSettingMap[args[2]];
        if setting then
            Settings[setting] = setToggleOrRotate(VariantTables[setting], Settings[setting], args[3]);
            if Settings[setting] ~= nil then
                if VariantTables[setting] then
                    print('[' .. addon.name .. ']' .. setting .. ": " .. VariantTables[setting][Settings[setting]]);
                else
                    print('[' .. addon.name .. ']' .. setting .. ": " .. (Settings[setting] and "On" or "Off"));
                end
            end
        elseif args[2] == 'cast' then
            local command = '/exec "..\\addons\\' .. addon.name .. '\\' .. 'scripts\\';
            if (Settings.Skillchain <= 12) then
                if (Settings.UseHelix) then
                    command = command .. 'helix\\';
                end
                command = command .. SkillchainTable[Settings.Skillchain].property;
            else
                command = command .. 'misc\\';
                command = command .. SkillchainTable[Settings.Skillchain].property;
            end
            command = command .. '"';
            AshitaCore:GetChatManager():QueueCommand(-1, command);
        end
    end
end);

