//
//  AnimalModel.swift
//  Cat or Dog CoreML
//
//  Created by Arrinal Sholifadliq on 24/01/22.
//

import Foundation

class AnimalModel: ObservableObject {
    
    @Published var animal = Animal()
    
    func getAnimal() {
        let stringUrl = Bool.random() ? catUrl : dogUrl
        
        // create url object
        let url = URL(string: stringUrl)
        
        // check url not nil
        guard url != nil else {
            print("couldn't create url object")
            return
        }
        
        // get url sessioin
        let session = URLSession.shared
        
        // create a data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            // if there is no error
            if error == nil && data != nil {
                
                // parse json
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                        let item = json.isEmpty ? [:] : json[0]
                        print(item)
                        
                        if let animal = Animal(json: item) {
                            DispatchQueue.main.async {
                                while animal.results.isEmpty {}
                                self.animal = animal
                            }
                        }
                    }
                    
                } catch {
                    print("couldn't parse json")
                }
            }
        }
        
        // start data task
        dataTask.resume()
    }
    
}
