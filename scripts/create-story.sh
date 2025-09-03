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

# 1. Check if a project name is provided
if [ -z "$1" ]; then
  echo "Error: Project name is required." >&2
  echo "Usage: $0 <project-name>" >&2
  exit 1
fi

PROJECT_NAME=$1

echo "Creating new story project: $PROJECT_NAME..."

git clone "$STORY_FORGE_TEMPLATE_URL" "../$PROJECT_NAME"

echo "✅ Successfully created '$PROJECT_NAME' in the parent directory."
