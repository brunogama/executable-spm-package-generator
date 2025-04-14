# Swift Executable Project Creator

A simple command-line tool that creates a new Swift executable project with minimal configuration and modern platform support.

## Motivation

This script was created to address a common frustration when testing Swift concurrency features: Xcode Playgrounds often fail or behave unpredictably when working with async/await, actors, and other concurrency primitives. By quickly creating standalone executable projects, you can:

- Test concurrency code in a more stable environment
- Avoid the frequent crashes and freezes that occur in Playgrounds
- Get more reliable debugging and execution of async code
- Rapidly prototype Swift concurrency patterns without the overhead of a full app
- See console output cleanly without Playground's rendering issues

Instead of wrestling with Playground limitations or setting up a full project manually each time, this tool creates a ready-to-run executable project with a single command.

## Overview

This script streamlines the process of creating a new Swift executable project by automating the standard setup steps. It handles directory creation, Swift package initialization with the latest platform support, and removes test directories to focus solely on executable functionality.

## Features

- Creates a Swift executable project with a single command
- Configures the project with support for the latest Apple platforms:
  - macOS 14.0
  - iOS 17.0
  - tvOS 17.0
  - watchOS 10.0
  - visionOS 2.0
- Automatically removes test directories to keep the project focused
- Automatically opens Package.swift for editing
- Automatically builds and runs the new project
- Handles errors gracefully with descriptive messages
- Single-purpose tool with streamlined workflow

## Requirements

- macOS with Swift installed
- Swift 5.0 or later
- Xcode command line tools

## Installation

1. Download the `ProjectCreator.swift` script
2. Make it executable:
   ```bash
   chmod +x ProjectCreator.swift
   ```
3. Optionally, move it to a directory in your PATH for easy access

## Usage

Run the script from the terminal:

```bash
./ProjectCreator.swift
```

Or if you've added it to your PATH:

```bash
ProjectCreator.swift
```

The script will:
1. Prompt you for a package name
2. Create a new directory with that name
3. Initialize a Swift executable package
4. Add platform requirements for the latest Apple platforms
5. Remove test directories
6. Change to the new project directory
7. Open Package.swift in your default editor
8. Build and run the project

## Example

```
$ ./ProjectCreator.swift
🚀 Starting Swift Executable Project Creator

📦 Enter package name: MyAwesomeApp

🛠  Creating executable project structure...
Creating executable package: MyAwesomeApp
Creating Package.swift
Creating .gitignore
Creating Sources/
Creating Sources/main.swift
🧹 Removing Tests directory...
📄 Updated Package.swift with latest platforms (macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 2)

✅ Successfully created executable project at: /Users/yourname/Developer/MyAwesomeApp with latest platform support

Executing next steps automatically...
📂 Changed to directory: MyAwesomeApp
📄 Opened Package.swift
🚀 Building and running project...
Building for debugging...
[8/8] Linking MyAwesomeApp
Build of product 'MyAwesomeApp' complete! (0.50s)
Hello, world!
```

## Customization

You can easily modify the script to add more features or change its behavior:

- Edit the `updatePackageManifest()` method to change supported platforms or versions
- Modify the `runSwiftPackageInit()` method to customize package initialization
- Adjust the `executeNextSteps()` method to change automatic actions after project creation
- Add new methods for additional project setup steps

## How It Works

The script performs the following key operations:

1. **Project Initialization**: Creates a directory and initializes a Swift executable package
2. **Platform Configuration**: Updates the Package.swift manifest to include the latest platform requirements
3. **Cleanup**: Removes test directories to focus on executable functionality
4. **Automation**: Automatically opens the project, builds, and runs it

## Troubleshooting

- If you see errors about file permissions, make sure the script is executable with: `chmod +x ProjectCreator.swift`
- If Package.swift fails to open, check that your default app for .swift files is set correctly
- If the build fails, check that you have the latest Xcode and Swift toolchain installed

## License

This project is available under the MIT License. Feel free to use and modify as needed.