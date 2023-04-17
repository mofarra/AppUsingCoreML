//
//  AnimalModel.swift
//  CatsAndDogsV1
//
//  Created by Mohamad Alfarra on 3/27/23.
//

import Foundation

class AnimalModel: ObservableObject{
    
    @Published var animal = Animal()
    
    func getAnimal() {
        // to get the data from constants
        let stringUrl = Bool.random() ? catUrl : dogUrl
        
        //1. create the url object (1-4 is standard when getting image or video)
        let url = URL(string: stringUrl)
        
        //2. check if url is empty
        guard url != nil else {
            print("couldn't create url")
            return
        }
        
        //3. get url
        let session = URLSession.shared
        
        //4. create data task
        let dataTask = session.dataTask(with: url!) {(data, response, error) in
            if error == nil && data != nil {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                       let imageUrl = json["url"] as? String {
                        // create the animal instance with image URL
                        let animal = Animal(imgUrl: imageUrl)
                        
                        DispatchQueue.main.async {
                            // We are checking if the image is avilable 
                            while animal.results.isEmpty {}
                            
                            // set the downloaded image data to the animal instance
                            self.animal = animal
                        }
                    }
                } catch {
                    print("JSON parse failed")
                }
            }
        }
        dataTask.resume()
    }
}

