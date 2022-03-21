function Webhook(webHookUrl, webHookImage)
    local self = {}

    self.webHookUrl = webHookUrl
    self.webHookImage = webHookImage

    if not self.webHookUrl then 
        error('discordWebHookUrl was expected but got nil')
        return
    end

    self.send = function(playerId, rawCommand)
        local user = self.getPlayerServerInfo()
        local messageObj = self.messageBuilder(user, rawCommand)
        PerformHttpRequest(self.webHookUrl, function(err, text, header) print(err, text) end, 'POST', json.encode(messageObj), {
            ['Content-Type'] = 'application/json'
        })
    end

    self.messageBuilder = function(user, rawCommand)

        return {
            embeds = {
                {
                    title = user.name ..' use a command',
                    description = '```'.. rawCommand ..'```\n',
                    color = 3666853,

                    fields = {
                        {
                            name = 'Steam Hex:',
                            value = user.steamhex,
                            inline = true
                        },
                        {
                            name = 'Rockstar License:',
                            value = user.license,
                            inline = true
                        }
                    },

                    thumbnail = {
                        url = self.webHookImage
                    },

                    author = {
                        name = user.name,
                    },
                },
            }
        }
    end

    self.getPlayerServerInfo = function ()
        local user = {
            steamhex = "None",
            license = "None"
        }
        user.name = GetPlayerName(source)

        for k,v in pairs(GetPlayerIdentifiers(source)) do              
            if string.sub(v, 1, string.len("steam:")) == "steam:" then -- Steam Hex
                user.steamhex = string.sub(v, 7)
            elseif string.sub(v, 1, string.len("license:")) == "license:" then -- Rockstar License
                user.license = string.sub(v, 9)
            end
        end

        return user
    end

    self.createDescription = function(user)
        return string.format("Steam: %s |\n License: %s |", user.steamhex, user.license)
    end

    return self
end
