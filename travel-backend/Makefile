# ==============================================================================
#  TravelApp — Docker Makefile
#  Usage: make <target>
# ==============================================================================

# ── Configuration ──────────────────────────────────────────────────────────────
COMPOSE         := docker compose
APP_CONTAINER   := app
DB_CONTAINER    := db

# ── ngrok Configuration ────────────────────────────────────────────────────────
NGROK_AUTH_TOKEN  := 2dPikNNTJMtqOZI2fh8sgKjNT0p_6Q2DywWVLbboAexW8e7Ge
NGROK_DOMAIN      := tiger-sudoku-tiara.ngrok-free.dev
NGROK_LOCAL_PORT  := 8080

# Colours for pretty output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
RED    := \033[0;31m
RESET  := \033[0m

.PHONY: help start stop restart build up down logs logs-app shell \
        migrate seed fresh db-shell \
        cache-clear cache-build key jwt-secret \
        test lint ps prune \
        ngrok ngrok-install ngrok-status ngrok-stop \
        _wait-for-app

.DEFAULT_GOAL := help

# ==============================================================================
#  HELP
# ==============================================================================
help: ## Show this help message
	@echo ""
	@echo "  $(CYAN)TravelApp — Available commands$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ \
		{ printf "  $(GREEN)%-18s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

# ==============================================================================
#  INTERNAL — Wait until app container is healthy
# ==============================================================================
_wait-for-app:
	@echo "$(YELLOW)▶ Waiting for app container to be ready...$(RESET)"
	@i=0; \
	while [ $$i -lt 30 ]; do \
		i=$$((i+1)); \
		STATUS=$$($(COMPOSE) ps -q $(APP_CONTAINER) 2>/dev/null | xargs -I{} docker inspect --format='{{.State.Status}}' {} 2>/dev/null); \
		if [ "$$STATUS" = "running" ]; then \
			echo "$(GREEN)✔ App container is running$(RESET)"; \
			exit 0; \
		fi; \
		echo "  waiting... ($$i/30) status=$$STATUS"; \
		sleep 3; \
	done; \
	echo "$(RED)✗ App container failed to start. Run: make logs-app$(RESET)"; \
	exit 1

# ==============================================================================
#  CORE — Start / Stop / Restart
# ==============================================================================
start: ## Start containers (keys are auto-generated inside entrypoint.sh)
	@echo "$(YELLOW)▶ Checking containers...$(RESET)"
	@if [ -z "$$($(COMPOSE) ps -q 2>/dev/null)" ]; then \
		echo "$(YELLOW)▶ No containers found — building and starting...$(RESET)"; \
		$(COMPOSE) up --build -d; \
	else \
		echo "$(YELLOW)▶ Containers found — starting...$(RESET)"; \
		$(COMPOSE) start; \
	fi
	@$(MAKE) -s _wait-for-app
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(GREEN)  ✔ Application is up → http://localhost:8080$(RESET)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"

stop: ## Stop running containers (preserves data)
	@echo "$(YELLOW)▶ Stopping containers...$(RESET)"
	@$(COMPOSE) stop
	@echo "$(GREEN)✔ Containers stopped$(RESET)"

restart: ## Restart all containers
	@echo "$(YELLOW)▶ Restarting containers...$(RESET)"
	@$(COMPOSE) restart
	@echo "$(GREEN)✔ Containers restarted$(RESET)"

build: ## Force rebuild all images then start
	@echo "$(YELLOW)▶ Rebuilding images...$(RESET)"
	@$(COMPOSE) up --build -d
	@$(MAKE) -s _wait-for-app
	@echo "$(GREEN)✔ Build complete → http://localhost:8080$(RESET)"

up: ## Start containers in foreground (shows live logs)
	@$(COMPOSE) up

down: ## Stop and remove containers (data volumes preserved)
	@echo "$(YELLOW)▶ Bringing down containers...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)✔ Done$(RESET)"

# ==============================================================================
#  LOGS & MONITORING
# ==============================================================================
logs: ## Tail logs from all containers
	@$(COMPOSE) logs -f

logs-app: ## Tail logs from the app container only
	@$(COMPOSE) logs -f $(APP_CONTAINER)

ps: ## Show container status
	@$(COMPOSE) ps

# ==============================================================================
#  SHELL ACCESS
# ==============================================================================
shell: ## Open a bash shell inside the app container
	@$(COMPOSE) exec $(APP_CONTAINER) bash

db-shell: ## Open MySQL shell inside the db container
	@$(COMPOSE) exec $(DB_CONTAINER) mysql -u travel_user -psecret travel

# ==============================================================================
#  LARAVEL — Artisan shortcuts
# ==============================================================================
migrate: ## Run database migrations
	@echo "$(YELLOW)▶ Running migrations...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan migrate --force
	@echo "$(GREEN)✔ Migrations done$(RESET)"

seed: ## Run database seeders
	@echo "$(YELLOW)▶ Seeding database...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan db:seed --force
	@echo "$(GREEN)✔ Seeding done$(RESET)"

fresh: ## Drop all tables, re-migrate and re-seed (⚠ destroys data)
	@echo "$(YELLOW)⚠ Resetting database — all data will be lost...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan migrate:fresh --seed --force
	@echo "$(GREEN)✔ Database reset complete$(RESET)"

cache-clear: ## Clear all Laravel caches
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan cache:clear
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan config:clear
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan route:clear
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan view:clear
	@echo "$(GREEN)✔ Caches cleared$(RESET)"

cache-build: ## Rebuild Laravel config/route cache (for production)
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan config:cache
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan route:cache
	@echo "$(GREEN)✔ Cache rebuilt$(RESET)"

key: ## Generate Laravel APP_KEY manually
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan key:generate --force

jwt-secret: ## Generate JWT secret manually
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan jwt:secret --force

# ==============================================================================
#  TESTING & QUALITY
# ==============================================================================
test: ## Run PHPUnit test suite
	@echo "$(YELLOW)▶ Running tests...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan test
	@echo "$(GREEN)✔ Tests complete$(RESET)"

lint: ## Run PHP syntax check on custom source
	@echo "$(YELLOW)▶ Checking PHP syntax...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) find /var/www/html/app -name "*.php" \
		-exec php -l {} \; | grep -v "No syntax errors"
	@echo "$(GREEN)✔ Lint complete$(RESET)"

# ==============================================================================
#  CLEANUP
# ==============================================================================
prune: ## ⚠ Remove containers, images AND volumes (full reset)
	@echo "$(YELLOW)⚠ This will delete ALL containers, images and volumes...$(RESET)"
	@read -p "Are you sure? [y/N] " confirm && [ "$$confirm" = "y" ]
	@$(COMPOSE) down -v --rmi all --remove-orphans
	@echo "$(GREEN)✔ Full cleanup done$(RESET)"

# ==============================================================================
#  NGROK — Tunnel Management
# ==============================================================================
ngrok-install: ## Install ngrok if not already installed
	@if command -v ngrok >/dev/null 2>&1; then \
		echo "$(GREEN)✔ ngrok already installed: $$(ngrok --version)$(RESET)"; \
	else \
		echo "$(YELLOW)▶ ngrok not found — installing...$(RESET)"; \
		if [ "$$(uname)" = "Darwin" ]; then \
			if command -v brew >/dev/null 2>&1; then \
				brew install ngrok/ngrok/ngrok; \
			else \
				ARCH=$$(uname -m); \
				if [ "$$ARCH" = "arm64" ]; then \
					curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip -o /tmp/ngrok.zip; \
				else \
					curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip -o /tmp/ngrok.zip; \
				fi; \
				unzip -o /tmp/ngrok.zip -d /usr/local/bin; \
				rm /tmp/ngrok.zip; \
			fi; \
		elif [ "$$(uname)" = "Linux" ]; then \
			ARCH=$$(uname -m); \
			if [ "$$ARCH" = "aarch64" ] || [ "$$ARCH" = "arm64" ]; then \
				curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.zip -o /tmp/ngrok.zip; \
			else \
				curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip -o /tmp/ngrok.zip; \
			fi; \
			unzip -o /tmp/ngrok.zip -d /tmp/ngrok-bin; \
			sudo mv /tmp/ngrok-bin/ngrok /usr/local/bin/ngrok; \
			sudo chmod +x /usr/local/bin/ngrok; \
			rm -rf /tmp/ngrok.zip /tmp/ngrok-bin; \
		else \
			echo "$(RED)✗ Unsupported OS. Install ngrok manually: https://ngrok.com/download$(RESET)"; \
			exit 1; \
		fi; \
		echo "$(GREEN)✔ ngrok installed: $$(ngrok --version)$(RESET)"; \
	fi

ngrok: ngrok-install ## Start ngrok tunnel → https://$(NGROK_DOMAIN)
	@echo "$(YELLOW)▶ Configuring ngrok auth token...$(RESET)"
	@ngrok config add-authtoken $(NGROK_AUTH_TOKEN)
	@echo "$(YELLOW)▶ Checking that the app containers are running...$(RESET)"
	@if [ -z "$$($(COMPOSE) ps -q 2>/dev/null)" ]; then \
		$(MAKE) start; \
	fi
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(GREEN)  ✔ Tunnel public URL:$(RESET)"
	@echo "$(CYAN)     https://$(NGROK_DOMAIN)$(RESET)"
	@echo "$(GREEN)  ✔ API base URL for Flutter:$(RESET)"
	@echo "$(CYAN)     https://$(NGROK_DOMAIN)/api/v1$(RESET)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo ""
	@echo "$(YELLOW)  Press Ctrl+C to stop the tunnel$(RESET)"
	@echo ""
	@ngrok http --domain=$(NGROK_DOMAIN) $(NGROK_LOCAL_PORT)

ngrok-status: ## Show ngrok tunnel status (requires tunnel to be running)
	@echo "$(CYAN)▶ ngrok tunnel info:$(RESET)"
	@curl -s http://localhost:4040/api/tunnels 2>/dev/null \
		| python3 -c "import sys,json; \
			data=json.load(sys.stdin); \
			[print('  URL:', t['public_url'], '→', t['config']['addr']) \
			for t in data.get('tunnels',[])]" \
		|| echo "$(RED)  No active tunnel found. Run: make ngrok$(RESET)"

ngrok-stop: ## Kill any running ngrok process
	@echo "$(YELLOW)▶ Stopping ngrok...$(RESET)"
	@pkill -f ngrok && echo "$(GREEN)✔ ngrok stopped$(RESET)" \
		|| echo "$(YELLOW)  No ngrok process was running$(RESET)"
