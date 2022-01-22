//
//  GameScene.swift
//  Project20
//
//  Created by Noah Glaser on 1/19/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    
    var triesLabel: SKLabelNode!
    
    var gameTime: Timer?
    
    var fireworks = [SKNode]()
    
    var leftEdge = -22
    var bottomEdge = -22
    var rightEdge = 1024 + 22
    
    var tries = 5 {
        didSet {
            triesLabel.text = "Tries: \(tries)"
            if tries == 0 {
                
                triesLabel.text = "Last Try"
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        gameTime = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        scoreLabel = SKLabelNode()
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 40, y: 100)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        triesLabel = SKLabelNode()
        triesLabel.fontName = "Chalkduster"
        triesLabel.fontSize = 40
        triesLabel.position = CGPoint(x: view.center.x, y: 100)
        triesLabel.text = "Tries: \(tries)"
        addChild(triesLabel)

    }
    
    
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
            case 0:
                firework.color = .cyan
            case 1:
                firework.color = .green
            default:
                firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y:-22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        
        addChild(node)
    }
    
    @objc func launchFireworks() {
        
        if tries == 0 {
            gameTime?.invalidate()
            return
        }
        
        tries -= 1
        let movementAmount: CGFloat = 1800
        let fireworkMovement = Int.random(in: 0...3)
        switch fireworkMovement {
        case 0:
            // fire five straigt up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            // fire five in fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)

        case 2:
            // fire left to right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            
            // fire left to right
            
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    func newGame() {
        tries = 5
        score = 0
        gameTime = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        
        if tries <= 0 &&  children.count < 5 {
            newGame()
            return
        }
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
    
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue}
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "selected"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
            
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                firework.removeFromParent()
                
                fireworks.remove(at: index)
            }
        }
        
        if children.count < 5 && tries == 0  {
            triesLabel.text = "Tap to play again!"
        }
    }
    
    func explode(firework: SKNode) {
        guard let emitter = SKEmitterNode(fileNamed: "explode") else { fatalError("missing explosion!")}
        emitter.position = firework.position
        emitter.name = "explosion"
        addChild(emitter)
        emitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
        ]))
        firework.removeFromParent()
    }
    
    
    
    func explodeFireworks() {
        var numExplode = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExplode += 1
            }
        }
        
        switch numExplode {
            case 0:
                break;
            case 1:
                score += 200
            case 2:
                score += 500
            case 3:
                score += 1500
            case 4:
                score += 2500
            default:
                score += 4000
        }
    }
}
