import CoreML

// MARK: - ModelUpdater
/// Code from: https://developer.apple.com/documentation/coreml/core_ml_api/personalizing_a_model_with_on-device_updates
struct ModelUpdater {
    
    // MARK: - Public Properties
    static var liveModel: MLModelHandler {
        if useUpdateClassifier {
            return updatedCarClassifier ?? defaultCarClassifier
        } else {
            return createMLTrainedModel
        }
    }
    
    static var useUpdateClassifier = true
    
    // MARK: - Private Type Properties
    private static var updatedCarClassifier: MyCarsUpdatableModel?
    private static let defaultCarClassifier = MyCarsUpdatableModel()
    private static let createMLTrainedModel = ToyCarsImageClassifier_v2()
    
    /// The location of the app's Application Support directory for the user.
    private static let appDirectory = FileManager.default.urls(for: .applicationSupportDirectory,
                                                               in: .userDomainMask).first!
    private static let defaultModelURL = MyCarsUpdatableModel.urlOfModelInThisBundle
    private static var updatedModelURL = appDirectory.appendingPathComponent("personalized.mlmodelc")
    private static var tempUpdatedModelURL = appDirectory.appendingPathComponent("personalized_tmp.mlmodelc")
    
    private static var hasMadeFirstPrediction = false
    
    private init() {}
    
    // MARK: - Public API
    static func updateWith(trainingData: MLBatchProvider,
                           completionHandler: @escaping () -> Void) {
        let usingUpdatedModel = updatedCarClassifier != nil
        let currentModelURL = usingUpdatedModel ? updatedModelURL : defaultModelURL
        
        /// The closure an MLUpdateTask calls when it finishes updating the model.
        func updateModelCompletionHandler(updateContext: MLUpdateContext) {
            // Save the updated model to the file system.
            saveUpdatedModel(updateContext)
            
            // Begin using the saved updated model.
            loadUpdatedModel()
            
            // Inform the calling View Controller when the update is complete
            DispatchQueue.main.async { completionHandler() }
        }
        
        MyCarsUpdatableModel.updateModel(at: currentModelURL,
                                         with: trainingData,
                                         completionHandler: updateModelCompletionHandler)
    }
    
    static func resetClassifier() {
        updatedCarClassifier = nil
        
        // Remove the updated model from its designated path.
        if FileManager.default.fileExists(atPath: updatedModelURL.path) {
            try? FileManager.default.removeItem(at: updatedModelURL)
        }
    }
    
    // MARK: - Private Type Helper Methods
    /// Saves the model in the given Update Context provided by an MLUpdateTask.
    /// - Parameter updateContext: The context from the Update Task that contains the updated model.
    /// - Tag: SaveUpdatedModel
    private static func saveUpdatedModel(_ updateContext: MLUpdateContext) {
        let updatedModel = updateContext.model
        let fileManager = FileManager.default
        do {
            // Create a directory for the updated model.
            try fileManager.createDirectory(at: tempUpdatedModelURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            
            // Save the updated model to temporary filename.
            try updatedModel.write(to: tempUpdatedModelURL)
            
            // Replace any previously updated model with this one.
            _ = try fileManager.replaceItemAt(updatedModelURL,
                                              withItemAt: tempUpdatedModelURL)
            
            print("Updated model saved to:\n\t\(updatedModelURL)")
        } catch let error {
            print("Could not save updated model to the file system: \(error)")
            return
        }
    }
    
    private static func loadUpdatedModel() {
        guard FileManager.default.fileExists(atPath: updatedModelURL.path) else {
            // The updated model is not present at its designated path.
            return
        }
        
        // Create an instance of the updated model.
        guard let model = try? MyCarsUpdatableModel(contentsOf: updatedModelURL) else {
            return
        }
        
        updatedCarClassifier = model
    }
}

// MARK: - MLModelHandler
extension MLModelHandler {
    static func updateModel(at url: URL,
                            with trainingData: MLBatchProvider,
                            completionHandler: @escaping (MLUpdateContext) -> Void) {
        
        // Create an Update Task.
        guard let updateTask = try? MLUpdateTask(forModelAt: url,
                                           trainingData: trainingData,
                                           configuration: nil,
                                           completionHandler: completionHandler)
            else {
                print("Could't create an MLUpdateTask.")
                return
        }
        
        updateTask.resume()
    }
}
