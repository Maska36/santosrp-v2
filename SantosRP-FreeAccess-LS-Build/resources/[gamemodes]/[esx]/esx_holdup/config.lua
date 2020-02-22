Config = {}
Translation = {}

Config.Shopkeeper = 416176080
Config.Locale = 'fr'

Config.Shops = {
    {coords = vector3(85.092,-232.616,54.697), heading = -30.0, money = {5000, 15000}, cops = 2, name = 'Mimi\'s', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(549.405,2669.127,42.156), heading = 91.0, money = {7500, 20000}, cops = 1, name = '7/11', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false}
}

Translation = {
    ['fr'] = {
        ['shopkeeper'] = 'Commerçant',
        ['robbed'] = 'Je viens juste d\'être braqué, je n\'ai ~r~plus d\'argent à donner~s~.. LAISSE MOI !',
        ['cashrecieved'] = 'Vous avez reçu',
        ['currency'] = '$',
        ['scared'] = 'Peur:',
        ['no_cops'] = '~r~Il n\'y a pas assez de policier en service.',
        ['cop_msg'] = 'Une photo du voleur a été envoyé depuis les caméras de surveillance!',
        ['set_waypoint'] = 'Mettre un marker jusqu\'au magasin',
        ['hide_box'] = 'Fermer cette boite.',
        ['robbery'] = 'Braquage en cours',
        ['walked_too_far'] = '~r~Vous vous êtes trop éloigné!'
    }
}