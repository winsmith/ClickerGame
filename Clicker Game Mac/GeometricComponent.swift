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
    
    required init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
