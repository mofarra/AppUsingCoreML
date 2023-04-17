//
//  Animal.swift
//  CatsAndDogsV1
//
//  Created by Mohamad Alfarra on 3/27/23.
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
    var imgUrl: String
    var imageData: Data?
    var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    init(imgUrl: String, imageData: Data? = nil) {
        self.imgUrl = imgUrl
        self.imageData = imageData
        self.results = []
        if let imageData = imageData {
            classifyAnimal(imageData: imageData)
        } else {
            getImage()
        }
    }
    
    init() {
        self.imgUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json: [String: Any]) {
        guard let imageUrl = json["imgUrl"] as? String else { return nil }
        self.imgUrl = imageUrl
        self.imageData = nil
        self.results = []
        getImage()
    }
    
    func getImage() {
        let url = URL(string: imgUrl)
        guard url != nil else {
            print("could not find URL")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                self.imageData = data
                self.classifyAnimal(imageData: data!)
            }
        }
        dataTask.resume()
    }
    
    func classifyAnimal(imageData: Data) {
        let model = try! VNCoreMLModel(for: modelFile.model)
        let handler = VNImageRequestHandler(data: imageData)
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                print ("Failed to classify animal")
                return
            }
            for classification in results{
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
        }
        do{
            try handler.perform([request])
        } catch {
            print("image format not supported")
        }
    }
}




