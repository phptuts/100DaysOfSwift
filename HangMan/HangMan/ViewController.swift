//
//  ViewController.swift
//  HangMan
//
//  Created by Noah Glaser on 12/21/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var hangmanImage: UIImageView!

    @IBOutlet var letterDisplayLabel: UILabel!
    let maxLetters = 9
    var guessLeft = 6
    
    var selectedWord = ""
    var guessedLetters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        newGame()
        
    }

    @objc func getWord() -> String {
        let urlString = "https://random-word-api.herokuapp.com/word?number=10"
        // This is pretend that the api takes 1 seconds
        sleep(1)
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // ok to parse the data
                let decoder = JSONDecoder()
                if let words = try? decoder.decode(Array<String>.self, from: data)  {
                    if let word = words.filter({ $0.count < self.maxLetters }).randomElement() {
                        return word.lowercased()
                    }
                }
            }
        }
        
        return "error"
    }
    
   
    func newGame() {
        letterDisplayLabel.text = "Fetching Word"
        guessedLetters = []
        guessLeft = 6
        hangmanImage.image = UIImage(named: "hangman0")
        performSelector(inBackground: #selector(setupGame), with: nil)
    }
    
    @objc func setupGame() {
        selectedWord = getWord()
        print(selectedWord)
        var blankText = ""
        for _ in 0..<selectedWord.count {
            blankText += "_ "
        }
        DispatchQueue.main.async {
            self.letterDisplayLabel.text = blankText
        }
        
    }
    
    @IBAction func tappedGuess(_ sender: Any) {
        
        if guessLeft == 0 {
            showAlert(title: "Game Over", message: "Tap New Game to start a new game.", handler: nil)
            return
        }
        
        let ac = UIAlertController(title: "Guess Letter", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Guess", style: .default, handler: { [weak self, weak ac] _ in
            if let letterGuess = ac?.textFields?.first?.text?.first {
                self?.guessCharacter(letterGuess)
            }
        }))
        present(ac, animated: true)
    }
    
    @IBAction func tappedNewGame(_ sender: Any) {
        newGame()
    }
    
    func guessCharacter(_ c: Character) {
        
        
        
        if selectedWord.contains(c) {
            guessedLetters.append(c)
            var newChars = ""
            
            let wordArray = Array(selectedWord)
            for i in 0..<wordArray.count {
                let charAdded =  guessedLetters.contains(wordArray[i]) ? " \(wordArray[i])" : " _"
                newChars += charAdded
            }
            letterDisplayLabel.text = newChars
            
            if !newChars.contains("_") {
                showAlert(title: "You Won!!", message: "Congrats You Guess the word!", handler: nil)
            }
            
            return
        }
        
        guessLeft -= 1
        let imageNumber = 6 - guessLeft
        let imageName = "hangman\(imageNumber)"
        hangmanImage.image = UIImage(named: imageName)
        
        if guessLeft == 0 {
            showAlert(title: "You Lose", message: "Sorry to lost :)", handler: {
                [weak self] _ in
                self?.showWord()
            })
        }
    }
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "contine", style: .default, handler: handler))
        
        present(ac, animated: true)
    }
    
    func showWord() {
        var newChars = ""
        let wordArray = Array(selectedWord)
        for i in 0..<wordArray.count {
            newChars += " \(wordArray[i])"
        }
        letterDisplayLabel.text = newChars
    }
}

