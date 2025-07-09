# TFD Treasure Hunts

Treasure hunting for RedM.

Coming soon.

## Create Items

- treasuremap_small_east
- treasuremap_small_west
- treasuremap_large_east
- treasuremap_large_west
- treasurehunt_chest_small
- treasurehunt_chest_large

### VORP

Run the following query in your SQL database. Modify the fields as desired.

```mysql
INSERT INTO items (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `groupId`, `metadata`, `desc`, `degradation`, `weight`) VALUES
("treasuremap_small_east", "Treasure Map", 50, 1, "item_standard", 1, 9, "{}", "A small treasure map", 0, 0.1),
("treasuremap_small_west", "Treasure Map", 50, 1, "item_standard", 1, 9, "{}", "A small treasure map", 0, 0.1),
("treasuremap_large_east", "Large Treasure Map", 50, 1, "item_standard", 1, 9, "{}", "A large treasure map", 0, 0.1),
("treasuremap_large_west", "Large Treasure Map", 50, 1, "item_standard", 1, 9, "{}", "A large treasure map", 0, 0.1),
("treasurehunt_chest_small", "Small Treasure Chest", 50, 1, "item_standard", 1, 9, "{}", "A small treasure chest", 0, 0.1),
("treasurehunt_chest_large", "Large Tresure Chest", 50, 1, "item_standard", 1, 9, "{}", "A large treasure chest", 0, 0.1);
```

### RSG

Soon.
