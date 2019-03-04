//
//  PointsReceiverComponent.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import GameplayKit

class PointsReceiverComponent: GKComponent {
    private(set) var points: Double = 1.0
    
    func receive(points: Double) {
        self.points += points
    }
    
    func pay(points: Double) {
        self.points -= points
    }
}
