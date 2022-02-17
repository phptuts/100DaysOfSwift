//
//  GameViewController.swift
//  Project29
//
//  Created by Noah Glaser on 2/13/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene?
    
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "Player 1: \(player1Score)"
        }
    }
    
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "Player 2: \(player2Score)"
        }
    }

    @IBOutlet var windLabel: UILabel!
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var angleSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame?.viewController = self
                currentGame?.newGravity()
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
        player2ScoreLabel.text = "Player 2: 0"
        player1ScoreLabel.text = "Player 1: 0"
        levelLabel.text = "Level: 1"

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"

    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        velocityLabel.isHidden = true
        velocitySlider.isHidden = true
        launchButton.isHidden = true
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
        
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        velocityLabel.isHidden = false
        velocitySlider.isHidden = false
        launchButton.isHidden = false
    }
    
    func winRound(player: Int) {
        if player == 1 {
            player1Score += 1
        } else {
            player2Score += 1
        }
    }
    
    func nextLevel() {
        if level >= 3 {
            level = 3
            return
        }
        
        level += 1
    }
    
    func updateWindLabel(speed: Int, angle: Int) {
        print("WORKED AGAIN")
        windLabel.text = "Wind Speed \(speed) point at \(angle)°"
    }
    
    func gameOver() {
        gameOverLabel.isHidden = false
        gameOverLabel.text = player2Score > player1Score ? "Game Over: Player 2 Won" : "Game Over:  Player 1 Won"
    }
}
