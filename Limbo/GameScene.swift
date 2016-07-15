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
    
    var background: SKSpriteNode!
    
    var square: SKSpriteNode!
    
    var light: SKLightNode!
    
    var blackSun: SKSpriteNode!
    
    var sunAtApex = false
    
    var start: CGPoint?
    
    var startTime: NSTimeInterval?
    
    let kMinDistance = 25
    let kMinDuration = 0.1
    let kMinSpeed = 10
    let kMaxSpeed = 1000
    
    var nextVector: CGVector = CGVectorMake(1, 1)
    
    
    override func didMoveToView(view: SKView) {
        background = self.childNodeWithName("background") as! SKSpriteNode
        background.size = self.size
        background.zPosition = -5
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        
        
        blackSun = self.childNodeWithName("blackSun") as! SKSpriteNode
        blackSun.position = CGPointMake(0, 0)
        blackSun.zPosition = 3
        
        light = self.childNodeWithName("//light") as! SKLightNode
        light?.categoryBitMask = 1
        light?.falloff = 1
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let loc = touch.locationInNode(self)
//            var ringmaker = Ring()
//            ringmaker.drawRect(CGRect())
            createVelocityFieldNode(loc)
            print("created")
        
            
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
    
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
                }
            }
        }
            }
    
    

    override func update(currentTime: CFTimeInterval) {
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
        lGrav.strength = -1
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
        vField.strength = 0.1
        vField.falloff = 6
        //vField.region = SKRegion(size: frame.size)
        addChild(vField)
        
        /* Create the arrow that signifies the direction and magnitude of the force */
        let velocityArrow = SKSpriteNode(imageNamed: "VelocityArrow")
        var theta = atan(nextVector.dy/nextVector.dx)
        if (nextVector.dx < 0 && nextVector.dy > 0) {
            theta = theta + CGFloat(pi)
        }
        if (nextVector.dx < 0 && nextVector.dy < 0) {
            theta = theta - CGFloat(pi)
        }
        print(theta * 180/3.14)
        let rotate = SKAction.rotateToAngle(theta, duration: 0.01)
        addChild(velocityArrow)
        velocityArrow.zPosition = -2
        velocityArrow.position = point
        velocityArrow.size = CGSizeMake(50, 50)
        velocityArrow.alpha = 0.2
        velocityArrow.runAction(rotate)
        vField.region = SKRegion(radius: Float(velocityArrow.size.height))
    }
}
