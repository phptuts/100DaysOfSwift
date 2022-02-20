//
//  Card.swift
//  MatchingGame
//
//  Created by Noah Glaser on 2/19/22.
//

import Foundation

typealias Capital = String
typealias Country = String



struct Card: Equatable {
    var position: Int
    var text: String
    var isMatched: Bool = false
    var showing: Bool = false
}

struct GameState {
    var selectedCard1: Card?
    var pairs : [Capital: Country] = [
        "Paris": "France",
        "Washington D.C.": "United States",
        "Argentina": "Buenos Aires",
        "Berlin": "Germany",
        "Vietnam": "Hanoi",
        "Latvia": "Riga",
        "Kenya": "Nairobi",
        "Ireland": "Dublin"
    ]
    var gameStarted = false
    var cards = [Card]()
    
    
    mutating func move(cardNumber: Int) {
        
        var selectedCard = cards[cardNumber]
        
        guard let firstCard = selectedCard1 else {
            selectedCard1 = selectedCard
            selectedCard.showing = true
            return
        }
    
        
        cards = cards.map {
            var card = Card(position: $0.position, text: $0.text)
            card.isMatched = $0.isMatched
            if ($0 == firstCard || $0 == selectedCard) {
                card.isMatched = isMatch(firstCard: firstCard, secondCard: selectedCard)
            }
            card.showing = false
            return card
        }
        
        selectedCard1 = nil
    }
    
    func isMatch(firstCard: Card, secondCard: Card) -> Bool {
        
        return pairs[firstCard.text] == secondCard.text || pairs[secondCard.text] == firstCard.text
    }
        
    mutating func newGame() {
        var randomPairs: [Capital: Country] = [:]
        
        for (i, pair) in pairs.shuffled().enumerated() {
            if i < 4 {
                randomPairs[pair.key] = pair.value
            }
        }
        
        selectedCard1 = nil
        cards = shuffleCards(countryPairs: randomPairs).enumerated().map {
            return Card(position: $0, text: $1)
        }
    }
    
    var gameOver: Bool {
        return cards.filter { $0.isMatched }.count == cards.count && gameStarted
    }
    
    

    func shuffleCards(countryPairs: [Capital: Country]) -> [String] {
       return  countryPairs.shuffled().reduce([String](), {acc, entry in
           var copy = acc.map { $0 }
           copy.append(entry.value)
           copy.append(entry.key)
           return copy
        }).shuffled()
    }
    
}
