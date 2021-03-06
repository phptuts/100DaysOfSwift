//
//  ViewController.swift
//  Project2
//
//  Created by Noah Glaser on 11/29/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
        
    var countries = [String]()
    
    var score = 0
    
    var correctAnswer = 0
    
    var totalQuestions = 0
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(showScore))
        
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigerai", "poland", "russia", "spain", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            [weak self] granted, error in
            if granted {
                center.removeAllPendingNotificationRequests()
                self?.scheduleNotifications()
            }
        }
        
        askQuestion()
    }
    

    
    
    
    
    
    
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()

        for i in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Play Flag Game"
            content.body = "Please play the awesome flag game!"
            content.categoryIdentifier = "flag_game_reminder"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(10 * i), repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
                
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        button1.transform = CGAffineTransform(scaleX: 1, y: 1)
        button2.transform = CGAffineTransform(scaleX: 1, y: 1)
        button3.transform = .identity

        
        self.title = "Flag: \(self.countries[correctAnswer].uppercased()) | score: \(self.score)"
        self.totalQuestions += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        let isCorrect = sender.tag == correctAnswer
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { [weak self] _ in
            self?.updateScore(isCorrect: isCorrect)
        }

    }
    
    func updateScore(isCorrect: Bool) {
        self.score += isCorrect ? 1 : -1
        if !isCorrect {
            
            let alertControllerWrongAnswer = UIAlertController(title: "Wrong Answer", message: "Wrong! That???s the flag of \(countries[self.correctAnswer].countryCase)", preferredStyle: .alert)
            alertControllerWrongAnswer.addAction(UIAlertAction(title: "Continue", style: .default))
            
            present(alertControllerWrongAnswer, animated: true)
        }
        
        
        if totalQuestions == 10 {
            
            let defaults = UserDefaults.standard
            
            let currentHighScore = defaults.integer(forKey: "highscore")
            let title: String
            if currentHighScore < score {
                title = "High Score"
                defaults.set(score, forKey: "highscore")
            } else {
                title = "Your Score"
            }
            
            let ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in self.askQuestion()}))
            present(ac, animated: true)
            
            self.totalQuestions = 0
            self.score = 0
        } else {
            self.askQuestion()
        }
    }
    
    @objc func showScore() {
        // this controls the alert
        let ac = UIAlertController(title: "Score", message: "Your score is \(self.score)", preferredStyle: .alert)
        // This controls the button
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present(ac, animated: true)
    }
    
}

extension String  {
    var countryCase: String {
        
        // If it equals us or uk
        // upper case the string
        if self.count == 2 {
            return self.uppercased()
        }
        
        // Get the first letter and upper case it otherwise
        // return blank string
        let firstLetter =  self.first?.uppercased() ?? ""
        var stringCopy = self
        // remove first charcter
        stringCopy.removeFirst()
        
        // This will turn SPAIN -> Spain or spain -> Spain
        return "\(firstLetter)\(stringCopy.lowercased())"
    }
    
}
