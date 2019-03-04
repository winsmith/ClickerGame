//
//  GeometricComponent.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import Cocoa
import GameplayKit

class GeometricComponent: GKComponent {
    let node: SKNode
    let pointsEmitterComponent: PointsEmitterComponent?
    
    required init(node: SKNode, pointsEmitter pointsEmitterComponent: PointsEmitterComponent? = nil) {
        self.node = node
        self.pointsEmitterComponent = pointsEmitterComponent
        
        super.init()
        
        if let pointsEmitterComponent = self.pointsEmitterComponent {
            let actionLength = max(0, ((1 / pointsEmitterComponent.pointsPerSecond) - 0.2))
            
            node.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.wait(forDuration: actionLength),
                SKAction.applyForce(CGVector(dx: 0, dy: node.frame.width), duration: 0.1),
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1),
            ])))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
