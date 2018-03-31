Table = {
	pack = function(tabl,start,en)
		local new = {}
		for i = start or 1, en or #tabl do
			table.insert(new,tabl[i])
		end
		return new
	end;
	merge = function(from,to)
		for i,v in next, from do
			to[i] = v
		end
		return to
	end;
	clone = function(tab)
		local clone = {}
		for i,v in next,tab do
			if type(v) == 'table' then
				clone[i] = Citrus.Table.clone(v)
				if getmetatable(v) then
					local metaclone = Citrus.Table.clone(getmetatable(v))
					setmetatable(clone[i],metaclone)
				end
			else
				clone[i] = v
			end
		end
		if getmetatable(tab) then
			local metaclone = getmetatable(tab)
			setmetatable(clone,metaclone)
		end
		return clone
	end;
	contains = function(tabl,contains,typ)
		for i,v in next,tabl do
			if v == contains or (typeof(i) == typeof(contains) and v == contains) or i == contains then
				if typ then
					return ({true,v,i})[typ]
				else
					return true,v,i
				end
			end
		end
		return nil
	end;
	toNumeralIndex = function(tabl)
		local new = {}
		for index,v in next,tabl do
			if type(index) ~= 'number' then
				table.insert(new,{index,v})
			else
				table.insert(new,index,v)
			end
		end
		setmetatable(new,{
				__index = function(self,index)
					for i,v in next,self do
						if type(v) == 'table' and v[1] == index then
							return v[2]
						end
					end
				end
				})
		return new
	end;
	length = function(tab)
		return #Citrus.Table.toNumeralIndex(tab)
	end;
	reverse = function(tab)
		local new ={}
		for i,v in next,tab do
			table.insert(new,tab[#tab-i+1])
		end
		return new
	end;
	indexOf = function(tabl,val)
		return Citrus.Table.contains(tabl,val,3)
	end;
	valueOfNext = function(tab,nex)
		local i,v = next(tab,nex)
		return v
	end;
	find = function(tabl,this)
		return Citrus.Table.contains(tabl,this,2)
	end;
	search = function(tabl,this)
		if Citrus.Table.find(tabl,this) then
			return Citrus.Table.find(tabl,this)
		end
		for i,v in next,tabl do
			if type(i) == 'string' or type(v) == 'string' then
				local subject = type(i) == 'string' and i or type(v) == 'string' and v
				local caps = Citrus.Misc.stringFilterOut(subject,'%u',nil,false,true)
				local numc = caps..(subject:match('%d+$') or '')
				if subject:lower():sub(1,#this) == this:lower() or caps:lower() == this:lower() or numc:lower() == this:lower() then
					return v,i
				end
			end
		end
		return false
	end;
	anonSetMetatable = function(tabl,set)
		local old = getmetatable(tabl)
		local new = Citrus.Table.clone(setmetatable(tabl,set))
		setmetatable(tabl,old)
		return new
	end;
};
