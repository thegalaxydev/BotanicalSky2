local Util = {}

function Util.Single(t: {[number]: any}) --idk why I made this just felt like not doing _, value
	local function iter(tbl, index)
		index = index + 1
		local value = tbl[index]

		return value
	end

	return iter, t, 0
end

return Util