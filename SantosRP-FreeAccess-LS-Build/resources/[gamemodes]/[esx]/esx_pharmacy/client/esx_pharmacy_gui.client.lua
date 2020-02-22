-- ====================================================================================================================
-- Local function
-- ====================================================================================================================
function OpenShopMenu()
  ESX.UI.Menu.CloseAll()

  local elements = {
    { 
      label = _U('firstaidkit') .. ' <span style="color:green;">$'.. Config.Price['firstaidkit'] ..'</span>',
      value = { name = 'firstaidkit',    price = Config.Price['firstaidkit'] } 
    },
    { 
      label = _U('defibrillateur') .. ' <span style="color:green;">$'.. Config.Price['defibrillateur'] ..'</span>',
      value = { name = 'defibrillateur', price = Config.Price['defibrillateur'] }
    }
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
      css = 'pharmacie',
      title    = _U('drugstore'),
      align    = 'top-left',
      elements = elements
    }, function(data, menu)
      local element = data.current.value

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
          css = 'pharmacie',
          title = _U('valid_this_purchase'),
          align = 'top-left',
          elements = {
            { label = _U('yes'), value = 'yes' },
            { label = _U('no'),  value = 'no'  }
          }
        }, function(data2, menu2)
          if data2.current.value == 'yes' then
            TriggerServerEvent('esx_pharmacy:buyItem', element.name, element.price)
          end
          
          menu2.close()
          setCurrentAction('pharmacy_shop', _U('press_menu'), {})
        end, function(data2, menu2)
          menu2.close()
        end
      )

    end, function(data, menu)
      menu.close()
    end
  )

end