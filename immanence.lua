addon.name      = 'immanence';                    -- The name of the addon.
addon.author    = 'wolliw';                     -- The name of the addon author.
addon.version   = '0.1';                        -- The version of the addon. (No specific format, x.x at least recommended.)
addon.desc      = 'Scholar Immanence skillchain handler.';    -- (Optional) The description of the addon.
addon.link      = '';      -- (Optional) The link to the addons homepage.

require 'common';
local chat = require 'chat';
local util = require 'util';

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
		      
		-- Hanldle most configuration commands.
        if setting then
            Settings[setting] = util.setToggleOrRotate(VariantTables[setting], Settings[setting], args[3]);
            if Settings[setting] ~= nil then
                if VariantTables[setting] then
					print(chat.header(util.firstToUpper(addon.name))
						.. chat.message('Skillchain: ')
						.. chat.color1(2, SkillchainTable[Settings[setting]].property)
						.. ' [' .. chat.color1(2, SkillchainTable[Settings[setting]].elements) .. ']');
                else
					print(chat.header(util.firstToUpper(addon.name))
						.. chat.message('Helix: ')
						.. chat.color2(2, Settings[setting]));
                end
            end
		-- Start a skillchain.
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
			print(chat.header(util.firstToUpper(addon.name))
				.. chat.message('Casting: ')
				.. chat.color1(2, VariantTables['Skillchain'][Settings['Skillchain']]));
            AshitaCore:GetChatManager():QueueCommand(-1, command);
        end
    end
end);

