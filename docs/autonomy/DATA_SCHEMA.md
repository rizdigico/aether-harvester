# DATA SCHEMA

> **Current-status note (2026-09-10):** The original schema below is a v1
> recovery snapshot. The live implementation now uses schema version 2,
> sanitizes loaded profiles, keeps Studio data in `PlayerData_Studio_v1`, and
> uses per-player save locking plus cloned save snapshots. See
> `GameServices/PlayerDataService.luau` and [`CURRENT_STATUS.md`](CURRENT_STATUS.md)
> for the current evidence.

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
        [index: number]: {
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
            Status: "Active" | "Completed" | "Abandoned",
            Progress: { [objectiveIndex: number]: number } | nil,
            AcceptedAt: number | nil,
            CompletedAt: number | nil
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
    GuildId: string | nil,
    GuildRank: string | nil,
    Cosmetics: { [index: number]: string },
    EquippedCosmetic: string | nil,
    Entitlements: { [key: string]: boolean },
    ProcessedReceipts: { [purchaseId: string]: number },
    Boosts: {
        [boostId: string]: { ExpiresAt: number, Multiplier: number }
    },
    Mailbox: {
        [index: number]: {
            Id: string,
            From: string,
            FromId: number,
            Subject: string,
            Message: string,
            SentAt: number,
            Read: boolean,
            Attachments: { [index: number]: any }
        }
    },
    BattlePassLevel: number,
    BattlePassXP: number,
    BattlePassPremium: boolean,
    SchemaVersion: number
}
```

### Historical migration gaps

The following bullets describe the pre-reforge implementation and are retained
to explain why this document is versioned as a recovery snapshot:

- No versioning or migration support.
- Direct overwrites during schema changes.
- No load-time validation.
- No concurrency control during player disconnection.

### Historical recommended fixes
1. **Add Versioning**: Implement versioning with migration support for future schema changes.
2. **Add Data Validation**: Validate data structure during load and save.
3. **Implement Transactional Saves**: Use transactional saves to prevent race conditions.
4. **Add Error Handling**: Implement retry logic and fallback for DataStore operations.

---
