local fileName="db/test"

function readFile(name)
	local filename=name
	if filename==nil then
		filename=fileName
	end
	if fs.exists(filename)==false then
		fs.open(filename,"w").close()
	end
	local file=fs.open(filename,"r")
	local text=file.readAll()
	file.close()
	return text
end

function cleanFile(name)
	local text=readFile(name)
	repeat
		text=string.gsub(text,"%]%]","]")
	until string.match(text,"%]%]")==nil
	writeFile(name,text,true)
end

function writeFile(name,text,isCleaning)
	local filename=name
	if filename==nil then
		filename=fileName
	end
	fs.delete(filename)
	local file=fs.open(filename,"w")
	file.write(text)
	file.close()
	if isCleaning==nil then
		cleanFile(name)
	end
end

function set(key,value,name)
	local text=readFile(name)
	local currentValue=get(key,name)
	if currentValue==nil then
		if value==nil then
			return
		end
		writeFile(name,text.."\n["..key.."]=["..tostring(value).."]")
	else
		if value==nil then
			writeFile(name,text:gsub("%["..key.."%]=%[.[^%]]*",""))
		end
		writeFile(name,text:gsub("%["..key.."%]=%[.[^%]]*","["..key.."]=["..tostring(value)..""))
	end
end

function get(key,name)
	local text=readFile(name) 
	local match=string.match(text,"%["..key.."%]=%[.[^%]]*")
	if match==nil then
		return nil
	else
		local final=string.gsub(string.gsub(match,"%["..key.."%]=%[",""),"%]","")
		return final--string.sub(final,1,string.len(final)-1)
	end	
end

function getAll(name)
	local entries = {}
	local text=readFile(name)
	for entry in string.gmatch(text,"[^%[.]+%]=%[[^%]]+") do 
		local start = string.find(entry,"%]=%[")
		local id = string.sub(entry,0,start-1)
		local value = string.sub(entry,start+3,string.len(entry))
		entries[id]=value
	end
	return entries
end

return { readFile = readFile, cleanFile = cleanFile, writeFile = writeFile, set = set, get = get, getAll = getAll }