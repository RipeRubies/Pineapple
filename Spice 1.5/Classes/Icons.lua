Spice.Instance.newClass("Icon",function(...)
	return Spice.Imagery.insertImage(...)
end)
Spice.Instance.newClass("IconButton",function(...)
	return Spice.Imagery.toImage(Spice.Instance.newInstace('ImageButton'), ...)
end)
