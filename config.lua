Config = {}
Config.CraftTime = 8000
Config.Textures = { cross = {"scoretimer_textures", "scoretimer_generic_cross"}, locked = {"menu_textures","stamp_locked_rank"}, tick = {"scoretimer_textures","scoretimer_generic_tick"}, money = {"inventory_items", "money_moneystack"}, alert = {"menu_textures", "menu_icon_alert"},}

Config.Crafting = {
    [1] = {
        ['name'] = "Valentine Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(-365.3349, 753.2812, 115.9103),
        ['job'] = "saloonvalentine",
    },
    [2] = {
        ['name'] = "Black Water Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(-819.4074, -1319.52, 43.67892),
        ['job'] = "saloonblackwater",
    },
    [3] = {
        ['name'] = "Armadillo Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(-3698.511, -2593.747, -13.31931),
        ['job'] = "saloonarmadillo",
    },
    [4] = {
        ['name'] = "Tumbleweed Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(-5519.606, -2905.956, -1.751306),
        ['job'] = "saloontumbleweed",
    },
    [5] = {
        ['name'] = "Rhodes Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(1338.885, -1373.685, 80.48071),
        ['job'] = "saloonrhodes",
    },
    [6] = {
        ['name'] = "Saint Denis Bastile Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(2640.308, -1224.214, 53.38037),
        ['job'] = "saloonbastile",
    },
    [7] = {
        ['name'] = "Saint Denis Saloon",
        ['store'] = 1500,
        ['tablecraft'] = vector3(2793.439, -1165.701, 47.93229),
        ['job'] = "saloonsaintdenis",
    },
}

Config.Foods = {
    [1] = { -- ok
        ['label'] = "Ensopato de Carne Nobre", --- LABEL DO ITEM
        ['recipe'] = 'ensopadonobre', --- NOME DO ITEM DA RECEITA(CASO PRECISE DE RECEITA PARA CRAFTAR) EXEMPLO: RECEITAGOMADEMAITAKE
        ['amount'] = false, --- QUANTIDADE FALSE PARA RECEBER 1, CASO QUEIRA RECEBER MAIS DIGITE A QUANTIDADE OU USE UM MATH.RANDOM(1,3) DE 1 A 3 ITENS
        ['desc'] = "2x Carne Veado Assado<br>4x Cenouras<br>1x Água", -- RECEITA QUE VAI APARECER NA DESCRISÃO
        ['resultitem'] = 'ensopadonobre', --- OQUE VAI RECEBER COM ESSE CRAFT NOME DO ITEM
        ['items'] = {   --- RECEITAS, SEM ESSES ITENS NÃO É POSSIVEL FAZER O CRAFT
            {['name'] = 'assadavenison', ['count'] = 2},
            {['name'] = 'carrot', ['count'] = 4},
            {['name'] = 'water', ['count'] = 1},
        }
    },
}

Config.Drinks = {
    [1] = { -- ok
        ['label'] = "Caldo de Cana", --- LABEL DO ITEM
        ['recipe'] = false, --- NOME DO ITEM DA RECEITA(CASO PRECISE DE RECEITA PARA CRAFTAR) EXEMPLO: RECEITAGOMADEMAITAKE
        ['amount'] = false, --- QUANTIDADE FALSE PARA RECEBER 1, CASO QUEIRA RECEBER MAIS DIGITE A QUANTIDADE OU USE UM MATH.RANDOM(1,3) DE 1 A 3 ITENS
        ['desc'] = "2x Cana de Açucar<br>1x Água", -- RECEITA QUE VAI APARECER NA DESCRISÃO
        ['resultitem'] = 'caldodecana', --- OQUE VAI RECEBER COM ESSE CRAFT NOME DO ITEM
        ['items'] = {   --- RECEITAS, SEM ESSES ITENS NÃO É POSSIVEL FAZER O CRAFT
            {['name'] = 'canadeacucar', ['count'] = 2},
            {['name'] = 'water', ['count'] = 1},
        }
    },
}

Config.Text = {
    norecipe = "You Don't Have the Recipe to Produce",
    nohaveitem = "You do not have what it takes to produce lacks",
    received = "You Produced"
}