//
//  Animal.swift
//  Cat or Dog CoreML
//
//  Created by Arrinal Sholifadliq on 24/01/22.
//

import Foundation
import CoreML
import Vision

struct Result: Identifiable {
    var imageLabel: String
    var confidence: Double
    var id = UUID()
}


class Animal {
    
    // url for image
    var imageUrl: String
    
    // image data
    var imageData: Data?
    
    // model file
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    // classified results
    var results: [Result]
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json: [String: Any]) {
        
        // check JSON has a URL
        guard let imageUrl = json["url"] as? String else { return nil }
        
        // set animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        self.results = []
        
        // download image data
        getImage()
    }
    
    func getImage() {
        
        // create url object
        let url = URL(string: imageUrl)
        
        // check url isn't nil
        guard url != nil else {
            print("couldn't get url")
            return
        }
        
        // get url session
        let session = URLSession.shared
        
        // create data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            // check no errors
            if error == nil && data != nil {
                self.imageData = data
                self.classifyAnimal()
            }
        }
        
        // start data task
        dataTask.resume()
    }
    
    func classifyAnimal() {
        
        // get reference to the model
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        // create an image handler
        let handler = VNImageRequestHandler(data: imageData!)
        
        // create request to the model
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("couldn't classify animal")
                return
            }
            
            // update results
            for classification in results {
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
            
        }
        
        // execute request
        do {
            try handler.perform([request])
        } catch {
            print("invalid image")
        }
    }
}
