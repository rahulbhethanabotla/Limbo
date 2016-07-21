//
//  GameScene.swift
//  Playing With Effects
//
//  Created by Rahul Bhethanabotla on 7/12/16.
//  Copyright (c) 2016 Rahul Bhethanabotla. All rights reserved.
//

import SpriteKit
import CoreGraphics
import UIKit

class GameScene: SKScene {
    
    let pi = M_PI
    
    var hero: SKSpriteNode!
    
    var background: SKSpriteNode!
    
    var square: SKSpriteNode!
    
    var light: SKLightNode!
    
    var blackSun: SKSpriteNode!
    
    var sunAtApex = false
    
    var start: CGPoint?
    
    var physicsTab: MSButtonNode!
    
    var radialGravityButton: MSToggleNode!
    
    var linearGravityButton: MSToggleNode!
    
    var velocityVectorButton: MSToggleNode!
    
    var physicsBar: SKSpriteNode!
    
    var startTime: NSTimeInterval?
    
    let kMinDistance = 10
    let kMinDuration = 0.1
    let kMinSpeed = 10
    let kMaxSpeed = 1000
    
    var nextVector: CGVector = CGVectorMake(1, 1)
    
    var wasPhysicsPressed: Bool = false
    
    var wasRadialPressed: Bool = false
    
    var wasLinearPressed: Bool = false
    
    var wasVelocityPressed: Bool = false
    
    var wasOptionsPressed: Bool = false
    
    var isOptionsDown: Bool = false
    
    var isDropDownDown: Bool = false
    
    var moveRightButton: MSButtonNode!
    
    var moveLeftButton: MSButtonNode!
    
    var optionsTab: MSButtonNode!
    
    var optionsBar: SKSpriteNode!
    
    var restartButton: MSButtonNode!
    
    var pauseButton: MSButtonNode!
    
    var gamePaused: Bool = false
    
    var storedVelocity: CGVector!
    
    override func didMoveToView(view: SKView) {
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        
        /* Setup the background image */
        background = self.childNodeWithName("background") as! SKSpriteNode
        background.size = self.size
        background.zPosition = -5
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        
        /* Setup the blackSun image and starting position */
        
        blackSun = self.childNodeWithName("blackSun") as! SKSpriteNode
        blackSun.position = CGPointMake(0, 0)
        blackSun.zPosition = -2
        
        
        /* Setup the background lighting/ambience */
        
        light = self.childNodeWithName("//light") as! SKLightNode
        light?.categoryBitMask = 1
        light?.falloff = 1
        
        
        /* Setup the physics button and children buttons */
        
        physicsTab = self.childNodeWithName("physicsTab") as! MSButtonNode
        physicsBar = physicsTab.childNodeWithName("physicsBar") as! SKSpriteNode
        physicsBar.hidden = false
        physicsTab.selectedHandler = {
            self.wasPhysicsPressed = !self.wasPhysicsPressed
            if (self.isDropDownDown) {
                let moveUp = SKAction.moveToY(-24.6, duration: 0)
                let hide = SKAction.hide()
                let sequence = SKAction.sequence([hide, moveUp ])
                
                self.physicsBar.runAction(sequence)
                self.isDropDownDown = false
            }
            else {
                let dropDown = SKAction.moveToY(-175, duration: 0)
                let unhide = SKAction.unhide()
                let sequence = SKAction.sequence([unhide, dropDown])
                
                self.physicsBar.runAction(sequence)
                self.isDropDownDown = true
            }
        }
        
        radialGravityButton = physicsBar.childNodeWithName("radialGravityButton") as! MSToggleNode
        radialGravityButton.selectedHandler = {
            
            if (!self.wasRadialPressed) {
                self.radialGravityButton.alpha = 0.4
            }
            else {
                self.radialGravityButton.state = .Active
            }
            self.wasRadialPressed = !self.wasRadialPressed
        }
        
        velocityVectorButton = physicsBar.childNodeWithName("velocityVectorButton") as! MSToggleNode
        velocityVectorButton.selectedHandler = {
            
            if (!self.wasVelocityPressed) {
                self.velocityVectorButton.alpha = 0.4
            }
            else {
                self.velocityVectorButton.state = .Active
            }
            print("click")
            self.wasVelocityPressed = !self.wasVelocityPressed
        }
        
        linearGravityButton = physicsBar.childNodeWithName("linearGravityButton") as! MSToggleNode
        linearGravityButton.selectedHandler = {
            
            if (!self.wasLinearPressed) {
                self.linearGravityButton.alpha = 0.4
                print("linear pressed")
            }
            else {
                self.linearGravityButton.state = .Active
                print("linear unpressed")
            }
            self.wasLinearPressed = !self.wasLinearPressed
        }
        
        
        
        moveRightButton = self.childNodeWithName("moveRightButton") as! MSButtonNode
        moveRightButton.selectedHandler = {
            if (self.hero.xScale < 0) {
                self.hero.xScale = -self.hero.xScale
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
            }
            self.hero.physicsBody?.applyImpulse(CGVectorMake(15, 0))
        }
        
        moveLeftButton = self.childNodeWithName("moveLeftButton") as! MSButtonNode
        moveLeftButton.selectedHandler = {
            if (self.hero.xScale > 0) {
                self.hero.xScale = -self.hero.xScale
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
            }
            self.hero.physicsBody?.applyImpulse(CGVectorMake(-15, 0))
        }
        
        optionsTab = self.childNodeWithName("optionsTab") as! MSButtonNode
        optionsBar = optionsTab.childNodeWithName("optionsBar") as! SKSpriteNode
        optionsTab.selectedHandler = {
            self.wasOptionsPressed = !self.wasOptionsPressed
            if (self.isOptionsDown) {
                let moveUp = SKAction.moveToY(-24.6, duration: 0)
                let hide = SKAction.hide()
                let sequence = SKAction.sequence([hide, moveUp ])
                
                self.optionsBar.runAction(sequence)
                self.isOptionsDown = false
            }
            else {
                let dropDown = SKAction.moveToY(-180, duration: 0)
                let unhide = SKAction.unhide()
                let sequence = SKAction.sequence([unhide, dropDown])
                
                self.optionsBar.runAction(sequence)
                self.isOptionsDown = true
            }
            
        }
        
        restartButton = optionsBar.childNodeWithName("restartButton") as! MSButtonNode
        restartButton.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
        pauseButton = optionsBar.childNodeWithName("pauseButton") as! MSButtonNode
        pauseButton.selectedHandler = {
            //(self.scene?.view?.paused = !(self.scene?.view?.paused)!)!
            //self.scene!.paused = !self.scene!.paused
            if (self.gamePaused) {
                self.hero.paused = !self.hero.paused
                self.hero.physicsBody?.velocity = self.storedVelocity
            }
            else {
                self.hero.paused = !self.hero.paused
                self.storedVelocity = self.hero.physicsBody?.velocity
                print(self.storedVelocity)
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
                print(self.storedVelocity)
                self.moveRightButton.paused = !self.moveRightButton.paused
                self.moveLeftButton.paused = !self.moveRightButton.paused
                
            }
            self.gamePaused = !self.gamePaused
        }
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (wasPhysicsPressed) {
            for touch in touches {
                let loc = touch.locationInNode(self)
            }
            
            /* Avoid multi-touch gestures (optional) */
            if touches.count > 1 {
                return
            }
            let touch: UITouch = touches.first!
            let location: CGPoint = touch.locationInNode(self)
            // Save start location and time
            start = location
            startTime = touch.timestamp
            if (wasRadialPressed) { createRadialGravityNode(location) }
            if (wasLinearPressed) { createLinearGravityNode(location) }
            
        }
        
        //
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (wasPhysicsPressed) {
            let touch: UITouch = touches.first!
            let location: CGPoint = touch.locationInNode(self)
            // Determine distance from the starting point
            var dx: CGFloat = location.x - start!.x
            var dy: CGFloat = location.y - start!.y
            let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
            if Int(magnitude) >= kMinDistance {
                // Determine time difference from start of the gesture
                let dt: CGFloat = CGFloat(touch.timestamp - startTime!)
                if Double(dt) > kMinDuration {
                    // Determine gesture speed in points/sec
                    let speed: CGFloat = magnitude / dt
                    if Int(speed) >= kMinSpeed && Int(speed) <= kMaxSpeed {
                        // Calculate normalized direction of the swipe
                        dx = dx / magnitude
                        dy = dy / magnitude
                        print("Swipe detected with speed = \(speed) and direction (\(dx), \(dy))")
                        nextVector = CGVectorMake(dx, dy)
                        if (wasVelocityPressed) { createVelocityFieldNode(start!) }
                        
                    }
                }
            }
            
        }
    }
    
    
    
    
    
    override func update(currentTime: CFTimeInterval) {
        if (gamePaused) { return }
        
        /* Called before each frame is rendered */
        if (abs(blackSun.position.y - 320) <= 0.1) {
            sunAtApex = true
        }
        
        if (sunAtApex == false){
            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y + (320/284))
            //print("x = \(blackSun.position.x)")
            //print("y = \(blackSun.position.y)")
        }
        else {
            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y - (320/284))
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func createRadialGravityNode(point: CGPoint) {
        let rGrav = SKFieldNode.radialGravityField()
        rGrav.enabled = true
        rGrav.position = point
        rGrav.strength = 0.5
        rGrav.falloff = 0.01
        rGrav.region = SKRegion(size: CGSizeMake(100,100))
        addChild(rGrav)
        let fieldRadius = SKSpriteNode(imageNamed: "Blue_Circle")
        addChild(fieldRadius)
        fieldRadius.zPosition = -2
        fieldRadius.position = point
        fieldRadius.size = CGSizeMake(300, 300)
        fieldRadius.color = UIColor(white: 1.0, alpha: 1.0)
        fieldRadius.alpha = 0.2
    }
    
    func createLinearGravityNode(point: CGPoint) {
        let gravityVector: vector_float3 = [0, -1, 0]
        let lGrav = SKFieldNode.linearGravityFieldWithVector(gravityVector)
        lGrav.enabled = true
        lGrav.position = point
        lGrav.strength = 1
        lGrav.falloff = 0.01
        addChild(lGrav)
        let fieldRadius = SKSpriteNode(imageNamed: "Blue_Circle")
        addChild(fieldRadius)
        fieldRadius.zPosition = -2
        fieldRadius.position = point
        fieldRadius.size = CGSizeMake(100, 100)
        fieldRadius.alpha = 0.2
        lGrav.region = SKRegion(radius: Float(fieldRadius.size.height))
    }
    
    func createVelocityFieldNode(point: CGPoint) {
        /* Create the actual physics field node */
        let velocityVector: vector_float3 = [Float(nextVector.dx * 0.3), Float(nextVector.dy * 0.3), 0]
        let vField = SKFieldNode.velocityFieldWithVector(velocityVector)
        vField.enabled = true
        vField.position = point
        let magnitude: CGFloat = sqrt(nextVector.dx * nextVector.dx + nextVector.dy  * nextVector.dy)
        vField.strength = 0.1 * Float(magnitude*30)
        vField.falloff = 6
        //vField.region = SKRegion(size: frame.size)
        addChild(vField)
        
        /* Create the arrow that signifies the direction and magnitude of the force */
        let velocityArrow = SKSpriteNode(imageNamed: "VelocityArrow")
        var theta = atan2f(Float(nextVector.dy), Float(nextVector.dx))
        //        if (nextVector.dx < 0 && nextVector.dy > 0) {
        //            theta = theta + Float(pi)
        //        }
        //        if (nextVector.dx < 0 && nextVector.dy < 0) {
        //            theta = theta - Float(pi)
        //        }
        print(theta)
        let rotate = SKAction.rotateToAngle(CGFloat(theta) + CGFloat(pi*0.05), duration: 0.0)
        
        addChild(velocityArrow)
        velocityArrow.zPosition = -2
        velocityArrow.position = point
        velocityArrow.size = CGSizeMake(50, 50)
        velocityArrow.alpha = 0.2
        velocityArrow.runAction(rotate)
        vField.region = SKRegion(radius: Float(velocityArrow.size.height))
    }
}
