#!/bin/bash

# -----------------------------------------------------------------------------
# ct (Control Tower)
#
# The main entry point for all control-tower commands.
# This script acts as a router to other specialized scripts.
# -----------------------------------------------------------------------------

set -euo pipefail

# Find the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Check if any command is provided
if [ -z "${1:-}" ]; then
  # --- Dynamic Interactive Mode ---
  echo "What would you like to do?"

  # 1. Find all 'create-*' scripts and build menu options
  scripts_dir="${SCRIPT_DIR}/../scripts"
  options=()
  script_files=()
  for script in "$scripts_dir"/create-*.sh; do
    if [ -f "$script" ]; then
      # Extract 'story' from 'create-story.sh'
      type=$(basename "$script" .sh | sed -e 's/create-//')
      # Capitalize the first letter and create a user-friendly option
      options+=("Create a new ${type} project")
      script_files+=("$script")
    fi
  done
  options+=("Quit")

  # 2. Display the menu and handle user selection
  select opt in "${options[@]}"; do
    # Handle the "Quit" option
    if [[ "$opt" == "Quit" ]]; then
      echo "Exiting."
      break
    fi

    # Handle script execution for other options
    if [[ -n "$opt" ]]; then
      read -p "Enter the project name: " PROJECT_NAME
      if [ -n "$PROJECT_NAME" ]; then
        # Find the corresponding script file for the selected option
        selected_script="${script_files[$((REPLY-1))]}"
        bash "$selected_script" "$PROJECT_NAME"
      else
        echo "Project name cannot be empty." >&2
      fi
      break
    else
      echo "Invalid option $REPLY. Please try again."
    fi
  done
  exit 0
fi

COMMAND=$1 # e.g., "new"

case "$COMMAND" in
  new)
    SUB_COMMAND=${2:-} # Safely get the second argument (e.g., "story")

    case "$SUB_COMMAND" in
      story)
        PROJECT_NAME=${3:-} # Safely get the third argument (the project name)
        if [ -z "$PROJECT_NAME" ]; then
          echo "Error: Project name is required for 'new story'." >&2
          echo "Usage: $0 new story <project-name>" >&2
          exit 1
        fi
        # Call the script with the validated project name
        bash "${SCRIPT_DIR}/../scripts/create-story.sh" "$PROJECT_NAME"
        ;;
      *)
        echo "Error: Unknown or missing type for 'new' command. Available: 'story'" >&2
        echo "Usage: $0 new story <project-name>" >&2
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Error: Unknown command '$COMMAND'. Available: 'new'" >&2
    echo "Usage: $0 new story <project-name>" >&2
    exit 1
    ;;
esac
