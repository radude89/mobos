//
//  Car.swift
//  MyCar
//
//  Created by Radu Dan on 13/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import UIKit

// MARK: - Car
enum Car: String {
    case nissan
    case porsche
    case ford
}

// MARK: - Static images
protocol ImageSet {
    var images: [UIImage] { get }
}

extension ImageSet {
    var range: ClosedRange<Int> { 1...3 }
}

enum ImageSetFactory {
    static func makeImageSet(for car: Car) -> ImageSet {
        switch car {
        case .nissan:
            return NissanImageSet()
            
        case .porsche:
            return PorscheImageSet()
            
        case .ford:
            return FordImageSet()
        }
    }
}

struct NissanImageSet: ImageSet {
    var images: [UIImage] {
        return range.map { UIImage(named: "\(Car.nissan.rawValue)_\($0)")! }
    }
}

struct PorscheImageSet: ImageSet {
    var images: [UIImage] {
        return range.map { UIImage(named: "\(Car.porsche.rawValue)_\($0)")! }
    }
}

struct FordImageSet: ImageSet {
    var images: [UIImage] {
        return range.map { UIImage(named: "\(Car.ford.rawValue)_\($0)")! }
    }
}
