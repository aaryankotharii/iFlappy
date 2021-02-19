//
//  GameScene.swift
//  iFlappy
//
//  Created by Aaryan Kothari on 01/02/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Bird = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var shareButton = SKSpriteNode()
    var finalScoreNode = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var scoreLabel = SKLabelNode()
    
    var moveAndRemove = SKAction()
    var moveAndRemoveGround = SKAction()
    
    var gameStarted : Bool = false
    var gameOver : Bool = false
    
    var score : Int = 0
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func shareScore() {
        
    }
    
    func createScene() {
        runGroundSpawner()
        createBird()
        setupScoreLabel()
        setupBackground()
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func setupScoreLabel() {
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 100)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 4
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "04b_19"
        scoreLabel.fontSize = 60
        self.addChild(scoreLabel)
    }
    
    func setupRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.size = CGSize(width: 107, height: 37.5)
        restartButton.position = CGPoint(x: self.frame.width/2 - 65, y: self.frame.height/2)
        restartButton.zPosition = 5
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func setupShareButton() {
        shareButton = SKSpriteNode(imageNamed: "share")
        shareButton.size = CGSize(width: 107, height: 37.5)
        shareButton.position = CGPoint(x: self.frame.width/2 + 65, y: self.frame.height/2)
        shareButton.zPosition = 5
        shareButton.setScale(0)
        self.addChild(shareButton)
        shareButton.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func setupFinalScore() {
        finalScoreNode = SKSpriteNode(imageNamed: "score")
        finalScoreNode.size = CGSize(width: 100, height: 132)
        finalScoreNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 100)
        finalScoreNode.zPosition = 5
        finalScoreNode.setScale(0)
        
        let highScore = DefaultManager().fetchHighScore()
        
        let finalScoreLabel = SKLabelNode(text: "\(score)")
        finalScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 140)
        finalScoreLabel.zPosition = 6
        finalScoreLabel.fontColor = .white
        finalScoreLabel.fontName = "04b_19"
        finalScoreLabel.fontSize = 30
        
        let highScoreLabel = SKLabelNode(text: "\(highScore)")
        highScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 190)
        highScoreLabel.zPosition = 6
        highScoreLabel.fontColor = .white
        highScoreLabel.fontName = "04b_19"
        highScoreLabel.fontSize = 30
        
        
        self.addChild(finalScoreLabel)
        self.addChild(highScoreLabel)

        self.addChild(finalScoreNode)
        finalScoreNode.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func gameOverSetupgameOverSetup() {
        setupRestartButton()
        setupShareButton()
        setupFinalScore()
        scoreLabel.run(SKAction.fadeAlpha(to: 0.0, duration: 0.3))
    }
    
    func setupBackground() {
        for i in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.position = CGPoint(x: CGFloat(i) * self.frame.width, y: Ground.frame.height)
            bg.name = "background"
            bg.size = self.view!.bounds.size
            self.addChild(bg)
        }
    }
    
    func createGround() {
        
        Ground = SKSpriteNode(imageNamed: "ground")
        Ground.name = "ground"
        Ground.setScale(0.5)
        
        /// Set Ground position
        let halfGroundHeight = Ground.frame.height / 2
        Ground.position = CGPoint(x: Ground.frame.width/2, y: halfGroundHeight)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        Ground.run(moveAndRemoveGround)
        /// Add Ground to Scene
        self.addChild(Ground)
    }
    
    func runGroundSpawner() {
        let spawn = SKAction.run { self.createGround() }
        
        let delay = SKAction.wait(forDuration: 2.0)
        let spawnDelay = SKAction.sequence([spawn,delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        
        let distance = CGFloat(self.frame.width)
        let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
        
        let removePipes = SKAction.removeFromParent()
        
      moveAndRemoveGround = SKAction.sequence([movePipes,removePipes])
    }
    
    func createBird() {
        Bird = SKSpriteNode(imageNamed: "bird")
        Bird.animateWithLocalGIF(fileNamed: "bird")
        
        /// Set Bird size and position
        Bird.size = CGSize(width: 60, height: 42)
        Bird.position = CGPoint(x: self.frame.width/2 - Bird.frame.width, y: self.frame.height/2)
        
        Bird.physicsBody = SKPhysicsBody(circleOfRadius: Bird.frame.height / 2)
        Bird.physicsBody?.categoryBitMask = PhysicsCategory.Bird
        Bird.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        Bird.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score
        Bird.physicsBody?.affectedByGravity = false
        Bird.zPosition = 2
        
        /// Add Bird to Scene
        self.addChild(Bird)
        
    }
    
    func createWalls() {
        
        let scoreNode = SKSpriteNode()
        
        scoreNode.size = CGSize(width: 1, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        scoreNode.color = .clear
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width + topWall.frame.width, y: self.frame.height + 50)
        bottomWall.position = CGPoint(x: self.frame.width + bottomWall.frame.width, y: Ground.frame.height - 50)
        scoreNode.position = CGPoint(x: self.frame.width + topWall.frame.width, y: self.frame.height/2)
        
        topWall.setScale(0.4)
        bottomWall.setScale(0.4)
        
        topWall.zRotation = CGFloat(Double.pi)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.addChild(scoreNode)
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(in: -100 ..< 100)
        wallPair.position.y = wallPair.position.y + randomPosition
        //
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
    }
    
    func runWallSpawner() {
        let spawn = SKAction.run { self.createWalls()  }
        
        let delay = SKAction.wait(forDuration: 2.0)
        let spawnDelay = SKAction.sequence([spawn,delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        
        let distance = CGFloat(self.frame.width + wallPair.frame.width) * 2
        
        let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
        let removePipes = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([movePipes,removePipes])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted {
            if !gameOver {
                Bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 35))
            }
        } else {
            gameStarted = true
            scoreLabel.alpha = 1.0
            Bird.physicsBody?.affectedByGravity = true

            runWallSpawner()
            runGroundSpawner()
            Bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
        
        for touch in touches {
            let location = touch.location(in:  self)
            
            if gameOver && restartButton.contains(location) {
                restartScene()
            } else if gameOver && shareButton.contains(location) {
                shareScore()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        switch contact.state {
        case .levelUp:
            score += 1
            scoreLabel.text = "\(score)"
        case .gameOver:
            DefaultManager().saveHighScore(score)
            self.enumerateChildNodes(withName: "wallPair", using: stopGame)
            self.enumerateChildNodes(withName: "ground", using: stopGame)
        case .error: ()
        //TODO handle
        }
        
    }
    
    func stopGame(node:SKNode,error:UnsafeMutablePointer<ObjCBool>) {
        node.speed = 0
        self.removeAllActions()
        if !gameOver {
            self.gameOver = true
            gameOverSetupgameOverSetup()
        }
    }
}

extension SKPhysicsContact {
    var state : ContactState {
        let bodyA = self.bodyA
        let bodyB = self.bodyB
        
        let scoreBird = bodyA.categoryBitMask == PhysicsCategory.Score && bodyB.categoryBitMask == PhysicsCategory.Bird
        let birdScore = bodyA.categoryBitMask == PhysicsCategory.Bird && bodyB.categoryBitMask == PhysicsCategory.Score
        
        let birdWall = bodyA.categoryBitMask == PhysicsCategory.Bird && bodyB.categoryBitMask == PhysicsCategory.Wall
        let wallBird = bodyA.categoryBitMask == PhysicsCategory.Wall && bodyB.categoryBitMask == PhysicsCategory.Bird
        
        let birdGround = bodyA.categoryBitMask == PhysicsCategory.Bird && bodyB.categoryBitMask == PhysicsCategory.Ground
        let groundBird = bodyA.categoryBitMask == PhysicsCategory.Ground && bodyB.categoryBitMask == PhysicsCategory.Bird
        
        if scoreBird || birdScore { return .levelUp }
        if birdWall || wallBird || birdGround || groundBird { return .gameOver }
        
        return .error
    }
}

enum ContactState {
    case levelUp
    case gameOver
    case error
}

