ESX = nil
local isDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowBillsMenu()

	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
		local elements = {}

		for k,v in ipairs(bills) do
			table.insert(elements, {
				label  = ('%s - <span style="color:red;">%s</span>'):format(v.label, _U('invoices_item', ESX.Math.GroupDigits(v.amount))),
				billId = v.id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			css = 'santos',
			title    = _U('invoices'),
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_billing:payBill', function()
				ShowBillsMenu()
			end, data.current.billId)
		end, function(data, menu)
			menu.close()
		end)
	end)

end

RegisterNetEvent('santos_menuperso:openMenuFactures')
AddEventHandler('santos_menuperso:openMenuFactures', function()
  	ShowBillsMenu()
end)

AddEventHandler('esx:onPlayerDeath', function() isDead = true end)

AddEventHandler('playerSpawned', function(spawn) isDead = false end)
