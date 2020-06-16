//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Connor Holland on 6/16/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import UIKit

class CardController {
  static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
    // 1 - Prepare URL
    guard let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new") else {return completion(.failure(.invalidURL))}
    let url = baseURL.appendingPathComponent("draw")
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    components?.queryItems = [URLQueryItem(name: "count", value: "1")]
    guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
    print(finalURL)
    
    // 2 - Contact server
    URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
        if let error = error {
            return completion(.failure(.thrownError(error)))
        }
      
    // 4 - Check for json data
        guard let data = data else {return completion(.failure(.noData))}
      
    // 5 - Decode json into a Card
        do {
            let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
            let card = topLevelObject.cards[0]
            return completion(.success(card))
        } catch {
            return completion(.failure(.thrownError(error)))
        }
    }.resume()
  }
   
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
        // 1 - Prepare URL
        let finalURL = card.image
        print(finalURL)
          // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
                      
            // 4 - Check for image data
            guard let data = data else {return completion(.failure(.noData))}
                      
            // 5 - Initialize an image from the data
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            return completion(.success(image))
            
        }.resume()
    }
}
    
    

