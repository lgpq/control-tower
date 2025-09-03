#!/bin/bash

# -----------------------------------------------------------------------------
# create-story.sh
#
# Description:
#   Creates a new story project based on the 'story-forge-template'.
#
# Usage:
#   bash scripts/create-story.sh <project-name>
#
# Example:
#   bash scripts/create-story.sh my-epic-fantasy
# -----------------------------------------------------------------------------

set -euo pipefail

# --- Configuration ---
STORY_FORGE_TEMPLATE_URL="https://github.com/lgpq/story-forge-template.git" # ✅

# --- Main Logic ---

PROJECT_NAME=$1 # The project name is validated and passed from the main 'ct' script.

echo "Creating new story project: ${PROJECT_NAME}..."

git clone "$STORY_FORGE_TEMPLATE_URL" "../${PROJECT_NAME}"

PROJECT_PATH="../${PROJECT_NAME}" # Define project path for clarity

echo "Initializing as a new, clean repository..."
rm -rf "${PROJECT_PATH}/.git"

# Initialize a new git repository
git -C "${PROJECT_PATH}" init -b main
git -C "${PROJECT_PATH}" add .
# Create the initial commit for the new project
git -C "${PROJECT_PATH}" commit -m "feat: initial commit from story-forge-template"

echo "✅ Successfully created and initialized project: ${PROJECT_NAME}"
