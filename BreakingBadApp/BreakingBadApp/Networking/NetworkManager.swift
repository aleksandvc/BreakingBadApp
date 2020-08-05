//
//  NetworkManager.swift
//  BreakingBadApp
//
//  Created by Sasha Belov on 4.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    func getAllCharacters(presenter: UIViewController, completion:@escaping (([Character]?)->())) {
        guard let url = URL(string: Urls.getCharactersUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let dataResponse = data {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    //Decode JSON Response Data
                    let charactersArray = try decoder.decode([Character].self,
                                                   from: dataResponse)
                    
                    completion(charactersArray)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    presenter.present(alert, animated: false, completion: nil)
                }
            }
        })
        
        task.resume()
    }
    
}
