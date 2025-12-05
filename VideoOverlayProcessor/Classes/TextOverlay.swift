//
//  TextOverlay.swift
//  VideoOverlayProcessor
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
public typealias PlatformFont = UIFont
#elseif canImport(AppKit)
public typealias PlatformFont = NSFont
#endif
public let defaultFont: PlatformFont = .boldSystemFont(ofSize: 38)

public class TextOverlay: BaseOverlay {
    let text: String
    let textColor: PlatformColor
    let font: PlatformFont
    let textAlignment: NSTextAlignment

    // Glow configuration
    let glowColor: PlatformColor?
    let glowRadius: CGFloat

    override var layer: CALayer {
        // Container to hold glow + main text layers
        let container = CALayer()
        container.frame = frame
        container.backgroundColor = backgroundColor.cgColor
        container.opacity = 0.0

        // Build the main text layer
        let mainTextLayer = makeTextLayer(
            string: text,
            font: font,
            alignment: layerAlignmentMode,
            frame: container.bounds,
            foregroundColor: textColor
        )

        // Optionally build the glow layer
        if let glowColor = glowColor, glowRadius > 0 {
            let glowTextLayer = makeTextLayer(
                string: text,
                font: font,
                alignment: layerAlignmentMode,
                frame: container.bounds,
                foregroundColor: glowColor
            )
            // Shadow-based glow: computed from glyph alpha mask
            glowTextLayer.shadowColor = glowColor.cgColor
            glowTextLayer.shadowOpacity = 1.0
            glowTextLayer.shadowRadius = glowRadius
            glowTextLayer.shadowOffset = .zero

            // Add glow behind main text
            container.addSublayer(glowTextLayer)
        }

        // Add main text on top
        container.addSublayer(mainTextLayer)

        return container
    }

    private var layerAlignmentMode: CATextLayerAlignmentMode {
        switch textAlignment {
        case NSTextAlignment.left:
            return CATextLayerAlignmentMode.left
        case NSTextAlignment.center:
            return CATextLayerAlignmentMode.center
        case NSTextAlignment.right:
            return CATextLayerAlignmentMode.right
        case NSTextAlignment.justified:
            return CATextLayerAlignmentMode.justified
        case NSTextAlignment.natural:
            return CATextLayerAlignmentMode.natural
        @unknown default:
            return CATextLayerAlignmentMode.center
        }
    }

    // Helper to create a configured CATextLayer
    private func makeTextLayer(
        string: String,
        font: PlatformFont,
        alignment: CATextLayerAlignmentMode,
        frame: CGRect,
        foregroundColor: PlatformColor
    ) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.backgroundColor = nil // background is handled by container
        textLayer.foregroundColor = foregroundColor.cgColor
        textLayer.string = string
        textLayer.isWrapped = true
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.alignmentMode = alignment
        // Use integral frame to reduce artifacts
        textLayer.frame = CGRect(x: floor(frame.origin.x), y: floor(frame.origin.y), width: floor(frame.size.width), height: floor(frame.size.height))
        textLayer.masksToBounds = false

        // Ensure crisp rendering
        #if canImport(UIKit)
        textLayer.contentsScale = UIScreen.main.scale
        #elseif canImport(AppKit)
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        #endif

        textLayer.displayIfNeeded()
        return textLayer
    }

    public init(
        text: String,
        frame: CGRect,
        delay: TimeInterval,
        duration: TimeInterval,
        backgroundColor: PlatformColor = PlatformColor.clear,
        textColor: PlatformColor = PlatformColor.black,
        font: PlatformFont = defaultFont,
        textAlignment: NSTextAlignment = NSTextAlignment.center,
        glowColor: PlatformColor? = nil,
        glowRadius: CGFloat = 0.0
    ) {

        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.glowColor = glowColor
        self.glowRadius = glowRadius

        super.init(frame: frame, delay: delay, duration: duration, backgroundColor: backgroundColor)
    }
}
