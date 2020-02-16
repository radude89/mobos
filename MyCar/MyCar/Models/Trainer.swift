//
//  Trainer.swift
//  MyCar
//
//  Created by Radu Dan on 13/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import UIKit
import CoreML

struct Trainer {
    
    private let modelHandler: MLModelHandler
    private let car: Car
    
    init(modelHandler: MLModelHandler = ModelUpdater.liveModel, car: Car) {
        self.modelHandler = modelHandler
        self.car = car
    }
    
    func updateModel(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            ModelUpdater.updateWith(trainingData: self.featureBatchProvider) {
                completion?()
            }
        }
    }
    
    private var featureBatchProvider: MLBatchProvider {
        var featureProviders: [MLFeatureProvider] = []
        let imageSet = ImageSetFactory.makeImageSet(for: car)
        
        imageSet.images.forEach { image in
            let inputValue = modelHandler.featureValue(usingImage: image)
            let outputValue = MLFeatureValue(string: car.rawValue)
            
            let dataPointFeatures: [String: MLFeatureValue] = [modelHandler.inputName: inputValue,
                                                               modelHandler.outputName: outputValue]
            
            if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
                featureProviders.append(provider)
            }
        }
        
        return MLArrayBatchProvider(array: featureProviders)
    }
}
