//
//  MLModelHandler.swift
//  MyCar
//
//  Created by Radu Dan on 13/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import UIKit
import CoreML

protocol MLModelHandler: AnyObject {
    var modelDescription: MLModelDescription { get }
    var model: MLModel { get }
    var inputName: String { get }
    var outputName: String { get }
    
    func featureValue(usingImage image: UIImage) -> MLFeatureValue
}

extension MLModelHandler {
    var modelDescription: MLModelDescription { model.modelDescription }
    var inputName: String { "image" }
    var outputName: String { "label" }
    
    func featureValue(usingImage image: UIImage) -> MLFeatureValue {
        let imageInputDescription = modelDescription.inputDescriptionsByName[inputName]!
        let constraint = imageInputDescription.imageConstraint!
        let imageFeatureValue = try? MLFeatureValue(cgImage: image.cgImage!, constraint: constraint)
        
        return imageFeatureValue!
    }
}

extension MyCarsUpdatableModel: MLModelHandler {}

extension ToyCarsImageClassifier_v2: MLModelHandler {}
