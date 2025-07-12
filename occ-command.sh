#!/bin/bash

# Configurable variables
PHP_BINARY="/usr/local/bin/php"           # Path to PHP binary
NEXTCLOUD_DIR="/var/www/html"  # Path to Nextcloud installation
OCC_USER="www-data"                 # Web server user (e.g., www-data for Apache)
HELP_FILE="$(dirname "$0")/occ_commands.txt"  # Path to help file

# Function to display help file
display_help() {
    if [[ -f "$HELP_FILE" ]]; then
        cat "$HELP_FILE"
    else
        echo "Error: Help file not found at $HELP_FILE"
        echo "Creating a default help file..."
        cat << EOF > "$HELP_FILE"
Nextcloud OCC Command Helper

Usage: $0 [occ_command] [options]

Examples:
  $0 app:list                  # List all installed apps
  $0 maintenance:mode --on     # Enable maintenance mode
  $0 maintenance:mode --off    # Disable maintenance mode
  $0 user:add --password-from-env user123  # Add a user (set OCC_COMMAND_PASSWORD env variable)
  $0 files:scan --all          # Rescan all files
  $0 --help                    # Show this help

Environment Variables:
  PHP_BINARY: Path to PHP binary (default: $PHP_BINARY)
  NEXTCLOUD_DIR: Path to Nextcloud directory (default: $NEXTCLOUD_DIR)
  OCC_USER: Web server user (default: $OCC_USER)

Common OCC Commands:
  - app:enable <app>          Enable an app
  - app:disable <app>         Disable an app
  - db:convert-filecache-bigint  Convert filecache to bigint
  - config:system:get <key>   Get system config value
  - config:system:set <key> --value=<value>  Set system config value

See Nextcloud documentation for more commands: https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html
EOF
        cat "$HELP_FILE"
    fi
}

# Check if help is requested or no arguments provided
if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
    display_help
    exit 0
fi

# Override variables with environment variables if set
PHP_BINARY="${PHP_BINARY:-/usr/bin/php}"
NEXTCLOUD_DIR="${NEXTCLOUD_DIR:-/var/www/nextcloud}"
OCC_USER="${OCC_USER:-www-data}"

# Validate PHP binary
if [[ ! -x "$PHP_BINARY" ]]; then
    echo "Error: PHP binary not found or not executable at $PHP_BINARY"
    exit 1
fi

# Validate Nextcloud directory
if [[ ! -d "$NEXTCLOUD_DIR" || ! -f "$NEXTCLOUD_DIR/occ" ]]; then
    echo "Error: Nextcloud directory or occ command not found at $NEXTCLOUD_DIR"
    exit 1
fi

# Run occ command as OCC_USER
echo "Executing: occ $@"
if ! sudo -u "$OCC_USER" "$PHP_BINARY" "$NEXTCLOUD_DIR/occ" "$@"; then
    echo "Error: Failed to execute occ command"
    exit 1
fi
