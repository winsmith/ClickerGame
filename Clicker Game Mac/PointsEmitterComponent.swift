//
//  PointsEmitterComponent.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import Cocoa
import GameplayKit

class PointsEmitterComponent: GKComponent {
    let pointsPerSecond: Double
    let receiver: PointsReceiverComponent
    
    required init(receiver: PointsReceiverComponent, pointsPerSecond: Double = 0.1) {
        self.receiver = receiver
        self.pointsPerSecond = pointsPerSecond
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let pointsToEmit = pointsPerSecond * seconds
        receiver.receive(points: pointsToEmit)
    }
}
