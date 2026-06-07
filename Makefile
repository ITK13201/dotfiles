NIX          = nix
NIX_STORE    = nix-store
NIXOS_REBUILD = nixos-rebuild

# System detection
OS   := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(OS),Linux)
	ifeq ($(ARCH),x86_64)
		SYSTEM := x86_64-linux
	else
		$(error Unsupported architecture: $(ARCH))
	endif
else
	$(error Unsupported OS: $(OS))
endif

# Location check (deployment only)
RUNS_ENV   ?= deployment
EXPECT_LOC  = $(shell realpath $(HOME))/dotfiles
ifeq ($(RUNS_ENV),deployment)
	ifneq ($(CURDIR),$(EXPECT_LOC))
		$(error Must run from $(EXPECT_LOC), but current dir is $(CURDIR))
	endif
endif

NIX_FLAGS = --extra-experimental-features nix-command \
            --extra-experimental-features flakes

# -------------------------------------------------------
# NixOS
# -------------------------------------------------------

# Evaluation only
.PHONY: nixos-eval-%
nixos-eval-%:
	@$(NIX) eval $(NIX_FLAGS) \
		".#nixosConfigurations.${@:nixos-eval-%=%}.config.system.build.toplevel" \
		--show-trace

# Build only (no switch)
.PHONY: nixos-build-%
nixos-build-%:
	@$(NIX) build $(NIX_FLAGS) \
		".#nixosConfigurations.${@:nixos-build-%=%}.config.system.build.toplevel" \
		--no-link --show-trace

# Build and switch
.PHONY: nixos-%
nixos-%:
	@sudo $(NIXOS_REBUILD) switch --flake ".#${@:nixos-%=%}"

# -------------------------------------------------------
# Shortcuts (default host: nixos)
# -------------------------------------------------------

.PHONY: eval build switch
eval:   nixos-eval-nixos
build:  nixos-build-nixos
switch: nixos-nixos

# -------------------------------------------------------
# Maintenance
# -------------------------------------------------------

# Update flake inputs
.PHONY: update
update:
	@$(NIX) $(NIX_FLAGS) flake update

# Format nix files
.PHONY: fmt
fmt:
	@$(NIX) $(NIX_FLAGS) fmt

# Garbage collection
.PHONY: clean-store
clean-store:
	@$(NIX_STORE) --gc

.PHONY: clean-oldgen
clean-oldgen:
	@nix-collect-garbage -d

# -------------------------------------------------------
# Bootstrap
# -------------------------------------------------------

# Install Nix (Determinate installer)
.PHONY: nix-install
nix-install:
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
		| sh -s -- install

# -------------------------------------------------------
# Default
# -------------------------------------------------------

.PHONY: test
.DEFAULT_GOAL := test
test:
	@$(NIX) --version
	$(info Detected system: $(SYSTEM))
	$(info Build environment: $(RUNS_ENV))
