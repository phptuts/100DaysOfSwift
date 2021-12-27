//
//  GameScene.swift
//  Project11
//
//  Created by Noah Glaser on 12/25/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    let ballImages = ["ballRed","ballBlue","ballGreen", "ballGrey", "ballPurple", "ballYellow"]

    var scoreLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!

    var ballCount = 5 {
        didSet {
            ballsLabel.text = "Balls Left: \(ballCount)"
            if ballCount == 0 {
                gameOverAlert()
            }
        }
    }
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = true {
        didSet {
            if editingMode {
                editLabel.text = "Start Dropping"
            } else {
                editLabel.text = "Playing"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .aspectFit;

        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls Left: 5"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballsLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "New Game"
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.position = CGPoint(x: 40, y: 700)
        addChild(newGameLabel)

        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Start Dropping"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 40, y: 650)
        addChild(editLabel)
        
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640 , y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        let location = firstTouch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode = false
            return
        }
        
        if objects.contains(newGameLabel) {
            newGame()
            return
        }
            
        if editingMode {
            let size = CGSize(width: Int.random(in: 16...128), height: 16)
            let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
            box.name = "box"
            box.zRotation = CGFloat.random(in: 1...3)
            box.position = location
            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            addChild(box)
            return
        }
        
        
        if isGameOver() {
            gameOverAlert()
            return
        }
        //        let boxNode = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
        //        boxNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        //        boxNode.position = location
        //        addChild(boxNode)
                
        let ball = SKSpriteNode(imageNamed: ballImages.randomElement() ?? "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.restitution = 0.9
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        ball.position = CGPoint(x: location.x, y:scoreLabel.position.y)
        ball.name = "ball"
        ballCount -= 1
        addChild(ball)
        
        
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)

    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        
        slotGlow.position = position
        
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            if isGameOver() {
                gameOverAlert()
            }
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            if isGameOver() {
                gameOverAlert()
            }
        } else if object.name == "box" {
            destroy(ball: object)
            score += 10
        }
    }
    
    func newGame() {
        scene?.children.filter { $0.name == "box" }.forEach {
            $0.removeFromParent()
        }
        ballCount = 5
        score = 0
        editingMode = true
    }
    
    func didWinGame() -> Bool {
        return scene?.children.filter { $0.name == "box" }.count == 0
    }
    
    func isGameOver() -> Bool {
        return didWinGame() || ballCount == 0
    }
    
    func gameOverAlert() {
        
        let didWin = didWinGame()
        let message = "You \(didWin ? "won": "lost") the game"
        let ac = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: {
            [weak self] _ in
            self?.newGame()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let controller = view?.window?.rootViewController  {
            controller.present(ac, animated: true)
        }
    }
    
    func destroy(ball: SKNode) {
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
