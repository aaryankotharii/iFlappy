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

    var wallPair = SKNode()

    var moveAndRemove = SKAction()
    
    var gameStarted : Bool = false
    
    var score : Int = 0
    
    override func didMove(to view: SKView) {
        createGround()
        createBird()
        createWalls()
        self.physicsWorld.contactDelegate = self
    }
    
    func createGround() {
        
        /// Create Ground
        Ground = SKSpriteNode(imageNamed: "ground")
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
        
        /// Add Ground to Scene
        self.addChild(Ground)
    }
    
    func createBird() {
        Bird = SKSpriteNode(imageNamed: "bird")
        
        /// Set Bird size and position
        Bird.size = CGSize(width: 60, height: 70)
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
        scoreNode.color = .blue
        
        wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width + topWall.frame.width, y: self.frame.height/2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width + bottomWall.frame.width, y: self.frame.height/2 - 350)
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
        
        let randomPosition = CGFloat.random(in: -200 ..< 200)
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
        
        let distance = CGFloat(self.frame.width + wallPair.frame.width) //FIXME: increase distance
        let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
        let removePipes = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([movePipes,removePipes])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if gameStarted {
            Bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
        } else {
            gameStarted = true
            Bird.physicsBody?.affectedByGravity = true
            runWallSpawner()
            Bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
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
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let firstCase = bodyA.categoryBitMask == PhysicsCategory.Score && bodyB.categoryBitMask == PhysicsCategory.Bird
        let secondCase = bodyA.categoryBitMask == PhysicsCategory.Bird && bodyB.categoryBitMask == PhysicsCategory.Score
        
        if firstCase || secondCase  {
            score += 1
            print("SCORE: ",score)
        }
        
    }
}
