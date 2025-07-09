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
            Coords = vector4(2861.760, -1194.387, 48.989, 144.505),
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
            Coords = vector4(-756.495, -1355.898, 43.575, 268.836),
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
        { item = "ironhammer", amount = 1, probability = 0.1 },
        { item = "goldbar", amount = 1, probability = 0.05 },
        { item = "gold_nugget", minAmount = 1, maxAmount = 5, probability = 0.5 },
        { item = "ironbar", amount = 2, probability = 0.2 },
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
    Items = {"pickaxe"}, -- items the player must have to be able to dig
    Locations = {
        ["east"] = {
            { Coords = vector3(-392.232, 1754.217, 216.329), },
            { Coords = vector3(737.601, 1822.649, 237.015), },
            { Coords = vector3(1243.012, 1172.151, 149.665), },
            { Coords = vector3(1498.220, 1057.747, 182.039), },
            { Coords = vector3(1681.867, 1443.404, 146.871), },
            { Coords = vector3(2502.262, 2290.402, 176.575), },
            { Coords = vector3(1451.206, 824.011, 100.665), },
            { Coords = vector3(640.963, 975.490, 182.463), },
            { Coords = vector3(2490.153, 299.900, 73.359), },
            { Coords = vector3(2876.614, -242.328, 42.645), },
            { Coords = vector3(2441.146, -450.929, 42.052), },
            { Coords = vector3(2272.049, -780.092, 42.329), },
            { Coords = vector3(1726.065, -1006.503, 41.522), },
            { Coords = vector3(2017.456, -1986.358, 42.052), },
            { Coords = vector3(1969.901, -1889.202, 41.976), },
            { Coords = vector3(1201.081, -2229.645, 59.748), },
            { Coords = vector3(2331.965, -1318.528, 43.659), },
        },
        ["west"] = {
            { Coords = vector3(-5307.460, -4052.913, -12.994), },
            { Coords = vector3(-5848.325, -3754.586, -25.318), },
            { Coords = vector3(-6358.623, -3614.786, -24.474), },
            { Coords = vector3(-6135.221, -3071.264, -0.287), },
            { Coords = vector3(-5522.071, -2399.804, -9.081), },
            { Coords = vector3(-5404.690, -2985.802, 11.058), },
            { Coords = vector3(-4679.466, -3751.666, 13.711), },
            { Coords = vector3(-4056.713, -2054.008, 1.353), },
            { Coords = vector3(-2729.110, -2364.242, 45.113), },
            { Coords = vector3(-2122.177, -2278.632, 98.875), },
            { Coords = vector3(-2195.217, -2055.871, 59.067), },
            { Coords = vector3(-2677.679, -1439.078, 147.323), },
            { Coords = vector3(-2764.876, -323.379, 150.110), },
            { Coords = vector3(-2233.854, 601.019, 117.804), },
            { Coords = vector3(-1761.515, -2940.424, -10.669), },
            { Coords = vector3(-725.736, -1007.478, 42.548), },
            { Coords = vector3(-1093.066, 690.439, 104.655), }
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
