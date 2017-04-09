//
//  GameScene.swift
//  HoppyBunny
//
//  Created by Martin Walsh on 08/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum GameSceneState {
    case active, gameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* Scene connections */
    var hero: SKSpriteNode!
    var scrollLayer: SKNode!
    var obstacleLayer: SKNode!
    
    /* UI Connections */
    var finalImage: MSButtonNode!
    var questionOne: MSButtonNode!
    var questionTwo: MSButtonNode!
    var questionThree: MSButtonNode!
    var scoreLabel: SKLabelNode!
    
    /* Timers */
    var sinceTouch: CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    
    /* Game constants */
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 160
    
    /* Game management */
    var gameState: GameSceneState = .active
    var points = 3
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        
        /* Recursive node search for 'hero' (child of referenced node) */
        hero = self.childNode(withName: "//hero") as! SKSpriteNode
        
        /* Set reference to scroll layer node */
        scrollLayer = self.childNode(withName: "scrollLayer")
        
        /* Set reference to obstacle layer node */
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        
        /* Set UI connections */
        finalImage = self.childNode(withName: "finalImage") as! MSButtonNode
        questionOne = self.childNode(withName: "questionOne") as! MSButtonNode
        questionTwo = self.childNode(withName: "questionTwo") as! MSButtonNode
        questionThree = self.childNode(withName: "questionThree") as! MSButtonNode
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
        /* Setup final image selection handler */
        finalImage.selectedHandler = {
            [unowned self] in
            
            
            self.finalImage.state = .hidden
        }
        
        /*Setup questionOne selection handler*/
        questionOne.selectedHandler = {
            [unowned self] in
            
            self.questionOne.state = .hidden
        }

        
        /*Setup questionTwo selection handler*/
        questionTwo.selectedHandler = {
            [unowned self] in
            
            self.questionTwo.state = .hidden
            //answerTwoa.state = .active
            //answerTwob.state = .active
            //answerTwoc.state = .active
            
        }

        
      /*Setup questionThree selection handler*/
        questionThree.selectedHandler = {
            [unowned self] in
            
            self.questionThree.state = .hidden
            //answerThreeOne.state = .hidden
            //answerThreeTwo.state = .hidden
            //answerThreeThree.state = .hidden
            
        }

        
        /* Hide final Image and questions*/
        finalImage.state = .hidden
        questionOne.state = .hidden
        questionTwo.state = .hidden
        questionThree.state = .hidden
        
    
        
        /* Reset Score label */
        scoreLabel.text = String(points)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        /* Disable touch if game state is not active */
        if gameState != .active { return }
        
        /* Play SFX */
        let flapSFX = SKAction.playSoundFileNamed("sfx_flap", waitForCompletion: false)
        self.run(flapSFX)
        
        /* Reset velocity, helps improve response against cumulative falling velocity */
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        /* Apply vertical impulse */
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
        
        /* Apply subtle rotation */
        hero.physicsBody?.applyAngularImpulse(1)
        
        /* Reset touch timer */
        sinceTouch = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        /* Skip game update if game no longer active */
        if gameState != .active { return }
        
        /* Grab current velocity */
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        /* Check and cap vertical velocity */
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        /* Apply falling rotation */
        if sinceTouch > 0.1 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        /* Clamp rotation */
        hero.zRotation = hero.zRotation.clamped(CGFloat(-100).degreesToRadians(), CGFloat(-10).degreesToRadians())
        hero.physicsBody!.angularVelocity = hero.physicsBody!.angularVelocity.clamped(-2, 2)
        
        /* Process world scrolling */
        scrollWorld()
        
        /* Process obstacles */
        updateObstacles()
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        spawnTimer+=fixedDelta
    }
    
    func scrollWorld() {
        /* Scroll World */
        
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint( x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through obstacle layer nodes */
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            
            /* Check if obstacle has left the scene */
            if obstaclePosition.x <= 0 {
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
            }
            
        }
        
        /* Time to add a new obstacle? */
        if spawnTimer >= 1.5 {
            
            /* Create a new obstacle reference object using our obstacle resource */
            let resourcePath = Bundle.main.path(forResource: "Obstacle", ofType: "sks")
            let newObstacle = SKReferenceNode(url: URL (fileURLWithPath: resourcePath!))
            obstacleLayer.addChild(newObstacle)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: 352, y: 220)
            
            /* Convert new node position back to obstacle layer space */
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            // Reset spawn timer
            spawnTimer = 0
        }
    }
    
    // MARK: - Physics handling
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Ensure only called while game running */
        if gameState != .active { return }
        
        /* Hero touches anything, game over */
        
        /* Get references to bodies involved in collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        /* Did our hero pass through the 'goal'? */
        if nodeA.name == "goal" || nodeB.name == "goal" {
            
            /* We can return now */
            return
        }
        
        /*collision*/
        
        /* Increment points */
        points -= 1
        
        /* Update score label */
        scoreLabel.text = String(points)
      
        //INSERT counter for answers
        
        /* If 1st house hit */
        if points == 2 {
            /* Show question one */
            questionOne.state = .active
            answerOnea.state = .active
            answerOneb.state = .active
            answerOnec.state = .active
        }
        
        if points == 1 {
            /* Show question two */
            questionTwo.state = .active
        }
        
        /* If 3rd house hit */
        if points == 0 {
            
            /* Show question three */
            questionThree.state = .active
            
            
            /* Change game state to game over */
            gameState = .gameOver
            
            /* Stop any new angular velocity being applied */
            hero.physicsBody?.allowsRotation = false
            
            /* Reset angular velocity */
            hero.physicsBody?.angularVelocity = 0
            
            /* Stop hero flapping animation */
            hero.removeAllActions()
            
            /* Create our hero death action */
            let heroDeath = SKAction.run({
                
                /* Put our hero face down in the dirt */
                self.hero.zRotation = CGFloat(-90).degreesToRadians()
                /* Stop hero from colliding with anything else */
                self.hero.physicsBody?.collisionBitMask = 0
            })
            
            /* Run action */
            hero.run(heroDeath)
            
            
            
            
            /* Show final Image */
            finalImage.state = .active
        }
       
        

        

        

        
        

    }
}
