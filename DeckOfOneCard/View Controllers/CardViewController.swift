//
//  CardViewController.swift
//  DeckOfOneCard
//
//  Created by Connor Holland on 6/16/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var suiteValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Methods
    func fetchImageAndUpdateViews(for card: Card) {
        CardController.fetchImage(for: card) { [weak self] (result) in
            DispatchQueue.main.async {
            switch result {
            case .success(let image):
                self?.suiteValueLabel.text = "\(card.value) 0f \(card.suit)"
                self?.cardImageView.image = image
            case .failure(let error):
                self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func drawButtonTapped(_ sender: Any) {
        CardController.fetchCard { [weak self] (result) in
            switch result {
            case .success(let card):
                self?.fetchImageAndUpdateViews(for: card)
            case .failure(let error):
                DispatchQueue.main.async {
                self?.presentErrorToUser(localizedError: error )
                }
            }
        }
    }
}
