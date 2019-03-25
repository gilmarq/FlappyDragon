//
//  GameScene.swift
//  FlappyDrangon
//
//  Created by Gilmar on 21/03/2019.
//  Copyright © 2019 Gilmar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
  
    var floor : SKSpriteNode!
    var gameArea: CGFloat = 410.0
    var intro : SKSpriteNode!
    var player : SKSpriteNode!
    var velocity : Double = 100.0
    var gameFinshed = false
    var gameStarted = false
    var restart = false
    var scoreLabel :SKLabelNode!
    var score : Int = 0
    var flyForce: CGFloat = 400.0  //30.0
    //sempre fazer elevado a potência de 2
    var playerCategory: UInt32 = 1
    var enemyCategoty: UInt32 = 2
    var  scoreCategory: UInt32 = 4
    var timer: Timer!
    weak var gameViwController: GameViewController?
    var scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    

    override func didMove(to view: SKView) {
        
      physicsWorld.contactDelegate = self
        
       addBackground()
       addFloor()
       addIntro()
       addPlayer()
       moveFloor()
       //gameOver()
        
      
    }
    func addPlayer(){
         player = SKSpriteNode(imageNamed: "player1")
         player.zPosition = 4
         player.position = CGPoint(x: 60, y: size.height - gameArea/2)
         addChild(player)
        
        var playerTextures = [SKTexture]()
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let animationAction = SKAction.animate(with:playerTextures, timePerFrame: 0.09)
        let repeatAction  = SKAction.repeatForever(animationAction)
        player.run(repeatAction)
    }
    func addIntro(){
        intro = SKSpriteNode(imageNamed: "intro")
        addChild(intro)
        intro.zPosition = 3
        intro.position = CGPoint(x:size.width/2, y: size.height - 210)
        
    }
    
    func addFloor(){
         floor = SKSpriteNode(imageNamed: "floor")
        addChild(floor)
        floor.zPosition = 2
        floor.position = CGPoint(x: floor.size.width/2, y: size.height - gameArea - floor.size.height/2)
        
        let invisibleFloor = SKNode()
        invisibleFloor.physicsBody  = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategoty
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        
        invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea)
        invisibleFloor.zPosition = 2
        
         addChild(invisibleFloor)
        
        
        let invisibleRoof = SKNode()
        invisibleRoof.physicsBody  = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleRoof.physicsBody?.isDynamic = false
        invisibleRoof.position = CGPoint(x: size.width/2, y: size.height)
        invisibleRoof.zPosition = 2
        addChild(invisibleRoof)
        
    }
    func addBackground(){
        let background = SKSpriteNode(imageNamed:"background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
        
    }
    func  moveFloor(){
        let duration = Double(floor.size.width/2)/velocity
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        let sequenceAction = SKAction.sequence([moveFloorAction,resetXAction])
        let repeatAction  = SKAction.repeatForever(sequenceAction)
        
        floor.run(repeatAction)
    }
    func addScore(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 97
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        scoreLabel.alpha = 0.8
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 100 )
        addChild(scoreLabel)
        
    }
    
    func spawnEnemies(){
        let initalPosition = CGFloat(arc4random_uniform(132) + 74)
        let enemyNumber = Int(arc4random_uniform(4) + 1)
        let enemiesDistance = self.player.size.height * 2.5
        
         let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemyNumber)")
         let  enemyWidth = enemyTop.size.width
         let enemyHeigth =  enemyTop.size.height
        
         enemyTop.position = CGPoint(x: size.width + enemyWidth/2 , y: size.height - initalPosition + enemyHeigth/2)
         enemyTop.zPosition = 1
         enemyTop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyWidth, height: enemyHeigth))
         enemyTop.physicsBody?.isDynamic = false
         enemyTop.physicsBody?.categoryBitMask = enemyCategoty
         enemyTop.physicsBody?.contactTestBitMask = playerCategory
        
        
        
          let enemyButtom = SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)")
          
          enemyButtom.position = CGPoint(x: size.width + enemyWidth/2 , y: enemyTop.position.y - enemyTop.size.height - enemiesDistance )
         enemyButtom.zPosition = 1
         enemyButtom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyWidth, height: enemyHeigth))
         enemyButtom.physicsBody?.isDynamic = false
         enemyButtom.physicsBody?.categoryBitMask = enemyCategoty
         enemyButtom.physicsBody?.contactTestBitMask = playerCategory
        
         let distance  = size.width + enemyWidth
         let duration =  Double(distance)/velocity
         let moviAction =  SKAction.moveBy(x: -distance, y: 0, duration: duration)
         let removeActyion = SKAction.removeFromParent()
         let sequenceAction = SKAction.sequence([moviAction ,removeActyion])
        
        let layser  = SKNode()
        layser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2, y: enemyTop.position.y  - enemyTop.size.height/2  - enemiesDistance/2)
        layser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemiesDistance))
        layser.physicsBody?.isDynamic = false
        layser.physicsBody?.categoryBitMask = scoreCategory
        
         layser.run(sequenceAction)
         enemyTop.run(sequenceAction)
         enemyButtom.run(sequenceAction)
        
         addChild(enemyTop)
         addChild(enemyButtom)
         addChild(layser)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameFinshed{
            if !gameStarted{
                 intro.removeFromParent()
                addScore()
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyForce(CGVector( dx: 0, dy: flyForce))
                player.physicsBody?.categoryBitMask = playerCategory
                player.physicsBody?.contactTestBitMask = scoreCategory
                player.physicsBody?.collisionBitMask = enemyCategoty
                
                
                gameStarted = true
                
                timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (timer) in
                   self.spawnEnemies()
                }
                
                
            }else {
                player.physicsBody?.velocity = CGVector.zero
                 player.physicsBody?.applyForce(CGVector( dx: 0, dy: flyForce))
            }
        }else {
            if restart  {
                    restart = false
                gameViwController?.presentScene()
            }
        }
        
    }
    
    func gameOver(){
        print("Se Fudeu")
        timer.invalidate()
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "playerDead")
        for node in self.children{
            node.removeAllActions()
        }
        player.physicsBody?.isDynamic = false
        gameFinshed = true
        gameStarted =  false
        
        Timer.scheduledTimer(withTimeInterval: 2.0 , repeats: false) { (timer) in
            let gameOverLabel  = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 50
            gameOverLabel.text  = "SE FUDEU"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            self.addChild(gameOverLabel)
            self.restart =  true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if  gameStarted {
            let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat
            player.zRotation = yVelocity
            
        }
    }
}

extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted{
            if  contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory{
                score += 1
                scoreLabel.text = "\(score)"
                run(scoreSound  )
            }else if contact.bodyA.categoryBitMask == enemyCategoty || contact.bodyB.categoryBitMask == enemyCategoty{
                gameOver()
                run(gameOverSound)
                
        }
    }
}
}
