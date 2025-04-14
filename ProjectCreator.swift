#!/usr/bin/env swift

import Foundation

// MARK: - Main Execution

do {
    let creator = ProjectCreator()
    try creator.run()
} catch {
    print("❌ Error: \(error)")
    exit(1)
}

// MARK: - Project Creator Class

class ProjectCreator {
    private let fileManager = FileManager.default
    private let currentDirectory = FileManager.default.currentDirectoryPath
    private var packageName: String = ""
    private var projectPath: String = ""
    
    // Normal initializer with no throws
    init() {}
    
    // MARK: - User Interaction
    
    func run() throws {
        print("🚀 Starting Swift Executable Project Creator")
        
        try getProjectName()
        try createProjectStructure()
        
        print("\n✅ Successfully created executable project at: \(projectPath) with latest platform support")
        print("\nExecuting next steps automatically...")
        
        // Change directory, run the project, and open Package.swift
        try executeNextSteps()
    }
    
    private func getProjectName() throws {
        print("\n📦 Enter package name:", terminator: " ")
        guard let name = readLine()?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            throw ProjectError.missingPackageName
        }
        packageName = name
        projectPath = currentDirectory + "/" + packageName
    }
    
    // MARK: - Project Creation
    
    private func createProjectStructure() throws {
        print("\n🛠  Creating executable project structure...")
        
        try createDirectory()
        try runSwiftPackageInit()
        try updatePackageManifest()
    }
    
    private func createDirectory() throws {
        if fileManager.fileExists(atPath: projectPath) {
            print("⚠️  Directory already exists. Overwriting...")
            try fileManager.removeItem(atPath: projectPath)
        }
        try fileManager.createDirectory(atPath: projectPath, withIntermediateDirectories: true)
    }
    
    private func runSwiftPackageInit() throws {
        // Initialize the Swift package
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        process.arguments = [
            "package",
            "init",
            "--type", "executable",
            "--name", packageName
        ]
        process.currentDirectoryPath = projectPath
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            throw ProjectError.packageCreationFailed
        }
        
        // Remove the Tests directory
        let testsPath = projectPath + "/Tests"
        if fileManager.fileExists(atPath: testsPath) {
            print("🧹 Removing Tests directory...")
            try fileManager.removeItem(atPath: testsPath)
        }
    }
    
    private func updatePackageManifest() throws {
        let packagePath = projectPath + "/Package.swift"
        
        // Read Package.swift content
        guard let content = try? String(contentsOfFile: packagePath, encoding: .utf8) else {
            print("⚠️ Could not read Package.swift to update platforms")
            throw ProjectError.manifestUpdateFailed
        }
        
        // Find the right position to insert platforms
        // We need to add it after the package declaration line but before the products section
        let targetPattern = "let package = Package("
        guard let targetRange = content.range(of: targetPattern) else {
            print("⚠️ Could not update platforms: Package declaration not found")
            throw ProjectError.manifestUpdateFailed
        }
        
        // Split the content at the beginning of the package declaration
        let startIndex = content.startIndex
        
        let beforePackage = String(content[startIndex..<targetRange.lowerBound])
        let packageAndAfter = String(content[targetRange.lowerBound..<content.endIndex])
        
        // Find where to insert the platforms declaration
        let packageNamePattern = "name: \"\(packageName)\""
        guard let nameRange = packageAndAfter.range(of: packageNamePattern) else {
            print("⚠️ Could not update platforms: Package name not found")
            throw ProjectError.manifestUpdateFailed
        }
        
        // Insert after the package name
        let beforeName = String(packageAndAfter[packageAndAfter.startIndex..<nameRange.upperBound])
        let afterName = String(packageAndAfter[nameRange.upperBound..<packageAndAfter.endIndex])
        
        // Create the platform declaration
        let platformsDeclaration = ",\n    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .visionOS(.v2)]"
        
        // Assemble the updated content
        let updatedContent = beforePackage + beforeName + platformsDeclaration + afterName
        
        // Write back to file
        try updatedContent.write(to: URL(fileURLWithPath: packagePath), atomically: true, encoding: .utf8)
        
        print("📄 Updated Package.swift with latest platforms (macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 2)")
    }
    
    private func executeNextSteps() throws {
        // 1. Change to the project directory
        FileManager.default.changeCurrentDirectoryPath(projectPath)
        print("📂 Changed to directory: \(packageName)")
        
        // 2. Open Package.swift
        let openProcess = Process()
        openProcess.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        openProcess.arguments = ["Package.swift"]
        
        try openProcess.run()
        print("📄 Opened Package.swift")
        
        // 3. Build and run the project
        let runProcess = Process()
        runProcess.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        runProcess.arguments = ["run"]
        
        print("🚀 Building and running project...")
        try runProcess.run()
        runProcess.waitUntilExit()
        
        guard runProcess.terminationStatus == 0 else {
            throw ProjectError.nextStepsExecutionFailed
        }
    }
}

// MARK: - Error Handling

enum ProjectError: Error {
    case missingPackageName
    case packageCreationFailed
    case nextStepsExecutionFailed
    case manifestUpdateFailed
}

extension ProjectError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingPackageName:
            return "Package name cannot be empty"
        case .packageCreationFailed:
            return "Failed to create Swift package"
        case .nextStepsExecutionFailed:
            return "Failed to execute next steps automatically"
        case .manifestUpdateFailed:
            return "Failed to update Package.swift with platforms"
        }
    }
}