#!/bin/sh

echo "Running..."

# Set the variables
WORKSPACE_DIR="."
REPO_URL="https://${GITHUB_TOKEN}@github.com/ValenW/blog.git"
TARGET_DIR="html"  # Directory where you want to clone the repo
BRANCH="deploy"

# Function to check if a directory is empty
is_empty_dir() {
  [ -z "$(ls -A "$1")" ]
}

# Function to check if a directory is a Git repository
is_git_repo() {
  [ -d "$1/.git" ]
}

# Navigate to the workspace directory
cd "$WORKSPACE_DIR" || { echo "Workspace directory not found! Exiting."; exit 1; }

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Repository not found. Cloning the $BRANCH branch into $TARGET_DIR..."
    git clone --branch "$BRANCH" --depth 1 "$REPO_URL" "$TARGET_DIR"
else
    if is_empty_dir "$TARGET_DIR" || ! is_git_repo "$TARGET_DIR"; then
        echo "Directory is empty or not a valid Git repository. Cleaning up and cloning the repository..."
        rm -rf "$TARGET_DIR"/*
        git clone --branch "$BRANCH" --depth 1 "$REPO_URL" "$TARGET_DIR"
    else
        echo "Valid Git repository found. Pulling the latest changes from the $BRANCH branch..."
        cd "$TARGET_DIR" || { echo "Failed to navigate to the target directory! Exiting."; exit 1; }
        git fetch --depth 1 origin "$BRANCH"
        git checkout "$BRANCH"
        git reset --hard "origin/$BRANCH"
    fi
fi
