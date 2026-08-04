# DATA SCHEMA

## PlayerDataService Schema

### Player Data Structure
```
{
    PlayerId: string,
    Level: number,
    XP: number,
    Currency: {
        AetherShards: number,
        AetherGems: number,
        EventTokens: number,
        FamePoints: number
    },
    Inventory: {
        [itemId: string]: number
    },
    PetInventory: {
        [petId: string]: {
            InstanceId: number,
            PetId: string,
            Level: number,
            XP: number,
            Hunger: number,
            Happiness: number,
            Energy: number,
            IsEquipped: boolean
        }
    },
    EquippedPets: {
        [petId: string]: boolean
    },
    Skills: {
        [skillId: string]: number
    },
    Quests: {
        [questId: string]: {
            Title: string,
            Description: string,
            Progress: number,
            Rewards: {
                Currency: number,
                Items: {
                    [itemId: string]: number
                }
            }
        }
    },
    Achievements: {
        [achievementId: string]: boolean
    },
    Stats: {
        HarvestCount: number,
        CombatKills: number,
        TradesCompleted: number,
        PlaytimeMinutes: number,
        ZonesDiscovered: number
    },
    Settings: {
        MusicVolume: number,
        SFXVolume: number,
        GraphicsQuality: number
    },
    PrestigeLevel: number,
    GuildId: string | nil
}
```

### Migration Gaps
- **No Versioning**: Uses `PlayerData_v1` without versioning or migration support.
- **No Schema Evolution**: Direct overwrites on save can corrupt data during schema changes.
- **No Data Validation**: No checks for invalid or corrupted data during load.
- **No Concurrency Control**: Race conditions possible during player disconnection.

### Recommended Fixes
1. **Add Versioning**: Implement versioning with migration support for future schema changes.
2. **Add Data Validation**: Validate data structure during load and save.
3. **Implement Transactional Saves**: Use transactional saves to prevent race conditions.
4. **Add Error Handling**: Implement retry logic and fallback for DataStore operations.

---