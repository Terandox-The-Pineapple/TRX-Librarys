if fs.exists("data") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/data.lua data") end
local data = require("data")

function initLanguageLink()
    if data.get("LangLink", "config") == nil then
        io.write("Use Custom Language File? ( y , n ): ")
        local readHolder = read()
        if readHolder == "y" or readHolder == "yes" or readHolder == "Yes" then
            io.write("Link: ")
            local pbLink = read()
            data.set("LangLink", pbLink, "config")
        else
            data.set("LangLink", "https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/TRXDictionary.lua", "config")
        end
    end
end

function setLanguage()
    local dictionary = data.get("dictionary", "dictionary")
    dictionary = textutils.unserialise(dictionary)

    if data.get("language", "config") == nil then
        local langString = "Language ("
        local langAmount = tablelength(dictionary)
        local counter = 1
        for index, lang in pairs(dictionary) do
            langString = langString .. " " .. index .. " "
            if counter < langAmount then
                langString = langString .. ","
            else
                langString = langString .. "): "
            end
            counter = counter + 1
        end
        io.write(langString)
        local lang = read()
        if dictionary[lang] == nil then
            print("Not a valid Language!!!")
            return false
        end
        data.set("language", lang, "config")
    end
    return true
end

function tablelength(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

return { initLanguageLink = initLanguageLink, setLanguage = setLanguage, tablelength = tablelength }
