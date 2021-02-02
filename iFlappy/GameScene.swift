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
    override func didMove(to view: SKView) {
        createGround()
        createBird()
        createWalls()
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
        
        /// Add Ground to Scene
        self.addChild(Ground)
    }
    
    func createBird() {
        Bird = SKSpriteNode(imageNamed: "bird")
        
        /// Set Bird size and position
        Bird.size = CGSize(width: 60, height: 70)
        Bird.position = CGPoint(x: self.frame.width/2 - Bird.frame.width, y: self.frame.height/2)
        
        /// Add Bird to Scene
        self.addChild(Bird)
    }
    
    func createWalls() {
       let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 400)
        bottomWall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 300)
        
        topWall.setScale(0.4)
        bottomWall.setScale(0.4)
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        self.addChild(wallPair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
