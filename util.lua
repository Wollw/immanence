local util = T{};

util.setOrToggle = function(setting, arg)
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

util.firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

util.tableContains = function(t, value)
	for k, v in pairs(t) do
		if v == value then
			return k;
		end
	end
	return nil;
end

util.rotate = function(setting, length, arg) 
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

util.getVariantFromName = function (table, name)
	for k, v in pairs(table) do
		if v == name then
			return k;
		end
	end
	return nil;
end

util.setOrRotate = function(table, setting, arg)
	if arg and util.tableContains(table, arg) then
		return util.getVariantFromName(table, arg);
	else
		return util.rotate(setting, #table, arg);
	end
end

util.setToggleOrRotate = function (table, setting, arg)
	if table then
		return util.setOrRotate(table, setting, arg);
	else
		return util.setOrToggle(setting, arg);
	end
end

return util;