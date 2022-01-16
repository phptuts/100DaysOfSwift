//
//  GameScene.swift
//  Day66ShootGalleryGameChallenge
//
//  Created by Noah Glaser on 1/15/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let targets = ["target0", "target1", "target3"]
    
    let startPoints = [CGPoint(x: 90, y: 600), CGPoint(x: 90, y: 400), CGPoint(x: 90, y: 200)]
    
    var scoreLabel: SKLabelNode!
    
    var bulletLabel: SKLabelNode!
    
    var timeLabel: SKLabelNode!

    var player: SKSpriteNode!
    
    var gameOverSprite: SKSpriteNode!
    
    var gameTimer: Timer!
    
    var gameState: GameState! {
        didSet {
            var actions: [SKAction] = []
            if gameState.playFireSound {
                actions.append(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
                gameState.playFireSound = false
            }
            
            if gameState.playReloadSound {
                actions.append(SKAction.playSoundFileNamed("reload", waitForCompletion:  false))
                actions.append(SKAction.wait(forDuration: 0.2))
                gameState.playReloadSound = false
            }
            
            if gameState.playEmptySound {
                actions.append(SKAction.playSoundFileNamed("empty", waitForCompletion: false))
                gameState.playEmptySound = false
            }
            
            if let sprite = gameState.spriteToFade as? SKSpriteNode {
                actions.append(SKAction.fadeOut(withDuration: 0.3))
                actions.append(SKAction.run {
                    sprite.removeFromParent()
                })
                sprite.run(SKAction.sequence(actions))
                gameState.spriteToFade = nil
            } else {
                run(SKAction.sequence(actions))
            }
            
            if gameState.isGameOver {
                gameTimer.invalidate()
                gameOverSprite.zPosition = 3
                gameOverSprite.alpha = 1
            }
            
            scoreLabel.text = "Score: \(gameState.score)"
            
            let bulletMessage = gameState.bullets > 0 ? "Bullets: \(gameState.bullets)" : "Reload"
            bulletLabel.text = bulletMessage
            timeLabel.text = "Time: \(gameState.timeLeft)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        
        let woodbackground = SKSpriteNode(imageNamed: "wood-background")
        woodbackground.position = CGPoint(x: 1024/2, y: 768/2)
        woodbackground.size = CGSize(width: 1024, height: 768)
        woodbackground.zPosition = -1
        addChild(woodbackground)
        
        player = SKSpriteNode(imageNamed: "cursor")
        player.position = CGPoint(x: 60, y: 500)
        player.zPosition = 2

        addChild(player)
        
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: 100, y: 100)
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.zPosition = 2

        addChild(scoreLabel)
        
        bulletLabel = SKLabelNode()
        bulletLabel.position = CGPoint(x: 900, y: 100)
        bulletLabel.fontName = "Chalkduster"
        bulletLabel.zPosition = 2
        bulletLabel.name = "bulletLabel"
        addChild(bulletLabel)
        
        timeLabel = SKLabelNode()
        timeLabel.position = CGPoint(x: 525, y: 100)
        timeLabel.fontName = "Chalkduster"
        timeLabel.zPosition = 2
        addChild(timeLabel)
        
        gameOverSprite = SKSpriteNode(imageNamed: "game-over")
        gameOverSprite.position = CGPoint(x: 525, y: 400)
        gameOverSprite.zPosition = -1
        gameOverSprite.alpha = 0
        addChild(gameOverSprite)
        newGame()
        
    }
    
    func newGame() {
        gameOverSprite.alpha = 0
        gameOverSprite.zPosition = -1
        timeLabel.text = "Time: 25"
        bulletLabel.text = "Bullets: 6"
        scoreLabel.text = "Score: 0"

        gameState = GameState()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameState.isGameOver  {
            let bulletSound = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
            run(bulletSound)
            newGame()
            return
        }
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        player.position = location
        gameState.fireBullet(children.first(where: {$0.contains(location) && $0.name?.contains("target") ?? false}))
        
        if children.filter({$0.contains(location) && $0.name == "bulletLabel"}).count == 1 {
            gameState.reload()
        }
    }
    
   
    @objc func createTarget() {
        
        let target = targets.randomElement()!
                
        let sprite = SKSpriteNode(imageNamed: target)
        sprite.name = target
        
        sprite.position = startPoints.randomElement()!
        
        sprite.physicsBody = SKPhysicsBody()
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.velocity = CGVector(dx: 600, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.angularVelocity = 3
        addChild(sprite)
                
        gameState.timeLeft -= 1
            
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        children.filter{$0.name?.contains("target") ?? false}.forEach {
            if $0.position.x > 1400 {
                $0.removeFromParent()
            }
        }
    }
}
