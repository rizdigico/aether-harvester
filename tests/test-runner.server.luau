--!strict
-- TestEZ bootstrap: runs all tests in ReplicatedStorage.Tests and prints a
-- machine-readable JSON summary line that the agent/CI can parse.
local TestEZ = require(game.ReplicatedStorage.TestEZ)
local TestBootstrap = TestEZ.TestBootstrap

local results = TestBootstrap:run({
    testRoots = {
        game.ReplicatedStorage.AetherShared,
    },
    runnerName = "AetherHarvesterUnitTests",
    isCli = false,
})

local passed = 0
local failed = 0
for _, suiteResult in ipairs(results) do
    for _, testResult in ipairs(suiteResult.testResults) do
        if testResult.passed then
            passed += 1
        else
            failed += 1
            warn(
                string.format(
                    "[TEST-FAIL] suite=%s test=%s message=%s",
                    suiteResult.name,
                    testResult.name,
                    testResult.message or "no message"
                )
            )
        end
    end
end

-- Machine-readable summary line for the agent/CI pipeline
print(
    string.format(
        '{"status": %s, "passed": %d, "failed": %d}',
        failed == 0 and '"passed"' or '"failed"',
        passed,
        failed
    )
)

if failed > 0 then
    error(string.format("Test run failed: %d passed, %d failed", passed, failed))
end
