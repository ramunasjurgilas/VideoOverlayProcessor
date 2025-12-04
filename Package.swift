//
//  Package.swift
//  VideoOverlayProcessor
//
//  Created by Ramunas Jurgilas on 04/12/2025.
//  Copyright © 2025 Inspace Labs. All rights reserved.
//

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VideoOverlayProcessor",
    platforms: [
        .iOS(.v11)   // or .v10 if you really need lower
    ],
    products: [
        .library(
            name: "VideoOverlayProcessor",
            targets: ["VideoOverlayProcessor"]
        )
    ],
    targets: [
        .target(
            name: "VideoOverlayProcessor",
            path: "VideoOverlayProcessor/Classes"
            // If you want, you can be explicit about frameworks:
            // linkerSettings: [
            //     .linkedFramework("UIKit"),
            //     .linkedFramework("Foundation"),
            //     .linkedFramework("AVFoundation")
            // ]
        ),
        .testTarget(
            name: "VideoOverlayProcessorTests",
            dependencies: ["VideoOverlayProcessor"],
            path: "VideoOverlayProcessorTests"
        )
    ]
)
