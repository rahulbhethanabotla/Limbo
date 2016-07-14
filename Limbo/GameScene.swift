//
//  GameScene.swift
//  Playing With Effects
//
//  Created by Rahul Bhethanabotla on 7/12/16.
//  Copyright (c) 2016 Rahul Bhethanabotla. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    
    var square: SKSpriteNode!
    
    var light: SKLightNode!
    
    var blackSun: SKSpriteNode!
    
    var sunAtApex = false
    
    override func didMoveToView(view: SKView) {
        background = self.childNodeWithName("background") as! SKSpriteNode
        background.size = self.size
        background.zPosition = -5
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        
        
        square = self.childNodeWithName("square") as! SKSpriteNode
        square.position = CGPointMake(250, 90)
        square.setScale(0.05)
        square.zPosition = 3
        
        //        let firefly = SKEmitterNode(fileNamed: "ParticleLightDragTest")
        //        firefly?.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        //        firefly?.zPosition = 3
        
        
        blackSun = self.childNodeWithName("blackSun") as! SKSpriteNode
        blackSun.position = CGPointMake(0, 0)
        blackSun.zPosition = 3
        
        light = self.childNodeWithName("//light") as! SKLightNode //childNodeWithName("light") as! SKLightNode
        light?.categoryBitMask = 1
        light?.falloff = 1
        light?.ambientColor = UIColor.whiteColor()
        light?.lightColor = UIColor.cyanColor()
        light?.shadowColor = UIColor.blackColor()
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let loc = touch.locationInNode(self)
            self.childNodeWithName("blackSun")?.position = CGPointMake(loc.x, loc.y)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (abs(blackSun.position.y - 320) <= 0.1) {
            sunAtApex = true
        }
        
        if (sunAtApex == false){
            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y + (320/284))
            print("x = \(blackSun.position.x)")
            print("y = \(blackSun.position.y)")
        }
        else {
            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y - (320/284))
        }
    }
    
//    func createRadialGravityNode() {
//        var rGrav = SKFieldNode.radialGravityField()
//        rGrav.enabled = true
//        rGrav.position = CGPointMake(size.width/2, size.height/2)
//        rGrav.strength = 0.5
//        rGrav.region = SKRegion(size: frame.size)
//        addChild(rGrav)
//        
//    }
}
