# Aether Harvester dev scripts
# Uses project-local tools via Rokit shims.

ROJO ?= C:\Users\aariz\.rokit\bin\rojo.exe
STYLUA ?= C:\Users\aariz\.rokit\bin\stylua.exe
SELENE ?= C:\Users\aariz\.rokit\bin\selene.exe
LUNE ?= C:\Users\aariz\.rokit\bin\lune.exe
LUAU_LSP ?= C:\Users\aariz\.rokit\bin\luau-lsp.exe

.PHONY: help format check lint test build watch serve

help:
	@echo "Aether Harvester tooling"
	@echo "  make format     - format all src with StyLua"
	@echo "  make check      - check formatting (no write)"
	@echo "  make lint       - run Selene linter"
	@echo "  make typecheck  - run Luau LSP type check"
	@echo "  make build      - build the Rojo project (place file)"
	@echo "  make watch      - Rojo serve (live-sync to Studio)"
	@echo "  make test       - run unit tests via Lune (Luau-only tests)"

format:
	$(STYLUA) src tests

check:
	$(STYLUA) --check src tests

lint:
	$(SELENE) src tests

typecheck:
	$(ROJO) sourcemap default.project.json --output sourcemap.json
	$(LUAU_LSP) analyze --defs=scripts/types/globalTypes.d.luau --defs=scripts/types/testez.d.luau --sourcemap=sourcemap.json src

build:
	$(ROJO) build --output aether-harvester.rbxlx

watch:
	$(ROJO) serve

test:
	@echo "Run in Studio via test.project.json (TestEZ bootstrap writes machine-readable results)"
	@echo "Or: rojo build test.project.json --output test-place.rbxlx && open in Studio"
