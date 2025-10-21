#!/bin/bash

# Interactive Bench Initialization Script

# -----------------------------
# Bench Initialization
# -----------------------------

# Ask for bench name
read -p "Enter bench name: " BENCH_NAME

# Ask for Frappe branch, default to version-15
read -p "Enter Frappe branch [version-15]: " FRAPPE_BRANCH
FRAPPE_BRANCH=${FRAPPE_BRANCH:-version-15}

# Optional: Ask for bench path (default current directory)
read -p "Enter path to create bench [$(pwd)]: " BENCH_PATH
BENCH_PATH=${BENCH_PATH:-$(pwd)}

# Go to bench path
cd "$BENCH_PATH" || { echo "Invalid path: $BENCH_PATH"; exit 1; }

# Initialize bench
echo "Initializing bench '$BENCH_NAME' with Frappe branch '$FRAPPE_BRANCH'..."
bench init "$BENCH_NAME" --frappe-branch "$FRAPPE_BRANCH"

if [ $? -ne 0 ]; then
    echo "❌ Bench initialization failed!"
    exit 1
fi

echo "✅ Bench '$BENCH_NAME' created successfully in $BENCH_PATH"

# Change to the newly created bench directory
cd "$BENCH_NAME" || exit 1

# -----------------------------
# Add Apps
# -----------------------------
APPS_LIST=()

while true; do
    read -p "Do you want to add an app? [y/n]: " ADD_APP
    case "$ADD_APP" in
        [Yy]* )
            read -p "Enter app name: " APP_NAME
            read -p "Enter app branch (leave empty for default): " APP_BRANCH

            if [ -z "$APP_BRANCH" ]; then
                echo "Getting app '$APP_NAME' with default branch..."
                bench get-app "$APP_NAME"
            else
                echo "Getting app '$APP_NAME' from branch '$APP_BRANCH'..."
                bench get-app "$APP_NAME" --branch "$APP_BRANCH"
            fi

            # Save app to list
            APPS_LIST+=("$APP_NAME")
            ;;
        [Nn]* )
            echo "No more apps to add."
            break
            ;;
        * )
            echo "Please answer y or n."
            ;;
    esac
done

# -----------------------------
# Create Site (no loop)
# -----------------------------
read -p "Do you want to create a new site? [y/n]: " CREATE_SITE
if [[ "$CREATE_SITE" =~ ^[Yy] ]]; then
    read -p "Enter site name (e.g., site1.local): " SITE_NAME

    echo "Creating new site '$SITE_NAME'..."
    bench new-site "$SITE_NAME"

    if [ $? -eq 0 ]; then
        echo "✅ Site '$SITE_NAME' created successfully."
        echo "Switching to site '$SITE_NAME'..."
        bench use "$SITE_NAME"

        # -----------------------------
        # Install Apps on Site
        # -----------------------------
        # Ensure erpnext installs first if in the list
        FINAL_APPS=()
        for app in "${APPS_LIST[@]}"; do
            if [[ "$app" == "erpnext" ]]; then
                FINAL_APPS=("$app" "${FINAL_APPS[@]}")
            else
                FINAL_APPS+=("$app")
            fi
        done

        for app in "${FINAL_APPS[@]}"; do
            echo "Installing app '$app' on site '$SITE_NAME'..."
            bench --site "$SITE_NAME" install-app "$app"
        done

    else
        echo "❌ Failed to create site '$SITE_NAME'."
    fi
else
    echo "Site creation skipped."
fi

# -----------------------------
# Start Bench
# -----------------------------
echo "Starting bench..."
bench start

