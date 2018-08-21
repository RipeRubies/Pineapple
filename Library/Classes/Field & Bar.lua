Spice.Objects.Classes.new("Field",function(siz,...)
	local ud, Color, set, v2, um = Spice.Positioning.new, Spice.Color, Spice.Properties.setProperties, Spice.Positioning.fromVector2, Spice.Positioning.fromUDim
	local rest = type(siz) == 'string' and true or false
	local pos, br, pad, brcol
	local args = {...}
	if type(args[1]) == 'number' then
		pos, br, pad, brcol = ...
	else
		br, pad, brcol = ...
	end
	local field = Spice.Objects.newInstance("Frame",nil,{Position = ud(0,pos or 0,2),Transparency = 1,Size = not rest and ud(1,siz,4) or ud(1,0,1),BorderSizePixel = 0})
	if br then
		local bre = Spice.Objects.newInstance('Frame',field,{Size = ud(1,-(pad or 0)*2,0,1),BackgroundColor3 = brcol or Color.fromHex'#e9e9e9',BorderSizePixel = 0,Position = ud(0,pad or 0,1,0),ap = v2(0,1)})
	end
	if rest then
		field.AncestryChanged:connect(function(me, mom)
			me.Size = ud(1,0,1,-me.Position.Y.Offset - (me.Position.Y.Scale*mom.AbsoluteSize.Y))
		end)
	end
	return field
end)

Spice.Objects.Classes.new("Bar",function(thickness,width)
	local bar = Spice.Objects.Custom.new("Frame",nil,{BorderSizePixel = 0,Size = UDim2.new(width and type(width) == 'number' and UDim.new(width,0) or width or UDim.new(1,0), UDim.new(0, thickness or 1))})
	bar:Index('Width',function(self)
		return self.Instance.Size.X
	end)
	bar:Index('Thickness',function(self)
		return self.Instance.Size.Y.Offset
	end)
	bar:NewIndex('Width',function(self,new)
		self.Instance.Size = UDim2.new(type(new) == 'number' and UDim.new(new,0) or new, self.Instance.Size.Y)
	end)
	bar:NewIndex('Thickness',function(self,new)
		self.Instance.Size = UDim2.new(self.Instance.Size.X, UDim.new(0,new))
	end)
	bar.TweenColor3 = function(self, color, ...)
		Spice.Motion.tweenServiceTween(bar.Instance, 'BackgroundColor3', color, ...)
	end
	bar.TweenThickness = function(self, new,...)
		Spice.Motion.tweenServiceTween(bar.Instance, 'Size',  UDim2.new(self.Instance.Size.X, UDim.new(0,new)), ...)
	end
	bar.TweenWidth = function(self, new,...)
		Spice.Motion.tweenServiceTween(bar.Instance, 'Size',  UDim2.new(type(new) == 'number' and UDim.new(new,0) or new, self.Instance.Size.Y), ...)
	end
	return bar
end)
