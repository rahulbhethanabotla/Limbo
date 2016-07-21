//
//  SettingsScene.swift
//  Limbo
//
//  Created by Rahul Bhethanabotla on 7/20/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    
    /* UI Connections */
    var onToggle: MSToggleNode!
    var offToggle: MSToggleNode!
    
    
    override func didMoveToView(view: SKView) {
        onToggle = self.childNodeWithName("onToggle") as! MSToggleNode
        offToggle = self.childNodeWithName("offToggle") as! MSToggleNode
    }
}
