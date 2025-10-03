#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew is not installed. Installing it now..."
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Set Homebrew path (for macOS)
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo "Homebrew installation completed."
else
    echo "Homebrew is already installed."
fi

# Install SwiftFormat
echo "Installing SwiftFormat..."
brew install swiftformat

# Verify SwiftFormat installation
if command -v swiftformat &> /dev/null
then
    echo "SwiftFormat installation completed."
else
    echo "SwiftFormat installation failed."
    exit 1
fi

# Create a pre-push hook
cp -f scripts/pre-push .git/hooks/pre-push && chmod +x .git/hooks/pre-push
echo "Pre-push hook has been set up."