--!strict
-- Lune unit test runner: runs pure-Luau specs from tests/lune/*.spec.luau
-- without the Roblox engine. For engine-dependent tests use TestEZ in Studio.
-- Usage: lune run scripts/run-unit-tests.luau

local fs = require("@lune/fs")
local process = require("@lune/process")

-- fs paths resolve against CWD (project root); require resolves against script dir.
local fsTestRoot = "tests/lune"
local requireRoot = "../tests/lune"
local passed = 0
local failed = 0
local failures: { string } = {}

local function runSpec(path: string)
    local spec = require(path)
    if type(spec) ~= "table" then
        return
    end
    for _, group in ipairs(spec) do
        if type(group) == "table" and group.name and group.tests then
            print("== " .. group.name .. " ==")
            for _, t in ipairs(group.tests) do
                local ok, err = pcall(t.fn)
                if ok then
                    passed += 1
                    print("  [PASS] " .. t.name)
                else
                    failed += 1
                    table.insert(failures, string.format("%s :: %s :: %s", path, t.name, tostring(err)))
                    print("  [FAIL] " .. t.name .. " -- " .. tostring(err))
                end
            end
        end
    end
end

for _, entry in ipairs(fs.readDir(fsTestRoot)) do
    if entry:sub(-10) == ".spec.luau" then
        runSpec((requireRoot .. "/" .. entry):gsub("%.luau$", ""))
    end
end

print(string.format('{"status": %q, "passed": %d, "failed": %d}', failed == 0 and "passed" or "failed", passed, failed))
for _, f in ipairs(failures) do
    print("[FAILURE] " .. f)
end
process.exit(failed == 0 and 0 or 1)
