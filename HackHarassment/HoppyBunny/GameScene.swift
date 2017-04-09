//
//  GameScene.swift
//  HoppyBunny
//
//  Created by us on 08/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum GameSceneState {
    case active, gamePause
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* Scene connections */
    var hero: SKSpriteNode!
    var scrollLayer: SKNode!
    var obstacleLayer: SKNode!
    
    /* UI Connections */
    var questionOne: MSButtonNode!
    var answer1a: MSButtonNode!
    var answer1b: MSButtonNode!
    var answer1c: MSButtonNode!
    var questionTwo: MSButtonNode!
    var answer2a: MSButtonNode!
    var answer2b: MSButtonNode!
    var answer2c: MSButtonNode!
    var questionThree: MSButtonNode!
    var answer3a: MSButtonNode!
    var answer3b: MSButtonNode!
    var answer3c: MSButtonNode!
    var finalMinimal: MSButtonNode!
    var finalModerate: MSButtonNode!
    var finalHigh: MSButtonNode!
    var feedbackMinimal: MSButtonNode!
    var feedbackModerate: MSButtonNode!
    var feedbackHigh: MSButtonNode!
    var finalScreen: MSButtonNode!
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
    var countHigh = 0
    var countModerate = 0
    var countMinimal = 0
    var isHit = false
    
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
        questionOne = self.childNode(withName: "questionOne") as! MSButtonNode
        answer1a = self.childNode(withName: "answer1a") as! MSButtonNode
        answer1b = self.childNode(withName: "answer1b") as! MSButtonNode
        answer1c = self.childNode(withName: "answer1c") as! MSButtonNode
        questionTwo = self.childNode(withName: "questionTwo") as! MSButtonNode
        answer2a = self.childNode(withName: "answer2a") as! MSButtonNode
        answer2b = self.childNode(withName: "answer2b") as! MSButtonNode
        answer2c = self.childNode(withName: "answer2c") as! MSButtonNode
        questionThree = self.childNode(withName: "questionThree") as! MSButtonNode
        answer3a = self.childNode(withName: "answer3a") as! MSButtonNode
        answer3b = self.childNode(withName: "answer3b") as! MSButtonNode
        answer3c = self.childNode(withName: "answer3c") as! MSButtonNode
        finalHigh = self.childNode(withName: "finalHigh") as! MSButtonNode
        finalModerate = self.childNode(withName: "finalModerate") as! MSButtonNode
        finalMinimal = self.childNode(withName: "finalMinimal") as! MSButtonNode
        feedbackHigh = self.childNode(withName: "feedbackHigh") as! MSButtonNode
        feedbackModerate = self.childNode(withName: "feedbackModerate") as! MSButtonNode
        feedbackMinimal = self.childNode(withName: "feedbackMinimal") as! MSButtonNode
        finalScreen = self.childNode(withName: "finalScreen") as! MSButtonNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
        /* Setup final score selection handler */
        finalHigh.selectedHandler = {
            [unowned self] in
            
            self.finalHigh.state = .hidden
            self.feedbackHigh.state = .partial
        }
        finalModerate.selectedHandler = {
            [unowned self] in
            
            self.finalModerate.state = .hidden
            self.feedbackModerate.state = .partial
        }
        finalMinimal.selectedHandler = {
            [unowned self] in
            
            self.finalMinimal.state = .hidden
            self.feedbackMinimal.state = .partial
        }
        
        /* Setup final feedback selection handler */
        feedbackHigh.selectedHandler = {
            [unowned self] in
            
            self.feedbackHigh.state = .hidden
            self.finalScreen.state = .disabled
        }
        feedbackModerate.selectedHandler = {
            [unowned self] in
            
            self.feedbackModerate.state = .hidden
            self.finalScreen.state = .disabled
        }
        feedbackMinimal.selectedHandler = {
            [unowned self] in
            
            self.feedbackMinimal.state = .hidden
            self.finalScreen.state = .disabled
        }

        
        /*Setup answer1a selection handler*/
        answer1a.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countHigh += 1
            self.questionOne.state = .hidden
            self.answer1a.state = .hidden
            self.answer1b.state = .hidden
            self.answer1c.state = .hidden
            self.gameState = .active
        }
        /*Setup answer1b selection handler*/
        answer1b.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countModerate += 1
            self.questionOne.state = .hidden
            self.answer1a.state = .hidden
            self.answer1b.state = .hidden
            self.answer1c.state = .hidden
            self.gameState = .active
        }
        /*Setup answer1c selection handler*/
        answer1c.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countMinimal += 1
            self.questionOne.state = .hidden
            self.answer1a.state = .hidden
            self.answer1b.state = .hidden
            self.answer1c.state = .hidden
            self.gameState = .active
        }
        
        
        /*Setup answer2a selection handler*/
        answer2a.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countHigh += 1
            self.questionTwo.state = .hidden
            self.answer2a.state = .hidden
            self.answer2b.state = .hidden
            self.answer2c.state = .hidden
            self.gameState = .active
        }
        /*Setup answer2b selection handler*/
        answer2b.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countModerate += 1
            self.questionTwo.state = .hidden
            self.answer2a.state = .hidden
            self.answer2b.state = .hidden
            self.answer2c.state = .hidden
            self.gameState = .active
        }
        /*Setup answer2c selection handler*/
        answer2c.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countMinimal += 1
            self.questionTwo.state = .hidden
            self.answer2a.state = .hidden
            self.answer2b.state = .hidden
            self.answer2c.state = .hidden
            self.gameState = .active
        }
        
        
        /*Setup answer3a selection handler*/
        answer3a.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countHigh += 1
            self.questionThree.state = .hidden
            self.answer3a.state = .hidden
            self.answer3b.state = .hidden
            self.answer3c.state = .hidden
            self.gameState = .active
            
            /* Show final Image */
            if self.countHigh > self.countModerate && self.countHigh > self.countMinimal{
                self.finalHigh.state = .partial
            }else
                if self.countMinimal > self.countHigh && self.countMinimal > self.countModerate{
                    self.finalMinimal.state = .partial
                }else{
                    self.finalModerate.state = .partial
            }
        }
        /*Setup answer3b selection handler*/
        answer3b.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countModerate += 1
            self.questionThree.state = .hidden
            self.answer3a.state = .hidden
            self.answer3b.state = .hidden
            self.answer3c.state = .hidden
            self.gameState = .active
            
            /* Show final Image */
            if self.countHigh > self.countModerate && self.countHigh > self.countMinimal{
                self.finalHigh.state = .partial
            }else
                if self.countMinimal > self.countHigh && self.countMinimal > self.countModerate{
                    self.finalMinimal.state = .partial
                }else{
                    self.finalModerate.state = .partial
            }

            
        }
        /*Setup answer3c selection handler*/
        answer3c.selectedHandler = {
            [unowned self] in
            
            /* Play SFX */
            let answerSFX = SKAction.playSoundFileNamed("sfx_goal", waitForCompletion: false)
            self.run(answerSFX)
            
            self.countMinimal += 1
            self.questionThree.state = .hidden
            self.answer3a.state = .hidden
            self.answer3b.state = .hidden
            self.answer3c.state = .hidden
            self.gameState = .active
            
            /* Show final Image */
            if self.countHigh > self.countModerate && self.countHigh > self.countMinimal{
                self.finalHigh.state = .partial
            }else
                if self.countMinimal > self.countHigh && self.countMinimal > self.countModerate{
                    self.finalMinimal.state = .partial
                }else{
                    self.finalModerate.state = .partial
            }

        }
        
        
        /* Hide all buttons*/
        questionOne.state = .hidden
        answer1a.state = .hidden
        answer1b.state = .hidden
        answer1c.state = .hidden
        questionTwo.state = .hidden
        answer2a.state = .hidden
        answer2b.state = .hidden
        answer2c.state = .hidden
        questionThree.state = .hidden
        answer3a.state = .hidden
        answer3b.state = .hidden
        answer3c.state = .hidden
        finalHigh.state = .hidden
        finalModerate.state = .hidden
        finalMinimal.state = .hidden
        feedbackHigh.state = .hidden
        feedbackModerate.state = .hidden
        feedbackMinimal.state = .hidden
        finalScreen.state = .hidden
        
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
        hero.zRotation = hero.zRotation.clamped(CGFloat(-45).degreesToRadians(), CGFloat(-10).degreesToRadians())
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
            
            
            /* Check if obstacle has left the scene or obstacle has been hit */
            if obstaclePosition.x <= 0 || isHit {
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
                isHit = false
            }
            
        }
        
        /* Time to add a new obstacle? */
        if spawnTimer >= 1 {
            
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
        isHit = true
        
        /* Update score label */
        scoreLabel.text = String(points)
        
        //INSERT counter for answers
        
        /* If 1st house hit */
        if points == 2 {
            gameState = .gamePause
            
            /* Show question one */
            questionOne.state = .active
            answer1a.state = .active
            answer1b.state = .active
            answer1c.state = .active
        }
        
        if points == 1 {
            gameState = .gamePause
            
            /* Show question two */
            questionTwo.state = .active
            answer2a.state = .active
            answer2b.state = .active
            answer2c.state = .active
        }
        
        /* If 3rd house hit */
        if points == 0 {
            gameState = .gamePause
            
            /* Show question three */
            questionThree.state = .active
            answer3a.state = .active
            answer3b.state = .active
            answer3c.state = .active
            
            
            /* Change game state to game paused */
            gameState = .gamePause
            
            scoreLabel.removeFromParent()
        
        }
        
        
        
        
        
        
        
        
        
    }
}
