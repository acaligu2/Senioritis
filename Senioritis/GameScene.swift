//
//  GameScene.swift
//  Senioritis
//
//  Created by Anthony on 4/20/19.
//  Copyright © 2019 Caligure. All rights reserved.
//

/*
 
 TODO:
 
    1.) Vary start location of enemies
 
    2.) Random selection of movement
 
    3.) Implement projectiles
 
 
 */

import SpriteKit
import GameplayKit

struct Physics {
    
    static let Enemy : UInt32 = 1
    static let Character : UInt32 = 2
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var finishedGame = false
    var started = false
    
    var month = "January"
    var day = 22
    
    var misses = 0
    
    var enemyTimer : Timer?
    
    lazy var scoreLabel: SKLabelNode = {
        
        var label = SKLabelNode()
        label.fontSize = 65.0
        label.fontName = "AppleSDGothicNeo-Bold"
        label.zPosition = 3
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontColor = SKColor.black
        label.text = "Senioritis"
        return label
        
    }()
    
    lazy var missesLabel: SKLabelNode = {
        
        var label = SKLabelNode()
        label.fontSize = 65.0
        label.fontName = "AppleSDGothicNeo-Bold"
        label.zPosition = 3
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontColor = SKColor.red
        label.text = ""
        return label
        
    }()
    
    let names = ["eileen.png", "lander.png", "bartenstein.png", "dmitry.png", "madden.png"]
    
    var gameOver = false
    
    let player = SKSpriteNode(imageNamed: "character")

    
    let jumpSound = SKAction.playSoundFileNamed("jumpS.wav", waitForCompletion: false)
    
    let damageSound = SKAction.playSoundFileNamed("damage.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.9)
        
        missesLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.80)
        
        self.addChild(scoreLabel)
        self.addChild(missesLabel)
        
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.setScale(0.1)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -1
        
        self.addChild(background)
        
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width * 0.45, y: self.size.height * 0.175)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 8.0, height: 8.0))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = Physics.Character
        player.physicsBody?.contactTestBitMask = Physics.Enemy
        player.physicsBody?.isDynamic = true
        player.physicsBody?.collisionBitMask = 0
        
        self.addChild(player)
        
        
    }
    
    func startTimer(){
        
        started = true
        
        enemyTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(spawnEnemies), userInfo: nil, repeats: true)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        NSLog("Contact")
        
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if(((firstBody.categoryBitMask == Physics.Character) && (secondBody.categoryBitMask == Physics.Enemy)) || ((firstBody.categoryBitMask == Physics.Enemy) && (secondBody.categoryBitMask == Physics.Character))){
            
            collisionDetected(Enemy: firstBody.node as! SKSpriteNode, Character: secondBody.node as! SKSpriteNode)
            
        }
        
    }
    
    func collisionDetected(Enemy: SKSpriteNode, Character: SKSpriteNode){
    
        self.run(damageSound)
        
        misses += 1
            
        missesLabel.text?.append(" X ")
            
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            if(gameOver){
                
                let reset = GameScene(size: self.size)
                reset.scaleMode = self.scaleMode
                
                let animation = SKTransition.fade(withDuration: 7.5)
                self.view?.presentScene(reset, transition: animation)
                
            }
            
            if (touch == touches.first && !started) {
                
                scoreLabel.text = "\(month) \(day)"
                startTimer()
                
            }
        
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
        
        if(finishedGame){
            
            NSLog("We made it")
            
        }
        
        if(misses == 3){
            
            gameOver = true
            scoreLabel.text = "GAME OVER"
            
            missesLabel.fontColor = SKColor.black
            missesLabel.text = "YOU SURVIVED UNTIL \(month) \(day)"
            enemyTimer?.invalidate()
            
        }

        
    }

    @objc func spawnEnemies(){
        
        let name = names.randomElement()!
        let enemy = SKSpriteNode(imageNamed: name)
        
        enemy.position = CGPoint(x: self.size.width + 50, y: self.size.height * 0.175)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 8.0, height: 8.0))
        enemy.physicsBody?.categoryBitMask = Physics.Enemy
        enemy.physicsBody?.contactTestBitMask = Physics.Character
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.collisionBitMask = 0
        
        let action = SKAction.moveTo(x: -50, duration: 3)
        
        let jumpUp = SKAction.moveTo(y: self.size.height * 0.5, duration: 0.5)
        
        let down = SKAction.moveTo(y: self.size.height * 0.175, duration: 0.5)
        
        let jumpSequence = SKAction.repeatForever(SKAction.sequence([jumpUp, down]))
        
        let group = SKAction.group([action, jumpSequence])
        
        let actionDone = SKAction.removeFromParent()
        
        let increment = SKAction.run {
            self.day += 1
            
            if(self.day == 32 && self.month == "January"){
                
                self.month = "February"
                self.day = 1
                
            }
            
            if(self.day == 29 && self.month == "February"){
                
                self.month = "March"
                self.day = 1
                
            }
            
            if(self.day == 32 && self.month == "March"){
                
                self.month = "April"
                self.day = 1
                
            }
            
            if(self.day == 31 && self.month == "April"){
                
                self.month = "May"
                self.day = 1
                
            }
            
            if(self.day == 10 && self.month == "May"){
                
                self.finishedGame = true
                
            }
            
            self.scoreLabel.text = "\(self.month) \(self.day)"
            
        }
        
        enemy.run(SKAction.sequence([group, actionDone,increment]))
        
        self.addChild(enemy)
    
        
    }
    
}
