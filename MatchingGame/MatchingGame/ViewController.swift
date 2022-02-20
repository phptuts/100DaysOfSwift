//
//  ViewController.swift
//  MatchingGame
//
//  Created by Noah Glaser on 2/19/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardLabel1: UILabel!
    @IBOutlet var cardLabel2: UILabel!
    @IBOutlet var cardLabel3: UILabel!
    @IBOutlet var cardLabel4: UILabel!
    @IBOutlet var cardLabel5: UILabel!
    @IBOutlet var cardLabel6: UILabel!
    @IBOutlet var cardLabel7: UILabel!
    @IBOutlet var cardLabel8: UILabel!
    
    var game: GameState! {
        didSet {
            
            if !game.gameStarted {
                return
            }
            
            canMove = true
            if game.selectedCard1 != nil {
                
                return
            }
            
            self.game.cards.forEach { card in
                guard let label = self.cardLabels.first(where: { $0.text == card.text }) else { return }
                if card.isMatched {
                    label.hideCard()
                } else {
                    label.flipCardOver()
                }
            }
            
            
            
            if self.game.gameOver {
                let ac = UIAlertController(title: "You Won", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "YEAH!", style: .default))
                
                present(ac, animated: true)
            }
        }
    }
    
    var cardLabels = [UILabel]()
    
    var canMove = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = GameState()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))
        // Do any additional setup after loading the view.
        cardLabels = [cardLabel1, cardLabel2, cardLabel3, cardLabel4, cardLabel5, cardLabel6, cardLabel7, cardLabel8]

        newGame()
    }
    
    @objc func newGame() {
        game.gameStarted = false
        game.newGame()
        
        cardLabels.enumerated().forEach {
            $1.isUserInteractionEnabled = true
            $1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedCard)))
            $1.transform = CGAffineTransform(scaleX: -1, y: 1)
            $1.textColor = $1.backgroundColor
            $1.alpha = 1
            $1.text = game.cards[$0].text
        }
        game.gameStarted = true
    }
    
    @objc func selectedCard(sender: UITapGestureRecognizer) {
        
        if !canMove {
            return
        }
        
        canMove = false
        guard let label = sender.view as? UILabel else { return }
        label.showCard() {
            [weak self, weak label] in
            guard let cardNumber = label?.tag else { return }
            self?.game.move(cardNumber: cardNumber - 1)
        }
    }

}

extension UILabel {
    func showCard(onComplete: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.transform = .identity
            self.textColor = .white
        }, completion: { _ in
            onComplete()
        })
    }
    
    func flipCardOver() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.textColor = self.backgroundColor
            self.alpha = 1
        })
    }
    
    func hideCard() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.alpha = 0
        })
    }
}

