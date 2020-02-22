ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().org == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	TriggerServerEvent('trew_hud_ui:getServerInfo')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	TriggerServerEvent('trew_hud_ui:getServerInfo')
end)

RegisterNetEvent('esx:setOrg')
AddEventHandler('esx:setOrg', function(org)
	ESX.PlayerData.org = org
	TriggerServerEvent('trew_hud_ui:getServerInfo')
end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' and 'society_'..ESX.PlayerData.job.name == society then
		TriggerServerEvent('trew_hud_ui:getServerInfo')
	end

	if ESX.PlayerData.org and ESX.PlayerData.org.grade_name == 'boss' and 'society_'..ESX.PlayerData.org.name == society then
		TriggerServerEvent('trew_hud_ui:getServerInfo')
	end
end)

function OpenBossOrgMenu(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isOrgBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		orgwithdraw  = false,
		orgdeposit   = false,
		orgwash      = false,
		orgemployees = true,
		orggrades    = false
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.orgwithdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_org_society_money'})
	end

	if options.orgdeposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_org_money'})
	end

	if options.orgwash then
		table.insert(elements, {label = _U('wash_money'), value = 'wash_org_money'})
	end

	if options.orgemployees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_org_employees'})
	end

	if options.orggrades then
		table.insert(elements, {label = _U('salary_management'), value = 'manage_org_grades'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_org_actions_' .. society, {
		css = 'santos',
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_org_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_org_society_money_amount_' .. society, {
				css = 'santos',
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:withdrawOrgMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_org_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_org_money_amount_' .. society, {
				css = 'santos',
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:depositOrgMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'wash_org_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_org_money_amount_' .. society, {
				css = 'santos',
				title = _U('wash_money_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:washOrgMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'manage_org_employees' then
			OpenManageOrgEmployeesMenu(society)
		elseif data.current.value == 'manage_org_grades' then
			OpenManageOrgGradesMenu(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenBossMenu(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		withdraw  = true,
		deposit   = true,
		wash      = true,
		employees = true,
		grades    = true
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.wash and ESX.PlayerData.org.name == "santos" then
		table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	if options.grades then
		table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		css = 'santos',
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				css = 'santos',
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:withdrawMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				css = 'santos',
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:depositMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'wash_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society, {
				css = 'santos',
				title = _U('wash_money_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:washMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		elseif data.current.value == 'manage_grades' then
			OpenManageGradesMenu(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

-- Society Org
function OpenManageOrgEmployeesMenu(society)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_org_employees_' .. society, {
		css = 'santos',
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = _U('employee_list'), value = 'employee_list'}
			--{label = _U('recruit'),       value = 'recruit'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenOrgEmployeeList(society)
		end

		--if data.current.value == 'recruit' then
			--OpenOrgRecruitMenu(society)
		--end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenOrgEmployeeList(society)

	ESX.TriggerServerCallback('esx_society:getOrgEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].org.grade_label == '' and employees[i].org.label or employees[i].org.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenOrgPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setOrg', function()
					OpenOrgEmployeeList(society)
				end, employee.identifier, 'santos', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageOrgEmployeesMenu(society)
		end)

	end, society)

end

function OpenOrgRecruitMenu(society)

	ESX.TriggerServerCallback('esx_society:getOrgOnlinePlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			if players[i].org.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_org_' .. society, {
			css = 'santos',
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_org_confirm_' .. society, {
				css = 'santos',
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('esx_society:setOrg', function()
						OpenOrgRecruitMenu(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenOrgPromoteMenu(society, employee)

	ESX.TriggerServerCallback('esx_society:getOrg', function(org)

		local elements = {}

		for i=1, #org.grades, 1 do
			local gradeLabel = (org.grades[i].label == '' and org.label or org.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = org.grades[i].org_grade,
				selected = (employee.org.grade == org.grades[i].org_grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_org_employee_' .. society, {
			css = 'santos',
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setOrg', function()
				OpenOrgEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenOrgEmployeeList(society)
		end)

	end, society)

end


function OpenManageOrgGradesMenu(society)
	ESX.TriggerServerCallback('esx_society:getOrg', function(org)
		local elements = {}
		for i=1, #org.grades, 1 do
			local gradeLabel = (org.grades[i].label == '' and org.label or org.grades[i].label)
			table.insert(elements, {
				label = ('%s <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(org.grades[i].salary))),
				value = org.grades[i].org_grade
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_org_grades_' .. society, {
			css = 'santos',
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_org_grades_amount_' .. society, {
				css = 'santos',
				title = _U('salary_amount')
			}, function(data2, menu2)
				amountt = tonumber(data2.value)
				if amountt == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amountt > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()
					ESX.TriggerServerCallback('esx_society:setOrgSalary', function()
						OpenManageOrgGradesMenu(society)
					end, society, data.current.value, amountt)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

-- Society Job
function OpenManageEmployeesMenu(society)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		css = 'santos',
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = _U('employee_list'), value = 'employee_list'},
			{label = _U('recruit'),       value = 'recruit'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeList(society)

	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setAnJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'chomeur', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(society)
		end)

	end, society)

end

function OpenRecruitMenu(society)

	ESX.TriggerServerCallback('esx_society:getAllOnlinePlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			css = 'santos',
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				css = 'santos',
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('esx_society:setAnJob', function()
						OpenRecruitMenu(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPromoteMenu(society, employee)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.job.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			css = 'santos',
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setAnJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

function OpenManageGradesMenu(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}
		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			table.insert(elements, {
				label = ('%s <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			css = 'santos',
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				css = 'santos',
				title = _U('salary_amount')
			}, function(data2, menu2)
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('esx_society:setAnJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

AddEventHandler('society:openBMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

AddEventHandler('esx_society:openBossOrgMenu', function(society, close, options)
	OpenBossOrgMenu(society, close, options)
end)