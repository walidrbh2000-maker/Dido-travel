#!/bin/bash

set -e

ENV_FILE="/var/www/html/.env"
ARTISAN="/var/www/html/artisan"

# ── 0. Bootstrap Laravel if missing ──────────────────────────────────────────
if [ ! -f "/var/www/html/composer.json" ]; then
    echo "▶ No Laravel project found — creating fresh install..."

    composer create-project laravel/laravel /tmp/laravel-base "^11.0" \
        --prefer-dist --no-interaction --quiet

    cp -rn /tmp/laravel-base/. /var/www/html/
    rm -rf /tmp/laravel-base

    echo "▶ Installing required packages..."
    cd /var/www/html
    composer require \
        tymon/jwt-auth \
        barryvdh/laravel-dompdf \
        --no-interaction --quiet

    php artisan vendor:publish \
        --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider" \
        --quiet || true

    echo "✔ Laravel project ready."
fi

# ── 1. Wait for MySQL ─────────────────────────────────────────────────────────
echo "▶ Waiting for database connection..."
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
DB_DATABASE="${DB_DATABASE:-travel}"
DB_USERNAME="${DB_USERNAME:-travel_user}"
DB_PASSWORD="${DB_PASSWORD:-secret}"

for i in $(seq 1 30); do
    if php -r "new PDO('mysql:host=${DB_HOST};port=${DB_PORT};dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}');" 2>/dev/null; then
        echo "✔ Database is ready."
        break
    fi
    echo "  DB not ready — retrying ($i/30)..."
    sleep 3
    if [ "$i" = "30" ]; then
        echo "✗ Could not connect to database after 30 attempts. Aborting."
        exit 1
    fi
done

# ── 2. Install Composer dependencies ─────────────────────────────────────────
echo "▶ Installing Composer dependencies..."
composer install --no-interaction --optimize-autoloader

# ── 3. Generate APP_KEY ───────────────────────────────────────────────────────
if [ ! -f "$ENV_FILE" ]; then
    echo "✗ .env file not found at $ENV_FILE"
    exit 1
fi

APP_KEY=$(grep -E "^APP_KEY=" "$ENV_FILE" | cut -d= -f2 | tr -d '[:space:]')
if [ -z "$APP_KEY" ]; then
    echo "▶ APP_KEY missing — generating..."
    php "$ARTISAN" key:generate --force
    echo "✔ APP_KEY generated."
else
    echo "✔ APP_KEY already set."
fi

# ── 4. Generate JWT_SECRET ────────────────────────────────────────────────────
JWT_SECRET=$(grep -E "^JWT_SECRET=" "$ENV_FILE" | cut -d= -f2 | tr -d '[:space:]')
if [ -z "$JWT_SECRET" ]; then
    echo "▶ JWT_SECRET missing — generating..."
    php "$ARTISAN" jwt:secret --force
    echo "✔ JWT_SECRET generated."
else
    echo "✔ JWT_SECRET already set."
fi

# ── 5. Fix storage permissions (www-data = PHP-FPM user) ─────────────────────
echo "▶ Fixing storage permissions..."
mkdir -p /var/www/html/storage/logs \
         /var/www/html/storage/framework/cache \
         /var/www/html/storage/framework/sessions \
         /var/www/html/storage/framework/views \
         /var/www/html/bootstrap/cache

chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

chmod -R 775 \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

echo "✔ Permissions fixed."

# ── 6. Run migrations ─────────────────────────────────────────────────────────
echo "▶ Running migrations..."
php "$ARTISAN" migrate --force
echo "✔ Migrations done."

# ── 7. Run seeders (non-fatal) ────────────────────────────────────────────────
echo "▶ Seeding database..."
php "$ARTISAN" db:seed --force || echo "⚠ Seeding skipped (already seeded or error — continuing)."

# ── 8. Build caches (as www-data so PHP-FPM can overwrite them) ───────────────
echo "▶ Caching config and routes..."
su -s /bin/sh www-data -c "php $ARTISAN config:cache"
su -s /bin/sh www-data -c "php $ARTISAN route:cache"
echo "✔ Cache built."

# ── 9. Start PHP-FPM ─────────────────────────────────────────────────────────
echo "▶ Starting PHP-FPM..."
exec "$@"
