//
//  GameScene.swift
//  Project23
//
//  Created by Noah Glaser on 1/27/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum ForcedBomb {
    case never, alway, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    
    var activeSlicePoints = [CGPoint]()
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    let SPEEDTARGET = "SPEED_TARGET"
    let TARGET = "TARGET"
    
    let targets = ["TARGET", "SPEED_TARGET"]
    
    
    
    var activeEnemies = [SKSpriteNode]()
    
    var isSwooshSoundActive = false
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9
    
    var sequence = [SequenceType]()
    
    var sequencePosition = 0
    
    var chainDelay = 3.0
    
    var nextSequenceQueued = true
    
    var isGameEnded = false
    
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFit
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in self?.tossEnemies()
        }
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isGameEnded == false else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if targets.contains(node.name ?? "") {
                // destroy penquin
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                score += node.name == SPEEDTARGET ? 5 : 1

                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.0001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                // destroy the bomb
                guard let bombContainer = node.parent as? SKSpriteNode else { return }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.0001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])

                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: true))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else { return }
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
        
        
        
        let gameOverSprite = SKSpriteNode(imageNamed: "gameover")
        gameOverSprite.position = CGPoint(x: 512, y: 384)
        gameOverSprite.zPosition = 3
        gameOverSprite.scale(to: CGSize(width: 300, height: 300))
        addChild(gameOverSprite)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration:   0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration:   0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        // This is so the fade out in the touches end does not interfer with
        // the new lines being created
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceFG.path = path.cgPath
        activeSliceBG.path = path.cgPath
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        run(swooshSound) {
            [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    let enemyProperties = (
        enemyTypeBomb: 0,
        enemyTypePenguin: 1,
        bombFuseX: 76,
        bombFuseY: 64,
        enemyXStartRange: 64...960,
        enenyYStart: 128,
        enemyAngularVelocityRange: CGFloat(-3.0)...CGFloat(3.0),
        left: CGFloat(256),
        leftMiddle: CGFloat(512),
        rightMiddle: CGFloat(768),
        highXSpeedRange: 8...15,
        lowXSpeedRange: 3...5,
        yVelocityRange: 20...28,
        sizeOfCollisionBody: CGFloat(64),
        speedMultiplier: 40,
        fasterSpeedMultiplier: 44
    )
    
    func createEnemy(forceBomb: ForcedBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = enemyProperties.enemyTypePenguin
        } else if forceBomb == .alway {
            enemyType = enemyProperties.enemyTypeBomb
        }
        
        var useSlowSpeed = true
        
        if enemyType == enemyProperties.enemyTypeBomb {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: "sliceBombUse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "slicedFuse") {
                emitter.position = CGPoint(x: enemyProperties.bombFuseX, y: enemyProperties.bombFuseY)
                enemy.addChild(emitter)
            }
            
        } else {
            
            if Int.random(in: 1...5) > 4 {
                enemy = SKSpriteNode(imageNamed: "target1")
                enemy.name = SPEEDTARGET
                useSlowSpeed = false
            } else {
                enemy = SKSpriteNode(imageNamed: "penguin")
                enemy.name = TARGET
            }
            
            
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        }
        
        let randomPosition = CGPoint(x: Int.random(in: enemyProperties.enemyXStartRange), y: enemyProperties.enenyYStart)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: enemyProperties.enemyAngularVelocityRange)
        let randomXVelocity: Int
        
        if randomPosition.x < enemyProperties.left {
            randomXVelocity = Int.random(in: enemyProperties.highXSpeedRange)
        } else if randomPosition.x < enemyProperties.leftMiddle {
            randomXVelocity = Int.random(in: enemyProperties.lowXSpeedRange)
        } else if randomPosition.x < enemyProperties.rightMiddle {
            randomXVelocity = -Int.random(in: enemyProperties.lowXSpeedRange)
        } else {
            randomXVelocity = -Int.random(in: enemyProperties.highXSpeedRange)
        }
        
        let randomYVelocity = Int.random(in: enemyProperties.yVelocityRange)
        let speedMultiplier = useSlowSpeed ? enemyProperties.speedMultiplier : enemyProperties.fasterSpeedMultiplier
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemyProperties.sizeOfCollisionBody)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * speedMultiplier, dy: randomYVelocity * speedMultiplier)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if isGameEnded && activeEnemies.count > 0 {
            for sprite in activeEnemies.reversed() {
                sprite.run(SKAction.fadeOut(withDuration: 0.5))
                sprite.name = ""
                sprite.removeFromParent()
            }
            activeEnemies.removeAll(keepingCapacity: true)
        } else if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if  targets.contains(node.name ?? ""){
                        node.name = ""
                        subtractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)

                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                    
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) {
                [weak self] in self?.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    func tossEnemies() {
        
        guard isGameEnded == false else { return }
        
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .alway)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) {
                [weak self] in self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) {
                [weak self] in self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) {
                [weak self] in self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) {
                [weak self] in self?.createEnemy()
            }
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) {
                [weak self] in self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) {
                [weak self] in self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) {
                [weak self] in self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) {
                [weak self] in self?.createEnemy()
            }
        }
        sequencePosition += 1
        nextSequenceQueued = false
    }
}
