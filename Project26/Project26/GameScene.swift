//
//  GameScene.swift
//  Project26
//
//  Created by Noah Glaser on 2/5/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    
    var scoreLabel: SKLabelNode!
    
    var levelLabel: SKLabelNode!
    
    var isGameOver = false
    
    var teleported = false
    
    var landingSprite: SKSpriteNode?
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
        
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 200, y: 16)
        levelLabel.zPosition = 2
        addChild(levelLabel)

        
        loadLevel(fileName: "level1")
        createPlayer()
        
        physicsWorld.gravity.dy = 0
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    
    func clearLevel() {
        for case let node as SKSpriteNode in children {
            if ["wall", "vortex", "star", "finish", "teleport", "landing"].contains(node.name) {
                node.removeFromParent()
            }
        }
    }
    
    func fetchLevelFromFile(fileName: String) -> [String] {
        guard let levelUrl = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
            fatalError("Cound find level.txt in the app bundle")
        }
        
        guard let levelString = try? String(contentsOf: levelUrl) else {
            fatalError("Could load level.txt in the app bundle")
        }
        
        return levelString.components(separatedBy: "\n").filter({ !$0.isEmpty })
    }
    
    func createSpace(space: Character, column: Int, row: Int) {
        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
        
        if space == "x" {
            // load wall
            let node = SKSpriteNode(imageNamed: "block")
            node.position = position
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            node.physicsBody?.isDynamic = false
            node.name = "wall"
            addChild(node)
        } else if space == "v" {
            // load vortex
            let node = SKSpriteNode(imageNamed: "vortex")
            node.name = "vortex"
            node.position = position
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            addChild(node)
        } else if space == "t" || space == "l" {
            // load vortex
            let node = SKSpriteNode(imageNamed: "teleport")
            node.name = space == "t" ? "teleport" : "landing"
            node.position = position
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            if space == "t" {
                landingSprite = node
            }
            
            addChild(node)
        } else if space == "s" {
            // load star
            let node = SKSpriteNode(imageNamed: "star")
            node.name = "star"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.position = position
            addChild(node)
        } else if space == "f" {
            // load finish point
            let node = SKSpriteNode(imageNamed: "finish")
            node.name = "finish"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.position = position
            addChild(node)
        } else if space == " " {
            // this is an empty space
        } else {
            fatalError("Unknown level letter: \(space)")
        }
    }
        
    func loadLevel(fileName: String, randomize: Bool = false) {
        
        let lines = fetchLevelFromFile(fileName: fileName)
        print(lines)
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                
                // All spaces should remain to guarantee a path
                if letter == " " {
                    continue
                }
                
                // row = 0 or column = 0 that means it must be wall because it's on the perimeter
                // if it's f that means it's trophy and we should leave it a long
                if !randomize || row == 0 || column == 0 || row == 11 || column == 15 || letter == "f" || letter == "t" || letter == "l" {
                    createSpace(space: letter, column: column, row: row)
                    continue
                } else {
                    let spaces = "xxxxvvvs"
                    if let space = spaces.randomElement() {
                        createSpace(space: space, column: column, row: row)
                    }
                }
                
                
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.zPosition = 1
        player.position = CGPoint(x: 96, y: 672)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scaleX(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "teleport" {
            player.physicsBody?.isDynamic = false
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scaleX(to: 0.0001, duration: 0.25)
            let sequence = SKAction.sequence([move, scale])
            player.run(sequence) {
                [weak self] in
                if let landing =  self?.children.first(where: { $0.name == "landing"}) {
                    self?.player.position = landing.position
                    let scale = SKAction.scaleX(to: 1, duration: 0.25)
                    self?.player.run(scale)
                    self?.player.physicsBody?.isDynamic = true
                }
                
            }
            
            
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            self.clearLevel()
            self.loadLevel(fileName: "level-random", randomize: true)
            player.physicsBody?.isDynamic = false
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let scale = SKAction.scaleX(to: 0.0001, duration: 0.25)

            let start = SKAction.run {
                [weak self] in
                self?.level += 1
                self?.createPlayer()
            }
            
            player.run(SKAction.sequence([scale, wait, start, remove]))
            
            
        }
    }
}
