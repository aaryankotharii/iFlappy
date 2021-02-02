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
        
    override func didMove(to view: SKView) {
        /// Create Ground
        Ground = SKSpriteNode(imageNamed: "ground")
        Ground.setScale(0.5)
        
        /// Set Ground position
        let halfGroundHeight = Ground.frame.height / 2
        Ground.position = CGPoint(x: Ground.frame.width/2, y: halfGroundHeight)
        
        /// Add Ground to Scene
        self.addChild(Ground)
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
