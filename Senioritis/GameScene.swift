//
//  GameScene.swift
//  Senioritis
//
//  Created by Anthony on 4/20/19.
//  Copyright © 2019 Caligure. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Physics {
    
    static let Enemy : UInt32 = 1
    static let Character : UInt32 = 2
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let names = ["eileen.png", "lander.png", "bartenstein.png", "dmitry.png", "madden.png"]
    
    var gameOver = false
    
    let player = SKSpriteNode(imageNamed: "character")

    
    let jumpSound = SKAction.playSoundFileNamed("jumpS.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        NSLog("IS this thing on")
        
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.setScale(0.1)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -1
        
        self.addChild(background)
        
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width * 0.45, y: self.size.height * 0.175)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = Physics.Character
        player.physicsBody?.contactTestBitMask = Physics.Enemy
        player.physicsBody?.isDynamic = false
        player.physicsBody?.collisionBitMask = 0
        
        self.addChild(player)
        
        var enemyTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(spawnEnemies), userInfo: nil, repeats: true)
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        NSLog("Contact")
        
        if(contact.bodyA != nil && contact.bodyB != nil){
        
            var firstBody : SKPhysicsBody = contact.bodyA
            var secondBody : SKPhysicsBody = contact.bodyB
            
            if(((firstBody.categoryBitMask == Physics.Character) && (secondBody.categoryBitMask == Physics.Enemy)) || ((firstBody.categoryBitMask == Physics.Enemy) && (secondBody.categoryBitMask == Physics.Character))){
                
                collisionDetected(Enemy: firstBody.node as! SKSpriteNode, Character: secondBody.node as! SKSpriteNode)
                
            }
            
        }
        
    }
    
    func collisionDetected(Enemy: SKSpriteNode, Character: SKSpriteNode){
    
        Enemy.removeFromParent()
    
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

    @objc func spawnEnemies(){
        
        var name = names.randomElement()!
        var enemy = SKSpriteNode(imageNamed: name)
        
        enemy.position = CGPoint(x: self.size.width + 50, y: self.size.height * 0.175)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.categoryBitMask = Physics.Enemy
        enemy.physicsBody?.contactTestBitMask = Physics.Character
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.collisionBitMask = 0
        
        let action = SKAction.moveTo(x: -50, duration: 3)
        let actionDone = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([action, actionDone]))
        
        self.addChild(enemy)
        
    }
    
}
