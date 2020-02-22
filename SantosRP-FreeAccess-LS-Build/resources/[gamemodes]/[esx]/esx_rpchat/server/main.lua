ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
  CancelEvent()
  TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEME ', '^2'..command_args[1]..'^0 n\'est pas une commande valide !'}})
end)

AddEventHandler('chatMessage', function(playerId, playerName, message)
  if string.sub(message, 1, string.len("/")) ~= "/" then
    CancelEvent()
    message = Emojit(message)

    if message ~= nil or message ~= "" then
      TriggerEvent('SendToDiscord', playerId, "CHAT", "**"..playerName.."** à dit **"..message.."**", 3315455, "chat")
      argEmoji = Discordt(message)
      if argEmoji then argEmoji = argEmoji message = "" else argEmoji = " " end
      playerName = GetRealPlayerName(playerId)
      print(xPlayerName)
      TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0}<br> {1} '..argEmoji..' </div>',
        args = { playerName, message }
      })
    end
  end
end)

RegisterCommand('ano', function(playerId, args, rawCommand)
  if playerId == 0 then
    print('esx_rpchat: you can\'t use this command from console!')
  else
    local msg = table.concat(args, ' ')

    msg = Emojit(msg)
    if msg ~= nil or msg ~= "" then
    	TriggerEvent('SendToDiscord', playerId, "CHAT ANONYME", "**"..GetPlayerName(playerId).."** à dit **"..msg.."**", 3315455, "chat")
      argEmoji = Discordt(msg)
      if argEmoji then argEmoji = argEmoji msg = "" else argEmoji = " " end
	    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @Anonyme<br> {0} '..argEmoji..' </div>',
        args = { msg }
	    })
    end
  end
end, false)

RegisterCommand('hrp', function(playerId, args, rawCommand)
  if playerId == 0 then
    print('esx_rpchat: you can\'t use this command from console!')
  else
    local msg = table.concat(args, ' ')

    msg = Emojit(msg)
    if msg ~= nil or msg ~= "" then
      TriggerEvent('SendToDiscord', playerId, "CHAT HRP", "**"..GetPlayerName(playerId).."** à dit **"..msg.."**", 3315455, "chat")
      argEmoji = Discordt(msg)
      if argEmoji then argEmoji = argEmoji msg = "" else argEmoji = " " end
      TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}<br> {1} '..argEmoji..' </div>',
        args = { GetPlayerName(playerId), msg }
      })
    end
  end
end, false)

function GetRealPlayerName(playerId)
  local xPlayer = ESX.GetPlayerFromId(playerId)

  if xPlayer then
    return xPlayer.get('firstName')
  else
    return GetPlayerName(playerId)
  end
end

function Emojit(text)
    for i = 1, #emoji do
      for k = 1, #emoji[i][1] do
        text = string.gsub(text, emoji[i][1][k], emoji[i][2])
      end
    end
    return text
end

function Discordt(text)
    for i = 1, #discord do
      for k = 1, #discord[i][1] do
        text = string.gsub(text, discord[i][1][k], discord[i][2])
      end
    end
    return text
end