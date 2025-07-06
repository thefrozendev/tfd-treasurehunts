Config = {
    Debug = true,

    Blips = {
        -- Set this to true if you want blip of the map vendor to be shown on the map,
        -- otherwise this could be a fun little secret for players to discover.
        Show = false,
        Name = "Treasure Map Seller",
        -- https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/textures/blips_mp
        -- or https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/textures/blips
        Sprite = `blip_mp_game_treasure_hunt`,
        Scale = 0.2,
        -- https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/blip_modifiers
        Color = `BLIP_MODIFIED_MP_COLOR_32`
    },

    DistanceToCreateVendor = 50.0,

    -- Split vendors... the thought here is a vendor out east could hold treasure maps out west,
    -- and vice versa.
    MapVendors = {
        {
            Name = "Treasure Map Vendor",
            Coords = vector4(0, 0, 0, 0),
            PedModel = `s_m_m_blwdealer_01`,
            Stock = {
                {
                    Item = "treasuremap_small_east",
                    Price = 5,
                    Label = "Small Treasure Map"
                },
                {
                    Item = "treasuremap_large_east",
                    Price = 15,
                    Label = "Large Treasure Map"
                },
            }
        },
        {
            Name = "Treasure Map Vendor",
            Coords = vector4(0, 0, 0, 0),
            PedModel = `s_m_m_blwdealer_01`,
            Stock = {
                {
                    Item = "treasuremap_small_west",
                    Price = 5,
                    Label = "Small Treasure Map"
                },
                {
                    Item = "treasuremap_large_west",
                    Price = 15,
                    Label = "Large Treasure Map"
                },
            }
        }
    },
}

-- These tables are separated so that they can reference other Config Items more easily

-- The main loot tables. There are 3 properties within the nested tables here:
-- 1. `item` is the item to award
-- 2. `amount` is the amount of the item to award
-- 3. `probability` represents the relative chances. For example, an item with a probability of 0.5 is
--    fives times more likely to be picked than one with a probability of 0.1. These values do not need
--    to sum to 1, as they are normalized.
Config.LootTables = {
    ["small"] = {
        { item = "gold_nugget", amount = 1, probability = 0.1 },
        { item = "sand", amount = 1, probability = 0.2 },
    },
    ["large"] = {
        { item = "jewelry_box", amount = 1, probability = 0.5 },
    }
}

Config.Dig = {
    Chests = {
        ["treasurehunt_chest_small"] = {
            Amount = 3,
            LootTable = Config.LootTables["small"],
        },
        ["treasurehunt_chest_large"] = {
            Amount = 5,
            LootTable = Config.LootTables["large"],
        }
    },
    Items = {"shovel"}, -- items the player must have to be able to dig
    Locations = {
        ["east"] = {
            { Coords = vector3(0, 0, 0) },
        },
        ["west"] = {
            { Coords = vector3(0, 0, 0) },
        }
    }
}

Config.Maps = {
    -- Properties of this table should match the item name used in the framework
    ["treasuremap_small_east"] = {
        Chest = "treasurehunt_chest_small",
        DigLocations = Config.Dig.Locations["east"],
    },
    ["treasuremap_large_east"] = {
        Chest = "treasurehunt_chest_large",
        DigLocations = Config.Dig.Locations["east"],
    },
    ["treasuremap_small_west"] = {
        Chest = "treasurehunt_chest_small",
        DigLocations = Config.Dig.Locations["west"],
    },
    ["treasuremap_large_west"] = {
        Chest = "treasurehunt_chest_large",
        DigLocations = Config.Dig.Locations["west"],
    },
}
