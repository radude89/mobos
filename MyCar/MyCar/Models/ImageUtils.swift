//
//  ImageUtils.swift
//  MyCar
//
//  Created by Radu Dan on 12/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import UIKit
import ImageIO
import VideoToolbox

extension UIImage {
    convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let img = cgImage else {
            return nil
        }

        self.init(cgImage: img)
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError("Unhandled case")
        }
    }
}
