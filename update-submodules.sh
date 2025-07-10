#!/bin/bash

# Smith-Pad Submodule Management Script
# This script provides a complete workflow for managing Git submodules

set -e        # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'        # No Color

# Function to print colored output
print_status() {
        echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
        echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
        echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
        echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to check if we're in a git repository
check_git_repo() {
        if ! git rev-parse --git-dir > /dev/null 2>&1; then
                print_error "Not in a Git repository. Please run this script from a Git repository."
                exit 1
        fi
}

# Function to add a new submodule
add_submodule() {
        if [ $# -ne 2 ]; then
                print_error "Usage: $0 add <repository-url> <folder-name>"
                exit 1
        fi

        local repo_url=$1
        local folder_name=$2

        print_header "Adding Submodule"
        print_status "Adding $repo_url as submodule in folder: $folder_name"

        git submodule add "$repo_url" "$folder_name"
        git add .gitmodules "$folder_name"
        git commit -m "Add $folder_name as submodule"

        print_status "Submodule added successfully!"
        print_warning "Don't forget to push: git push"
}

# Function to update all submodules
update_submodules() {
        print_header "Updating Submodules"

        print_status "Updating all submodules to latest commits..."
        git submodule update --remote

        # Check if there are any changes
        if git diff --quiet; then
                print_status "All submodules are already up to date!"
                return 0
        fi

        print_status "Staging submodule updates..."
        git add .

        print_status "Committing submodule updates..."
        git commit -m "Update submodules to latest versions"

        print_status "Submodules updated successfully!"
        print_warning "Don't forget to push: git push"
}

# Function to push submodules
push_submodules() {
        print_header "Pushing Submodules"

        print_status "Pushing main repository..."
        git push

        print_status "Pushing submodule changes..."
        git submodule foreach git push

        print_status "All submodules pushed successfully!"
}

# Function to initialize submodules (for new clones)
init_submodules() {
        print_header "Initializing Submodules"

        print_status "Initializing submodules..."
        git submodule init

        print_status "Updating submodules..."
        git submodule update

        print_status "Submodules initialized successfully!"
}

# Function to show submodule status
show_status() {
        print_header "Submodule Status"

        print_status "Current submodules:"
        git submodule status

        echo ""
        print_status "Checking for updates..."
        git submodule foreach git status --porcelain
}

# Function to update specific submodule
update_specific_submodule() {
        if [ $# -ne 1 ]; then
                print_error "Usage: $0 update-specific <folder-name>"
                exit 1
        fi

        local folder_name=$1

        print_header "Updating Specific Submodule"
        print_status "Updating submodule: $folder_name"

        git submodule update --remote "$folder_name"
        git add "$folder_name"
        git commit -m "Update $folder_name submodule"

        print_status "Submodule $folder_name updated successfully!"
        print_warning "Don't forget to push: git push"
}

# Function to remove a submodule
remove_submodule() {
        if [ $# -ne 1 ]; then
                print_error "Usage: $0 remove <folder-name>"
                exit 1
        fi

        local folder_name=$1

        print_header "Removing Submodule"
        print_warning "This will remove the submodule: $folder_name"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_status "Removing submodule: $folder_name"

                # Remove the submodule
                git submodule deinit -f "$folder_name"
                git rm -f "$folder_name"
                rm -rf ".git/modules/$folder_name"

                print_status "Submodule $folder_name removed successfully!"
                print_warning "Don't forget to commit and push: git commit -m 'Remove $folder_name submodule' && git push"
        else
                print_status "Operation cancelled."
        fi
}

# Function to show help
show_help() {
        echo "Smith-Pad Submodule Management Script"
        echo ""
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "        add <repo-url> <folder-name>     Add a new submodule"
        echo "        update                           Update all submodules to latest"
        echo "        update-specific <folder-name>    Update a specific submodule"
        echo "        push                             Push main repo and all submodules"
        echo "        init                             Initialize submodules (for new clones)"
        echo "        status                           Show submodule status"
        echo "        remove <folder-name>             Remove a submodule"
        echo "        help                             Show this help message"
        echo ""
        echo "Examples:"
        echo "        $0 add https://github.com/user/repo projects/my-project"
        echo "        $0 update"
        echo "        $0 push"
        echo "        $0 update-specific projects/my-project"
}

# Main script logic
main() {
        check_git_repo

        case "${1:-help}" in
                "add")
                        add_submodule "$2" "$3"
                        ;;
                "update")
                        update_submodules
                        ;;
                "update-specific")
                        update_specific_submodule "$2"
                        ;;
                "push")
                        push_submodules
                        ;;
                "init")
                        init_submodules
                        ;;
                "status")
                        show_status
                        ;;
                "remove")
                        remove_submodule "$2"
                        ;;
                "help"|*)
                        show_help
                        ;;
        esac
}

# Run the main function with all arguments
main "$@"