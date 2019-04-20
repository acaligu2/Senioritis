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
    
    let player = SKSpriteNode(imageNamed: "mainCharacterStandard")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.setScale(0.1)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        
        self.addChild(background)
        
        
        player.setScale(5)
        player.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.175)
        player.zPosition = 2
        
        self.addChild(player)
        
        
    }

}
