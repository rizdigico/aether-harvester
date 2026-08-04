local ServerMain = require(game.ReplicatedStorage.AetherShared.Modules.ServerMain)

-- Wait for game to fully load
task.wait(2)

-- Initialize server
ServerMain.Initialize()

print("[BOOT] Aether Harvester Simulator server started successfully")
