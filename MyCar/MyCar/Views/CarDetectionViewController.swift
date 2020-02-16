//
//  CarDetectionViewController.swift
//  MyCar
//
//  Created by Radu Dan on 12/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import UIKit
import ARKit
import Vision

// MARK: - CarDetectionViewController
final class CarDetectionViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var debugLabel: UILabel!
    
    /// Used to update classifications every N seconds.
    private var timer: Timer!
    
    /// The amount of time in seconds for capturing the frame.
    private let timeLoopInterval: TimeInterval = 2
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = makeARConfiguration()
        runSceneView(with: configuration)
        
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timeLoopInterval, repeats: true) { [weak self] _ in
            if let capturedImage = self?.sceneView.session.currentFrame?.capturedImage,
                let image = UIImage(pixelBuffer: capturedImage) {
                self?.updateClassifications(for: image)
            }
        }
    }
    
    private func makeARConfiguration() -> ARConfiguration {
        let configuration: ARConfiguration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        return configuration
    }
    
    private func runSceneView(with configuration: ARConfiguration) {
        sceneView.session.run(configuration)
    }
    
    // MARK: - Classification Handlers
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ModelUpdater.liveModel.model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                DispatchQueue.main.async {
                    self?.processClassifications(for: request, error: error)
                }
            })
            request.imageCropAndScaleOption = .centerCrop
            
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            debugLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
            return
        }
        
        let classifications = results as! [VNClassificationObservation]
        
        if classifications.isEmpty {
            debugLabel.text = "Nothing recognized."
        } else {
            let descriptions = classifications.map { classification in
                return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
            }
            
            debugLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
        }
    }
    
    private func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                self.debugLabel.text = "Failed to perform classification.\n\(error.localizedDescription)"
            }
        }
    }
    
}
