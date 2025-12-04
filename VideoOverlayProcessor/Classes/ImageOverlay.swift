//
//  ImageOverlay.swift
//  VideoOverlayProcessor
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

#if canImport(UIKit)
import UIKit
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias PlatformColor = NSColor
#endif

#if canImport(UIKit)
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
public typealias PlatformImage = NSImage
#endif

class ImageOverlay: BaseOverlay {
    let image: PlatformImage

    override var layer: CALayer {
        let imageLayer = CALayer()
#if canImport(UIKit)
        imageLayer.contents = image.cgImage
#elseif canImport(AppKit)
        imageLayer.contents = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
#endif
        imageLayer.backgroundColor = backgroundColor.cgColor
        imageLayer.frame = frame
        imageLayer.opacity = 0.0

        return imageLayer
    }

    init(image: PlatformImage,
         frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: PlatformColor = PlatformColor.clear) {

        self.image = image

        super.init(frame: frame, delay: delay, duration: duration, backgroundColor: backgroundColor)
    }
}
