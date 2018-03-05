Misc = {
	Functions = {
		tweenService = function(what,prop,to,...)
			local args = {...}
			local props = {}
			local tim,style,direction,rep,reverse,delay
			for i,v in next,args do
				if type(v) == 'string' or typeof(v) == 'EnumItem' then
					if style == nil then
						style = v and type(v) ~= 'string' or Enum.EasingStyle[v]
					else
						direction = v and type(v) ~= 'string' or Enum.EasingDirection[v]
					end
				elseif type(v) == 'number' then
					if tim == nil then
						tim = v
					elseif rep == nil then
						rep = v
					else
						delay = v
					end
				elseif type(v) == 'boolean' then
					reverse = v
				end
			end
			for i,v in next,type(prop) == 'table' and prop or {prop} do
				props[Citrus.Properties[v]] = type(to) ~= 'table' and to or to[i]
			end
			return game:GetService('TweenService'):Create(what,TweenInfo.new(tim,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,reverse or false,delay or 0),props):Play()
		end;
		stringFilterOut = function(string,starting,ending,...)
			local args,disregard,tostr,flip = {...}
			for i,v in pairs(args)do
				if type(v) == 'boolean' then
					if flip == nil then flip = v else tostr = v end
				elseif type(v) == 'string' then
					disregard = v
				end
			end
			local filter,out = {},{}
			for i in string:gmatch(starting) do
				if not Citrus.Misc.Functions.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
					local filtered = string:sub(string:find(starting),ending and ({string:find(ending)})[2] or ({string:find(starting)})[2])
					local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
					table.insert(filter,filtered~=disregard and filtered or nil)
					table.insert(out,o~=disregard and o or nil)
				else
					table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
				end
				string = string:sub((ending and ({string:find(ending)})[2] or ({string:find(starting)})[2]) + 1)
			end
			table.insert(out,string)
			filter = tostr and table.concat(filter) or filter
			out = tostr and table.concat(out) or out
			return flip and out or filter, flip and filter or out
		end;
		switch = function(...)
			return setmetatable({filter = {},Default = false,data = {...},
				Filter = function(self,...)
					self.filter = {...}
					return self
				end;	
				Get = function(self,what)	
					local i = what
					if Citrus.Misc.Table.find(self.data,what) then
						i = Citrus.Misc.Table.indexOf(self.data,what)
					end
					if Citrus.Misc.Table.find(self.filter,what) then
						i = Citrus.Misc.Table.indexOf(self.filter,what)
					end
					return self.data[i]
				end},{
					__call = function(self,what,...)
						local get = self:Get(what)
						return get and (type(get) ~= 'function' and get or get(...)) or self.Default
					end;
				})
		end;
		round = function(num)
			return math.floor(num+.5)
		end;
		contains = function(containing,...)
			for _,content in next,{...} do
				if content == containing then
					return true
				end
			end
			return false
		end;
		operation = function(a,b,opa)
			return Citrus.Misc.Functions.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b)):Filter('+','-','*','/','%','^','^/','x','pow','rt')(opa)
		end;
	};
	Table = {
		pack = function(tabl,start)
			local new = {}
			for i = start or 1, #tabl do
				table.insert(new,tabl[i])
			end
			return new
		end;
		merge = function(who,what)
			for i,v in next,who do
				if what[i] then
					for a,z in next,v do
						what[i][a] = z
					end
				else
					what[i] = v
				end
			end
			return what
		end;
		clone = function(tab)
			local clone = {}
			for i,v in next,tab do
				if type(v) == 'table' then
					clone[i] = Citrus.Misc.Table.clone(v)
					if getmetatable(v) then
						local metaclone = Citrus.Misc.Table.clone(getmetatable(v))
						setmetatable(clone[i],metaclone)
					end
				else
					clone[i] = v
				end
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
			return false
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
			return #Citrus.Misc.Table.toNumeralIndex(tab)
		end;
		reverse = function(tab)
			local new ={}
			for i,v in next,tab do
				new[#tab+1-1] = v
			end
			return new
		end;
		indexOf = function(tabl,val)
			return Citrus.Misc.Table.contains(tabl,val,3)
		end;
		valueOfNext = function(tab,nex)
			local i,v = next(tab,nex)
			return v
		end;
		find = function(tabl,this)
			return Citrus.Misc.Table.contains(tabl,this,2)
		end;
		search = function(tabl,this)
			local misc = Citrus.Misc
			if misc.Table.find(tabl,this) then
				return misc.Table.find(tabl,this)
			end
			for i,v in next,tabl do
				if type(i) == 'string' or type(v) == 'string' then
					local subject = type(i) == 'string' and i or type(v) == 'string' and v
					local caps = misc.Functions.stringFilterOut(subject,'%u',nil,false,true)
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
			local new = Citrus.Misc.Table.clone(setmetatable(tabl,set))
			setmetatable(tabl,old)
			return new
		end;
	};
}