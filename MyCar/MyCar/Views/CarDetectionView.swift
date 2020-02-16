//
//  CarDetectionView.swift
//  MyCar
//
//  Created by Radu Dan on 12/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import SwiftUI

struct CarDetectionView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CarDetectionViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CarDetectionView>) -> CarDetectionViewController {
        ModelUpdater.useUpdateClassifier = context.environment.useUpdateClassifier
        
        let storyboard = UIStoryboard.init(name: "CarDetectionView", bundle: nil)
        return storyboard.instantiateInitialViewController() as? CarDetectionViewController ?? CarDetectionViewController()
    }
    
    func updateUIViewController(_ uiViewController: CarDetectionViewController, context: UIViewControllerRepresentableContext<CarDetectionView>) {
    }
}

struct UseUpdateClassifierKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var useUpdateClassifier: Bool {
        get {
            return self[UseUpdateClassifierKey.self]
        }
        set {
            self[UseUpdateClassifierKey.self] = newValue
        }
    }
}
