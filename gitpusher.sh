#!/bin/bash

# Function to manage SSH configuration
setup_ssh_config() {
    echo "Enter a label for this GitHub account (e.g., personal, work):"
    read github_label

    ssh_key_path=~/.ssh/id_rsa_$github_label
    ssh_config_path=~/.ssh/config

    if [ ! -f $ssh_key_path ]; then
        echo "No SSH key found for $github_label. Generating a new SSH key..."
        ssh-keygen -t rsa -b 4096 -C "youremail@example.com" -f $ssh_key_path -N ""
        echo "SSH key generated successfully!"
    else
        echo "SSH key for $github_label already exists. Skipping key generation."
    fi

    # Update or add SSH config entry for this account
    if ! grep -q "Host github-$github_label" $ssh_config_path 2>/dev/null; then
        echo "Configuring SSH for $github_label..."
        echo "Host github-$github_label" >>$ssh_config_path
        echo "    HostName github.com" >>$ssh_config_path
        echo "    User git" >>$ssh_config_path
        echo "    IdentityFile $ssh_key_path" >>$ssh_config_path
        echo "    IdentitiesOnly yes" >>$ssh_config_path
        echo "SSH configuration for $github_label added successfully!"
    else
        echo "SSH configuration for $github_label already exists. Skipping."
    fi

    # Display SSH key for user to add to GitHub
    echo "Please copy the SSH key below and add it to GitHub under Settings > SSH and GPG Keys:"
    echo "==================================================================="
    cat $ssh_key_path.pub
    echo "==================================================================="
    echo "After adding the SSH key to GitHub, come back here and type 'yes'."
}

# Wait for user confirmation
wait_for_confirmation() {
    while true; do
        read -p "Have you added the SSH key to GitHub? (yes/no): " response
        if [ "$response" == "yes" ]; then
            break
        else
            echo "Please add the SSH key to GitHub before proceeding."
        fi
    done
}

# Test SSH connection
test_ssh_connection() {
    echo "Testing SSH connection to GitHub..."
    ssh -T github-$github_label
    if [ $? -eq 1 ]; then
        echo "SSH connection successful! Proceeding with Git setup..."
    else
        echo "SSH connection failed. Please check your setup and try again."
        exit 1
    fi
}

# Function to clean up old branches locally
clean_old_branch() {
    echo "Enter the name of the old branch to delete (or leave blank to skip):"
    read old_branch
    if [ -n "$old_branch" ]; then
        git branch -D $old_branch 2>/dev/null
        echo "Old branch '$old_branch' deleted locally."
    else
        echo "No old branch specified. Skipping cleanup."
    fi
}

# Function to set up and push code to a GitHub repository
setup_and_push() {
    echo "Enter the GitHub repository SSH URL (e.g., github-$github_label:username/repo.git):"
    read repo_url

    # Initialize Git and add remote if not already set
    if [ ! -d .git ]; then
        echo "Initializing Git repository..."
        git init
    else
        echo "Git repository already initialized."
    fi

    if ! git remote | grep -q origin; then
        echo "Adding remote repository..."
        git remote add origin $repo_url
    else
        echo "Remote repository already added."
    fi

    # Switch to a new branch and commit changes
    echo "Enter the new branch name to use (default: main):"
    read new_branch
    new_branch=${new_branch:-main}

    git checkout -B $new_branch
    echo "Adding all files to the repository..."
    git add .

    echo "Enter commit message (default: 'Updated project'):"
    read commit_message
    commit_message=${commit_message:-"Updated project"}

    git commit -m "$commit_message"

    # Push changes to GitHub
    echo "Pushing changes to GitHub..."
    git push -u origin $new_branch --force
    echo "Code successfully pushed to GitHub!"
}

# Main script flow
echo "GitHub Automation Tool"
setup_ssh_config
wait_for_confirmation
test_ssh_connection
clean_old_branch
setup_and_push
