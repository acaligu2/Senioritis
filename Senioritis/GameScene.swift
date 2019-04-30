//
//  GameScene.swift
//  Senioritis
//
//  Created by Anthony on 4/20/19.
//  Copyright © 2019 Caligure. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var frequency = 15
    
    var gameOver = false
    
    let player = SKSpriteNode(imageNamed: "character")
    
    let enemies = [
    
        SKSpriteNode(imageNamed: "eileen"),
        SKSpriteNode(imageNamed: "lander"),
        SKSpriteNode(imageNamed: "bartenstein"),
        SKSpriteNode(imageNamed: "dmitry"),
        SKSpriteNode(imageNamed: "madden")
    
    ]

    
    let jumpSound = SKAction.playSoundFileNamed("jumpS.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.setScale(0.1)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        
        self.addChild(background)
        
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width * 0.45, y: self.size.height * 0.175)
        player.zPosition = 2
        
        self.addChild(player)        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
        
            if player.contains(touch.location(in: self)){
                
                self.run(jumpSound)
                
                let jumpUp = SKAction.move(to: CGPoint(x: self.size.width * 0.45, y: self.size.height * 0.5), duration: 0.5)
                
                let down = SKAction.move(to: CGPoint(x: self.size.width * 0.45, y: self.size.height * 0.175), duration: 0.5)
                
                let jumpSequence = SKAction.sequence([jumpUp, down])
                player.run(jumpSequence)
                
            }
        
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {

        
    }

}
