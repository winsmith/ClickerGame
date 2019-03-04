//
//  PointsReceiverComponent.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import Cocoa
import GameplayKit

class PointsReceiverComponent: GKComponent {
    private(set) var points: Double = 0.0
    
    func receive(points: Double) {
        self.points += points
    }
}
